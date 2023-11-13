## Language
> [zh_CN](../README.md)  
> ***en***  

***
# MCSManager setup bat
A Windows version online installation script for MCSManager.

[Using MIT license.](https://mit-license.org)  
Github: https://github.com/bddjr/MCSManager-setup-bat

***
## Get Start
If you need to install on a cloud server, please use remote desktop instead of SSH.

### Run CMD as Admin
Copy the following command, then on the remote desktop of the server, press the keyboard `win`+`R` to open 'Run', then press the keyboard `Ctrl`+`V` to paste, and then press the keyboard's `Enter`.  
```
powershell start-process -verb runas cmd
```

If UAC pops up, click "Yes" and wait for the cmd window to pop up, as shown in the following figure.  

![cmd](cmd.jpg)

***
## Install
Next, `MCSManager-setup-en-github.bat` will be used as the demonstration script.  

### 1. Download and run the installation script
Copy the following command, then on the remote desktop of the server, right-click and paste it into the cmd window with administrator privileges, and then press `Enter` on the keyboard to run.  
```cmd
cd /d "%temp%" && powershell "(-join("""`r`n""" , (((Invoke-WebRequest -Uri https://raw.githubusercontent.com/bddjr/MCSManager-setup-bat/main/MCSManager-setup-en-github.bat -UseBasicParsing).Content) -replace '\n',"""`r`n"""))) | Out-File -Encoding utf8 -FilePath MCSManager-setup-en-github.bat" && .\MCSManager-setup-en-github.bat nopause
```
The script will download and extract MCSManager to `C:\Program Files\MCSManager` , and then automatically install the service.  

### 2. Start MCSManager now
Copy the following command, then on the remote desktop of the server, right-click and paste it into the cmd window with administrator privileges, and then press `Enter` on the keyboard to run.  
```cmd
sc start MCSManager-daemon && sc start MCSManager-web
```

### 3. Delete installation script and cache compressed package
cmd run command
```cmd
del "%temp%\MCSManager-setup-en-github.bat"
del "%temp%\MCSManager.zip"
```

***
## Uninstall
Next, `MCSManager-uninstaller-en.bat` will be used as the demonstration script.  

### 1. Download and run the uninstallation script
Copy the following command, then on the remote desktop of the server, right-click and paste it into the cmd window with administrator privileges, and then press `Enter` on the keyboard to run.  
```cmd
cd /d "%temp%" && powershell "(-join("""`r`n""" , (((Invoke-WebRequest -Uri https://raw.githubusercontent.com/bddjr/MCSManager-setup-bat/main/MCSManager-uninstaller-en.bat -UseBasicParsing).Content) -replace '\n',"""`r`n"""))) | Out-File -Encoding utf8 -FilePath MCSManager-uninstaller-en.bat" && .\MCSManager-uninstaller-en.bat nopause
```
This script will stop the service, remove the service, and then delete the folder `C:\Program Files\MCSManager` .  

### 2. Delete Uninstall Script
cmd run command
cmd 运行命令  
```cmd
del "%temp%\MCSManager-uninstaller-en.bat"
```
