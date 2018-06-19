      # Autorisation d'un serveur DHCP dans ADDS
        Add-DhcpServerInDC -DnsName $env:COMPUTERNAME  
    
    # Création d'une étendue DHCP
        Add-DhcpServerv4Scope -name "Interne" -StartRange 10.0.10.0 `
        -EndRange 10.0.20.0 `
        -SubnetMask 255.0.0.0 `
        -Description "Internal" `
        -State Active 
    
    # Ajouts d'option dans une étendue DHCP
        Set-DhcpServerv4OptionValue -ScopeID "10.0.0.0" `
        -DnsServer 10.0.0.1 `
        -DnsDomain 'Form.aca' `
        -Routeur 10.255.255.254

    # Creation de la Zone DNS
        Add-DNSServerPrmaryZone -Name Pwsh.loc -computerName $SrvDNS -ReplicationScope -Domain
    # Ajout d'un Enregistrement de Type A
        Add-DnsServerRessourceRecordA -name www -IpvAAddress 10.0.0.90 -Zone Pwsh.loc -computerName $SrvDNS
        Add-DnsServerRessourceRecordA -name Proget -IpvAAddress 172.17.5.77 -Zone 'Your.domain' -computerName $SrvDNS
