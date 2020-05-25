Class TppToken {

    [String] $AccessToken
    [string] $TokenType
    [datetime] $Expires
    [string] $RefreshToken
    [string] $Identity
    [string] $Scope
    [string] $ServerUrl

    TppToken () {
    }

    [boolean] IsValid() {
        return ($this.Expires -lt (GetDate))
    }

    [void] Refresh() {
    }
}