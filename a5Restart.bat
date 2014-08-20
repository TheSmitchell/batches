REM An adaptation of Cheeso's process shared on StackOverflow

REM Original Author: Cheeso (stackoverflow.com/users/48082/cheeso)
REM Script Source: stackoverflow.com/questions/7861683/from-a-batch-file-how-can-i-wait-for-a-process-to-exit-after-calling-taskkill
REM Date Shared: October 22, 2011 @ 6:28 PM
REM Date Retrieved: Unknown; but still there on August 20, 2014

REM Modifications By: Sarah Mitchell
REM Description: Kill all running A5 Application Servers (only works if proc is named A5ApplicationServer.exe)

@ECHO OFF

SET tasklist=%windir%\System32\tasklist.exe
SET taskkill=%windir%\System32\taskkill.exe

CALL :STOPPROC A5ApplicationServer.exe

REM Start all servers again - Add a call to START for each instance of AWS you run
START "" "C:\Path\To\A5ApplicationServer.exe" -CONFIG="C:\Path\to\AWS\Instance\Config.xml"

GOTO :EOF

:STOPPROC
  SET procFound=0
  SET notFound_result=ERROR:
  SET procName=%1
  FOR /f "usebackq" %%A IN (`%taskkill% /IM %procName% /f /t`) DO (
    IF NOT %%A==%notFound_result% (set procFound=1)
  )
  IF %procFound%==0 (
    ECHO The process was not running.
    GOTO :EOF
  )
  SET wasStopped=1
  SET ignore_result=INFO:

:CHECKDEAD
  "%winddir%\system32\timeout.exe" 3 /NOBREAK
  FOR /f "usebackq" %%A IN (`%tasklist% /nh /fi "imagename eq %procName%"`) DO (
    IF NOT %%A==%ignore_result% (goto :CHECKDEAD)
  )
  EXIT /B
