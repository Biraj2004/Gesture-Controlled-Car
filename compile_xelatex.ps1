# Dynamic XeLaTeX Compilation Script
# Automatically detects the single .tex file in the current directory,
# compiles it using XeLaTeX (2 passes), checks for file locks,
# and cleans up auxiliary files.

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

# Find the .tex file in the current directory
$texFiles = Get-ChildItem -Path $scriptDir -Filter "*.tex"
if ($texFiles.Count -eq 0) {
    Write-Error "No .tex files found in the directory '$scriptDir'."
    exit 1
} elseif ($texFiles.Count -gt 1) {
    # If there are multiple, select the first one that is not a guide
    $texFile = $texFiles | Where-Object { $_.Name -notlike "*guide*" } | Select-Object -First 1
    if (-not $texFile) {
        $texFile = $texFiles[0]
    }
    Write-Host "Multiple .tex files found. Using: $($texFile.Name)" -ForegroundColor Yellow
} else {
    $texFile = $texFiles[0]
}

$baseName = $texFile.BaseName
$texFileName = $texFile.Name
$pdfFileName = "$baseName.pdf"
$pdfPath = Join-Path $scriptDir $pdfFileName

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

# Check if target PDF is locked and wait for user to release it if needed
if (Test-Path $pdfPath) {
    $fileLocked = $true
    while ($fileLocked) {
        try {
            $stream = [System.IO.File]::OpenWrite($pdfPath)
            $stream.Close()
            $fileLocked = $false
        } catch {
            Write-Host "ERROR: Target file '$pdfFileName' is locked." -ForegroundColor Red
            Write-Host "Please close the PDF file in your viewer (Acrobat, Browser, etc.) and press ENTER to retry..." -ForegroundColor Yellow
            Read-Host
        }
    }
}

# Remove stale aux/log files from any previous run
$auxExtensions = @("aux", "out", "toc", "log", "lof", "lot", "run.xml", "bcf")
foreach ($ext in $auxExtensions) {
    $auxFile = Join-Path $scriptDir "$baseName.$ext"
    if (Test-Path $auxFile) {
        Remove-Item $auxFile -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Using XeLaTeX: $xelatexExe" -ForegroundColor Cyan
Write-Host "Compiling $texFileName (pass 1 of 2)..." -ForegroundColor Cyan

& $xelatexExe -interaction=nonstopmode -halt-on-error $texFileName
if ($LASTEXITCODE -ne 0) {
    Write-Error "First XeLaTeX pass failed. See $baseName.log for details."
    exit $LASTEXITCODE
}

Write-Host "Compiling $texFileName (pass 2 of 2)..." -ForegroundColor Cyan

& $xelatexExe -interaction=nonstopmode -halt-on-error $texFileName
if ($LASTEXITCODE -ne 0) {
    Write-Error "Second XeLaTeX pass failed. See $baseName.log for details."
    exit $LASTEXITCODE
}

Write-Host "Compilation complete." -ForegroundColor Green

# Clean up all auxiliary/log files, keep only the PDF and source files.
foreach ($ext in $auxExtensions) {
    $auxFile = Join-Path $scriptDir "$baseName.$ext"
    if (Test-Path $auxFile) {
        Remove-Item $auxFile -Force -ErrorAction SilentlyContinue
    }
}

Write-Host "Final PDF: $pdfPath" -ForegroundColor Green
