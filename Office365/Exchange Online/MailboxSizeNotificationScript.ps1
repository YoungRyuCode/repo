#Exchange Online Mailbox Size Notification Script
#
#Notifies users when their mailbox is approaching the size limit
#
#By Chad Mosman, MessageOps, www.messageops.com
#

#Email address that the notification email will appear to be from
$mailFrom = "svc.sharepoint@nutanix.com"

#If inbound mailflow is not enabled on your domain in Microsoft Online, change this value
#to your on-premise mail server which should forward to Microsoft Online
$smtpServer = "mail.global.frontbridge.com"

#Microsoft Online Service Account Username and Password
$powerUser = "Young.Ryu@nutanix.com"
$powerPass = "Cool@1120"

#If sending a final report to the admin enter the email address the final report should be sent to
$adminemail = "svc.sharepoint@nutanix.com"
#Enter the subject for the report sent to admin
$adminsubject = "Mailbox Quota Report"

#Warning Levels, each level is percentage of quota used. Emails to users are customized based on level
$Level1 = 75
$Level2 = 85
$Level3 = 95

$supportcollection=@()

$password = ConvertTo-SecureString $powerPass -AsPlainText -Force
$adminCredential = New-Object -TypeName System.Management.Automation.PSCredential -argumentlist $powerUser,$password

#Get all the enabled users
$enabledusers = get-msonlineuser -Credential $AdminCredential -Enabled -ResultSize 10000

#Get the mailbox size and item count for each user.

ForEach($user in $enabledUsers){
If ($user.mailboxsize -gt 0){
$mailbox = get-msonlineuser -identity $user.identity -Credential $AdminCredential -SourceDetail Full

$quota=$mailbox.UsedMailboxsize / $user.MailboxSize * 100
$quota = "{0:N0}" -f $quota
$quota = [int]$quota

$quotausersobj= "" | select Name,QuotaUsed
$quotausersobj.Name=$user.identity
$quotausersobj.QuotaUsed=$quota
$supportcollection += $quotausersobj

If ($quota -ge $Level1){

If ($quota -ge $Level3){
$subject = "IMMEDIATE ACTION REQUIRED: Your Mailbox has Exceeded the Quota Size"
$body = "Your mailbox is currently at",$quota,"% of the allowed quota. Failure to immediately reduce the size of your mailbox will result in the inability to send or receive mail."
}
ElseIf ($quota -ge $Level2){
$subject = "IMMEDIATE ACTION REQUIRED: Your Mailbox is about to Exceed the Quota Size"
$body = "Your mailbox is currently at",$quota,"% of the allowed quota. If you do not reduce the size of your mailbox now, you will not be able to send or receive mail."
}
Else{
$subject = "ACTION REQUIRED: Your Mailbox is Approaching the Quota Size"
$body = "Your mailbox is currently at",$quota,"% of the allowed quota. If you do not reduce the size of your mailbox soon, you may not be able to send or receive mail."
}

$body = $body + "To reduce the size of your mailbox, please following these instructions."

#Send notification to user. Comment out next 2 lines if testing.
#$smtp = new-object Net.Mail.SmtpClient($smtpServer)
#$smtp.Send($mailFrom, $user.Identity, $subject, $body)

#Write Results to console. Uncomment next 5 lines if testing.
write-host "Mail from: ", $mailfrom
write-host "Mail to: ", $user.Identity
write-host "Subject: ", $subject
write-host "Body: ", $body
write-host
}
}
}

#Send a report to the admin which lists the quotas used by all users

#Sort the list from highest quota usage to smallest
$supportCollection = $supportcollection | sort @{expression="QuotaUsed";Descending=$true}
$supportbody = "User Identity,Quota Used,Over Limit`n`n"

ForEach($user in $supportCollection){
If ($user.quotaused -ge $Level1){
$supportbody = $supportbody + $user.name + " , " + $user.quotaused + " , " + "Notification sent to User" + "`n`n"
}
Else{
$supportbody = $supportbody + $user.name + " , " + $user.quotaused + "`n`n"
}
}

#Send notification to Admins. Comment out next 2 lines if testing.
#$smtp = new-object Net.Mail.SmtpClient($smtpServer)
#$smtp.Send($mailFrom, $AdminEmail, $adminsubject, $supportbody)

#Write Results to console. Uncomment next line if testing.

$supportbody