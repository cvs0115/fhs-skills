param(
    [Parameter(Mandatory = $true)]
    [string]$Path,
    [string]$Name,
    [string]$SshHost = 'dev-lxc-1'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
    Write-Error "File not found: $Path"
    exit 1
}

if (-not $Name) {
    $Name = [System.IO.Path]::GetFileName($Path)
}

if ($Name -eq '.' -or $Name -eq '..') {
    Write-Error 'Invalid Name.'
    exit 1
}

if ($Name -notmatch '^[A-Za-z0-9._-]{1,120}$') {
    Write-Error 'Name must match ^[A-Za-z0-9._-]{1,120}$'
    exit 1
}

$remoteInbox = "/root/fhs-skills/inbox/$Name"

ssh $SshHost "test ! -e $remoteInbox"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Remote file already exists: $remoteInbox"
    exit 2
}

scp -O -LiteralPath $Path "${SshHost}:${remoteInbox}"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$localHash = (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
$remoteLine = ssh $SshHost "sha256sum $remoteInbox"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$remoteHash = ($remoteLine -split '\s+')[0]
if ($localHash -eq $remoteHash) {
    Write-Output 'MATCH'
    exit 0
}
Write-Output 'MISMATCH'
exit 1
