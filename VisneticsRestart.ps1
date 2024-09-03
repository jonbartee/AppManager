
#check if URL source code is valid or not
# $logonPage = Invoke-WebRequest -Uri 'http://erpvispw002/login.ems'
# $result = $logonPage -match '<body>\s*</body>'

$visService = get-service -name "Visnetic MailFlow Engine"

#restart visnetics service
$visService.stop()
$visService.WaitForStatus("Stopped", '00:10:00')

#wait some time between executing commands to prevent issues
sleep -s 30

if(get-process -name "MailflowEngine*" -eq true){
    taskkill /IM 'MailflowEngine*' /F
}

if ($visService.status -eq "Stopped"){
    $visService.start()
    $visService.WaitForStatus("Running", '00:10:00')
}

#wait some time between executing commands to prevent issues
sleep -s 30

if ($visService.status -eq "Running"){
    #recycle visnetics app pool
    C:\Windows\System32\inetsrv\appcmd.exe recycle apppool "VisNetic MailFlow"
}