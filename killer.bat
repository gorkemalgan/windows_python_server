set logfolder=%cd%\logs
set logfile=%logfolder%\log_%date:~10,13%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%.txt
if not exist %logfolder% mkdir %logfolder%

choice /t 60 /c yn /d y /m "Shall we kill the dlserver task?"
set choice=%errorlevel%

if %choice% equ 1 (
	echo %time% >> %logfile%
	echo killer is awake... >> %logfile%
	schtasks /end /tn dlserver

	if %errorlevel% equ 0 (
		echo dlserver is killed by killer... >> %logfile%
	) else (
		echo kill operation was unsuccessfull with error code %errorlevel%... >> %logfile%
	)
) else (
	echo Quiting dlserverkiller task... >> %logfile%
	exit
)