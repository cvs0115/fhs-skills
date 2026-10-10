#!/usr/bin/env bash
# Framework guards, verdict parser, build.sh and review.sh. No /root and no /srv/fhs-build.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
FIX="$ROOT/scripts/tests/fixtures"

FAILS=0
pass() { echo "PASS $1"; }
fail() { echo "FAIL $1: $2"; FAILS=$((FAILS + 1)); }

# --- 1. verdict -----------------------------------------------------------
# shellcheck source=../lib/verdict.sh
source "$ROOT/scripts/lib/verdict.sh"

check_verdict() {
  local file="$1" want="$2" name="$3" got
  got="$(verdict "$file")"
  if [[ "$got" == "$want" ]]; then
    pass "$name"
  else
    fail "$name" "got '$got', want '$want'"
  fi
}

check_verdict "$FIX/review-approve.md" "APPROVE" "verdict-approve"
check_verdict "$FIX/review-approve-after-fixes.md" "APPROVE AFTER FIXES" "verdict-approve-after-fixes"
check_verdict "$FIX/review-reject.md" "REJECT" "verdict-reject"
check_verdict "$FIX/review-none.md" "NONE" "verdict-none"
check_verdict "$FIX/review-bold.md" "APPROVE AFTER FIXES" "verdict-bold"
check_verdict "$ROOT/scripts/tests/fixtures/does-not-exist.md" "NONE" "verdict-missing"

# --- throwaway repo -------------------------------------------------------
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
FHS_REPO="$TMP/repo"
FHS_BUILD_ROOT="$TMP/build"
export FHS_REPO FHS_BUILD_ROOT
unset REVIEW_MODEL || true
mkdir -p "$FHS_REPO" "$FHS_BUILD_ROOT"
export GIT_TERMINAL_PROMPT=0
git -C "$FHS_REPO" init -b main >/dev/null
git -C "$FHS_REPO" config user.email "builder-test@example.com"
git -C "$FHS_REPO" config user.name "Builder Test"
git -C "$FHS_REPO" config commit.gpgsign false
echo init > "$FHS_REPO/README"
git -C "$FHS_REPO" add README
git -C "$FHS_REPO" commit -m "init" >/dev/null

set_docs() {
  local mode="$1"
  mkdir -p "$FHS_REPO/docs/plans" "$FHS_REPO/docs/prompts" "$FHS_REPO/docs/tests" "$FHS_REPO/docs/reviews"
  printf '# Plan zz-01\n' > "$FHS_REPO/docs/plans/zz-01.md"
  printf '# Prompt zz-01\n' > "$FHS_REPO/docs/prompts/zz-01.md"
  printf '# Tests zz-01\n' > "$FHS_REPO/docs/tests/zz-01.md"
  rm -f "$FHS_REPO/docs/reviews/zz-01.md"
  case "$mode" in
    approve) cp "$FIX/review-approve.md" "$FHS_REPO/docs/reviews/zz-01.md" ;;
    after) cp "$FIX/review-approve-after-fixes.md" "$FHS_REPO/docs/reviews/zz-01.md" ;;
    reject) cp "$FIX/review-reject.md" "$FHS_REPO/docs/reviews/zz-01.md" ;;
    noreview) ;;
    notask)
      cp "$FIX/review-approve.md" "$FHS_REPO/docs/reviews/zz-01.md"
      rm -f "$FHS_REPO/docs/prompts/zz-01.md"
      ;;
    notest)
      cp "$FIX/review-approve.md" "$FHS_REPO/docs/reviews/zz-01.md"
      rm -f "$FHS_REPO/docs/tests/zz-01.md"
      ;;
    *) echo "bad mode $mode" >&2; exit 1 ;;
  esac
  git -C "$FHS_REPO" add -A
  git -C "$FHS_REPO" commit -m "docs $mode" >/dev/null
}

LAST_OUT=""
expect_exit() {
  local want="$1" name="$2"
  shift 2
  local ec
  LAST_OUT="$("$@" 2>&1)"
  ec=$?
  if [[ $ec -eq $want ]]; then
    pass "$name"
  else
    fail "$name" "exit $ec, want $want; output: ${LAST_OUT//$'\n'/ | }"
  fi
}

set_docs approve

expect_exit 0 prepare-approve bash scripts/build.sh prepare docs/plans/zz-01.md aa --check-only
if [[ "$LAST_OUT" != "OK: ready to prepare aa from main" ]]; then
  fail "prepare-approve-message" "output: ${LAST_OUT//$'\n'/ | }"
fi

set_docs after
expect_exit 3 prepare-after-fixes bash scripts/build.sh prepare docs/plans/zz-01.md aa --check-only

set_docs reject
expect_exit 3 prepare-reject bash scripts/build.sh prepare docs/plans/zz-01.md aa --check-only

set_docs noreview
expect_exit 3 prepare-no-review bash scripts/build.sh prepare docs/plans/zz-01.md aa --check-only

set_docs notask
expect_exit 3 prepare-no-task bash scripts/build.sh prepare docs/plans/zz-01.md aa --check-only

set_docs notest
expect_exit 3 prepare-no-test bash scripts/build.sh prepare docs/plans/zz-01.md aa --check-only

set_docs approve
expect_exit 2 prepare-bad-name bash scripts/build.sh prepare docs/plans/zz-01.md Bad_Name --check-only

git -C "$FHS_REPO" branch feat/zz
expect_exit 4 prepare-existing-branch bash scripts/build.sh prepare docs/plans/zz-01.md zz --check-only

git -C "$FHS_REPO" branch side
git -C "$FHS_REPO" rm -f docs/plans/zz-01.md docs/prompts/zz-01.md docs/tests/zz-01.md docs/reviews/zz-01.md >/dev/null
git -C "$FHS_REPO" commit -m "drop zz-01 on main" >/dev/null

expect_exit 0 prepare-base-side bash scripts/build.sh prepare docs/plans/zz-01.md zz-side --base side --check-only
if [[ "$LAST_OUT" != "OK: ready to prepare zz-side from side" ]]; then
  fail "prepare-base-side-message" "output: ${LAST_OUT//$'\n'/ | }"
fi
expect_exit 3 prepare-base-main-missing bash scripts/build.sh prepare docs/plans/zz-01.md zz-side --check-only

git -C "$FHS_REPO" checkout side -- docs/plans/zz-01.md docs/prompts/zz-01.md docs/tests/zz-01.md docs/reviews/zz-01.md
git -C "$FHS_REPO" commit -m "restore zz-01 on main" >/dev/null

# --- 3. prepare as non-root ----------------------------------------------
expect_exit 5 prepare-not-root bash scripts/build.sh prepare docs/plans/zz-01.md zzroot
if [[ -e "$FHS_BUILD_ROOT/zzroot" ]]; then
  fail "prepare-not-root-nodir" "directory was created"
elif [[ "$LAST_OUT" == *Cloning* ]]; then
  fail "prepare-not-root-noclone" "clone started"
fi

# --- 4. collect with no report -------------------------------------------
expect_exit 3 collect-no-report bash scripts/build.sh collect zz

# --- 5. review.sh ---------------------------------------------------------
expect_exit 2 review-model-grok env REVIEW_MODEL=grok-4.7-high bash scripts/review.sh --check-only docs/plans/zz-01.md
expect_exit 2 review-model-claude env REVIEW_MODEL=claude-x bash scripts/review.sh --check-only docs/plans/zz-01.md
expect_exit 0 review-model-default env -u REVIEW_MODEL bash scripts/review.sh --check-only docs/plans/zz-01.md
if [[ "$LAST_OUT" != "OK" ]]; then
  fail "review-model-default-message" "output: ${LAST_OUT//$'\n'/ | }"
fi

parent="$(cd "$FHS_REPO/.." && pwd)"
wt="$parent/fhs-skills-wt/review-zz"
expect_exit 3 review-diff-no-reports env -u REVIEW_MODEL bash scripts/review.sh --diff feat/zz
if [[ -e "$wt" ]]; then
  fail "review-diff-no-worktree" "worktree exists at $wt"
elif git -C "$FHS_REPO" worktree list | grep -q 'review-'; then
  fail "review-diff-no-worktree" "git worktree list shows review-"
elif compgen -G "$FHS_REPO/docs/reviews/*.tmp" > /dev/null; then
  fail "review-diff-no-tmp" "tmp review left behind"
fi

# --- 6. bash -n -----------------------------------------------------------
bn="$(bash -n scripts/build.sh scripts/review.sh scripts/lib/verdict.sh scripts/lib/guards.sh 2>&1)"
ec=$?
if [[ $ec -eq 0 && -z "$bn" ]]; then
  pass "bash-n"
else
  fail "bash-n" "exit $ec; output: ${bn//$'\n'/ | }"
fi

if [[ $FAILS -ne 0 ]]; then
  exit 1
fi
exit 0
