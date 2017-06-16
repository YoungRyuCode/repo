#https://github.com/SharePoint/PnP-PowerShell
#https://github.com/SharePoint/PnP-PowerShell/blob/master/Documentation/readme.md
#https://github.com/SharePoint/PnP-PowerShell/blob/master/Documentation/EnablePnPFeature.md
#https://github.com/SharePoint/PnP-PowerShell/blob/master/Documentation/GetPnPFeature.md
#https://blogs.msdn.microsoft.com/razi/2013/10/28/listing-all-sharepoint-server-2013-features-including-name-title-scope-id-and-description/

Install-Module SharePointPnPPowerShellOnline

Get-Module SharePointPnPPowerShell* -ListAvailable | Select-Object Name,Version | Sort-Object Version -Descending

#Update-Module SharePointPnPPowerShell

Connect-PnPOnline –Url "https://nutanixinc.sharepoint.com/BU/SABD/NutanixReady" –Credentials (Get-Credential)

#Get-Command -Module *PnP*


#Enable-PnPFeature -Identity "94c94ca6-b32f-4da9-a9e3-1f3d343d7ecb" -Force #PublishWeb
Enable-PnPFeature -Identity "00bfea71-d8fe-4fec-8dad-01c19a6e4053" -Force #Wiki Home Page
Enable-PnPFeature -Identity "961d6a9c-4388-4cf2-9733-38ee8c89afd4" -Force #Site Pages (RollupPages)
Enable-PnPFeature -Identity "f151bb39-7c3b-414f-bb36-6bf18872052f" -Force #Site Notebook


Get-PnPFeature -Scope Web

Get-SPOFeature | where { $_.DisplayName -like "Site Notebook" }