<#
.SYNOPSIS
Creates new Code Golf folders base on a codegolf.stackexchange.com question.

.DESCRIPTION
Creates a folder named after the provided question, and ontaining a README with
the question.
#>

function New-CodeGolf {
	[CmdletBinding(DefaultParameterSetName = "ByUrl")]
	param(
		# Proved the Url to a CodeGolf question.
		[Parameter(Mandatory = $true,
			ValueFromPipeline = $true,
			Position = 0,
			ParameterSetName = "ByUrl")]
		[string] $Url,
		
		# Proved the ID to a CodeGolf question.
		[Parameter(Mandatory = $true,
			ParameterSetName = "ByID")]
		[int] $ID,
	
		# Name folder this instead of the title of the CodeGolf.
		[string] $Folder
	)
	
	if ($PSCmdlet.ParameterSetName -eq "ByUrl") {
		$Match = [Regex]::Match($Url, "questions/(\d+)");
		if ($Match.Success) {
			$ID = $Match.Groups[1].Value;
		}
		else {
			Write-Warning "Malformated codegolf.stackexchange.com Url.";
			exit 1;
		}
	}
	
	$Item
	try {
		$Response = Invoke-WebRequest "https://api.stackexchange.com/2.2/questions/$($ID)?site=codegolf&filter=!-W2e9exN_*126BIx8c_v" -ErrorAction Stop
		$Item = (ConvertFrom-Json $Response.Content).items[0]
	}
	catch {
		Write-Warning "Could not fetch the question.`n`t$($_.Exception.Message)"
	}
	finally {
		$Response.Dispose()
	}
	
	$Meta = "---`ntitle: $($Item.title)`npermalink: $($Item.link)`ntags: $($Item.tags)`n---`n`n"
	$Heading = "# [$($Item.title)]($($Item.link))`n`n"
	$ReadmeContent = $Meta + $Heading + $Item.body_markdown
	
	if ($Folder) {
		if (-Not (Test-Path ".\$Folder" -PathType Container)) {
			New-Item -ItemType Directory -Path ".\$Folder" | Out-Null
		}
		$ReadmeContent | Out-File -FilePath ".\$Folder\README.md" -Force
	}
	else {
		$Folder = [Regex]::Match($Item.link, "questions/\d+/(.+)").Groups[1].Value
	
		if (Test-Path ".\$Folder" -PathType Container) {
			$i = 1
			do {
				$i++
			} while (Test-Path ".\$Folder ($i)" -PathType Container)
			$Folder = ".\$Folder ($i)"
		}
		New-Item -ItemType Directory -Path ".\$Folder" | Out-Null
	
		$ReadmeContent | Out-File -FilePath ".\$Folder\README.md"
	}
}

Export-ModuleMember -Function New-CodeGolf