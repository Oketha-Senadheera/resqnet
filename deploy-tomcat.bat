@echo off
setlocal EnableDelayedExpansion

REM Check if CATALINA_HOME is set, otherwise use default
if not defined TOMCAT_DIR (
    if defined CATALINA_HOME (
        set "TOMCAT_DIR=%CATALINA_HOME%"
    ) else (
        set "TOMCAT_DIR=C:\apache-tomcat-10.1.44"
    )
)

REM Check if Maven is available
where mvn >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Maven is not found in PATH. Please install Maven and add it to PATH.
    exit /b 1
)

REM Verify Tomcat installation
if not exist "%TOMCAT_DIR%\bin\catalina.bat" (
    echo [ERROR] Could not find catalina.bat under "%TOMCAT_DIR%".
    echo Please set TOMCAT_DIR environment variable or update the script.
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
    echo Stopping Tomcat...
    call "%TOMCAT_DIR%\bin\shutdown.bat"
    REM Wait for Tomcat to stop (up to 30 seconds)
    timeout /t 30 /nobreak > nul
)

REM Remove previous deployment
echo Cleaning previous deployment...
if exist "%TOMCAT_DIR%\webapps\resqnet.war" (
    del /f /q "%TOMCAT_DIR%\webapps\resqnet.war"
)
if exist "%TOMCAT_DIR%\webapps\resqnet" (
    rmdir /s /q "%TOMCAT_DIR%\webapps\resqnet"
)

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
