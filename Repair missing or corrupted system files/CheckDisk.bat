@echo off
:: CheckDisk.bat
:: This script runs chkdsk with /r on a specified drive.

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrative privileges...
) else (
    echo Please run this script as an Administrator.
    pause
    exit
)

:: Ask for the drive letter
set /p DriveLetter="Enter the drive letter to check (e.g., C:), or press Enter for the current drive: "

:: Run chkdsk
if "%DriveLetter%"=="" (
    echo Running chkdsk on the current drive...
    chkdsk /r
) else (
    echo Running chkdsk on %DriveLetter%...
    chkdsk %DriveLetter% /r
)

:: Pause at the end
echo.
echo Check complete. Press any key to exit.
pause >nul
