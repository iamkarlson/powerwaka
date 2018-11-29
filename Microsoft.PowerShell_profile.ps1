
$wakatime = $(where.exe wakatime);
if($wakatime) {
    $PLUGIN_VERSION = "0.1";
}

function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus



    if($wakatime) {
        $job = Start-Job -ScriptBlock {
            $gitFolder = (Get-GitDirectory);

            if($gitFolder -eq $null){
                wakatime --write --entity-type app --entity Powershell;
            } else {
                $gitFolder = (get-item ($gitFolder).Replace(".git",""))

                $command = "";
                try{
                $command = (Get-History -Count 1|select -Property CommandLine).CommandLine.Split(" ")[0].Replace("(","")
                } catch{
                    $command = "error"
                }

                wakatime --write --plugin "powershell-wakatime-iamkarlson-plugin/$PLUGIN_VERSION" `
                --entity-type app `
                --entity "$command" `
                --project $gitFolder.Name `
                --language PowerShell
            }
        }
    }

    $global:LASTEXITCODE = $realLASTEXITCODE
    return ">"
}
