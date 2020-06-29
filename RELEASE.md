## v2.0.2
- fix #108.  Process to convert a secure password to plain text was failing on Linux.

## v2.0.1
- add Import-TppCertificate, #88
- make Invoke-TppRestMethod accessible, #106
- fix verbose being turned on incorrectly in New-TppSession when getting by token

## v2.0.0
- Add token-based authentication support, Integrated, OAuth, and Certificate. Tokens can be used in or out of this module. #94
- Add CertificateType option to New-TppCertificate
- Add support for GET api calls which require a trailing slash
- Fixes in multiple functions where .Add on a hashtable was called in the process block
- Fix issue #102, Base64 with private key not an available option
- Update formats which support IncludeChain