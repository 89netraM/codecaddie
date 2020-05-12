<#
.SYNOPSIS
Beeps and boops
#>

function Invoke-Beep {
	[CmdletBinding()]
	param(
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string] $Beeper
	)

	process {
		Write-Host "${$Beeper}: Beep bleep bloop"
	}
}