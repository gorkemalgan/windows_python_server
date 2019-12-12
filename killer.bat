choice /t 60 /c yn /d y /m "Shall we kill the dlserver task?"
set choice=%errorlevel%

if %choice% equ 1 (
	echo killer is awake...
	schtasks /end /tn dlserver

	if %errorlevel% equ 0 (
		echo dlserver is killed by killer...
	) else (
		echo kill operation was unsuccessfull with error code %errorlevel%...
	)
) else (
	echo Quiting dlserverkiller task...
	exit
)