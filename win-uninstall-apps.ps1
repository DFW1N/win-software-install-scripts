######################################################################################################################################
#
#       _____  _____   _____  __  __   ____   _      
#      / ____||  __ \ |_   _||  \/  | / __ \ | |        Project:          CRIMOL-SR Transformation
#     | |     | |__) |  | |  | \  / || |  | || |        Creator:          Sacha Roussakis-Notter
#     | |     |  _  /   | |  | |\/| || |  | || |        Creation Date:    Wedensday, November 24th 2021, 09:00 am
#     | |____ | | \ \  _| |_ | |  | || |__| || |____    File:             uninstall-software.ps1
#      \_____||_|  \_\|_____||_|  |_| \____/ |______|
#
#
#   Copyright (c) 2021 Crimol Pty Ltd, Sacha Roussakis-Notter
#
#   Date                  By                  Comments
#   ---------             ---------           ------------------------------------------------
#   24/11/2021  Sacha Roussakis-Notter        Wrote code to remove app packages from Microsoft Desktop
#####################################################################################################################################


###################################
## UNINSTALL Windows 10 Software ##
###################################

## Uninstall Skype
 Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage

## Uninstall Sound Recorder
 Get-AppxPackage Microsoft.soundrecorder | Remove-AppxPackage

## Uninstall Your Phone
 Get-AppxPackage Microsoft.YourPhone -AllUsers | Remove-AppxPackage

## Uninstall MixedRealityPortal
Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage

## Uninstall Movies & Tv
Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage

## Uninstall xbox game bar
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage

## Uninstall Xbox Live
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage

## Uninstall Groove Music
remove-AppxPackage (Get-AppxPackage –AllUsers|Where{$_.PackageFullName -match "ZuneMusic"}).PackageFullName

## Uninstall Mail and Calendar
Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage

## Uninstall Microsoft Solitaire Collection
Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage

## Uninstall Microsoft Tips
Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage

## Uninstall Microsoft Bing Weather
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage

## Uninstall 3D Viewer
Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage

## Uninstall Feedback Hub
get-appxpackage *feedback* | remove-appxpackage

## Uninstall Microsoft Office
Get-AppxPackage -name “Microsoft.Office.Desktop” | Remove-AppxPackage
Get-AppxPackage *officehub* | Remove-AppxPackage

## Uninstall Media Extensions
Get-AppxPackage Microsoft.WebMediaExtensions | Remove-AppxPackage

## Uninstall OneDrive
Get-AppxPackage microsoft.microsoftskydrive | Remove-AppxPackage 

## Uninstall Cortana App
Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage

## Uninstall Windows Maps App
Get-AppxPackage *windowsmaps* | Remove-AppxPackage 

## Uninstall Microsoft People App
Get-AppxPackage Microsoft.People* | Remove-AppxPackage

## Uninstall Microsoft Get Help
Get-AppxPackage *Microsoft.GetHelp* -AllUsers | Remove-AppxPackage

## Uninstall Microsoft Store
Get-AppxPackage *WindowsStore* | Remove-AppxPackage
