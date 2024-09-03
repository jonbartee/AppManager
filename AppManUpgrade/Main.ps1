<<<<<<< HEAD
=======



>>>>>>> main
$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path .\log.txt

<<<<<<< HEAD
$global:vaildChoice = 1,2,3,4,5,6,7


function mainMenu{
    cls
    Write-Host('
    1. Stop App Man Services
    2. Upload .ppm file to App Man Servers
    3. Run App Man Backup Process
    4. Upgrade App Man Servers
    5. Check Upgrade Status
    6. Start App Man Services
    7. Check Running Status of App Man Service
    Press q to quit
    ')
    $global:scriptChoice = Read-Host("Please make a selection")
    cls
}

function serverMenu{
    Write-Host '
    Select servers to run script on:
    1. Primary Servers
    2. Standby Servers
    3. Primary and Standby Servers
    4. Test Servers
    Press q to quit
    '
    $serverChoice = Read-Host("Please make a selection")

    switch($serverChoice){
        1{
            $global:serverFile = ".\PrimaryServers.txt"
        }
        2{
            $global:serverFile = ".\StandbyServers.txt"
        }
        3{
            $global:serverFile = ".\AllServers.txt"
        }
        4{
            $global:serverFile = ".\TestServers.txt"
        }
        q{
            $global:serverFile = $null
            break
            pause
        }
    }
    cls
}

function checkRunningStatus{

    $parameters = @{
        ComputerName = (Get-Content $serverFile)
        ScriptBlock = {Get-Service "Applications Manager*"}
    }

    $results = invoke-command @parameters

    foreach ($result in $results){
        if($result.status -eq "Running"){
            Write-Host("Please run shutdownAppMan.ps1 script before executing upgrade or backup script")
            $global:scriptChoice = $null
            break
        }
    }
}

do{
    mainMenu
    
    if($scriptChoice -eq "q"){
        break
    }
    elseif($scriptChoice -in $vaildChoice){

        serverMenu

        if ($scriptChoice -eq 1 -or $scriptChoice -eq 3){
            Write-Host("checking status")
            checkRunningStatus
        }

        switch($scriptChoice){

            1{ 
                .\shutdownAppMan.ps1 -File $serverFile
            }

            2{
                .\amFileUpload.ps1 -File $serverFile
            }
            
            3{  
                .\amBackup.ps1 -File $serverFile
            }

            4{
                .\amUpgrade.ps1 -File $serverFile
            }

            5{
                .\amUpgradeStatus.ps1 -File $serverFile
            }

            6{
                .\startAppMan.ps1 -File $serverFile
            }

            7{
                .\amServiceStatus -File $serverFile
            }
        }
    }
    else{
        Write-Host("Please make a valid selection")
        Pause
    }

    $scriptChoice = $null
    $serverFile = $null
}
until ($scriptChoice -eq 'q')
=======

function backupAppMan{
    # 1. Stop the ManageEngine Applications Manager service from Start → Run → services.msc 
    # (For Linux servers execute sh shutdownApplicationsManager.sh command from '<Applications Manager Home>' location).

    get-service "Applications Manager*"
    # Stop-Service "Applications Manager*"

    # 2. Via command prompt, execute the shutdownApplicationsManager.bat -force command from the '<Applications Manager Home>' folder. 
    # (For Linux servers execute sh shutdownApplicationsManager.sh -force command from '<Applications Manager Home>' location).

    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\"
    get-childitem shutdownApplicationsManager.bat

    #call bat script

    # 3. Go to the '<Applications Manager Home>/working/support' folder and delete all old support files (files with extension as .gz or .zip).
    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\working\Support\"
    get-childitem *.gz, *.zip
    
    #remove files
    #rm *.gz, *.zip

    # 4. Go to the '<Applications Manager Home>/working/webclient' and delete the 'temp' directory.
    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\working\webclient\"
    get-childitem "temp*"

    #delete temp directory
    #rm temp

    # 5. Go to the '<Applications Manager Home>' and delete the old logs folders (Example: logs_old or logs_date or logs.zip). Also delete logs folder under '<Applications Manager Home>/working' location. (Do not delete the 'logs' folder as it may be useful if any issues occur post upgrade, delete only old logs folders if present)

    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\"
    get-childitem *logs*

    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\working\"
    get-childitem *logs*

    #delete old logs

    # 6. Go to the '<Applications Manager Home>/working and delete hs_err_pid<xxxx>.log files & java_pid<xxxx>.hprof files if present (where xxxx can be any process ID).

    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\working\"

    get-childitem hs_err_pid*
    get-childitem java_pid*   

    # 7. Go to the '<Applications Manager Home>/working/heapdump' and delete the contents in that directory.
    
    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\working\heapdump\"
    Get-ChildItem

    #rm *

    # 8. Go to the '<Applications Manager Home>/working/backup' and delete the backups which are older than last one year. (If there is no backup then proceed to next step).

    Set-Location -Path "E:\Program Files\ManageEngine\AppManager15\working\backup\"

    Get-ChildItem

    # 9. Take a complete backup of '<Applications Manager Home>' folder. After that close all the explorer & command prompt windows.

    # If you are using Microsoft SQL server backend, then connect to the corresponding SQL server & take the backup of Applications Manager database.
    # will be done separately by DB backup team
}



function upgradeAppMan{
    # # 1. Shutdown service.

    # $AppManService = get-service "Applications Manager*"

    # $AppManService.stop()

    # #Check to make sure app man processes have stopped
    # if(get-process -name "AppManagerTrayIcon" -eq true){
    #     taskkill /IM AppManagerTrayIcon /F
    # }

    # # 2. Download the .ppm and save it in a path.
    #         #this step is performed pre upgrade using FileUpload.ps1 script

    # # 3. Create an empty "EC_Upgrade_Key.properties" in <APM home>/working folder.

    # Set-Location E:\Program Files\ManageEngine\AppManager15\working
    # New-Item -ItemType file "EC_Upgrade_Key.properties"

    # # 4. Execute below command from <APM home>/bin folder to start upgrade.

    # Set-Location E:\Program Files\ManageEngine\AppManager15
    # updateManager.bat -option i -c -u "working\conf" -ppmPath "<path to ppm>\ManageEngine_Applications_Manager_16_0_SP-6_8.ppm"

    # # 5. Check upgrade status in AppManager16/logs/updatemanagerlog0.txt.

    # get-content E:\Program Files\ManageEngine\AppManager16\logs\updatemanagerlog0.txt -Wait | Where-Object { $_ -match 'installed successfully' } | Select -First 1

    # # 6. Upgrade can be confirmed as successful via below cases : 

    # #       a. Upgraded product version in <APM home>/conf/About.properties

    #         cat E:\Program Files\ManageEngine\AppManager16\conf\About.properties

    # #       b. Below prints in "updatemanagerlog0.txt"

    # #         8 Sep, 2023 11:51:14 AM  [com.adventnet.tools.update.installer.ApplyPatch]  [INFO] : Service Pack installed successfully
    # #         8 Sep, 2023 11:51:14 AM  [com.adventnet.tools.update.installer.ApplyPatch]  [INFO] : Service pack [ ManageEngine_Applications_Manager-16.0-SP-6.8 ] installed successfully and upgraded to "ManageEngine Applications Manager (16.0)".
    # #             c. cmd output - PFA cmd terminal screenshot.

    # # 7. Product has to be started manually. 
    # $AppManService = get-service "Applications Manager*"

    # $AppManService.start()


}






function mainMenu{
    Write-Host('
    1. Run App Man Backup Process
    2. Upload .ppm file to App Man Servers
    3. Upgrade App Man Servers
    4. Check Running Status of App Man Service
    Press q to quit
    ')
}


do{
    cls
    mainMenu
    $choice = Read-Host("Please make a selection")

    switch($choice){

        1 {
            Write-host("================================")
            Write-Host("APP MAN BACKUP")
            Write-host("================================")
            
            $AMPrimary = Read-Host "Would you like to backup Primary App Man servers?(y/n)"
            $AMPrimary = $AMPrimary.ToLower()
            
            if ($AMPrimary -eq "y" -Or $AMPrimary -eq "yes"){
                Write-host("Primary Servers")
                # Invoke-Command -ComputerName (Get-Content .\PrimaryServers.txt) @parameters | Sort-Object -Property PSComputerName
            
                #save server list to array
                $servers = get-content -Path .\PrimaryServers.txt
            
                #iterate through servers to run backup
                foreach ($server in $servers){
            
                    Write-Host($server)
            
                    #create PSSession with server
                    $sesh = New-PSSession $server
            
                    Invoke-Command -Session $sesh -ScriptBlock ${function:backupAppMan}
            
                    Remove-PSSession $sesh
            
                }            
            }
            
            $AMStandby = Read-Host "Would you like to backup Standby App Man servers?(y/n)"
            $AMStandby = $AMStandby.ToLower()
            
            if ($AMStandby -eq "y" -Or $AMStandby -eq "yes"){
                Write-Host("`n")
                Write-Host("Standby Servers")
            #     Invoke-Command -ComputerName (Get-Content .\StandbyServers.txt) @parameters | Sort-Object -Property PSComputerName  
            
                    #save server list to array
                    $servers = get-content -Path .\StandbyServers.txt
            
                #iterate through servers to run backup
                foreach ($server in $servers){
            
                    Write-Host($server)
            
                    #create PSSession with server
                    $sesh = New-PSSession $server
            
                    Invoke-Command -Session $sesh -ScriptBlock ${function:backupAppMan}
            
                    Remove-PSSession $sesh
            
                }
            
            }
        }

        2{
            Add-Type -AssemblyName System.Windows.Forms

            $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
            InitialDirectory = [Environment]::GetFolderPath('Desktop') 
            Filter = 'All Files (*.ppm)| *.ppm'
            }
            $null = $FileBrowser.ShowDialog()

            $FilePath = $FileBrowser.Filename

            Write-host("================================")
            Write-Host("File Upload Status")
            Write-host("================================")

            #save server list to array
            $servers = get-content -Path .\PrimaryServers.txt

            #iterate through servers to copy file
            foreach ($server in $servers){

                #create PSSession with server
                $sesh = New-PSsession $server

                #copy file to server via PSsession
                copy-item -Path $FilePath -Destination "E:\" -ToSession $sesh

                Remove-PSSession $sesh
                
            }

            #save server list to array
            $servers = get-content -Path .\StandbyServers.txt

            #iterate through servers to copy file
            foreach ($server in $servers){

                #create PSSession with server
                $session = New-PSsession $server

                #copy file to server via PSsession
                copy-item -Path $FilePath -Destination "E:\" -ToSession $session

                Remove-PSSession $sesh
            }
        }
        
        3{

            $parameters1 = @{
                ComputerName = (Get-Content PrimaryServers.txt)
                ScriptBlock = ${function:upgradeAppMan}
            }
            
            $parameters2 = @{
                ComputerName = (Get-Content StandbyServers.txt)
                ScriptBlock = ${function:upgradeAppMan}
            }

            Write-host("================================")
            Write-Host("APP MAN UPGRADE STATUS")
            Write-host("================================")

            $AMPrimary = Read-Host "Would you like to upgrade Primary App Man servers?(y/n)"
            $AMPrimary = $AMPrimary.ToLower()

            if ($AMPrimary -eq "y" -Or $AMPrimary -eq "yes"){
                Write-host("Primary Servers")
                Invoke-Command @parameters1 | Sort-Object -Property PSComputerName
            }

            $AMStandby = Read-Host "Would you like to ugrade Standby App Man servers?(y/n)"
            $AMStandby = $AMStandby.ToLower()

            if ($AMStandby -eq "y" -Or $AMStandby -eq "yes"){
                Write-Host("`n")
                Write-Host("Standby Servers")
                Invoke-Command @parameters2 | Sort-Object -Property PSComputerName  
            }
        }

        4{
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
        }

        # 'q' {
        # }

    }
    Pause
}
until ($choice -eq 'q')
>>>>>>> main

Stop-Transcript