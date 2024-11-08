true# Import data from the CSV file
$CSVFile = "C:\Users\Administrateur\Documents\ActiveDirectoryScript\files.csv"
$CSVData = Import-Csv -Path $CSVFile -Delimiter "," -Encoding Default

# Loop through each line of the CSV file
foreach ($User in $CSVData) {
    
    $UserForename = $User.Forename
    $UserName = $User.Username
    $UserBirthDate = [datetime]::ParseExact($User.Birthdate, "dd/MM/yyyy", $null)
    $UserLogin = ($UserForename).Substring(0,1).ToLower() + "." + $UserName.ToLower()
    $UserMail = $UserLogin + "@devopsregnilo.local"
    
    # Create password using forename and birth day and month
    $UserPassword = $UserForename + $UserBirthDate.ToString("ddMM")
    $UserFonction = $User.Fonction
    $UserSite = $User.site
    $UserPermission = $User.permission

    # Define the group name based on the site and permission
    $groupName = "$UserPermission"
    
    # Check if user already exists
    if (Get-ADUser -Filter {SamAccountName -eq $UserLogin}) {
        Write-Host "User $UserLogin already exists"
    } else {
        Write-Host "User $UserLogin does not exist"
        
        # Create the new user
        New-ADUser -Name $UserForename `
                   -GivenName $UserForename `
                   -Surname $UserName `
                   -SamAccountName $UserLogin `
                   -UserPrincipalName $UserMail `
                   -EmailAddress $UserMail `
                   -AccountPassword (ConvertTo-SecureString $UserPassword -AsPlainText -Force) `
                   -Enabled $true `
                   -Path "OU=Users,DC=devopsregnilo,DC=local" `
                   -ChangePasswordAtLogon $true `
                   -Description "$UserFonction at $UserSite"

        Write-Output "User created: $UserLogin with password $UserPassword ($UserForename $UserName)"
        
        # Add the user to the appropriate group based on their permission and site
        $group = Get-ADGroup -Filter { Name -eq $groupName }
        if ($group) {
            Add-ADGroupMember -Identity $group.DistinguishedName -Members $UserLogin
            Write-Host "User $UserLogin added to group $groupName"
        } else {
            Write-Host "Group $groupName not found. Please create it first."
        }
    }
}