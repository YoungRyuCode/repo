
Install-Module PSServiceNow

Import-Module PSServiceNow
Set-ServiceNowAuth 
Get-ServiceNowIncident -MatchContains @{short_description='PowerShell'} 


Import-Module PSServiceNow
Get-ServiceNowIncident -MatchContains @{short_description='PowerShell'} -ServiceNowCredential $PSCredential -ServiceNowURL $ServiceNowURL