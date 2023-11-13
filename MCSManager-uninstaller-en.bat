@echo off
rem Encoding: UTF8
chcp 65001 >nul
title %~nx0
cd /d "%~dp0"
echo MCSManager uninstaller
echo https://github.com/bddjr/MCSManager-setup-bat
echo;
Net session >nul 2>&1 || (
    echo Trying to run as Administrator...
    powershell start-process "%~nx0" -verb runas
    exit
)

echo Are you sure you want to uninstall MCSManager? If OK, enter "yes"
set /p y_n=
if /i "%y_n%" neq "yes" goto gotopause


set MCSManager_install_file=C:\Program Files\MCSManager

echo;
echo # Stop MCSManager-web service
; sc stop MCSManager-web
echo # Delete MCSManager-web service
; sc delete MCSManager-web

echo;
echo # Stop MCSManager-daemon service
; sc stop MCSManager-daemon
echo # Delete MCSManager-daemon service
; sc delete MCSManager-daemon

echo;
echo # Wait for 3 seconds
; timeout /T 3 /nobreak

echo;
echo # Remove dir "%MCSManager_install_file%"
; rd /s /q "%MCSManager_install_file%"
if not exist "%MCSManager_install_file%\" echo Successfully removed.
;

:gotopause
echo;
if %errorlevel% neq 0 echo Error code %errorlevel%
echo If you need to run the uninstall script again, please run the command with administrator privileges:
; echo "%%temp%%\MCSManager-uninstaller-cn.bat" nopause
; echo;
echo If you need to delete the uninstallation script, please run the command with administrator privileges:
; echo del "%%temp%%\MCSManager-uninstaller-cn.bat"
; echo;
if "%1" neq "nopause" (
    echo The program has stopped, press any key to exit
    ; pause >nul
)
cd /d "%~dp0"
