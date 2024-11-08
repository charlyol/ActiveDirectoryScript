$list=Get-ADOrganizationalUnit -Filter 'Name -like "*"'
$toRemove= "Sites" , "Valence" , "Grenoble" , "Chambery" , "IT-Valence" , "IT-Grenoble" , "IT-Chambery"
foreach ($item in $list) {
    if ($toRemove -contains $item.Name) {
        Write-Host "Removing " $item.DistinguishedName
        Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -Identity $item.DistinguishedName
        Remove-ADOrganizationalUnit -Identity $item.DistinguishedName -Confirm:$false -Recursive
    }
}