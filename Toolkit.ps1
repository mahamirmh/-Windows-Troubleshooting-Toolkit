param([switch]$Cli)
$ErrorActionPreference='Stop'
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$reports=Join-Path $root 'reports'
New-Item -ItemType Directory -Force -Path $reports | Out-Null
$results=New-Object System.Collections.Generic.List[object]
$admin=([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
$checks=@(
 @{Id='overview';Name='System overview';Command='systeminfo';Args=@();Timeout=90},
 @{Id='network';Name='IP configuration';Command='ipconfig';Args=@('/all');Timeout=30},
 @{Id='dns';Name='DNS lookup';Command='nslookup';Args=@('example.com');Timeout=30},
 @{Id='ping';Name='Network ping';Command='ping';Args=@('-n','4','1.1.1.1');Timeout=30},
 @{Id='route';Name='Trace route';Command='tracert';Args=@('-d','-w','1000','-h','12','1.1.1.1');Timeout=90},
 @{Id='disk';Name='Read-only disk scan';Command='chkdsk';Args=@('C:','/scan');Timeout=900},
 @{Id='process';Name='Processes';Command='tasklist';Args=@();Timeout=60},
 @{Id='drivers';Name='Drivers';Command='driverquery';Args=@();Timeout=90},
 @{Id='firewall';Name='Firewall profiles';Command='netsh';Args=@('advfirewall','show','allprofiles');Timeout=60},
 @{Id='bitlocker';Name='BitLocker status';Command='manage-bde';Args=@('-status');Timeout=60},
 @{Id='sfcverify';Name='SFC verification';Command='sfc';Args=@('/verifyonly');Timeout=1800;Admin=$true},
 @{Id='dismcheck';Name='DISM health check';Command='dism';Args=@('/Online','/Cleanup-Image','/CheckHealth');Timeout=600;Admin=$true},
 @{Id='sfcfix';Name='SFC repair';Command='sfc';Args=@('/scannow');Timeout=3600;Admin=$true;Change=$true},
 @{Id='dismfix';Name='DISM repair';Command='dism';Args=@('/Online','/Cleanup-Image','/RestoreHealth');Timeout=3600;Admin=$true;Change=$true},
 @{Id='flushdns';Name='Flush DNS';Command='ipconfig';Args=@('/flushdns');Timeout=60;Change=$true},
 @{Id='winsock';Name='Reset Winsock';Command='netsh';Args=@('winsock','reset');Timeout=90;Admin=$true;Change=$true}
)
function Confirm-Operation($item) {
 if(-not $item.Change){return $true}
 $a=Read-Host "WARNING: $($item.Name) changes system settings. Type YES to proceed"
 return ($a -ceq 'YES')
}
function Invoke-Check($item){
 if($item.Admin -and -not $admin){Write-Warning 'Administrator access required';return}
 if(-not (Confirm-Operation $item)){Write-Host 'Cancelled';return}
 $start=Get-Date
 try {
  $p=New-Object System.Diagnostics.Process
  $p.StartInfo.FileName=$item.Command
  $p.StartInfo.Arguments=($item.Args -join ' ')
  $p.StartInfo.UseShellExecute=$false
  $p.StartInfo.RedirectStandardOutput=$true
  $p.StartInfo.RedirectStandardError=$true
  $p.StartInfo.CreateNoWindow=$true
  [void]$p.Start()
  $outTask=$p.StandardOutput.ReadToEndAsync()
  $errTask=$p.StandardError.ReadToEndAsync()
  if(-not $p.WaitForExit($item.Timeout*1000)){
   try{$p.Kill()}catch{}
   throw 'Command timed out'
  }
  $outTask.Wait();$errTask.Wait()
  $message=($outTask.Result+"\r\n"+$errTask.Result).Trim()
  if($message.Length -gt 50000){$message=$message.Substring(0,50000)+' [TRUNCATED]'}
  $status=if($p.ExitCode -eq 0){'OK'}else{'CHECK'}
 }catch{$status='ERROR';$message=$_.Exception.Message}
 $results.Add([pscustomobject]@{Time=$start.ToString('s');Name=$item.Name;Status=$status;Output=$message})
 Write-Host "[$status] $($item.Name)"
 Write-Host $message
}
function Export-Report {
 $path=Join-Path $reports ('report-'+(Get-Date -Format 'yyyyMMdd-HHmmss')+'.html')
 $sections=foreach($r in $results){
  $name=[System.Net.WebUtility]::HtmlEncode($r.Name)
  $output=[System.Net.WebUtility]::HtmlEncode($r.Output)
  "<section><h2>$name - $($r.Status)</h2><pre>$output</pre></section>"
 }
 $html='<!doctype html><html><head><meta charset="utf-8"><title>RISHEH diagnostics</title><style>body{font:15px Segoe UI;margin:30px auto;max-width:960px;background:#f4f7f6;color:#18392e}section{padding:20px;background:white;margin:14px 0;border-radius:12px}pre{white-space:pre-wrap;overflow-wrap:anywhere}</style></head><body><h1>RISHEH Windows Diagnostics</h1><p>Private machine data may appear. Review before sharing.</p>'+($sections -join '')+'</body></html>'
 [IO.File]::WriteAllText($path,$html,[Text.UTF8Encoding]::new($false))
 Write-Host "Report: $path"
}
function Run-Menu {
 while($true){
  Write-Host "`n=== RISHEH Windows Toolkit (Preview) ==="
  for($i=0;$i -lt $checks.Count;$i++){Write-Host "$($i+1). $($checks[$i].Name)"}
  Write-Host 'R. Export report   Q. Quit'
  $choice=Read-Host 'Select'
  if($choice -match '^[qQ]$'){break}
  if($choice -match '^[rR]$'){Export-Report;continue}
  $number=0
  if([int]::TryParse($choice,[ref]$number) -and $number -ge 1 -and $number -le $checks.Count){Invoke-Check $checks[$number-1]}
 }
}
if(-not $Cli){Write-Host 'GUI preview is not included in this repository source snapshot; starting safe CLI.'}
Run-Menu
