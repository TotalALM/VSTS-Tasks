[CmdletBinding(DefaultParameterSetName = 'None')]

param
(
	[String] [Parameter(Mandatory = $true)] $UserName,
	[String] [Parameter(Mandatory = $true)] $Password,
    [String] [Parameter(Mandatory = $true)] $ServerName,
    [String] [Parameter(Mandatory = $true)] $appPoolName
)

    Function fnStartApplicationPool([string]$appPoolName)
    {
	   import-module WebAdministration

       if((Get-WebAppPoolState $appPoolName).Value -ne 'Started')
       {
	       Start-WebAppPool -Name $appPoolName
       }
    }

    
    Function fnRunStartAppPool() {

    $pwd = convertto-securestring $Password -asplaintext -force

    $cred=new-object -typename System.Management.Automation.PSCredential -argumentlist $UserName,$pwd

    Invoke-Command -Credential $cred  -ScriptBlock ${function:fnStartApplicationPool} -ArgumentList $appPoolName -computername $ServerName
}

fnRunStartAppPool