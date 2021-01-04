## v2.1.0
- Update Get-TppCertificateDetail help to ensure output lists the correct properties, [#119](https://github.com/gdbarron/VenafiTppPS/issues/119).  Thanks @doyle043!
- Hide secret info, eg. passwords, tokens, etc, when verbose logging.  [#120](https://github.com/gdbarron/VenafiTppPS/issues/120).  Thanks @bwright86!
- Add search, get, and remove code sign project and environment functions
- Fix, provide the correct error message when making rest call and testing to see if a trailing slash is needed or not
- Update New-TppSession to ensure $TppSession is created even if subsequent custom field calls fail
- Update TppSession object Validate method to check if token auth is required.  Needed for code sign.

## v2.0.5
- Add missing filters CreateDate, CreatedBefore, and CreatedAfter to Find-TppCertificate, [#117](https://github.com/gdbarron/VenafiTppPS/issues/117).  Thanks @doyle043!

## v2.0.4
- Fix header getting stripped causing Write-TppLog to fail, [#114](https://github.com/gdbarron/VenafiTppPS/issues/114).  Thanks @stevekeever!
- Update Invoke-TppRestMethod to retry with trailing slash for all methods, not just Get

## v2.0.3
- Add Origin property when creating a new certificate
- Add icon to project, [#37](https://github.com/gdbarron/VenafiTppPS/issues/37)

## v2.0.2
- Process to convert a secure password to plain text was failing on Linux, [#108](https://github.com/gdbarron/VenafiTppPS/issues/108).  Thanks @macflurry7!

## v2.0.1
- Add Import-TppCertificate, [#88](https://github.com/gdbarron/VenafiTppPS/issues/88).  Thanks @smokey7722!
- Make Invoke-TppRestMethod accessible, [#106](https://github.com/gdbarron/VenafiTppPS/issues/106).  Thanks @wilddev65!
- Fix verbose being turned on incorrectly in New-TppSession when getting by token

## v2.0.0
- Add token-based authentication support, Integrated, OAuth, and Certificate. Tokens can be used in or out of this module. [#94](https://github.com/gdbarron/VenafiTppPS/issues/94).  Thanks @BeardedPrincess!
- Add CertificateType option to New-TppCertificate
- Add support for GET api calls which require a trailing slash
- Fixes in multiple functions where .Add on a hashtable was called in the process block
- Fix issue #102, Base64 with private key not an available option
- Update formats which support IncludeChain

## v1.2.5
- Add offset parameter to Find-TppCertificate, [#92](https://github.com/gdbarron/VenafiTppPS/issues/92)
- Allow inclusion of private key for format Base64 (PKCS #8) in Get-TppCertificate.  Earlier versions of Venafi documentation listed this incorrectly, but has been resolved.  [#95](https://github.com/gdbarron/VenafiTppPS/issues/95)
- Get-TppCertificate failing when pipilining due to adding a key to a hashtable that already exists, [#96](https://github.com/gdbarron/VenafiTppPS/issues/96)
- Linux style paths which use / instead of \ were failing path check due to invalid regex, [#97](https://github.com/gdbarron/VenafiTppPS/issues/97)
- PSSA fix for Read-TppLog

## v1.2.3
- ProvisionCertificate not triggering a push, [#89](https://github.com/gdbarron/VenafiTppPS/issues/89)

## v1.2.2
- Add Linux support
- Add New-TppDevice
- New-TppCapiApplication
    - Add ProvisionCertificate parameter to provision a certificate when the application is created
    - Removed UpdateIis switch as unnecessary, simply use WebSiteName
    - Add ApplicationName parameter to support pipelining of path
    - Add SkipExistenceCheck parameter to bypass some validation which some users might not have access to
- New-TppCertificate
    - Certificate authority is no longer required
    - Fix failure when SAN parameter not provided
    - Fix Management Type not applying
- Add ability to provide root level path, \ved, in some `Find-` functions
- Add pipelining and ShouldProcess functionality to multiple functions
- Update New-TppObject to make Attribute not mandatory
- Remove ability to write to the log with built-in event groups.  This is no longer supported by Venafi.  Custom event groups are still supported.
- Add aliases for Find-TppObject (fto), Find-TppCertificate (ftc), and Invoke-TppCertificateRenewal (itcr)
- Simplified class and enum loading

## v1.1
- fix session state not being preserved across internal function calls, thanks Kory B!
- add Pipeline and ShouldProcess support to New-TppPolicy
- add ShouldProcess support to New-TppObject

## v1.0.5
- add many search options to Read-TppLog
- ensure the Recursive parameter of Find-TppCertificate can only be applied when providing a path
- ensure InputObject property of Find-TppCertificate only accepts type Policy so we get a path
- add TppManagementType enum
- add private function to convert a date to UTC ISO 8601 format
- cleanup help in Find-TppCertificate

## v1.0.4
- add Subject Alternate Name parameter to New-TppCertificate

## v1.0.3
- add Add-TppCertificateAssociation to associate a certificate to one or more application objects
- update New-TppObject to use Add-TppCertificateAssociation when a certificate is provided
- update New-TppCapiApplication to use the updated New-TppObject
- update Get-TppIdentityAttribute to use Test-TppIdentity for validation

## v1.0.2
- additional fixes in identity functions

## v1.0.1
- fix validation in identity functions

## v1.0
- Add Integrated Authentication, a credential is no longer required
- Add Write-TppLog with support for default and custom event groups
- Add PassThru option for all 'New-' functions, returning TppObject
- Standardize all enums with Tpp prefix
- Make enums/classes available outside of the module scope, access these directly at the command line.  For example, [TppObject]::new('\ved\policy\object').
- Fix finding by Stage, StageGreaterThan, and StageLessThan in Find-TppCertificate
- Add error handling for Get-TppSystemStatus
- Add Get-TppVersion
- Rename Restore-TppCertificate to Invoke-TppCertificateRenewal
- Lots of help/documentation updates
- Breaking change: Update New-TppObject to simplify the attributes provided, now just pass a hashtable of object key/value pairs.
- Better parameter support for New-TppCertificate with Name and CommonName
- Rename Get-TppLog to Read-TppLog
