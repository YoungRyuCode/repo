#Company Administrator
#Exchange Service Administrator
#SharePoint Service Administrator
#User Account Administrator
#Service Support Administrator


$cred = Get-Credential
Connect-MsolService -credential $cred
Get-MsolRole | %{$role = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | select @{Name="Role"; Expression = {$role}}, DisplayName, EmailAddress | Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\List of Admin Roles\List of Office365 Admin.csv"


#$role = Get-MsolRole -RoleName "Company Administrator"
#Get-MsolRoleMember -RoleObjectId $role.ObjectId | Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\List of Admin Roles\ListofGlobalAdmin.csv"
#$role = Get-MsolRole -RoleName "Exchange Service Administrator"
#Get-MsolRoleMember -RoleObjectId $role.ObjectId | Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\List of Admin Roles\ListofExchangeAdmin.csv"
#$role = Get-MsolRole -RoleName "SharePoint Service Administrator"
#Get-MsolRoleMember -RoleObjectId $role.ObjectId | Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\List of Admin Roles\ListofSharePointAdmin.csv"
#$role = Get-MsolRole -RoleName "User Account Administrator"
#Get-MsolRoleMember -RoleObjectId $role.ObjectId | Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\List of Admin Roles\ListofUserAcctAdmin.csv"
#$role = Get-MsolRole -RoleName "Service Support Administrator"
#Get-MsolRoleMember -RoleObjectId $role.ObjectId | Export-CSV "C:\Users\Young_Ryu\OneDrive - Nutanix\Application Services\O365\List of Admin Roles\ListofSrvSupportAdmin.csv"
