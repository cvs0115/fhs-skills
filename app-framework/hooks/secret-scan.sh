#!/usr/bin/env bash
# EXAMPLE secret scan - adapt the patterns to your platform's token formats before use.
#
# Usage:
#   bash hooks/secret-scan.sh --staged          # what is about to be committed (default)
#   bash hooks/secret-scan.sh --range A..B      # commits about to be pushed, e.g. origin/develop..develop
#
# Uses gitleaks when it is installed (preferred; check the syntax for your gitleaks version),
# otherwise a regex fallback over ADDED lines only. It prints file:line and the rule name,
# never the matched value. Mark a known-safe line with the comment 'secret-scan:allow'.
#
# Also blocks: staged secret-bearing files (.env, keys, certificates) and files over MAX_MB.

set -u

MODE="${1:---staged}"
RANGE="${2:-}"
MAX_MB="${MAX_MB:-5}"
found=0

if [ "$MODE" = "--range" ] && [ -z "$RANGE" ]; then
  echo "secret-scan: --range needs A..B" >&2
  exit 2
fi

# --- Preferred: gitleaks ---------------------------------------------------------------------------
if command -v gitleaks >/dev/null 2>&1 && [ "${NO_GITLEAKS:-0}" != "1" ]; then
  if [ "$MODE" = "--staged" ]; then
    gitleaks git --pre-commit --staged --redact --no-banner || exit 1
  else
    gitleaks git --log-opts="$RANGE" --redact --no-banner || exit 1
  fi
  exit 0
fi

# --- Fallback: regex over added lines ---------------------------------------------------------------
if [ "$MODE" = "--staged" ]; then
  diff_cmd="git diff --cached -U0 --no-color"
  files_cmd="git diff --cached --name-only --diff-filter=ACMR"
else
  diff_cmd="git diff -U0 --no-color $RANGE"
  files_cmd="git diff --name-only --diff-filter=ACMR $RANGE"
fi

# Secret-bearing file names.
while IFS= read -r f; do
  [ -z "$f" ] && continue
  case "$f" in
    *.env|.env|.env.*|*/.env|*/.env.*|*.pem|*.pfx|*.p12|*.key|*id_rsa*|*id_ed25519*)
      case "$f" in *.example|*.sample|*.template) continue ;; esac
      echo "secret-scan: $f: secret-bearing file type; don't commit it" >&2
      found=1
      ;;
  esac
  if [ -f "$f" ]; then
    size=$(wc -c < "$f" | tr -d ' ')
    if [ "$size" -gt $((MAX_MB * 1024 * 1024)) ]; then
      echo "secret-scan: $f: larger than ${MAX_MB} MB; large files don't belong in git" >&2
      found=1
    fi
  fi
done < <($files_cmd)

# Added lines as "file:line<TAB>content".
added="$($diff_cmd | awk '
  /^\+\+\+ / { f = substr($0, 7); next }
  /^@@ / { split($3, a, ","); n = substr(a[1], 2) + 0; next }
  /^\+/ { print f ":" n "\t" substr($0, 2); n++ }
')"

check() {
  local name="$1" pattern="$2" hits
  hits="$(printf '%s\n' "$added" | grep -v 'secret-scan:allow' | grep -E -- "$pattern" | cut -f1)"
  if [ -n "$hits" ]; then
    printf '%s\n' "$hits" | while IFS= read -r loc; do
      echo "secret-scan: $loc: possible $name" >&2
    done
    found=1
  fi
}

check "private key"          '-----BEGIN [A-Z ]*PRIVATE KEY-----'
check "cloud access key"     'AKIA[0-9A-Z]{16}'
check "git host token"       'gh[pousr]_[A-Za-z0-9]{36,}'
check "chat token"           'xox[baprs]-[A-Za-z0-9-]{10,}'
check "JWT"                  'eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.'
check "bearer token"         '[Bb]earer[[:space:]]+[A-Za-z0-9._~+/-]{20,}'
check "connection password"  '([Pp]assword|[Pp]wd)=[^;[:space:]"'"'"']{6,}'
check "assigned secret"      '([Ss]ecret|[Pp]assw(or)?d|[Aa][Pp][Ii][_-]?[Kk]ey|[Cc]lient[_-]?[Ss]ecret|[Aa]ccess[_-]?[Tt]oken)["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"'[:space:]<>{}]{8,}["'"'"']'
# Add your platform's token formats here, e.g.:
# check "platform token" '<PLATFORM_TOKEN_REGEX>'

if [ "$found" != 0 ]; then
  echo "secret-scan: FAILED. Move secrets to the platform's secret store; never commit them." >&2
  exit 1
fi
exit 0
