[CmdletBinding()]
param(
  [string]$Pages = "1-6",
  [int]$Resolution = 144,
  [switch]$SkipCompile
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-PageList {
  param([Parameter(Mandatory = $true)][string]$Spec)

  $pages = New-Object System.Collections.Generic.List[int]

  foreach ($part in ($Spec -split ",")) {
    $trimmed = $part.Trim()
    if (-not $trimmed) {
      continue
    }

    if ($trimmed -match "^(?<start>\d+)-(?<end>\d+)$") {
      $start = [int]$Matches.start
      $end = [int]$Matches.end

      if ($start -le $end) {
        foreach ($page in $start..$end) {
          $pages.Add($page)
        }
      }
      else {
        foreach ($page in $end..$start) {
          $pages.Add($page)
        }
      }
      continue
    }

    if ($trimmed -match "^\d+$") {
      $pages.Add([int]$trimmed)
      continue
    }

    throw "Invalid page spec segment: '$trimmed'."
  }

  if ($pages.Count -eq 0) {
    throw "No pages resolved from spec '$Spec'."
  }

  return $pages | Sort-Object -Unique
}

function Invoke-External {
  param(
    [Parameter(Mandatory = $true)][string]$FilePath,
    [Parameter(Mandatory = $true)][string[]]$ArgumentList
  )

  & $FilePath @ArgumentList
  if ($LASTEXITCODE -ne 0) {
    $joinedArgs = $ArgumentList -join " "
    throw "$FilePath failed with exit code $LASTEXITCODE. Args: $joinedArgs"
  }
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$templateDir = Split-Path -Parent $scriptDir
$repoDir = Split-Path -Parent $templateDir

$refPdf = Join-Path $repoDir "tex-rendered.pdf"
$candidatePdf = Join-Path $templateDir "example/output.pdf"
$focusDir = Join-Path $templateDir "compare/focus"
$refDir = Join-Path $focusDir "ref"
$candDir = Join-Path $focusDir "cand"
$blendDir = Join-Path $focusDir "blend"
$sideDir = Join-Path $focusDir "side"

$pageList = Get-PageList -Spec $Pages

foreach ($dir in @($refDir, $candDir, $blendDir, $sideDir)) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

if (-not $SkipCompile) {
  & (Join-Path $scriptDir "compile-typst.ps1")
  if ($LASTEXITCODE -ne 0) {
    throw "compile-typst.ps1 failed with exit code $LASTEXITCODE."
  }
}

foreach ($page in $pageList) {
  $pageLabel = "{0:d2}" -f $page
  $refPng = Join-Path $refDir "page-$pageLabel.png"
  $candPng = Join-Path $candDir "page-$pageLabel.png"
  $blendPng = Join-Path $blendDir "page-$pageLabel.png"
  $sidePng = Join-Path $sideDir "page-$pageLabel.png"
  $legacyRefPng = Join-Path $refDir "page-$page.png"
  $legacyCandPng = Join-Path $candDir "page-$page.png"

  Remove-Item -LiteralPath $refPng, $candPng, $blendPng, $sidePng, $legacyRefPng, $legacyCandPng -ErrorAction SilentlyContinue

  Invoke-External -FilePath "mutool" -ArgumentList @(
    "draw", "-F", "png", "-r", "$Resolution",
    "-o", $refPng,
    $refPdf,
    "$page"
  )

  Invoke-External -FilePath "mutool" -ArgumentList @(
    "draw", "-F", "png", "-r", "$Resolution",
    "-o", $candPng,
    $candidatePdf,
    "$page"
  )

  Invoke-External -FilePath "magick" -ArgumentList @(
    "(",
    $refPng,
    "-fuzz", "8%",
    "-transparent", "white",
    "-fill", "#0066ff",
    "-colorize", "100",
    ")",
    "(",
    $candPng,
    "-fuzz", "8%",
    "-transparent", "white",
    "-fill", "#ff0000",
    "-colorize", "100",
    ")",
    "-background", "white",
    "-compose", "Over",
    "-flatten",
    $blendPng
  )

  Invoke-External -FilePath "magick" -ArgumentList @(
    $refPng,
    $candPng,
    "+append",
    $sidePng
  )
}

Write-Host "Compared pages $($pageList -join ', ') at ${Resolution}dpi."
Write-Host "Reference PNGs: $refDir"
Write-Host "Candidate PNGs: $candDir"
Write-Host "Blend PNGs: $blendDir"
Write-Host "Side-by-side PNGs: $sideDir"
