$fqdn = Get-ADDomain
$fulldomain = $fqdn.DNSRoot
$domain = $fulldomain.split(".")
$Dom = $domain[0]
$Ext = $domain[1]
$userPassword = '123+aze'
$Nb_employés = 5
$Nb_Eleves = 30
$Nb_Profs = 18


# Informations des Sites et Services
$Sites = ("Debrousses","Croix-Rousse","Saint-Just")
$Services = ("Administratifs","Direction","Comptabilite")
$Formations =("BTS_SIO","BTS_CG","BTS_AM","Term_STMG")
######  fonctions  ###########
function Get-RandomUser {
    <#
        .SYNOPSIS
            Generate random user data.
        .DESCRIPTION
            This function uses the free API for generating random user data from https://randomuser.me/
        .EXAMPLE
            Get-RandomUser 10
        .EXAMPLE
            Get-RandomUser -Amount 25 -Nationality us,gb -Format csv -ExludeFields picture
        .LINK
            https://randomuser.me/
        
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateRange(1,5000)]
        [int] $Amount,

        [Parameter()]
        [ValidateSet('Male','Female')]
        [string] $Gender,

        # Supported nationalities: AU, BR, CA, CH, DE, DK, ES, FI, FR, GB, IE, IR, NL, NZ, TR, US
        # Pictures won't be affected by this, but data such as location, cell/home phone, id, etc. will be more appropriate.
        [Parameter()]
        [string[]] $Nationality,

        # Seeds allow you to always generate the same set of users.
        [Parameter()]
        [int] $Seed,

        [Parameter()]
        [ValidateSet('json','csv','yaml','xml')]
        [string] $Format = 'json',

        # Fields to include in the results.
        # Supported values: gender, name, location, email, login, registered, dob, phone, cell, id, picture, nat
        [Parameter()]
        [string[]] $IncludeFields,

        # Fields to exclude from the the results.
        # Supported values: gender, name, location, email, login, registered, dob, phone, cell, id, picture, nat
        [Parameter()]
        [string[]] $ExcludeFields
    )

    $rootUrl = "http://api.randomuser.me/?format=$($Format)"

    if ($Amount) {
        $rootUrl += "&results=$($Amount)"
    }

    if ($Gender) {
        $rootUrl += "&gender=$($Gender)"
    }

    if ($Seed) {
        $rootUrl += "&seed=$($Seed)"
    }

    if ($Nationality) {
        $rootUrl += "&nat=$($Nationality -join ',')"
    }

    if ($IncludeFields) {
        $rootUrl += "&inc=$($IncludeFields -join ',')"
    }

    if ($ExcludeFields) {
        $rootUrl += "&exc=$($ExcludeFields -join ',')"
    }
    
    Invoke-RestMethod -Uri $rootUrl
}

####### Fin Fonctions ########
New-ADOrganizationalUnit -Name "Ecole" -Description "OU racine"  -Path "DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit -Name "Profs" -Description "Professeurs"  -Path "OU=Ecole,DC=$Dom,DC=$EXT" -ProtectedFromAccidentalDeletion $false
$users = Get-RandomUser -Amount $Nb_Profs -Nationality fr -IncludeFields name,dob,phone,cell -ExcludeFields picture | Select-Object -ExpandProperty results
foreach ($user in $users)
         {
            $newUserProperties = @{
            Name = "$($user.name.first) $($user.name.last)"
            GivenName = $user.name.first
            Surname = $user.name.last
            Path = "OU=Profs,OU=Ecole,DC=$Dom,DC=$EXT"
            title = "Professeur"
            OfficePhone = $user.phone
            MobilePhone = $user.cell
            EmailAddress="$($user.name.first).$($user.name.last)@$($fulldomain)"
            AccountPassword = (ConvertTo-SecureString $userPassword -AsPlainText -Force)
            SamAccountName = $($user.name.first).Substring(0,1)+$($user.name.last)
            UserPrincipalName = "$(($user.name.first).Substring(0,1)+$($user.name.last))@$($fulldomain)"
            Enabled = $true
            ChangePasswordAtLogon = $true
            }
    
        try {New-ADUser @newUserProperties} 
        catch {}
        }
foreach ($S in $Sites)
    {
        new-ADOrganizationalUnit -Name $S -Path "OU=Ecole,DC=$Dom,DC=$EXT" -Description "Site de $S" -ProtectedFromAccidentalDeletion $false

        foreach ($F in $Formations) {
            
            new-ADOrganizationalUnit -Name $F -Path "OU=$S,OU=Ecole,DC=$Dom,DC=$EXT" -Description "Formation $F" -ProtectedFromAccidentalDeletion $false

         $users = Get-RandomUser -Amount $Nb_Eleves -Nationality fr -IncludeFields name,dob,phone,cell -ExcludeFields picture | Select-Object -ExpandProperty results

        foreach ($user in $users)
         {
            $newUserProperties = @{
            Name = "$($user.name.first) $($user.name.last)"
            City = "$S"
            GivenName = $user.name.first
            Surname = $user.name.last
            Path = "OU=$F,OU=$S,OU=Ecole,DC=$Dom,DC=$EXT"
            title = "Elèves de $F"
            department="$F"
            OfficePhone = $user.phone
            MobilePhone = $user.cell
            Company="Ecole site de $S"
            EmailAddress="$($user.name.first).$($user.name.last)@$($fulldomain)"
            AccountPassword = (ConvertTo-SecureString $userPassword -AsPlainText -Force)
            SamAccountName = $($user.name.first).Substring(0,1)+$($user.name.last)
            UserPrincipalName = "$(($user.name.first).Substring(0,1)+$($user.name.last))@$($fulldomain)"
            Enabled = $true
            ChangePasswordAtLogon = $true
            }
    
        try {New-ADUser @newUserProperties} 
        catch {}
        }

        }
        if ($S -eq "Croix-Rousse")
        {
            foreach ($Se in $Services) 
            {
                new-ADOrganizationalUnit -Name $Se -Path "OU=$S,OU=Ecole,DC=$Dom,DC=$EXT"  -Description "Service $Se du site $S " -ProtectedFromAccidentalDeletion $false
    
        $users = Get-RandomUser -Amount $Nb_employés -Nationality fr -IncludeFields name,dob,phone,cell -ExcludeFields picture | Select-Object -ExpandProperty results

        foreach ($user in $users) {
        $newUserProperties = @{
        Name = "$($user.name.first) $($user.name.last)"
        City = "$S"
        GivenName = $user.name.first
        Surname = $user.name.last
        Path = "OU=$se,OU=$S,OU=Ecole,DC=$Dom,DC=$EXT"
        title = "Employés"
        department="$Se"
        OfficePhone = $user.phone
        MobilePhone = $user.cell
        Company="Ecole"
        EmailAddress="$($user.name.first).$($user.name.last)@$($fulldomain)"
        AccountPassword = (ConvertTo-SecureString $userPassword -AsPlainText -Force)
        SamAccountName = $($user.name.first).Substring(0,1)+$($user.name.last)
        UserPrincipalName = "$(($user.name.first).Substring(0,1)+$($user.name.last))@$($fulldomain)"
        Enabled = $true
        ChangePasswordAtLogon = $true
    }
    try {New-ADUser @newUserProperties} catch {}
}
            }
        }

    }
