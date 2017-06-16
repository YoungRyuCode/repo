############################################################################################################################################################################################################# 
# Delete Inbox Items at specific date 
# 
# To run the script 
# 
# .\Purge-InboxItems-Date.ps1 
# 
# 
# Author:                 Young Ryu 
# Version:                1.0 
# Last Modified Date:     6/5/2017 
# Last Modified By:       Young.Ryu@nutanix.com
# 
# NOTE THAT: How to encript your password
# Run the following command:
# Read-Host -Prompt "Enter your tenant password" -AsSecureString | ConvertFrom-SecureString | Out-File "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\O365\PowerShell\EncriptedPW\cred_pc.txt"
# cred_pc.txt makes your password encripted !!
############################################################################################################################################################################################################

# Set variables
$fileLocation = "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\O365\PowerShell"
$From = "Young.Ryu@nutanix.com"
$To = "Young.Ryu@nutanix.net"
$DatePurged = "(received:04/1/2017..04/1/2017)"
$mailbox = "svc.mail.nos-alerts@nutanix.com"
#$To = "Webex_Users@nutanix.com"

# Set Credential for Office 365 Global Admin
$username = "Young.Ryu@nutanix.com" 
$Pass = Get-Content "$fileLocation\EncriptedPW\cred_pc.txt" | ConvertTo-SecureString
$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $Pass 

#Connect Exchange Online Service
$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $Pass
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Creds -Authentication Basic -AllowRedirection

# Import Exchange Online Service session
Import-PSSession $Session

# Get-CurrentDate 
$CurrentDate = Get-Date -Format g

# Delete (Purge) Inbox Items from Date to Date
Search-Mailbox -Identity $mailbox -SearchQuery $DatePurged -DeleteContent -force

# Get the result of Get-MailboxStatistics
$Result = Get-MailboxStatistics -Identity $mailbox |Format-List TotalItemSize, DeletedItemCount, TotalDeletedItemSize

# Send a confirmation email to Specific DL group
Send-MailMessage -from $From -To $To -SmtpServer smtp.office365.com -Port 587 -UseSsl -Subject "$mailbox mailbox - Purging Process has been successfully completed from Date $DatePurged at $CurrentDate" -Body ($Result | out-string) -priority High -Credential $Creds

# Remove Exchange Online Service session
Remove-PSSession $Session