@echo off

cd /d "C:\Telegram"

start "" powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "backend.ps1"

timeout /t 2 /nobreak >nul

start "" "http://127.0.0.1:8080/"

exit