# The csv file we will write to - MODIFY THIS FOR YOUR OWN ENVIRONMENT 
$OutputFile = "ConnectionbyClientTypeDetailDaily.csv"                
$username = "Young,Ryu@nutanix.com"                           
$password = "Cool@1120" | ConvertTo-SecureString -asPlainText -Force  
$cred = New-Object System.Management.Automation.PSCredential($username,$password) # Encrypt creds for use 
# Report Root URL 
$Root = "https://reports.office365.com/ecp/reportingwebservice/reporting.svc/"  
$WebService = "ConnectionbyClientTypeDetailDaily" 
$Format = "`$format=JSON" 
$Select = "`$select=Date,WindowsLiveID,UserName,ClientType,Count"  
# Build report URL 
$url = ($Root + $WebService + "/?" + $Select + "&" + $Format)   
$rawReportData = (Invoke-RestMethod -Credential $cred -uri $url).d.results   
 
# Write File Header 
 
Out-File -FilePath $OutputFile -InputObject ("Date,WindowsLiveID,UserName,ClientType,Count") -Encoding UTF8 
ForEach ($entry in $rawReportData) 
{ 
    $Date = $entry.Date.ToString("yyyy-MM-dd") 
    $WindowsLiveID = $entry.WindowsLiveID 
    $UserName = $entry.UserName 
    $ClientType = $entry.ClientType 
    $Count = $entry.Count 
     
    Out-File -FilePath $OutputFile -InputObject ("$Date,$WindowsLiveID,$UserName,$ClientType,$Count") -Encoding UTF8 -append 
    write-host ("$Date,$WindowsLiveID,$UserName,$ClientType,$Count") 
} 