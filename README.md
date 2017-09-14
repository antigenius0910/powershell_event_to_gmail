# powershell_event_to_gmail
Use powershell create custom event while activate send out gmail notification

By creating a custom powershell script and attach it with a log file from event viewer we are albe to demonstrate instant gmail notification when an event was triggered in a Windows 7 machine.

First we create a custom event log name "Simple-Talk"

```powershell
New-EventLog -LogName 'Simple-Talk' -Source 'PowerShellArticle'
```

Trigger a Write-EventLog in powershell to see if it create a log file

```powershell
Write-EventLog -LogName 'Simple-Talk' -Source 'PowerShellArticle' -EventId 60000 -EntryType Information -Message 'test'
```

![screen shot 2017-09-14 at 1 36 53 pm](https://user-images.githubusercontent.com/5915590/30447486-eaf2e464-9951-11e7-869c-3fd3e5c63492.png)

(!!!If your custom message doesn't show up correctly or it shows "Event ID source can't be found....." meaning the DLL is not at its correct place. Please follow this link [The description for Event ID ( XXX ) in Source ( Symantec ) cannot be found](https://support.symantec.com/en_US/article.TECH99678.html) and copy the EventLogMessages.dll to its reference place. In my case, its locate under C:\Windows\Microsoft.NET\Framework\v4.0.30319\EventLogMessages.dll)

Second we create a html file which will be an attchment for our notification email. Through the html format we can sort all reports in future for reference in order to find the tendency and frequency for the problem.

```powershell
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
```

![screen shot 2017-09-14 at 1 52 04 pm](https://user-images.githubusercontent.com/5915590/30448269-f359d4da-9953-11e7-8477-5dbc870f7f71.png)

Third, we write the script for sending email notification through a relay gmail. The very last part is pause for debug you can comment it out when everything work as it suppose to be.

```powershell
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
```

If both scripts work correctly then we combine them together. I have it saved as the file "custom_event_gmail.ps1"

Very last part we attached this script to the custom event we just created in event viewer. You can check if it got created correctly in task scheduler.

![screen shot 2017-09-14 at 2 02 43 pm](https://user-images.githubusercontent.com/5915590/30449806-d8b9de98-9955-11e7-90c4-bc39df82f50a.png)

Finally, we do a Write-EvenLog to simulate realtime Windows events occurring situation.  

```powershell
Write-EventLog -LogName 'Simple-Talk' -Source 'PowerShellArticle' -EventId 60000 -EntryType Information -Message 'It works!!!' 
```

Ta-Da!



