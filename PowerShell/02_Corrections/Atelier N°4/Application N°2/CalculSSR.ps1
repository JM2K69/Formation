##Initialize######
[System.Reflection.Assembly]::LoadWithPartialName('presentationframework') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.dll')       | out-null 
[System.Reflection.Assembly]::LoadFrom('assembly\MahApps.Metro.IconPacks.dll') | out-null
[System.Reflection.Assembly]::LoadFrom('assembly\System.Windows.Interactivity.dll') | out-null
Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -AssemblyName "System.Drawing"
[System.Windows.Forms.Application]::EnableVisualStyles()
[String]$ScriptDirectory = split-path $myinvocation.mycommand.path

function LoadXml ($global:filename)
{
    $XamlLoader=(New-Object System.Xml.XmlDocument)
    $XamlLoader.Load($filename)
    return $XamlLoader
}

# Load MainWindow
$XamlMainWindow=LoadXml("$ScriptDirectory\main.xaml")
$Reader=(New-Object System.Xml.XmlNodeReader $XamlMainWindow)
$Form=[Windows.Markup.XamlReader]::Load($Reader)

<#
$XamlMainWindow.SelectNodes("//*[@Name]") | %{"trying item $($_.Name)";
    try {Set-Variable -Name "$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop}
    catch{throw}
    }
 
Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}
 
 Get-FormVariables
 #>
$Check = $Form.findname("Check")
$Exit = $Form.findname("Exit")
$AddressIP = $Form.findname("NetLocal")
$Netmask = $Form.findname("Netmask") 
$R_Netw_Add = $Form.findname("R_Net_Add")
$R_Broadcast = $Form.findname("R_Broad")
$WillcardMask = $Form.findname("R_Will")
$R_Nb_guest = $Form.findname("R_Nb_H") 

#########################################################################
#                       Functions       								#
#########################################################################

$Check.add_Click({

    $Netlocal = $AddressIP.Text 
    $Netmask2 = $Netmask.Text

    $ip = $Netlocal
    $ip = $ip.split()
    $ip = $ip[0]

    $masque = $Netmask2
    $masque = $masque.split()
    $masque = $masque[0]

    #Définition de l'@ réseau et de la plage 
    $ip = $ip.split('.')
    $masque = $masque.split('.')

    $a = $ip[0] -band $masque[0]
    $b = $ip[1] -band $masque[1]
    $c = $ip[2] -band $masque[2]
    $d = $ip[3] -band $masque[3]

    #Adresse réseau
    $netaddr = "$a.$b.$c.$d"

    $R_Netw_Add.Content = $netaddr

    #Nombre de machine
    $e = 255 - $masque[0]
    $f = 255 - $masque[1]
    $g = 255 - $masque[2]
    $h = 255 - $masque[3]

    #Wildcast
    $will = "$e.$f.$g.$h"

    $WillcardMask.Content = $will

    #calcul du nombre d'hôtes sur le réseau
    $i = $a + $e
    $j = $b + $f
    $k = $c + $g
    $l = $d + $h

    #Adresse broadcast
    $broadcast = "$i.$j.$k.$l"

    $R_Broadcast.Content = $broadcast

    #Premier hôte sur le réseau
    $d += 1
    $premier = "$a.$b.$c.$d"

    #Dernier hôte sur le réseau
    $l -= 1
    $dernier = "$i.$j.$k.$l"

    #Nombre de machine dans la plage
    $e++
    $f++
    $g++
    $h++

    $nbrhote = $e * $f * $g * $h - 2
    $R_Nb_guest.Content = $nbrhote

})
    

$Exit.add_Click({
    break
})
$Form.ShowDialog() | Out-Null

