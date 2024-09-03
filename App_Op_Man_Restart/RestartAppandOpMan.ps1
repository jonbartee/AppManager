$parameters1 = @{
    ComputerName = (Get-Content PrimaryServers.txt)
    Credential = "GAC\<s account here>"
    ScriptBlock = {
        restart-service -name "Applications Manager*"
    }     
}

$parameters2 = @{
    ComputerName = (Get-Content StandbyServers.txt)
    Credential = "GAC\<s account here>"
    ScriptBlock = {
        restart-service -name "Applications Manager*"
    }
}

$parameters3 = @{
    ComputerName = (Get-Content PrimaryOpManServers.txt)
    Credential = "GAC\<s account here>"
    ScriptBlock = {
        restart-service -name "OpManager*"
    }
}

$AMPrimary = Read-Host "Would you like to restart primary App Man servers?(y/n)"
$AMPrimary = $AMPrimary.ToLower()

if ($AMPrimary -eq "y" -Or $AMPrimary -eq "yes"){
    Write-host("================================")
    Write-Host("APP MAN SERVICE STATUS")
    Write-host("================================")
    Write-host("Primary Servers")
    Invoke-Command @parameters1 | Sort-Object -Property PSComputerName
}

$AMStandby = Read-Host "Would you like to restart standby App Man servers?(y/n)"
$AMStandby = $AMStandby.ToLower()

if ($AMStandby -eq "y" -Or $AMStandby -eq "yes"){
    Write-Host("`n")
    Write-Host("Standby Servers")
    Write-Host("`n")
    Invoke-Command @parameters2 | Sort-Object -Property PSComputerName
}

$OM = Read-Host "Would you like to restart OpMan servers?(y/n)"
$OM = $OM.ToLower()

if ($OM -eq "y" -Or $OM -eq "yes"){
    Write-Host("`n")
    Write-host("================================")
    Write-Host("OPMAN SERVICE STATUS")
    Write-host("================================")
    Write-Host("OpManager Servers")
    Write-Host("`n")   
    Invoke-Command @parameters3 | Sort-Object -Property PSComputerName
}

Pause