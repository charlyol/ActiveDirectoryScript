# Import data from the CSV file
$CSVFile = "C:\Users\Administrateur\Documents\ActiveDirectoryScript\files.csv"
$CSVData = Import-Csv -Path $CSVFile -Delimiter "," -Encoding Default

# Loop through each line of the CSV file
foreach ($User in $CSVData) {
    
    $UserForename = $User.Forename
    $UserName = $User.UserName
    $UserBirthDate = [datetime]::ParseExact($User.BirthDate, "dd/MM/yyyy", $null)
    $UserLogin = ($UserForename).Substring(0,1).ToLower() + "." + $UserName.ToLower()
    $UserMail = $UserLogin + "@devops-regnilo.local"
    
    # Create password using forename and birth day and month
    $UserPassword = $UserForename + $UserBirthDate.ToString("ddMM")
    $UserFonction = $User.Fonction

    if (Get-ADUser -Filter {SamAccountName -eq $UserLogin}) {
        Write-Host "User $UserLogin already exists"
    } else {
        Write-Host "User $UserLogin does not exist"
        New-ADUser -Name $UserForename `
                   -GivenName $UserForename `
                   -Surname $UserName `
                   -SamAccountName $UserLogin `
                   -UserPrincipalName $UserMail `
                   -EmailAddress $UserMail `
                   -AccountPassword (ConvertTo-SecureString $UserPassword -AsPlainText -Force) `
                   -Enabled $true `
                   -Path "OU=Users,DC=devops-regnilo,DC=local" `
                   -ChangePasswordAtLogon $true `
                   -Description $UserFonction

        Write-Output " User created : $UserLogin $UserPassword ($UserForename $UserName)"
    }
}