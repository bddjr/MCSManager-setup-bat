@echo off
rem Encoding: UTF8
chcp 65001 >nul
title %~nx0
cd /d "%~dp0"
echo MCSManager setup bat

echo https://github.com/bddjr/MCSManager-setup-bat
echo;
Net session >nul 2>&1 || (
    echo Trying to run as Administrator...

    powershell start-process "%~nx0" -verb runas
    exit
)

echo Are you sure you want to install MCSManager? If OK, enter "yes"
; set /p y_n_install=
if /i "%y_n_install%" neq "yes" goto gotopause

set MCSManager_zip_name=MCSManager.zip
set MCSManager_install_file=C:\Program Files\MCSManager
set WinSW_name=WinSW.NET461.exe
set release_download_url=https://github.com/bddjr/MCSManager-setup-bat/releases/download/MCSManager
set download_hash_name=SHA256.txt

set downloaded=false


echo;
echo # Check the pre powershell commands
;
echo Check Get-FileHash
; powershell Get-Command Get-FileHash
if %errorlevel% neq 0 goto gotopause

echo Check Invoke-WebRequest
; powershell Get-Command Invoke-WebRequest
if %errorlevel% neq 0 goto gotopause

echo Check Expand-Archive
; powershell Get-Command Expand-Archive
if %errorlevel% neq 0 goto gotopause



if not exist %MCSManager_zip_name% goto download
:checkhash
echo;
echo # Verify file hash value

; echo Obtain the hash value of the local file

; for /F %%i in ('powershell ^(Get-FileHash MCSManager.zip^).Hash') do ( set downloaded_hash=%%i)
if %errorlevel% neq 0 goto gotopause
echo hash: %downloaded_hash%

; echo Obtain the hash value of cloud files
; for /F %%i in ('powershell ^([System.Text.Encoding]::GetEncoding^(65001^)^).GetString^(^(Invoke-WebRequest "%release_download_url%/%download_hash_name%" -UseBasicParsing^).Content^)') do ( set cloud_hash=%%i)
if %errorlevel% neq 0 goto gotopause
echo hash: %cloud_hash%

; if /i "%downloaded_hash%" neq "%cloud_hash%" (
    echo Error: Hash values are different
    ; if "%downloaded%"=="true" goto gotopause
) else (
    echo Correct: Hash values are the same
    ; goto unzip
)


:download
echo;
echo # Download MCSManager
;
@echo on
powershell Invoke-WebRequest -Uri %release_download_url%/%MCSManager_zip_name% -OutFile %MCSManager_zip_name% -UseBasicParsing
@echo off
set downloaded=true
if %errorlevel% neq 0 goto gotopause
goto checkhash


:unzip
echo;
echo # Unzip to "%MCSManager_install_file%"
; if "%downloaded%"=="false" if exist "%MCSManager_install_file%" (
    echo Detected that the folder already exists. Are you sure you want to unzip it again? If OK, enter "yes"
    ; set /p y_n_unzip=
    if /i "%y_n_unzip%" neq "yes" goto install_services
)
powershell Expand-Archive -LiteralPath %MCSManager_zip_name% -DestinationPath """%MCSManager_install_file%""" -Force
if %errorlevel% neq 0 goto gotopause


:install_services
set can_not_install_services=false

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
echo # Install MCSManager-daemon service
; cd /d "%MCSManager_install_file%\daemon\winsw"
.\%WinSW_name% install
if %errorlevel% neq 0 set can_not_install_services=true

echo;
echo # Install MCSManager-web service
; cd /d "%MCSManager_install_file%\web\winsw"
sc delete MCSManager-web
.\%WinSW_name% install
if %errorlevel% neq 0 set can_not_install_services=true

echo;
if "%can_not_install_services%"=="true" (
    echo Service installation failed. Please restart Windows and try again
) else (
    echo Service installation successful! To start the service, use the following command with administrator privileges:
    ; echo sc start MCSManager-daemon ^&^& sc start MCSManager-web
)

:gotopause
echo;
if %errorlevel% neq 0 echo Error code %errorlevel%
if "%1" neq "nopause" (
    echo The program has stopped, press any key to exit
    ; pause >nul
)
cd /d "%~dp0"
