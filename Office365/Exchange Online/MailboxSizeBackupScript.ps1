Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | Get-MailboxStatistics | fl

Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | Get-MailboxStatistics | Format-Table DisplayName, TotalItemSize, ItemCount -Autosize

Get-Mailbox | Get-MailboxStatistics | Format-Table DisplayName, TotalItemSize, ItemCount -Autosize

Get-Mailbox | Get-MailboxStatistics | Select DisplayName, TotalItemSize, ItemCount | Sort ItemCount -Descending

Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | Get-MailboxStatistics | Select DisplayName, DatabaseProhibitSendQuota, TotalItemSize, ItemCount | Sort ItemCount -Descending

Get-Mailbox -Identity "Shawn@nutanix.com" | Get-MailboxStatistics | Select DisplayName, DatabaseProhibitSendQuota, TotalItemSize, ItemCount | Sort ItemCount -Descending

Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | fl usedatabasequota*

Get-MailboxUsageDetailReport | Select -first 100 | Select-Object Date, Username, MailboxSize, CurrentMailboxSize, PercentUsed | export-csv "c:\MailboxSizes.csv"

get-mailbox | get-mailboxstatistics | select DisplayName,ItemCount,TotalItemSize | export-csv "MailboxSizes.csv"


Get-MailboxUsageDetailReport | Select-Object Date, Username, MailboxSize, CurrentMailboxSize, PercentUsed | export-csv "c:\MailboxSizes.csv"



Set-Mailbox user@domain.com (user@domain.com) -ProhibitSendReceiveQuota 100GB -ProhibitSendQuota 99GB -IssueWarningQuota 98GB 

Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | fl *quota

Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | fl usedatabasequota*