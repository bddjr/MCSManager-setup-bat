@echo off
chcp 65001 >nul
title %~nx0
cd /d %~dp0
echo MCSManager setup bat
echo 一款为 MCSManager 做的 Windows 版在线安装脚本。
echo https://gitee.com/bddjr/MCSManager-setup-bat
echo;
Net session >nul 2>&1 || (
    echo 尝试以管理员权限运行脚本……
    powershell start-process "%~nx0" -verb runas
    exit
)

set MCSManager_zip_name=MCSManager.zip
set MCSManager_install_file=C:\Program Files\MCSManager
set WinSW_name=WinSW.NET461.exe


echo # 下载 MCSManager
powershell curl -o %MCSManager_zip_name% https://gitee.com/bddjr/MCSManager-setup-bat/releases/download/MCSManager/%MCSManager_zip_name%
if %errorlevel% neq 0 goto pause

echo;
echo # 解压到 "%MCSManager_install_file%"
powershell Expand-Archive -LiteralPath %MCSManager_zip_name% -DestinationPath """%MCSManager_install_file%"""
if %errorlevel% neq 0 goto pause

echo # 安装 MCSManager-daemon 服务
cd %MCSManager_install_file%\daemon\winsw
%WinSW_name% install

echo # 安装 MCSManager-web 服务
cd %MCSManager_install_file%\web\winsw
%WinSW_name% install


:pause
if "%1" neq "nopause" (
    echo;
    if %errorlevel% neq 0 echo 错误代码 %errorlevel%
    echo 程序已停止，按任意键退出
    pause >nul
)
