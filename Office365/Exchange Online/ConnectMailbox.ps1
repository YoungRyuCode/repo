$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Get-mailbox "Young.Ryu@nutanix.com"

#Get-mailbox | Get-MailboxStatistics | Sort-Object TotalItemSize | Select-Object DisplayName,StorageLimitStatus,TotalItemSize 
#Get-mailbox | Get-MailboxStatistics | Sort-Object -property @{Expression="TotalItemSize";Descending=$true}


#Get-mailbox | Sort-Object TotalItemSize -Descending

#Get-Mailbox "svc.mail.nos-alerts@nutanix.com" | Get-MailboxStatistics | Select-Object DisplayName,StorageLimitStatus,ProhibitSendQuota,TotalItemSize

#Get-Mailbox "svc.mail.nos-alerts@nutanix.com" | Get-MailboxStatistics | Select-Object ProhibitSendQuota, DisplayName, TotalItemSize

#Get-Mailbox "svc.mail.nos-alerts@nutanix.com" | FL UserPrincipalName,DisplayName,ProhibitSendQuota,TotalItemSize

Get-Mailbox "svc.mail.nos-alerts@nutanix.com"

Get-Mailbox "svc.mail.nos-asups@nutanix.com"

Get-Mailbox "Young.Ryu@nutanix.com" -Monitoring

Get-Mailbox "miranda@nutanix.com"

#Get-Mailbox -resultsize unlimited| Add-mailboxpermission -user admin@yourdomain.com -AccessRights FullAccess -Automapping $false

#run this command to give the account access to a single mailbox:

#Add-mailboxpermission –identity user@yourdomain.com -user admin@yourdomain.com -AccessRights FullAccess -Automapping $false

#Get-MailboxStatistics -Identity "Young.Ryu@nutanix.com"

#Get-MailboxDatabase | Get-MailboxStatistics -Filter 'DisconnectDate -ne $null'

Test-MapiConnectivity -Identity "svc.mail.nos-alerts@nutanix.com"
Test-MapiConnectivity -Identity "svc.mail.nos-asups@nutanix.com"

Get-MailboxPermission -Identity "Young.Ryu@nutanix.com"