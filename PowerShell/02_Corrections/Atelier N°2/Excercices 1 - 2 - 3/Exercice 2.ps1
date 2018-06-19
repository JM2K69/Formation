# Recuperations des informations du domaine AD
$fqdn = Get-ADDomain
$fulldomain = $fqdn.DNSRoot
$domain = $fulldomain.split(".")
$Dom = $domain[0]
$Ext = $domain[1]

# Informations des Sites et Services
$Sites = ("Debrousses","Croix-Rousse","Saint-Just")
$Services = ("Administratifs","Direction","Comptabilite")
$Formations =("BTS_SIO","BTS_CG","BTS_AM","Term_STMG")

New-ADOrganizationalUnit -Name "Ecole" -Description "OU racine"  -Path "DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false

foreach ($S in $Sites)
    {
        new-ADOrganizationalUnit -Name $S -Path "OU=Ecole,DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false

        foreach ($F in $Formations) {
            
            new-ADOrganizationalUnit -Name $F -Path "OU=$S,OU=Ecole,DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false

                1..12 | % {
                $MDP ="123+aze"
                $name = "E"+"_"+$S.Substring(0,3)+"_"+$F.Substring(4)+"_"+"{0:00}" -f $_
                $SecurePass = ConvertTo-SecureString $MDP -AsPlainText -Force
                New-ADUser -Name $name -UserPrincipalName "$name@$Dom.$Ext"-Path "OU=$F,OU=$S,OU=Ecole,DC=$Dom,DC=$EXT" -AccountPassword $SecurePass
                Enable-ADAccount -Identity $name
                Set-ADUser -Identity $name -ChangePasswordAtLogon $false
                }
        }
        if ($S -eq "Croix-Rousse")
        {
            foreach ($Se in $Services) 
            {
                new-ADOrganizationalUnit -Name $Se -Path "OU=$S,OU=Ecole,DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false
    
                    1..3 | % {
                $MDP ="123+aze"
                $name = "Emp"+"_"+$S.Substring(0,3)+"_"+ $Se.Substring(0,3)+"_"+"{0:00}" -f $_
                $SecurePass = ConvertTo-SecureString $MDP -AsPlainText -Force
                New-ADUser -Name $name -UserPrincipalName "$name@$Dom.$Ext"-Path "OU=$Se,OU=$S,OU=Ecole,DC=$Dom,DC=$EXT" -AccountPassword $SecurePass
                Enable-ADAccount -Identity $name
                Set-ADUser -Identity $name -ChangePasswordAtLogon $false
                }
            }

         }
    }
