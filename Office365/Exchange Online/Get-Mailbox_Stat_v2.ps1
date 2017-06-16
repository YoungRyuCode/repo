################################################################################################################################################################ 
# Get mailbox statistics (nos-alerts@nutanix.com) and send email 
# 
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
################################################################################################################################################################

# Set Credential for Office 365 Global Admin
$username = "Young.Ryu@nutanix.com" 
$Pass = Get-Content "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\PowerShell\EncriptedPW\cred.txt" | ConvertTo-SecureString
$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $Pass 

#Connect Exchange Online Service
$Creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $Pass
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Creds -Authentication Basic -AllowRedirection

# Import Exchange Online Service
Import-PSSession $Session

# Get Mailbox statistics
Get-Mailbox -Identity "svc.mail.nos-alerts@nutanix.com" | Select-Object alias | foreach-object {Get-MailboxFolderStatistics -Identity $_.alias | select-object Identity, ItemsInFolder, FolderSize} | Export-csv "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\PowerShell\nos-alerts-stats\nos-alerts_Stats.csv" -NoTypeInformation

# Send an email
Send-MailMessage -From "Young.Ryu@nutanix.com" -To "Young.Ryu@nutanix.net" -SMTPServer smtp.office365.com -Port 587 -UseSsl -Credential $Creds -Subject "Daily report - nos-alerts" -Body "Attached file has nos-alerts mailbox statistics" -Attachments "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\PowerShell\nos-alerts-stats\nos-alerts_Stats.csv"

# Disconnect Exchange Online Service
Remove-PSSession $Session