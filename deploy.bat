@echo off
setlocal
set rev=
if exist VERSION for /f %%i in (VERSION) do if not defined rev set "rev=%%i"
title Johnny's Git Kit v%rev% Deployment
pushd %~dp0

set "climode="
if not "%~1" == "" (
    if "%~2" == "" (
        if "%~1%" == "1" (
            set "climode=1"
            goto deploy
        ) else if "%~1%" == "0" (
            set "climode=1"
            goto remove
        ) else >&2 echo warning: ignored invalid argument: %~1
    ) else >&2 echo warning: too many arguments, ignoring all
)

@echo Johnny's Git Kit v%rev% Deployment
@echo https://github.com/lxvs/jg
@echo;
@echo Please choose what to do:
@echo   1  Deploy Johnny's Git Kit
@echo   0  Remove Johnny's Git Kit

:choose
@echo;
set /p=Please select a number: <NUL
set selection=
set /p selection=
if "%selection%" == "1" goto deploy
if "%selection%" == "0" goto remove
>&2 echo Invalid input.
goto choose

:deploy
if not exist "bin" (
    >&2 echo Error: Could not find the script folder.
    if not defined climode pause
    exit /b 1
)
if not exist "%USERPROFILE%\bin\" (
    md "%USERPROFILE%\bin\"
    @echo Created folder '%USERPROFILE%\bin\'
) else call:RmDep
@echo Copying Johnny's Git Kit to your PC...
for /r bin\ %%f in (jg*) do copy /Y "%%f" "%USERPROFILE%\bin\"
if defined rev (
    echo #!/bin/bash
    echo echo "Johnny's Git Kit v%rev%"
    echo echo "https://github.com/lxvs/jg"
)>%USERPROFILE%\bin\jgversion || >&2 echo Warning: failed to create jgversion
call:Fin 1
exit /b

:remove
if not exist "%USERPROFILE%\bin\" (
    >&2 echo There is no Johnny's Git Kit deployed in your PC.
    if not defined climode pause
    exit /b 1
)
call:RmDep
>&2 echo Removing Johnny's Git Kit from your PC...
for /r bin\ %%f in (jg*) do del "%USERPROFILE%\bin\%%~nf" 2>NUL
del "%USERPROFILE%\bin\jgversion" 2>NUL
rd "%USERPROFILE%\bin" 2>NUL
call:Fin 0
exit /b

:Fin
@echo;
if "%~1" == "1" (
    @echo Deployment finished.
) else if "%~1" == "0" (
    @echo Removal finished.
)
if not defined climode pause
exit /b 0

:RmDep
@echo;
@echo Removing deprecated commands...
del "%USERPROFILE%\bin\jg" 2>NUL
del "%USERPROFILE%\bin\jgjustpullit" 2>NUL
del "%USERPROFILE%\bin\jgstash" 2>NUL
exit /b
