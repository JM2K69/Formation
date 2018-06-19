
$Modules = Get-Module -ListAvailable # Stocker Tous les module => Variables
$Location = "e:\Modules PowerShell" # Stocker L'emplacement dans une Variable
foreach ($i in $Modules)
{
    $File = "Cmdlet" +"_"+ $i+".txt"
    $Rep = "Modules $i"
    New-Item -Name $Rep -Path "$Location\" -ItemType Directory |Out-Null
    Get-Command -Module $i | Out-File -FilePath "$Location\$Rep\$File"
}
