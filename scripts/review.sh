#!/usr/bin/env bash
# Cross-model review: cursor-agent, read-only (plan mode), on a non-Claude model.
#   scripts/review.sh docs/plans/<slug>-<nn>.md      review a plan
#   scripts/review.sh --diff feat/<name>             review a branch's diff against main
# Writes docs/reviews/<name>.md and prints the verdict. REVIEW_MODEL overrides the model.
set -euo pipefail

# Runs in the checkout it is called from (a worktree reviews its own branch files).
REPO="$(git rev-parse --show-toplevel)"
MODEL="${REVIEW_MODEL:-gpt-5.6-sol-high}"
case "$MODEL" in claude-*|*sonnet*|*opus*|*fable*|*haiku*)
  echo "REVIEW_MODEL=$MODEL is a Claude model; the reviewer must be a different family." >&2; exit 2;;
esac

if [[ "${1:-}" == "--diff" ]]; then
  BRANCH="${2:?usage: review.sh --diff <branch>}"
  git -C "$REPO" rev-parse --verify -q "$BRANCH" >/dev/null || { echo "No branch $BRANCH" >&2; exit 2; }
  NAME="$(basename "$BRANCH")-diff"
  PLAN_HINT="If docs/plans/ has a plan for this branch, check the diff against it."
  SUBJECT="the diff of branch $BRANCH against main. Run: git diff main...$BRANCH  (and git log main..$BRANCH). $PLAN_HINT"
else
  PLAN="${1:?usage: review.sh <plan.md> | --diff <branch>}"
  [[ -f "$REPO/$PLAN" || -f "$PLAN" ]] || { echo "No plan file $PLAN" >&2; exit 2; }
  PLAN="$(realpath --relative-to="$REPO" "$PLAN" 2>/dev/null || echo "$PLAN")"
  NAME="$(basename "$PLAN" .md)"
  SUBJECT="the plan file $PLAN"
fi

OUT="$REPO/docs/reviews/$NAME.md"
TODAY="$(date +%F)"

read -r -d '' PROMPT <<EOF || true
You are the Reviewer for the fhs-skills repo (Claude skills for a Firehouse Subs owner's back office).
The writer is Claude (Anthropic). You are $MODEL, a different model family. You have no access to the writer's conversation.

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

cd "$REPO"
cursor-agent -p --mode plan --trust --model "$MODEL" --output-format text "$PROMPT" > "$OUT.tmp"
mv "$OUT.tmp" "$OUT"
echo "Review written: ${OUT#$REPO/}"
grep -m1 -oE 'APPROVE AFTER FIXES|APPROVE|REJECT' "$OUT" || echo "WARNING: no verdict found in the review"
