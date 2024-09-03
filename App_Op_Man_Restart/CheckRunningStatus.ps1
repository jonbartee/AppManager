$parameters1 = @{
    ComputerName = (Get-Content PrimaryServers.txt)
    Credential = "GAC\<s account here>"
    ScriptBlock = {     
        get-service "Applications Manager*"
    }
}

$parameters2 = @{
    ComputerName = (Get-Content StandbyServers.txt)
    Credential = "GAC\<s account here>"
    ScriptBlock = {
        get-service "Applications Manager*"
    }
}

$parameters3 = @{
    ComputerName = (Get-Content OpManServers.txt)
    Credential = "GAC\<s account here>"
    ScriptBlock = {
        get-service "OpManager*"
    }
}




Write-host("================================")
Write-Host("APP MAN SERVICE STATUS")
Write-host("================================")
Write-host("Primary Servers")
Invoke-Command @parameters1 | Sort-Object -Property PSComputerName
Write-Host("`n")
Write-Host("Standby Servers")
Write-Host("`n")
Invoke-Command @parameters2 | Sort-Object -Property PSComputerName
Write-Host("`n")
Write-host("================================")
Write-Host("OPMAN SERVICE STATUS")
Write-host("================================")
Write-Host("OpManager Servers")
Write-Host("`n")
Invoke-Command @parameters3 | Sort-Object -Property PSComputerName

Pause