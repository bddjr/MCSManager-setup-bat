@echo off
chcp 65001 >nul
title %~nx0
cd /d %~dp0
echo MCSManager uninstaller
echo https://gitee.com/bddjr/MCSManager-setup-bat
echo;
Net session >nul 2>&1 || (
    echo 尝试以管理员权限运行脚本……
    powershell start-process "%~nx0" -verb runas
    exit
)

echo 你确定要安装 MCSManager 吗？如果确定则输入yes
set /p y_n=
if /i "%y_n%" neq "yes" goto pause


set MCSManager_install_file=C:\Program Files\MCSManager

echo # 停止 MCSManager-web 服务
sc stop MCSManager-web

echo # 卸载 MCSManager-web 服务
sc delete MCSManager-web

echo # 停止 MCSManager-daemon 服务
sc stop MCSManager-daemon

echo # 卸载 MCSManager-daemon 服务
sc delete MCSManager-daemon

echo # 等待3秒
timeout /b 3 /nobreak

echo # 删除 %MCSManager_install_file%
rd /s /q %MCSManager_install_file%

:pause
if "%1" neq "nopause" (
    echo;
    if %errorlevel% neq 0 echo 错误代码 %errorlevel%
    echo 程序已停止，按任意键退出
    pause >nul
)
