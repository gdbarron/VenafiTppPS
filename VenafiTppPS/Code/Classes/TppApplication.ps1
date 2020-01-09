using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider()]
class Device : SHiPSLeaf {
    static $Name = "Application"

    [string]$Name;
    [string]$TypeName;
    [string]$Path;
    [guid]$Guid

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
