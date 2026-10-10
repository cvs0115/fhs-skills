#!/usr/bin/env bash
# EXAMPLE hook - adapt per app before use.
#
# Claude Code PreToolUse hook for the Bash tool (wired in .claude/settings.example.json).
# - DENY:  force pushes, pushes to main/master, commits that skip hooks.
# - ASK:   destructive shell commands (recursive deletes, hard resets, branch deletes, schema drops,
#          platform deploy/delete commands you list in EXTRA_ASK_PATTERN).
#
# Why a hook as well as permission rules: CLAUDE.md only advises, and Bash permission patterns are
# easy to slip past (different flag order, chained commands). This script sees the whole command.
# It is still not a security boundary; use the sandbox for OS-level enforcement.
#
# main moves only at release time, after the user's OK. The user runs that push themselves (or
# approves it outside the agent). Agents never push main.
#
# Runs under bash (Git Bash on Windows). Uses jq if present, otherwise a sed fallback.

set -u

# Add your platform CLI's outward-facing verbs here, e.g. '(mycli (deploy|upload|delete|uninstall))'
EXTRA_ASK_PATTERN="${EXTRA_ASK_PATTERN:-}"

input="$(cat)"

if command -v jq >/dev/null 2>&1; then
  cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
else
  cmd="$(printf '%s' "$input" | sed -nE 's/.*"command"[[:space:]]*:[[:space:]]*"(([^"\\]|\\.)*)".*/\1/p' | head -n 1)"
fi

[ -z "$cmd" ] && exit 0

deny() {
  echo "Blocked by hooks/pre-bash-guard.sh: $1" >&2
  exit 2
}

ask() {
  # JSON on stdout with exit 0 asks the user to confirm this one call.
  local reason="$1"
  reason="${reason//\"/\'}"
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"%s"}}\n' "$reason"
  exit 0
}

# --- Deny rules -----------------------------------------------------------------------------------

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push([[:space:]].*)?[[:space:]](--force|--force-with-lease|-f)([[:space:]=]|$)'; then
  deny "force push is never allowed. Fast-forward only."
fi

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push([[:space:]].*)?[[:space:]]\+[^[:space:]]'; then
  deny "a +refspec is a force push. Fast-forward only."
fi

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push([[:space:]].*)?[[:space:]:](main|master)([[:space:]]|$)'; then
  deny "agents never push main. main moves only after a verified deploy and the user's OK; the user runs that push."
fi

# A bare 'git push' while main is checked out also pushes main.
if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push[[:space:]]*($|[;&|])'; then
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
  if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
    deny "bare 'git push' on $branch would push main."
  fi
fi

if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+commit([[:space:]].*)?[[:space:]](--no-verify)([[:space:]]|$)'; then
  deny "commits must run the hooks (type-check, tests, secret scan). Fix the failure instead."
fi

# --- Ask rules ------------------------------------------------------------------------------------

ASK_PATTERN='(rm[[:space:]]+-[a-zA-Z]*[rR])|(git[[:space:]]+reset[[:space:]]+--hard)|(git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f)|(git[[:space:]]+branch[[:space:]]+-D)|(git[[:space:]]+checkout[[:space:]]+--[[:space:]])|(git[[:space:]]+restore[[:space:]])|(git[[:space:]]+stash[[:space:]]+(drop|clear))|(git[[:space:]]+worktree[[:space:]]+remove)|(Remove-Item.*-Recurse)|(rmdir[[:space:]]+/s)|(del[[:space:]]+/[sq])|([Dd][Rr][Oo][Pp][[:space:]]+([Tt][Aa][Bb][Ll][Ee]|[Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee]|[Ss][Cc][Hh][Ee][Mm][Aa]))|([Tt][Rr][Uu][Nn][Cc][Aa][Tt][Ee][[:space:]]+[Tt][Aa][Bb][Ll][Ee])'

if printf '%s' "$cmd" | grep -Eq "$ASK_PATTERN"; then
  ask "Destructive command. Confirm the blast radius before it runs: $cmd"
fi

if [ -n "$EXTRA_ASK_PATTERN" ] && printf '%s' "$cmd" | grep -Eq "$EXTRA_ASK_PATTERN"; then
  ask "Outward-facing platform command (deploy/upload/delete). Needs your explicit OK: $cmd"
fi

exit 0
