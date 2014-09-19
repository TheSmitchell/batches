REM Sweep the filthy temp directory
set _tempDir="C:\Users\ADMIN~1\AppData\Local\Temp"
del "%_tempDir%\*.*" /s /q

REM Were you raised in a barn?! FFS
FOR /D %%a IN ("%_tempDir%\*.*") DO rmdir "%%a" /s /q
