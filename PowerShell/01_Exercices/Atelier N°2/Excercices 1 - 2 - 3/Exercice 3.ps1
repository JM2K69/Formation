#Informations et Aide
      # Autorisation d'un serveur DHCP dans ADDS
        Add-DhcpServerInDC -DnsName $env:COMPUTERNAME  
    
    # Création d'une étendue DHCP
        Add-DhcpServerv4Scope -name "Interne" -StartRange 172.17.0.10 `
        -EndRange 172.17.0.200 `
        -SubnetMask 255.255.0.0 `
        -Description "Internal" `
        -State Active 
    
    # Ajouts d'option dans une étendue DHCP
        Set-DhcpServerv4OptionValue -ScopeID "172.17.0.0" `
        -DnsServer 172.17.0.1 `
        -DnsDomain formation.local `
        -Routeur 172.17.255.254
    # DNS
        Get-Command -Module DnsServer
