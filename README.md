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

