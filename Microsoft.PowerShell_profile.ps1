############################# Wakatime #########################################
function Test-Wakatime{

    $wakatime = $(where.exe wakatime);

    if($wakatime) {
        return $True;
    } else {
        return $False;
    }
}

$env:wakaDebug = $False

function Send-Wakatime(){
    if(!(Test-Wakatime)) {
        return;
    }
    $command = "";
    try {
        $historyItem = (Get-History |select -Last 1)
        $commandObj = ($historyItem|select -Property CommandLine).CommandLine
        $commandText = ([regex]::split($commandObj,"[ |;:]")[0])
        $command = $commandText.Replace("(","")
    } catch [Exception] {
        if($command -eq "") {
            $command = "error"
        }
    }
    $gitFolder = (Get-GitDirectory);
    Get-Job -State Completed|?{$_.Name.Contains("WakaJob")}|Remove-Job
    $job = Start-Job -Name "WakaJob" -ScriptBlock {
        param($command, $gitFolder)

        Write-Host "Sending wakatime"
        Write-Host "Waka command: $command"
        if($command -eq "") {
            return;
        }

        $PLUGIN_VERSION = "0.2";

        $wakaCommand = 'wakatime --write'
        $wakaCommand =$wakaCommand + " --plugin `"powershell-wakatime-iamkarlson-plugin/$PLUGIN_VERSION`""
        $wakaCommand =$wakaCommand + ' --entity-type app '
        $wakaCommand =$wakaCommand + ' --entity "'
        $wakaCommand =$wakaCommand +  $command
        $wakaCommand =$wakaCommand + '" '
        $wakaCommand =$wakaCommand + ' --language "PowerShell"'

        if($gitFolder -eq $null){
        } else {
            $gitFolder = (get-item ($gitFolder).Replace(".git",""))
            $wakaCommand =$wakaCommand + ' --project "'
            $wakaCommand =$wakaCommand + $gitFolder.Name
            $wakaCommand =$wakaCommand + '"'
        }
        $envwakaDebug=$env:wakaDebug
        Write-Host "wakaDebug: $envwakaDebug"
        $wakaCommand
        if($envwakaDebug){
            $wakaCommand |out-file ~/.powerwaka.log -Append
        }
        iex $wakaCommand
    } -ArgumentList $command, $gitFolder
}

function prompt {

    Send-Wakatime

    If (Test-Wakatime) {
        $wakaBgColor = "Gray"
        $wakaFgColor = "White"
        $openSymbol = "{"
        $closeSymbol = "}"

        $prompt += Write-Prompt "$openSymbol " `
        -BackgroundColor $wakaBgColor

        $prompt +=Write-Prompt ("W") `
        -ForegroundColor $wakaFgColor `
        -BackgroundColor $wakaBgColor

        if( (Get-GitDirectory) -eq $null){
        } else {
            $prompt +=Write-Prompt ("P") `
            -ForegroundColor $wakaFgColor `
            -BackgroundColor $wakaBgColor
        }
        $prompt += Write-Prompt -Object "$closeSymbol " `
        -BackgroundColor $wakaBgColor
    }

    $prompt

    & $GitPromptScriptBlock
}
