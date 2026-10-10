#!/usr/bin/env bash
set -euo pipefail

repo="${FHS_GATE_REPO:-/root/fhs-skills}"
inbox="${FHS_GATE_INBOX:-/root/fhs-skills/inbox}"

cmd="${SSH_ORIGINAL_COMMAND:-}"

refuse() {
  echo refused >&2
  exit 1
}

if [[ -z "$cmd" ]]; then
  refuse
fi

name_re='^[A-Za-z0-9._-]{1,120}$'

if [[ "$cmd" =~ ^git-upload-pack[[:space:]]+\'$repo\'$ ]]; then
  exec git-upload-pack "$repo"
fi

if [[ "$cmd" =~ ^git-upload-pack[[:space:]]+\'$repo/\'$ ]]; then
  exec git-upload-pack "$repo"
fi

if [[ "$cmd" =~ ^git-upload-pack[[:space:]]+$repo$ ]]; then
  exec git-upload-pack "$repo"
fi

if [[ "$cmd" =~ ^git-receive-pack[[:space:]]+\'$repo\'$ ]]; then
  exec git-receive-pack "$repo"
fi

if [[ "$cmd" =~ ^git-receive-pack[[:space:]]+\'$repo/\'$ ]]; then
  exec git-receive-pack "$repo"
fi

if [[ "$cmd" =~ ^git-receive-pack[[:space:]]+$repo$ ]]; then
  exec git-receive-pack "$repo"
fi

if [[ "$cmd" =~ ^scp[[:space:]]+-t[[:space:]]+$inbox/(.+)$ ]]; then
  name="${BASH_REMATCH[1]}"
  if [[ "$name" == "." || "$name" == ".." ]]; then
    refuse
  fi
  if [[ ! "$name" =~ $name_re ]]; then
    refuse
  fi
  exec scp -t "$inbox/$name"
fi

if [[ "$cmd" =~ ^test[[:space:]]+![[:space:]]+-e[[:space:]]+$inbox/(.+)$ ]]; then
  name="${BASH_REMATCH[1]}"
  if [[ "$name" == "." || "$name" == ".." ]]; then
    refuse
  fi
  if [[ ! "$name" =~ $name_re ]]; then
    refuse
  fi
  exec test ! -e "$inbox/$name"
fi

if [[ "$cmd" =~ ^sha256sum[[:space:]]+$inbox/(.+)$ ]]; then
  name="${BASH_REMATCH[1]}"
  if [[ "$name" == "." || "$name" == ".." ]]; then
    refuse
  fi
  if [[ ! "$name" =~ $name_re ]]; then
    refuse
  fi
  exec sha256sum "$inbox/$name"
fi

refuse
