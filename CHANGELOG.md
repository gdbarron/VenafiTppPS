## v2.0.5
- Add missing filters CreateDate, CreatedBefore, and CreatedAfter to Find-TppCertificate, [#117](https://github.com/gdbarron/VenafiTppPS/issues/117).  Thanks @doyle043!

## v2.0.4
- Fix header getting stripped causing Write-TppLog to fail, #114
- Update Invoke-TppRestMethod to retry with trailing slash for all methods, not just Get

## v2.0.3
- Add Origin property when creating a new certificate
- Add icon to project, #37

## v2.0.2
- Process to convert a secure password to plain text was failing on Linux, #108

## v2.0.1
- Add Import-TppCertificate, #88
- Make Invoke-TppRestMethod accessible, #106
- Fix verbose being turned on incorrectly in New-TppSession when getting by token

## v2.0.0
- Add token-based authentication support, Integrated, OAuth, and Certificate. Tokens can be used in or out of this module. #94
- Add CertificateType option to New-TppCertificate
- Add support for GET api calls which require a trailing slash
- Fixes in multiple functions where .Add on a hashtable was called in the process block
- Fix issue #102, Base64 with private key not an available option
- Update formats which support IncludeChain