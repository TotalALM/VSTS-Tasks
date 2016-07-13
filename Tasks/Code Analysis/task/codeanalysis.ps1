[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
	[String] [Parameter(Mandatory = $true)] $ruleSet,
	[String] [Parameter(Mandatory = $true)] $buildDirectory,#directory of the bin folder
    [String] [Parameter(Mandatory = $true)] $fileList,
	[String] [Parameter(Mandatory = $true)] $outputFile,#The output file
    [String] [Parameter(Mandatory = $true)] $includeSummary,#whether or not to include summary to output
	[String] [Parameter(Mandatory = $true)] $logging,
	[String] [Parameter(Mandatory = $false)] $ruleSets,#identifies location of custom rulesets
	[String] [Parameter(Mandatory = $false)] $xslFileTemplate, #any xsl template for resulting report
	[String] [Parameter(Mandatory = $false)] $FxCopEXE

)
 
Write-Host "Starting Code Analysis"

[bool]$includeSummary = Convert-String $includeSummary Boolean
[bool]$logging = Convert-String $logging Boolean

$allArgs =  @()

function resolveFxCop()
{
	 if ([string]::IsNullOrEmpty($FxCopEXE))
		{	
			$v14 = "$env:ProgramFiles (x86)\Microsoft Visual Studio 14.0\Team Tools\Static Analysis Tools\FxCop\FxCopCmd.exe"	
			$v12 = "$env:ProgramFiles (x86)\Microsoft Visual Studio 12.0\Team Tools\Static Analysis Tools\FxCop\FxCopCmd.exe"

			if (test-path $v14){$FxCopEXE = $v14}
			elseif (test-path $v12){$FxCopEXE = $v12}									
		}
	
	if ((test-path $FxCopEXE)) { return $FxCopEXE}  

	throw "Fx Cop not installed"
}

function resolveRuleSets()
{
	 if ([string]::IsNullOrEmpty($ruleSets))
		{	
			$v14 = "$env:ProgramFiles (x86)\Microsoft Visual Studio 14.0\Team Tools\Static Analysis Tools\Rule Sets"	
			$v12 = "$env:ProgramFiles (x86)\Microsoft Visual Studio 12.0\Team Tools\Static Analysis Tools\Rule Sets"

			if (test-path $v14){$ruleSets = $v14}
			elseif (test-path $v12){$ruleSets = $v12}									
		}
	
	if ((test-path $ruleSets)) { return $ruleSets}  
}

function resolveXSLFileTemplate()
{
	 if ([string]::IsNullOrEmpty($xslFileTemplate))
		{	
			$v14 = "$env:ProgramFiles (x86)\Microsoft Visual Studio 14.0\Team Tools\Static Analysis Tools\FxCop\xml\FxCopReport.xsl"	
			$v12 = "$env:ProgramFiles (x86)\Microsoft Visual Studio 12.0\Team Tools\Static Analysis Tools\FxCop\xml\FxCopReport.xsl"

			if (test-path $v14){$xslFileTemplate = $v14}
			elseif (test-path $v12){$xslFileTemplate = $v12}									
		}
	
	if ((test-path $xslFileTemplate)) { return $xslFileTemplate}  
}

function CheckFileDirectory($path)
{
	if ((Test-Path $path)) { return $true }

	return $false
}

$FxCopEXE = resolveFxCop
$ruleSets = resolveRuleSets
$xslFileTemplate = resolveXSLFileTemplate


#Compile files to run analysis
$fileList.Split(",") | foreach {
    Write-Host "Include file: $buildDirectory.Trim()\$_.Trim()"

	 $chkdll = CheckFileDirectory -path $buildDirectory.Trim()  

	if ($chkdll)
	{
		$dll = "/file:$buildDirectory.Trim()\$_.Trim() "
		$allArgs += $dll 
	}
}


$allArgs += "/ruleset:+$ruleSets\$ruleSet.ruleset"


#denotes to include summary
if ($includeSummary)
{
    $allArgs += "/Summary" 
}

#sets output file path
$allArgs += "/out:$outputFile"


if ($logging)
{
    $allArgs += "/verbose"
}

$checkXsl = CheckFileDirectory -path $xslFileTemplate
if ($checkXsl)
{
    $allArgs += "/outXsl:$xslFileTemplate"
    $allArgs += "/applyoutXsl"
}

Write-Host $allArgs

& $FxCopEXE $allArgs


