# Script to automate installation of Oh-MyPosh & Theme, Modules; Z, PSReadLine, Terminal-Icons, Windows Terminal conf

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Oh-My-Posh install, add to default prompt, add theme

Write-Host "Oh-MyPosh" -ForegroundColor White -BackgroundColor Blue

    $input = Read-Host "Install Oh-My-Posh? [y/n]" 
    switch($input){
            y{

                Install-Module oh-my-posh -Scope CurrentUser

            }
            n{continue}
        default{write-warning "Y or N only."}
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


# Windows Terminal setup

Write-Host "Windows Terminal default settings" -ForegroundColor White -BackgroundColor Blue

    try{
        $dest3 = "C:\Users\$env:Username\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"

        if (!(Test-Path -path $dest3)) {New-Item $dest3 -Type Directory}
        Copy-Item "settings.json" -Destination $dest3
        }
    catch{[EXCEPTION]}

    try{
        $dest4 = "C:\Users\$env:Username\Documents\PowerShell\WT_images\"

        if (!(Test-Path -path $dest4)) {New-Item $dest4 -Type Directory}
        Copy-Item "win.png","ubu.png" -Destination $dest4
        }
    catch{[EXCEPTION]}


Write-Host "Open WindowsTerminal settings.json & Ctrl+F "ADD-USERNAME"" -ForegroundColor Red -BackgroundColor Yellow