@echo off
chcp 65001 >nul
title %~nx0
cd /d "%~dp0"
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
; set /p y_n_install=
if /i "%y_n_install%" neq "yes" goto gotopause

set MCSManager_zip_name=MCSManager.zip
set MCSManager_install_file=C:\Program Files\MCSManager
set WinSW_name=WinSW.NET461.exe
set release_download_url=https://gitee.com/bddjr/MCSManager-setup-bat/releases/download/MCSManager
set download_hash_name=SHA256.txt

set downloaded=false


echo;
echo # 检查前置powershell命令是否存在
;
echo 检查 Get-FileHash
; powershell Get-Command Get-FileHash
if %errorlevel% neq 0 goto gotopause

echo 检查 Invoke-WebRequest
; powershell Get-Command Invoke-WebRequest
if %errorlevel% neq 0 goto gotopause

echo 检查 Expand-Archive
; powershell Get-Command Expand-Archive
if %errorlevel% neq 0 goto gotopause



if not exist %MCSManager_zip_name% goto download
:checkhash
echo;
echo # 校验文件哈希值

; echo 获取本地哈希值

; for /F %%i in ('powershell ^(Get-FileHash MCSManager.zip^).Hash') do ( set downloaded_hash=%%i)
if %errorlevel% neq 0 goto gotopause
echo 本地文件哈希值：%downloaded_hash%

; echo 获取云文件哈希值
; for /F %%i in ('powershell ^([System.Text.Encoding]::GetEncoding^(65001^)^).GetString^(^(Invoke-WebRequest "%release_download_url%/%download_hash_name%" -UseBasicParsing^).Content^)') do ( set cloud_hash=%%i)
if %errorlevel% neq 0 goto gotopause
echo 云文件哈希值：%cloud_hash%

; if /i "%downloaded_hash%" neq "%cloud_hash%" (
    echo 错误：两者哈希值不同
    ; if "%downloaded%"=="true" goto gotopause
) else (
    echo 正确：两者哈希值相同
    ; goto unzip
)


:download
echo;
echo # 下载 MCSManager
;
@echo on
powershell Invoke-WebRequest -Uri %release_download_url%/%MCSManager_zip_name% -OutFile %MCSManager_zip_name% -UseBasicParsing
@echo off
set downloaded=true
if %errorlevel% neq 0 goto gotopause
goto checkhash


:unzip
echo;
echo # 解压到 "%MCSManager_install_file%"
; if "%downloaded%"=="false" if exist "%MCSManager_install_file%" (
    echo 检测到已有该文件夹，确定要再次解压吗？如果确定则输入yes
    ; set /p y_n_unzip=
    if /i "%y_n_unzip%" neq "yes" goto install_services
)
powershell Expand-Archive -LiteralPath %MCSManager_zip_name% -DestinationPath """%MCSManager_install_file%""" -Force
if %errorlevel% neq 0 goto gotopause


:install_services
set can_not_install_services=false

echo;
echo # 安装 MCSManager-daemon 服务
;
cd /d "%MCSManager_install_file%\daemon\winsw"
sc delete MCSManager-daemon
.\%WinSW_name% install
if %errorlevel% neq 0 set can_not_install_services=true


echo;
echo # 安装 MCSManager-web 服务

cd /d "%MCSManager_install_file%\web\winsw"
sc delete MCSManager-web
.\%WinSW_name% install
if %errorlevel% neq 0 set can_not_install_services=true

echo;
if "%can_not_install_services%"=="true" (
    echo 服务安装失败，请重启Windows后重试
) else (
    echo 服务安装成功！以管理员权限下面这行命令以启动服务：
    ; echo sc start MCSManager-daemon ^&^& sc start MCSManager-web
)

:gotopause
echo;
if %errorlevel% neq 0 echo 错误代码 %errorlevel%
if "%1" neq "nopause" (
    echo 程序已停止，按任意键退出
    ;
    pause >nul
)
