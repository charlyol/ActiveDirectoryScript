$tiers = "T0", "T1", "T2"
$sites= "Site1", "Site2", "Site3"
# Définir les groupes
foreach ($tier in $tiers) {
    New-ADGroup -Name "$tier Admins" -SamAccountName "${tier}Admins" -GroupCategory Security -GroupScope Global -DisplayName "$tier Administrators" -Path "OU=Groups,OU=$tier,DC=devops,DC=forest" -Description "Members of this group are Administrators"
    New-ADGroup -Name "$tier Developers" -SamAccountName "${tier}Developers" -GroupCategory Security -GroupScope Global -DisplayName "$tier Developers" -Path "OU=Groups,OU=$tier,DC=devops,DC=forest" -Description "Members of this group are Developers"
    New-ADGroup -Name "$tier Users" -SamAccountName "${tier}Users" -GroupCategory Security -GroupScope Global -DisplayName "$tier Users" -Path "OU=Groups,OU=$tier,DC=devops,DC=forest" -Description "Members of this group are Users"

    $string="$tier Admins"
    $admins=Get-ADGroup -Filter { Name -eq $string }
    $string="$tier Users"
    $users=Get-ADGroup -Filter { Name -eq $string}
    $string="$tier Developers"
    $devs=Get-ADGroup -Filter { Name -eq $string }
    echo $tier , $admins , $devs , $users

    $password = (ConvertTo-SecureString -AsPlainText "P@ssword123" -Force)
    # Créer les utilisateurs pour $tier
    for ($i = 1; $i -le 10; $i++) {
        # Définir les attributs des utilisateurs
        $username = "User$tier-$i"
        $role = if ($i -le 2) { "Admin" } elseif ($i -le 5) { "Developer" } else { "User" }
        $userAttributes = @{
            Name = $username
            GivenName = "FirstName$tier$i"
            Surname = "LastName$tier$i"
            SamAccountName = $username
            UserPrincipalName = "$username@devops.forest"
            Path = "OU=Users,OU=$tier,DC=devops,DC=forest"
            AccountPassword = $password
            Enabled = $true
            PasswordNeverExpires = $false
            ChangePasswordAtLogon = $true
        }

        # Créer l'utilisateur
        New-ADUser @userAttributes

        # Ajouter l'utilisateur au groupe correspondant
        switch ($role) {
            "Admin" { Add-ADGroupMember -Identity $admins.DistinguishedName -Members $username }
            "Developer" { Add-ADGroupMember -Identity $devs.DistinguishedName  -Members $username }
            "User" { Add-ADGroupMember -Identity $users.DistinguishedName  -Members $username }
        }

        Write-Host "User $username with role $role created and added to the appropriate group."
    }
}

foreach ($site in $sites) {
    New-ADGroup -Name "$site Admins" -SamAccountName "${site}Admins" -GroupCategory Security -GroupScope Global -DisplayName "$site Administrators" -Path "OU=Groups,OU=$site,OU=Sites,DC=devops,DC=forest" -Description "Members of this group are Administrators"
    New-ADGroup -Name "$site Developers" -SamAccountName "${site}Developers" -GroupCategory Security -GroupScope Global -DisplayName "$site Developers" -Path "OU=Groups,OU=$site,OU=Sites,DC=devops,DC=forest" -Description "Members of this group are Developers"
    New-ADGroup -Name "$site Users" -SamAccountName "${site}Users" -GroupCategory Security -GroupScope Global -DisplayName "$site Users" -Path "OU=Groups,OU=$site,OU=Sites,DC=devops,DC=forest" -Description "Members of this group are Users"
    
    $string="$site Admins"
    $admins=Get-ADGroup -Filter { Name -eq $string }
    $string="$site Users"
    $users=Get-ADGroup -Filter { Name -eq $string}
    $string="$site Developers"
    $devs=Get-ADGroup -Filter { Name -eq $string }
    
    $password = (ConvertTo-SecureString -AsPlainText "P@ssword123" -Force)
    # Créer les utilisateurs pour $site
    for ($i = 1; $i -le 10; $i++) {
        # Définir les attributs des utilisateurs
        $username = "User$site-$i"
        $role = if ($i -le 2) { "Admin" } elseif ($i -le 5) { "Developer" } else { "User" }
        $userAttributes = @{
            Name = $username
            GivenName = "FirstName$site$i"
            Surname = "LastName$site$i"
            SamAccountName = $username
            UserPrincipalName = "$username@devops.forest"
            Path = "OU=Users,OU=$site,OU=Sites,DC=devops,DC=forest"
            AccountPassword = $password
            Enabled = $true
            PasswordNeverExpires = $false
            ChangePasswordAtLogon = $true
        }

        # Créer l'utilisateur
        New-ADUser @userAttributes

        # Ajouter l'utilisateur au groupe correspondant
        switch ($role) {
            "Admin" { Add-ADGroupMember -Identity $admins.DistinguishedName -Members $username }
            "Developer" { Add-ADGroupMember -Identity $devs.DistinguishedName -Members $username }
            "User" { Add-ADGroupMember -Identity $users.DistinguishedName -Members $username }
        }

        Write-Host "User $username with role $role created and added to the appropriate group."
    }
}