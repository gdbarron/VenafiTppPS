# VenafiTppPS - PowerShell module for Venafi Trust Protection Platform and CodeSign Protect

[![Build status](https://gd-barron.visualstudio.com/VenafiTppPS/_apis/build/status/VenafiTppPS)](https://dev.azure.com/gd-barron/VenafiTppPS/_build/latest?definitionId=1)
[![Documentation Status](https://readthedocs.org/projects/venafitppps/badge/?version=latest)](https://venafitppps.readthedocs.io/en/latest/?badge=latest)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/VenafiTppPS?style=plastic)](https://www.powershellgallery.com/packages/VenafiTppPS)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/VenafiTppPS?style=plastic)

## Documentation

Documentation can be found at [http://venafitppps.readthedocs.io](http://venafitppps.readthedocs.io) or by using built-in PowerShell help.  Every effort has been made to document each parameter and provide good examples.

## Supported Platforms

| OS             | PowerShell Version Tested | Status  |
| -------------- |--------------------| -----|
| Windows        | 5.1                | **Working!** |
| Windows        | Core 6.2.3+         | **Working!** |
| MacOS          | Core 6.2.3+         | **Working!** |
| Linux (Ubuntu 18.04) | Core 6.2.3+         | **Working!** |

## Install Module

VenafiTppPS is published to the PowerShell Gallery.  The most recent version is listed in the badge 'powershell gallery' above and can be viewed by clicking on it.  To install the module, you need to have PowerShell installed first.  On Windows, PowerShell will already be installed.  For [Linux](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7) or [macOS](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7), you will need to install PowerShell Core; follow those links for guidance.  Once PowerShell is installed, start a PowerShell prompt and execute `Install-Module -Name VenafiTppPS` which will install from the gallery.

## Usage

Start a new PowerShell prompt (even if you have one from the Install Module step) and create a new VenafiTppPS session with

```powershell
$cred = Get-Credential
New-TppSession -Server 'venafi.mycompany.com' -Credential $cred
```

This will create a session which will be used by default in other functions.
You can also use integrated authentication, simply exclude `-Credential $cred`.  As of v2.0, token-based authentication has been added as well.
View the help on all the ways you can create a new TPP session with `help New-TppSession -full`.

One of the easiest ways to get started is to use `Find-TppObject`:

```powershell
$allPolicy = Find-TppObject -Path '\ved\policy' -Recursive
```

This will return all objects in the Policy folder.  You can also search from the root folder, \ved.

To find a certificate object, not retrieve an actual certificate, use:
```powershell
$cert = Find-TppCertificate -Limit 1
```

Check out the parameters for `Find-TppCertificate` as there's an extensive list to search on.

Now you can take that certificate 'TppObject' and find all log entries associated with it:

```powershell
$cert | Read-TppLog
```

You can also have multiple sessions at once, either to the same server with different credentials or different servers.
This can be helpful to determine the difference between what different users can access or perhaps compare folder structures across environments.  The below will compare the objects one user can see vs. another.

```powershell
# assume you've created 1 session already as shown above...

$user2Cred = Get-Credential # specify credentials for a different/limited user

# get a session as user2 and save the session in a variable
$user2Session = New-TppSession -ServerUrl 'https://venafi.mycompany.com' -Credential $user2Cred -PassThru

# get all objects in the Policy folder for the first user
$all = Find-TppObject -Path '\ved\policy' -Recursive

# get all objects in the Policy folder for user2
$all2 = Find-TppObject -Path '\ved\policy' -Recursive -TppSession $user2Session

Compare-Object -ReferenceObject $all -DifferenceObject $all2 -Property Path
```

## Contributing

Please feel free to log an issue for any new features you would like, bugs you come across, or just simply a question.  I am happy to have people contribute to the codebase as well.
