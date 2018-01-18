<#
.SYNOPSIS
Get-EventsInfo retrieves events from the event logs on a remote system.

.DESCRIPTION
Get-EventsInfo use get-event log to retrieve the event logs from 
one or more computers. It displays the number of events requested for
the specified logs.


.PARAMETER computername
The computer name, or names, to query. This is mandatory.

.PARAMETER logname
This is the name of the log to query. Default is System

.PARAMETER newestlogs
The number of logs to retrieve. Default is 100

.EXAMPLE
Get-EventsInfo -computername PS1 -Logname Application -NewestLogs 100

.Example
Get-EventsInfo -Computername PS1
#>
param (
    [parameter(mandatory=$true,HelpMessage="Enter a Remote Computername:")]
    [String]$computername,

    [String]$Logname="System",

    [int]$NewestLogs=100

)
Write-Verbose "Connecting to $computername"
Write-Verbose "Looking up the last $NewestLogs from the $Logname log for $computername"
Invoke-Command -ComputerName $computername {
    Get-Eventlog -LogName $using:Logname -Newest $using:NewestLogs   
}