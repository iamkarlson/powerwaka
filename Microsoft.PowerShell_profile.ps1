
$wakatime = $(where.exe wakatime);
if($wakatime) {
    $PLUGIN_VERSION = "0.1";
}

function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host($pwd.ProviderPath) -nonewline

    Write-VcsStatus



    if($wakatime) {

        $gitFolder = (get-item (Get-GitDirectory).Replace(".git",""))

        if($gitFolder){

            try{
                $command = (Get-History -Count 1|select -Property CommandLine).CommandLine.Split(" ")[0].Replace("(","")
            } catch{
                $command = "error"
            }

            wakatime `
            --plugin "powershell-wakatime-iamkarlson-plugin/$PLUGIN_VERSION" `
            --entity-type app `
            --entity $command `
            --project $gitFolder.Name `
            --language PowerShell
        } else {
            wakatime --entity-type app --project Powershell;
        }
    }

    $global:LASTEXITCODE = $realLASTEXITCODE
    return ">"
}
