$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Get-MessageTrace -RecipientAddress Young.Ryu@nutanix.com -StartDate 06/06/2017 -EndDate 06/07/2017 | Where-Object {$_.Status -eq "Failed"}

#Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate 05/27/2017 -EndDate 05/30/2017 | Where-Object {$_.Status -eq "Failed"} | Get-MessageTraceDetail | fl

Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate 05/27/2017 -EndDate 05/30/2017 | Get-MessageTraceDetail | select-object Date, Sender, Recipient, Subject, Status

Get-MessageTrace -RecipientAddress Young.Ryu@nutanix.com -StartDate "06/06/2017 4:00:00PM" -EndDate "06/07/2017 10:30:00AM" -PageSize 1000 >> "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\MimeCast\Output_Young.txt"

Get-MessageTrace -RecipientAddress Young.Ryu@nutanix.com -StartDate "06/06/2017 4:00:00PM" -EndDate "06/07/2017 10:30:00AM" | Get-MessageTraceDetail | select-object Date, Sender, Recipient, Subject, Status


Get-MailboxRestoreRequest -Identity "Young.Ryu@nutanix.com"

Set-MailboxRestoreRequest -Identity "Young.Ryu@nutanix.com\Test2" #-BadItemLimit 100

Remove-PSSession $Session