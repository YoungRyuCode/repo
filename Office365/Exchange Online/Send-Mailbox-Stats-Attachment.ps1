################################################################################################################################################################ 
# Get mailbox statistics (nos-alerts@nutanix.com) and send email 
# 
# To run the script 
# 
# .\Send-Mailbox-Stats-Attachment.ps1 
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
# cred.txt makes your password encripted !!
################################################################################################################################################################

# Set variables
$fileLocation = "C:\Users\Young.Ryu.YRYUSJC-PC2\Nutanix\OneDrive - Nutanix\Application Services\O365\PowerShell"
$From = "Young.Ryu@nutanix.com"
#$To = "Young.Ryu@nutanix.net"
$mailbox = "svc.mail.nos-alerts@nutanix.com"
$To = "Webex_Users@nutanix.com"

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
$CurrentDate = Get-Date -format "MMM d yyyy hh-mm-ss"

# Get Mailbox statistics
Get-Mailbox -Identity $mailbox | Select-Object alias | foreach-object {Get-MailboxFolderStatistics -Identity $_.alias | select-object Identity, ItemsInFolder, FolderSize} | Export-csv "$fileLocation\nos-alerts-stats\Nos-Alerts_Stats_$CurrentDate.csv" -NoTypeInformation

# Send Report by email
Send-MailMessage -From $From -To $To -SMTPServer smtp.office365.com -Port 587 -UseSsl -Credential $Creds -Subject "Weekly Mailbox Report for nos-alerts@nutanix.com" -Body "Attached file has Nos-alerts Mailbox statistics" -Attachments "$fileLocation\nos-alerts-stats\Nos-Alerts_Stats_$CurrentDate.csv"
 
# Remove Exchange Online Service session
Remove-PSSession $Session