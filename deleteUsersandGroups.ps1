# Suppression des utilisateurs et des groupes créés
function CleanUp {
    Write-Host "Cleaning up users and groups created in Site1..."

    $list = Get-ADUser -Filter 'Name -like "User*"'
    # Suppression des utilisateurs
    foreach ($username in $list.Name) {
        Remove-ADUser -Identity $username -Confirm:$false
        Write-Host "User $username has been removed."
    }
    $groups = Get-ADGroup -Filter 'Name -like "T0*" -or Name -like "T1*" -or Name -like "T2*" -or Name -like "Site1*" -or Name -like "Site2*" -or Name -like "Site3*"'
    # Suppression des groupes
    foreach ($group in $groups) {
        Remove-ADGroup -Identity $group.DistinguishedName -Confirm:$false
        Write-Host "Group $($group.Name) has been removed."
    }
}
CleanUp