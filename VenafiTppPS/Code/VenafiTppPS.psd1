#
# Module manifest for module 'VenafiTppPS'
#
# Generated by: Greg Brownstein
#
# Generated on: 10/4/2019
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'VenafiTppPS.psm1'

# Version number of this module.
ModuleVersion = '1.2.2'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'c753bf91-13c0-4ae0-9e43-dbf40b22c3be'

# Author of this module
Author = 'Greg Brownstein'

# Company or vendor of this module
CompanyName = 'Greg Brownstein'

# Copyright statement for this module
Copyright = '(c) 2018-2019 Greg Brownstein. All rights reserved.'

# Description of the functionality provided by this module
Description = 'PowerShell module to access the features of Venafi Trust Protection Platform REST API'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Add-TppCertificateAssociation', 'ConvertTo-TppGuid',
               'ConvertTo-TppPath', 'Find-TppCertificate', 'Find-TppIdentity',
               'Find-TppObject', 'Get-TppAttribute', 'Get-TppCertificate',
               'Get-TppCertificateDetail', 'Get-TppCustomField',
               'Get-TppIdentityAttribute', 'Get-TppObject', 'Get-TppPermission',
               'Get-TppSystemStatus', 'Get-TppVersion', 'Get-TppWorkflowTicket',
               'Invoke-TppCertificateRenewal', 'Move-TppObject',
               'New-TppCapiApplication', 'New-TppCertificate', 'New-TppDevice',
               'New-TppObject', 'New-TppPolicy', 'New-TppSession', 'Read-TppLog',
               'Remove-TppCertificate', 'Remove-TppCertificateAssociation',
               'Rename-TppObject', 'Revoke-TppCertificate', 'Set-TppAttribute',
               'Set-TppPermission', 'Set-TppWorkflowTicketStatus',
               'Test-TppIdentity', 'Test-TppObject', 'Write-TppLog', 'Import-TppCertificate'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = 'TppSession', 'TppSupportedVersion'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'fto', 'itcr'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Venafi','TPP','TrustProtectionPlatform','API'

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/gdbarron/VenafiTppPS/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/gdbarron/VenafiTppPS'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '- Add Linux support
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
'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'http://venafitppps.readthedocs.io/'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

