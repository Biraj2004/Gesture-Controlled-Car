<#
.SYNOPSIS
    Compiles Gesture-Controlled-Car-MiniProject.tex into Gesture-Controlled-Car-MiniProject.pdf using XeLaTeX (two passes for correct
    figure/table numbering and citation references).

.DESCRIPTION
    Run this script from anywhere; it locates its own folder and compiles
    Gesture-Controlled-Car-MiniProject.tex there. Requires xelatex to be available
    on PATH (TeX Live / MiKTeX / TinyTeX).

.EXAMPLE
    .\compile_xelatex.ps1
#>

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

# Locate xelatex: check PATH first, fall back to TinyTeX if not found on PATH.
$xelatex = Get-Command xelatex -ErrorAction SilentlyContinue
if ($xelatex) {
    $xelatexExe = $xelatex.Source
} else {
    $tinytex = Join-Path $env:APPDATA "TinyTeX\bin\windows\xelatex.exe"
    if (Test-Path $tinytex) {
        $xelatexExe = $tinytex
    } else {
        Write-Error "xelatex not found on PATH or in TinyTeX default location. Please install TeX Live, MiKTeX, or TinyTeX."
        exit 1
    }
}

# Remove stale aux/log files from any previous run (possibly with a
# different LaTeX engine) to avoid corrupted-state compile errors.
Get-ChildItem -Path $scriptDir -Filter "Gesture-Controlled-Car-MiniProject.aux" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $scriptDir -Filter "Gesture-Controlled-Car-MiniProject.out" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $scriptDir -Filter "Gesture-Controlled-Car-MiniProject.toc" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $scriptDir -Filter "Gesture-Controlled-Car-MiniProject.log" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

Write-Host "Using XeLaTeX: $xelatexExe" -ForegroundColor Cyan
Write-Host "Compiling Gesture-Controlled-Car-MiniProject.tex (pass 1 of 2)..." -ForegroundColor Cyan

& $xelatexExe -interaction=nonstopmode -halt-on-error Gesture-Controlled-Car-MiniProject.tex
if ($LASTEXITCODE -ne 0) {
    Write-Error "First XeLaTeX pass failed. See Gesture-Controlled-Car-MiniProject.log for details."
    exit $LASTEXITCODE
}

Write-Host "Compiling Gesture-Controlled-Car-MiniProject.tex (pass 2 of 2)..." -ForegroundColor Cyan

& $xelatexExe -interaction=nonstopmode -halt-on-error Gesture-Controlled-Car-MiniProject.tex
if ($LASTEXITCODE -ne 0) {
    Write-Error "Second XeLaTeX pass failed. See Gesture-Controlled-Car-MiniProject.log for details."
    exit $LASTEXITCODE
}

Write-Host "Compilation complete." -ForegroundColor Green

# Clean up all auxiliary/log files, keep only the PDF and source files.
$auxExtensions = @("*.aux", "*.out", "*.toc", "*.log", "*.lof", "*.lot")
foreach ($pattern in $auxExtensions) {
    Get-ChildItem -Path $scriptDir -Filter $pattern -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

$finalPath = Join-Path $scriptDir "Gesture-Controlled-Car-MiniProject.pdf"
Write-Host "Final PDF: $finalPath" -ForegroundColor Green
