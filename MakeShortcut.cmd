@ECHO OFF
SETLOCAL

where nircmd >nul 2>&1
if %errorlevel% GTR 0 (
  echo [91mnircmd.exe used to create shortcut not found. Must be in path.[0m
  echo download here: https://www.nirsoft.net/utils/nircmd.html
  goto :EOF
)

nircmd shortcut PowerShell.exe "%~dp0" "DuEx" "-ExecutionPolicy Bypass -WindowStyle Hidden -File PoShDualExplorers.ps1" "%~dp0PoShDualExplorers.ico" "" "" "%~dp0"

if %errorlevel% neq 0 (
  pause
  exit /b 1
)
timeout /t 5