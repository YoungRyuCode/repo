$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential

#Import Windows Azure AD module
import-module MSOnline

#Connect Windows Azure AD
Connect-AzureAD

#Get-ADUser -Filter {UserPrincipalName -eq $_.UserPrincipalName} -Properties Manager
#Get-ADUser -Identity Young.Ryu -Properties manager | Select-Object -Property @{label='Supervisor';expression={$_.manager}}

#$userName = "Young.Ryu@nutanix.com"
#Get-AzureADUser | select $userName,@{n="Manager";e={(Get-AzureADUser -ObjectId (Get-AzureADUserManager -ObjectId $_.ObjectId).ObjectId).UserPrincipalName}}
#Get-AzureADUser | select UserPrincipalName,@{n="Manager";e={(Get-AzureADUser -ObjectId (Get-AzureADUserManager -ObjectId $_.ObjectId).ObjectId).UserPrincipalName}}

#$user = Get-AzureADUser -ObjectId “Young.Ryu@nutanix.com”
#$user.DisplayName


Get-AzureADUserManager -ObjectId “Young.Ryu@nutanix.com”
Get-AzureADUserManager -ObjectId “miranda@nutanix.com”