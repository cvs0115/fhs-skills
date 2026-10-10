#!/usr/bin/env bash
# Guards meant to be sourced by build.sh and review.sh.

check_review_model() {
  local model="$1"
  if [[ "$model" == "gpt-5.6-sol-high" ]]; then
    return 0
  fi
  echo "review model must be gpt-5.6-sol-high (owner decision 2026-10-10), got: $model" >&2
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
