$structure = "Sites", "T0" , "T1" , "T2"

$sites = "Valence" , "Grenoble" , "Chambery"

$each_site = "Users" , "Groups" , "Computers"

$each_tier = "Users" , "Groups" , "Service Accounts"


function Create-Organizational-Unit {
    param($name, $OU)
    if ($OU -eq $null) {
        New-ADOrganizationalUnit -Name $name -Path "DC=devopsregnilo,DC=local"
    } else {
        New-ADOrganizationalUnit -Name $name -Path $OU
    }
}

foreach ($item in $structure) {
    echo $item
    Create-Organizational-Unit -name $item

    if ($item -like "T[0-2]") {
        foreach ($directory in $each_tier) {
            echo $item , $directory
            Create-Organizational-Unit -name $directory -OU "OU=$item,DC=devopsregnilo,DC=local"
        }
    } elseif ($item -eq "Sites") {
        foreach ($site in $sites) {
            echo $item , $site
            Create-Organizational-Unit -name $site -OU "OU=Sites,DC=devopsregnilo,DC=local"
            foreach ($element in $each_site) {
                echo $item, $site, $element
                Create-Organizational-Unit -name $element -OU "OU=$site,OU=Sites,DC=devopsregnilo,DC=local"
            }
        }
    }
}