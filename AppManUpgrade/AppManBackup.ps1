$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path .\BackupTest.txt -Append



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

Write-host("================================")
Write-Host("APP MAN BACKUP STATUS")
Write-host("================================")

$AMPrimary = Read-Host "Would you like to backup Primary App Man servers?(y/n)"
$AMPrimary = $AMPrimary.ToLower()

if ($AMPrimary -eq "y" -Or $AMPrimary -eq "yes"){
    Write-host("Primary Servers")
    # Invoke-Command -ComputerName (Get-Content .\PrimaryServers.txt) @parameters | Sort-Object -Property PSComputerName

    #save server list to array
    $servers = get-content -Path .\PrimaryServers.txt

    #iterate through servers to copy file
    foreach ($server in $servers){

        Write-Host($server)

        #create PSSession with server
        $sesh = New-PSSession $server

        # Invoke-Command -Session $sesh -ScriptBlock ${function:backupAppMan}

        Remove-PSSession $sesh

    }

    #remove all sessions created
    # Get-PSSession | Remove-PSSession

}

$AMStandby = Read-Host "Would you like to backup Standby App Man servers?(y/n)"
$AMStandby = $AMStandby.ToLower()

if ($AMStandby -eq "y" -Or $AMStandby -eq "yes"){
    Write-Host("`n")
    Write-Host("Standby Servers")
#     Invoke-Command -ComputerName (Get-Content .\StandbyServers.txt) @parameters | Sort-Object -Property PSComputerName  

        #save server list to array
        $servers = get-content -Path .\StandbyServers.txt

        #iterate through servers to copy file
        foreach ($server in $servers){
    
            #create PSSession with server
            Enter-PSSession $server
    
            #run backup script
            # backupAppMan
            
        }

    #remove all sessions created
    Get-PSSession | Remove-PSSession

}

Stop-Transcript
Pause