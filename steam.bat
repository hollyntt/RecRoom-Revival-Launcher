@echo off
setlocal EnableDelayedExpansion
title RecRoom Launcher

set "GAME_DIR=%~dp0"
if "%GAME_DIR:~-1%"=="\" set "GAME_DIR=%GAME_DIR:~0,-1%"

set "PLUGINS_DIR=%GAME_DIR%\BepInEx\plugins"
set "CACHE_FILE=%GAME_DIR%\BepInEx\cache\chainloader_typeloader.dat"
set "REVIVAL_NAME=Unknown"
set "REVIVAL_EXE=RecRoom.exe"
set "REVIVAL_COLOR=[97m"
set "CHECK_RUNNING=0"

if exist "%PLUGINS_DIR%\WoofPatch.dll"             set "REVIVAL_NAME=Meow.net"    & set "REVIVAL_COLOR=[96m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\MeowPatch.dll"             set "REVIVAL_NAME=Meow.net"    & set "REVIVAL_COLOR=[96m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\MeowNet.dll"               set "REVIVAL_NAME=Meow.net"    & set "REVIVAL_COLOR=[96m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\Radeon.Core.BasePatch.dll" set "REVIVAL_NAME=Radium"      & set "REVIVAL_COLOR=[93m" & set "REVIVAL_EXE=Radium.exe"  & set "CHECK_RUNNING=1"
if exist "%PLUGINS_DIR%\RadiumPatch.dll"           set "REVIVAL_NAME=Radium"      & set "REVIVAL_COLOR=[93m" & set "REVIVAL_EXE=Radium.exe"  & set "CHECK_RUNNING=1"
if exist "%PLUGINS_DIR%\Radium.dll"                set "REVIVAL_NAME=Radium"      & set "REVIVAL_COLOR=[93m" & set "REVIVAL_EXE=Radium.exe"  & set "CHECK_RUNNING=1"
if exist "%PLUGINS_DIR%\VanillaPatch.dll"          set "REVIVAL_NAME=Vanilla"     & set "REVIVAL_COLOR=[92m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\VanillaClient.dll"         set "REVIVAL_NAME=Vanilla"     & set "REVIVAL_COLOR=[92m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\RROPlugin.dll"             set "REVIVAL_NAME=RecRoomOpen" & set "REVIVAL_COLOR=[95m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\RecRoomOpen.dll"           set "REVIVAL_NAME=RecRoomOpen" & set "REVIVAL_COLOR=[95m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\EverestPatch.dll"          set "REVIVAL_NAME=Everest"     & set "REVIVAL_COLOR=[94m" & set "REVIVAL_EXE=RecRoom.exe"
if exist "%PLUGINS_DIR%\Everest.dll"               set "REVIVAL_NAME=Everest"     & set "REVIVAL_COLOR=[94m" & set "REVIVAL_EXE=RecRoom.exe"

:: --- check exe exists (done OUTSIDE of if block to avoid () path bug) ---
set "FULL_EXE_PATH=%GAME_DIR%\!REVIVAL_EXE!"
set "EXE_MISSING=0"
if not exist "!FULL_EXE_PATH!" set "EXE_MISSING=1"
if "!EXE_MISSING!"=="1" (
    cls
    echo.
    echo  [ERROR] Could not find !REVIVAL_EXE!
    echo  Looked in: !FULL_EXE_PATH!
    echo  Make sure this script is in your RecRoom game folder.
    echo.
    pause
    exit /b 1
)

:: --- already running check for Radium ---
if "!CHECK_RUNNING!"=="1" (
    set "ALREADY_RUNNING=0"
    tasklist /FI "IMAGENAME eq !REVIVAL_EXE!" 2>NUL | find /I "!REVIVAL_EXE!" >NUL
    if !ERRORLEVEL!==0 set "ALREADY_RUNNING=1"
    if "!ALREADY_RUNNING!"=="1" (
        cls
        echo.
        echo  !REVIVAL_NAME! is already running!
        echo  If no window is visible it may still be patching.
        echo  Check Task Manager for more info.
        echo.
        pause
        exit /b 0
    )
    set "CACHE_MISSING=0"
    if not exist "!CACHE_FILE!" set "CACHE_MISSING=1"
    if "!CACHE_MISSING!"=="1" (
        echo  First run detected - BepInEx will patch in the background.
        echo  A window should appear within a few minutes.
        echo.
    )
)

:: --- menu ---
cls
echo.
echo  ===========================================
echo   RecRoom Revival Launcher
echo  ===========================================
echo.
echo   Revival : !REVIVAL_NAME!
echo   Exe     : !REVIVAL_EXE!
echo.
echo   Plugins loaded:
for %%F in ("%PLUGINS_DIR%\*.dll") do echo     - %%~nF
echo.
echo  -------------------------------------------
echo   How do you want to launch?
echo.
echo     1  -  Screen (Desktop)
echo     2  -  VR
echo     3  -  Cancel
echo.
set "CHOICE="
set /p "CHOICE=  Enter 1, 2 or 3: "

if "!CHOICE!"=="1" goto :screen
if "!CHOICE!"=="2" goto :vr
if "!CHOICE!"=="3" goto :cancel
echo  Invalid choice. Run again and type 1, 2 or 3.
echo.
pause
exit /b 0

:screen
echo.
echo  Launching !REVIVAL_NAME! - Screen mode...
start "" "!FULL_EXE_PATH!" +forcemode:screen
exit /b 0

:vr
echo.
echo  Launching !REVIVAL_NAME! - VR mode...
start "" "!FULL_EXE_PATH!" +forcemode:vr
exit /b 0

:cancel
echo.
echo  Cancelled.
pause
exit /b 0