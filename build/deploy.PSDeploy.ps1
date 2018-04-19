# Generic module deployment.
#
# ASSUMPTIONS:
#
# * folder structure either like:
#
#   - RepoFolder
#     - This PSDeploy file
#     - ModuleName
#       - ModuleName.psd1
#
#   OR the less preferable:
#   - RepoFolder
#     - RepoFolder.psd1
#
# * Nuget key in $ENV:NugetApiKey
#
# * Set-BuildEnvironment from BuildHelpers module has populated ENV:BHModulePath and related variables

# Publish to gallery with a few restrictions
if ($ENV:BHProjectName -and $ENV:BHProjectName.Count -eq 1) {
    Deploy Module {
        By PSGalleryModule {
            FromSource $ENV:BHProjectName
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }
}

# Publish to AppVeyor if we're in AppVeyor
if (
    $env:BHModulePath -and
    $env:BHBuildSystem -eq 'AppVeyor'
) {
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHModulePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}