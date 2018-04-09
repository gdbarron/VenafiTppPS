# VenafiTppPS
PowerShell module to access the features of Venafi Trust Protection Platform REST API

After loading the module, create a new session with
```
New-TppSession -ServerUrl "https://venafi.mycompany.com" -Credential <cred>
```
before calling any functions.  Get-TppCertificateDetails is the only function currently available, but this will change in the near future.  Please let me know if there are any specific items you would like added.
