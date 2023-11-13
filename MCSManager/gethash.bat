for /F %%i in ('powershell ^(Get-FileHash MCSManager.zip^).Hash') do (set hash=%%i)
echo | set /p="%hash%" >SHA256.txt
pause
