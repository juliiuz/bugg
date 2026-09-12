@echo off
chcp 65001 >nul
mode con: cols=112 lines=36
color 0F
set "ROOT=%~dp0"
set "PS1=%ROOT%Bug-G Tools.ps1"

if not exist "%PS1%" (
  echo Bug-G Tools.ps1 nao encontrado.
  pause
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
