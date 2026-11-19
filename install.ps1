# Recorder Tianjie Gongfa - one-line installer for Windows (PowerShell 5.1+)
# Usage: irm https://liyubuke.github.io/tianjie/install.ps1 | iex
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
function T([string]$k) { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($k)) }
$S = @{
  'skill' = '5b2V6Z+z56yU5aSp6Zi25Yqf5rOV'
  'title' = 'PT0g5b2V6Z+z56yU5aSp6Zi25Yqf5rOVIMK3IOWuieijhe+8iFdpbmRvd3PvvIk9PQ=='
  'dl' = '5LiL6L295oqA6IO95YyF4oCm4oCm'
  'dlfail' = '5LiL6L295aSx6LSl77yM6K+35qOA5p+l572R57uc77yIR2l0SHViIOacieaXtumcgOimgeWkmuivleWHoOasoe+8ieWQjumHjeivle+8mg=='
  'installto' = '5a6J6KOF5oqA6IO95Yiw77ya'
  'skip' = '5rKh5pyJ5YaZ5YWl5p2D6ZmQ77yM5bey6Lez6L+H77ya'
  'none' = '5rKh5om+5YiwIENsYXVkZSBDb2RlIC8gQ29kZXggLyBXb3JrQnVkZHkgLyDljYPpl64g55qE6YWN572u55uu5b2V77yM6KOF5Yiw5b2T5YmN55uu5b2V55qEIHNraWxsc1wg5LiL44CC'
  'check' = '5qOA5p+l6K+75b2V6Z+z55qE5Lik5Liq57uE5Lu277yI6K6v6aOe5b2V6Z+z56yUID0g5pm65aOw5LqS6IGU77yM6K6v6aOe5ZCs6KeB77yJ77ya'
  'rec' = '6K6v6aOe5b2V6Z+z56yU'
  'xftj' = '6K6v6aOe5ZCs6KeB'
  'recok' = '6K6v6aOe5b2V6Z+z56yU5bey6KOF5YiwIA=='
  'recfail' = '6K6v6aOe5b2V6Z+z56yU6Ieq5Yqo5a6J6KOF5aSx6LSl77yM5Y+v5Lul5oqK6L+Z5Y+l5Y+R57uZIEFJIOWKqeaJi++8mmN1cmwgLWZzU0wgaHR0cHM6Ly9vcGVuLmlmbHlyZWNvcmRlci5jb20vc2tpbGxzL2lmbHl0ZWstcmVjb3JkZXIvaW5zdGFsbC5zaCB8IGJhc2g='
  'nopy' = '5rKh5om+5YiwIFB5dGhvbiAzLjkr77yM6Lez6L+H6K6v6aOe5b2V6Z+z56yU6Ieq5Yqo5a6J6KOF44CC'
  'xftjtip' = '6K6v6aOe5ZCs6KeB6K+35ZyoIFdvcmtCdWRkeeOAjOS4k+WutiDCtyDmioDog70gwrcg6L+e5o6l5Zmo44CN4oaS44CM5oqA6IO944CN5pCc57Si44CQ6K6v6aOe5ZCs6KeB44CR5a6J6KOF77yM5oiW5oqK6L+Z5Y+l5Y+R57uZIEFJIOWKqeaJi++8mmN1cmwgLWZzU0wgaHR0cHM6Ly9za2lsbGh1Yi5jbi9pbnN0YWxsL2luc3RhbGwuc2ggfCBiYXNoICYmIHNraWxsaHViIGluc3RhbGwgeGZ0ai10cmFuc2NyaWJl'
  'done' = 'PT0g6KOF5aW95LqGID09'
  'restart' = '6YeN5ZCv5L2g55qEIEFJIOWKqeaJi++8jOeEtuWQjuWvueWug+ivtO+8muW9lemfs+eslOWkqemYtuWKn+azlQ=='
  'auth' = '56ys5LiA5qyh6K+75Y+W5b2V6Z+z5pe25Lya5by55Ye66K6v6aOe6LSm5Y+35o6I5p2D6aG177yM55m75b2V5bm25ZCM5oSP5Y2z5Y+v44CC'
}
$Site = if ($env:TIANJIE_SITE) { $env:TIANJIE_SITE } else { 'https://liyubuke.github.io/tianjie' }
$SkillName = T $S.skill
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host ''; Write-Host (T $S.title)
$Work = Join-Path $env:TEMP ('tianjie-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $Work | Out-Null
try {
  Write-Host (T $S.dl)
  $zip = Join-Path $Work 'tianjie.zip'
  try { Invoke-WebRequest -UseBasicParsing -Uri "$Site/tianjie.zip" -OutFile $zip }
  catch { Write-Host ((T $S.dlfail) + " $Site/tianjie.zip"); exit 1 }
  Add-Type -AssemblyName System.IO.Compression.FileSystem
  [IO.Compression.ZipFile]::ExtractToDirectory($zip, (Join-Path $Work 'x'))
  $Src = Join-Path (Join-Path $Work 'x') $SkillName

  $U = $env:USERPROFILE
  $Tools = @()
  if (Test-Path "$U\.claude")     { $Tools += ,@('Claude Code', "$U\.claude\skills", 'claude') }
  if (Test-Path "$U\.codex")      { $Tools += ,@('Codex', "$U\.codex\skills", 'codex') }
  if (Test-Path "$U\.workbuddy")  { $Tools += ,@('WorkBuddy', "$U\.workbuddy\skills", 'workbuddy') }
  if (Test-Path "$U\.qwenworkcn") { $Tools += ,@((T '5Y2D6Zeu'), "$U\.qwenworkcn\skills", 'workspace') }
  if ($Tools.Count -eq 0) { Write-Host (T $S.none); $Tools += ,@('.', (Join-Path (Get-Location) 'skills'), 'workspace') }

  Write-Host ''; Write-Host (T $S.installto)
  foreach ($t in $Tools) {
    try {
      New-Item -ItemType Directory -Force -Path $t[1] | Out-Null
      $dst = Join-Path $t[1] $SkillName
      if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
      Copy-Item -Recurse -Path $Src -Destination $dst
      Write-Host ("  [OK] " + $t[0] + "  ->  " + $dst)
    } catch { Write-Host ("  [!] " + (T $S.skip) + $t[1]) }
  }

  if ($args -notcontains '--no-deps') {
    Write-Host ''; Write-Host (T $S.check)
    $py = $null
    foreach ($c in @('py -3', 'python', 'python3')) {
      try { $v = & ([scriptblock]::Create("$c -c `"import sys;print(1 if sys.version_info>=(3,9) else 0)`"")) 2>$null; if ($v -eq '1') { $py = $c; break } } catch {}
    }
    $needX = $false
    foreach ($t in $Tools) {
      $d = $t[1]
      $hasR = (Test-Path "$d\recording-assistant-prod\SKILL.md") -or (Test-Path "$d\iflytek-recorder\SKILL.md")
      $hasX = @(Get-ChildItem -Path $d -Directory -Filter 'xftj-transcribe*' -ErrorAction SilentlyContinue).Count -gt 0
      $r = if ($hasR) { 'OK' } else { 'X' }; $x = if ($hasX) { 'OK' } else { 'X' }
      Write-Host ("  " + $t[0] + ": " + (T $S.rec) + " $r   " + (T $S.xftj) + " $x")
      if (-not $hasX) { $needX = $true }
      if (-not $hasR) {
        if ($py) {
          try {
            $base = 'https://open.iflyrecorder.com/skills/iflytek-recorder'
            $shTxt = (Invoke-WebRequest -UseBasicParsing -Uri "$base/install.sh").Content
            $want = [regex]::Match($shTxt, 'installer_sha256="([0-9a-f]{64})"').Groups[1].Value
            $ipy = Join-Path $Work 'install.py'
            Invoke-WebRequest -UseBasicParsing -Uri "$base/install.py" -OutFile $ipy
            $got = (Get-FileHash -Algorithm SHA256 $ipy).Hash.ToLower()
            if ($want -and $got -eq $want) {
              Push-Location (Split-Path $d -Parent)
              & ([scriptblock]::Create("$py -B `"$ipy`" --target $($t[2])")) | Out-Null
              Pop-Location
              if ((Test-Path "$d\recording-assistant-prod\SKILL.md")) { Write-Host ("  [OK] " + (T $S.recok) + $t[0]) } else { throw 'x' }
            } else { throw 'sha' }
          } catch { Write-Host ("  [!] " + (T $S.recfail)) }
        } else { Write-Host ("  [!] " + (T $S.nopy)) }
      }
    }
    if ($needX) { Write-Host ("  [!] " + (T $S.xftjtip)) }
  }
  Write-Host ''; Write-Host (T $S.done); Write-Host (T $S.restart); Write-Host (T $S.auth)
} finally { Remove-Item -Recurse -Force $Work -ErrorAction SilentlyContinue }
