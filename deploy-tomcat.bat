@echo off
setlocal

REM Hard-coded Tomcat directory (update if your installation moves)
set "TOMCAT_DIR=C:\apache-tomcat-10.1.44"

if not exist "%TOMCAT_DIR%\bin\catalina.bat" (
    echo [ERROR] Could not find catalina.bat under "%TOMCAT_DIR%".
    exit /b 1
)

pushd "%~dp0"

REM Build the WAR
call mvn clean package
if errorlevel 1 (
    echo [ERROR] Maven build failed.
    popd
    exit /b 1
)

REM Stop Tomcat if it is already running
if exist "%TOMCAT_DIR%\bin\shutdown.bat" (
    call "%TOMCAT_DIR%\bin\shutdown.bat"
)

REM Remove previous deployment
if exist "%TOMCAT_DIR%\webapps\resqnet.war" del /f /q "%TOMCAT_DIR%\webapps\resqnet.war"
if exist "%TOMCAT_DIR%\webapps\resqnet" rmdir /s /q "%TOMCAT_DIR%\webapps\resqnet"

REM Copy new WAR
copy /y "%~dp0target\resqnet.war" "%TOMCAT_DIR%\webapps\resqnet.war"
if errorlevel 1 (
    echo [ERROR] Failed to copy WAR file. Did you run the build successfully?
    popd
    exit /b 1
)

REM Start Tomcat in the current console
call "%TOMCAT_DIR%\bin\catalina.bat" run

popd
endlocal
