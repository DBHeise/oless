[CmdletBinding()] 
param(
	[ValidateSet("x64", "x86")][String[]]$Platforms = @("x64", "x86"),
	[ValidateSet("Debug", "Release")][String[]]$Flavors = @("Release"),
	[Switch]$KeepPDB
)

$msbuildPath = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -requires Microsoft.Component.MSBuild -find MSBuild\Current\Bin\amd64\MSBuild.exe | Select-Object -First 1
Set-Alias -name msbuild -Value $msbuildPath


$Platforms | ForEach-Object {
	$platform = $_
	$Flavors | ForEach-Object {
		$config = $_
		$outDir = ".\bin\windows\$platform\$config"
		if (-not (Test-Path -PathType Container $outDir)) {
			New-Item -Path $outDir -ItemType Directory -Force | Out-Null
		}
		$outDir = Resolve-Path $outDir
		Write-Progress -Activity "Building" -Status ($platform + "," + $config)
		msbuild -noLogo -m -verbosity:detailed -restore -target:Rebuild -property:Configuration=$config -property:Platform=$platform -property:OutDir=$outDir -clp:"ErrorsOnly;NoSummary" oless.sln
		Write-Progress -Activity "Building" -Status ($platform + "," + $config) -Completed
		if ($LASTEXITCODE) { 
			exit $LASTEXITCODE 
		} else {
			Write-Host "Build Successful: $platform, $config"
		}
		
	}
}

if ($KeepPDB) {
	Get-ChildItem -Path .\Bin -Recurse -Exclude @("*.exe", "*.pdb") -File | Remove-Item
} else {
	#Clean up other artifacts
	Get-ChildItem -Path .\Bin -Recurse -Exclude @("*.exe") -File | Remove-Item
}