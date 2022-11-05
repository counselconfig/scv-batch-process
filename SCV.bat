@ECHO OFF 
:: This batch file loads external data into the Single Customer View comprising 3/3 processes
:::  ___  _____   __
::: / __|/ __\ \ / /
::: \__ \ (__ \ V / 
::: |___/\___| \_/                
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
ECHO.
ECHO Please wait, updating Single Customer View
ECHO.
ECHO ===========================================================
ECHO 1/3 Getting Econnect, Eventbrite, and SmartSurvey data
ECHO ===========================================================
start /d "Y:\Single Customer View\Integration Services\SCV Solutions\winscpdex\winscpdex\bin\Debug" winscpdex.exe
start /d "Y:\Single Customer View\Integration Services\SCV Solutions\SmartSurvey" SS_output_main.bat
start /w /d "Y:\Single Customer View\Integration Services\SCV Solutions\Eventbrite" EB_output_main.bat
ECHO.
ECHO =============================================
ECHO 2/3 Backing up new and limiting historic data
ECHO =============================================
call Powershell.exe "& 'Y:\Single Customer View\Integration Services\SCV Solutions\Backup sources script\Backup sources.ps1'"
call Powershell.exe "& 'Y:\Single Customer View\Integration Services\SCV Solutions\Storage limitation script\Storage limitation delete.ps1'"
ECHO.
ECHO ======================================
ECHO 3/3 Loading data into the SCV database
ECHO ======================================
start /d "Y:\Single Customer View\Integration Services\SCV Solutions\econnect\econnect\bin\Debug" econnect.exe
start /w "" "C:\Program Files (x86)\Microsoft SQL Server\120\DTS\Binn\DTExec.exe"  /f "Y:\Single Customer View\Integration Services\SCV Solutions\SCV Data Integration\SCV Data Integration\SCV2.dtsx" 
ECHO.
ECHO **************************************
ECHO Finished updating Single Customer View 
ECHO **************************************
PAUSE

rem /d = run and execute the next command 
rem /w = wait for the command to complete before running the next one 

