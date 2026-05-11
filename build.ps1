# build.ps1 -- Compile support handout + presentation slides.
#
# Usage:
#   .\build.ps1                 # compile both (support + presentation)
#   .\build.ps1 support         # compile only support handout
#   .\build.ps1 presentation    # compile only presentation slides
#
# Auto-recompile on save (after first manual build, leave running):
#   cd support\src
#   latexmk -pvc -pdf main.tex
#
# Requires: pdflatex on PATH (MiKTeX or TeX Live).

param(
  [string]$Target = "all"
)

$ErrorActionPreference = "Stop"

# Resolve pdflatex location (MiKTeX user install is not always on PATH)
$pdflatex = (Get-Command pdflatex -ErrorAction SilentlyContinue).Source
if (-not $pdflatex) {
  $candidate = "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64\pdflatex.exe"
  if (Test-Path $candidate) { $pdflatex = $candidate }
}
if (-not $pdflatex) {
  Write-Error "pdflatex not found. Install MiKTeX or add it to PATH."
  exit 1
}

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$jobs = @()

if ($Target -eq "all" -or $Target -eq "support") {
  $jobs += [pscustomobject]@{ Name = "Support handout"; Dir = "$root\support\src"; File = "main.tex" }
}
if ($Target -eq "all" -or $Target -eq "presentation") {
  $jobs += [pscustomobject]@{ Name = "Presentation";    Dir = "$root\presentation";  File = "main.tex" }
}
if (-not $jobs) {
  Write-Error "Unknown target '$Target'. Use: all | support | presentation"
  exit 1
}

$start = Get-Date
$failed = @()

foreach ($job in $jobs) {
  Write-Host ""
  Write-Host "==> $($job.Name)  ($($job.Dir))" -ForegroundColor Cyan

  Push-Location $job.Dir
  try {
    # Two passes for TOC / refs / phantomsections
    & $pdflatex -interaction=nonstopmode -halt-on-error $job.File | Out-Null
    & $pdflatex -interaction=nonstopmode -halt-on-error $job.File | Out-Null

    if ($LASTEXITCODE -eq 0 -and (Test-Path "main.pdf")) {
      $size = [math]::Round((Get-Item "main.pdf").Length / 1KB, 0)
      Write-Host "    OK -- main.pdf ($size KB)" -ForegroundColor Green

      # Clean intermediate files but keep .pdf and .log
      Get-ChildItem -Include "*.aux", "*.out", "*.toc", "*.synctex.gz", "*.nav", "*.snm", "*.vrb" -Path .\* -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
    } else {
      Write-Host "    FAILED -- see main.log" -ForegroundColor Red
      $failed += $job.Name
    }
  }
  finally {
    Pop-Location
  }
}

$elapsed = ((Get-Date) - $start).TotalSeconds
Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
if ($failed.Count -eq 0) {
  Write-Host "Done in $([math]::Round($elapsed, 1))s. All builds OK." -ForegroundColor Green
} else {
  Write-Host "Done in $([math]::Round($elapsed, 1))s. FAILED: $($failed -join ', ')" -ForegroundColor Red
  exit 1
}
