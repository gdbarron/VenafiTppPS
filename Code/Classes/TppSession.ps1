class TppSession {
    
    [ValidateNotNullOrEmpty()][string] $APIKey
    [ValidateNotNullOrEmpty()][System.Management.Automation.PSCredential] $Credential
    [ValidateNotNullOrEmpty()][string] $ServerUrl
    [ValidateNotNullOrEmpty()][datetime] $ValidUntil

    TppSession($APIKey, $Credential, $ServerUrl, $ValidUntil) {
        $this.APIKey = $APIKey
        $this.Credential = $Credential
        $this.ServerUrl = $ServerUrl
        $this.ValidUntil = $ValidUntil
    }
}

