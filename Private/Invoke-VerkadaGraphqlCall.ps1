function Invoke-VerkadaGraphqlCall
{
	<#
		.SYNOPSIS
		Used to build an Invoke-RestMethod call for Verkada's Graphql enpoint
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(Mandatory = $true, Position = 0)]
		[String]$url,
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'body')]
		[Object]$body,
		[Parameter()]
		[String]$method = 'GET',
		[Parameter()]
		[int]$page_size = 100,
		[Parameter(Mandatory = $true)]
		[String]$propertyName,
		[Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'query')]
		[object]$query,
		[Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'query')]
		[object]$qlVariables,
		[Parameter(Mandatory = $true)]
		[String]$org_id,
		[Parameter(Mandatory = $true)]
		[string]$usr_id,
		[Parameter(Mandatory = $true)]
		[string]$x_verkada_token,
		[Parameter(Mandatory = $true)]
		[string]$x_verkada_auth
	)

	Process {
		if ($query) {
			$body = @{
			'query' = $query
			'variables' = $variables
			}
		}
		
		$body.variables.pagination.pageSize		= $page_size
		$body.variables.pagination.pageToken		= $null

		$cookies = @{
			'auth'	= $x_verkada_auth
			'org'		= $org_id
			'token'	= $x_verkada_token
			'usr'		= $usr_id
		}

		$session = New-WebSession $cookies $url

		$uri = $url
		$records = @()
		
		Do {
			$bodyJson = $body | ConvertTo-Json -depth 100 -Compress
			$response = Invoke-RestMethod -Uri $uri -Body $bodyJson -ContentType 'application/json' -WebSession $session -Method $method  -MaximumRetryCount 3 -TimeoutSec 120 -RetryIntervalSec 5
			$records += $response.data.($propertyName).($propertyName)
			$body.variables.pagination.pageToken = $response.data.($propertyName).nextPageToken
		} While ($body.variables.pagination.pageToken)
		
		return $records
	} #end process
} #end function