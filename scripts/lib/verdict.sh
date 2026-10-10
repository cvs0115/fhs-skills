#!/usr/bin/env bash
# verdict <review.md>: print APPROVE, APPROVE AFTER FIXES, REJECT, or NONE.
# First "## Verdict" wins. On the first non-empty line after it: strip leading
# spaces, then one leading "**" if present. The result must be an exact token,
# optional closing "**", then "." or end of line. Anything else is NONE.
# Meant to be sourced. When run directly, prints the verdict for the given file.

verdict() {
  local file="$1" line="" seen=0 content="" token="" rest=""
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
    content="${content#"${content%%[![:space:]]*}"}"
    [[ -z "$content" ]] && continue
    if [[ "${content:0:2}" == "**" ]]; then
      content="${content:2}"
    fi
    for token in "APPROVE AFTER FIXES" "REJECT" "APPROVE"; do
      if [[ "$content" == "$token"* ]]; then
        rest="${content#"$token"}"
        if [[ "${rest:0:2}" == "**" ]]; then
          rest="${rest:2}"
        fi
        if [[ -z "$rest" || "${rest:0:1}" == "." ]]; then
          echo "$token"
          return 0
        fi
      fi
    done
    echo NONE
    return 0
  done < "$file"
  echo NONE
  return 0
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  [[ $# -ge 1 ]] || { echo "usage: verdict.sh <file>" >&2; exit 2; }
  verdict "$1"
fi
