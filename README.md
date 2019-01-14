# powerwaka
Powershell tracker for wakatime

## Requirements

* Basically, you need [posh-git](https://github.com/dahlbyk/posh-git) to be installed. If you don't have it you can drop out everything related to git folder detection and keep it simple. 
* Python & Pip. I hope you will find enough manuals on the internet how to do it. Later version is better, of course. More information about that you can find in the [wakatime-cli repository](https://github.com/wakatime/wakatime/)


## How to?

When you installed posh-git you should have your powershell profile similar to that:

```Powershell

function prompt {
    # Your non-prompt logic here

    # Have posh-git display its default prompt
    & $GitPromptScriptBlock
}
```

So, we're gonna replace it with our brand new stylish profile. Take it [here](https://github.com/iamkarlson/powerwaka/blob/master/Microsoft.PowerShell_profile.ps1) and put where all the profiles live: 

```
C:\Users\%USER_NAME%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

Don't forget to install wakatime-cli.

### One more thing
If you're using powershell 6 (core, or whatever) you have to put your profile specifically to the place of installation.

```Powershell
pip install wakatime
```

And here you go!


## Live working example

Check-out my [dotfiles](https://github.com/iamkarlson/dotfiles) for further info.
