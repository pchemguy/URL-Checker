@echo off
:: ============================================================================
:: Downloads files from a list of URLs. The last part of the URL must be a 
:: valid file name. Additional URL arguments after the question mark are not
:: supported.
:: ============================================================================


for /f "usebackq delims=" %%G in ("headers.txt") do (
    set HEADERS=!HEADERS! --header "%%G"
)
set CURLCMD=curl -L^
 -c cookies.txt ^
 %HEADERS%


(
  echo ==================== %DATE% %TIME% ====================
  echo.
) >>url_download_log.txt

if not exist "Downloads" md "Downloads" 1>nul
for /f "usebackq delims=" %%G in ("urls.txt") do (
  set URL=%%~G
  set URL=!URL:%%=%%%%!
  set URL=!URL: =%%%%20!
  call :FILE_DOWNLOAD "!URL!"
)
echo.>>url_download_log.txt

exit /b 0


:: ============================================================================
:FILE_DOWNLOAD
:: Call this sub with argument(s):
::   - %1 - URL
::
setlocal

set URL=%~1
set FILENAME=%~nx1
set FILENAME=!FILENAME:%%20= !

if not exist "Downloads/%FILENAME%" (
  echo ++++ Downloading ++++
) else (
  echo ---- Skipping ----
)

echo URL     =%URL%
echo FILENAME=%FILENAME%

if exist "Downloads/%FILENAME%" (
 goto :SKIP_DOWNLOAD
)

echo URL     =%URL% >>url_download_log.txt
echo FILENAME=%FILENAME% >>url_download_log.txt
%CURLCMD% "%URL%" -o "Downloads/%FILENAME%" 2>>url_download_log.txt

:SKIP_DOWNLOAD
endlocal

exit /b 0


