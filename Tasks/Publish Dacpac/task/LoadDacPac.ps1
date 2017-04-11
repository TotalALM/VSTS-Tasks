param( 
    [string] [Parameter(Mandatory = $true)] $sqlVersion,
    [string] [Parameter(Mandatory = $true)] $dacpacfilepath,
    [string] [Parameter(Mandatory = $true)] $connectionstring,
    [string] [Parameter(Mandatory = $true)] $databaseName,
    [string] [Parameter(Mandatory = $true)] $blockdataloss = $false,
    [string] [Parameter(Mandatory = $true)] $allowincompatableplatform,
    [string] [Parameter(Mandatory = $true)] $ignorefileandlogpaths,
    [string] [Parameter(Mandatory = $true)] $ignorefilegroupplacement,
    [string] [Parameter(Mandatory = $true)] $ignorefilesize,
    [string] [Parameter(Mandatory = $true)] $includecompositeobjects,
    [string] [Parameter(Mandatory = $false)] $dacpacdlloverride
        ) 

Write-Host "Deploying the DB with the following settings" 
Write-Host "dacpac: $dacpacfilepath" 
Write-Host "connection String: $connectionstring"
Write-Host "Include Composite Objects: $includecompositeobjects"
Write-Host "Ignore File Size: $ignorefilesize"
Write-Host "Ignore File Group Placement: $ignorefilegroupplacement"
Write-Host "Ignore File and Log File Paths: $ignorefileandlogpaths"
Write-Host "Allow Incompatible Platform: $allowincompatableplatform"
Write-Host "Block Possible data loss: $blockdataloss"
Write-Host ""

#$filePath = $MyInvocation.MyCommand.Path
#$fileName = $MyInvocation.MyCommand.Name
#$filePath = $filePath.Replace($fileName, "")

$filePath = "C:\Program Files (x86)\Microsoft SQL Server\120\Dac\bin\Microsoft.SqlServer.Dac.dll"
if ($sqlVersion -eq "2008r2")
{
    $filePath = "C:\Program Files (x86)\Microsoft SQL Server\110\DAC\bin\Microsoft.SqlServer.Dac.dll"
}


Write-Host "Current File Path: $filePath"

if ($dacpacdlloverride -eq "")
{
    if ($sqlVersion -eq "2014")
    {
        $toolsdll = $filePath
        add-type -path "$toolsdll"
        $dacpacdlloverride = $filePath
        Write-Host $dacpacdlloverride
        add-type -path "$dacpacdlloverride"
    }
    elseif ($sqlVersion -eq "2008r2")
    {
        $dacpacdlloverride = $filePath
        Write-Host $dacpacdlloverride
        add-type -path "$dacpacdlloverride"
    }
}

# load in DAC DLL (requires config file to support .NET 4.0) 
 # change file location for a 32-bit OS 
  add-type -path "$dacpacdlloverride"

Write-Host "Connection String: $connectionstring"

 $d = new-object Microsoft.SqlServer.Dac.DacServices "$connectionstring" 
# register events, if you want ’em 
#register-objectevent -in $d -eventname Message -source "msg" -action { out-host -in $Event.SourceArgs[1].Message.Message } | Out-Null

$DeployOptions = new-object Microsoft.SqlServer.Dac.DacDeployOptions
        $DeployOptions.IncludeCompositeObjects = $includecompositeobjects
        $DeployOptions.IgnoreFileSize = $ignorefilesize
        $DeployOptions.IgnoreFilegroupPlacement = $ignorefilegroupplacement
        $DeployOptions.IgnoreFileAndLogFilePath = $ignorefileandlogpaths     
        $DeployOptions.AllowIncompatiblePlatform = $allowincompatableplatform  
        $DeployOptions.BlockOnPossibleDataLoss = $blockdataloss

Write-Host "Executing Deployment of Dacpac"

Try
{
# Load dacpac from file & deploy to database named pubsnew 
 $dp = [Microsoft.SqlServer.Dac.DacPackage]::Load($dacpacfilepath) 
 $d.Deploy($dp, $databaseName, $true, $DeployOptions) # the true is to allow an upgrade, could be parameterised, also can add further deploy params
 Write-Host "Deployed Successful"
 }
 catch [System.Exception]
 {
    # $_ is set to the ErrorRecord of the exception
  if ($_.Exception.InnerException) {
    Write-Host $_.Exception.InnerException.Message
  } else {
    Write-Host $_.Exception.Message
  }
  throw [System.IO.FileNotFoundException] $_.Exception.Message

 }

