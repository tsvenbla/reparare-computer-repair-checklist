@echo off
:: RunSFC.bat
:: This script runs sfc.exe with the /SCANNOW parameter.

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrative privileges...
) else (
    echo Please run this script as an Administrator.
    pause
    exit
)

:: Run SFC
echo Running System File Checker. This might take a while...
sfc.exe /SCANNOW

:: Pause at the end
echo.
echo SFC scan complete. Press any key to exit.
pause >nul
