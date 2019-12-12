for /f "delims=" %%x in (params.bat) do %%x

set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%

set logfolder=%cd%\logs
set logfile=%logfolder%\log_%date:~10,13%%date:~4,2%%date:~7,2%_%hour%%min%.txt

timeout 300
if not exist %logfolder% mkdir %logfolder%

echo %time% >> %logfile%
echo Timeout is finished... >> %logfile% 
echo Pulling dlserver repo... >> %logfile%
git pull >> %logfile%
echo Running server.bat... >> %logfile%
server.bat %logfolder% %logfile%
