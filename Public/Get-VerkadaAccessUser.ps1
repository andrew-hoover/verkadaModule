function Get-VerkadaAccessUser
{
	<#
		.SYNOPSIS
		Gets an Access User in an organization by userId
		
		.DESCRIPTION
		This function is used to get all the details about an indivual Access user in an org.
		This function is used to rename a camera or cameras in a Verkada org.
		The org_id and reqired tokens can be directly submitted as parameters, but is much easier to use Connect-Verkada to cache this information ahead of time and for subsequent commands.
		
		.LINK
		https://github.com/bepsoccer/verkadaModule/blob/master/docs/function-documentation/Get-VerkadaAccessUser.md

		.EXAMPLE
		Get-VerkadaAccessUser -userId 'aefrfefb-3429-39ec-b042-userAC'
		This will retrieve the user with userId aefrfefb-3429-39ec-b042-userAC.  The org_id and tokens will be populated from the cached created by Connect-Verkada.
		
		.EXAMPLE
		Get-VerkadaAccessUser -userId 'aefrfefb-3429-39ec-b042-userAC' -org_id 'deds343-uuid-of-org' -x_verkada_token 'sd78ds-uuid-of-verkada-token' -x_verkada_auth 'auth-token-uuid-dscsdc'
		This will retrieve the user with userId aefrfefb-3429-39ec-b042-userAC.  The org_id and tokens are submitted as parameters in the call.
	#>

	[CmdletBinding(PositionalBinding = $true)]
	Param(
		#The UUID of the organization the user belongs to
		[Parameter(ValueFromPipelineByPropertyName = $true, Position = 0)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$org_id = $Global:verkadaConnection.org_id,
		#The UUID of the user
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1)]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[String]$userId,
		#The Verkada(CSRF) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[ValidatePattern('^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$')]
		[string]$x_verkada_token = $Global:verkadaConnection.csrfToken,
		#The Verkada Auth(session auth) token of the user running the command
		[Parameter()]
		[ValidateNotNullOrEmpty()]
		[string]$x_verkada_auth = $Global:verkadaConnection.userToken
	)

	Begin {
		#parameter validation
		if ([string]::IsNullOrEmpty($org_id)) {throw "org_id is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_token)) {throw "x_verkada_token is missing but is required!"}
		if ([string]::IsNullOrEmpty($x_verkada_auth)) {throw "x_verkada_auth is missing but is required!"}
	} #end begin
	
	Process {
		$url = "https://vcerberus.command.verkada.com/user/$org_id/$userId"
		Invoke-VerkadaRestMethod $url $org_id -x_verkada_token $x_verkada_token -x_verkada_auth $x_verkada_auth -UnPwd
	} #end process
} #end function