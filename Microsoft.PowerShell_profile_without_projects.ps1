
$wakatime = $(where.exe wakatime);

function global:prompt {
  Write-Host($pwd.ProviderPath) -nonewline
  
  if($wakatime) {
      Get-Job -State Completed|?{$_.Name.Contains("WakaJob")}|Remove-Job
      $job = Start-Job -Name "WakaJob" -ScriptBlock {
        wakatime --entity-type app --project Powershell;
    }
  }
  return ">"
}
