# Script to automate installation of Oh-MyPosh & Theme, Modules; Z, PSReadLine, Terminal-Icons, Windows Terminal conf

$sep = "____________________________________________________________" 





# Install required fonts


Write-Output "Installing required Nerd fonts" 
try{
    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
    foreach ($file in Get-ChildItem *.ttf)
    {
        $fileName = $file.Name
        if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
            Write-Output $fileName
            Get-Childitem $file | ForEach-Object{ $fonts.CopyHere($_.fullname) }
        }
    }
    #Copy-Item *.ttf c:\windows\fonts\
    }
catch{[EXCEPTION]}
Write-Output $sep -ForegroundColor White -BackgroundColor Blue
Write-Output ""





# Set PSGallery as trusted (confirm flag for Install-Module still prompt on untrusted repo

Write-Output "Setting PSGallery as trusted repo (revert if needed)"

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Oh-My-Posh install, add to default prompt, add theme

Write-Output "Oh-MyPosh" -ForegroundColor White -BackgroundColor Blue

    $input = Read-Host "Install Oh-My-Posh? [y/n]" 
    switch($input){
            y{

                winget install JanDeDobbeleer.OhMyPosh

            }
            n{continue}
        default{write-warning "Y or N only."}
    }

Write-Output $sep -ForegroundColor White -BackgroundColor Blue
Write-Output ""



# Setting OMp as prompt and adding theme
    
Write-Output "Setting Oh-My-Posh as prompt and setting theme" -ForegroundColor White -BackgroundColor Blue

    try{
        $dest = "C:\Users\$env:Username\AppData\Local\Programs\oh-my-posh\themes"

        if (!(Test-Path -path $dest)) {New-Item $dest -Type Directory}
        Copy-Item "wylde.json" -Destination $dest
        }
    catch{[EXCEPTION]}

Write-Output $sep -ForegroundColor White -BackgroundColor Blue
Write-Output ""



# Module installation

Write-Output "Installing Z,PsReadLine,Terminal-Icons" -ForegroundColor White -BackgroundColor Blue

    try{
        Install-Module -Name z -RequiredVersion 1.1.3 -confirm:$false
        Install-Module -Name Terminal-Icons -RequiredVersion 0.8.0 -confirm:$false
        Remove-Module -Name PSReadLine
        Install-Module -Name PSReadLine -RequiredVersion 2.2.0-beta5 -AllowPrerelease -confirm$false
        }
    catch{[EXCEPTION]}

Write-Output $sep -ForegroundColor White -BackgroundColor Blue
Write-Output ""




# Set PowerShell profile to incorporate OMP and Module settings 
Write-Output "Setting Powershell profile" -ForegroundColor White -BackgroundColor Blue
Write-Output ""

    try{
        $dest2 = "C:\Users\$env:Username\Documents\PowerShell"

        if (!(Test-Path -path $dest2)) {New-Item $dest2 -Type Directory}
        Copy-Item "Microsoft.PowerShell_profile.ps1" -Destination $dest2
        }
    catch{[EXCEPTION]}

Write-Output "NOTE - If you are using OneDrive, you may need to copy into OneDrive\Documents\Powershell" -ForegroundColor Red -BackgroundColor Yellow
Write-Output ""
Write-Output $sep -ForegroundColor White -BackgroundColor Blue
Write-Output ""



# Windows Terminal setup

Write-Output "Windows Terminal default settings" -ForegroundColor White -BackgroundColor Blue

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


Write-Output "Open WindowsTerminal settings.json & Ctrl+F "ADD-USERNAME"" -ForegroundColor Red -BackgroundColor Yellow

Write-Output $sep -ForegroundColor White -BackgroundColor Blue
Write-Output ""