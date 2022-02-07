# Script to automate installation of Oh-MyPosh & Theme, Modules; Z, PSReadLine, Terminal-Icons, Windows Terminal conf

$sep = "____________________________________________________________" 

Write-Host "James Wylde - https://github.com/jameswylde/powershell-profile-setup.git" -ForegroundColor White -BackgroundColor Red
Write-Host ""
Write-Host ""


# Install required fonts

Write-Host $sep -ForegroundColor Green
Write-Host "Installing required Nerd fonts - [1/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

    try{
        $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
        foreach ($file in Get-ChildItem .\fonts\ *.ttf)
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

Write-Host ""


# Update JSON with env:Username added to paths

Write-Host "Setting user specific json variales - [2/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

    $json = Get-Content ".\src\settings.json" | ConvertFrom-Json 
    $json.profiles.list[0].backgroundImage = "C:\Users\$env:Username\Documents\PowerShell\WT_images\win.png"
    $json | ConvertTo-Json -Depth 9 | Out-File "settings.json"


Write-Host ""

# Set PSGallery as trusted (confirm flag for Install-Module still prompt on untrusted repo

Write-Host "Setting PSGallery as trusted repo - [3/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Backing up current PS profile

Write-Host "Backing up current PS profile - [4/9]" -ForegroundColor Green

    try{
         if (test-path $profile){Rename-Item $profile -NewName Microsoft.PowerShell_profile[BACKUP].ps1}
        }
    catch{[EXCEPTION]}

    Write-Host ""

# Oh-My-Posh install, add to default prompt, add theme

Write-Host "Installing Oh-MyPosh and/or Windows Terminal - [5/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

function Install-WinGet()

        # Function for Winget from @crutkas (winget installed by def on W11)
        {
            $hasPackageManager = Get-AppPackage -name "Microsoft.DesktopAppInstaller"

            if(!$hasPackageManager)
            {
                $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"

                [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                $releases = Invoke-RestMethod -uri "$($releases_url)"
                $latestRelease = $releases.assets | Where-Object { $_.browser_download_url.EndsWith("msixbundle") } | Select-Object -First 1
            
                Add-AppxPackage -Path $latestRelease.browser_download_url
            }
        }
        Install-WinGet

        $choice1 = Read-Host "Install Windows Terminal? [y/n]" 
        switch($choice1){
                y{
    
                    winget install --id=Microsoft.WindowsTerminal -e
    
                }
                n{continue}
            default{write-warning "Y or N only."}
        }

    $choice2 = Read-Host "Install Oh-My-Posh? [y/n]" 
    switch($choice2){
            y{

                winget install JanDeDobbeleer.OhMyPosh

            }
            n{continue}
        default{write-warning "Y or N only."}
    }


Write-Host ""


# Setting OMp as prompt and adding theme
    
Write-Host "Setting Oh-My-Posh as prompt and setting theme - [6/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

    try{
        $dest = "C:\Users\$env:Username\AppData\Local\Programs\oh-my-posh\themes"

        if (!(Test-Path -path $dest)) {New-Item $dest -Type Directory}
        Copy-Item ".\src\wylde.json" -Destination $dest
        }
    catch{[EXCEPTION]}


Write-Host ""


# Module installation

Write-Host "Installing Z,PsReadLine,Terminal-Icons modules - [7/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

    try{
        Install-Module -Name z -RequiredVersion 1.1.3 -AllowClobber -confirm:$false
        Install-Module -Name Terminal-Icons -RequiredVersion 0.8.0 -confirm:$false
        #Get-InstalledModule -Name psreadline -AllVersions | Uninstall-Module
        Install-Module PSReadLine -Force -AllowPrerelease -SkipPublisherCheck
        # Install-Module -Name PSReadLine -RequiredVersion 2.2.0-beta5 -AllowPrerelease -confirm$false
        }
    catch{Write-Output $_.Exception.GetType().Name}


Write-Host ""




# Set PowerShell profile to incorporate OMP and Module settings 
Write-Host "Setting Powershell profile - [8/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

    try{
        $dest2 = "C:\Users\$env:Username\Documents\PowerShell"

        if (!(Test-Path -path $dest2)) {New-Item $dest2 -Type Directory}
        Copy-Item ".\src\Microsoft.PowerShell_profile.ps1" -Destination $dest2
        }
    catch{[EXCEPTION]}

Write-Host "NOTE - If you are using OneDrive, you may need to copy into OneDrive\Documents\Powershell" -ForegroundColor Red -BackgroundColor Yellow


Write-Host ""



# Windows Terminal setup

Write-Host "Windows Terminal default settings - [9/9]" -ForegroundColor Green
Write-Host $sep -ForegroundColor Green

    try{
        $dest3 = "C:\Users\$env:Username\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\"

        if (!(Test-Path -path $dest3)) {New-Item $dest3 -Type Directory}
        Copy-Item ".\src\settings.json" -Destination $dest3
        }
    catch{[EXCEPTION]}

    try{
        $dest4 = "C:\Users\$env:Username\Documents\PowerShell\WT_images\"

        if (!(Test-Path -path $dest4)) {New-Item $dest4 -Type Directory}
        Copy-Item ".\src\win.png" -Destination $dest4
        }
    catch{[EXCEPTION]}



Write-Host ""

