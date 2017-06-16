$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

Get-MessageTrace -RecipientAddress Young.Ryu@nutanix.com -StartDate 05/01/2017 -EndDate 05/20/2017 | fl

#Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate 05/27/2017 -EndDate 05/30/2017 | Where-Object {$_.Status -eq "Failed"} | Get-MessageTraceDetail | fl

Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate 05/27/2017 -EndDate 05/30/2017 | Get-MessageTraceDetail | select-object Date, Sender, Recipient, Subject, Status

Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate "05/26/2017 12:00:00PM" -EndDate "05/27/2017 5:30:00PM" -PageSize 1000 >> "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\MimeCast\Output1.txt"
Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate "05/27/2017 5:30:00PM" -EndDate "05/28/2017 5:30:00PM" -PageSize 1000 >> "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\MimeCast\Output2.txt"
Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate "05/28/2017 5:30:00PM" -EndDate "05/29/2017 5:30:00PM" -PageSize 1000 >> "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\MimeCast\Output3.txt"
Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate "05/29/2017 5:30:00PM" -EndDate "05/30/2017 5:30:00PM" -PageSize 1000 >> "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\MimeCast\Output4.txt"
Get-MessageTrace -RecipientAddress support_case@nutanix.com -StartDate "05/30/2017 5:30:00PM" -EndDate "05/31/2017 5:30:00PM" -PageSize 1000 >> "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\MimeCast\Output5.txt"

get-inboxrule -Mailbox "young.ryu@nutanix.com"

Get-Mailbox svc.mail.nos-asups@nutanix.com | fl

#Condition 1 – Get all failed/undeliverable emails:

Get-Messagetrackinglog -Recipients: support_case@nutanix.com -EventID "FAIL" -Start "5/26/2011 9:00:00 AM" -End "5/30/2011 5:00:00 PM" |ft Timestamp, Source, Sender, Recipients, MessageSubject >>C:output.txt

#Condition 2 – Get all success emails

Get-Messagetrackinglog -Recipients: support_case@nutanix.com -EventID "RECEIVE" -Start "5/26/2011 9:00:00 AM" -End "5/30/2011 5:00:00 PM" |ft Timestamp, Source, Sender, Recipients, MessageSubject >>C:output.txt