# Lister tous les services dont le Status et "Running"

    Get-Service | Where-Object {$_.Status -eq "Running"}

# Compter les processus dont le Status et "Running"

    #1ère méthode
    (Get-Service | Where-Object {$_.Status -eq "Running"}).Count
    
    #2ème méthode
      $Services = Get-Service | Where-Object {$_.Status -eq "Running"}
      $Services.count
    
      #1ère méthode
      $(Get-Service | Where-Object {$_.Status -eq "Running"}).Count
