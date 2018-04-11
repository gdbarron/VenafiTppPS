# VenafiTppPS - PowerShell module for Venafi Trust Protection Platform

[![Build status](https://ci.appveyor.com/api/projects/status/vxyan36tsimle56b/branch/master?svg=true&passingText=master%20-%20passing)](https://ci.appveyor.com/project/GregBrownstein/venafitppps)
[![Build status](https://ci.appveyor.com/api/projects/status/vxyan36tsimle56b/branch/develop?svg=true&passingText=develop%20-%20passing)](https://ci.appveyor.com/project/GregBrownstein/venafitppps)

After loading the module, create a new session with
```
New-TppSession -ServerUrl "https://venafi.mycompany.com" -Credential <cred>
```
before calling any functions which can be found below.  Please let me know if there are any specific items you would like added.

## VenafiTppPS Cmdlets
### [Get-TppCertificateDetail]
Get details about a certificate based on search criteria.  See the examples for a few of the available options.
The SDK provides a full list.  Additional details can be had by passing the guid.

### [Get-TppConfig]
Retrieves object’s attributes.  You can either retrieve all attributes or individual ones.  By default, the attributes returned are not the effective policy, but that can be requested with the EffectivePolicy switch.

### [Invoke-TppCertificateRenew]
Requests renewal for an existing certificate. This call marks a certificate for	immediate renewal. The certificate must not be in error, already being processed, or configured for Monitoring in order for it be renewable. Caller must have Write access to the certificate object being renewed.

### [Invoke-TppRestMethod]
For one off calls to TPP for which no functions have been created yet :)

### [New-TppSession]
Authenticates a user against a configured Trust	Protection Platform identity provider (e.g. Active Directory, LDAP, or Local). After the user is authenticated, Trust Protection Platform returns an API key allowing access to all other REST calls.

### [Test-TppObjectExists]
Validate either a DN or GUID exists.
