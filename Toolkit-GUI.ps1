# RISHEH GUI preview — Windows PowerShell 5.1 / Windows Forms
# Diagnostics are executed in a separate process. No repairs are offered in this UI.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[Windows.Forms.Application]::EnableVisualStyles()
$root=Split-Path -Parent $MyInvocation.MyCommand.Path
$form=New-Object Windows.Forms.Form
$form.Text='RISHEH | Windows Health Center'
$form.Size=New-Object Drawing.Size(950,660)
$form.MinimumSize=New-Object Drawing.Size(700,500)
$form.StartPosition='CenterScreen'
$form.BackColor=[Drawing.Color]::FromArgb(245,248,247)
$title=New-Object Windows.Forms.Label
$title.Text='RISHEH  /  Windows Health Center'
$title.Font=New-Object Drawing.Font('Segoe UI',17,[Drawing.FontStyle]::Bold)
$title.ForeColor=[Drawing.Color]::FromArgb(23,74,58)
$title.SetBounds(22,18,870,40);$form.Controls.Add($title)
$subtitle=New-Object Windows.Forms.Label
$subtitle.Text='Read-only diagnostics  |  Offline-first  |  Preview'
$subtitle.SetBounds(24,62,850,25);$form.Controls.Add($subtitle)
$items=@(
 @{Name='System overview';File='systeminfo.exe';Args=''},
 @{Name='IP configuration';File='ipconfig.exe';Args='/all'},
 @{Name='DNS lookup';File='nslookup.exe';Args='example.com'},
 @{Name='Internet ping';File='ping.exe';Args='-n 4 1.1.1.1'},
 @{Name='Network route';File='tracert.exe';Args='-d -w 1000 -h 12 1.1.1.1'},
 @{Name='Running processes';File='tasklist.exe';Args=''},
 @{Name='Firewall profiles';File='netsh.exe';Args='advfirewall show allprofiles'},
 @{Name='Power modes';File='powercfg.exe';Args='/a'}
)
$list=New-Object Windows.Forms.ListBox
$list.Font=New-Object Drawing.Font('Segoe UI',10)
$list.SetBounds(22,105,250,425);$list.Anchor='Top,Bottom,Left'
foreach($i in $items){[void]$list.Items.Add($i.Name)}
$form.Controls.Add($list)
$output=New-Object Windows.Forms.TextBox
$output.Multiline=$true;$output.ReadOnly=$true;$output.ScrollBars='Both'
$output.WordWrap=$false;$output.Font=New-Object Drawing.Font('Consolas',9)
$output.SetBounds(290,105,625,425);$output.Anchor='Top,Bottom,Left,Right'
$form.Controls.Add($output)
$run=New-Object Windows.Forms.Button;$run.Text='Run selected'
$run.SetBounds(22,550,155,36);$run.Anchor='Bottom,Left';$form.Controls.Add($run)
$save=New-Object Windows.Forms.Button;$save.Text='Save text report'
$save.SetBounds(190,550,155,36);$save.Anchor='Bottom,Left';$form.Controls.Add($save)
$status=New-Object Windows.Forms.Label;$status.Text='Ready'
$status.SetBounds(365,557,490,26);$status.Anchor='Bottom,Left,Right';$form.Controls.Add($status)
$timer=New-Object Windows.Forms.Timer;$timer.Interval=250
$script:proc=$null;$script:started=$null;$script:outPath=$null;$script:errPath=$null
$timer.Add_Tick({
 if(-not $script:proc){$timer.Stop();return}
 if(-not $script:proc.HasExited -and ((Get-Date)-$script:started).TotalSeconds -lt 120){return}
 if(-not $script:proc.HasExited){
  try{$script:proc.Kill()}catch{}
  $status.Text='Timed out'
 }else{$status.Text="Completed (exit $($script:proc.ExitCode))"}
 try{
  $text=(Get-Content -LiteralPath $script:outPath -Raw -ErrorAction SilentlyContinue)
  $err=(Get-Content -LiteralPath $script:errPath -Raw -ErrorAction SilentlyContinue)
  $output.Text=($text+"\r\n"+$err)
 }catch{$output.Text=$_.Exception.Message}
 foreach($p in @($script:outPath,$script:errPath)){Remove-Item -LiteralPath $p -Force -ErrorAction SilentlyContinue}
 $script:proc.Dispose();$script:proc=$null;$run.Enabled=$true;$timer.Stop()
})
$run.Add_Click({
 if($list.SelectedIndex -lt 0 -or $script:proc){return}
 $item=$items[$list.SelectedIndex]
 $script:outPath=Join-Path $env:TEMP ("risheh-"+[guid]::NewGuid().ToString('N')+'.out')
 $script:errPath=Join-Path $env:TEMP ("risheh-"+[guid]::NewGuid().ToString('N')+'.err')
 $psi=New-Object Diagnostics.ProcessStartInfo
 $psi.FileName=$item.File;$psi.Arguments=$item.Args
 $psi.UseShellExecute=$false;$psi.CreateNoWindow=$true
 $psi.RedirectStandardOutput=$true;$psi.RedirectStandardError=$true
 # Avoid pipe deadlock by copying streams asynchronously to temporary files.
 try{
  $script:proc=New-Object Diagnostics.Process
  $script:proc.StartInfo=$psi
  $script:proc.add_OutputDataReceived({param($sender,$e) if($null -ne $e.Data){[IO.File]::AppendAllText($script:outPath,$e.Data+[Environment]::NewLine)}})
  $script:proc.add_ErrorDataReceived({param($sender,$e) if($null -ne $e.Data){[IO.File]::AppendAllText($script:errPath,$e.Data+[Environment]::NewLine)}})
  [void]$script:proc.Start()
  $script:proc.BeginOutputReadLine();$script:proc.BeginErrorReadLine()
  $script:started=Get-Date;$run.Enabled=$false
  $status.Text='Running '+$item.Name;$timer.Start()
 }catch{$output.Text=$_.Exception.Message;$run.Enabled=$true}
})
$save.Add_Click({
 $dialog=New-Object Windows.Forms.SaveFileDialog
 $dialog.Filter='Text report (*.txt)|*.txt'
 $dialog.FileName='RISHEH-diagnostics.txt'
 if($dialog.ShowDialog() -eq 'OK'){
  [IO.File]::WriteAllText($dialog.FileName,$output.Text,[Text.UTF8Encoding]::new($false))
  [Windows.Forms.MessageBox]::Show('Report saved. Review private information before sharing.')
 }
})
$form.Add_FormClosing({if($script:proc -and -not $script:proc.HasExited){try{$script:proc.Kill()}catch{}}})
[void]$form.ShowDialog()
