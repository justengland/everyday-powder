@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"ruby.exe" "C:/Users/Justin/My Documents/Aptana Studio 3 Workspace/powder-hound/bundles/ruby/1.9.1/bin/sqlite3_ruby" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"ruby.exe" "%~dpn0" %*
