# Get-TppCustomField

## SYNOPSIS
Get custom field details

## SYNTAX

```
Get-TppCustomField [-Class] <String> [[-TppSession] <TppSession>] [<CommonParameters>]
```

## DESCRIPTION
Get details about custom fields for either certificates or devices

## EXAMPLES

### EXAMPLE 1
```
Get-TppCustomField -Class 'X509 Certificate'
```

Get custom fields for certificates

## PARAMETERS

### -Class
Class to get details on. 
Value can be either Device or X509 Certificate

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TppSession
Session object created from New-TppSession method. 
The value defaults to the script session object $TppSession.

```yaml
Type: TppSession
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Script:TppSession
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### Query returns a PSCustomObject with the following properties:
###     Items
###         AllowedValues
###         Classes
###         ConfigAttribute
###         DN
###         DefaultValues
###         Guid
###         Label
###         Mandatory
###         Name
###         Policyable
###         RenderHidden
###         RenderReadOnly
###         Single
###         Type
###     Locked
###     Result
## NOTES
All custom fields are retrieved upon inital connect to the server and a property of TppSession

## RELATED LINKS

[http://venafitppps.readthedocs.io/en/latest/functions/Get-TppCustomField/](http://venafitppps.readthedocs.io/en/latest/functions/Get-TppCustomField/)

[https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Metadata-GetItemsForClass.php?tocpath=REST%20API%20reference%7CMetadata%20programming%20interfaces%7C_____11](https://docs.venafi.com/Docs/18.1SDK/TopNav/Content/SDK/WebSDK/API_Reference/r-SDK-POST-Metadata-GetItemsForClass.php?tocpath=REST%20API%20reference%7CMetadata%20programming%20interfaces%7C_____11)

