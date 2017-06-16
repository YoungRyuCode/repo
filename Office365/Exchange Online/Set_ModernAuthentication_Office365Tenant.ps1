#Connect Exchange Online Service
$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

#Set Modern Authentication into Nutanixinc.onmicrosoft.com tenant
Set-OrganizationConfig -OAuth2ClientProfileEnabled $true

#Validate Nutanixinc.onmicrosoft.com = true 
Get-OrganizationConfig | Format-Table -Auto Name,OAuth*

#Disconnect Exchange Online service
Remove-PSSession $Session