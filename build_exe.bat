@ECHO off
rem Builds hirviurheilu.zip file containing the exe file and the SQLite3 database file.
rem Dependencies:
rem - ocra: gem install ocra
rem - 7za.exe: http://7-zip.org/download.html (the command line version)

@ECHO on
CALL cd ..
CALL ocra elk_sports\start.rb elk_sports --no-dep-run --add-all-core --gemfile elk_sports\Gemfile --dll sqlite3.dll --output hirviurheilu.exe --icon elk_sports\public\favicon.ico -- server
CALL 7za a hirviurheilu.zip hirviurheilu.exe hirviurheilu.sqlite3
CALL cd elk_sports