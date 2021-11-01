@echo off
setlocal
pushd %~dp0

call:Settings
call:ParseArgs || goto end
call:ShowPrompt || goto end
call:StartOperation || goto end
goto end

:Settings
set "target_dir=%USERPROFILE%\bin"
set "name=Johnny's Git Kit"
set "link=https://github.com/lxvs/jg"
title %name% Installation
exit /b
::Settings

:ParseArgs
set climode=
set op=
if not "%~1" == "" (
    set "climode=1"
    if "%~2" == "" (
        if "%~1" == "/?" (
            call:Logo
            call:Usage
            exit /b 1
        ) else if "%~1%" == "1" (
            set "op=1"
            exit /b 0
        ) else if "%~1%" == "0" (
            set "op=0"
            exit /b 0
        ) else if /i "%~1%" == "install" (
            set "op=1"
            exit /b 0
        ) else if /i "%~1%" == "uninstall" (
            set "op=0"
            exit /b 0
        ) else if /i "%~1%" == "deploy" (
            set "op=1"
            exit /b 0
        ) else if /i "%~1%" == "remove" (
            set "op=0"
            exit /b 0
        ) else (
            >&2 echo ERROR: ignored invalid argument: %~1
            >&2 echo;
            >&2 call:Usage
            exit /b 1
        )
    ) else (
        >&2 echo ERROR: too many arguments.
        >&2 echo;
        >&2 call:Usage
        exit /b 1
    )
)
exit /b 0
::ParseArgs

:ShowPrompt
if defined op exit /b 0
call:Logo
@echo Please choose what to do:
@echo   1  Install
@echo   0  Uninstall
:choose
@echo;
set /p=Please select a number: <NUL
set selection=
set /p selection=
if "%selection%" == "1" (
    set "op=1"
    exit /b 0
) else if "%selection%" == "0" (
    set "op=0"
    exit /b 0
) else (
    >&2 echo Invalid input.
    goto choose
)
exit /b 1
::ShowPrompt

:StartOperation
if not defined op (
    >&2 echo ERROR: no operation.
    exit /b 1
)
if "%op%" == "1" (
    call:Install
) else if "%op%" == "0" (
    call:Uninstall
) else (
    >&2 echo ERROR: invalid operation - %op%
    exit /b 1
)
exit /b 1
::StartOperation

:Install
if not exist "%target_dir%" (
    mkdir "%target_dir%" || (
        >&2 echo ERROR: failed to create directory %target_dir%
        exit /b 1
    )
) else call:RemoveDeprecated
copy /Y jg "%target_dir%\" || exit /b
@echo Complete.
exit /b 0
::Install

:Uninstall
if not exist "%target_dir%\jg" (
    >&2 echo ERROR: not installed yet.
    exit /b 1
)
del /f "%target_dir%\jg"
rd "%target_dir%" 2>NUL
@echo Complete.
exit /b 0
::Uninstall

:RemoveDeprecated
pushd "%target_dir%"
del /f jgamendlastcommit jgcommitnumber jgforeachrepodo jgjustpullit jggrepacommit jgjustpullit jgmakesomediff jgnumberforthehistory jgpush jgstash jgversion 2>nul
popd
exit /b 0
::RemoveDeprecated

:Logo
@echo;
@echo     %name%
@echo     %link%
@echo;
exit /b
::Logo

:Usage
@echo Usage:
@echo     INSTALL.bat [ 1 ^| install ]
@echo     INSTALL.bat [ 0 ^| uninstall ]
exit /b
::Usage

:end
if not defined climode pause
exit /b
