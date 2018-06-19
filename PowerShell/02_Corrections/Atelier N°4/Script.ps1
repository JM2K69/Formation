$computername ="."
# Get the object
$memoryslot = Get-WmiObject Win32_PhysicalMemoryArray -ComputerName $computername
$memory = Get-WMIObject Win32_PhysicalMemory -ComputerName $computername
$memorymeasure = Get-WMIObject Win32_PhysicalMemory -ComputerName $computername | Measure-Object -Property Capacity -Sum

#  Format and Print
"Total memory slot availabe: {0}" -f $memoryslot.MemoryDevices
"Maximum Capacity allowed: {0}GB" -f $($memoryslot.MaxCapacity/1024/1024)
"Total memory sticks installed: {0}" -f $memorymeasure.count
"Total RAM installed: {0}GB" -f $($memorymeasure.sum/1024/1024/1024)
""

(Get-NetIPAddress -InterfaceIndex $(Get-NetAdapter -Name 'Ethernet*').ifIndex -AddressFamily IPv4).IPAddress