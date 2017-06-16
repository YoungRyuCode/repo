$username = "Young.Ryu@nutanix.com"
$password = "Cool@1120"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Creds -Authentication Basic -AllowRedirection
Import-PSSession $Session


#$group = Get-DistributionGroupMember #–identity “Group Name” | Select DisplayName

#Get-DistributionGroup –ResultSize Unlimited -Identity "IT-O365" | ?{ (Get-DistributionGroupMember –identity $_.Name).Count } 

Get-DistributionGroup -ResultSize Unlimited -Identity "IT-O365" | Sort -Property RequireSenderAuthenticatioNEnabled | 
Select Name, Managedby, RequireSenderAuthenticationEnabled, PrimarySMTPAddress | ? {(Get-DistributionGroupMember –Identity $_.Name).Count} |
#Select Name, Managedby, RequireSenderAuthenticationEnabled, PrimarySMTPAddress, (Get-DLMembersRecurse $_.Name).Count | 
Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\DistributionGroupAllMembers\DL details\Get-ListOfDL_Managers_DeliveryManagement1.csv"

function Get-DLMembersRecurse ($DL) 
{
    $memlist = @()
    $mems = Get-DistributionGroupMember $dl -ResultSize unlimited
    foreach ($m in $mems) {
            if ($m.recipienttype -match "group") {          
                Get-dlmembersRecurse $m.identity
            } else {
                    if (($memlist -match $m).count -eq 0) {$memlist += $m           }
            }       
    }
    return $memlist
 }