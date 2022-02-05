# Script to automate installation of Oh-MyPosh & Theme, Modules; Z, PSReadLine, Terminal-Icons, Windows Terminal conf

# Oh-My-Posh install, add to default prompt, add theme

Write-Host "Oh-MyPosh" -ForegroundColor White -BackgroundColor Blue

    $input = Read-Host "Install Oh-My-Posh? [y/n]" 
    switch($input){
            y{

                Install-Module oh-my-posh -Scope CurrentUser

            }
            n{continue}
        default{write-warning "    Y or N only."}
    }
    
Write-Host "Setting Oh-My-Posh as prompt and setting theme" -ForegroundColor White -BackgroundColor Blue

    try{
        $dest = "C:\Users\$env:Username\AppData\Local\Programs\oh-my-posh\themes"

        if (!(Test-Path -path $dest)) {New-Item $dest -Type Directory}
        Copy-Item "wylde.json" -Destination $dest
        }
    catch{[EXCEPTION]}


# Module installation

Write-Host "Installing Z,PsReadLine,Terminal-Icons" -ForegroundColor White -BackgroundColor Blue

    try{
        Install-Module -Name z -RequiredVersion 1.1.3 -confirm:$false
        Install-Module -Name Terminal-Icons -RequiredVersion 0.8.0 -confirm:$false
        Install-Module -Name PSReadLine -AllowPrerelease -confirm:$false
        }
    catch{[EXCEPTION]}


Write-Host "Setting Powershell profile" -ForegroundColor White -BackgroundColor Blue


try{
    $dest2 = "C:\Users\$env:Username\Documents\PowerShell"

    if (!(Test-Path -path $dest2)) {New-Item $dest2 -Type Directory}
    Copy-Item "Microsoft.PowerShell_profile.ps1" -Destination $dest2
    }
catch{[EXCEPTION]}

Write-Host "NOTE - If you are using OneDrive, you may need to copy into OneDrive\Documents\Powershell" -ForegroundColor Red -BackgroundColor Yellow


# C:\Users\$env:Username\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState