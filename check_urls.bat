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
  call :CHECK_URL "%%~G"
) >>url_check_log.txt
echo.>>url_check_log.txt
del /Q /F trash.$$$

exit /b 0


:: ============================================================================
:CHECK_URL
:: Call this sub with argument(s):
::   - %1 - URL
::
setlocal

set URL="%~1"
set URL=!URL: =%%20!
for /f "usebackq delims=" %%G in (`%CURLCMD% %URL% 2^>^&1`) do (
  echo %%G %URL%
)

endlocal

exit /b 0
