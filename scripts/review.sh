#!/usr/bin/env bash
# Cross-model review: cursor-agent, read-only (plan mode), on included Cursor models.
#   scripts/review.sh docs/plans/<slug>-<nn>.md      review a plan
#   scripts/review.sh --diff feat/<name>             review a branch's diff against main
#   scripts/review.sh --check-only ...               validate args and model, print OK
# Writes docs/reviews/<name>.md and prints the verdict. REVIEW_MODEL overrides the model.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/guards.sh
source "$SCRIPT_DIR/lib/guards.sh"
# shellcheck source=lib/verdict.sh
source "$SCRIPT_DIR/lib/verdict.sh"

REPO="${FHS_REPO:-/root/fhs-skills}"
REPO="${REPO%/}"
FHS_BUILD_ROOT="${FHS_BUILD_ROOT:-/srv/fhs-build}"
FHS_BUILD_ROOT="${FHS_BUILD_ROOT%/}"

usage() {
  echo "usage: review.sh [--check-only] [--writer composer|grok] <plan.md> | --diff <branch>" >&2
}

CHECK_ONLY=0
DIFF=0
BRANCH=""
PLAN=""
WRITER="composer"
WRITER_SET=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check-only) CHECK_ONLY=1; shift ;;
    --writer)
      [[ $# -ge 2 ]] || { usage; exit 2; }
      WRITER="$2"
      WRITER_SET=1
      shift 2
      ;;
    --diff)
      [[ $# -ge 2 ]] || { usage; exit 2; }
      DIFF=1
      BRANCH="$2"
      shift 2
      ;;
    --*) usage; exit 2 ;;
    *)
      [[ -z "$PLAN" ]] || { usage; exit 2; }
      PLAN="$1"
      shift
      ;;
  esac
done

if [[ $DIFF -eq 1 && -n "$PLAN" ]]; then
  usage
  exit 2
fi

if [[ $DIFF -eq 0 && $WRITER_SET -eq 1 ]]; then
  usage
  exit 2
fi

if [[ $DIFF -eq 1 ]]; then
  case "$WRITER" in
    composer) MODEL="${REVIEW_MODEL:-cursor-grok-4.6-xhigh}" ;;
    grok) MODEL="${REVIEW_MODEL:-composer-2.5}" ;;
    *) usage; exit 2 ;;
  esac
  check_reviewer diff "$WRITER" "$MODEL" || exit 2
else
  MODEL="${REVIEW_MODEL:-cursor-grok-4.6-xhigh}"
  check_reviewer plan claude "$MODEL" || exit 2
fi

cleanup_diff() {
  if [[ "${CREATED:-0}" -eq 1 && -n "${WT:-}" ]]; then
    git -C "$REPO" worktree remove --force "$WT" >/dev/null 2>&1 || true
    if [[ -d "${WT:-}" ]]; then
      rm -rf "$WT" || true
    fi
    git -C "$REPO" worktree prune >/dev/null 2>&1 || true
  fi
  if [[ -n "${OUT_TMP:-}" ]]; then
    rm -f "$OUT_TMP" || true
  fi
}

TODAY="$(date +%F)"

writer_line() {
  case "$1" in
    claude) echo "The writer is Claude (Anthropic). You are $MODEL, a different model family." ;;
    composer) echo "The writer is Composer (Cursor). You are $MODEL, a different model family." ;;
    grok) echo "The writer is Grok (xAI via Cursor). You are $MODEL, a different model family." ;;
  esac
}

if [[ $DIFF -eq 1 ]]; then
  [[ -n "$BRANCH" ]] || { usage; exit 2; }
  git -C "$REPO" rev-parse --verify -q "$BRANCH" >/dev/null || { echo "No branch $BRANCH" >&2; exit 2; }
  short="${BRANCH#feat/}"
  short="$(basename "$short")"
  if [[ $CHECK_ONLY -eq 1 ]]; then
    echo OK
    exit 0
  fi
  BUILD_REPORT="$FHS_BUILD_ROOT/reports/${short}.md"
  TEST_REPORT="$FHS_BUILD_ROOT/reports/${short}-test.md"
  missing=0
  if [[ ! -f "$BUILD_REPORT" ]]; then
    echo "missing builder report: $BUILD_REPORT" >&2
    missing=1
  fi
  if [[ ! -f "$TEST_REPORT" ]]; then
    echo "missing tester report: $TEST_REPORT" >&2
    missing=1
  fi
  if [[ $missing -ne 0 ]]; then
    exit 3
  fi
  parent="$(cd "$REPO/.." && pwd)"
  WT="$parent/fhs-skills-wt/review-$short"
  NAME="${short}-diff"
  OUT="$REPO/docs/reviews/$NAME.md"
  OUT_TMP="$OUT.tmp"
  CREATED=0
  wt_porcelain="$(git -C "$REPO" worktree list --porcelain)"
  if [[ -e "$WT" ]] || printf '%s\n' "$wt_porcelain" | grep -qxF "worktree $WT"; then
    echo "review worktree path already exists: $WT" >&2
    exit 4
  fi
  trap cleanup_diff EXIT
  mkdir -p "$(dirname "$WT")" "$(dirname "$OUT")"
  git -C "$REPO" worktree add --detach "$WT" "$BRANCH"
  CREATED=1
  SUBJECT="the diff of branch $BRANCH against main. Run: git diff main...$BRANCH  (and git log main..$BRANCH). Compare against main and against the plan and task file if the branch names them. Check the reported test results against the diff. Builder report: $BUILD_REPORT. Tester report: $TEST_REPORT."
  WL="$(writer_line "$WRITER")"
  read -r -d '' PROMPT <<EOF || true
You are the Reviewer for the fhs-skills repo (Claude skills for a Firehouse Subs owner's back office).
$WL You have no access to the writer's conversation.

Read first: CLAUDE.md (the rules), skills/fhs-skills/SKILL.md "Rules", docs/templates/review.md (your output form),
and any spec in docs/specs/ that the subject names.
Subject: $SUBJECT

Read only. Edit nothing, create nothing, run nothing that changes files or git state.
Return ONLY the filled review form as markdown, starting with "# Review · $NAME", date $TODAY, reviewer model $MODEL.
Verdict is exactly one of: APPROVE · APPROVE AFTER FIXES · REJECT.
Majors include: a missing or wrong served tree; a contradiction with CLAUDE.md, an owner rule or a logged decision;
a live Toast/R365/ADP change not listed; a done-check that does not use real data; editing files the plan does not name.
Do not invent scope: extra ideas are not majors. Close gaps yourself; gaps are findings, not questions for the owner.
EOF
  cursor-agent -p --mode plan --trust --model "$MODEL" --workspace "$WT" --output-format text "$PROMPT" > "$OUT_TMP"
  mv "$OUT_TMP" "$OUT"
  echo "Review written: ${OUT#"$REPO/"}"
  verdict "$OUT"
else
  [[ -n "$PLAN" ]] || { usage; exit 2; }
  if [[ -f "$REPO/$PLAN" ]]; then
    PLAN="$(realpath --relative-to="$REPO" "$REPO/$PLAN")"
  elif [[ -f "$PLAN" ]]; then
    PLAN="$(realpath --relative-to="$REPO" "$PLAN")"
  else
    echo "No plan file $PLAN" >&2
    exit 2
  fi
  NAME="$(basename "$PLAN" .md)"
  if [[ -f "$REPO/docs/prompts/$NAME.md" ]]; then
    SUBJECT="the plan file $PLAN and the task file docs/prompts/$NAME.md"
    READ_TASK="docs/prompts/$NAME.md, "
  else
    SUBJECT="the plan file $PLAN"
    READ_TASK=""
  fi
  if [[ $CHECK_ONLY -eq 1 ]]; then
    echo OK
    exit 0
  fi
  OUT="$REPO/docs/reviews/$NAME.md"
  OUT_TMP="$OUT.tmp"
  WL="$(writer_line claude)"
  read -r -d '' PROMPT <<EOF || true
You are the Reviewer for the fhs-skills repo (Claude skills for a Firehouse Subs owner's back office).
$WL You have no access to the writer's conversation.

Read first: CLAUDE.md (the rules), skills/fhs-skills/SKILL.md "Rules", docs/templates/review.md (your output form),
${READ_TASK}and any spec in docs/specs/ that the subject names.
Subject: $SUBJECT

Read only. Edit nothing, create nothing, run nothing that changes files or git state.
Return ONLY the filled review form as markdown, starting with "# Review · $NAME", date $TODAY, reviewer model $MODEL.
Verdict is exactly one of: APPROVE · APPROVE AFTER FIXES · REJECT.
Majors include: a missing or wrong served tree; a contradiction with CLAUDE.md, an owner rule or a logged decision;
a live Toast/R365/ADP change not listed; a done-check that does not use real data; editing files the plan does not name.
Do not invent scope: extra ideas are not majors. Close gaps yourself; gaps are findings, not questions for the owner.
EOF
  cd "$REPO"
  cursor-agent -p --mode plan --trust --model "$MODEL" --output-format text "$PROMPT" > "$OUT_TMP"
  mv "$OUT_TMP" "$OUT"
  echo "Review written: ${OUT#"$REPO/"}"
  verdict "$OUT"
fi
