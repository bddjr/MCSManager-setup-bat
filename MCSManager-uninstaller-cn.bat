@echo off
rem Encoding: GBK (ANSI)
title %~nx0
cd /d "%~dp0"
echo MCSManager uninstaller
echo https://gitee.com/bddjr/MCSManager-setup-bat
echo;
Net session >nul 2>&1 || (
    echo �����Թ���ԱȨ�����нű�����
    powershell start-process "%~nx0" -verb runas
    exit
)

echo ��ȷ��Ҫж�� MCSManager �����ȷ��������yes
set /p y_n=
if /i "%y_n%" neq "yes" goto gotopause


set MCSManager_install_file=C:\Program Files\MCSManager

echo;
echo # ֹͣ MCSManager-web ����
; sc stop MCSManager-web

echo;
echo # ж�� MCSManager-web ����
; sc delete MCSManager-web

echo;
echo # ֹͣ MCSManager-daemon ����
; sc stop MCSManager-daemon

echo;
echo # ж�� MCSManager-daemon ����
; sc delete MCSManager-daemon

echo;
echo # �ȴ�3��
; timeout /T 3 /nobreak

echo;
echo # ɾ�� "%MCSManager_install_file%"
; rd /s /q "%MCSManager_install_file%"
if %errorlevel%==0 echo �ɹ�
;

:gotopause
echo;
if %errorlevel% neq 0 echo ������� %errorlevel%
if "%1" neq "nopause" (
    echo ������ֹͣ����������˳�
    ; pause >nul
)