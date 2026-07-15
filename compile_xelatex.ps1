<#
.SYNOPSIS
    Compiles main.tex into main.pdf using XeLaTeX (two passes for correct
    figure/table numbering and citation references).

.DESCRIPTION
    Run this script from anywhere; it locates its own folder and compiles
    Diabetes_T2DM_Report/main.tex there. Requires xelatex to be available
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
Get-ChildItem -Path $scriptDir -Filter "main.aux" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $scriptDir -Filter "main.out" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $scriptDir -Filter "main.toc" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path $scriptDir -Filter "main.log" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue

Write-Host "Using XeLaTeX: $xelatexExe" -ForegroundColor Cyan
Write-Host "Compiling main.tex (pass 1 of 2)..." -ForegroundColor Cyan

& $xelatexExe -interaction=nonstopmode -halt-on-error main.tex
if ($LASTEXITCODE -ne 0) {
    Write-Error "First XeLaTeX pass failed. See main.log for details."
    exit $LASTEXITCODE
}

Write-Host "Compiling main.tex (pass 2 of 2)..." -ForegroundColor Cyan

& $xelatexExe -interaction=nonstopmode -halt-on-error main.tex
if ($LASTEXITCODE -ne 0) {
    Write-Error "Second XeLaTeX pass failed. See main.log for details."
    exit $LASTEXITCODE
}

Write-Host "Compilation complete." -ForegroundColor Green

# Clean up all auxiliary/log files, keep only the PDF and source files.
$auxExtensions = @("*.aux", "*.out", "*.toc", "*.log", "*.lof", "*.lot")
foreach ($pattern in $auxExtensions) {
    Get-ChildItem -Path $scriptDir -Filter $pattern -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
}

# Rename the compiled PDF to its final delivery name.
$finalName = "Gesture-Controlled-Car-MiniProject.pdf"
$finalPath = Join-Path $scriptDir $finalName
if (Test-Path $finalPath) {
    try {
        Remove-Item $finalPath -Force -ErrorAction Stop
    } catch {
        Write-Error "ERROR: Target file '$finalName' is locked."
        Write-Host "Please close the PDF file in your viewer (Acrobat, Browser, etc.) and re-run compilation." -ForegroundColor Yellow
        exit 1
    }
}
try {
    Rename-Item -Path (Join-Path $scriptDir "main.pdf") -NewName $finalName -Force
} catch {
    Write-Error "ERROR: Failed to rename main.pdf to $finalName."
    exit 1
}

Write-Host "Final PDF: $finalPath" -ForegroundColor Green
