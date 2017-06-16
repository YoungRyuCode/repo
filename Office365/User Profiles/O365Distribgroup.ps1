#################################################################################
##	Name: O365Distriblist
##	Author: Ulrich Bojko (ulrich@getinthesky.com)
##	Date: 11-09-2012
##	Details: http://wp.me/p18bZt-1al
##	Description: PowerShell Script that creates a Distributiongroup, adds 
##	Contacts from a csv-file to the group and the hides the external contacts 
##	from the Global Adress List. The cvs-file is enclosed in the download. 
##	Consult the blogpost for details				   
#################################################################################
## Edit the variables below this line. 
#################################################################################

$DistribName = "Newsletter"
$DistribDisplay = "Newsletter recievers"
$DistribSMTP = "newsletter@mycompany.com"
$DistribMember = "alias@mycompany.com"
$DistribDesc = "Description og Distributiongroup"
$CSV = ".\O365Distribgroup.csv"

#################################################################################
## Careful if you edit below this line. Dude! I'm not responsible, if you mess it up!
#################################################################################

## Login and download the Exchange Session. You will need the administratorcredentials 
#$cred=Get-Credential
#$s=New-PsSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $cred -AllowRedirection -Authentication Basic
#$importresults = Import-PSSession $s

## Create the Distributionsgroup
write-host "Creating the Distributiongroup" $Distribname -Foregroundcolor green
New-DistributionGroup -Name $DistribName -DisplayName $DistribDisplay -Alias $DistribName -PrimarySmtpAddress $DistribSMTP -Members $DistribMember -MemberDepartRestriction Closed -MemberJoinRestriction Closed -ModerationEnabled $True -ModeratedBy $DistribMember -ManagedBy $DistribMember -Notes $DistribDesc -BypassNestedModerationEnabled $True

## Add the contacts from the csvfile as external contacts 
write-host "Adding members from the CSV-file as External Contacts"  -Foregroundcolor green
Import-Csv $CSV |%{New-MailContact -Name $_.Name -DisplayName $_.Name -ExternalEmailAddress $_.ExternalEmailAddress -FirstName $_.FirstName -LastName $_.LastName}

## Update the contacts with additional information. This is optional. Outcomment, if not needed.
write-host "Updating Contacts with additional information"  -Foregroundcolor green
Import-Csv $CSV | ForEach {Set-Contact $_.Name -StreetAddress $_.StreetAddress -City $_.City -StateorProvince $_.StateorProvince -PostalCode $_.PostalCode -Phone $_.Phone -MobilePhone $_.MobilePhone -Pager $_.Pager -HomePhone $_.HomePhone -Company $_.Company -Title $_.Title -OtherTelephone $_.OtherTelephone -Department $_.Department -Fax $_.Fax -Initials $_.Initials -Notes $_.Notes -Office $_.Office -Manager $_.Manager}

## Match the Contacts from the csv-file with the external Contacts and add them to the distributiongroup
write-host "Adding the External Contacts to Distributiongroup" -Foregroundcolor green
Import-Csv $CSV |%{Add-DistributionGroupMember $DistribName -Member $_.Name}

## Hide all the Contacts from the csv-file
write-host "Hiding Contacts from Global Adress List (GAL)" -Foregroundcolor green
Import-csv $CSV |%{Set-MailContact $_.Name -HiddenFromAddressListsEnabled $true}

## Close the Exchange Session
write-host "All done, bye-bye." -Foregroundcolor green
write-host "##########################################" -Foregroundcolor green
write-host "##Drop me a FB-like or a comment, if you like this script" -Foregroundcolor green
write-host "##"  -Foregroundcolor green
write-host "## All the best, Ulrich" -Foregroundcolor green
write-host "##########################################" -Foregroundcolor green
Remove-PSSession -Id 1