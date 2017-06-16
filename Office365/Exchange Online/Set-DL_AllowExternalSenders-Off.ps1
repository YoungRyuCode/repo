############################################################################################################################################################################################################# 
# Set Allow External Senders = Off into the specific Distribution Group in Office 365 
# CHG0030463 from 9:30am to 12:30pm on 6/10/2017
# 
# To run the script
# .\Set-DL-AllowExternalSenders-Off.ps1 
# 
# Author:                 Young Ryu 
# Version:                1.0 
# Last Modified Date:     6/9/2017 
# Last Modified By:       Young.Ryu@nutanix.com
############################################################################################################################################################################################################

# Connect Exchange Online service
$Creds = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
# Import Exchange online service session
Import-PSSession $Session

# Set Allow External Senders = Off
# Start this line below

# 1. Eng
Set-DistributionGroup -Identity "Eng" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Eng" | select-object RequireSenderAuthenticationEnabled

# 2. Team-Sales
Set-DistributionGroup -Identity "Team-Sales" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Team-Sales" | select-object RequireSenderAuthenticationEnabled

# 3. Team-Emea-Sales
Set-DistributionGroup -Identity "Team-Emea-Sales" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Team-Emea-Sales" | select-object RequireSenderAuthenticationEnabled

# 4. Eng-Help
Set-DistributionGroup -Identity "Eng-Help" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Eng-Help" | select-object RequireSenderAuthenticationEnabled

# 5. Team-Apac
Set-DistributionGroup -Identity "Team-Apac" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Team-Apac" | select-object RequireSenderAuthenticationEnabled

# 6. Cap
Set-DistributionGroup -Identity "Cap" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Cap" | select-object RequireSenderAuthenticationEnabled

# 7. Marketing
Set-DistributionGroup -Identity "Marketing" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Marketing" | select-object RequireSenderAuthenticationEnabled

# 8. Staffing
Set-DistributionGroup -Identity "Staffing" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Staffing" | select-object RequireSenderAuthenticationEnabled

# 9. Team-oem-all
Set-DistributionGroup -Identity "Team-oem-all" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "Team-oem-all" | select-object RequireSenderAuthenticationEnabled

# 10. RTP SREs
Set-DistributionGroup -Identity "RTP SREs" -RequireSenderAuthenticationEnabled $True
Get-DistributionGroup -Identity "RTP SREs" | select-object RequireSenderAuthenticationEnabled

# End this line above

# Remove Exchange online service session
Remove-PSSession $Session