param
(
	[Parameter(Mandatory = $true)] [string] $inputFiles,
	[Parameter(Mandatory = $true)] [string] $output,
    [Parameter(Mandatory = $false)] [string] $addDefaultRuleSets,
	[Parameter(Mandatory = $false)] [string] $removeDefaultRuleSets,
    [Parameter(Mandatory = $false)] [string] $applyoutXsl,
	[Parameter(Mandatory = $false)] [string] $summary,
    [Parameter(Mandatory = $false)] [string] $logging,
    [Parameter(Mandatory = $false)] [string] $console,
	[Parameter(Mandatory = $false)] [string] $types,
	[Parameter(Mandatory = $false)] [string] $addCustomRuleLibraries,
	[Parameter(Mandatory = $false)][ string] $addCustomRuleSets,
    [Parameter(Mandatory = $false)][ string] $removeCustomRuleSets,
    [Parameter(Mandatory = $false)][ string] $consoleXsl
)

$parameters =  @()

[bool]$summary = Convert-String $summary Boolean
[bool]$logging = Convert-String $logging Boolean
[bool]$console = Convert-String $console Boolean

$FxCopInstallationPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio 14.0\Team Tools\Static Analysis Tools"
Write-Host $FxCopInstallationPath

if (Test-Path $FxCopInstallationPath)
{
	$FxCopCmdPath = "$FxCopInstallationPath\FxCop\FxCopCmd.exe"
    Write-Host $FxCopCmdPath

	if (Test-Path $FxCopCmdPath)
	{
		foreach ($inputFile in $inputFiles)
		{
            if (Test-Path $inputFile)
			{
                Write-Host $inputFile
                $parameters += "/file:$inputFile"
            }
            else
            {
                Write-Host $inputFile does not exist
            }
		}

        if ($output)
		{
            Write-Host $output
			$parameters += "/out:$output";
		}

        if($addDefaultRuleSets)
        {
            Write-Host $addDefaultRuleSets
            $parameters += "/ruleSet:+$FxCopInstallationPath\Rule Sets\$addDefaultRuleSets";
        }

        if($removeDefaultRuleSets)
        {
            Write-Host $removeDefaultRuleSets`.ruleset
            $parameters += "/ruleSet:-$FxCopInstallationPath\Rule Sets\$removeDefaultRuleSets.ruleset";
        }

		if ($applyoutXsl)
		{
            Write-Host $applyoutXsl
			$parameters += "/applyoutXsl:$FxCopInstallationPath\FxCop\Xml\$applyoutXsl"
		}

        if ($summary)
		{
            Write-Host $summary
			$parameters += "/summary";
		}

        if ($logging)
		{
            Write-Host $logging
			$parameters += "/verbose";
		}

        if ($console)
		{
            Write-Host $console
			$parameters += "/console";
		}

        if ($types)
		{
            Write-Host $types
			$parameters += "/types:$types";
		}

        if ($addCustomRuleLibraries)
        {
            foreach ($addCustomRuleLibrary in $addCustomRuleLibraries)
		    {
                if (Test-Path $addCustomRuleLibrary)
			    {
                    Write-Host $addCustomRuleLibrary
				    $parameters += "/rule:$addCustomRuleLibrary";
			    }
                else
                {
                    Write-Host $addCustomRuleLibrary does not exist
                }
            }
        }

        if ($addCustomRuleSets)
        {
            foreach ($customRuleSet in $addCustomRuleSets)
		    {
                if (Test-Path $customRuleSet)
			    {
                    Write-Host $customRuleSet
				    $parameters += "/ruleSet:+$customRuleSet"
			    }
                else
                {
                    Write-Host $customRuleSet does not exist
                }
            }
        }

        if ($removeCustomRuleSets)
        {
            foreach ($customRuleSet in $removeCustomRuleSets)
		    {
                if (Test-Path $customRuleSet)
			    {
                    Write-Host $customRuleSet
				    $parameters += "/ruleSet:-$customRuleSet"
			    }
                else
                {
                    Write-Host $customRuleSet does not exist
                }
            }
        }

        if ($consoleXsl)
		{
            Write-Host $consoleXsl
			$parameters += "/consoleXsl:$FxCopInstallationPath\FxCop\Xml\$consoleXsl"
		}

        $parameters
        & $FxCopCmdPath $parameters
	}
    else
    {
        Write-Host $FxCopCmdPath does not exist
    }
}
else
{
    Write-Host $FxCopInstallationPath does not exist
}