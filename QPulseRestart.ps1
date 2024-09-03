$logonPage = Invoke-WebRequest -Uri 'qplappqw004.qagac.gulfaero.com/anon'
$result = $logonpage.content -like "*Anonymous Hazard Report*"

if ($result = True){
    $qp = get-service -name "QPulse Server"
    $iis = get-service -name "W3SVC"

    #restart q-pulse service
    $qp.restart()
    $qp.WaitForStatus("Running", '00:02:00')

    #wait some time between executing commands to ensure q-pulse service starts
    sleep -s 60

    iisreset

    $iis.WaitForStatus("Running", '00:05:00')
}