# Script to automate installation of Oh-MyPosh & Theme, Modules; Z, PSReadLine, Terminal-Icons, Windows Terminal conf

$sep = "____________________________________________________________" 





# Install required fonts

Write-Host $sep -ForegroundColor Green
Write-Host "Installing required Nerd fonts" -ForegroundColor Green
try{
    $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
    foreach ($file in Get-ChildItem *.ttf)
    {
        $fileName = $file.Name
        if (-not(Test-Path -Path "C:\Windows\fonts\$fileName" )) {
            Write-Host $fileName
            Get-Childitem $file | ForEach-Object{ $fonts.CopyHere($_.fullname) }
        }
    }
    #Copy-Item *.ttf c:\windows\fonts\
    }
catch{[EXCEPTION]}
Write-Host $sep -ForegroundColor Green
Write-Host ""


# Update JSON with env:Username added to paths

Write-Host "Setting user specific json variales" -ForegroundColor Green

    $json = Get-Content "settings.json" | ConvertFrom-Json 
    $json.profiles.list[0].backgroundImage = "C:\Users\$env:Username\Documents\PowerShell\WT_images\win.png"
    $json | ConvertTo-Json -Depth 9 | Out-File "settings.json"

Write-Host $sep -ForegroundColor Green
Write-Host ""

# Set PSGallery as trusted (confirm flag for Install-Module still prompt on untrusted repo

Write-Host "Setting PSGallery as trusted repo (revert if needed)" -ForegroundColor Green

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Oh-My-Posh install, add to default prompt, add theme

Write-Host "Installing Oh-MyPosh" -ForegroundColor Green

    $input = Read-Host "Install Oh-My-Posh? [y/n]" 
    switch($input){
            y{

                winget install JanDeDobbeleer.OhMyPosh

            }
            n{continue}
        default{write-warning "Y or N only."}
    }

Write-Host $sep -ForegroundColor Green
Write-Host ""



# Setting OMp as prompt and adding theme
    
Write-Host "Setting Oh-My-Posh as prompt and setting theme" -ForegroundColor Green

    try{
        $dest = "C:\Users\$env:Username\AppData\Local\Programs\oh-my-posh\themes"

        if (!(Test-Path -path $dest)) {New-Item $dest -Type Directory}
        Copy-Item "wylde.json" -Destination $dest
        }
    catch{[EXCEPTION]}

Write-Host $sep -ForegroundColor Green
Write-Host ""



# Module installation

Write-Host "Installing Z,PsReadLine,Terminal-Icons" -ForegroundColor Green

    try{
        Install-Module -Name z -RequiredVersion 1.1.3 -confirm:$false
        Install-Module -Name Terminal-Icons -RequiredVersion 0.8.0 -confirm:$false
        Get-InstalledModule -Name psreadline -AllVersions | Uninstall-Module
        Install-Module PSReadLine -Force -AllowPrerelease -SkipPublisherCheck
        # Install-Module -Name PSReadLine -RequiredVersion 2.2.0-beta5 -AllowPrerelease -confirm$false
        }
    catch{Write-Output $_.Exception.GetType().Name}

Write-Host $sep -ForegroundColor Green
Write-Host ""




# Set PowerShell profile to incorporate OMP and Module settings 
Write-Host "Setting Powershell profile" -ForegroundColor Green
Write-Host ""

    try{
        $dest2 = "C:\Users\$env:Username\Documents\PowerShell"

        if (!(Test-Path -path $dest2)) {New-Item $dest2 -Type Directory}
        Copy-Item "Microsoft.PowerShell_profile.ps1" -Destination $dest2
        }
    catch{[EXCEPTION]}

Write-Host "NOTE - If you are using OneDrive, you may need to copy into OneDrive\Documents\Powershell" -ForegroundColor Red -BackgroundColor Yellow
Write-Host ""
Write-Host $sep -ForegroundColor Green
Write-Host ""



# Windows Terminal setup

Write-Host "Windows Terminal default settings" -ForegroundColor Green

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


Write-Host $sep -ForegroundColor Green
Write-Host ""

