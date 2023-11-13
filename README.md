# MCSManager setup bat
一款为 MCSManager 做的 Windows 版在线安装脚本。  

[使用MIT许可证。](https://mit-license.org)  
仓库：  
> 境内Gitee https://gitee.com/bddjr/MCSManager-setup-bat  
> 境外Github https://github.com/bddjr/MCSManager-setup-bat

***
## 开始使用
如果您需要在云服务器安装，请使用远程桌面，而不是ssh。  
接下来将以 `MCSManager-setup-cn-gitee.bat` 作为演示使用的脚本。  

### 1. 以管理员权限运行CMD  
复制下面这行命令，然后在服务器的远程桌面，按键盘 `win`+`R` 打开“运行” ，然后按键盘 `Ctrl`+`V` 的粘贴，然后按键盘的 `Enter` 。  
```
powershell Start-Process -Verb RunAs cmd
```

如果弹出UAC点“是”，然后等待弹出 cmd 窗口，界面如下图。  

![cmd](README/cmd.jpg)

### 2. 下载并运行安装脚本
复制下面这行命令，然后在服务器的远程桌面，对着管理员权限的 cmd 窗口右键粘贴，然后按键盘 `Enter` 运行。  
```cmd
cd /d %temp% && powershell curl -o MCSManager-setup-cn-gitee.bat https://gitee.com/bddjr/MCSManager-setup-bat/raw/main/MCSManager-setup-cn-gitee.bat && .\MCSManager-setup-cn-gitee.bat nopause
```
该脚本将会自动下载并解压 MCSManager 到 `C:\Program Files\MCSManager` ，然后自动安装服务。  

### 3. 立即启动 MCSManager
复制下面这行命令，然后在服务器的远程桌面，对着管理员权限的 cmd 窗口右键粘贴，然后按键盘 `Enter` 运行。  
```cmd
sc start MCSManager-daemon && sc start MCSManager-web
```

### 4. 删除安装脚本 (可选)
复制下面这行命令，然后在服务器的远程桌面，对着管理员权限的 cmd 窗口右键粘贴，然后按键盘 `Enter` 运行。  
```cmd
del %temp%\MCSManager-setup-cn-gitee.bat
```