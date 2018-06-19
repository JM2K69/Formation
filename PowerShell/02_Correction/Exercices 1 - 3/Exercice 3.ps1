#Lister tous les services dont le status et ″Running″ mais afficher que les cinq derniers
Get-Service | Where-Object {$_.Status -eq "Running"} | Select-Object -Last 5

#Lister tous les services dont la description contient ″ Windows ″ et grouper les en fonctions de leur status
Get-Service | Where-Object {$_.DisplayName -like "*Windows*"} | Group-Object -Property Status
