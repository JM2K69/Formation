#Connection à un ESXI ou vCenter
    Connect-VIServer -Server 192.168.0.30 -Credential (Get-Credential)
    #Récupérer les Hôtes
        Get-VMHost
    #Récupérer les Datastores
        Get-Datastore
    #Création déploiement de VM sur un ESXI à partir d'un OVF ou OVA
        Import-VApp -Name VM1 -Source $ovf_Files -VMHost $HostESXI -Datastore $Datastore -DiskStorageFormat Thin

    #Récupérer un Template et le clonner
        Get-Template
        new-vm -Name BLA -VM $template -VMHost $HostESXI -Datastore $Datastore -DiskStorageFormat Thin 

  

