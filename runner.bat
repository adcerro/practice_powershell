@echo off
:: Check for admin rights
net session >nul 2>&1
if %errorlevel%==0 (
    echo Running with admin rights...
) else (
    echo Requesting admin privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)

:: Your real commands go below this line
powershell.exe -ExecutionPolicy Bypass -File "%dp0\script.ps1"

PAUSE

PAUSE