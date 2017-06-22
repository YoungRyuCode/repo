################################################################################################################
# Update Content Type in SharePoint Online Document Library
# Permission : SharePoint Admin, Global Admin or Site Owner
# 
# To run the script 
# .\UpdateContentTypeSPLibrary_Online.ps1 
# 
# Author:                 Young Ryu 
# Version:                1.0 
# Last Modified Date:     6/22/2017 
# Last Modified By:       Young.Ryu@nutanix.com
# 
# Download: https://github.com/SharePoint/PnP-PowerShell/releases
# How to Use: https://msdn.microsoft.com/en-us/pnp_powershell/pnp-powershell-overview
##################################################################################################################

Install-Module SharePointPnPPowerShellOnline
Get-Module SharePointPnPPowerShell* -ListAvailable | Select-Object Name,Version | Sort-Object Version -Descending

# Set Site Url
$siteUrl = Read-Host "Please enter your site url (i.e., https://nutanixinc.sharepoint.com/sites/dev/BU/IT ) "

#Connect SharePoint Online PnP PowerShell
Connect-PnPOnline –Url $siteUrl –Credentials (Get-Credential)

# Set variables 
$listName = Read-Host "Please enter Document Library Name (i.e., Test_Seismic) "
$newCT = Read-Host "Please type the Content Type you want to add"
$existingCT = Read-Host "Please type Content Type you want to delete"

# Add new content type to the list
Add-PnPContentTypeToList -List $listName -ContentType $newCT -DefaultContentType

# Remove content type from the list 
Remove-PnPContentTypeFromList -List $listName -ContentType $existingCT
