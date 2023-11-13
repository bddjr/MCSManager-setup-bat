@echo off
rem Encoding: UTF8
chcp 65001 >nul
title %~nx0
cd /d "%~dp0"
echo MCSManager uninstaller
echo https://gitee.com/bddjr/MCSManager-setup-bat
echo;
Net session >nul 2>&1 || (
    echo 尝试以管理员权限运行脚本……
    powershell start-process "%~nx0" -verb runas
    exit
)

echo 你确定要卸载 MCSManager 吗？如果确定则输入yes
set /p y_n=
if /i "%y_n%" neq "yes" goto gotopause


set MCSManager_install_file=C:\Program Files\MCSManager

echo;
echo # 停止 MCSManager-web 服务
; sc stop MCSManager-web
echo # 删除 MCSManager-web 服务
; sc delete MCSManager-web

echo;
echo # 停止 MCSManager-daemon 服务
; sc stop MCSManager-daemon
echo # 删除 MCSManager-daemon 服务
; sc delete MCSManager-daemon

echo;
echo # 等待3秒
; timeout /T 3 /nobreak

echo;
echo # 移除目录 "%MCSManager_install_file%"
; rd /s /q "%MCSManager_install_file%"
if not exist "%MCSManager_install_file%\" echo 移除成功。
;

:gotopause
echo;
if %errorlevel% neq 0 echo 错误代码 %errorlevel%
echo 如果需要再次运行卸载脚本，请用管理员权限运行命令：
; echo "%%temp%%\MCSManager-uninstaller-cn.bat" nopause
; echo;
echo 如果需要删除卸载脚本，请用管理员权限运行命令：
; echo del "%%temp%%\MCSManager-uninstaller-cn.bat"
; echo;
if "%1" neq "nopause" (
    echo 程序已停止，按任意键退出
    ; pause >nul
)
cd /d "%~dp0"
