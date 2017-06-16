$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $Creds -Authentication Basic -AllowRedirection
Import-PSSession $Session

$DistributionGroups = Get-Distributiongroup -resultsize unlimited
$UserDName = read-host “Enter User Name"
$UserDName = (Get-Mailbox $User).name
"Searching which groups " + $User + " is a member of and removing membership..."
ForEach ($Group in $DistributionGroups)
{
    if ((Get-Distributiongroupmember $Group.Name | select -expand name) -contains $UserDName)
    {
        write-host "Getting user from group '$Group'"
        #Remove-DistributionGroupMember -Identity "$Group" -Member "$UserDName" -Confirm:$false
        Get-DistributionGroupMember -Identity "$Group" -Member "$UserDName" -Confirm:$false | select DisplayName,Title,PrimarySMTPAddress | Export-CSV C:\PowerShell\temp\filename.csv
    }
} 