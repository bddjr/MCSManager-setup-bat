@echo off
rem Encoding: GBK (ANSI)
title %~nx0
cd /d "%~dp0"
echo MCSManager setup bat
echo һ��Ϊ MCSManager ���� Windows �����߰�װ�ű���

echo https://gitee.com/bddjr/MCSManager-setup-bat
echo;
Net session >nul 2>&1 || (
    echo �����Թ���ԱȨ�����нű�����

    powershell start-process "%~nx0" -verb runas
    exit
)

echo ��ȷ��Ҫ��װ MCSManager �����ȷ��������yes
; set /p y_n_install=
if /i "%y_n_install%" neq "yes" goto gotopause

set MCSManager_zip_name=MCSManager.zip
set MCSManager_install_file=C:\Program Files\MCSManager
set WinSW_name=WinSW.NET461.exe
set release_download_url=https://gitee.com/bddjr/MCSManager-setup-bat/releases/download/MCSManager
set download_hash_name=SHA256.txt

set downloaded=false


echo;
echo # ���ǰ��powershell�����Ƿ����
;
echo ��� Get-FileHash
; powershell Get-Command Get-FileHash
if %errorlevel% neq 0 goto gotopause

echo ��� Invoke-WebRequest
; powershell Get-Command Invoke-WebRequest
if %errorlevel% neq 0 goto gotopause

echo ��� Expand-Archive
; powershell Get-Command Expand-Archive
if %errorlevel% neq 0 goto gotopause



if not exist %MCSManager_zip_name% goto download
:checkhash
echo;
echo # У���ļ���ϣֵ

; echo ��ȡ���ع�ϣֵ

; for /F %%i in ('powershell ^(Get-FileHash MCSManager.zip^).Hash') do ( set downloaded_hash=%%i)
if %errorlevel% neq 0 goto gotopause
echo �����ļ���ϣֵ��%downloaded_hash%

; echo ��ȡ���ļ���ϣֵ
; for /F %%i in ('powershell ^([System.Text.Encoding]::GetEncoding^(65001^)^).GetString^(^(Invoke-WebRequest "%release_download_url%/%download_hash_name%" -UseBasicParsing^).Content^)') do ( set cloud_hash=%%i)
if %errorlevel% neq 0 goto gotopause
echo ���ļ���ϣֵ��%cloud_hash%

; if /i "%downloaded_hash%" neq "%cloud_hash%" (
    echo �������߹�ϣֵ��ͬ
    ; if "%downloaded%"=="true" goto gotopause
) else (
    echo ��ȷ�����߹�ϣֵ��ͬ
    ; goto unzip
)


:download
echo;
echo # ���� MCSManager
;
@echo on
powershell Invoke-WebRequest -Uri %release_download_url%/%MCSManager_zip_name% -OutFile %MCSManager_zip_name% -UseBasicParsing
@echo off
set downloaded=true
if %errorlevel% neq 0 goto gotopause
goto checkhash


:unzip
echo;
echo # ��ѹ�� "%MCSManager_install_file%"
; if "%downloaded%"=="false" if exist "%MCSManager_install_file%" (
    echo ��⵽���и��ļ��У�ȷ��Ҫ�ٴν�ѹ�����ȷ��������yes
    ; set /p y_n_unzip=
    if /i "%y_n_unzip%" neq "yes" goto install_services
)
powershell Expand-Archive -LiteralPath %MCSManager_zip_name% -DestinationPath """%MCSManager_install_file%""" -Force
if %errorlevel% neq 0 goto gotopause


:install_services
set can_not_install_services=false

echo;
echo # ��װ MCSManager-daemon ����
;
cd /d "%MCSManager_install_file%\daemon\winsw"
sc delete MCSManager-daemon
.\%WinSW_name% install
if %errorlevel% neq 0 set can_not_install_services=true


echo;
echo # ��װ MCSManager-web ����

cd /d "%MCSManager_install_file%\web\winsw"
sc delete MCSManager-web
.\%WinSW_name% install
if %errorlevel% neq 0 set can_not_install_services=true

echo;
if "%can_not_install_services%"=="true" (
    echo ����װʧ�ܣ�������Windows������
) else (
    echo ����װ�ɹ����Թ���ԱȨ������������������������
    ; echo sc start MCSManager-daemon ^&^& sc start MCSManager-web
)

:gotopause
echo;
if %errorlevel% neq 0 echo ������� %errorlevel%
if "%1" neq "nopause" (
    echo ������ֹͣ����������˳�
    ;
    pause >nul
)
