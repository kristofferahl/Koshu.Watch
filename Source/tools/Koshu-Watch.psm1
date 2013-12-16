Param(
	[Parameter(Position=0,Mandatory=1)] [hashtable]$config
)

#------------------------------------------------------------
# Commands
#------------------------------------------------------------

function Start-Watch {
	[CmdletBinding()]
	param(
		[Parameter(Position=0,Mandatory=0,ValueFromPipeline=$True)][string]$path='.\',
		[Parameter(Position=1,Mandatory=1,ValueFromPipeline=$True)][scriptblock]$action,
		[Parameter(Position=2,Mandatory=0,ValueFromPipeline=$True)][switch]$subdirectories,
		[Parameter(Position=3,Mandatory=0,ValueFromPipeline=$True)][int]$timeout=1000
	)

	if (-not (test-path $path)) {
		throw "The given path does not exist ($path)"
	}

	$path = (resolve-path $path)

	$watcher = new-object System.IO.FileSystemWatcher
	$watcher.Path = $path
	$watcher.IncludeSubdirectories = $subdirectories
	$watcher.EnableRaisingEvents = $false
	$watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName

	write-host "Watching filesystem for changes ($path)." -fore yellow

	while($true) {
		$result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::ALL, $timeout);
		if($result.TimedOut) {
			continue;
		}
		write-host $result.changetype.tostring() "'$($result.name)'" -fore yellow

		$context = ([ordered]@{
			"type" = $result.changetype.tostring().tolower()
			"path" = "$path\$($result.name)"
		})

		$fileName = [io.path]::GetFileName($context.path)
		if ($fileName -ne $null -and $fileName -ne '') {
			$context.name = $fileName
		}

		$fileExtension = [io.path]::GetExtension($context.path)
		if ($fileExtension -ne $null -and $fileExtension -ne '') {
			$context.extension = $fileExtension
		}

		if ($result.oldname -ne $null -and $result.oldname -ne '') {
			$context.oldPath="$path\$($result.oldname)"
		}

		invoke-command -scriptblock $action -argumentlist $context
	}
}


#------------------------------------------------------------
# Export
#------------------------------------------------------------

export-modulemember -function Start-Watch