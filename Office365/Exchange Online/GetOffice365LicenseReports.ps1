Connect-MsolService

$customformat = @{expr={$_.AccountSkuID};label="AccountSkuId"},
         @{expr={$_.ActiveUnits};label="Total"},
         @{expr={$_.ConsumedUnits};label="Assigned"},
        @{expr={$_.activeunits-$_.consumedunits};label="Unassigned"},
        @{expr={$_.WarningUnits};label="Warning"}
$result = Get-MsolAccountSku | sort activeunits -desc | select $customformat
$runningout=@()
$result | foreach{
    if($_.unassigned -le 5){
        $runningout+=$_
    }
}
[string]$body=$runningout | convertto-html
#[string]$body=$result | convertto-html
$cred=Get-Credential
send-mailmessage -from Young.Ryu@nutanix.com -To Young.Ryu@nutanix.com -SmtpServer smtp.office365.com -Port 587 -UseSsl -Body $body -Subject "Daily Office 365 License Report" -BodyAsHtml -Credential $cred
