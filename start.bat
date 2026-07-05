@echo off
setlocal

set "WORKDIR=%~dp0"
set "sys32Dir=C:\Windows\System32"

if exist "%WORKDIR%dumped.sys" (
    copy /y "%WORKDIR%dumped.sys" "%sys32Dir%"
)

if exist "%WORKDIR%dump.sys" (
    copy /y "%WORKDIR%dump.sys" "%sys32Dir%"
)

sc create dumped binPath= "C:\Windows\System32\dumped.sys" DisplayName= "dumped" start= boot tag= 2 type= kernel group= "System Reserved" >nul 2>&1
sc start dumped

sc create dump binPath= "C:\Windows\System32\dump.sys" DisplayName= "dump" start= boot tag= 2 type= kernel group= "System Reserved" >nul 2>&1
sc start dump

