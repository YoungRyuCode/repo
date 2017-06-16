$username = "Young.Ryu@nutanix.com"
$password = "Cool@1120"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Creds -Authentication Basic -AllowRedirection
Import-PSSession $Session

Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | Select-Object alias | foreach-object {Get-MailboxFolderStatistics -Identity $_.alias | select-object Identity, ItemsInFolder, FolderSize} | Export-csv c:\nos-alerts_Stats.csv -NoTypeInformation

Send-MailMessage -From "Young.Ryu@nutanix.com" -To “Young.Ryu@nutanix.com" -SMTPServer smtp.office365.com -Port 587 -UseSsl $Creds -Subject "Daily report - nos-alerts" -Body "Attached file has nos-alerts mailbox statistics" -Attachments "c:\nos-alerts_Stats.csv"


#$(Get-DistributionGroupMember -ResultSize unlimited "Team-Sales" -Recursive).Count