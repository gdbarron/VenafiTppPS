class TppSession {
    
    [string] $APIKey
    [System.Management.Automation.PSCredential] $Credential
    [string] $ServerUrl
    [datetime] $ValidUntil
    [PSCustomObject] $CustomField

    TppSession () {
        # throw [System.NotImplementedException]::New()
    }

    TppSession ([Hashtable] $initHash) {
        $this._init($initHash)
    }

    [void] Validate() {
        if ( $null -eq $this.ApiKey ) {
            throw "You must first connect to the TPP server with New-TppSession"
        }

        # if we know the session is still valid, don't bother checking with the server
        # add a couple of seconds so we don't get caught making the call as it expires
        Write-Verbose ("ValidUntil: {0}, Current (+2s): {1}" -f $this.ValidUntil, (Get-Date).ToUniversalTime().AddSeconds(2))
        if ( $this.ValidUntil -lt (Get-Date).ToUniversalTime().AddSeconds(2) ) {

            try {
                $params = @{
                    Method      = 'Get'
                    Uri         = ("{0}/vedsdk/authorize/checkvalid" -f $this.ServerUrl)
                    Headers     = @{
                        "X-Venafi-Api-Key" = $this.ApiKey
                    }
                    ContentType = 'application/json'
                }
                Invoke-RestMethod @params
            } catch {
                # tpp sessions timeout after 3 mins of inactivity
                # reestablish connection
                if ( $_.Exception.Response.StatusCode.value__ -eq '401' ) {
                    Write-Verbose "Unauthorized, re-authenticating"
                    $this.Connect()
                } else {
                    throw $_
                }
            }
        }
    }

    [void] Connect() {
        if ( $null -eq $this.ServerUrl -or $null -eq $this.Credential ) {
            throw "You must provide values for ServerUrl and Credential"
        }

        $params = @{
            Method    = 'Post'
            ServerUrl = $this.ServerUrl
            UriLeaf   = 'authorize'
            Body      = @{
                Username = $this.Credential.username
                Password = $this.Credential.GetNetworkCredential().password
            }
        }

        $response = Invoke-TppRestMethod @params
        $this.APIKey = $response.ApiKey
        $this.ValidUntil = $response.ValidUntil

        # get custom fields
        if ( -not $this.CustomField ) {
            $allFields = (Get-TppCustomField -TppSession $this -Class 'X509 Certificate').Items
            $deviceFields = (Get-TppCustomField -TppSession $this -Class 'Device').Items
            $allFields += $deviceFields | where {$_.Guid -notin $allFields.Guid}
            $this.CustomField = $allFields
        }

    }

    hidden [void] _init ([Hashtable] $initHash) {

        if ( -not ($initHash.ServerUrl -and $initHash.Credential) ) {
            throw "ServerUrl and Credential are required"
        }

        $this.ServerUrl = $initHash.ServerUrl
        $this.Credential = $initHash.Credential
        $this.CustomField = $null
    }
}

