class TppPermission {

    [bool] $IsAssociateAllowed
    [bool] $IsCreateAllowed
    [bool] $IsDeleteAllowed
    [bool] $IsManagePermissionsAllowed
    [bool] $IsPolicyWriteAllowed
    [bool] $IsPrivateKeyReadAllowed
    [bool] $IsPrivateKeyWriteAllowed
    [bool] $IsReadAllowed
    [bool] $IsRenameAllowed
    [bool] $IsRevokeAllowed
    [bool] $IsViewAllowed
    [bool] $IsWriteAllowed

    [HashTable] Splat() {

        $splat = @{}
        $propNames = $this | gm | where {$_.MemberType -eq 'Property'} | select -ExpandProperty Name

        foreach ($prop in $propNames) {
            if ($this.GetType().GetProperty($prop)) {
                $splat.Add($prop, $this.$prop)
            }
        }

        return $splat
    }
}

