$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential

#Import Windows Azure AD module
import-module MSOnline

#Connect Windows Azure AD
#Connect-AzureAD

Get-MsolUser -All -UnlicensedUsersOnly

Get-MsolAccountSku

#nutanixinc:VISIOCLIENT

Get-MsolUser -All -UnlicensedUsersOnly | Get-MsolUserLicense -AddLicenses "nutanixinc:VISIOCLIENT"

Get-MsolUserLicense

Get-MsolUser -UserPrincipalName "Young.Ryu@nutanix.com" | Select-Object UsageLocation
