$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com"| Select-Object alias | foreach-object {Get-MailboxFolderStatistics -Identity $_.alias | select-object Identity, ItemsInFolder, FolderSize} | Export-csv c:\nos-alert_Stats1.csv -NoTypeInformation

Remove-PSSession $Session