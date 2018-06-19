#Configuration d'une machine Windows de base
    #Serveur Core
        #Adresse IP
        $InterfaceIndex = $(Get-NetAdapter -Name "*Ethernet*").ifIndex

        New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress 10.0.10.1 -PrefixLength 8 -DefaultGateway 10.255.255.254`
        
        #redemarrage
        Rename-Computer -NewName "ADDS" -Force -Restart

        #Poste Client
        #Adresse IP
        $InterfaceIndex = $(Get-NetAdapter -Name "*Ethernet*").ifIndex

        New-NetIPAddress -InterfaceIndex $InterfaceIndex -IPAddress 10.0.10.2 -PrefixLength 8 -DefaultGateway 10.255.255.254`
        Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses 10.0.10.1
        #redemarrage
        Rename-Computer -NewName "CLI" -Force -Restart