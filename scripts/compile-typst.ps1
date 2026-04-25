[CmdletBinding()]
param(
  [string]$InputPath = "example/main.typ",
  [string]$OutputPath = "example/output.pdf",
  [string]$FontPath = "fonts"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateDir = Split-Path -Parent $scriptDir

Push-Location $templateDir
try {
  & typst compile --root . --font-path $FontPath $InputPath $OutputPath
  if ($LASTEXITCODE -ne 0) {
    throw "typst compile failed with exit code $LASTEXITCODE."
  }
}
finally {
  Pop-Location
}
