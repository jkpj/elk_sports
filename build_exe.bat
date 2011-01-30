@ECHO off
rem Builds hirviurheilu.zip file containing the exe file and the SQLite3 database file.
rem Dependencies:
rem - tar2rubyscript: https://github.com/ryanbooker/tar2rubyscript
rem - ocra: gem install ocra
rem - 7za.exe: http://7-zip.org/download.html (the command line version)

@ECHO on
CALL cd ..
CALL tar2rubyscript elk_sports
CALL ocra elk_sports.rb --add-all-core --gemfile elk_sports\Gemfile --dll sqlite3.dll --output hirviurheilu.exe --icon elk_sports\public\favicon.ico
CALL 7za a hirviurheilu.zip hirviurheilu.exe hirviurheilu.sqlite3
CALL cd elk_sports