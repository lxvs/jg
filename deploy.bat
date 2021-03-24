@echo off
setlocal
set "_ver=1.3.0"
title Johnny's Git Kit Deployment %_ver%
pushd %~dp0
echo  Johnny's Git Kit Deployment %_ver%
echo  https://github.com/lxvs/jg
echo;
echo ^> Please choose what to do:
echo   ^| 1     Deploy Johnny's Git Kit
echo   ^| 0     Remove Johnny's Git Kit

:choose
echo;
set /p=^> Please select a number: <NUL
set selection=
set /p selection=
if "%selection%" EQU "" goto deploy
if "%selection%" EQU "1" goto deploy
if "%selection%" EQU "0" goto remove
echo ^> Invalid input.
goto choose

:deploy
if not exist "bin" (
    echo Error: Could not find the script folder.
    goto End
)
if not exist "%userprofile%\bin\" (
    md "%userprofile%\bin\"
    echo ^> Created folder '%userprofile%\bin\'
) else call:RmDep
echo ^> Copying Johnny's Git Kit to your PC...
for /r bin\ %%f in ( jg* ) do (( copy /Y "%%f" "%userprofile%\bin\" ) || goto somethingIsWrong )
call:Fin 1
goto end

:remove
if not exist "%userprofile%\bin\" (
    echo ^> It hasn't deployed in your PC.
    goto choose
)
call:RmDep
echo ^> Removing Johnny's Git Kit from your PC...
for /r bin\ %%f in ( jg* ) do ( del /Q "%userprofile%\bin\%%~nf" 2>NUL || goto somethingIsWrong )
rd "%userprofile%\bin" 2>NUL
call:Fin 0
goto end

:Fin
echo;
if "%1" EQU "1" (
    echo ^> Deployment finished.
    echo;
    goto:eof
)
if "%1" EQU "0" (
    echo ^> Removement finished.
    goto:eof
)
echo ^> Warning 330: an unreachable place is reached with parameter '%1'.
goto:eof

:RmDep
echo;
echo ^> Removing deprecated commands...
del "%userprofile%\bin\jg" 2>NUL
del "%userprofile%\bin\jggrepcommit" 2>NUL
del "%userprofile%\bin\jgpush" 2>NUL
del "%userprofile%\bin\jgstash" 2>NUL
goto:eof

:somethingIsWrong
echo Something is wrong!
:end
pause & goto:eof
