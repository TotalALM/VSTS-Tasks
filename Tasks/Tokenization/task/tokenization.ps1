[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
    [String] [Parameter(Mandatory = $true)] $SourcePath,
	[String] [Parameter(Mandatory = $true)] $TargetFileNames,
	[String] [Parameter(Mandatory = $false)] $RecursiveSearch,
    [String] [Parameter(Mandatory = $true)] $TokenStart,
    [String] [Parameter(Mandatory = $true)] $TokenEnd
)

import-module "Microsoft.TeamFoundation.DistributedTask.Task.Internal" 
import-module "Microsoft.TeamFoundation.DistributedTask.Task.Common" 

$patterns = @()
$regex = $TokenStart + '[A-Za-z0-9.]*' + $TokenEnd
$matches = @()

Write-Host (Get-LocalizedString -Key 'Regex: {0}...' -ArgumentList $regex)
Write-Host (Get-LocalizedString -Key 'Source Path: {0}...' -ArgumentList $SourcePath)
Write-Host (Get-LocalizedString -Key 'Target File Name: {0}...' -ArgumentList $TargetFileName)

function ProcessMatches($fileMatches)
{
	ForEach($targetFileMatch in $fileMatches)
	{
	    $fileEncoding = Get-FileEncoding($targetFileMatch.FullName)
	
	    Write-Host (Get-LocalizedString -Key 'Targeted FileName Encoding: {0}...' -ArgumentList $fileEncoding)
		
		$targetFilePath = $targetFileMatch.Directory.FullName
		$tempFile = $targetFileMatch.FullName + '.tmp'
	
		#Write-Host (Get-LocalizedString -Key 'Target File Path: {0}...' -ArgumentList $targetFilePath)
		Write-Host (Get-LocalizedString -Key 'Target File Match: {0}...' -ArgumentList $targetFileMatch.FullName)
		Write-Host (Get-LocalizedString -Key 'Temp File: {0}...' -ArgumentList $tempFile)
		
		Copy-Item -Force $targetFileMatch.FullName $tempFile
	
		$matches = select-string -Path $tempFile -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value }
		ForEach($match in $matches)
		{
            $matchedItem = $match
            $matchedItem = $matchedItem.TrimStart($TokenStart)
            $matchedItem = $matchedItem.TrimEnd($TokenEnd)
            $matchedItem = $matchedItem -replace '\.','_'
        
            Write-Host (Get-LocalizedString -Key 'Token {0}...' -ArgumentList $matchedItem) -ForegroundColor Green
        
            $matchValue = Get-TaskVariable $distributedTaskContext $matchedItem
        
            Write-Host (Get-LocalizedString -Key 'Token Value: {0}...' -ArgumentList $matchValue) -ForegroundColor Green
        
            (Get-Content $tempFile) | 
            Foreach-Object {
                $_ -replace $match,$matchValue
            } | 
            Set-Content $tempFile -Force -Encoding $fileEncoding
		}
	
		Copy-Item -Force $tempFile $targetFileMatch.FullName
		Remove-Item -Force $tempFile	
	}
}

function Get-FileEncoding($targetFilePath)
{
 [byte[]]$byte = get-content -Encoding byte -ReadCount 4 -TotalCount 4 -Path $targetFilePath
 #Write-Host Bytes: $byte[0] $byte[1] $byte[2] $byte[3]
 
 # EF BB BF (UTF8)
 if ( $byte[0] -eq 0xef -and $byte[1] -eq 0xbb -and $byte[2] -eq 0xbf )
 { return 'UTF8' }
 
 # FE FF  (UTF-16 Big-Endian)
 elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff)
 { return 'Unicode UTF-16 Big-Endian' }
 
 # FF FE  (UTF-16 Little-Endian)
 elseif ($byte[0] -eq 0xff -and $byte[1] -eq 0xfe)
 { return 'Unicode UTF-16 Little-Endian' }
 
 # 00 00 FE FF (UTF32 Big-Endian)
 elseif ($byte[0] -eq 0 -and $byte[1] -eq 0 -and $byte[2] -eq 0xfe -and $byte[3] -eq 0xff)
 { return 'UTF32 Big-Endian' }
 
 # FE FF 00 00 (UTF32 Little-Endian)
 elseif ($byte[0] -eq 0xfe -and $byte[1] -eq 0xff -and $byte[2] -eq 0 -and $byte[3] -eq 0)
 { return 'UTF32 Little-Endian' }
 
 # 2B 2F 76 (38 | 38 | 2B | 2F)
 elseif ($byte[0] -eq 0x2b -and $byte[1] -eq 0x2f -and $byte[2] -eq 0x76 -and ($byte[3] -eq 0x38 -or $byte[3] -eq 0x39 -or $byte[3] -eq 0x2b -or $byte[3] -eq 0x2f) )
 { return 'UTF7'}
 
 # F7 64 4C (UTF-1)
 elseif ( $byte[0] -eq 0xf7 -and $byte[1] -eq 0x64 -and $byte[2] -eq 0x4c )
 { return 'UTF-1' }
 
 # DD 73 66 73 (UTF-EBCDIC)
 elseif ($byte[0] -eq 0xdd -and $byte[1] -eq 0x73 -and $byte[2] -eq 0x66 -and $byte[3] -eq 0x73)
 { return 'UTF-EBCDIC' }
 
 # 0E FE FF (SCSU)
 elseif ( $byte[0] -eq 0x0e -and $byte[1] -eq 0xfe -and $byte[2] -eq 0xff )
 { return 'SCSU' }
 
 # FB EE 28  (BOCU-1)
 elseif ( $byte[0] -eq 0xfb -and $byte[1] -eq 0xee -and $byte[2] -eq 0x28 )
 { return 'BOCU-1' }
 
 # 84 31 95 33 (GB-18030)
 elseif ($byte[0] -eq 0x84 -and $byte[1] -eq 0x31 -and $byte[2] -eq 0x95 -and $byte[3] -eq 0x33)
 { return 'GB-18030' }
 
 else
 { return 'ASCII' }
}

Write-Host (Get-LocalizedString -Key 'RecursiveSearch: {0}...' -ArgumentList $RecursiveSearch)

$targetedFiles = $TargetFileNames.Split(',')

ForEach($targetedFileName in $targetedFiles)
{
	Write-Host (Get-LocalizedString -Key 'Targeted FileName: {0}...' -ArgumentList $targetedFileName)
		
	if ([System.Convert]::ToBoolean($RecursiveSearch))
	{	
		$fileMatches = Get-ChildItem -Path $SourcePath -Filter $targetedFileName -Recurse
		
		ProcessMatches($fileMatches)
	}
	else 
	{
		$fileMatches = Get-ChildItem -Path $SourcePath -Filter $targetedFileName 
		
		ProcessMatches($fileMatches)	
	}
}
