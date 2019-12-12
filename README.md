# Windows Python Server
This is the collection of batch files I used to run at my server computer to periodically run python scripts for deep learning. What it does in order is:

* Code enters from getter.bat
* If not created already creates 'logs/' folder
* Calls server.bat
* Pulls repo in %mainfolder% location (given in params.bat)
* Checks file version at %mainrelative% (given in params.bat)
* Sends email saying that computer is awake
* If there is a new commit since last run, runs the file with the given anaconda environment %condaenv% (given in params.bat)
* During this process saves all the outputs to logs/log_date_time.txt
* After the run finishes, sends the log file to 'to_mail' from 'from_mail' (given in params.py)
* Also if there is any file under %mainfolder%\email\ folder, they are attached to mail as well. You can copy needed logs, plots and all other files at the end of python script to 'mail/' folder and server.bat will send them.
* Shutdown the computer

You can create a task from windows task schedular to run getter.bat at the system startup. Then whenever system starts, computer will automatically pull the changes from the repo, run the script, sends output logs to you via email and shutdown the computer afterwards. You can set bios alarm to wake computer every midnight so that it will do all processing in the night and in the morning your logs will be ready at your email address.

killer.bat is to kill the task of running getter.bat. This is useful when you dont want your computer to run the scripts. So you can create a second task to run at logon that will run the killer.bat. Command line will ask you if you want to kill the task. Killer is required to be in a seperate batch because if you dont create a task for logon, windows will not show command line.