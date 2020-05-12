<#
.SYNOPSIS
Creates new Code Golf folders base on a codegolf.stackexchange.com question.

.DESCRIPTION
Creates a folder named after the provided question, and ontaining a README with
the question.
#>

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
	[int] $ID
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

Write-Host $ID;