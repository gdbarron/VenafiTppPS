@{
    # Some defaults for all dependencies
    PSDependOptions = @{
        Target    = '$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules'
        AddToPath = $True
    }

    # Grab some modules without depending on PowerShellGet
    'psake'         = @{
        DependencyType = 'PSGalleryNuget'
    }
    'PlatyPS'         = @{
        DependencyType = 'PSGalleryNuget'
    }
    'PSDeploy'      = @{
        DependencyType = 'PSGalleryNuget'
        Version        = '0.2.4'
    }
    'BuildHelpers'  = @{
        DependencyType = 'PSGalleryNuget'
        Version        = '1.1.1'
    }
    'Pester'        = @{
        DependencyType = 'PSGalleryNuget'
        Version        = '4.1.0'
    }
}