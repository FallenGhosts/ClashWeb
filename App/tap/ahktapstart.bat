@echo off
setlocal
set DEVICE_NAME=clash-tap
set PATH=%PATH%;"%~dp0App";"%~dp0App\tap";%SystemRoot%\system32;%SystemRoot%\system32\wbem;%SystemRoot%\system32\WindowsPowerShell/v1.0
cd ./App
cd ./tap
add_tap_device.vbs
tun2socks.vbs
netsh interface ip add route 0.0.0.0/0 %DEVICE_NAME% 10.0.0.1 metric=0 store=active
netsh interface ipv6 add route ::/0 %DEVICE_NAME% fdfe:dcba:9876::1 metric=0 store=active
ipconfig /flushdns