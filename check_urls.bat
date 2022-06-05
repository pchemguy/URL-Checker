@echo off


for /f "usebackq delims=" %%G in ("headers.txt") do (
    set HEADERS=!HEADERS! --header "%%G"
)
set WGETCMD=wget^
 --server-response^
 --spider^
 --quiet^
 %HEADERS%^
 --keep-session-cookies^
 --load-cookies="cookies.txt"^
 --save-cookies "cookies.txt"

(
  echo ==================== %DATE% %TIME% ====================
  echo.
) >>url_check_log.txt

for /f "usebackq delims=" %%G in ("urls.txt") do (
  call :CHECK_URL "%%~G"
) >>url_check_log.txt
echo.>>url_check_log.txt

exit /b 0


:: ============================================================================
:CHECK_URL
:: Call this sub with argument(s):
::   - %1 - URL
::
setlocal

set URL="%~1"
for /f "usebackq delims=" %%G in (`%WGETCMD% %URL% 2^>^&1`) do (
  set STATUS=%%G
  set STATUS=!STATUS:~0,15!
  echo !STATUS! %URL%
  goto :EXIT_RESPNOSE_FOR
)
:EXIT_RESPNOSE_FOR

endlocal

exit /b 0
