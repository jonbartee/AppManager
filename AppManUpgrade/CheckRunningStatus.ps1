$parameters1 = @{
    ComputerName = (Get-Content PrimaryServers.txt)
    ScriptBlock = {get-service "Applications Manager*"}
}

$parameters2 = @{
    ComputerName = (Get-Content StandbyServers.txt)
    ScriptBlock = {get-service "Applications Manager*"}
}

Write-host("================================")
Write-Host("APP MAN SERVICE STATUS")
Write-host("================================")
Write-host("Primary Servers")
Invoke-Command @parameters1 | Sort-Object -Property PSComputerName
Write-Host("`n")
Write-Host("Standby Servers")
Invoke-Command @parameters2 | Sort-Object -Property PSComputerName

Pause