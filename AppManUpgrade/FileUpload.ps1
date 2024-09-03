Add-Type -AssemblyName System.Windows.Forms

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = [Environment]::GetFolderPath('Desktop') 
    Filter = 'All Files (*.ppm)| *.ppm'
}
$null = $FileBrowser.ShowDialog()

$FilePath = $FileBrowser.Filename

$AMPrimary = Read-Host "Would you like to upload file Primary App Man servers?(y/n)"
$AMPrimary = $AMPrimary.ToLower()

if ($AMPrimary -eq "y" -Or $AMPrimary -eq "yes"){

    #save server list to array
    $servers = get-content -Path .\PrimaryServers.txt

    #iterate through servers to copy file
    foreach ($server in $servers){

        #create PSSession with server
        $session = New-PSsession $server

        #copy file to server via PSsession
        copy-item -Path $FilePath -Destination "E:\" -ToSession $session
        
    }

    #remove all sessions created
    Get-PSSession | Remove-PSSession
}

$AMStandby = Read-Host "Would you like to upload file to Standby App Man servers?(y/n)"
$AMStandby = $AMStandby.ToLower()

if ($AMStandby -eq "y" -Or $AMStandby -eq "yes"){

    #save server list to array
    $servers = get-content -Path .\StandbyServers.txt

    #iterate through servers to copy file
    foreach ($server in $servers){

        #create PSSession with server
        $session = New-PSsession $server

        #copy file to server via PSsession
        copy-item -Path $FilePath -Destination "E:\" -ToSession $session
    }

    #remove all sessions created
    Get-PSSession | Remove-PSSession
}

Pause