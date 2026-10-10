#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
HOOK="$ROOT/scripts/git-hooks/pre-receive"
GATE="$ROOT/scripts/windows/ssh-gate.sh"
WIN="$ROOT/scripts/windows"

FAILS=0
TMPDIRS=()

pass() { echo "PASS $1"; }
fail() { echo "FAIL $1: $2"; FAILS=$((FAILS + 1)); }

cleanup() {
  local d
  for d in "${TMPDIRS[@]}"; do
    rm -rf "$d"
  done
}
trap cleanup EXIT

export GIT_AUTHOR_NAME='Win Agent Test'
export GIT_AUTHOR_EMAIL='win-agent-test@example.com'
export GIT_COMMITTER_NAME='Win Agent Test'
export GIT_COMMITTER_EMAIL='win-agent-test@example.com'
export GIT_TERMINAL_PROMPT=0

git_commit() {
  local dir="$1" msg="$2"
  git -C "$dir" add -A
  git -C "$dir" commit -m "$msg" >/dev/null
}

hook_push() {
  local pc="$1"
  shift
  git -C "$pc" push origin "$@" 2>&1
}

hook_expect_refused() {
  local id="$1" pc="$2"
  shift 2
  local out ec
  out="$(hook_push "$pc" "$@")"
  ec=$?
  if [[ $ec -eq 0 ]]; then
    fail "$id" "push succeeded, expected refusal"
    return
  fi
  if [[ "$out" != *"refused:"* ]]; then
    fail "$id" "missing refused: in output: ${out//$'\n'/ | }"
  else
    pass "$id"
  fi
}

# --- Hook matrix H1-H10 ---------------------------------------------------
HOOK_ROOT="$(mktemp -d)"
TMPDIRS+=("$HOOK_ROOT")
SERVER="$HOOK_ROOT/server"
PC="$HOOK_ROOT/pc"
mkdir -p "$SERVER"

git -C "$SERVER" init -b main >/dev/null
echo readme > "$SERVER/README"
git_commit "$SERVER" "init"
cp "$HOOK" "$SERVER/.git/hooks/pre-receive"
chmod +x "$SERVER/.git/hooks/pre-receive"
git clone "$SERVER" "$PC" >/dev/null 2>&1

git -C "$PC" checkout -b feat/win-hello >/dev/null
echo hello > "$PC/hello.txt"
git_commit "$PC" "win hello"
if hook_push "$PC" feat/win-hello >/dev/null; then
  pass H1
else
  fail H1 "new feat/win-hello push failed"
fi

echo more >> "$PC/hello.txt"
git_commit "$PC" "win ff"
if hook_push "$PC" feat/win-hello >/dev/null; then
  pass H2
else
  fail H2 "fast-forward push failed"
fi

FF_COMMIT="$(git -C "$PC" rev-parse feat/win-hello)"

git -C "$PC" checkout main >/dev/null
echo mainline >> "$PC/README"
git_commit "$PC" "main ahead"
hook_expect_refused H3 "$PC" main

git -C "$PC" checkout -b feat/other >/dev/null
echo other > "$PC/other.txt"
git_commit "$PC" "other"
hook_expect_refused H4 "$PC" feat/other

git -C "$PC" checkout feat/win-hello >/dev/null
echo amend >> "$PC/hello.txt"
git -C "$PC" commit --amend -m "amend" >/dev/null
out="$(git -C "$PC" push --force origin feat/win-hello 2>&1)"
if [[ $? -ne 0 && "$out" == *"refused:"* ]]; then
  pass H5
else
  fail H5 "expected refused non-fast-forward; out: ${out//$'\n'/ | }"
fi

hook_expect_refused H6 "$PC" --delete feat/win-hello

git -C "$PC" reset --hard >/dev/null
git -C "$PC" checkout main >/dev/null
git -C "$PC" checkout -b feat/win-Upper_Case >/dev/null
echo up > "$PC/up.txt"
git_commit "$PC" "upper"
hook_expect_refused H7 "$PC" feat/win-Upper_Case

git -C "$PC" checkout main >/dev/null
git -C "$PC" checkout -b feat/win- >/dev/null
echo empty > "$PC/empty.txt"
git_commit "$PC" "empty suffix"
hook_expect_refused H8 "$PC" feat/win-

REF_LINES="$(git -C "$SERVER" for-each-ref --format='%(refname)' refs/heads/ | sort)"
WANT_REFS=$'refs/heads/feat/win-hello\nrefs/heads/main'
if [[ "$REF_LINES" == "$WANT_REFS" ]]; then
  SERVER_FF="$(git -C "$SERVER" rev-parse refs/heads/feat/win-hello)"
  if [[ "$SERVER_FF" == "$FF_COMMIT" ]]; then
    pass H9
  else
    fail H9 "feat/win-hello at $SERVER_FF, want $FF_COMMIT"
  fi
else
  fail H9 "refs: ${REF_LINES//$'\n'/ | }"
fi

CUR="$(git -C "$SERVER" branch --show-current)"
if [[ "$CUR" == main ]]; then
  pass H10
else
  fail H10 "server branch is $CUR"
fi

# --- Gate matrix ----------------------------------------------------------
GATE_ROOT="$(mktemp -d)"
TMPDIRS+=("$GATE_ROOT")
FHS_GATE_REPO="$GATE_ROOT/repo"
FHS_GATE_INBOX="$GATE_ROOT/inbox"
mkdir -p "$FHS_GATE_REPO" "$FHS_GATE_INBOX"

STUB_BIN="$GATE_ROOT/bin"
mkdir -p "$STUB_BIN"
for stub in git-upload-pack git-receive-pack scp test sha256sum; do
  cat > "$STUB_BIN/$stub" <<'STUBEOF'
#!/usr/bin/env bash
echo "STUB $(basename "$0") $*"
exit 0
STUBEOF
  chmod +x "$STUB_BIN/$stub"
done

run_gate() {
  SSH_ORIGINAL_COMMAND="$1" FHS_GATE_REPO="$FHS_GATE_REPO" FHS_GATE_INBOX="$FHS_GATE_INBOX" \
    PATH="$STUB_BIN:$PATH" bash "$GATE" 2>&1
}

gate_expect_ok() {
  local id="$1" cmd="$2" want_line="$3"
  local out ec
  out="$(run_gate "$cmd")"
  ec=$?
  if [[ $ec -ne 0 ]]; then
    fail "$id" "exit $ec, want 0; out: ${out//$'\n'/ | }"
    return
  fi
  if [[ "$out" != "$want_line" ]]; then
    fail "$id" "got '$out', want '$want_line'"
  else
    pass "$id"
  fi
}

gate_expect_refused() {
  local id="$1" cmd="$2"
  local out ec
  if [[ -n "$cmd" ]]; then
    out="$(run_gate "$cmd")"
  else
    out="$(SSH_ORIGINAL_COMMAND= FHS_GATE_REPO="$FHS_GATE_REPO" FHS_GATE_INBOX="$FHS_GATE_INBOX" \
      PATH="$STUB_BIN:$PATH" bash "$GATE" 2>&1)"
  fi
  ec=$?
  if [[ $ec -ne 1 ]]; then
    fail "$id" "exit $ec, want 1"
    return
  fi
  if [[ "$out" == *STUB* ]]; then
    fail "$id" "unexpected STUB output: $out"
  else
    pass "$id"
  fi
}

gate_expect_ok G1 "git-upload-pack '$FHS_GATE_REPO'" "STUB git-upload-pack $FHS_GATE_REPO"
gate_expect_ok G2 "git-upload-pack '$FHS_GATE_REPO/'" "STUB git-upload-pack $FHS_GATE_REPO"
gate_expect_ok G3 "git-upload-pack $FHS_GATE_REPO" "STUB git-upload-pack $FHS_GATE_REPO"
gate_expect_ok G4 "git-receive-pack '$FHS_GATE_REPO'" "STUB git-receive-pack $FHS_GATE_REPO"
gate_expect_ok G5 "git-receive-pack $FHS_GATE_REPO" "STUB git-receive-pack $FHS_GATE_REPO"
gate_expect_ok G6 "scp -t $FHS_GATE_INBOX/r.md" "STUB scp -t $FHS_GATE_INBOX/r.md"
gate_expect_ok G7 "test ! -e $FHS_GATE_INBOX/r.md" "STUB test ! -e $FHS_GATE_INBOX/r.md"
gate_expect_ok G8 "sha256sum $FHS_GATE_INBOX/r.md" "STUB sha256sum $FHS_GATE_INBOX/r.md"

gate_expect_refused G9 bash
gate_expect_refused G10 "sh -c id"
gate_expect_refused G11 "git-receive-pack '/etc'"
gate_expect_refused G12 "scp -t $FHS_GATE_INBOX/../x"
gate_expect_refused G13 "scp -f $FHS_GATE_INBOX/a"
gate_expect_refused G14 "sha256sum /etc/shadow"
gate_expect_refused G15 ""
gate_expect_refused G16 "sha256sum $FHS_GATE_INBOX/a;id"
gate_expect_refused G16 "sha256sum $FHS_GATE_INBOX/\$(id)"
gate_expect_refused G17 "test ! -e /etc/x"

# --- Static checks S1-S6 --------------------------------------------------
if ! grep -q Remove-Item "$WIN/refresh-mirror.ps1" "$WIN/send-report.ps1" 2>/dev/null; then
  pass S1
else
  fail S1 "Remove-Item found in a ps1"
fi

if grep -q Read-Host "$WIN/refresh-mirror.ps1" && grep -q "\-ne 'YES'" "$WIN/refresh-mirror.ps1"; then
  pass S2
else
  fail S2 "Read-Host or -ne 'YES' missing in refresh-mirror"
fi

if grep -qE 'Get-FileHash.*-Algorithm SHA256' "$WIN/refresh-mirror.ps1" \
  && grep -qE 'Get-FileHash.*-Algorithm SHA256' "$WIN/send-report.ps1"; then
  pass S3
else
  fail S3 "Get-FileHash -Algorithm SHA256 missing"
fi

S4_FAIL=0
for f in "$WIN/refresh-mirror.ps1" "$WIN/send-report.ps1"; do
  if LC_ALL=C grep -nP '[^\x00-\x7F]' "$f" >/dev/null 2>&1; then
    S4_FAIL=1
  fi
done
if [[ $S4_FAIL -eq 0 ]]; then
  pass S4
else
  fail S4 "non-ASCII in ps1"
fi

S5_FAIL=0
for f in "$WIN/refresh-mirror.ps1" "$WIN/send-report.ps1"; do
  if grep -q $'\t' "$f"; then
    S5_FAIL=1
  fi
  if [[ -n "$(head -c 3 "$f" | od -An -tx1 | tr -d ' \n')" ]] && [[ "$(head -c 3 "$f" | od -An -tx1 | tr -d ' \n')" == efbbbf ]]; then
    S5_FAIL=1
  fi
done
if [[ $S5_FAIL -eq 0 ]]; then
  pass S5
else
  fail S5 "tab or BOM in ps1"
fi

if bash -n "$GATE" && bash -n "$ROOT/scripts/tests/test_windows_agent.sh"; then
  pass S6
else
  fail S6 "bash -n syntax error"
fi

if [[ $FAILS -eq 0 ]]; then
  exit 0
fi
exit 1
