$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session


#Get-MailboxStatistics -Identity "svc.mail.nos-alerts@nutanix.com" |Format-List TotalItemSize, DeletedItemCount, TotalDeletedItemSize

For ($i=0; $i -le 10; $i++) 
{
    Start-Sleep -s 100
    Get-MailboxStatistics -Identity "svc.mail.nos-alerts@nutanix.com" |Format-List TotalItemSize, DeletedItemCount, TotalDeletedItemSize
}