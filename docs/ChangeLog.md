# Version 0.3.8 (2018-05-30)
- bugfixes



# Version 0.3.7 (2018-05-30)
- add support for new policy folder creation
- rename functions



# Version 0.3.6 (2018-05-29)
- add certificate revocation



# Version 0.3.5 (2018-05-23)
- minor updates to cert renewal
- basic certificate creation functionality added



# Version 0.3.4 (2018-05-21)
- get workflow details updates
- first cut at setting workflow status
- add ExistOnly option to Test-TppObject to only return boolean, useful when only testing 1 path and not piping in a list
- Add better and standarized regex validation for DN paths
- Code cleanup and updated help



# Version 0.3.3 (2018-05-18)
- With Set-TppAttribute set to Overwrite by default, update New-TppCapiApplication to ensure our Consumers attribute update does not overwrite

# Version 0.3.2 (2018-05-17)
- initial cut at gathering workflow ticket details
- resolve issue with New-TppSession not loading private functions
- Update Set-TppAttribute to make overwrite the default behavior

# Version 0.3.1 (2018-05-17)
- Get-TppObjectConfig renamed to Get-TppAttribute
- Add support for custom fields. Custom fields are retrieved upon server connect and stored in TppSession.
Get-TppAttribute and Set-TppAttribute both support auto detection of a custom field. The custom field Label will be used in place of the Guid.
- Modify Get-TppObject to search recursively by default

# Version 0.2.8 (2018-05-09)
- finalize Set-TppAttribute, supports adding and overwriting values
- Default DN to VED root in Get-TppObject, one less param to provide if doing a basic search
- Fix New-TppCapiApplication to update Consumers attrib on the certificate
- Help updates
