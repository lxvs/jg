@echo off
setlocal
title Johnny's Git Kit Deployment
pushd %~dp0
echo  Johnny's Git Kit Deployment
echo;
echo ^> Please choose what to do:
echo   ^| 1     Deploy Johnny's Git Kit
echo   ^| 0     Remove Johnny's Git Kit
:Choose
echo;
set /p=^> Please select a number: <NUL
set selection=
set /p selection=
if "%selection%" EQU "" goto Deploy
if "%selection%" EQU "1" goto Deploy
if "%selection%" EQU "0" goto Remove
echo ^> Invalid input.
goto Choose
:Deploy
if not exist "bin" (
    echo Error: Could not find the script folder.
    goto End
)
if not exist "%userprofile%\bin\" (
    md "%userprofile%\bin\"
    echo ^> Created folder '%userprofile%\bin\'
)
for /r bin\ %%f in ( jg* ) do (( copy /Y "%%f" "%userprofile%\bin\" ) || goto SomethingIsWrong )
call:Fin 1
goto End
:Remove
if not exist "%userprofile%\bin\" (
    echo ^> It hasn't deployed in your PC.
    goto Choose
)
for /r bin\ %%f in ( jg* ) do ( del /Q "%userprofile%\bin\%%~nf" || goto SomethingIsWrong )
rd "%userprofile%\bin" 2>NUL
call:Fin 0
goto End
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
:SomethingIsWrong
echo Something is wrong!
:End
pause & goto:eof
