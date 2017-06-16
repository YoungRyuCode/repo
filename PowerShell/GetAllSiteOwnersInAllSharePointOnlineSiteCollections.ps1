Add-PSSnapin microsoft.sharepoint.powershell -ErrorAction SilentlyContinue
Import-Module ‘C:\Program Files\SharePoint Online Management Shell\Microsoft.Online.SharePoint.PowerShell’ -DisableNameChecking

Connect-SPOService
$AllSites = Get-SPOSite

Foreach($site in $AllSites)
{
    Write-Host $site.Url
    $Groups = Get-SPOSiteGroup -Site $site.Url
    Foreach($Group in $Groups)
    {
        Foreach($Role in $Group.Roles)
        {
            If ($Role.Contains(“Full Control”))
            {
                Write-Host $Group.Title
                Write-Host $Group.Users
                $users = $Group.Users -join ‘ ‘
                $title = $Group.Title
                $props = @{Title = $title
                Users = $users
                Website = $site.Url}
                $temp = New-Object psobject -Property $props
                $temp | export-csv –append –path C:\SiteOwnerandSites.csv
            }
        }
    }
}