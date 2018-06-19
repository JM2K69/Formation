#Informations et Aide
    # Recuperations des informations du domaine AD
        $fqdn = Get-ADDomain
        $fulldomain = $fqdn.DNSRoot
        $domain = $fulldomain.split(".")
        $Dom = $domain[0]
        $Ext = $domain[1]

    # Utilisation de boucle 
        $test = ("PowerShell","Bash","Bourn")
        $Pwsh= $test[0]
        foreach ($item in $test) {

            Write-Host "$item est un Shell mais $Pwsh est le meilleur ;-) "
        }
        # Utilisation de Conditions
            $test = ("PowerShell","Bash","Bourn")
            foreach ($item in $test) {

               if ( $item -eq "PowerShell") 
                {
                    Write-Host "$item est un Shell mais $Pwsh est le meilleur ;-)  " -ForegroundColor Green
                }
                else
                 {
                    Write-Host "$item est un Shell mais $Pwsh est le meilleur ;-)  " -ForegroundColor Yellow
                }
            }

    #Creations des Objet
        # Création d'une OU sans Protection contre la   suppression
            New-ADOrganizationalUnit -Name "Simple,Basique" -Description "Dixit OrelSan"  -Path "DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false
        # Création d'un USER
            $MDP ="123+aze" # mot de passe
            $SecurePass = ConvertTo-SecureString $MDP -AsPlainText -Force #conversion en paramètre securisé 
            New-ADUser -Name jerome -Path "Distinguished Names" -AccountPassword $SecurePass
            Enable-ADAccount -Identity $name # Activation
            Set-ADUser -Identity $name -ChangePasswordAtLogon $false # Force le changemlent de MDP

