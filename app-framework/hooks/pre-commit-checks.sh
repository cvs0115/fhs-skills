#!/usr/bin/env bash
# EXAMPLE hook - adapt the commands to your stack before use.
#
# Runs the secret scan, the REAL type-check and the FULL test suite before a commit.
# Two ways to use it:
#   1. Claude Code PreToolUse hook on Bash (see .claude/settings.example.json). It reads the tool
#      call from stdin and acts only when the command is a 'git commit'.
#   2. Plain git hook: echo 'exec bash hooks/pre-commit-checks.sh --git' > .git/hooks/pre-commit
#      (in worktrees, set core.hooksPath instead so every worktree shares it).
#
# Stack detection: STACK=node | dotnet | custom (default: auto-detect).
# Override any command with TYPECHECK_CMD / TEST_CMD env vars, or edit the defaults below.
#
# Type-check warning: use the command your real build uses and make sure it checks files.
#   Node/TypeScript: in a solution-style tsconfig (empty "files" + "references"), 'tsc --noEmit'
#   checks ZERO files and always passes. Use 'tsc -b' (build mode) via an npm script.
#   .NET: 'dotnet build' compiles every project in the solution; treat warnings as your team decides.

set -u

GIT_MODE=0
[ "${1:-}" = "--git" ] && GIT_MODE=1

fail() {
  echo "pre-commit-checks: $1" >&2
  if [ "$GIT_MODE" = 1 ]; then exit 1; else exit 2; fi
}

if [ "$GIT_MODE" = 0 ]; then
  input="$(cat)"
  if command -v jq >/dev/null 2>&1; then
    cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
  else
    cmd="$(printf '%s' "$input" | sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | head -n 1)"
  fi
  printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+commit' || exit 0
fi

root="$(git rev-parse --show-toplevel 2>/dev/null)" || fail "not inside a git repository"
cd "$root" || fail "cannot cd to $root"

STACK="${STACK:-auto}"
if [ "$STACK" = "auto" ]; then
  if [ -f package.json ]; then
    STACK=node
  elif ls ./*.sln ./*.slnx ./*.csproj >/dev/null 2>&1; then
    STACK=dotnet
  else
    STACK=custom
  fi
fi

case "$STACK" in
  node)
    # package.json should define: "typecheck": "tsc -b" (or your build's real check), "test": "..."
    TYPECHECK_CMD="${TYPECHECK_CMD:-npm run -s typecheck}"
    TEST_CMD="${TEST_CMD:-npm test --silent}"
    ;;
  dotnet)
    TYPECHECK_CMD="${TYPECHECK_CMD:-dotnet build --nologo -v quiet}"
    TEST_CMD="${TEST_CMD:-dotnet test --nologo -v quiet --no-build}"
    ;;
  custom)
    TYPECHECK_CMD="${TYPECHECK_CMD:-}"
    TEST_CMD="${TEST_CMD:-}"
    [ -z "$TYPECHECK_CMD$TEST_CMD" ] && fail "set STACK, or TYPECHECK_CMD and TEST_CMD, for this repo"
    ;;
  *)
    fail "unknown STACK '$STACK'"
    ;;
esac

# 1. Secret scan on what is being committed.
bash "$root/hooks/secret-scan.sh" --staged || fail "secret scan found problems (see above). Remove them; never commit secrets."

# 2. Conflict markers in staged files.
if git diff --cached -U0 | grep -Eq '^\+(<<<<<<<|>>>>>>>)( |$)'; then
  fail "conflict markers in staged changes"
fi

# 3. Real type-check.
if [ -n "$TYPECHECK_CMD" ]; then
  echo "pre-commit-checks: $TYPECHECK_CMD" >&2
  sh -c "$TYPECHECK_CMD" >&2 || fail "type-check failed"
fi

# 4. Full test suite.
if [ -n "$TEST_CMD" ]; then
  echo "pre-commit-checks: $TEST_CMD" >&2
  sh -c "$TEST_CMD" >&2 || fail "tests failed"
fi

exit 0
