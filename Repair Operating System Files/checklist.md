# Repair missing or corrupted system files
If some Windows functions aren't working or Windows crashes, use the System File Checker to scan Windows and restore your files.  

When diagnosing and repairing a Windows operating system, it's essential to follow a systematic approach. The commands you've listed are used for different purposes, and their order of execution can depend on the specific issues you are encountering. However, I can provide a general guideline on how to use them effectively:

## Step 1: Check Disk for Errors
Before attempting other repairs, it's crucial to ensure your disk is error-free. Follow these steps:

1. **Run the [`chkdsk`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/chkdsk?tabs=event-viewer) Command**: Start by using the `chkdsk` command. This tool checks for logical and physical errors in the file system and its metadata. Running `chkdsk` without any parameters displays the volume's status without correcting any errors. For a thorough check, include the `/r` parameter, which locates bad sectors and recovers readable information. Be aware that this might take a long time on larger drives. If the drive is currently in use, `chkdsk` may request to schedule the error check for the next system restart; just follow the on-screen instructions if this occurs.

    To perform this check on the `C:` drive, enter:
    ```
    chkdsk C: /r
    ```

2. **Creating a CheckDisk Script**: For convenience, consider creating a `CheckDisk.bat` file. This script automates running `chkdsk` with the `/r` parameter. The script asks for the drive letter you want to check (defaulting to the current drive if none is specified), runs `chkdsk` on that drive, and pauses upon completion for review. Make sure to execute it with administrative privileges. 

    Here's the script for `CheckDisk.bat`:
    ```batch
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
    ```

## Step 2: Run DISM for Component Store Repair

After checking the disk for errors, the next step involves using the Deployment Image Servicing and Management (DISM) tool. This tool is essential for fixing Windows corruption errors. Follow these steps:

1. **Run the [`DISM`](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-reference--deployment-image-servicing-and-management) Command**: Execute the `DISM.exe /Online /Cleanup-image /Restorehealth` command. This command scans the current Windows image for component store corruption, and then perform repair operations automatically. This command repairs the Windows image and resolves issues with Windows Update files that `chkdsk` cannot fix. It's an effective way to repair system files and ensure the integrity of your Windows installation. Open a Command Prompt with administrative privileges and run the following:

    ```
    DISM.exe /Online /Cleanup-image /Restorehealth
    ```

    This process might take some time to complete, depending on your system's health and the speed of your internet connection.

> [!IMPORTANT]
> When you run this command, DISM uses Windows Update to provide the files that are required to fix corruptions. However, if your Windows Update client is already broken, use a running Windows installation as the repair source, or use a Windows side-by-side folder from a network share or from a removable media, such as the Windows DVD, as the source of the files. To do this, run the following command instead:
    
```
DISM.exe /Online /Cleanup-Image /RestoreHealth /Source:C:\RepairSource\Windows /LimitAccess
```

2. **Creating a DISM Script**: To simplify this process, you can create a `RunDISM.bat` file. This script will automatically execute the DISM command with the necessary parameters. Remember to run this script as an Administrator for it to function correctly. It will initiate the DISM process and pause upon completion for your review.

    Here's the script for `RunDISM.bat`:
    ```batch
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
    ```

## Step 3: Use System File Checker (SFC)

After running DISM, the last step is to use the System File Checker (SFC) tool. SFC is a Windows utility that scans for corrupted system files and replaces them with functional ones. Here's how to use it:

1. **Run the [`SFC`](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/sfc) Command**: To scan your system and automatically fix any corrupted files, use the `sfc.exe /SCANNOW` command. This tool is crucial for maintaining the integrity of Windows system files. Open a Command Prompt with administrative rights and type the following command:

    ```
    sfc.exe /SCANNOW
    ```

    The scan can take some time to complete. Once it finishes, it will provide details about any corrupted files it found and whether it could fix them.

2. **Creating an SFC Script**: For ease of use, you can create a `RunSFC.bat` script. This batch file will automate the process of running the SFC tool. Ensure you execute this script with administrative privileges. It initiates the SFC scan and pauses at the end for you to check the results.

    Below is the `RunSFC.bat` script:
    ```batch
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
    ```
