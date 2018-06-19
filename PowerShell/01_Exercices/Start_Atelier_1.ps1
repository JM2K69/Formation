############################################################
#  Author : Jérôme Bezet-Torres                            #
#  Date : Avril 2018                                       #
#  Version 1.2                                             #
#  Twitter : @JM2K69                                       #
#  Blog : https://jm2k69.github.io                         #
############################################################        
[String]$ScriptDirectory = split-path $MyInvocation.MyCommand.path
$verboseLogFile = $ScriptDirectory+"\Atelier1.log"
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
$Client = get-VM -Name G*_W10A

Write-Host "---------- Atelier N°1 Start ----------" -ForegroundColor Green
Write-Host ""
Write-Host "---------- Starting VM  ----------" -ForegroundColor Cyan
foreach ($item in $Server.name) 
    {
        $first=(get-vm -name $item).PowerState

        if ($first -eq 'PoweredOff') 
        {
            New-Logtrace "The VM $item is already shutdown try to Power On"
            New-Logtrace "Starting the Server $item"
            start-vm $item | Out-Null
            Wait-Tools -VM $item |Out-Null
            New-Logtrace "The Server $item is ready"
    
        }

    }
    foreach ($item in $Client.name) 
    {
        $first=(get-vm -name $item).PowerState

        if ($first -eq 'PoweredOff') 
        {
            New-Logtrace "The VM $item is already shutdown try to Power On"
            New-Logtrace "Starting the Client $item"
            start-vm $item | Out-Null
            Wait-Tools -VM $item |Out-Null
            New-Logtrace "The Client $item is ready"
            }
    }
Write-Host "---------- End Starting VM  ----------" -ForegroundColor Cyan

$EndTime = Get-Date
$duration = [math]::Round((New-TimeSpan -Start $StartTime -End $EndTime).TotalMinutes,2)

New-Logtrace "Atelier N°1 Starting in complete"
New-Logtrace "StartTime: $StartTime"
New-Logtrace "EndTime: $EndTime"
New-Logtrace "Duration: $duration minutes"
