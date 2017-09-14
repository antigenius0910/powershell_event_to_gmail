### create CSS style
$css= "<style>"
$css= $css+ "BODY{ text-align: center; background-color:white;}"
$css= $css+ "TABLE{    font-family: 'Lucida Sans Unicode', 'Lucida Grande', Sans-Serif;font-size: 12px;margin: 10px;width: 100%;text-align: center;border-collapse: collapse;border-top: 7px solid #004466;border-bottom: 7px solid #004466;}"
$css= $css+ "TH{font-size: 13px;font-weight: normal;padding: 1px;background: #cceeff;border-right: 1px solid #004466;border-left: 1px solid #004466;color: #004466;}"
$css= $css+ "TD{padding: 1px;background: #e5f7ff;border-right: 1px solid #004466;border-left: 1px solid #004466;color: #669;hover:black;}"
$css= $css+  "TD:hover{ background-color:#004466;}"
$css= $css+ "</style>" 
 
$StartDate = (get-date).adddays(-1) 
$body = Get-WinEvent -FilterHashtable @{logname="Simple-Talk"; starttime=$StartDate} -ErrorAction SilentlyContinue
$body | ConvertTo-HTML -Head $css MachineName,ID,TimeCreated,Message > C:\LogAppView1.html 
write-host "Create CSS file at C:\LogAppView1.html"
####

$event = Get-WinEvent -FilterHashTable @{logname='Simple-Talk' ;ID='60000'} -MaxEvents 1 
if ($event.LevelDisplayName -eq "Information") 
{
	$SMTPServer = "smtp.gmail.com"
	$SMTPPort = "587" 
	$Username = "$YOUR_RELAY_EMAIL"
	$Password = "$RELAY_EMAIL_PASSWORD"
	
        $to = "$TARGET_EMAIL"                                                                                                                         
	$cc = "$CC_EMAIL"
	$subject = "Custom event was found!"                                                                                                                                 
	$body = $event
	$body = $event.Message
	$attachment = "C:\LogAppView1.html"            
  
	$message = New-Object System.Net.Mail.MailMessage                                                                                                                     
	$message.subject = $subject
	$message.body = $body                                                                                                                                      
	$message.to.add($to)
	$message.cc.add($cc)                                                                                                                                       
	$message.from = $username
	$message.attachments.add($attachment)   

	$smtp = New-Object System.Net.Mail.SmtpClient($SMTPServer, $SMTPPort);                                                                                     
	$smtp.EnableSSL = $true
	$smtp.Credentials = New-Object System.Net.NetworkCredential($Username, $Password);                                                                         
	$smtp.send($message)
	write-host "Mail Sent" 
}
else
{
    Write-host "No event found. Here is the log entry that was inspected:"
    $event
}


# For debug, take it out when no need                                                                                                     
 if ($Host.Name -eq "ConsoleHost")                                                                                                                               
{                                                                                
     Write-Host "Press any key to continue..."                                                                                                                   
         $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null                                                                                                       
         }                        
