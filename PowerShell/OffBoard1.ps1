$SMTPServer = "smtp.office365.com"
$SMTPPort = "587"
$SMTPCred = $LiveCred
$FromAddress = "staffing_automation@nutanix.com"

function SendNotification{
 $Msg = New-Object Net.Mail.MailMessage
 $Smtp = New-Object Net.Mail.SmtpClient($SMTPServer, $SMTPPort)
 $Smtp.EnableSsl = $true
 $Smtp.Credentials = $SMTPCred
 $Msg.From = $FromAddress
 $MSg.To.Add($ToAddress)
 $Msg.Subject = $Subject
 $Msg.Body = $EmailBody
 $Msg.IsBodyHTML = $true
 $Smtp.Send($Msg)
}

#$O365 = Get-MsolUser -all | Where-Object {$_.isLicensed -eq "true"} | Select userprincipalname -expandproperty userprincipalname

#$FTE = $O365 | % {Get-ADUser -Properties * -fi "userprincipalname -eq '$($_.userprincipalname)'" -searchbase "OU=Disabled Users,OU=Nutanix,DC=corp,DC=nutanix,DC=com"} | Where-Object {($_.Enabled -like 'False')}

#$Disabled = get-msoluser -returndeletedusers | Where-Object {($_.islicensed -like 'true*') -and ($_.userprincipalname -notlike "*svc*")}

#$FTE = $Disabled | % {Get-ADUser -Properties * -fi "userprincipalname -eq '$($_.userprincipalname)'" -searchbase "OU=Disabled Users,OU=Nutanix,DC=corp,DC=nutanix,DC=com"}

$O365 = Get-MsolUser -all | Where-Object {$_.isLicensed -eq "true"} | Select userprincipalname -expandproperty userprincipalname

$Disabled = $O365 | % {Get-ADUser -Properties * -fi "userprincipalname -eq '$($_.userprincipalname)'" -searchbase "OU=Disabled Users,OU=Nutanix,DC=corp,DC=nutanix,DC=com"}

$Incidents = Get-ServiceNowIncident -MatchContains @{subcategory='Termination'} -limit 1000 | select *

$Disabled | ForEach {

$Name = $_.Name
$SAM = $_.SamAccountName
$DN = $_.DistinguishedName
$INCNumber = $Incidents | Where-Object {($_.short_description-like "*$Name*") -and ($_.state -notlike "*Closed*")} | Select Number -expandproperty number
$UPN = $_.Userprincipalname

if ($Incidents.short_description -like "*$Name*") { $Name,$SAM,$INCNumber,$UPN}

$DN = Get-ADuser $SAM -properties * | Select DistinguishedName -expandproperty DistinguishedName

$chars = [char[]]"abcdefghijkmnpqrstuvwxyz"
		$charsUp = [char[]]"ABCDEFGHJKLMNPQRSTUVWXYZ"
		$numbers = [char[]]"123456789"
		$symbols = [char[]]"!@%$#?&*+"
		$Password = (($chars | Get-Random -Count 1)+
			($charsUp | Get-Random -Count 1)+
			($symbols | Get-Random -Count 1)+
			($numbers | Get-Random -Count 1)+
			($charsUp | Get-Random -Count 1)+
			($symbols | Get-Random -Count 1)+
			($numbers | Get-Random -Count 1)+
			($charsUp | Get-Random -Count 1)+
			($symbols | Get-Random -Count 1)+
			($numbers | Get-Random -Count 1)+
			($charsUp | Get-Random -Count 1)+
			($symbols | Get-Random -Count 1)+
			($numbers | Get-Random -Count 1)+
			($charsUp | Get-Random -Count 1)+
			($symbols | Get-Random -Count 1)+
			($numbers | Get-Random -Count 1)+
			($charsUp | Get-Random -Count 1)+
			($symbols | Get-Random -Count 1)+
			($numbers | Get-Random -Count 1)+
			($charsUp | Get-Random -Count 1)+
			($symbols | Get-Random -Count 1)+
			($numbers | Get-Random -Count 1)+
			($chars| Get-Random -Count 1)) -join ""
			
		Set-ADAccountPassword $DN -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force) 
		
		Set-GAUser $UPN -Suspended $True -OrgUnitPath "/Former Employee"

		#Restore-MsolUser -userprincipalname $UPN
		
		$ADGroups = Get-ADUser $SAM -Properties * | select memberof -expandproperty memberof

        $ADgroups | ForEach {Remove-ADGroupMember -Confirm:$false  -Identity $_ -Members $SAM}
		
		$SlackID = $_ | Select extensionattribute9 -expandproperty extensionattribute9

		$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
		$Headers.Add("Accept", 'application/json')
		$Headers.Add("Content-Type", 'application/json')
		$Headers.Add("Authorization", 'Bearer xoxp-2172428722-15666521541-101608220449-8c22a888eecb4af5c6ce929b85be0beb')

		$Body ='{"active": false}'

		$Uri = "https://api.slack.com/scim/v1/Users/"+$SlackID

		Invoke-RestMethod -Method PATCH $Uri -Headers $Headers -Body $Body
		
		#Start-Sleep -s 300
		
		#Set-Mailbox $UPN -Type Shared -displayname "Termed - $($_.DisplayName)"
		
		#Set-Mailbox $UPN -Type Shared -displayname "Termed - $Name"
		
		Set-Mailbox $UPN -Type Shared
		
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:ENTERPRISEPACK"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:PROJECTCLIENT"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:VISIOCLIENT"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:POWER_BI_STANDARD"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:EXCHANGESTANDARD"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:PROJECTPREMIUM"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:PLANNERSTANDALONE"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:EMS"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:POWERAPPS_INDIVIDUAL_USER"
		Set-MsolUserLicense -UserPrincipalName $_.userprincipalname -RemoveLicenses "nutanixinc:YAMMER_ENTERPRISE_STANDALONE"
		
		Set-CASMailbox $_.userprincipalname -ActiveSyncEnabled $False -OWAEnabled $False -OWAforDevicesEnabled $False

		Set-Mailbox -HiddenFromAddressListsEnabled $true -Identity $UPN

		Set-MsolUser -UserPrincipalName $UPN -BlockCredential $true

		$mailbox = get-Mailbox $UPN
		$DN = $mailbox.DistinguishedName
		$MBName = $mailbox.DisplayName
		$Filter = "Members -like ""$DN"""
		$DGs = Get-DistributionGroup -ResultSize Unlimited -Filter $Filter
		
		ForEach	($dg in $DGs) { 

        Remove-DistributionGroupMember $dg.name -Member $MBName -confirm:$false
		
		}
		
$INCNumber | ForEach {
		
		$ToAddress = "help@nutanix.com"
		$Subject = "RE: Incident $_"
		
		$EmailBody = @"
 <html>
 <head>
 </head>
 <body>
 

 <dir><span style='font-family:Arial;font-size:10pt'>
 <li> - Moved To Disabled Users OU</li>
 <li> - AD Password Reset</li>
 <li> - Google Account Access Suspended</li>
 <li> - Slack Account Disabled</li>
 <li> - Shared Mailbox Created ($Name)</li>
 <li> - Removed From All AD Groups</li>
 <li> - Shared Mailbox Created</li>
 <li> - O365 Licenses Removed</li>
 <li> - O365 Account Blocked</li>
 <li> - Hidden From Global Address Book</li>
 <li> - Removed From All Distribution Lists</li>
 </dir></span>

 </body>
 </html>
"@

#if ($_ -ne $Null) {SendNotification}

SendNotification

}

clear-variable INCnumber


}

<li> - Shared Mailbox Created (Termed - $Name)</li>