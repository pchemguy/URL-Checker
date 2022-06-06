@echo off


for /f "usebackq delims=" %%G in ("headers.txt") do (
    set HEADERS=!HEADERS! --header "%%G"
)
set CURLCMD=curl -L -s^
 -c cookies.txt ^
 %HEADERS%^
 -w "%%{http_code}"^
 -o "trash.$$$"


(
  echo ==================== %DATE% %TIME% ====================
  echo.
) >>url_check_log.txt


for /f "usebackq delims=" %%G in ("urls.txt") do (
  set URL=%%~G
  set URL=!URL:%%=%%%%!
  set URL=!URL: =%%%%20!
  call :CHECK_URL "!URL!"
) >>url_check_log.txt
echo.>>url_check_log.txt
if exist "trash.$$$" del /Q /F "trash.$$$" 1>nul

exit /b 0


:: ============================================================================
:CHECK_URL
:: Call this sub with argument(s):
::   - %1 - URL
::
setlocal

set URL="%~1"
for /f "usebackq delims=" %%G in (`%CURLCMD% %URL% 2^>^&1`) do (
  echo %%G %URL%
)

endlocal

exit /b 0
