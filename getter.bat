for /f "delims=" %%x in (params.bat) do %%x

set logfolder=%cd%\logs
set logfile=%logfolder%\log_%date:~10,13%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%.txt

timeout 300
if not exist %logfolder% mkdir %logfolder%

echo %time% >> %logfile%
echo Timeout is finished... >> %logfile% 
echo Pulling dlserver repo... >> %logfile%
git pull
echo Running server.bat... >> %logfile%
server.bat %logfolder% %logfile%
