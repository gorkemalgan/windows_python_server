set logfoler=%1
set logfile=%2

for /f "delims=" %%x in (params.bat) do %%x

set lastversionbat=%cd%\lastversion.bat
set mailwakepy=%cd%\mailwake.py
set mailfilepy=%cd%\mailfile.py

if not exist %logfolder% mkdir %logfolder%
if not exist %lastversionbat% (
	echo %lastversionbat% doesn't exists, creating it with 1... >> %logfile%
	echo set lastversion=1 >> %lastversionbat%
)

echo Reading last ran version >> %logfile%
for /f "delims=" %%x in (%lastversionbat%) do %%x
set newversion=1

cd %mainfolder%
if not exist %mainrelative% (
	echo %mainrelative% doesn't exists, pulling and checking out... >> %logfile%
	git pull >> %logfile%
	git checkout %mainrelative% >> %logfile%
	if exist %mainrelative% (
		echo %mainrelative% exists now... >> %logfile%
		set runflag=1
	) else (
		echo %mainrelative% still doesn't exist... >> %logfile%
		set runflag=0
		echo Shutting down the computer.. >> %logfile%
		shutdown /s
		exit
	)
)

echo %mainrelative% exists... >> %logfile%
echo Pulling %mainfolder%... >> %logfile%
git pull >> %logfile%
echo Getting current version of %mainrelative% >> %logfile%
for /f %%x in ('git rev-parse --short HEAD:./%mainrelative%') do set newversion=%%x
echo Current version of the file is %newversion%, last ran version is %lastversion% >> %logfile%
if %newversion% equ %lastversion% (
	echo No changes in %mainrelative% file... >> %logfile%
	set runflag=0
) else (
	echo There is an update... >> %logfile%
	set runflag=1
)

if %runflag% equ 1 (
	echo Update lastversion.bat >> %logfile%
	echo set lastversion=%newversion% > %lastversionbat%
	echo Sending mail for beginning of script >> %logfile%
	(echo python %mailwakepy% "Beginning to run script") | %windir%\System32\cmd.exe /K %anacondaactivate% %anacondafolder%
	echo Activating conda environment %condaenv% and running %mainrelative%... >> %logfile%
	echo. >> %logfile%
	echo ******************************************************%condaenv%****************************************************** >> %logfile%
	(echo activate %condaenv% & echo python %mainrelative%) | %windir%\System32\cmd.exe /K %anacondaactivate% %anacondafolder% >> %logfile%
	echo. >> %logfile%
	echo ******************************************************%condaenv%****************************************************** >> %logfile%
	echo Activating conda environment base and sending email >> %logfile%
	(echo python %mailfilepy% %logfile% mail\) | %windir%\System32\cmd.exe /K %anacondaactivate% %anacondafolder%
	echo. >> %logfile%
) else (
	echo Sending mail for no change >> %logfile%
	(echo python %mailwakepy% "There is no change in files") | %windir%\System32\cmd.exe /K %anacondaactivate% %anacondafolder%
	echo. >> %logfile%
)

echo Shutting down the computer.. >> %logfile%
shutdown /s