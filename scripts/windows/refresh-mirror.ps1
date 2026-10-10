param(
    [string]$Clone = 'C:\fhs\fhs-skills',
    [string]$MirrorRoot = 'C:\Users\mayur\.claude\skills',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$SourceRoot = Join-Path $Clone 'skills'

$cloneResolved = (Resolve-Path -LiteralPath $Clone).Path
if (Test-Path -LiteralPath $MirrorRoot) {
    $mirrorResolved = (Resolve-Path -LiteralPath $MirrorRoot).Path
} else {
    $mirrorResolved = [System.IO.Path]::GetFullPath($MirrorRoot)
}
if ($mirrorResolved.StartsWith($cloneResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
    Write-Error "MirrorRoot must not be inside Clone ($Clone)."
    exit 1
}

git -C $Clone checkout main
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
git -C $Clone pull --ff-only origin main
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

function Get-FhsHashes([string]$Root) {
    $map = @{}
    if (-not (Test-Path -LiteralPath $Root)) { return $map }
    Get-ChildItem -LiteralPath $Root -Force -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like 'fhs-*' } |
        ForEach-Object {
            Get-ChildItem -LiteralPath $_.FullName -Recurse -Force -File
        } |
        ForEach-Object {
            $rel = $_.FullName.Substring($Root.Length).TrimStart('\')
            $hash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
            $map[$rel] = $hash
        }
    return $map
}

$src = Get-FhsHashes $SourceRoot
$dst = Get-FhsHashes $MirrorRoot
$onlyServer = @()
$different = @()
$onlyWindows = @()
foreach ($rel in $src.Keys) {
    if (-not $dst.ContainsKey($rel)) { $onlyServer += $rel }
    elseif ($dst[$rel] -ne $src[$rel]) { $different += $rel }
}
foreach ($rel in $dst.Keys) {
    if (-not $src.ContainsKey($rel)) { $onlyWindows += $rel }
}

Write-Output 'Only on server (would be copied):'
$onlyServer | Sort-Object | ForEach-Object { Write-Output $_ }
Write-Output 'Different hash (would be copied over):'
$different | Sort-Object | ForEach-Object { Write-Output $_ }
Write-Output 'Only on Windows (reported, not deleted):'
$onlyWindows | Sort-Object | ForEach-Object { Write-Output $_ }

if ($DryRun) {
    exit 0
}

$answer = Read-Host 'Type YES to copy server files onto the Windows skill folders'
if ($answer -ne 'YES') {
    Write-Output 'Stopped. Nothing copied.'
    exit 1
}

foreach ($rel in ($onlyServer + $different)) {
    $from = Join-Path $SourceRoot $rel
    $to = Join-Path $MirrorRoot $rel
    $parent = Split-Path -Parent $to
    if (-not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent | Out-Null
    }
    Copy-Item -LiteralPath $from -Destination $to -Force
}

$srcAfter = Get-FhsHashes $SourceRoot
$dstAfter = Get-FhsHashes $MirrorRoot
$matched = 0
$unmatched = 0
$seen = @{}
foreach ($rel in $srcAfter.Keys) {
    $seen[$rel] = $true
    if ($dstAfter.ContainsKey($rel) -and $dstAfter[$rel] -eq $srcAfter[$rel]) { $matched++ }
    else { $unmatched++ }
}
foreach ($rel in $dstAfter.Keys) {
    if (-not $seen.ContainsKey($rel)) {
        $unmatched++
        Write-Output "Still only on Windows: $rel"
    }
}
Write-Output "matched=$matched"
Write-Output "unmatched=$unmatched"
