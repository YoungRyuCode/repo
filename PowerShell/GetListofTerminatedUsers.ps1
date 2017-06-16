#Connect-SPOService -Url https://nutanixinc-admin.sharepoint.com

Connect-msolservice

Foreach ($User in (Get-MsolUser -All))
{
If ($User.BlockCredential -eq $true)
    {
        #if($user.UserPrincipalName -eq "ari.paul@nutanix.com")
        #{
        #    Write-host $user.UserPrincipalName
        #    break
        #}
        Write-Host $User.UserPrincipalName "is disabled" -ForegroundColor Red | Select-Object LastDirSyncTime
    }
}

#Get-MsolUser -All |FL DisplayName,BlockCredential

Get-MsolUser -UserPrincipalName "ari.paul@nutanix.com" | Select-Object UserPrincipalName, DisplayName, LastDirSyncTime, OverallProvisioningStatus