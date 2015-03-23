@echo off

:REM This will install (or update) Minecraft Server to run as Windows Server using
:REM NSSM - the Non-Sucking Service Manager.
:REM
:REM Call "minecraft help" for further assistance.

setlocal ENABLEDELAYEDEXPANSION
setlocal ENABLEEXTENSIONS

:REM Place minecraft_server.VERSION.jar here
:REM Optional: Also place this file there.
set MINECRAFT_HOME=C:\Program Files\Mojang\Minecraft
:REM The version denoted by the minecraft_server.jar.
set MINECRAFT_VERSION=1.8.1
:REM Minecraft Data (World Data, Configuration, etc.) will go here.
set MINECRAFT_DATA=C:\ProgramData\Mojang\Minecraft
:REM Where to find the nssm.exe matching your operating system, here: 64bit.
set NSSM_HOME=%ProgramFiles%\nssm-2.24\win64
:REM Where to find the bin\java.exe matching your operating system, here: 64bit.
set JAVA_HOME=%ProgramFiles%\Java\jre1.8.0_25

:REM Name used by NSSM to install, edit and remove service.
set SERVICE_NAME=Minecraft Server

set NSSM=%NSSM_HOME%\nssm.exe
set JAVA=%JAVA_HOME%\bin\java.exe
set MINECRAFT_JAR=%MINECRAFT_HOME%\minecraft_server.%MINECRAFT_VERSION%.jar

set NSSM_URL=https://nssm.cc/
set MINECRAFT_URL=https://minecraft.net/download
set JAVA_URL=https://java.com/download/

:REM Workaround to only pause this script at end when doubleclicked to prevent
:REM closing the shell window after the script is done. 
:REM See: http://stackoverflow.com/questions/3551888/pausing-a-batch-file-when-double-clicked-but-not-when-run-from-a-console-window
for %%x in (%cmdcmdline%) do if /i "%%~x"=="/c" set DOUBLECLICKED=1

:REM Switch statement for different options.
:REM See: http://stackoverflow.com/questions/18423443/switch-statement-equivalent-in-windows-batch-file
set COMMAND=%~1

2>NUL CALL :CASE_%COMMAND%
if ERRORLEVEL 1 call :DEFAULT_CASE
if defined ECODE goto ERROR

goto END

:CASE_help
  call :HELP
  goto END_CASE
:CASE_install
  call :INSTALL
  goto END_CASE
:CASE_edit
  call :EDIT
  goto END_CASE
:CASE_start
  call :START
  goto END_CASE
:CASE_stop
  call :STOP
  goto END_CASE
:CASE_status
  call :STATUS
  goto END_CASE
:CASE_run
  call :RUN
  goto END_CASE
:CASE_remove
  call :REMOVE
  goto END_CASE
:DEFAULT_CASE
  echo.
  echo Unknown command "%COMMAND%"
  echo.
  call :HELP
  call :SET_ECODE 11
  goto END_CASE
:END_CASE
  VER > NUL
  goto :EOF

:HELP

echo minecraft [help^|install^|remove^|edit^|start^|stop^|status^|run]
echo.
echo Tool to set up Minecraft Server and install it as a service.
echo.
echo Mind that you first should run Minecraft Server in order to set up
echo the configuration data like server.properties. Then accept the EULA
echo (in eula.txt) and start again just to ensure that the server runs
echo without problems. Install it as a service as soon as the server runs
echo just fine.
echo.
echo Recommended order of steps (run as admin or with UAC turned off):
echo.
echo 1. ^> minecraft run
echo    Configuration files will be created in: "%MINECRAFT_DATA%"
echo 2. Adapt server.properties, etc. and especially edit eula.txt to
echo    the End User License Agreement.
echo 3. ^> minecraft run
echo    Start Minecraft Server again just to see that all your configuration
echo    works. You can already log in. End server with Ctrl+C or /stop at
echo    Minecraft Console if everything is fine.
echo    You might also want to run some commands (see /help at Minecraft
echo    Console) e. g. to set default gamemode or define operators.
echo 4. ^> minecraft install
echo    Install Minecraft Server as Windows service. Service will be installed
echo    to start automatically on reboot. You can call this any time again to
echo    update the Service configuration (for example if you updated Java).
echo 5. ^> minecraft edit
echo    (Optional) Edit/review Minecraft Server settings.
echo 6. ^> minecraft start
echo    Start Minecraft Server Service.
echo.
echo Other options:
echo.
echo * ^> minecraft stop
echo   Stop Minecraft Server Service
echo * ^> minecraft status
echo   See if Minecraft Server Service is up and running.
echo * ^> minecraft remove
echo   Remove Minecraft Server Service
echo.
echo URLs:
echo * %NSSM_URL%
echo * %MINECRAFT_URL%
echo * %JAVA_URL%
echo.
echo If you cannot scroll call this help appending ^|more to your command.

goto :EOF

:REQUIRE_NSSM
if not exist "%NSSM%" (
  echo.
  echo Could not find "%NSSM%!
  echo.
  echo Please download at %NSSM_URL%
  call :SET_ECODE 12
)
goto EOF

:REQUIRE_JAVA
if not exist "%JAVA%" (
  echo.
  echo Could not find "%JAVA%!
  echo.
  echo Please download at %JAVA_URL%
  call :SET_ECODE 13
)
goto EOF

:REQUIRE_MINECRAFT
if not exist "%MINECRAFT_JAR%" (
  echo.
  echo Could not find "%MINECRAFT_JAR%"
  echo.
  echo Please download from %MINECRAFT_URL%
  call :SET_ECODE 14
)
goto EOF

:REQUIRE_DATA
if not exist "%MINECRAFT_DATA%" (
  mkdir "%MINECRAFT_DATA%"
  call :SET_ECODE %ERRORLEVEL%
)
goto EOF

:EDIT
call :REQUIRE_NSSM
if defined ECODE goto EOF
echo [NSSM] Edit Minecraft Server Service "%SERVICE_NAME%" Settings
"%NSSM%" edit "%SERVICE_NAME%"
call :SET_ECODE %ERRORLEVEL%
goto EOF

:STATUS
call :REQUIRE_NSSM
if defined ECODE goto EOF

echo [NSSM] Minecraft Server Service "%SERVICE_NAME%" Status
"%NSSM%" status "%SERVICE_NAME%"
call :SET_ECODE %ERRORLEVEL%

goto EOF

:REMOVE
call :REQUIRE_NSSM
if defined ECODE goto EOF

call :STOP
echo [NSSM] Removing Minecraft Server Service "%SERVICE_NAME%"
"%NSSM%" remove "%SERVICE_NAME%" confirm
call :SET_ECODE %ERRORLEVEL%

goto EOF

:INSTALL

call :REQUIRE_NSSM
if defined ECODE goto EOF
call :REQUIRE_JAVA
if defined ECODE goto EOF
call :REQUIRE_MINECRAFT
if defined ECODE goto EOF
call :REQUIRE_DATA
if defined ECODE goto EOF

call :STOP

echo [NSSM] Trying to remove possibly pre-existing service "%SERVICE_NAME%"...
"%NSSM%" remove "%SERVICE_NAME%" confirm >NUL 2>NUL
echo [NSSM] Installing as Service:
echo     * Minecraft Server: Version %MINECRAFT_VERSION%
echo.
echo         Path: "%MINECRAFT_JAR%"
echo         Data: "%MINECRAFT_DATA%"
echo.

"%NSSM%" install "%SERVICE_NAME%" "%JAVA%" -Xms1G -Xmx2G -Djava.awt.headless=true -server -jar """%MINECRAFT_JAR%""" nogui
call :SET_ECODE %ERRORLEVEL%

:REM Important: Start Service in Data-Directory.
"%NSSM%" set "%SERVICE_NAME%" AppDirectory "%MINECRAFT_DATA%"
"%NSSM%" set "%SERVICE_NAME%" Description "Minecraft Server v%MINECRAFT_VERSION%"

echo.
echo Now you might want to call "minecraft start".

goto EOF

:START
call :REQUIRE_NSSM
if defined ECODE goto EOF

echo.
echo [NSSM] Starting Minecraft Server Service "%SERVICE_NAME%"
echo.
"%NSSM%" start "%SERVICE_NAME%"

call :SET_ECODE %ERRORLEVEL%

goto EOF

:STOP
call :REQUIRE_NSSM
if defined ECODE goto EOF

echo [NSSM] Stopping Minecraft Server Service "%SERVICE_NAME%"
"%NSSM%" stop "%SERVICE_NAME%"

goto EOF

:RUN
call :REQUIRE_JAVA
if defined ECODE goto EOF
call :REQUIRE_MINECRAFT
if defined ECODE goto EOF
call :REQUIRE_DATA
if defined ECODE goto EOF

pushd "%MINECRAFT_DATA%"

echo [JAVA] Starting Minecraft Server with data directory "%MINECRAFT_DATA%"
echo        Help with "/help [<page>]".
echo        Quit with "/stop" or Ctrl+C.
echo.
"%JAVA%" -Xms1G -Xmx2G -Djava.awt.headless=true -server -jar "%MINECRAFT_JAR%" nogui
call :SET_ECODE %ERRORLEVEL%

popd

goto EOF

:SET_ECODE
if %1 NEQ 0 (
  set ECODE=%1
)
goto EOF

:ERROR
echo.
echo Error %ECODE%.
call :WAIT
exit /b %ECODE%

:END
echo.
echo Done.
call :WAIT
exit /b

:WAIT
if defined DOUBLECLICKED (
  echo Close if you are done reading...
  pause
)
goto :EOF
