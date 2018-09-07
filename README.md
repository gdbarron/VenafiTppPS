# VenafiTppPS - PowerShell module for Venafi Trust Protection Platform

[![Build status](https://gd-barron.visualstudio.com/VenafiTppPS/_apis/build/status/VenafiTppPS)](https://gd-barron.visualstudio.com/VenafiTppPS/_build/latest?definitionId=1)
[![Documentation Status](https://readthedocs.org/projects/venafitppps/badge/?version=latest)](https://venafitppps.readthedocs.io/en/latest/?badge=latest)

## Documentation
Documentation can be found at [http://venafitppps.readthedocs.io](http://venafitppps.readthedocs.io)

## Usage
After loading the module, create a new session with
```
New-TppSession -ServerUrl "https://venafi.mycompany.com" -Credential <cred>
```
before calling any functions.  This will create a session which will be used by default in other functions.

## Contributing
Please feel free to log an issue for any new features you would like or bugs you come across.  I am happy to have people contribute to the codebase as well.
