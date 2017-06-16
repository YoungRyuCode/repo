$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

$username = "Young.Ryu@nutanix.com"
$password = "Cool@1120"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Creds -Authentication Basic -AllowRedirection
Import-PSSession $Session

#send-mailmessage -from Young.Ryu@nutanix.com -To Young.Ryu@nutanix.com -SmtpServer smtp.office365.com -Port 587 -UseSsl -Subject "nos-alert Mailbox Statistics" -Credential $Creds
#send-mailmessage -from Young.Ryu@nutanix.com -To Young.Ryu@nutanix.com -SmtpServer smtp.office365.com -Port 587 -UseSsl -Subject $i -Credential $cred

For ($i=0; $i -le 20; $i++)
{
    Start-Sleep -S 60
    Get-MailboxStatistics -Identity "svc.mail.nos-alerts@nutanix.com" |Format-List TotalItemSize, DeletedItemCount, TotalDeletedItemSize
    #Get-MailboxFolderStatistics -Identity "svc.mail.nos-alerts@nutanix.com" -FolderScope "inbox" | Format-List ItemsInFolder
    #Get-MailboxFolderStatistics -Identity "svc.mail.nos-alerts@nutanix.com" -FolderScope "DeletedItems" | Format-List ItemsInFolder
    Get-MailboxFolderStatistics -Identity "svc.mail.nos-alerts@nutanix.com" -FolderScope "inbox" | select ItemsInFolder
    Get-MailboxFolderStatistics -Identity "svc.mail.nos-alerts@nutanix.com" -FolderScope "DeletedItems" | select ItemsInFolder

    Start-Sleep -S 60
}


Remove-PSSession $Session

Get-OrganizationConfig | FL #-FocusedInboxOn 
Get-FocusedInbox -Identity Shawn@nutanix.com
Get-FocusedInbox -Identity miranda@nutanix.com
Get-FocusedInbox -Identity Young.Ryu@nutanix.com


#Search-Mailbox -Identity "<MailboxOrMailUserIdParameter>" -DeleteContent -force

#Search-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" -SearchQuery 'Subject:"Alert Email Digest:*"' -DeleteContent 
#Search-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" -SearchQuery 'Subject:"NCC Email Digest*"' -DeleteContent 

#Search-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" -SearchQuery '(received:04/01/2017..04/30/2017)' -DeleteContent

#Get-MailboxActivityReport

#NCC Email Digest 

#Get-InboxRule -Mailbox "svc.mail.nos-alerts@nutanix.com"



#Get-mailbox "Young.Ryu@nutanix.com"

#Get-mailbox | Get-MailboxStatistics | Sort-Object TotalItemSize | Select-Object DisplayName,StorageLimitStatus,TotalItemSize 
#Get-mailbox | Get-MailboxStatistics | Sort-Object -property @{Expression="TotalItemSize";Descending=$true}


#Get-mailbox | Sort-Object TotalItemSize -Descending

#Get-Mailbox "svc.mail.nos-alerts@nutanix.com" | Get-MailboxStatistics | Select-Object DisplayName,StorageLimitStatus,ProhibitSendQuota,TotalItemSize

#Get-Mailbox "svc.mail.nos-alerts@nutanix.com" | Get-MailboxStatistics | Select-Object ProhibitSendQuota, DisplayName, TotalItemSize

#Get-Mailbox "svc.mail.nos-alerts@nutanix.com" | FL UserPrincipalName,DisplayName,ProhibitSendQuota,TotalItemSize

Get-Mailbox "svc.mail.nos-alerts@nutanix.com"

Get-ConnectionByClientTypeReport -StartDate 12/13/2015 -EndDate 12/15/2016