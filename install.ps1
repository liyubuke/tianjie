# Recorder Tianjie Gongfa - one-line installer for Windows (PowerShell 5.1+)
# Usage: irm https://liyubuke.github.io/tianjie/install.ps1 | iex
# Inside an AI tool: installs only into that tool. In a terminal: asks which tool. Or set $env:TIANJIE_TARGET='workbuddy' first.
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
function T([string]$k) { [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($k)) }
$S = @{
  'skill' = '5b2V6Z+z56yU6auY6Zi255So5rOV'
  'oldskill' = '5b2V6Z+z56yU5aSp6Zi25Yqf5rOV'
  'title' = 'PT0g5b2V6Z+z56yU6auY6Zi255So5rOVIMK3IOWuieijhe+8iFdpbmRvd3PvvIk9PQ=='
  'dl' = '5LiL6L295oqA6IO95YyF4oCm4oCm'
  'dlfail' = '5LiL6L295aSx6LSl77yM6K+35qOA5p+l572R57uc77yIR2l0SHViIOacieaXtumcgOimgeWkmuivleWHoOasoe+8ieWQjumHjeivle+8mg=='
  'installto' = '5a6J6KOF5oqA6IO95Yiw77ya'
  'skip' = '5rKh5pyJ5YaZ5YWl5p2D6ZmQ77yM5bey6Lez6L+H77ya'
  'none' = '5rKh5om+5YiwIENsYXVkZSBDb2RlIC8gQ29kZXggLyBXb3JrQnVkZHkgLyDljYPpl64g55qE6YWN572u55uu5b2V44CC6KOF5aW95YW25Lit5LiA5LiqIEFJIOW3peWFt+WQjuWGjei/kOihjO+8jOaIluWKoOWPguaVsOaMh+Wumu+8jOS+i+WmgiAtLXRhcmdldD13b3JrYnVkZHk='
  'hostonly' = '5qOA5rWL5Yiw5L2g5Zyo6L+Z5LiqIEFJIOW3peWFt+mHjOaJp+ihjO+8jOWPquijheWIsOWug++8mg=='
  'pick' = '5pys5py65qOA5rWL5Yiw6L+Z5LqbIEFJIOW3peWFt++8jOimgeijheWIsOWTquS4qu+8nw=='
  'all' = '5YWo6YOo'
  'pickq' = '6L6T5YWl57yW5Y+377yI5aSa5Liq55So56m65qC86ZqU5byA77yM5aaCIDEgM++8iQ=='
  'nopick' = '5rKh5pyJ6YCJ5oup77yM5bey6YCA5Ye644CC'
  'badtarget' = 'LS10YXJnZXQg5Y+q6IO95pivIGNsYXVkZeOAgWNvZGV444CBd29ya2J1ZGR544CBcXdlbuOAgWFsbA=='
  'done' = 'PT0g5oqA6IO96KOF5aW95LqGID09'
  'ai0' = '44CQ6K+3IEFJIOWKqeaJi+e7p+e7re+8jOS4jeimgeWBnOOAkQ=='
  'ai1' = 'MS4g56uL5Y2z6K+75Y+WIA=='
  'ai1b' = '77yM5oyJ5YW25Lit44CM56ysIDAg5q2l44CN5omn6KGM77yb'
  'ai2' = 'Mi4g5YWI6Zeu55So5oi355So5ZOq5Liq5b2V6Z+zIEFwcO+8iOiur+mjnuW9lemfs+eslCBBcHAgLyDorq/po57lkKzop4EgQXBwIC8gRGVlcHRpbmcgQXBw77yM5Y+v5aSa6YCJ77yJ77yb'
  'ai3' = 'My4g5oyJ55So5oi355qE6YCJ5oup5a6J6KOF5a+55bqU57uE5Lu277yM5bm25bim55So5oi35a6M5oiQ6LSm5Y+355m75b2V5ZKM5o6I5p2D77yM55u05Yiw5qOA5p+l6YCa6L+H77yb'
  'ai4' = 'NC4g54S25ZCO6L+b5YWl44CM6YCJ55So5rOV44CN77yM6K6p55So5oi354K56YCJ5LiA56eN55So5rOV5byA5aeL44CC'
  'next0' = '5LiL5LiA5q2l77yaMS4g6YeN5ZCv5L2g55qEIEFJIOWKqeaJi++8jOWvueWug+ivtO+8muW9lemfs+eslOmrmOmYtueUqOazlQ=='
  'next1' = 'Mi4g5a6D5Lya5YWI6Zeu5L2g55So5ZOq5Liq5b2V6Z+zIEFwcO+8iOiur+mjnuW9lemfs+eslCAvIOiur+mjnuWQrOingSAvIERlZXB0aW5n77yJ77yM'
  'next2' = 'ICAg5YaN5biu5L2g6KOF5aW95a+55bqU57uE5Lu244CB5omT5byA572R6aG16K6p5L2g55m75b2V5o6I5p2D77yM5a6M5oiQ5ZCO5bCx6IO96YCJ55So5rOV5byA5aeL44CC'
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
  $All = [ordered]@{
    'claude'    = @('Claude Code', "$U\.claude\skills", 'claude', "$U\.claude")
    'codex'     = @('Codex', "$U\.codex\skills", 'codex', "$U\.codex")
    'workbuddy' = @('WorkBuddy', "$U\.workbuddy\skills", 'workbuddy', "$U\.workbuddy")
    'qwen'      = @((T '5Y2D6Zeu'), "$U\.qwenworkcn\skills", 'workspace', "$U\.qwenworkcn")
  }
  $want = ''
  foreach ($a in $args) { if ($a -like '--target=*') { $want = $a.Substring(9) } }
  if (-not $want -and $env:TIANJIE_TARGET) { $want = $env:TIANJIE_TARGET }
  $host_ = ''
  if ($env:CLAUDECODE -or $env:CLAUDE_CODE_ENTRYPOINT) { $host_ = 'claude' }
  elseif ($env:CODEX_SESSION_ID -or $env:CODEX_THREAD_ID -or $env:CODEX_VERSION -or $env:CODEX_APP_TOOLS_PIPE_PATH) { $host_ = 'codex' }
  elseif ($env:WORKBUDDY_CONFIG_DIR -or $env:WORKBUDDY_HOME -or $env:WORKBUDDY_APP_NAME) { $host_ = 'workbuddy' }
  elseif (@(Get-ChildItem env: | Where-Object { $_.Name -like 'QWENWORK*' }).Count -gt 0) { $host_ = 'qwen' }
  $avail = @($All.Keys | Where-Object { Test-Path $All[$_][3] })
  $keys = @()
  if ($want) {
    if ($want -eq 'all') { $keys = $avail } else { $keys = @($want -split ',' | Where-Object { $All.Contains($_) }) }
  } elseif ($host_) {
    $keys = @($host_); Write-Host ((T $S.hostonly) + $All[$host_][0])
  } elseif ($avail.Count -eq 1) {
    $keys = $avail
  } elseif ($avail.Count -eq 0) {
    Write-Host (T $S.none); exit 1
  } else {
    Write-Host ''; Write-Host (T $S.pick)
    for ($i = 0; $i -lt $avail.Count; $i++) { Write-Host ("  " + ($i + 1) + ". " + $All[$avail[$i]][0]) }
    Write-Host ("  a. " + (T $S.all))
    $ans = Read-Host (T $S.pickq)
    foreach ($p in ($ans -split '\s+')) {
      if ($p -eq 'a' -or $p -eq 'A') { $keys = $avail }
      elseif ($p -match '^\d+$' -and [int]$p -ge 1 -and [int]$p -le $avail.Count) { $keys += $avail[[int]$p - 1] }
    }
    if ($keys.Count -eq 0) { Write-Host (T $S.nopick); exit 1 }
  }
  if ($keys.Count -eq 0) { Write-Host (T $S.badtarget); exit 1 }
  $Tools = @(); foreach ($k in ($keys | Select-Object -Unique)) { $Tools += ,@($All[$k][0], $All[$k][1], $All[$k][2]) }

  Write-Host ''; Write-Host (T $S.installto)
  foreach ($t in $Tools) {
    try {
      New-Item -ItemType Directory -Force -Path $t[1] | Out-Null
      $dst = Join-Path $t[1] $SkillName
      if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
      Copy-Item -Recurse -Path $Src -Destination $dst
      Write-Host ("  [OK] " + $t[0] + "  ->  " + $dst)
      $oldDst = Join-Path $t[1] (T $S.oldskill)
      if (Test-Path $oldDst) { Remove-Item -Recurse -Force $oldDst }
    } catch { Write-Host ("  [!] " + (T $S.skip) + $t[1]) }
  }

  $oldData = Join-Path $U (T $S.oldskill); $newData = Join-Path $U $SkillName
  if ((Test-Path $oldData) -and -not (Test-Path $newData)) { Move-Item $oldData $newData }
  Write-Host ''; Write-Host (T $S.done)
  if ($host_) {
    Write-Host ''
    Write-Host (T $S.ai0)
    Write-Host ((T $S.ai1) + (Join-Path $Tools[0][1] $SkillName) + '\SKILL.md' + (T $S.ai1b))
    Write-Host (T $S.ai2); Write-Host (T $S.ai3); Write-Host (T $S.ai4)
  } else {
    Write-Host (T $S.next0); Write-Host (T $S.next1); Write-Host (T $S.next2)
  }
} finally { Remove-Item -Recurse -Force $Work -ErrorAction SilentlyContinue }
