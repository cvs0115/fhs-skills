#!/usr/bin/env bash
# Draft plan, task file, and test plan from a brief via cursor-grok (read-only ask mode).
#   scripts/draft.sh [--check-only] <name>
#   scripts/draft.sh [--check-only] --fix <name>
# DRAFT_MODEL may override only with cursor-grok-4.6-high.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/guards.sh
source "$SCRIPT_DIR/lib/guards.sh"
# shellcheck source=lib/verdict.sh
source "$SCRIPT_DIR/lib/verdict.sh"

REPO="${FHS_REPO:-/root/fhs-skills}"
REPO="${REPO%/}"

usage() {
  echo "usage: draft.sh [--check-only] <name> | draft.sh [--check-only] --fix <name>" >&2
}

CHECK_ONLY=0
FIX=0
NAME=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check-only) CHECK_ONLY=1; shift ;;
    --fix) FIX=1; shift ;;
    --*) usage; exit 2 ;;
    *)
      [[ -z "$NAME" ]] || { usage; exit 2; }
      NAME="$1"
      shift
      ;;
  esac
done

[[ -n "$NAME" ]] || { usage; exit 2; }
check_name "$NAME" || exit 2

MODEL="${DRAFT_MODEL:-cursor-grok-4.6-high}"
check_draft_model "$MODEL" || exit 2

plan_is_grok_drafted() {
  local plan_file="$1"
  head -n 10 "$plan_file" | grep -q 'Drafted by Cursor Grok'
}

majors_has_real_bullets() {
  local file="$1" line="" in_majors=0 content=""
  while IFS= read -r line || [[ -n "$line" ]]; do
    local mark="$line"
    mark="${mark%"${mark##*[![:space:]]}"}"
    if [[ $in_majors -eq 0 ]]; then
      [[ "$mark" == "## Majors" ]] && in_majors=1
      continue
    fi
    if [[ "$mark" == "## "* ]]; then
      break
    fi
    content="${line#"${line%%[![:space:]]*}"}"
    [[ -z "$content" ]] && continue
    if [[ "$content" == "- "* ]]; then
      local bullet="${content#- }"
      bullet="${bullet%.}"
      local lower="${bullet,,}"
      if [[ "$lower" != "none" ]]; then
        return 0
      fi
    fi
  done < "$file"
  return 1
}

if [[ $FIX -eq 1 ]]; then
  REVIEW="$REPO/docs/reviews/$NAME.md"
  PLAN="$REPO/docs/plans/$NAME.md"
  PROMPT="$REPO/docs/prompts/$NAME.md"
  TESTS="$REPO/docs/tests/$NAME.md"
  for f in "$REVIEW" "$PLAN" "$PROMPT" "$TESTS"; do
    if [[ ! -f "$f" ]]; then
      echo "missing file for --fix: $f" >&2
      exit 2
    fi
  done
  if ! plan_is_grok_drafted "$PLAN"; then
    echo "CLAUDE: plan has no Drafted by Cursor Grok line; Grok cannot fix a Claude-written plan" >&2
    exit 3
  fi
  v="$(verdict "$REVIEW")"
  if [[ "$v" != "APPROVE AFTER FIXES" ]]; then
    echo "CLAUDE: review verdict is $v, not APPROVE AFTER FIXES" >&2
    exit 3
  fi
  if majors_has_real_bullets "$REVIEW"; then
    echo "CLAUDE: review has majors that must be fixed by Claude" >&2
    exit 3
  fi
  if [[ -f "$REPO/docs/reviews/$NAME-r2.md" ]]; then
    echo "CLAUDE: docs/reviews/$NAME-r2.md exists; this would be round 3" >&2
    exit 3
  fi
  if [[ $CHECK_ONLY -eq 1 ]]; then
    echo OK
    exit 0
  fi
  cd "$REPO"
  run_fix() {
    local target="$1" rel="$2"
    local tmp="${target}.tmp"
    local fix_prompt
    read -r -d '' fix_prompt <<EOF || true
You are drafting for the fhs-skills repo. Follow CLAUDE.md. Apply ONLY the Minors bullets in docs/reviews/$NAME.md.
Change nothing else. Keep the line "Drafted by Cursor Grok" in the plan's first 10 lines when editing the plan.
Return ONLY the file's markdown for $rel.
EOF
    if ! cursor-agent -p --mode ask --trust --model "$MODEL" --output-format text "$fix_prompt" > "$tmp"; then
      rm -f "$tmp"
      exit 1
    fi
    mv "$tmp" "$target"
    local n
    n="$(wc -l < "$target")"
    echo "wrote ${target#"$REPO/"} ($n lines)"
  }
  run_fix "$PLAN" "docs/plans/$NAME.md"
  run_fix "$PROMPT" "docs/prompts/$NAME.md"
  run_fix "$TESTS" "docs/tests/$NAME.md"
  git diff --stat -- docs/plans/"$NAME".md docs/prompts/"$NAME".md docs/tests/"$NAME".md
  exit 0
fi

BRIEF="$REPO/docs/briefs/$NAME.md"
[[ -f "$BRIEF" ]] || { echo "No brief docs/briefs/$NAME.md" >&2; exit 2; }

PLAN="$REPO/docs/plans/$NAME.md"
PROMPT="$REPO/docs/prompts/$NAME.md"
TESTS="$REPO/docs/tests/$NAME.md"
for f in "$PLAN" "$PROMPT" "$TESTS"; do
  if [[ -f "$f" ]]; then
    echo "refusing to draft: $(realpath --relative-to="$REPO" "$f") already exists" >&2
    exit 3
  fi
done

if [[ $CHECK_ONLY -eq 1 ]]; then
  echo OK
  exit 0
fi

cd "$REPO"
run_draft() {
  local target="$1" prompt="$2"
  local tmp="${target}.tmp"
  if ! cursor-agent -p --mode ask --trust --model "$MODEL" --output-format text "$prompt" > "$tmp"; then
    rm -f "$tmp"
    exit 1
  fi
  mv "$tmp" "$target"
  local n
  n="$(wc -l < "$target")"
  echo "wrote ${target#"$REPO/"} ($n lines)"
}

COMMON="Follow CLAUDE.md. Add no scope beyond the brief. Return ONLY the file's markdown."

read -r -d '' PLAN_PROMPT <<EOF || true
$COMMON
Use the form in docs/templates/plan.md.
Brief: docs/briefs/$NAME.md
Put this line within the plan's first 10 lines: Drafted by Cursor Grok 4.6 High from docs/briefs/$NAME.md.
EOF
run_draft "$PLAN" "$PLAN_PROMPT"

read -r -d '' TASK_PROMPT <<EOF || true
$COMMON
Use the form in docs/templates/prompt.md.
Brief: docs/briefs/$NAME.md
Plan: docs/plans/$NAME.md
EOF
run_draft "$PROMPT" "$TASK_PROMPT"

read -r -d '' TEST_PROMPT <<EOF || true
$COMMON
Use the form in docs/templates/test-plan.md.
Brief: docs/briefs/$NAME.md
Plan: docs/plans/$NAME.md
Task file: docs/prompts/$NAME.md
EOF
run_draft "$TESTS" "$TEST_PROMPT"
