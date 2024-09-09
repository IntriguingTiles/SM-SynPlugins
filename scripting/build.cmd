@ECHO OFF
setlocal enabledelayedexpansion

for %%f in (*.sp) do (
  set /p val=<%%f
  echo Compiling: %%f
  echo.
  "D:\Dev\alliedmodders\sourcemod\build\package\addons\sourcemod\scripting\spcomp.exe" %%f -o"D:\Dev\alliedmodders\customplugins\plugins\%%~nf.smx" -i"D:\Dev\alliedmodders\sourcemod\build\package\addons\sourcemod\scripting\include"
  echo.
)