using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class Device : SHiPSDirectory {
    static $Name = "Device"

    [string]$Name
    [string]$TypeName
    [string]$Path
    [guid]$Guid
    [string] $Host
    [string] $CredentialPath

    Device([string]$name, [string]$typeName, [string]$path, [guid]$guid) : base ($name) {
        $this.Name = $name
        $this.TypeName = $typeName
        $this.Path = $path
        $this.Guid = $guid
    }

    [object[]] GetChildItem() {
        $allObjects = Find-TppObject -Class $this.Name
        $obj = @()
        foreach ($thisObject in $allObjects) {

            $obj += [TppApplication]::new($thisObject.Name, $thisObject.TypeName, $thisObject.Path, $thisObject.Guid);
        }
        return $obj;
    }
}

using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamPools : VSTeamDirectory {

    # Default constructor
    VSTeamPools(
        [string]$Name
    ) : base($Name, $null) {
        $this.AddTypeName('Team.Pools')

        $this.DisplayMode = 'd-r-s-'
    }

    [object[]] GetChildItem() {
        $pools = Get-VSTeamPool -ErrorAction SilentlyContinue | Sort-Object name

        $objs = @()

        foreach ($pool in $pools) {
            $pool.AddTypeName('Team.Provider.Pool')

            $objs += $pool
        }

        return $objs
    }
}