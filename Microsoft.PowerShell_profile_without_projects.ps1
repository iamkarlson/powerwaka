
$wakatime = $(where.exe wakatime);

function global:prompt {
  Write-Host($pwd.ProviderPath) -nonewline
  
  if($wakatime) {
    $job = Start-Job -ScriptBlock {
      wakatime --entity-type app --project Powershell;
    }
  }
  return ">"
}
