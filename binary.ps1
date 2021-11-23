
####################
## PWSH VARIABLES ##
####################

$tempfolder = "C:\temp\"
$logFile = "c:\temp\" + (get-date -format 'yyyyMMdd') + '_aibsoftwareinstall.log'
$sasToken  = "sp=racwdyti&st=2021-11-23T12:04:05Z&se=2022-07-07T20:04:05Z&spr=https&sv=2020-08-04&sr=b&sig=TWRwaBbQkIHbHobDd0RIzg%2Bvqqbbxf93JZs2di5oHdc%3D"
$storageAccountName = "saswtransac1sacha"
$containerName = "softwarefiles"
$swblobname="software.zip"
#$serverhostname = $env:COMPUTERNAME + "$"

###################
## UNZIP FUNCTION #
###################

Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

#####################
## FOLDER CREATION ##
#####################

New-Item -ItemType Directory -Force -Path $tempfolder

##########################
## AZURE MODULE IMPORTS ##
##########################
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser -force
Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Scope CurrentUser -Force
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name Az.storage -Repository PSGallery -Scope CurrentUser -Force
Import-module AZ.storage

##########################
## SET LOGGING FUNCTION ##
##########################

function Write-Log {
    Param($message)
    Write-Output "$(get-date -format 'yyyyMMdd HH:mm:ss') $message" | Out-File -Encoding utf8 $logFile -Append
}

###############################
## DOWNLOAD BINARIES FROM SA ##
###############################

$downloadsFolder = $tempfolder + "downloads"
New-Item -ItemType Directory -Force -Path $downloadsFolder | Out-File $logFile -Append
$context = New-AzStorageContext $storageAccountName -SasToken $sasToken -ErrorAction SilentlyContinue
Get-AzStorageBlobContent -Container $ContainerName -Blob $swblobname  -Destination $downloadsFolder -Context $context -ErrorAction SilentlyContinue | Out-File $logFile -Append

####################
## UNZIP BINARIES ##
####################

"Unzip software file"| Out-File $logFile -Append
Unzip "$downloadsFolder\$swblobname" $downloadsFolder | Out-File $logFile -Append

#######################
## INSTALL NOTEPAD++ ##
#######################

try {
    Start-Process -filepath "$downloadsFolder\software\npp.8.1.9.Installer.exe" -Wait -ErrorAction Stop -ArgumentList '/S'
    if (Test-Path "C:\Program Files (x86)\Notepad++\notepad++.exe") {
        Write-Log "Notepad++ has been installed"
    }
    else {
        write-log "Error locating the Notepad++ executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing Notepad++: $ErrorMessage"
}

#########################
## INSTALL ADOBEREADER ##
#########################

try {
    Start-Process -FilePath "$downloadsFolder\software\AcroRdrDC2100720099_en_US.exe" -Wait -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES"
    # Wait for the installation to finish.
    # display in powershell the output of the command below
    if (Test-Path "C:\Program Files\Adobe\Acrobat DC\Acrobat\Acrobat.exe") {
        Write-Log "adobereader has been installed"
    }
    else {
        write-log "Error locating the adobereader executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing adobereader: $ErrorMessage"
}

##################
## INSTALL 7ZIP ##
##################
    
try {
    Start-Process -FilePath "$downloadsFolder\software\7z1900-x64.exe" -Wait -ArgumentList "/S"
    # Wait for the installation to finish.
    if (Test-Path "C:\Program Files\7-Zip\7zFM.exe") {
        Write-Log "7ZIP has been installed"
    }
    else {
        write-log "Error locating the 7ZIP executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing 7ZIP: $ErrorMessage"
}

####################
## INSTALL WINSCP ##
####################

try {
    Start-Process -FilePath "$downloadsFolder\software\WinSCP-5.19.4-Setup.exe" -Wait -ArgumentList "/VERYSILENT /NORESTART /ALLUSERS"
    # Wait for the installation to finish.
    if (Test-Path "C:\Program Files (x86)\WinSCP\WinSCP.exe") {
        Write-Log "Winscp has been installed"
    }
    else {
        write-log "Error locating the Winscp executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing Winscp: $ErrorMessage"
}

################################
## INSTALL Visual Studio Code ##
################################

Start-Process -FilePath "$downloadsFolder\software\VSCodeSetup-x64-1.62.3.exe" -Wait -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode"
# Wait for the installation to finish.
if (Test-Path "C:\Program Files\Microsoft VS Code\Code.exe") {
    Write-Log "Visual Studio Code has been installed"
}
else {
    write-log "Error locating the Visual Studio Code executable"
}

################################
## INSTALL Visual C++ RunTime ##
################################

Start-Process -FilePath "$downloadsFolder\software\vc_redist.x86.exe" -Wait -ArgumentList "/install /quiet /norestart"
# Wait for the installation to finish.
if (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat") {
    Write-Log "Visual C++ Runtime has been installed"
}
else {
    write-log "Error locating the Visual C++ Runtime executable"
}

#####################
## INSTALL OpenSSH ##
#####################

Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
# Start the sshd service
Start-Service sshd

# OPTIONAL but recommended:
Set-Service -Name sshd -StartupType 'Automatic'

# Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
    Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
} else {
    Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
}


###################
## INSTALL PuTTY ##
###################

try {
    Set-Location C:\temp\downloads\software
    MsiExec.exe /i putty-64bit-0.76-installer.msi /qn
    # Wait for the installation to finish.
    Start-Sleep -s 90
    if (Test-Path "C:\Program Files\PuTTY\PuTTY.exe") {
        Write-Log "Putty has been installed"
    }
    else {
        write-log "Error locating the Putty executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing Putty: $ErrorMessage"
}

########################
## INSTALL SUPERPuTTY ##
########################

try {
    Set-Location C:\temp\downloads\software
    MsiExec.exe /i SuperPuttySetup-1.4.0.9.msi /qn
    # Wait for the installation to finish.
    Start-Sleep -s 100
    if (Test-Path "C:\Program Files (x86)\SuperPuTTY\SuperPuTTY.exe") {
        Write-Log "SuperPuTTY has been installed"
    }
    else {
        write-log "Error locating the SuperPuTTY executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing SuperPuTTY: $ErrorMessage"
}


###################
## INSTALL SQLMS ##
###################

try {
    $InstallerSQL = "$downloadsFolder\software\SSMS-Setup-ENU.exe"; 
    Start-Process $InstallerSQL /Quiet -Wait
    # Wait for the installation to finish.
    if (Test-Path "C:\Program Files (x86)\Microsoft SQL Server\150\Tools\Binn\ManagementStudio\Ssms.exe") {
        Write-Log "SQL MS studio has been installed"
    }
    else {
        write-log "Error locating the SQL MS studio executable"
    }
}
catch {
    $ErrorMessage = $_.Exception.message
    write-log "Error installing SQL MS studio: $ErrorMessage"
}


#################
## INSTALL GIT ##
#################

Start-Process -FilePath "$downloadsFolder\software\Git-2.33.1-64-bit.exe" -Wait -ArgumentList "/SILENT"
# Wait for the installation to finish

####################################
## COPY VS code extensions SCRIPT ##
####################################

Copy-Item -Path "$downloadsFolder\*.vsix" -Destination "C:\Program Files\Microsoft VS Code\resources\app\extensions\" -Recurse


#####################
## END PWSH SCRIPT ##
#####################
