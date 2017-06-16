$msolcred = get-credential
connect-msolservice -credential $msolcred
$ExSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $msolCred -Authentication Basic -AllowRedirection
Import-PSSession $ExSession
$lyncsession = New-CsOnlineSession -Credential $msolcred 
Import-PSSession $lyncsession
Connect-SPOService -Url https://nutanixinc-admin.sharepoint.com -credential $msolcred