# powershell_event_to_gmail
Use powershell create custom event while activate send out gmail notification

By creating a custom powershell script and attach it with a log file from event viewer we are albe to demonstrate instant gmail notification when an event was triggered in a Windows 7 machine.

First we create a custom event log

```powershell
New-EventLog -LogName 'Simple-Talk' -Source 'PowerShellArticle'
```
