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

echo 你确定要安装 MCSManager 吗？如果确定则输入yes
set /p y_n=
if /i "%y_n%" neq "yes" goto pause


set MCSManager_zip_name=MCSManager.zip
set MCSManager_install_file=C:\Program Files\MCSManager
set WinSW_name=WinSW.NET461.exe


echo # 下载 MCSManager
if not exist %MCSManager_zip_name% (
    del %MCSManager_zip_name%
    if %errorlevel% neq 0 goto pause
)
@echo on
powershell Invoke-WebRequest -Uri https://gitee.com/bddjr/MCSManager-setup-bat/releases/download/MCSManager/%MCSManager_zip_name% -OutFile %MCSManager_zip_name%
@echo off
if %errorlevel% neq 0 goto pause

echo # 解压到 "%MCSManager_install_file%"
mkdir %MCSManager_install_file%
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
