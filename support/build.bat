@echo off
REM Wrapper for build.sh — runs it via Git Bash if available.
REM Double-click this file in Explorer, or run it from cmd/PowerShell.

setlocal

REM Try common Git Bash locations
set "BASH_EXE="
if exist "C:\Program Files\Git\bin\bash.exe" set "BASH_EXE=C:\Program Files\Git\bin\bash.exe"
if exist "C:\Program Files (x86)\Git\bin\bash.exe" set "BASH_EXE=C:\Program Files (x86)\Git\bin\bash.exe"
if exist "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" set "BASH_EXE=%LOCALAPPDATA%\Programs\Git\bin\bash.exe"

if "%BASH_EXE%"=="" (
  echo ERROR: Git Bash not found. Install Git for Windows from https://git-scm.com
  pause
  exit /b 1
)

cd /d "%~dp0"
"%BASH_EXE%" -c "./build.sh %*"

if errorlevel 1 (
  echo.
  echo Build failed. See messages above.
  pause
  exit /b 1
)

echo.
echo Done. PDFs are in the pdf\ folder.
pause
