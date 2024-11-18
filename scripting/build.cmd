@ECHO OFF
setlocal enabledelayedexpansion

for %%f in (*.sp) do (
  set /p val=<%%f
  echo Compiling: %%f
  echo.
  %SPCOMP% %%f -o"..\plugins\%%~nf.smx" -i"%SMINC%"
  echo.
)