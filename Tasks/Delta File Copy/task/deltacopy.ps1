[CmdletBinding(DefaultParameterSetName = 'None')]
param
(
	[String] [Parameter(Mandatory = $true)] $FromDirectory,
	[String] [Parameter(Mandatory = $true)] $ToDirectory, 
    [Boolean] [Parameter(Mandatory = $true)] $SyncAfterCopy,
    [String] [Parameter(Mandatory = $false)] $ExcludedFileNamesCommaDelimited
)
 
Write-Host "Starting Delta Copy"

Write-Host "From Directory: $FromDirectory"
Write-Host "From Directory: $ToDirectory"
Write-Host "Excluded File Name's: $ExcludedFileNamesCommaDelimited"
 
$excludedFileNamesFull = @()
 
#$excludedFileNames = $ExcludedFileNamesCommaDelimited.Split(",");

ForEach($excludedFileName in $ExcludedFileNamesCommaDelimited.Split(","))
	{
       $fileMatches = Get-ChildItem -Path $FromDirectory -Filter $excludedFileName -Recurse
 
         ForEach($targetFileMatch in $fileMatches)
        {
            $excludedFileNamesFull += ,$targetFileMatch.FullName
        }     
    }        

 
function FilesAreEqual
{
   param([System.IO.FileInfo] $first, [System.IO.FileInfo] $second) 
   $BYTES_TO_READ = 8;

   if ($first.Length -ne $second.Length)
   {
        return $false;
   }

   if ((Get-FileHash $first).Hash -eq (Get-FileHash $second).Hash) {
        return $true
    } else {
       return $false
    }
}

function CopyRecursive {
param([System.IO.DirectoryInfo] $From, [System.IO.DirectoryInfo] $To) 

 $FilesInFromFolder = Get-ChildItem -Path $From | ? {$_.psIsContainer -eq $False}
   
 Foreach ($File in ($FilesInFromFolder))
    {
		
		 $TargetFile = [io.path]::Combine($To, $File.Name )

         CopyFile $File.FullName $TargetFile        
    }

	$DirectoriesInFromFolder = Get-ChildItem -Path $From | where {$_.Attributes -eq 'Directory'}

Foreach ($Directory in ($DirectoriesInFromFolder))
    {
		 $TargetDirectoryPath = [io.path]::Combine($To, $Directory.Name )
		 $TargetDirectory = [System.IO.DirectoryInfo] $TargetDirectoryPath

		 if (-Not (Test-Path $TargetDirectoryPath)){
			 New-Item -ItemType Directory -Force -Path $TargetDirectoryPath
		 }

         CopyRecursive $Directory.FullName $TargetDirectory 
    }
}

function RemoveRecursive {
param([System.IO.DirectoryInfo] $From, [System.IO.DirectoryInfo] $To) 

 $FilesInToFolder = Get-ChildItem -Path $To | ? {$_.psIsContainer -eq $False}
   
 Foreach ($File in ($FilesInToFolder))
    {
		
		 $TargetFile = [io.path]::Combine($From, $File.Name )
         $OldFile =[io.path]::Combine($To, $File.Name )
        
         if(![System.IO.File]::Exists($TargetFile)){
                # If the file doesn't exist in the from directory
                # delete from the target directory
                Write-Host "Deleting file $File in $ToDirectory that didn't exist in $FromDirectory"
                Remove-Item $OldFile
            }
    }

	$DirectoriesInFromFolder = Get-ChildItem -Path $From | where {$_.Attributes -eq 'Directory'}

Foreach ($Directory in ($DirectoriesInFromFolder))
    {
		 $TargetDirectoryPath = [io.path]::Combine($To, $Directory.Name )
		 $TargetDirectory = [System.IO.DirectoryInfo] $TargetDirectoryPath

		 if (-Not (Test-Path $TargetDirectoryPath)){
			 New-Item -ItemType Directory -Force -Path $TargetDirectoryPath
		 }

         CopyRecursive $Directory.FullName $TargetDirectory 
    }
}

function CopyFile {
param([System.IO.FileInfo] $From, [System.IO.FileInfo] $To) 

        $shouldExclude =  $excludedFileNamesFull -contains $From; 
        
        if (!$shouldExclude)
        {
            if (Test-Path $To)
                {                 
                    if (FilesAreEqual $From $To)
                        {
                            write-host "$From is Identical and will not be copied"             
                        } 
                    else
                        {
                            Copy-Item $From.FullName $To -Force;

                            write-host "$From existed, but was different and was copied" 
                        }
                }
                else{                                      
                    Copy-Item $From.FullName $To -Force;

                    write-host "$From didn't exist and was copied" 
                }
            }
            else{write-host "$From was skipped because it was excluded" }
 }

 CopyRecursive $FromDirectory $ToDirectory
 
 if($SyncAfterCopy -eq $true){
    RemoveRecursive $FromDirectory $ToDirectory
 }