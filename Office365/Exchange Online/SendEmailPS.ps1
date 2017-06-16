$smtpServer = "ho-ex2010-caht1.exchangeserverpro.net"
$smtpFrom = "reports@exchangeserverpro.net"
$smtpTo = "administrator@exchangeserverpro.net"
$messageSubject = "List of Exchange Servers"
 
$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = $messageSubject
$message.IsBodyHTML = $true
 
$message.Body = Get-ExchangeServer | Select-Object Name,ServerRole | ConvertTo-Html
 
$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($message)


1
	
Send-MailMessage -To “Manager 1 <Manager1@xyz.com>", “Manager2 <Manager2@xyz.com>" -CC “Manager 3 <Manager3@xyz.com>”, “Manager4 <Manager4@xyz.com>” -From “Reports Admin <Reportadmin@xyx.com>" -SMTPServer smtp1.xyz.com -Subject “Daily report sent to multiple managers” -Body “This is a daily report of servers uptime”


1
	
Send-MailMessage -To “Manager 1 <Manager1@xyz.com>" -From “Reports Admin <Reportadmin@xyx.com>" -SMTPServer smtp1.xyz.com -Subject “Daily report” -Body “Attached file has uptime details of all servers” -Attachments “c:\temp\uptime-report.txt”