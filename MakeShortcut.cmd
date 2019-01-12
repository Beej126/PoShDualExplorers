::@ECHO OFF
SETLOCAL

::**** xxmklink args in order left to right
::path of the shortcut (.lnk added as needed)
::path of the object represented by the shortcut
::argument string (use quotes with space, see below)
::path of the working directory (i.e. "Start in")
::description string (shown in Shortcut's Properties)
::display mode (1:Normal [default], 3:Maximized, 7:Minimized)
::icon file [with optional icon index value n]

set scriptName=PoshDualExplorers

"%~dp0xxmklink" "%~dp0%scriptName%.lnk" PowerShell.exe "-new_console:z -ExecutionPolicy Bypass .\%scriptName%.ps1" "%~dp0" "DuEx" 7 "%~dp0%scriptName%.ico"

if %errorlevel% neq 0 (
  pause
  exit
)

echo.
echo.
echo *******************************************************
set install=Y
set /p install="copy shortcut to your auto startup folder [Y/n]: " 
IF %install% equ Y (
  copy "%~dp0%scriptName%.lnk" "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
  start "auto startup" "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
)
