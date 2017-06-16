$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential

#Import Windows Azure AD module
import-module MSOnline

Get-MsolAccountSku