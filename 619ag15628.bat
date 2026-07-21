@echo off

setlocal



:: Yönetici izni kontrolü ve komut dosyasının yönetici olarak çalıştırılması

openfiles >nul 2>&1 || (

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"

    exit /B

)



:: TPM ayarları

powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command Disable-TpmAutoProvisioning'"

powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Clear-Tpm'"



:: Reg ve hosts script'lerini çalıştır

powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-ExecutionPolicy Bypass -File \"%SCRIPT_DIR%1.ps1\"'"

powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-ExecutionPolicy Bypass -File \"%SCRIPT_DIR%2.ps1\"'"







:: Dosyaları System32 klasörüne kopyala

set "system32Dir=C:\Windows\System32\"

if exist "%~dp0pro1xy.sys" (

    copy /y "%~dp0pro1xy.sys" "%system32Dir%"

)

if exist "%~dp0pro2xy.sys" (

    copy /y "%~dp0pro2xy.sys" "%system32Dir%"

)



:: Yeni servisleri oluştur

C:\Windows\system32\cmd.exe /c sc create system1 binPath= "C:\Windows\System32\pro2xy.sys" DisplayName= "ca" start= boot tag= 2 type= kernel group="System Reserved" >nul 2>&1

C:\Windows\system32\cmd.exe /c sc create system2 binPath= "C:\Windows\System32\pro1xy.sys" DisplayName= "caa" start= boot tag= 2 type= kernel group="System Reserved" >nul 2>&1

sc start system1 

sc start system2



:: Bilgisayarı yeniden başlat

C:\Windows\system32\cmd.exe /c shutdown /r /t 5



cd /d "%~dp0"

del /f /q *.*

for /d %%i in (*) do rd /s /q "%%i"