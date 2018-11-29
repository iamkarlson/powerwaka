
$wakatime = $(where.exe wakatime);

function global:prompt {
  Write-Host($pwd.ProviderPath) -nonewline
  
  if($wakatime) {
    wakatime --entity-type app --project Powershell;
  }
  return ">"
}
