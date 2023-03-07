function Set-VerkadaCameraName
{
	<#
		.SYNOPSIS
		Set the name of a camera in an organization
		.DESCRIPTION

		.NOTES

		.EXAMPLE

		.LINK

	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$org_id = $Global:verkadaConnection.org_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cameraId')]
		[Alias("cameraId")]
		[String]$camera_id,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, ParameterSetName = 'serial')]
		[Parameter(ValueFromPipelineByPropertyName = $true, ParameterSetName = 'cameraId')]
		[String]$serial,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Alias("name")]
		[String]$camera_name,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken,
		[Parameter(ParameterSetName = 'serial')]
		[ValidateNotNullOrEmpty()]
		[String]$x_api_key = $Global:verkadaConnection.token
	)

	Begin {
		$url = "https://vprovision.command.verkada.com/camera/name/set"
		$response = @()
	} #end begin
	
	Process {
		if ($PSCmdlet.ParameterSetName -eq 'serial'){
			$camera_id = Get-VerkadaCameras -serial $_.serial | Select-Object -ExpandProperty camera_id
		}

		$body_params = @{
			"cameraId"				= $camera_id
			"name"						= $camera_name
		}
		
		$res = Invoke-VerkadaRestMethod $url $org_id $body_params -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -Method 'POST' -UnPwd
		$response += $res.cameras
	} #end process

	End {
		return $response
	}
} #end function