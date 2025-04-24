@echo off
cd "%~dp0"
set /p "target=Please choose the target os: {windows|linux|macos} "
call red.exe -r -t %target% -o "forms" "forms.red"
pause