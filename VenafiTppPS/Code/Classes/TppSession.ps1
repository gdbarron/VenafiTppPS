class TppSession {

    # [string] $APIKey
    # [System.Management.Automation.PSCredential] $Credential
    [string] $ServerUrl
    [datetime] $Expires
    [PSCustomObject] $Key
    [PSCustomObject] $Token
    [PSCustomObject] $CustomField
    # [Version] $Version

    TppSession () {
        # throw [System.NotImplementedException]::New()
    }

    TppSession ([Hashtable] $initHash) {
        $this._init($initHash)
    }

    [void] Validate() {

        if ( -not $this.Key -and -not $this.Token ) {
            throw "You must first connect to the TPP server with New-TppSession"
        }

        if ( $this.Key ) {

            # if we know the session is still valid, don't bother checking with the server
            # add a couple of seconds so we don't get caught making the call as it expires
            Write-Verbose ("Expires: {0}, Current (+2s): {1}" -f $this.Expires, (Get-Date).ToUniversalTime().AddSeconds(2))
            if ( $this.Expires -lt (Get-Date).ToUniversalTime().AddSeconds(2) ) {

                try {
                    $params = @{
                        Method      = 'Get'
                        Uri         = ("{0}/vedsdk/authorize/checkvalid" -f $this.ServerUrl)
                        Headers     = @{
                            "X-Venafi-Api-Key" = $this.Key.ApiKey
                        }
                        ContentType = 'application/json'
                    }
                    Invoke-RestMethod @params
                } catch {
                    # tpp sessions timeout after 3 mins of inactivity
                    # reestablish connection
                    if ( $_.Exception.Response.StatusCode.value__ -eq '401' ) {
                        Write-Verbose "Unauthorized, re-authenticating"
                        if ( $this.Key.Credential ) {
                            $this.Connect($this.Key.Credential)
                        } else {
                            $this.Connect()
                        }
                    } else {
                        throw $_
                    }
                }
            }
        } else {
            # token

        }
    }

    [void] GetTppCustomFieldOnConnect() {
        # get custom fields
        if ( -not $this.CustomField ) {
            $allFields = (Get-TppCustomField -TppSession $this -Class 'X509 Certificate').Items
            $deviceFields = (Get-TppCustomField -TppSession $this -Class 'Device').Items
            $allFields += $deviceFields | Where-Object { $_.Guid -notin $allFields.Guid }
            $this.CustomField = $allFields
        }
    }

    # connect for token
    [void] Connect(
        [PSCredential] $Credential,
        [string] $ClientId,
        [hashtable] $Scope,
        [string] $State
    ) {
        if ( -not ($this.ServerUrl) ) {
            throw "You must provide a value for ServerUrl"
        }

        $params = @{
            Method    = 'Post'
            ServerUrl = $this.ServerUrl
            UriRoot   = 'vedauth'
            UriLeaf   = 'authorize/oauth'
            Body      = @{
                client_id = $ClientId
                username  = $Credential.username
                password  = $Credential.GetNetworkCredential().password
            }
        }

        if ( $Scope ) {
            $params.Body.scope = $Scope
        }

        if ( $State ) {
            $params.Body.state = $State
        }

        $response = Invoke-TppRestMethod @params

        $this.Expires = $response.Expires
        $this.Token = [PSCustomObject]@{
            AccessToken  = $response.access_token
            RefreshToken = $response.RefreshToken
        }

        $this.GetTppCustomFieldOnConnect()
    }

    # connect for credential
    [void] Connect(
        [PSCredential] $Credential
    ) {
        if ( -not ($this.ServerUrl) ) {
            throw "You must provide a value for ServerUrl"
        }

        $params = @{
            Method    = 'Post'
            ServerUrl = $this.ServerUrl
            UriLeaf   = 'authorize'
            Body      = @{
                Username = $Credential.username
                Password = $Credential.GetNetworkCredential().password
            }
        }

        $response = Invoke-TppRestMethod @params
        $this.Expires = $response.ValidUntil
        $this.Key = [pscustomobject] @{
            ApiKey     = $response.ApiKey
            Credential = $Credential
        }

        # get custom fields
        if ( -not $this.CustomField ) {
            $allFields = (Get-TppCustomField -TppSession $this -Class 'X509 Certificate').Items
            $deviceFields = (Get-TppCustomField -TppSession $this -Class 'Device').Items
            $allFields += $deviceFields | Where-Object { $_.Guid -notin $allFields.Guid }
            $this.CustomField = $allFields
        }

        # $this.Version = (Get-TppSystemStatus -TppSession $this) | Select-Object -First 1 -ExpandProperty version

    }

    # connect for integrated
    [void] Connect() {
        if ( -not ($this.ServerUrl) ) {
            throw "You must provide a value for ServerUrl"
        }

        $params = @{
            Method                = 'Get'
            ServerUrl             = $this.ServerUrl
            UriLeaf               = 'authorize/integrated'
            UseDefaultCredentials = $true
        }

        $response = Invoke-TppRestMethod @params
        $this.Expires = $response.ValidUntil
        $this.Key = [pscustomobject] @{
            ApiKey     = $response.ApiKey
            Credential = $null
        }

        # get custom fields
        if ( -not $this.CustomField ) {
            $allFields = (Get-TppCustomField -TppSession $this -Class 'X509 Certificate').Items
            $deviceFields = (Get-TppCustomField -TppSession $this -Class 'Device').Items
            $allFields += $deviceFields | Where-Object { $_.Guid -notin $allFields.Guid }
            $this.CustomField = $allFields
        }

        # $this.Version = (Get-TppSystemStatus -TppSession $this) | Select-Object -First 1 -ExpandProperty version

    }

    hidden [void] _init ([Hashtable] $initHash) {

        if ( -not ($initHash.ServerUrl) ) {
            throw "ServerUrl is required"
        }

        $this.ServerUrl = $initHash.ServerUrl
        if ( $initHash.Credential ) {
            $this.Credential = $initHash.Credential
        }
        $this.CustomField = $null
    }
}

