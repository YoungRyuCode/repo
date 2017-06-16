################################################################################################################################################################ 
# Script Get DistributionGroup in Office 365
# DL Name | Owner(s) | Allow External Senders | DL Group ID
# 
# 
# To run the script : Need "Global Admin" permission in Office365
# 
# 
# 
# Author:                 Young Ryu
# Version:                1.1 
# Last Modified Date:     5/25/2017 
# Last Modified By:       Young Ryu (Young.Ryu@nutanix.com) 
################################################################################################################################################################ 


$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Get-Distributiongroup -ResultSize Unlimited | Sort -Property RequireSenderAuthenticatioNEnabled | Select Name, Managedby, RequireSenderAuthenticationEnabled, PrimarySMTPAddress | Export-CSV "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\O365\PS_Output\Get-ListOfDL_Managers_DeliveryManagement.csv"