###
#Author - Jon Bartee
#
#script to send emails out
#
###


$emailSmtpServer = "smtp.gac.gulfaero.com"
$emailSmtpServerPort = "25"
#$emailSmtpUser = $credential.UserName
#$emailSmtpPass = $credential.Password
 
$emailFrom = "bt.tools@gulfstream.com"
$emailTo = "bt.tools@gulfstream.com"
$emailcc="General - Tools & Monitoring <11732b56.gulfstream.com@amer.teams.ms>"
 
$emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
$emailMessage.cc.add($emailcc)
$emailMessage.Subject = "test 2 subject" 
$emailMessage.Body = "test 2 body"
 
$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
$SMTPClient.EnableSsl = $false
#$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
$SMTPClient.Send( $emailMessage )

# template used

# $emailSmtpServer = "mail"
# $emailSmtpServerPort = "587"
# $emailSmtpUser = "user"
# $emailSmtpPass = "P@ssw0rd"
 
# $emailFrom = "from"
# $emailTo = "to"
# $emailcc="CC"
 
# $emailMessage = New-Object System.Net.Mail.MailMessage( $emailFrom , $emailTo )
# $emailMessage.cc.add($emailcc)
# $emailMessage.Subject = "subject" 
# #$emailMessage.IsBodyHtml = $true #true or false depends
# $emailMessage.Body = "body"
 
# $SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort )
# $SMTPClient.EnableSsl = $False
# $SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );
# $SMTPClient.Send( $emailMessage )