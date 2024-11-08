$ErrorActionPreference = "Stop"
$VerbosePreference = "Continue"
# Import data from the CSV file
$CSVFile = "C:\Users\Administrateur\Documents\ActiveDirectoryScript\files.csv"
# Vérification si le fichier existe
if (Test-Path $CSVFile) {
    Write-Host "Le fichier CSV existe. Importation des données..."
} else {
    Write-Host "Le fichier CSV n'a pas été trouvé à l'emplacement spécifié."
    exit
}
$CSVData = Import-Csv -Path $CSVFile -Delimiter "," -Encoding Default
# Vérification si des données ont été importées
if ($CSVData.Count -eq 0) {
    Write-Host "Aucune donnée trouvée dans le fichier CSV."
    exit
}
# Loop through each line of the CSV file
foreach ($User in $CSVData) {
    $UserForename = $User.Forename
    $UserName = $User.Username
    $UserBirthDate = [datetime]::ParseExact($User.Birthdate, "dd/MM/yyyy", $null)
    $UserLogin = ($UserForename).Substring(0,1).ToLower() + "." + $UserName.ToLower()
    $UserMail = $UserLogin + "@devops-regnilo.local"

    # Create password using forename and birth day and month
    $UserPassword = $UserForename + $UserBirthDate.ToString("ddMM")
    $UserFonction = $User.Fonction
    # For testing purposes, display output
    Write-Host "Testing user creation:"
    Write-Host "Name: $UserForename $UserName"
    Write-Host "Login: $UserLogin"
    Write-Host "Email: $UserMail"
    Write-Host "Password: $UserPassword"
    Write-Host "Function: $UserFonction"
    Write-Host "------------------------------------------"
}