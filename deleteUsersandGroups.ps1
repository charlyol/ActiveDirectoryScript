# Suppression des utilisateurs et des groupes créés
function CleanUp {
    Write-Host "Cleaning up users and groups created in IT-Valence..."

    $list = Get-ADUser -Filter 'Name -like "User*"'
    # Suppression des utilisateurs
    foreach ($username in $list.Name) {
        Remove-ADUser -Identity $username -Confirm:$false
        Write-Host "User $username has been removed."
    }
    $groups = Get-ADGroup -Filter 'Name -like "Valence" -or Name -like "Grenoble" -or Name -like "Chambery" -or Name -like "IT-Valence" -or Name -like "IT-Grenoble" -or Name -like "IT-Chambery"'
    # Suppression des groupes
    foreach ($group in $groups) {
        Remove-ADGroup -Identity $group.DistinguishedName -Confirm:$false
        Write-Host "Group $($group.Name) has been removed."
    }
}
CleanUp