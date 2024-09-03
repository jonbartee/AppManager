Param(
    [parameter(mandatory=$true)]$file
)

$FilePath = ".\seed.file"
$destination = "E:\Program Files\ManageEngine\AppManager15\working\conf"

$parameters = @{
    ComputerName = (get-content $file)
    ScriptBlock = {ls "E:\Program Files\ManageEngine\AppManager15\working\conf" "seed*"}
}

Write-host("================================")
Write-Host("FILE UPLOAD STATUS")
Write-host("================================")

    #save server list to array
    $servers = get-content -Path $file

    #iterate through servers to copy file
    foreach ($server in $servers){

        #create PSSession with server
        $session = New-PSsession $server

        #copy file to server via PSsession
        copy-item -Path $FilePath -Destination $destination -ToSession $session
    }

    #remove all sessions created
    Get-PSSession | Remove-PSSession

Invoke-Command @parameters | Sort-Object -Property PSComputerName

Pause