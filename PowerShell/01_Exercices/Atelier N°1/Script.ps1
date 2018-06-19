# Notion et aide

    # Commande pour lister les Interfaces
        Get-NetAdapter
    # Attention il faut utiliser soit  l'alias de la carte réseau soit sont Index pour lui attribuer une IP
        #Utiliser des variables ! ! 
    # Lister toutes les commande pour les cartes réseaux
        Get-Command -Module NetAdapter 
    # Lister Les Rôles "Pour les Serveurs Uniquement" 
        Get-windowsFeature
    # Installer un Rôle 
    Install-windowsFeature -name 'Feature Name' -IncludeAllSubFeature -IncludeManagementTools 
    # Création d'un Domaine ADDS
    Install-ADDSforest -DomainName 'Nom de domaine' 

    