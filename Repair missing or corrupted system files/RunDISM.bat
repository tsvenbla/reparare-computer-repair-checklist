@echo off
:: RunDISM.bat
:: This script runs DISM.exe with /Online /Cleanup-image /Restorehealth.

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrative privileges...
) else (
    echo Please run this script as an Administrator.
    pause
    exit
)

:: Run DISM
echo Running DISM.exe to repair the Windows image...
DISM.exe /Online /Cleanup-image /Restorehealth

:: Pause at the end
echo.
echo DISM process complete. Press any key to exit.
pause >nul
