#Gulfstream Aerospace
#Author Jon Bartee
#Date - 10/24/2023
#
#This script is designed to run the createSupportFile.bat script and restart the Applications Manager service
#It is run through an action within the Applications Manager UI which is added to the monitors for tomcat going down
#
#An email is sent on success or failure of script execution
#

#Variable Declarations

$supportScriptPath = 'E:\Program Files\ManageEngine\AppManager15\bin\'

$emailSmtpServer = "smtp.gac.gulfaero.com"
$emailSmtpServerPort = "25"

#$emailFrom = "bt.tools@gulfstream.com"
#$emailTo = "bt.tools@gulfstream.com"

$emailFrom = "jonathan.bartee@gulfstream.com"
$emailTo = "jonathan.bartee@gulfstream.com"

#$emailcc = "General - Tools & Monitoring <11732b56.gulfstream.com@amer.teams.ms>"

$hostname = hostname

#functions for sending email
function emailSuccess{
    
    $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
    #$emailMessage.cc.add($emailcc)
    $emailMessage.Subject = "AppManRestart Script Result" 
    $emailMessage.Body = "AppManRestart.ps1 executed successfully on {0}. Support bundle created and located under E:\Program Files\ManageEngine\AppManager15\working\support" -f $hostname
    
    $SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
    $SMTPClient.EnableSsl = $false
    $SMTPClient.Send( $emailMessage )
}


function emailError{
    
    $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
    #$emailMessage.cc.add($emailcc)
    $emailMessage.Subject = "AppManRestart Script Result" 
    $emailMessage.Body = 'Error AppManRestart.ps1 did not complete successfully on {0}. Error Message: {1}' -f $hostname, $Error
    
    $SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
    $SMTPClient.EnableSsl = $false
    $SMTPClient.Send( $emailMessage )
}


try {

    #Clear error messages so only errors from this script will be output in email
    $error.clear() 

    #Restart Applications Manager Service
    # restart-service -name "Applications Manager Managed1"
    $AppManService = get-service "Applications Manager*"
    $AppManService.stop()
    $AppManService.WaitForStatus("Stopped", '00:05:00')
    $AppManService.start()
    $AppManService.WaitForStatus("Running", '00:05:00')

    #run support bundle script
    Set-Location $supportScriptPath
    .\createSupportFile.bat

    #Send email
    emailSuccess
}
catch {
    emailError
}

##OLD - FOR ZIPPING LOGS THE OLD WAY
    # #create timestamp for zip file name
    # $filedate = get-date -format "MMddyyyy"

    # #create filepath and zip file name for logs 
    # $zipfile = 'E:\Gulfstream\supportlogs\log' + $filedate + '.zip'

    # #set alias to call 7zip and zip folder
    # set-alias 7z "$env:ProgramFiles\7-zip\7z.exe"

    # #copy logs folder to zip because it is in use
    # copy-item -Path "E:\Program Files\ManageEngine\AppManager15\logs" -Destination "E:\Gulfstream\supportlogs" -Recurse

    # ##OLD - does not work because compress-archive has 2GB limit
    # ##compress copied folder
    # ##compress-archive -Path "E:\Program Files\ManageEngine\AppManager15\logs" -DestinationPath $zipfile

    # #zip folder and remove copied files after finished
    # #-tzip sets type as .zip
    # #-sdel deletes folder after zipping
    # 7z a -tzip -sdel $zipfile 'E:\Gulfstream\supportlogs\logs'