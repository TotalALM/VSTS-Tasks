param
(
    [String] [Parameter(Mandatory = $true)] $folder,
	[String] [Parameter(Mandatory = $true)] $archive,
    [String] $removeFolderAfterExtraction
)

Write-Verbose "Entering script Extract.ps1"  -Verbose

Write-Verbose "folder = $folder" -Verbose 
Write-Verbose "removeFolderAfterExtraction = $removeFolderAfterExtraction" -Verbose 
Write-Verbose "ArchiveFormat = $archiveformat" -Verbose 

function Get7ZipExe()
{ 
      
   $sz = "$env:ProgramFiles\7-Zip\7z.exe"
   $szx86 = "$env:ProgramFiles (x86)\7-Zip\7z.exe"
   
   Write-Verbose "sz = $sz" -Verbose 
   Write-Verbose "szx86 = $szx86" -Verbose 
   
   if ((test-path $sz)) { return $sz}  

   if ((test-path $szx86)) {return $szx86}  

   throw "7-zip is not installed on this machine." 
}

function ExtractZip($folderPath, $archivePath)
{ 
    sz x $archivePath -o"$folderPath" -aoa -r 
}

function RemoveFolder($folder)
{ 
Write-Verbose "Removing = $folder" -Verbose 

start-Sleep -m 4000
If (Test-Path $folder){
	    Remove-Item $folder -Recurse -Force
    }
}

$sa = Get7ZipExe
set-alias sz $sa

#Create the zip file. 
ExtractZip -archivePath $archive -folderPath $folder

#Remove the folder
If ([System.Convert]::ToBoolean($removeFolderAfterExtraction))
{
    RemoveFolder($folder)  
}
