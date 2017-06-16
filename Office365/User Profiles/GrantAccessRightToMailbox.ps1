#1: Establish Connection to MS Exchange Server using PowerShell
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic –AllowRedirection
Import-PSSession $Session

#2: Grant Access Right to Mailbox for Export using PowerShell
Add-MailboxPermission –User Young.Ryu@nutanix.com -Identity svc.sharepoint@nutanixinc.onmicrosoft.com -AccessRights FullAccess -InheritanceType All

#3: Open Outlook with New Account
#You need to open Outlook as hr-freshdtls@convertechgroup.com and ensure that the hr-managementdtls@convertechgroup.com mailbox is displayed in the mailbox list on the left pane. Permissions might take a few seconds and even minutes to take effect.

#4: Check Configuration Settings
#Outlook must be ready to configure for downloading all the mails for a limited time. Click on the File menu and on the Info page, click on the Account Settings. From the menu, select Account Settings and select your account and then click on the Change button. Make sure that Use Cached Exchange Mode is enable i.e. it is checked as well as Mail to keep offline is set to All.
#Note: Relaunch MS Outlook to update the application with recent changes being made and proceed further to export office 365 mailbox to PST using PowerShell. 

#5: Export Mailbox to PST using Import/Export Wizard

Remove-MailboxPermission -User hr-freshdtls@stellaroutlookemails.com -Identity hr-managementdtls@stellaroutlookemails.com -AccessRights FullAccess
Remove-PSSession $Session