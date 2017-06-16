$DL = gc "C:\reports\distros.txt"
foreach($name in $DL) {
    $Count = (Get-DistributionGroupMember -Identity $name –ResultSize Unlimited| select name).count

    #Out-File -FilePath "C:\reports\export.csv" -InputObject $name, $Count -Encoding UTF8 -append


    #$Count = (Get-DistributionGroupMember -Identity $name –ResultSize 10| select name).count
    #Write-host $name, $Count
    #$name, $Count |  Out-File -FilePath "C:\reports\export.csv" -Append
    $report += $name, $Count

    $report | Export-CSV -path "C:\reports\export.csv"
}
#$report | Export-CSV -path "C:\reports\export.csv"

#$Computer,$Speed,$RegCheck -join ',' | Out-File -FilePath $FilePath -Append -Width 200;
#$report = @{"Number1"=$var1},
#@{"Number2"=$var2},
#@{"Number3"=$var3}

#$report | Export-CSV -path c:\yourmom.csv