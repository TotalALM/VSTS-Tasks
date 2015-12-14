[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
    [String] [Parameter(Mandatory = $true)]
    $folder,
	[String] [Parameter(Mandatory = $true)]
    $zip,
    [String] [Parameter(Mandatory = $false)]
    $removeFolderAfterExtraction
)

Write-Verbose "Entering script Extract.ps1"  -Verbose

Write-Verbose "folder = $folder" -Verbose 
Write-Verbose "zip = $zip" -Verbose 
Write-Verbose "removeFolderAfterExtraction = $removeFolderAfterExtraction" -Verbose 

function CreateZip($folderPath, $zipPath)
{ 
    Add-Type -Assembly "System.IO.Compression.FileSystem" ;
	[System.IO.Compression.ZipFile]::CreateFromDirectory("$folderPath", "$zipPath") ;
    
}

function RemoveFolder($folder)
{ 
Write-Verbose "Removing = $folder" -Verbose 

start-Sleep -m 4000
If (Test-Path $folder){
	    Remove-Item $folder -Recurse -Force
    }
}

#Create the zip file. 
CreateZip -zipPath $zip -folderPath $folder

#Remove the folder
If ([System.Convert]::ToBoolean($removeFolderAfterExtraction))
{
    RemoveFolder($folder)  
}
