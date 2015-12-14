[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
    [String] [Parameter(Mandatory = $true)]
    $zip,
    [String] [Parameter(Mandatory = $true)]
    $folder,
    [String] [Parameter(Mandatory = $false )]
    $removeZipAfterCompress
)

Write-Verbose "Entering script UnZip.ps1"  -Verbose

Write-Verbose "folder = $folder" -Verbose 
Write-Verbose "zip = $zip" -Verbose 
Write-Verbose "removeZipAfterCompress = $removeZipAfterCompress" -Verbose 

function UnZip($zipPath, $folderPath)
{
    Add-Type -Assembly "System.IO.Compression.FileSystem" ;
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$zipPath", "$folderPath") ;
    
    Start-Sleep -m 4000
    
    If (Test-Path $zipPath){
	    Remove-Item $zipPath
    }

}

function RemoveZip($zip)
{ 

Write-Verbose "Removing = $zip" -Verbose 

start-Sleep -m 4000
If (Test-Path $zip){
	    Remove-Item $zip -Recurse -Force
    }
}

#Extract the zip file. 
Unzip -zipPath $zip -folderPath $folder

#Remove the folder
If ([System.Convert]::ToBoolean($removeZipAfterCompress))
{
    RemoveZip($zip)  
}