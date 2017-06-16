Clear-Host  
#Specify tenant admin and URL  
$User = "Young.Ryu@nutanix.com"
 
#$UserProfileOutPut = "C:\Users\Nuntanix_YR\OneDrive - Nutanix\SharePoint\Documents\Application Services\Reports\PSReports\AllProfiles.csv"
#$NoProfileOutput = "C:\Users\Nuntanix_YR\OneDrive - Nutanix\SharePoint\Documents\Application Services\Reports\PSReports\UsersWithNoProfile.csv"

$UserProfileOutPut = "C:\AllProfiles.csv"
$NoProfileOutput = "C:\UsersWithNoProfile.csv"
Write-Host "Collecting Infomration..." -ForegroundColor Yellow
  
#Configure Site URL and User  
$SiteURL = "https://nutanixinc-admin.sharepoint.com"
  
#Download Updated CSOM from https://www.nuget.org/packages/Microsoft.SharePointOnline.CSOM 
#Add references to SharePoint client assemblies and authenticate to Office 365 site - required for CSOM  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"  
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.UserProfiles.dll"
 
  
Write-Host "Loading SharePoint Assemblies..." -ForegroundColor Yellow  
Write-Host "Connecting to SharePoint Online Service and Context..." -ForegroundColor Yellow  
$Password = Read-Host -Prompt 'Please enter your password' -AsSecureString  
$Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList $User, $Password  
$Creds = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($User,$Password)  
  
#Bind to Site Collection  
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)  
$Context.Credentials = $Creds  
Write-Host "Connected to SharePoint Online Context..." -ForegroundColor Yellow  
  
#Create People Manager object to retrieve profile data  
  
#i:0#.f|membership|juliani@sharepointmvp.onmicrosoft.com  
$PeopleManager = New-Object Microsoft.SharePoint.Client.UserProfiles.PeopleManager($Context) -ErrorAction Inquire  
Write-Host "Loading People Manager..." -ForegroundColor Yellow  
  
try  
{  
    Connect-MsolService -Credential $Credentials -ErrorAction Inquire  
    Write-Host "Connected to SharePoint Online Service..." -ForegroundColor Yellow  
}  
catch  
{  
    Write-Host "Unable to Connect to SharePoint Online...Existing the Script."  
    return  
}  
  
$Users = Get-MsolUser -All | Select-Object UserPrincipalName, isLicensed  
Write-Host "Collecting Users Information from SharePoint Online..." -ForegroundColor Yellow  
  
$Headings = ""  
$boolCreateHeadings = $true  
$NoProfileUsers = @()   
  
Foreach ($User in $Users)  
{  
        $ClaimsUserFormat = 'i:0#.f|membership|'+ $User.UserPrincipalName  
        $UserProfile = $PeopleManager.GetPropertiesFor($ClaimsUserFormat)  
        $Context.Load($UserProfile)  
        $Context.ExecuteQuery()  
  
        If ($UserProfile.Email -ne $null)  
        {  
            if($boolCreateHeadings)  
            {  
                Write-Host "Loading CSV Headings..." -ForegroundColor Green  
                foreach($Key in $UserProfile.UserProfileProperties.Keys)  
                {  
                    $Headings += '"' + $Key + '",'  
                }  
                $Headings.Remove($Headings.Length-1, 1)  
                $Headings -join "," | Out-File -Encoding default -FilePath $UserProfileOutPut  
                $boolCreateHeadings = $false  
            }  
              
            Write-Host "User Found $ClaimsUserFormat" -ForegroundColor Green  
            Write-Host "---------------------------------------------------" -ForegroundColor Green  
            $Properties = ""  
            foreach($Value in $UserProfile.UserProfileProperties.Values)  
            {  
                $Properties += '"' + $Value + '",'  
            }  
            $Properties.Remove($Properties.Length-1, 1)  
            $Properties -join "," | Out-File -Encoding default -Append -FilePath $UserProfileOutPut  
            Write-Host "User Profile Written to CSV $UserProfileOutPut" -ForegroundColor Yellow          
        }    
        else  
        {  
            $NoProfileUser = New-Object PSObject  
            Add-Member -input $NoProfileUser noteproperty 'NoProfileUserName' $User.UserPrincipalName  
            $NoProfileUsers += $NoProfileUser  
            Write-Host "User found with No Profile..." -ForegroundColor Yellow  
        }  
}  
#Export Only No profile users to CSV.   
$NoProfileUsers | Export-Csv $NoProfileOutput -NoTypeInformation  
Write-Host "Script Completed. All profiles have been Written to $UserProfileOutPut" -ForegroundColor Green 
Write-Host "All Users with No Profiles are Exported to $NoProfileOutput..." -ForegroundColor Green