#!/usr/bin/env bash
# Guards meant to be sourced by build.sh and review.sh.

check_reviewer() {
  local mode="$1" writer="$2" model="$3"
  local allowed="" msg
  msg="owner decision 2026-10-10: included Cursor models; reviewer is never the writer's family"

  if [[ "$mode" == "plan" ]]; then
    case "$writer" in
      claude) allowed="cursor-grok-4.6-xhigh" ;;
      grok) allowed="composer-2.5" ;;
      *)
        echo "plan review writer must be claude or grok ($msg), got: $writer" >&2
        return 2
        ;;
    esac
  elif [[ "$mode" == "diff" ]]; then
    case "$writer" in
      composer) allowed="cursor-grok-4.6-xhigh" ;;
      grok) allowed="composer-2.5" ;;
      *)
        echo "diff writer must be composer or grok ($msg), got: $writer" >&2
        return 2
        ;;
    esac
  else
    echo "unknown review mode: $mode" >&2
    return 2
  fi

  if [[ "$model" == "$allowed" ]]; then
    return 0
  fi
  echo "review model must be $allowed ($msg), got: $model" >&2
  return 2
}

check_name() {
  local name="$1"
  if [[ "$name" =~ ^[a-z0-9][a-z0-9-]{1,40}$ ]]; then
    return 0
  fi
  echo "name must match ^[a-z0-9][a-z0-9-]{1,40}$, got: $name" >&2
  return 2
}

check_draft_model() {
  local model="$1"
  local allowed="cursor-grok-4.6-high"
  if [[ "$model" == "$allowed" ]]; then
    return 0
  fi
  echo "draft model must be $allowed (owner decision 2026-10-10: included Cursor models), got: $model" >&2
  return 2
}
