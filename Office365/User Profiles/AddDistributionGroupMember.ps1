$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Creds -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Import-Csv "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\Workplace\O365DistribGroup\O365Distribgroup - Sales Directors.csv" |%{Add-DistributionGroupMember "Sales Directors" -Member $_.Name}
Import-Csv "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\Workplace\O365DistribGroup\O365Distribgroup - Sales Directors.csv" |%{Add-DistributionGroupMember "Sales Directors" -Member $_.ExternalEmailAddress}