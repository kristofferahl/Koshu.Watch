# Koshu.Watch

File system watcher for Koshu. Contains common koshu tasks for watching directories using the System.IO.FileSystemWatcher.

## Usage

### Configuration

This plugin currently does not support configuration.

	config @{
		"Koshu.Watch"=@{}
	}

### Watching

	Start-Watch -path 'C:\Path\To\Application' -action {
		param($context)
		write-host "A change to $($context.path) triggered this action."
	}

### Watching subdirectories

	Start-Watch -path 'C:\Path\To\Application' -recurse -action {
		param($context)
		write-host "A change to $($context.path) triggered this action."
	}

## License
MIT (http://opensource.org/licenses/mit-license.php)

## Contact
Kristoffer Ahl (project founder)  
Email: koshu@77dynamite.net  
Twitter: http://twitter.com/kristofferahl  
Website: http://www.77dynamite.com/