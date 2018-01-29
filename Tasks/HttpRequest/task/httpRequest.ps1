[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
	[String] [Parameter(Mandatory = $true)] $url,
    [String] [Parameter(Mandatory = $false)] $body,
    [String] [Parameter(Mandatory = $true)] $method,
    [String] [Parameter(Mandatory = $false)] $headers
)

if ($headers -eq "")
{
    Invoke-WebRequest -Uri $url -Method $method -Body $body
}
else {
    Invoke-WebRequest -Uri $url -Method $method -Body $body -Headers $headers
}