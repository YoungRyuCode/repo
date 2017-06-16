#==========================Description of the Tool==========================#

Write-Host "
This script will collect information and create a report with all distribution lists available and its total members count:


"
#==========================Connecting to Exchange Online==========================#

$connection=Read-Host "Are you already connected to Exchange Online in this PowerShell Session? (y/n)"

If ($connection -eq "n") {

Write-Host "
The tool will need your Global Administrator credentials in order to connect to Exchange Online and pull the necessary logs.
This script will run in your local machine, so the credentials provided will not transit to any 3rd party database, it will only authenticate against Office 365 authentication services.

If you do NOT agree to provide your credentials please close the tool at this moment, otherwise press ENTER to continue.


"

Read-Host

$livecred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powerShell-liveID?serializationLevel=Full -Credential $LiveCred -Authentication Basic –AllowRedirection
Set-ExecutionPolicy RemoteSigned -Force
Import-PSSession $Session
Connect-MsolService -Credential $livecred
} else {}

#==========================Creating variables and paths==========================#

$path=Test-Path c:\O365Reports
If ($path -like "False") {md c:\O365Reports} else {}
$second=(get-date).Second
$minute=(get-date).Minute
$hour=(get-date).Hour
$day=(get-date).Day
$month=(get-date).Month
$year=(get-date).Year
$time="$hour.$minute.$second"
$report2="$month.$day.$year"
$report="$report2-$time"



cls

 

#==========================Main Operator==========================#


$distcount=(Get-DistributionGroup | Measure-Object).count
echo "The estimate total number of groups are $distcount, the count below will show how many we have already processed"


for ($a=0; $a -lt $distcount; $a++)
{
$c=$a+1
Get-DistributionGroup -ResultSize Unlimited | Select -Skip $a -First 1 | Select Displayname >> c:\O365Reports\$report-DLMembers.txt
Get-DistributionGroup -ResultSize Unlimited | Select -Skip $a -First 1 | Select ManagedBy >> c:\O365Reports\$report-DLMembers.txt
Get-DistributionGroup -ResultSize Unlimited | Select -Skip $a -First 1 | Get-DistributionGroupMember -ResultSize Unlimited | Measure-Object | select @{Label="Members Count"; Expression={$_.count}} >> c:\O365Reports\$report-DLMembers.txt
Get-DistributionGroup -ResultSize Unlimited | Select -Skip $a -First 1 | Get-DistributionGroupMember -ResultSize Unlimited | Select -ExpandProperty Name >> c:\O365Reports\$report-DLMembers.txt
Add-Content -Value "#############################################" -Path c:\O365Reports\$report-DLMembers.txt
Write-Progress -Activity "Gathering Group Members, seat back and relax!" -Status "Processing Group $c out of $distcount" -PercentComplete ($c / $distcount*100) 
}



cls


#==========================Printing results of script==========================# 

Write-Host "


Your Report was generated and can be found here: c:\O365Reports\"


Write-Host "
Note: The report will be named with the current date and time (M.D.Y-H.M.S) in a txt format!

Thank you for using this tool!
Developer: Rodolfo Lima
"