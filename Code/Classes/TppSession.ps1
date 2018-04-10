class TppSession {
    
    [string] $APIKey
    [System.Management.Automation.PSCredential] $Credential
    [string] $ServerUrl
    [datetime] $ValidUntil

    TppSession () {
        throw [System.NotImplementedException]::New()
    }

    TppSession ([Hashtable] $initHash) {
        $this._init($initHash)
    }

    # TppSession ($APIKey, $Credential, $ServerUrl, $ValidUntil) {
    #     $this.APIKey = $APIKey
    #     $this.Credential = $Credential
    #     $this.ServerUrl = $ServerUrl
    #     $this.ValidUntil = $ValidUntil
    # }

    [void] Validate() {
        if ( $null -eq $this.ApiKey ) {
            throw "You must Connect to the TPP server"
        }

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
    }

    hidden [void] _init ([Hashtable] $initHash) {

        if ( -not ($initHash.ServerUrl -and $initHash.Credential) ) {
            throw "ServerUrl and Credential are required"
        }

        $this.ServerUrl = $initHash.ServerUrl
        $this.Credential = $initHash.Credential
    }
}

