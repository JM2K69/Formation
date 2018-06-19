#Connection à un ESXI ou vCenter
Connect-VIServer -Server 172.17.1.245 -Credential (Get-Credential)
#Récupérer les Hôtes
    Get-VMHost
#Récupérer les Datastores
    Get-Datastore
#Création déploiement de VM sur un ESXI à partir d'un OVF ou OVA
    Import-VApp -Name VM1 -Source $ovf_Files -VMHost $HostESXI -Datastore $Datastore -DiskStorageFormat Thin

#Récupérer un Template et le clonner
    Get-Template
    new-vm -Name BLA -VM $template -VMHost $HostESXI -Datastore $Datastore -DiskStorageFormat Thin 

$chemin       = 'ISO'
$Destination  = $(get-datastore -name L_ESXI).DatastoreBrowserPath
$iso          = 'D:\Win2K3_VMware.iso'

Copy-DatastoreItem $iso -Destination "$Destination\$chemin"


New-VM -Name Win2K3_GProf `
      -DiskGB 4 `
      -DiskStorageFormat Thin `
      -MemoryGB 1 `
      -CD `
      -ResourcePool ("192.168.0.30") `
      -GuestId 'winNetStandardGuest' `
      -NetworkName:"VM Network" `
      -Datastore ("L_ESXI")

      New-CDDrive -VM Win2K3_GProf -IsoPath "[L_ESXI] ISO\Win2K3_VMware.iso" -StartConnected

      start-vm Win2K3_GProf

      New-NetworkAdapter -VM Win2K3_GProf -NetworkName HydrationKit -StartConnected -Type e1000
      Get-NetworkAdapter -VM Win2K3_GProf
      
      Get-VM -Name Win2K3_GProf | Get-NetworkAdapter -Name "Network adapter 2" | Set-NetworkAdapter -NetworkName "VM Network" -Confirm:$false     |Out-Null
    
      Get-VM -Name Win2K3_GProf | Where-Object {$_.PowerState –eq “PoweredOn”} | Get-CDDrive | Set-CDDrive -NoMedia -Confirm:$False
      Get-VM -Name Win2K3_GProf | Shutdown-VMGuest -Confirm:$false
      Get-VM -Name Win2K3_GProf | Export-VApp -Destination d:\ -Name VM2K3Pwsh -Format OVA