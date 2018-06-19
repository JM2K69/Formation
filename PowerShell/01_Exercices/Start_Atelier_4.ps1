############################################################
#  Author : Jérôme Bezet-Torres                            #
#  Date : Avril 2018                                       #
#  Version 1.2                                             #
#  Twitter : @JM2K69                                       #
#  Blog : https://jm2k69.github.io                         #
############################################################        
[String]$ScriptDirectory = split-path $MyInvocation.MyCommand.path
$verboseLogFile = $ScriptDirectory+"\Atelier4.log"
Function New-Logtrace 
{
    param(
    [Parameter(Mandatory=$true)]
    [String]$message
    )

    $timeStamp = Get-Date -Format "MM-dd-yyyy/%H:mm:ss"

    Write-Host -NoNewline -ForegroundColor Gray "[$timestamp]"
    Write-Host -ForegroundColor Green " $message"
    $logMessage = "{$timeStamp} $message"
    $logMessage | Out-File -Append -LiteralPath $verboseLogFile
}
$StartTime = Get-Date

$Server = get-vm -Name G*_ADDS_A1
$ESXI = get-vm -Name G*_Esxi*
$Client = get-VM -Name G*_W10A

Write-Host "---------- Atelier N°4 Start ----------" -ForegroundColor Green
write-host ""
# Shutdown Party #
Write-Host "---------- Shutdown VM  ----------" -ForegroundColor Yellow

foreach ($item in $Server.name) 
    {
        $first=(get-vm -name $item).PowerState

        if ($first -eq 'PoweredOff') 
        {
            New-Logtrace "The VM $item is already shutdown"
        }
        else 
        {
           New-Logtrace "The VM $item is PoweredOn Try to shutdonw"
           
           get-vm $item | Sort-Object Name | Shutdown-VMGuest -Confirm$false |Out-Null
          
          do 
          { 
            $info = (get-vm -Name $item).PowerState
            if ($info -eq 'PoweredOn')
                {
                    New-Logtrace "The VM $item is in progress to be Shudown"
                    Start-Sleep -Seconds 5 
                }
                              
          } until ($info -eq 'PoweredOff')
           
        }
    }

foreach ($item in $ESXI.name) 
    {
        $first=(get-vm -name $item).PowerState

        if ($first -eq 'PoweredOff') 
        {
            New-Logtrace "The VM $item is already shutdown"
        }
        else 
        {
           New-Logtrace "The VM $item is PoweredOn Try to shutdonw"
           
               get-vm $item | Sort-Object Name | Shutdown-VMGuest -Confirm$false |Out-Null
           
          do 
          { 
            $info = (get-vm -Name $item).PowerState
            if ($info -eq 'PoweredOn')
                {
                    New-Logtrace "The VM $item is in progress to be Shudown"
                    Start-Sleep -Seconds 5
                }
                              
          } until ($info -eq 'PoweredOff')
           
        }
    }
# End Shutdown Party #
Write-Host "---------- End Shutdown VM  ----------" -ForegroundColor Yellow

Write-Host "---------- Starting VM  ----------" -ForegroundColor Cyan

#Startup Party#
foreach ($item in $Client.name) 
    {
        $first=(get-vm -name $item).PowerState

        if ($first -eq 'PoweredOn') 
        {
            New-Logtrace "The VM $item is already PoweredOn"
        }
        else 
        {
           New-Logtrace "The VM $item is PoweredOff Try to PoweredOn"
           
           Start-vm $item |Out-Null
  
           Wait-Tools -VM $item | Out-Null

           New-Logtrace "The VM $item is Ok!"           
        }
    }

#End Startup Party#
Write-Host "---------- End Starting VM  ----------" -ForegroundColor Cyan

    $EndTime = Get-Date
$duration = [math]::Round((New-TimeSpan -Start $StartTime -End $EndTime).TotalMinutes,2)

New-Logtrace "Atelier N°4 Starting in complete"
New-Logtrace "StartTime: $StartTime"
New-Logtrace "EndTime: $EndTime"
New-Logtrace "Duration: $duration minutes"
