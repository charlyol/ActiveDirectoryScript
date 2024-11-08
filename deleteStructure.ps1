$list=Get-ADOrganizationalUnit -Filter 'Name -like "*"'
$toRemove= "Sites" , "T0" , "T1" , "T2"
foreach ($item in $list) {
    if ($toRemove -contains $item.Name) {
        Write-Host "Removing " $item.DistinguishedName
        Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -Identity $item.DistinguishedName
        Remove-ADOrganizationalUnit -Identity $item.DistinguishedName -Confirm:$false -Recursive
    }
}