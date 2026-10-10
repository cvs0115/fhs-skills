#!/usr/bin/env bash
# verdict <review.md>: print APPROVE, APPROVE AFTER FIXES, REJECT, or NONE.
# Meant to be sourced. When run directly, prints the verdict for the given file.

verdict() {
  local file="$1" line="" seen=0 content=""
  if [[ ! -f "$file" ]]; then
    echo NONE
    return 0
  fi
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ $seen -eq 0 ]]; then
      local mark="$line"
      mark="${mark%"${mark##*[![:space:]]}"}"
      if [[ "$mark" == "## Verdict" ]]; then
        seen=1
      fi
      continue
    fi
    content="$line"
    while [[ "$content" == [[:space:]]* || "$content" == \** ]]; do
      if [[ "$content" == [[:space:]]* ]]; then
        content="${content#"${content%%[![:space:]]*}"}"
      else
        content="${content#\*}"
      fi
    done
    [[ -z "$content" ]] && continue
    if [[ "$content" == "APPROVE AFTER FIXES"* ]]; then
      echo "APPROVE AFTER FIXES"
    elif [[ "$content" == REJECT* ]]; then
      echo REJECT
    elif [[ "$content" == APPROVE* ]]; then
      echo APPROVE
    else
      echo NONE
    fi
    return 0
  done < "$file"
  echo NONE
  return 0
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  [[ $# -ge 1 ]] || { echo "usage: verdict.sh <file>" >&2; exit 2; }
  verdict "$1"
fi
