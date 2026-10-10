#!/usr/bin/env bash
# Prepare a builder clone and collect its branch.
#   scripts/build.sh prepare docs/plans/<plan>.md <name> [--base <branch>] [--check-only]
#   scripts/build.sh collect <name>
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/verdict.sh
source "$SCRIPT_DIR/lib/verdict.sh"
# shellcheck source=lib/guards.sh
source "$SCRIPT_DIR/lib/guards.sh"

FHS_REPO="${FHS_REPO:-/root/fhs-skills}"
FHS_BUILD_ROOT="${FHS_BUILD_ROOT:-/srv/fhs-build}"
FHS_REPO="${FHS_REPO%/}"
FHS_BUILD_ROOT="${FHS_BUILD_ROOT%/}"

usage() {
  echo "usage: scripts/build.sh prepare <plan-path> <name> [--base <branch>] [--check-only]" >&2
  echo "       scripts/build.sh collect <name>" >&2
}

cmd_prepare() {
  local plan_path="" name="" base="main" check_only=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --check-only) check_only=1; shift ;;
      --base)
        [[ $# -ge 2 ]] || { usage; exit 2; }
        base="$2"
        shift 2
        ;;
      --*) usage; exit 2 ;;
      *)
        if [[ -z "$plan_path" ]]; then
          plan_path="$1"
        elif [[ -z "$name" ]]; then
          name="$1"
        else
          usage
          exit 2
        fi
        shift
        ;;
    esac
  done
  [[ -n "$plan_path" && -n "$name" ]] || { usage; exit 2; }
  [[ "$plan_path" =~ ^docs/plans/[^/]+\.md$ ]] || {
    echo "plan path must be docs/plans/<plan>.md, got: $plan_path" >&2
    exit 2
  }
  local plan
  plan="$(basename "$plan_path" .md)"
  check_name "$name" || exit 2

  local rel
  for rel in \
    "docs/plans/${plan}.md" \
    "docs/prompts/${plan}.md" \
    "docs/tests/${plan}.md" \
    "docs/reviews/${plan}.md"
  do
    if ! git -C "$FHS_REPO" cat-file -e "${base}:${rel}" 2>/dev/null; then
      echo "missing $rel" >&2
      exit 3
    fi
  done

  local tmp v
  tmp="$(mktemp)"
  if ! git -C "$FHS_REPO" show "${base}:docs/reviews/${plan}.md" > "$tmp"; then
    rm -f "$tmp"
    echo "missing docs/reviews/${plan}.md" >&2
    exit 3
  fi
  v="$(verdict "$tmp")"
  rm -f "$tmp"
  if [[ "$v" != "APPROVE" ]]; then
    echo "$v" >&2
    exit 3
  fi

  if [[ -e "$FHS_BUILD_ROOT/$name" ]]; then
    echo "exists: $FHS_BUILD_ROOT/$name" >&2
    exit 4
  fi
  if git -C "$FHS_REPO" rev-parse --verify -q "feat/$name" >/dev/null 2>&1; then
    echo "branch already exists: feat/$name" >&2
    exit 4
  fi

  if [[ $check_only -eq 1 ]]; then
    echo "OK: ready to prepare $name from $base"
    exit 0
  fi

  if [[ $EUID -ne 0 ]]; then
    echo "prepare must run as root" >&2
    exit 5
  fi

  git clone --no-hardlinks --branch "$base" "$FHS_REPO" "$FHS_BUILD_ROOT/$name"
  mkdir -p "$FHS_BUILD_ROOT/reports"
  chown -R fhsbuild: "$FHS_BUILD_ROOT/$name" "$FHS_BUILD_ROOT/reports"
  echo "Start Grok: sudo -u fhsbuild -H $FHS_BUILD_ROOT/.local/bin/agent --model grok-4.7-high --workspace $FHS_BUILD_ROOT/$name"
  echo "Tell it: Do the task in docs/prompts/${plan}.md"
}

cmd_collect() {
  local name="${1:-}"
  [[ $# -eq 1 && -n "$name" ]] || { usage; exit 2; }
  check_name "$name" || exit 2
  local report="$FHS_BUILD_ROOT/reports/$name.md"
  if [[ ! -f "$report" ]]; then
    echo "missing report: $report" >&2
    exit 3
  fi
  git -C "$FHS_REPO" fetch \
    --upload-pack="git -c safe.directory=$FHS_BUILD_ROOT/$name -c safe.directory=$FHS_BUILD_ROOT/$name/.git upload-pack" \
    "$FHS_BUILD_ROOT/$name" "feat/$name:feat/$name"
  echo "$report"
  echo "Next: scripts/review.sh --diff feat/$name"
}

case "${1:-}" in
  prepare) shift; cmd_prepare "$@" ;;
  collect) shift; cmd_collect "$@" ;;
  *) usage; exit 2 ;;
esac
