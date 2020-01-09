using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
class Root : SHiPSDirectory {

    static [pscustomobject] $tppSession

    Root() : base($this.GetType()) {
    }

    # Optional method
    # Must define this c'tor if it can be used as a drive root, e.g.
    # new-psdrive -name abc -psprovider SHiPS -root module#type
    # Also it is good practice to define this c'tor so that you can create a drive and test it in isolation fashion.
    Root([string]$name): base($name) {
    }

    # Mandatory it gets called by SHiPS while a user does 'dir'
    [object[]] GetChildItem() {
        if (-not [Root]::tppSession ) {
            new-tppsession -ServerUrl 'https://venafiqa.deloitteresources.com'
            # [TPP]::session = new-tppsession -ServerUrl 'https://venafiqa.deloitteresources.com' -PassThru -Verbose
            # Write-Verbose ([TPP]::tppSession | Out-String)
        }

        $allObjects = Find-TppObject -Path '\ved' -Recursive
        $obj = @()
        foreach ($thisObject in ($allObjects | group-object TypeName)) {
            $obj += [TppClass]::new($thisObject.Name);
        }
        return $obj;

        # $obj = @()

        # Write-Output ('xxx' + ([TPP]::Session | out-string))

        # $obj += [ByTypeRoot]::new();
        # $obj += [Bill]::new();

        # return $obj;
    }
}


using namespace Microsoft.PowerShell.SHiPS

[SHiPSProvider(UseCache = $true)]
[SHiPSProvider(BuiltinProgress = $false)]
class VSTeamAccount : SHiPSDirectory {

    # Default constructor
    VSTeamAccount(
        [string]$Name
    ) : base($Name) {
        $this.AddTypeName('Team.Account')

        # Invalidate any cache of projects.
        [VSTeamProjectCache]::timestamp = -1
    }

    [object[]] GetChildItem() {
        $topLevelFolders = @(
            [VSTeamPools]::new('Agent Pools'),
            [VSTeamExtensions]::new('Extensions')
        )

        # Don't show directories not supported by the server
        if (_testFeedSupport) {
            $topLevelFolders += [VSTeamFeeds]::new('Feeds')
        }

        if (_testGraphSupport) {
            $topLevelFolders += [VSTeamPermissions]::new('Permissions')
        }

        $items = Get-VSTeamProject | Sort-Object Name

        foreach ($item in $items) {
            $item.AddTypeName('Team.Provider.Project')
            $topLevelFolders += $item
        }

        return $topLevelFolders
    }

    [void] hidden AddTypeName(
        [string] $name
    ) {
        # The type is used to identify the correct formatter to use.
        # The format for when it is returned by the function and
        # returned by the provider are different. Adding a type name
        # identifies how to format the type.
        # When returned by calling the function and not the provider.
        # This will be formatted without a mode column.
        # When returned by calling the provider.
        # This will be formatted with a mode column like a file or
        # directory.
        $this.PSObject.TypeNames.Insert(0, $name)
    }
}