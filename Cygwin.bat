mode con: cols=126 lines=33
@echo off
REM chcp 65001
set batF=%~n0%~x0
set batP=%~p0
set batD=%~d0
@ECHO Running %batF%
REM Simplest case - started from shortcut in GUI maybe - we are in batfile dir:
if {"%CD%"}=={"%batD%%batP:/=\%"} GOTO :InPlace

REM Not simple, so locate us.
SetLocal ENABLEDELAYEDEXPANSION
for /F %%A in ("%CD%") do @(set PD=%%~dA
  set ODIR=%%~fsA
  echo In "!ODIR!", CurVol is "!PD!", need to be on "%batD%"
)
EndLocal
if {"%PD%"}=={"%batD%"} (pushd %batP% & REM running on the drv this batfile is on already
) else ( %batD% & REM jump to drv and then chdir, saving old dir
  pushd %batP%
)

:InPlace
for /F %%D in ("%CD%") do set CWD=%%~fsD
if exist      .\bin\cygpath.exe (
set PATH=%CWD%\bin;%PATH%
set HOME=/cygdrive/c/Users/%USERNAME%/AppData/Cygwin
set PROGRAMFILES=C:/PROGRA~1
) else (
@ECHO Aborting: did not chdir into expected location. Starting dir was %ODIR%.
PAUSE
GOTO :EOF
)

:Setup
set TERM=cygwin
set CYGWIN=nodosfilewarning

if exist .\bin\perl.exe (
REM  echo executing %batD%%batP:\=/%%batF% as a perl script ...
  SetLocal
  set PERL5OPT=-m-lib=.
  for /F usebackq %%P in (`bin\perl -x %batF%`) do set CYGPERLVERSION=%%~P
  EndLocal & set CYGPERLVERSION=%CYGPERLVERSION%
)

@ECHO Executing bash
bin\bash --login -i

REM iff we started in C:\Windows\System32 then we almost certainly ran from Start Menu shortcut
REM or another shortcut, and want to terminate.
if {%ODIR%}=={C:\Windows\System32} EXIT

if not {%ODIR%}=={} (GOTO :ReturnTrip
) else (EXIT)

:ReturnTrip
@ECHO Returning to previous cwd %ODIR%
popd & %PD% & EXIT

:PerlCodeX
#!perl
# remember my env var PERL_WIN32_LEVEL
use Win32 ( qw/
      MB_ICONHAND MB_ICONQUESTION MB_ICONEXCLAMATION MB_ICONASTERISK
      MB_ICONWARNING MB_ICONERROR MB_ICONINFORMATION MB_ICONSTOP
        / );
use strict;
use warnings;
use version; print version->parse($]); exit;
__END__
GOTO :EOF
