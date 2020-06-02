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


        # if we know the session is still valid, don't bother checking with the server
        # add a couple of seconds so we don't get caught making the call as it expires
        Write-Verbose ("Expires: {0}, Current (+2s): {1}" -f $this.Expires, (Get-Date).ToUniversalTime().AddSeconds(2))
        if ( $this.Expires -lt (Get-Date).ToUniversalTime().AddSeconds(2) ) {
            if ( $this.Key ) {

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
                            $this.Connect($null)
                        }
                    } else {
                        throw ('"{0} {1}: {2}' -f $_.Exception.Response.StatusCode.value__, $_.Exception.Response.StatusDescription, $_ | Out-String )
                    }
                }
            } else {
               # token
               # By default, access tokens are long-lived (90 day default). Refreshing the token should be handled outside of this class, so that the
               #  refresh token and access token can be properly maintained and passed to the script.
               
               # We have to assume a good token here and ensure Invoke-TPPRestMethod catches and handles the condition where a token expires
            }
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

    # connect for token based auth
    [void] ConnectToken(
        [string] $AccessToken
    ) {
        $this.Token = [PSCustomObject]@{
            AccessToken  = $AccessToken
        }

        # TODO: can't assume scope covers the below, need to update functions which rely on this
        #   BeardedPrincess: The Metadata/GetItemsForClass function does not require any special scope, just a valid token _should_ work
        $this.GetTppCustomFieldOnConnect()
    }

    # connect for key based
    [void] Connect(
        [PSCredential] $Credential
    ) {
        if ( -not ($this.ServerUrl) ) {
            throw "You must provide a value for ServerUrl"
        }

        $params = @{
            ServerUrl = $this.ServerUrl
        }

        if ( $Credential ) {
            $params.Method = 'Post'
            $params.UriLeaf = 'authorize'
            $params.Body = @{
                Username = $Credential.UserName
                Password = $Credential.GetNetworkCredential().Password
            }
        } else {
            $params.Method = 'Get'
            $params.UriLeaf = 'authorize/integrated'
            $params.UseDefaultCredentials = $true
        }

        $response = Invoke-TppRestMethod @params
        $this.Expires = $response.ValidUntil
        $this.Key = [pscustomobject] @{
            ApiKey     = $response.ApiKey
            Credential = $Credential
        }

        # $this.GetTppCustomFieldOnConnect()
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

