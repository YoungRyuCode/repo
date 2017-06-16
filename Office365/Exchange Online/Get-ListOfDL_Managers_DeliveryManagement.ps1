#Get-DistributionGroup SG-NSD | select Displayname, Primarysmtpaddress, Managedby

#Get-DistributionGroup -ResultSize Unlimited | FT Name, RequireSenderAuthenticationEnabled |Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\DistributionGroupAllMembers\DL details\DeliveryManagement.csv"

Get-distributiongroup -ResultSize Unlimited | Sort -Property RequireSenderAuthenticatioNEnabled | Select Name, Managedby, RequireSenderAuthenticationEnabled, PrimarySMTPAddress | Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\DistributionGroupAllMembers\DL details\Get-ListOfDL_Managers_DeliveryManagement.csv"

#Get-DistributionGroup | Select-object Name,@{label=”ManagedBy”;expression={[string]($_.managedby | foreach {$_.tostring().split(“/”)[-1]})}},Primarysmtpaddress