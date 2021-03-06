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

$XamlMainWindow.SelectNodes("//*[@Name]") | %{
    try {Set-Variable -Name "$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop | out-null}
    catch{throw}
    }

#########################################################################
#                       Functions       								#
#########################################################################
#########################################################################
#                            End Functions       					   #
#########################################################################


$Check.add_Click({

    $R_Computer.Content = $env:COMPUTERNAME

    $memorymeasure = Get-WMIObject Win32_PhysicalMemory -ComputerName $env:COMPUTERNAME | Measure-Object -Property Capacity -Sum

    $R_RAM.Content = "{0} GB" -f $($memorymeasure.sum/1024/1024/1024)

    $AddressIpv4 = (Get-NetIPAddress -InterfaceIndex $(Get-NetAdapter -Name 'Ethernet').ifIndex -AddressFamily IPv4).IPAddress
    $Netmask = (Get-NetIPAddress -InterfaceIndex $(Get-NetAdapter -Name 'Ethernet').ifIndex -AddressFamily IPv4).PrefixLength
    $R_IPv4.Content = "$AddressIpv4 /$Netmask"

})
    

$Form.ShowDialog() | Out-Null

