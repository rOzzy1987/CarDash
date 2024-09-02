@ECHO OFF


ECHO Reading source file
FOR /F "tokens=1* delims=|" %%i in (devs.txt) do CALL :CREATEFILE %%i, "%%j"

GOTO :EOF

:CREATEFILE
    ECHO Creating resources for %~1

    SET outdir=..\resources-%~1
    SET output=%outdir%\strings.xml

    @MKDIR "%outdir%"
    ECHO ^<strings^> > "%output%"
    ECHO     ^<string id="ProductName"^>%~2^</string^> >> "%output%"
    ECHO ^</strings^> >> "%output%"
EXIT /B 0

:EOF