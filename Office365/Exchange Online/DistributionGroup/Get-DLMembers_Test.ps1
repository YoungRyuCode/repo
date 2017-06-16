#$Name = Get-DistributionGroup -ResultSize Unlimited -Identity "IT-O365" | Select Name
$Name = Get-DistributionGroup -ResultSize Unlimited
write-host $Name
#Wirte-host $Name
(Get-DistributionGroupMember $Name).Count
#(Get-DistributionGroupMember -ResultSize unlimited "hq").Count


#$group = Get-DistributionGroup –identity "Team-Sales" | Select Name 
#(Get-DistributionGroupMember $group).Count


(Get-DistributionGroupMember –identity "Apac-Se-Leads").Count


$GN = gc d:\distros.txt
foreach($name in $GN) {
    $Count = (Get-DistributionGroupMember -Identity $name | select name).count
    Write-host -ForegroundColor Cyan "$name has $Count members"
}