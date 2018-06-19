#Installation et promotion du controleur de domaine

    #Installations des prés requis
    Install-windowsFeature -name AD-Domain-services -IncludeAllSubFeature -IncludeManagementTools
    
    #Création du domain AD 
    Install-ADDSforest -DomainName Pwsh.loc

#Poste Client    

    #Jonction de la machine au domaine Pwsh.loc
    Add-Computer -DomainName it-connect.fr -Credential Administrateur@Pwsh.loc

    #Vérification des tâches
        #Vérification des ports
            # LDAP
            Test-netConnection 10.0.10.1 -Port 389
             # DNS
             Test-netConnection 10.0.10.1 -Port 53
         #Résolutions de noms
            Resolve-DnsName "ADDS.Pwsh.loc"
            Resolve-DnsName "CLI.pwsh.loc"