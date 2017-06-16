<### ---
Pull AD Report to local CSV
.PURPOSE: 
        Self-executable script to export list of users from an AD group or OU.
        Pulls enabled users only.
.PREREQUISITES:
        Must have RSAT tools installed.
        Computer must be joined to domain.
        User needs to be in OMGIT SG to run the script.
.AUTHOR: DB
--- ###>
cd $env:USERPROFILE\Desktop\
$date = Get-Date -Format MMddyy
#-> FUNCTIONS
function Save-CSV
{
param( [string]$base,
       [string]$type )
process {
    Get-ADUser -SearchBase "ou=$base,ou=nutanix,dc=corp,dc=nutanix,dc=com" -filter {Enabled -eq "True"} -Properties * | `
    Select-Object @{ expression={$_.displayName}; label='Display Name' },`
    @{ expression={$_.givenName}; label='First Name' },`
    @{ expression={$_.surName}; label='Last Name' },`
    sAMAccountName,`
    @{ expression={$_.userPrincipalName}; label='Primary Email' },`
    @{ expression={$_.telephoneNumber}; label='Phone Number' },`
    @{ expression={$_.physicalDeliveryOfficeName}; label='Office' },`
    @{ expression={$_.l}; label='Location' },`
    @{ expression={$_.oktaWorkerType}; label='Employment Status' },`
    @{ expression={$_.Title}; label='JobTitle' },`
    @{ expression={$_.department}; label='Deptartment' },`
    @{ expression={$_.manager}; label='Manager' },`
    @{ expression={$_.passwordLastSet}; label='Password Last Set' } | ` 
    Export-Csv .\$($Type)_$date.csv -NoTypeInformation
            }
}
function Show-ErrorMessage
{
param ([string]$msg)
process {
    Write-Host "[FAILED]" -ForegroundColor "Red"
    Write-Host "$msg. Press Any Key To Exit...." -ForegroundColor Red
    [void][System.Console]::ReadKey($true)
    exit
    }
}
function ConvertFrom-DN
{
param([string]$DN=(Throw '$DN is required!'))
    foreach ( $item in ($DN.replace('\,','~').split(",")))
    {
        switch -regex ($item.TrimStart().Substring(0,3))
        {
            "CN=" {$CN = '/' + $item.replace("CN=","");continue}
            "OU=" {$ou += ,$item.replace("OU=","");$ou += '/';continue}
            "DC=" {$DC += $item.replace("DC=","");$DC += '.';continue}
        }
    }
    $canoincal = $dc.Substring(0,$dc.length - 1)
    for ($i = $ou.count;$i -ge 0;$i -- ){$canoincal += $ou[$i]}
    $canoincal += $cn.ToString().replace('~',',')
    return $canoincal
}
#Start Prereq region
$message = "Prerequisite Check"
$messageLength = "_" * $message.Length
Write-Host "$message"
Write-Host "$messageLength"
Write-Host ""
## RSAT tools
Write-Host "RSAT Tools " -NoNewline
$confirm = Get-Module -List ActiveDirecory
try {
    Import-Module ActiveDirectory
        }
catch {
    Show-ErrorMessage -msg "Install RSAT tools before continuing"
        }
sleep 2
Write-Host "[OK]" -ForegroundColor "Green"
## Internal Network connection
Write-Host "AD connection " -NoNewline
$sv2test = Test-Connection 10.3.1.11 -Quiet
if ($sv2test) {
    Write-Host "[OK]" -ForegroundColor "Green"; sleep 1
        }
else {
    Show-ErrorMessage -msg "Ensure you are on the corporate network"
        }
## In domain
Write-Host "Joined to domain " -NoNewline
$domain = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain; sleep 2
if ($domain -eq $true) {
    Write-Host "[OK]" -ForegroundColor "Green"; sleep 1
        }
else {
    Show-ErrorMessage -msg "Your computer is not on the domain. Please join and try again"
        }
## IT authentication
Write-Host "IT authentication " -NoNewline; sleep 1
$ADcreds = Get-Credential -Message "Enter your AD Credentials:"
if (!$ADcreds -eq "True") {
    exit
    }
$username = $ADcreds.username
$password = $ADcreds.GetNetworkCredential().password
$Memberof = Get-ADUser $ADCreds.UserName -Properties * | select -ExpandProperty memberof
# Get domain and apply credentials
$CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
$domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)
if ($domain.Name -eq $null) {
    Show-ErrorMessage -msg "Authentication failed"
        }
elseif ($Memberof -notcontains "CN=OMGIT,OU=Okta Managed Groups,OU=Security Groups,OU=Nutanix,DC=corp,DC=nutanix,DC=com") {
    Show-ErrorMessage -msg "You are not a member of OMGIT"
        }
else {
    Write-Host "[OK]" -ForegroundColor "Green"
        }
#End Prereq region
sleep 2
clear
#Kick off user selection
do {
    do {
        Write-Host ""
        Write-Host "A - Get Full Time Employees"
        Write-Host "B - Get Contractors"
        Write-Host "C - Get Interns"
        Write-Host "D - Pull All Nutanix Employees"
        Write-Host "E - Pull Members in an AD Group"
        Write-Host ""
        Write-Host "X - Done/Exit"
        Write-Host ""
        (Write-Host "NOTE: All reports are saved to your Desktop" -ForegroundColor "Green")
        Write-Host ""
        Write-Host "Select your option(s) and press Enter: (e.g. ""a"",""ab"" or exit with ""x"")"
        $choice = read-host
        write-host ""
        $ok = $choice -match '^[abcdex]+$'
        if ( -not $ok) { 
            Write-Host "Please choose again." 
            sleep 2
            clear
            }
        $FinalDecision = Read-Host "You have chosen ""$choice"". Are you sure you want to continue? [y/n]"
        if ($FinalDecision -ieq "y") {
            $ok | Out-Null
            }
        elseif ($FinalDecision -ieq "n") {
            $ok = $null
            Write-Host "Cancelled, please select again."
            sleep 3
            clear
            }
        else {
            Write-Host "Invalid entry. Try again."
            $ok = $null
            sleep 3
            clear
            }
    } 
    until ( $ok )
# Run selections
    Clear-Host
    Write-Host "Working, please wait..."
    switch -Regex ( $choice ) {
        "A"
        {Save-CSV -base users -type FullTime}
        
        "B"
        {Save-CSV -base contractors -type Contractors}
        "C"
        {Save-CSV -base interns -type Interns}
        "D"
        {
            New-Item .\temp -type directory | Out-Null
            cd .\temp
            Save-CSV -base users -type FullTime
            Save-CSV -base contractors -type Contractors
            Save-CSV -base interns -type Interns
            @(Import-csv .\FullTime_$date.csv) + @(Import-csv .\Contractors_$date.csv) + @(Import-csv .\Interns_$date.csv) | 
            Export-csv ..\AllUsers_$date.csv -NoTypeInformation
            cd ..
            Remove-Item .\temp -Force -Recurse
        }
        "E"
        {
            Clear-Host
            do {
    
                $Group = Read-Host "AD Group"
                $GroupCheck = Get-ADGroup $Group -Properties *
                    if ($GroupCheck -eq $null) {
                        Write-Host "Group not found, please check spelling and try again..."
                        sleep 2
                            }
                    else {
                        Write-Host "$group found. Pulling report..."
                        $list = Get-ADGroupMember -Identity $Group -Recursive | ForEach-Object {Get-ADUser $_.samaccountname -Properties *} |` 
                        Select-Object @{ expression={$_.displayName}; label='Display Name' },`
                            @{ expression={$_.givenName}; label='First Name' },`
                            @{ expression={$_.surName}; label='Last Name' },`
                            sAMAccountName,`
                            @{ expression={$_.userPrincipalName}; label='Primary Email' },`
                            @{ expression={$_.telephoneNumber}; label='Phone Number' },`
                            @{ expression={$_.physicalDeliveryOfficeName}; label='Office' },`
                            @{ expression={$_.l}; label='Location' },`
                            @{ expression={$_.oktaWorkerType}; label='Employment Status' },`
                            @{ expression={$_.Title}; label='JobTitle' },`
                            @{ expression={$_.department}; label='Deptartment' },`
                            @{ expression={$_.manager}; label='Manager' },`
                            @{ expression={$_.passwordLastSet}; label='Password Last Set' }
                        $list | Export-Csv .\$($group)_$date.csv -NoTypeInformation
                        break
                        }
                }
                while($true)
        }
    }
    Clear-Host
} until ( $choice -match "X" )