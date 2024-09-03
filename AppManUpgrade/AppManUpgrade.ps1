
$parameters1 = @{
    ComputerName = (Get-Content PrimaryServers.txt)
    ScriptBlock = {upgrade}
}

$parameters2 = @{
    ComputerName = (Get-Content StandbyServers.txt)
    ScriptBlock = {upgrade}
}


function upgrade{
    # 1. Shutdown service.

    $AppManService = get-service "Applications Manager*"

    $AppManService.stop()

    #Check to make sure app man processes have stopped
    if(get-process -name "AppManagerTrayIcon" -eq true){
        taskkill /IM AppManagerTrayIcon /F
    }

    # 2. Download the .ppm and save it in a path.
            #this step is performed pre upgrade using FileUpload.ps1 script

    # 3. Create an empty "EC_Upgrade_Key.properties" in <APM home>/working folder.

    Set-Location E:\Program Files\ManageEngine\AppManager15\working
    New-Item -ItemType file "EC_Upgrade_Key.properties"

    # 4. Execute below command from <APM home>/bin folder to start upgrade.

    Set-Location E:\Program Files\ManageEngine\AppManager15
    updateManager.bat -option i -c -u "working\conf" -ppmPath "<path to ppm>\ManageEngine_Applications_Manager_16_0_SP-6_8.ppm"

    # 5. Check upgrade status in AppManager16/logs/updatemanagerlog0.txt.

    get-content E:\Program Files\ManageEngine\AppManager16\logs\updatemanagerlog0.txt -Wait | Where-Object { $_ -match 'installed successfully' } | Select -First 1

    # 6. Upgrade can be confirmed as successful via below cases : 

    #       a. Upgraded product version in <APM home>/conf/About.properties

            cat E:\Program Files\ManageEngine\AppManager16\conf\About.properties

    #       b. Below prints in "updatemanagerlog0.txt"

    #         8 Sep, 2023 11:51:14 AM  [com.adventnet.tools.update.installer.ApplyPatch]  [INFO] : Service Pack installed successfully
    #         8 Sep, 2023 11:51:14 AM  [com.adventnet.tools.update.installer.ApplyPatch]  [INFO] : Service pack [ ManageEngine_Applications_Manager-16.0-SP-6.8 ] installed successfully and upgraded to "ManageEngine Applications Manager (16.0)".
    #             c. cmd output - PFA cmd terminal screenshot.

    # 7. Product has to be started manually. 
    $AppManService = get-service "Applications Manager*"

    $AppManService.start()


}

Write-host("================================")
Write-Host("APP MAN UPGRADE STATUS")
Write-host("================================")

$AMPrimary = Read-Host "Would you like to upload file Primary App Man servers?(y/n)"
$AMPrimary = $AMPrimary.ToLower()

if ($AMPrimary -eq "y" -Or $AMPrimary -eq "yes"){
    Write-host("Primary Servers")
    Invoke-Command @parameters1 | Sort-Object -Property PSComputerName
}

$AMStandby = Read-Host "Would you like to upload file to Standby App Man servers?(y/n)"
$AMStandby = $AMStandby.ToLower()

if ($AMStandby -eq "y" -Or $AMStandby -eq "yes"){
    Write-Host("`n")
    Write-Host("Standby Servers")
    Invoke-Command @parameters2 | Sort-Object -Property PSComputerName  
}

Pause