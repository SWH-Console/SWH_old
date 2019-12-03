cls
@echo off
:SWH_InitFirst
echo [%date% %time%] - SWH Started in %computername% > %localappdata%\ScriptingWindowsHost\StartLog.log
set execdate=%date%
set exectime=%time%
set execdir=%cd%
set execname=%~nx0
mode con: cols=120 lines=30
set moreCMD=0
set pathswh=%localappdata%\ScriptingWindowsHost
if %os%==Windows_NT (goto startingWindowsNT)

echo Your computer don't have a NT kernel (%Windir%\System32\ntoskrnl.exe)
echo SWH is not compatible with this version of Windows
echo Would you run SWH anyways knowing this version of Windows is not compatible? (Y/N)
choice /c:NY /N
if errorlevel 2 (goto startingWindowsNT)
if errorlevel 1 (exit /B)


:startingWindowsNT
md "%localappdata%\ScriptingWindowsHost">nul
cls
md "%localappdata%\ScriptingWindowsHost\Temp"
cls
md "%AppData%\SWH"
cls
md "%AppData%\SWH\.config"
cls
md "%AppData%\SWH\ApplicationData"
cls
md "%programfiles%\SWH\.config"
cls
md "%programfiles%\SWH\ApplicationData"
cls
md "%pathswh%\OldSWH"
cls
md "%pathswh%\SWHZip"
cls

if exist "%pathswh%\D.sys" (attrib +h +s "%pathswh%\D.sys")

if exist %pathswh%\resetstartlog.opt (
	for /f "tokens=1,2* delims=," %%L in (%pathswh%\resetstartlog.opt) do (set resetstartlog_=%%L)
) else (
	set resetstartlog_=1
)

goto regYesBlockCHK
FOR /f "usebackq tokens=3*" %%A IN (`REG QUERY "HKCU\Software\ScriptingWindowsHost /v DisableSWH"`) DO (
	set SWH_RegDisabled=%%A %%B
	)
if not %SWH_RegDisabled%==1 goto regYesBlockCHK

:swhdisabledreg
title %~dpnx0 - SWH disabled by Registry
cls
echo SWH has been disabled by an administrator
echo.
echo Press any key to exit SWH...
pause>nul
exit /b

:regYesBlockCHK
if not exist "%homedrive%\Program Files\SWH\ApplicationData\BU.dat" (
	echo [%date% %time%] - BlockUsers=0 >> %pathswh%\StartLog.log
	goto checkingPassword
)

:chkblockusers
echo [%date% %time%] - BlockUsers=1 >> %pathswh%\StartLog.log
for /f "tokens=1,2* delims=," %%b in (%programfiles%\SWH\ApplicationData\BU.dat) do (set onlyusernotblock=%%b)
cls
if /i %username%==%onlyusernotblock% (goto checkingPassword)
echo.
title %~dpnx0 - SWH blocked for this user
echo Your SWH access was blocked because you not have the requested privileges to start it.
echo.
echo Press any key to exit SWH...
echo.
pause>nul
exit /b
:checkingPassword
if exist "%programfiles%\SWH\ApplicationData\PS.dat" (goto swhpassword) else (
	set psd=[{CLSID:8t4tvry4893tvy2nq4928trvyn14098vny84309tvny493q8tvn0943tyvnu0q943t8vn204vmy10vn05}]
	goto startingswhpassword
)

:swhpassword
cls
:params_slash
::Parameters receptor
if /I "%1"=="/p" (goto Params_PasswordSWH)
if exist "%programfiles%\SWH\ApplicationData\PS.dat" (goto







	)
if /I "%1"=="/?" (goto usageParams_Slash)
if /I "%1"=="/h" (goto usageParams_Slash)
if /I "%1"=="/admin" (goto runSWH_Admin)
if /I "%1"=="/c" (goto params_Command) else (goto nonexist_PARAMSWH)
:params_command
echo.
set cmd="%2"
goto other1cmd

:Params_PasswordSWH
set psd=%2

:usageParams_Slash
echo.
::Parameters help
echo Usage:
echo.
echo "%~nx0" /?    ^| Same as /h. Shows SWH parameters help
echo "%~nx0" /admin    ^| Runs SWH as administrator
echo "%~nx0" /c ^<command^>    ^| Executes a SWH command
echo "%~nx0" /h    ^| Same as /?. Shows SWH parameters help
echo "%~nx0" /p ^<password^>   ^| If the password is existent, type the password and access SWH. (Creating)
echo.
goto swh
:runSWH_Admin
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %pathswh%\Temp\AdminSWH.vbs
echo If WScript.Arguments.Length = 0 Then >> %pathswh%\Temp\AdminSWH.vbs
echo   Set ObjShell = CreateObject("Shell.Application") >> %pathswh%\Temp\AdminSWH.vbs
echo   ObjShell.ShellExecute "wscript.exe" _ >> %pathswh%\Temp\AdminSWH.vbs
echo     , """" ^& WScript.ScriptFullName ^& """ /admin", , "RunAs",1 >> %pathswh%\Temp\AdminSWH.vbs
echo   WScript.Quit >> %pathswh%\Temp\AdminSWH.vbs
echo End if >> %pathswh%\Temp\AdminSWH.vbs
echo Set ObjShell = CreateObject("WScript.Shell") >> %pathswh%\Temp\AdminSWH.vbs
echo objShell.Run "cmd.exe /c %pathswh%\SWH.bat" >> %pathswh%\Temp\AdminSWH.vbs
echo.
start wscript.exe "%pathswh%\Temp\AdminSWH.vbs"
echo.
exit
:nonexist_PARAMSWH
echo Error! Type "%~nx0" /? to get help about how to start SWH with parameters
echo.
goto swh

:putpassword
echo [%date% %time%] - Password=1 >> %pathswh%\StartLog.log
title %~dpnx0 - Enter the password to start SWH
set password=[{CLSID:5378cv5t593vyn539n58tv2598ty5btvy3y9vn53439t57y483wv95ntvy54tn9v5y4vtn58tvu8}]
set /p password=Password to start SWH: 

::Read encrypted password
cd /d "%programfiles%\SWH\ApplicationData"
if not exist "%pathswh%\Temp\PS.dat" (goto TryingRemovePSD)
for /f "tokens=1,2* delims=," %%P in (PS.dat) do (set cryptpassword=%%P) 
cd /d "%pathswh%\Temp"
goto firstPSDchk

:TryingRemovePSD
cd /d "%pathswh%\Temp"
echo %date%> "%pathswh%\Temp\D.sys"
attrib -h -s "%pathswh%\Temp\D.sys"
for /f "tokens=1,2* delims=," %%y in (D.sys) do (set dateBlock=%%y)
attrib +h +s "%pathswh%\Temp\D.sys"
cls
title %~dpnx0 - You are blocked from SWH! Reason: Trying to steal passwords.
echo You are blocked from SWH! Reason: Trying to steal passwords.
echo.
echo Why my SWH access is blocked?
echo.
echo 1) You tried to remove SWH password
echo 2) You tried to change it
echo.
echo So, no I will not able to start SWH?
echo.
echo Yes, you will be able to use SWH, but you need to wait 1 day
if not "%date%"=="%dateBlock%" (goto waitedday) else (goto infiniteLoop)
:infiniteLoop
pause>nul
goto infiniteLoop

:waitedday
attrib -h -s "%pathswh%\Temp\D.sys"
del "%pathswh%\Temp\D.sys" /q
goto SWH_InitFirst

:firstPSDchk
::Decrypt Password
if exist Decrypt.txt del Decrypt.txt /q
if exist Decrypt.vbs del Decrypt.vbs /q
echo Option Explicit > Decrypt.vbs
echo Dim temp, key, objShell >> Decrypt.vbs
echo Dim objFSO, Dcrypt >> Decrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Decrypt.vbs
echo temp = "%cryptpassword%" >> Decrypt.vbs
echo key = "4Ou8fa94pfx3WV3AsnhoAz7xWbtkA5T36SMX7sOB9I8WazaCirdOT1HfhBJBKvZlQDMRIGEH49vPK5KTDPTaIPVT8h3F57QW3RYbJ0WrT90Fxk3EBcMCz0APGZebZWkZH2JvGuFqs8mvICYG4uZW2MYnXwPmnVa8S4HCEgeQRPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4IRQ0261QCeJHPBj71LKIqGDbWBTrLBh8wPONCYVM0F4RPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4" >> Decrypt.vbs
echo temp = Decrypt(temp,key) >> Decrypt.vbs
echo Set objFSO = createobject("scripting.filesystemobject") >> Decrypt.vbs
echo Set Dcrypt = objfso.createtextfile("Decrypt.txt",true)  >> Decrypt.vbs
echo Dcrypt.writeline "" ^&temp >> Decrypt.vbs
echo Dcrypt.close >> Decrypt.vbs
echo Function encrypt(Str, key) >> Decrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str = StrReverse(str) >> Decrypt.vbs
echo  For x = 1 To LenStr >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = keypos+1 >> Decrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Decrypt.vbs
echo  Next >> Decrypt.vbs
echo  encrypt = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
echo Function Decrypt(str,key) >> Decrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str=StrReverse(str) >> Decrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = KeyPos+1 >> Decrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Decrypt.vbs
echo       Next >> Decrypt.vbs
echo       Newstr=StrReverse(Newstr) >> Decrypt.vbs
echo       Decrypt = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
start /Wait WScript.exe "%pathswh%\Temp\Decrypt.vbs"

cd /d "%pathswh%\Temp"
for /f "tokens=1,2* delims=," %%F in (Decrypt.txt) do (set DecryptPSD=%%F)
if "%password%"=="%DecryptPSD%" (goto startingswhpassword) else (goto failedpassword)>nul


set password2="%password%"


if %password2%=="%psd%" (goto startingswhpassword) else (goto failedpassword)>nul


:failedpassword
echo.
del "%pathswh%\Temp\Decrypt.txt" /q>nul
del "%pathswh%\Temp\Decrypt.vbs" /q>nul
echo Incorrect password! Press any key to try again...
echo [%date% %time%] Failed to access SWH. Reason: Incorrect Password: %password% >> %pathswh%\StartLog.log
pause>nul
cls
goto putpassword


:startingswhpassword
cd /d "%programfiles%\SWH\ApplicationData"
echo [%date% %time%] - Password=0 >> %pathswh%\StartLog.log
for /f "tokens=1,2* delims=," %%p in (PS.dat) do (set psd=%%p)
rem Help more
rem Directory %localappdata%\ScriptingWindowsHost
cd /d %pathswh%


copy %0 %pathswh%\SWH.bat>nul
set /a sizeSWHkB=%~z0/1024
set firstDirCD_=%cd%
set syspathvar=0
set cdirectory=%cd%
mode cols=120 lines=30
echo SWH_TestFileAdmin > %WinDir%\SWH_TestFileAdmin.tmp
if exist %Windir%\SWH_TestFileAdmin.tmp (
	set admin=1
	del %windir%\SWH_TestFileAdmin.tmp /q
) else (set admin=0)
set commandtoexecute=SWH: 
cls

title Starting Scripting Windows Host Console...
echo Starting Scripting Windows Host Console...

color 07
set incotext=This command does not exist. Type "help" to see the commands available
set userblock=0
set sizeverify=0
set colmodesize=0
set linemodesize=0
cd %userprofile%


cls
md SwhZip>nul
cls
md MyProjects>nul
cls
md SWH_64Bits>nul
cls
md Settings>nul
cls
title Scripting Windows Host Console
set cdirectory=%userprofile%
cd /d %localappdata%\ScriptingWindowsHost
if not exist SWH_History.txt (
	echo Creating History... > SWH_History.txt
	echo Creating History... Please wait.
)
:startswh
rem Start SWH
cd /d %localappdata%\ScriptingWindowsHost\Settings
mode con: cols=120 lines=30
if exist Size.opt (
	for /f "tokens=1,2* delims=," %%s in (Size.opt) do (mode con: %%s)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\Size.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\Size.opt >> %pathswh%\StartLog.log
)

if exist ConsoleText.opt (
	for /f "tokens=1,2* delims=," %%c in (ConsoleText.opt) do (set commandtoexecute=%%c)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\ConsoleText.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\ConsoleText.opt >> %pathswh%\StartLog.log
)

if exist DefaultTitle.opt (
	for /f "tokens=1,2* delims=," %%t in (DefaultTitle.opt) do (set title=%%t &title %title%)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\DefaultTitle.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\DefaultTitle.opt >> %pathswh%\StartLog.log
	set title=%title%
)

if exist DefaultDirectory.opt (
	for /f "tokens=1,2* delims=," %%d in (DefaultDirectory.opt) do (cd /d %%d &set cdirectory=%%d)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\DefaultDirectory.opt >> %pathswh%\StartLog.log
	set cdirectory=%%d
) else (
	set cdirectory=%userprofile%
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\DefaultDirectory.opt >> %pathswh%\StartLog.log
)

if exist IncorrectCommand.opt (
	for /f "tokens=1,2* delims=," %%e in (IncorrectCommand.opt) do (set incotext=%%e)
	echo [%date% %time%] - Loaded Setting: %pathswh%\Settings\IncorrectCommand.opt >> %pathswh%\StartLog.log
) else (
	echo [%date% %time%] - Unexistant Setting: %pathswh%\Settings\IncorrectCommand.opt >> %pathswh%\StartLog.log
)
set cmd=Enter{VD-FF24F4FV54F-TW5THW5-4Y5Y-245UNW-54NYUW}
set ver=10.2.2
set securever=%ver%
cls
cd /d %cdirectory%
if not "%1"=="" (goto params_slash)
echo [%date% %time%] - SWH: Running SWH on user %username% in directory %~dp0 >> %pathswh%\StartLog.log
echo Welcome to the Scripting Windows Host Console. %xdiskcomp%
echo.
set /p cmd=%cd% %commandtoexecute%
set cmd2=%cmd%
set cmd="%cmd2%"
goto other1cmd

:cmdhelp
rem Help command More
echo. > %pathswh%\Temp\MoreHelp 
echo Commands: >> %pathswh%\Temp\MoreHelp
echo.>> %pathswh%\Temp\MoreHelp
echo base64decode: Encodes a string or a file using Base64 >> %pathswh%\Temp\MoreHelp
echo base64encode: Decodes a string or a file using Base64  >> %pathswh%\Temp\MoreHelp >> %pathswh%\Temp\MoreHelp
echo blockusers: Blocks SWH if the user is not "%username%" >> %pathswh%\Temp\MoreHelp
echo bootmode: Starts SWH with compatibility with X: drive (No recomended for normal use) >> %pathswh%\Temp\MoreHelp
echo bugs: Can see the bugs of SWH >> %pathswh%\Temp\MoreHelp
echo calc (or calculator): Starts SWH calculator >> %pathswh%\Temp\MoreHelp
echo cancelshutdown: Cancels the programmed shutdown >> %pathswh%\Temp\MoreHelp
echo cd: Go to a specific directory >> %pathswh%\Temp\MoreHelp
echo clear: Clears the screen of SWH >> %pathswh%\Temp\MoreHelp
echo clearhistory: Clears the SWH command history >> %pathswh%\Temp\MoreHelp
echo cleartemp: Clears the temporary files of your computer in %tmp% >> %pathswh%\Temp\MoreHelp
echo clearwintemp: Clears the Windows temporary files in %Systemroot%\Temp >> %pathswh%\Temp\MoreHelp
echo clipboard: Copies a text in the clipboard >> %pathswh%\Temp\MoreHelp
echo cmd: Starts Command Prompt in the current directory >> %pathswh%\Temp\MoreHelp
echo command: Starts MS-DOS command prompt (command.com) >> %pathswh%\Temp\MoreHelp
echo contact: Shows the contact information >> %pathswh%\Temp\MoreHelp
echo copy: Copies files of the computer >> %pathswh%\Temp\MoreHelp
echo credits: Shows the credits of SWH >> %pathswh%\Temp\MoreHelp
echo date: Changes the date of the computer >> %pathswh%\Temp\MoreHelp
echo del: Removes a file >> %pathswh%\Temp\MoreHelp
echo dir (or directory): Shows the current directory >> %pathswh%\Temp\MoreHelp
echo encrypttext: Encrypts a text >> %pathswh%\Temp\MoreHelp
echo endtask: Finish an active process >> %pathswh%\Temp\MoreHelp
echo execinfo: Shows the information of the execution of SWH >> %pathswh%\Temp\MoreHelp
echo execute (or exec): Starts a file of the computer >> %pathswh%\Temp\MoreHelp
echo faq: Shows the frequent asked questions list >> %pathswh%\Temp\MoreHelp
echo file: Creates a file >> %pathswh%\Temp\MoreHelp
echo folder: Makes a directory >> %pathswh%\Temp\MoreHelp
echo help: Shows this help message >> %pathswh%\Temp\MoreHelp
echo history: Views the commands history >> %pathswh%\Temp\MoreHelp
echo ipconfig: Shows the IP and his configuration >> %pathswh%\Temp\MoreHelp
echo more: Makes a pause in a long text every time the page ends >> %pathswh%\Temp\MoreHelp
echo msg: Makes a message box on the screen >> %pathswh%\Temp\MoreHelp
echo networkconnections: Shows the network connections >> %pathswh%\Temp\MoreHelp
echo path: Changes the actual path of SWH >> %pathswh%\Temp\MoreHelp
echo powershell: Starts Windows PowerShell in the current directory >> %pathswh%\Temp\MoreHelp
echo project: Makes a programmation script with Scripting Windows Host (Coming soon) >> %pathswh%\Temp\MoreHelp
echo prompt: Changes the text of the SWH command line >> %pathswh%\Temp\MoreHelp
echo read: Shows the text of a file >> %pathswh%\Temp\MoreHelp
echo removefolder: Removes an existing folder (empty) >> %pathswh%\Temp\MoreHelp
echo removepassword: Removes the actual password >> %pathswh%\Temp\MoreHelp
echo rename: Renames a file or a folder >> %pathswh%\Temp\MoreHelp
echo resetsettings: Resets the actual settings >> %pathswh%\Temp\MoreHelp
echo resetstartlog: Resets the start log each time SWH starts >> %pathswh%\Temp\MoreHelp
echo restartswh: Restarts SWH >> %pathswh%\Temp\MoreHelp
echo run: Runs a program, file or Internet ressource >> %pathswh%\Temp\MoreHelp
echo say: Says a text in SWH Console >> %pathswh%\Temp\MoreHelp
echo search: Searchs a file or a folder >> %pathswh%\Temp\MoreHelp
echo setpassword: Sets a password for SWH Console >> %pathswh%\Temp\MoreHelp
echo setup: Starts SWH Setup (Install/Uninstall) >> %pathswh%\Temp\MoreHelp
echo size: Changes the size of SWH Console >> %pathswh%\Temp\MoreHelp
echo shutdown: Shuts down the computer >> %pathswh%\Temp\MoreHelp
echo swh: Starts a new session of Scripting Windows Host Console >> %pathswh%\Temp\MoreHelp
echo swhadmin: Runs SWH as administrator >> %pathswh%\Temp\MoreHelp
echo swhdiskcleaner: Starts SWH Disk Cleaner >> %pathswh%\Temp\MoreHelp
echo swhzip: Starts SWHZip (SWH File compressor) >> %pathswh%\Temp\MoreHelp
echo systeminfo: Shows the system information >> %pathswh%\Temp\MoreHelp
echo tasklist: Shows active processes >> %pathswh%\Temp\MoreHelp
echo taskmgr: Opens Task Manager >> %pathswh%\Temp\MoreHelp
echo t-rex: Starts T-Rex game >> %pathswh%\Temp\MoreHelp
echo updateswh: Shows SWH Updates >> %pathswh%\Temp\MoreHelp
echo userinfo: Shows the information of a user >> %pathswh%\Temp\MoreHelp
echo version (or ver): Shows the version of SWH >> %pathswh%\Temp\MoreHelp
echo viewstartlog: Shows the start SWH log file >> %pathswh%\Temp\MoreHelp
echo voice: Makes a voice >> %pathswh%\Temp\MoreHelp
echo widedir: Shows the current directory in wide mode. >> %pathswh%\Temp\MoreHelp
echo winver: Shows the Windows Version >> %pathswh%\Temp\MoreHelp
echo. >> %pathswh%\Temp\MoreHelp
echo Press any key to continue... >> %pathswh%\Temp\MoreHelp

if %moreCMD%==1 (goto moreHelp) else (goto normalHelp)
:morehelp
more /E %pathswh%\Temp\MoreHelp
pause>nul
echo.
goto swh


:normalHelp
echo.
echo help >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
rem Help command
echo Commands:
echo.
echo base64decode: Encodes a string or a file using Base64
echo base64encode: Decodes a string or a file using Base64
echo blockusers: Blocks SWH if the user is not "%username%"
echo bootmode: Starts SWH with compatibility with X: drive (No recomended for normal use)
echo bugs: Can see the bugs of SWH
echo calc (or calculator): Starts SWH calculator
echo cancelshutdown: Cancels the scheduled shutdown
echo cd: Go to a specific directory
echo clear: Clears the screen of SWH
echo clearhistory: Clears the SWH command history
echo cleartemp: Clears the temporary files of your computer in %tmp%
echo clearwintemp: Clears the Windows temporary files in %Systemroot%\Temp
echo clipboard: Copies a text in the clipboard
echo cmd: Starts Command Prompt in the current directory
echo command: Starts MS-DOS command prompt (command.com)
echo contact: Shows the contact information
echo copy: Copies files of the computer
echo credits: Shows the credits of SWH
echo date: Changes the date of the computer
echo del: Removes a file
echo dir (or directory): Shows the current directory
echo encrypttext: Encrypts a text
echo endtask: Finish an active process
echo execinfo: Shows the information of the execution of SWH
echo execute (or exec): Starts a file of the computer
echo faq: Shows the frequent asked questions list
echo file: Creates a file
echo firmware: Enters the computer firmware (UEFI/BIOS)
echo folder: Makes a directory
echo help: Shows this help message
echo history: Views the commands history
echo ipconfig: Shows the IP and his configuration
echo more: Makes a pause in a long text every time the page ends
echo msg: Makes a message box on the screen
echo networkconnections: Shows the network connections
echo news: Shows the news of SWH %ver%
echo path: Changes the actual path of SWH
echo powershell: Starts Windows PowerShell in the current directory
echo project: Makes a programmation script with Scripting Windows Host (Coming soon)
echo prompt: Changes the text of the SWH command line
echo read: Shows the text of a file
echo removefolder: Removes an existing folder (empty)
echo removepassword: Removes the actual password
echo rename: Renames a file or a folder
echo resetsettings: Resets the actual settings
echo resetstartlog: Resets the start log each time SWH starts
echo restartswh: Restarts SWH
echo run: Runs a program, file or Internet ressource
echo say: Says a text in SWH Console
echo search: Searchs a file or a folder
echo setpassword: Sets a password for SWH Console
echo setup: Starts SWH Setup (Install/Uninstall)
echo size: Changes the size of SWH Console
echo shutdown: Shuts down the computer
echo swh: Starts a new session of Scripting Windows Host Console
echo swhadmin: Runs SWH as administrator
echo swhdiskcleaner: Starts SWH Disk Cleaner
echo swhzip: Starts SWHZip (SWH File compressor)
echo systeminfo: Shows the system information
echo tasklist: Shows active processes
echo taskmgr: Opens Task Manager
echo t-rex: Starts T-Rex game
echo updateswh: Shows SWH Updates
echo userinfo: Shows the information of a user
echo version (or ver): Shows the version of SWH
echo viewstartlog: Shows the start SWH log file
echo voice: Makes a voice
echo widedir: Shows the current directory in wide mode.
echo winver: Shows the Windows Version
echo.
echo Press any key to continue...
pause>nul
echo.
goto swh

:helpproject
echo HelpProject >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
echo How to create your own project:
echo.
echo To create a project, type "project" on the Scripting Windows Host Console.
echo The commands are writting in Scripting Windows Host, but it transforms it to other languages
echo To exit the project maker, type "exitproject" on project maker
echo.
goto swh

:other1cmd
rem "" antibug
if /i %cmd%=="help" (goto cmdhelp)
if /i %cmd%=="Enter{VD-FF24F4FV54F-TW5THW5-4Y5Y-245UNW-54NYUW}" (
	echo Enter >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
)
if /i %cmd%=="execute" (goto start)
if /i %cmd%=="exec" (goto start)
if /i %cmd%=="folder" (goto mkdir)
if /i %cmd%=="shutdown" (goto shutdown)
if /i %cmd%=="cd" (goto cd)
if /i %cmd%=="title" (goto title)
if /i %cmd%=="file" (goto file)
if /i %cmd%=="cls" (goto cls)
if /i %cmd%=="clear" (goto cls)
if /i %cmd%=="del" (goto del)
if /i %cmd%=="color" (goto color)
if /i %cmd%=="endtask" (goto taskkill)
if /i %cmd%=="tasklist" (goto tasklist)
if /i %cmd%=="taskmgr" (goto taskmgr)
if /i %cmd%=="removefolder" (goto rfolder)
if /i %cmd%=="exit" (cd\&echo.&echo Exiting SWH...&cd /d "%cdirectory%"&exit /b)
if /i %cmd%=="copy" (goto copyfiles)
if /i %cmd%=="cmd" (goto cmdscreen)
if /i %cmd%=="swh" (goto startswh)
if /i %cmd%=="msg" (goto msgbox)
if /i %cmd%=="date" (goto chdate)
if /i %cmd%=="time" (goto chtime)
if /i %cmd%=="say" (goto echosay)
if /i %cmd%=="credits" (goto credits)
if /i %cmd%=="directory" (goto dir)
if /i %cmd%=="dir" (goto dir)
if /i %cmd%=="cancelshutdown" (goto cancelshutdown)
if /i %cmd%=="rename" (goto rename)
if /i %cmd%=="history" (goto history)
if /i %cmd%=="clearhistory" (goto clearhistory)
if /i %cmd%=="calc" (goto calc)
if /i %cmd%=="calculator" (goto calc)
if /i %cmd%=="size" (goto consize)
if /i %cmd%=="project" (goto scriptproject)
if /i %cmd%=="helpproject"(goto HelpProject2)
if /i %cmd%=="voice" (goto voice)
if /i %cmd%=="networkconnections" (goto networkconnections)
if /i %cmd%=="prompt" (goto consoleinput)
if /i %cmd%=="t-rex" (goto trexgame)
if /i %cmd%=="search" (goto searchfiles)
if /i %cmd%=="powershell" (goto PowerShell)
if /i %cmd%=="url" (goto url)
if /i %cmd%=="systemconfig" (goto bootconfig)
if /i %cmd%=="variable" (goto variable)
if /i %cmd%=="swhvariables" (goto swhvariables)
if /i %cmd%=="vol" (goto vol)
if /i %cmd%=="settings" (goto settings)
if /i %cmd%=="run" (goto SWHrunDialog)
rem "not swh" antibug
if /i %cmd%=="""not swh""" (goto incommand)
if /i %cmd%=="swhzip" (goto swhzip)
if /i %cmd%=="helpsettings" (goto hsettings)
if /i %cmd%=="ipconfig" (goto ipconfig)
if /i %cmd%=="random" (goto randomnumber)
if /i %cmd%=="resetsettings" (goto resetsettings)
if /i %cmd%=="systeminfo" (goto SysInfo)
if /i %cmd%=="restartswh" (goto abstartswh)
if /i %cmd%=="path" (goto chPath)
if /i %cmd%=="faq" (goto FAQ)
if /i %cmd%=="systempath" (goto Syspath)
if /i %cmd%=="command" (goto commandCom)
if /i %cmd%=="execinfo" (goto execinfo)
if /i %cmd%=="cd.." (goto cdBack)
if /i %cmd%=="cd\" (goto cdDisk)
if /i %cmd%=="clearwintemp" (goto clsWinTMP)
if /i %cmd%=="cleartemp" (goto clsTemp)
if /i %cmd%=="swhdiskcleaner" (goto SWHdiskCleaner)
if /i %cmd%=="encrypttext" (goto encrypttext)
if /i %cmd%=="updateswh" (goto updateswh)
if /i %cmd%=="more" (goto moreWalk)
if /i %cmd%=="read" (goto read)
if /i %cmd%=="ver" (goto swhver)
if /i %cmd%=="version" (goto swhver)
if /i %cmd%=="setpassword" (goto setpassword)
if /i %cmd%=="removepassword" (goto removepassword)
if /i %cmd%=="blockusers" (goto accessonlyuser)
if /i %cmd%=="winver" (goto winver)
if /i %cmd%=="clipboard" (goto cmdClip)
if /i %cmd%=="decrypttext" (goto decrypttext)
if /i %cmd%=="userinfo" (goto userinfo)
if /i %cmd%=="viewstartlog" (goto viewstartlog)
if /i %cmd%=="resetstartlog" (goto resetstartlog)
if /i %cmd%=="bootmode" (goto xdiskbootask)
if /i %cmd%=="widedir" (goto widedir)
if /i %cmd%=="firmware" (goto firmwareaccess)
if /i %cmd%=="news" (goto newsSWH)
if /i %cmd%=="setup" (goto startSetup)
if /i %cmd%=="base64encode" (goto base64encode)
if /i %cmd%=="base64decode" (goto base64decode)
if /i %cmd%=="contact" (goto swhcontact)
if /I %cmd%=="swhadmin" (goto swh_admin)
if /i %cmd%=="bugs" (goto bugs) else (goto incommand)

:swh
set cmd=Enter{VD-FF24F4FV54F-TW5THW5-4Y5Y-245UNW-54NYUW}
echo SWH:Automatic >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
set /p cmd=%cd% %commandtoexecute%
set cmd2=%cmd%
set cmd="%cmd2%"
if %cmd%=="help" (goto cmdhelp) else (goto other1cmd)


:foundedpassword_gotoswh
if "%psd%"=="[{CLSID:8t4tvry4893tvy2nq4928trvyn14098vny84309tvny493q8tvn0943tyvnu0q943t8vn204vmy10vn05}]"
set /p enterpassword_gotoswh=Enter SWH password please: 
goto swh

:resetstartlog

if %resetstartlog_%==1 (
	if exist %pathswh%\resetstartlog.opt del %pathswh%\resetstartlog.opt /q
	echo 0 > %pathswh%\resetstartlog.opt
	echo Each time that SWH starts the log file will not be cleared
	echo.
	goto swh
)
if %resetstartlog_%==0 (
	if exist %pathswh%\resetstartlog.opt del %pathswh%\resetstartlog.opt /q
	echo 1 > %pathswh%\resetstartlog.opt
	echo Each time that SWH starts the log file will be cleared.
	echo.
	goto swh
)


:swh_admin
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %pathswh%\Temp\AdminSWH.vbs
echo If WScript.Arguments.Length = 0 Then >> %pathswh%\Temp\AdminSWH.vbs
echo   Set ObjShell = CreateObject("Shell.Application") >> %pathswh%\Temp\AdminSWH.vbs
echo   ObjShell.ShellExecute "wscript.exe" _ >> %pathswh%\Temp\AdminSWH.vbs
echo     , """" ^& WScript.ScriptFullName ^& """ /admin", , "RunAs",1 >> %pathswh%\Temp\AdminSWH.vbs
echo   WScript.Quit >> %pathswh%\Temp\AdminSWH.vbs
echo End if >> %pathswh%\Temp\AdminSWH.vbs
echo Set ObjShell = CreateObject("WScript.Shell") >> %pathswh%\Temp\AdminSWH.vbs
echo objShell.Run "cmd.exe /c %pathswh%\SWH.bat" >> %pathswh%\Temp\AdminSWH.vbs
echo.
start WScript.exe "%pathswh%\Temp\AdminSWH.vbs"
goto swh




:swhcontact
echo.
echo E-Mail to contact with SWH developper (anic17)
echo.
echo SWH.Console@gmail.com
echo.
echo Contact >> %pathswh%\SWH_History.txt
goto swh



:viewstartlog
echo.
type %pathswh%\StartLog.log
echo.
goto swh


:newsSWH
echo.
echo What's new on SWH %ver%?
echo.
echo Guaranteed decryption system:
echo Now the text decryptor works correctly, so encrypted data is guaranteed that you can decrypt it.
echo.
echo Encrypted password:
echo In previous versions, the password was visible in his password file.
echo Now it is encrypted, making SWH access only for people that know the password
echo.
echo More functions, less size:
echo SWH %ver% tries to be more accessible with only %sizeSWHkB% kB, and with a lot of functions.
echo.
echo Added slash parameters:
echo Now you can run SWH with parameters like %~nx0 /admin or %~nx0 /c ^<command^>
echo This is very useful to automatize tasks
echo.
goto swh


:base64decode
echo.
echo Note: A invalid string will not be decoded, this function needs Windows PowerShell
echo.
echo Base64 Decoder: Decoding "U1dI" will be "SWH"
echo.
set /p base64decode=String to decode in Base64: 

cd /d %pathswh%\Temp

powershell "[Text.Encoding]::UTF8.GetString([convert]::FromBase64String(\"%base64decode%\"))" > "%pathswh%\Temp\DecodedBase64.txt"
type "%pathswh%\Temp\DecodedBase64.txt"
for /f "tokens=1,2* delims=," %%f in (DecodedBase64.txt) do (set decodedStringBase64=%%f)
echo.
set /p clipbase64decode=Copy decoded text to the clipboard? (y/n): 
if /i "%clipbase64decode%"=="y" (goto clipbase64decodeG) else (goto afterClipBase64Decode)
:clipbase64decodeG
clip < DecodedBase64.txt
:afterClipBase64Decode
echo Decoded "%base64decode%" to "%decodedStringBase64%"
echo.
cd /d "%cdirectory%"
goto swh

:base64encode
echo.
echo Note: This function needs Windows PowerShell
echo.
echo Base64 Encoder: Encoding "SWH" will be "U1dI"
echo.
set /p base64encode=String to encode in Base64: 
cd /d %pathswh%\Temp
powershell "[convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes(\"%base64encode%\"))" > "%pathswh%\Temp\EncodedBase64.txt"
type "%pathswh%\Temp\EncodedBase64.txt"
for /f "tokens=1,2* delims=," %%q in (EncodedBase64.txt) do (set encodedStringBase64=%%q)
echo.
set /p clipbase64encode=Copy encoded text to the clipboard? (y/n): 
if /i "%clipbase64encode%"=="y" (goto clipbase64encodeG) else (goto afterClipBase64Encode)
:clipbase64encodeG
clip < EncodedBase64.txt
:afterClipBase64Encode
echo Encoded "%base64encode%" to "%encodedStringBase64%"
echo.
cd /d "%cdirectory%"
goto swh










:startSetup
if %admin%==0 (goto erroradminsetup) else goto InstallingSetup

:erroradminsetup
echo erroradmin=Msgbox("Please run SWH Setup as administrator",4112,"Please run SWH Setup as administrator") > "%tmp%\erroradmin.vbs"
start /wait wscript.exe "%tmp%\erroradmin.vbs"
del "%tmp%\erroradmin.vbs" /q
echo.
echo Please run SWH as administrator to start setup
echo.
cd /d %cdirectory%
goto swh


:InstallingSetup
if exist "%tmp%\cancelswh.tmp" (del "%tmp%\cancelswh.tmp" /q)
set nx=%~nx0
set dp=%~dp0
set route=%tmp%
cd /d %route%
if exist Setup.vbs (del Setup.vbs /q)
rem Scripting Windows Host Setup
rem Made by anic17
rem Copyright 2019 SWH 
set swhPath=%localappdata%\ScriptingWindowsHost
set dir=%~dp0
title Scripting Windows Host Installer
echo SWH_TestFileAdmin > %windir%\SWH_TestFileAdmin.tmp
if not exist %windir%\SWH_TestFileAdmin.tmp (goto erroradmin) else (del %windir%\SWH_TestFileAdmin.tmp /q /f)
if exist %localappdata%\ScriptingWindowsHost\SWH.* (goto uninstall)
if exist %userprofile%\Downloads\SWH.* (goto install) else (goto ErrorExtracting)

:install
cd /d %tmp%
rem License
echo Scripting Windows Host license: > "%tmp%\license.txt"
echo. >> "%tmp%\license.txt"
echo. >> "%tmp%\license.txt"
echo To install SWH, you must agree terms of service of SWH >> "%tmp%\license.txt"
echo. >> "%tmp%\license.txt"
echo Terms of service: >> "%tmp%\license.txt"
echo. >> "%tmp%\license.txt"
echo SWH is a  >> "%tmp%\license.txt"
echo . >> "%tmp%\license.txt"
echo SWH is a console. A console is a program that you type commands and it executes it. >> "%tmp%\license.txt"
echo But SWH is a console that it makes programming easier that never! >> "%tmp%\license.txt"
echo. >> "%tmp%\license.txt"
echo If you need help when you have installed SWH, please type "help" on SWH >> "%tmp%\license.txt"
echo. >> "%tmp%\license.txt"
echo Copyright (c) 2019 anic17. All rights reserved >> "%tmp%\license.txt"
rem End license

rem Cancel button
echo taskkill /f /im wscript.exe > "%tmp%\RestartSWHSetup.bat"
echo start wscript.exe "%tmp%\Setup.vbs" >> "%tmp%\RestartSWHSetup.bat"
echo exit >> "%tmp%\RestartSWHSetup.bat"


rem Setup Starts
rem Setup.vbs

echo strScriptHost = LCase(Wscript.FullName) > Setup.vbs
echo If Right(strScriptHost, 11) = "cscript.exe" Then >> Setup.vbs
echo 	cscript=msgbox("Please run SWH Setup with wscript.exe",4112,"Please run SWH Setup with wscript.exe") >> Setup.vbs
echo 	CScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo setupfirst=msgbox("Welcome to the Scripting Windows Host setup. This wizard will install SWH on your computer. Click OK to install SWH.",4353,"Scripting Windows Host Setup") >> Setup.vbs
echo if setupfirst = vbCancel then >> Setup.vbs
echo 	cancelFirstSetup=msgbox("Are you sure you want to close SWH Setup?",4148,"Close SWH Setup?") >> Setup.vbs
echo 	if cancelFirstSetup = vbYes Then >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 		objShell.Run "taskkill.exe /f /im Wscript.exe" >> Setup.vbs
echo 	End If >> Setup.vbs
echo 	If cancelFirstSetup = vbNo Then >> Setup.vbs
echo 		Set objFSO = createobject("scripting.filesystemobject")  >> Setup.vbs
echo 		Set exitYN = objfso.createtextfile("cancelswh.tmp",true) >> Setup.vbs  
echo 		exitYN.writeline "Cancel=0" >> Setup.vbs
echo 		exitYN.close >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 		objShell.Run "taskkill.exe /f /im Wscript.exe"  >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 		objShell.Run "cmd.exe /c del %tmp%\cancelswh.tmp /q" >> Setup.vbs
echo 		objShell.Run "taskkill.exe /f /im wscript.exe" >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs


echo startlic=Msgbox("Please read carefully the license",4096,"Please read carefully the license") >> Setup.vbs
echo If startlic = vbOK then objShell.Run "cmd.exe /c start notepad.exe %tmp%\license.txt" >> Setup.vbs
echo license=Msgbox("To install SWH you must agree the license. By clicking OK you agree the terms of condition",4353,"By clicking OK you agree terms of condition") >> Setup.vbs
echo if license = vbCancel Then >> Setup.vbs
echo 	objShell.Run "taskkill.exe /im notepad.exe" >> Setup.vbs
echo 	nolic=Msgbox("You must to accept the license to install SWH",4112,"You need to accept the license to install SWH") >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo 	objShell.Run "taskkill.exe /f /im WScript.exe" >> Setup.vbs
echo End If >> Setup.vbs
echo installing=Msgbox("Click OK to install SWH in your computer.                                               The program will be installed in :                                                                %localappdata%\ScriptingWindowsHost",4097,"Click OK to install SWH") >> Setup.vbs
echo if installing = vbOK Then >> Setup.vbs
echo 	objShell.Run "reg.exe add HKCU\Software\ScriptingWindowsHost" >> Setup.vbs
echo 	objShell.Run "reg.exe add HKCU\Software\ScriptingWindowsHost /v DisableSWH /t REG_DWORD /d 0 /f" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %localappdata%\ScriptingWindowsHost" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %localappdata%\ScriptingWindowsHost\Settings" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %localappdata%\ScriptingWindowsHost\SwhZip" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %localappdata%\ScriptingWindowsHost\MyProjects" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %localappdata%\ScriptingWindowsHost\Temp" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c mkdir %tmp%\SWH_Setup" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c xcopy %~0 %tmp%\SWH_Setup /o /x /k /q /y" >> Setup.vbs >> Setup.vbs
echo 	objShell.Run "cmd.exe /c xcopy %userprofile%\Downloads\*SWH*.* %localappdata%\ScriptingWindowsHost /o /x /k /q /y" >> Setup.vbs
echo 	objShell.Run "cmd.exe /c xcopy %0 %localappdata%\ScriptingWindowsHost\SWH.bat /o /x /k /q /y" >> Setup.vbsecho 	finish=MsgBox("SWH was succefully installed on your computer",4160,"SWH was succefully installed on your computer") >> Setup.vbs
echo 	launch=MsgBox("Launch SWH",4132,"Launch SWH") >> Setup.vbs
echo 	if launch = vbYes Then >> Setup.vbs
echo 		objShell.Run "cmd.exe /c %localappdata%\ScriptingWindowsHost\SWH" >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 		objShell.Run "taskkill /f /im Wscript.exe" >> Setup.vbs
echo 	Else >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 		objShell.Run "taskkill /f /im wscript.exe" >> Setup.vbs
echo 	End If >> Setup.vbs
echo End if >> Setup.vbs

rem Clean Temporary SWH files
:startSetupVBS
start /wait wscript.exe Setup.vbs
taskkill /im notepad.exe
if exist "%tmp%\cancelswh.tmp" (
	del "%tmp%\cancelswh.tmp" /q
	goto startSetupVBS
)
del %tmp%\Setup.vbs /q
del %tmp%\license.txt /q
echo.
cd /d %cdirectory%
goto swh

:ErrorExtracting
echo error=MsgBox("Please extract SWH in directory %userprofile%\Downloads",4112,"Please extract SWH in directory %userprofile%\Downloads") > %tmp%\ErrorExtracting.vbs
start /wait wscript.exe "%tmp%\ErrorExtracting.vbs"
echo.
goto swh


:uninstall
rem SWH is already installed.
rem Uninstall?

echo strScriptHost = LCase(Wscript.FullName) > Setup.vbs
echo If Right(strScriptHost, 11) = "cscript.exe" Then >> Setup.vbs
echo 	cscript=msgbox("Please run SWH Setup with wscript.exe",4112,"Please run SWH Setup with wscript.exe") >> Setup.vbs
echo 	CScript.Quit >> Setup.vbs
echo End If >> Setup.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Setup.vbs
echo already=msgbox("SWH is already installed in your computer. Do you want to uninstall it?",4388,"SWH is already installed. Uninstall?") >> Setup.vbs
echo if already = vbNo Then >> Setup.vbs
echo 	WScript.Quit >> Setup.vbs
echo 	objShell.Run "taskkill.exe /f /im wscript.exe" >> Setup.vbs
echo Else >> Setup.vbs
echo 	sureunins=msgbox("Are you sure you want to uninstall SWH?",4388,"Are you sure you want to uninstall SWH?") >> Setup.vbs
echo 		if sureunins = vbYes Then >> Setup.vbs
echo 		objShell.Run "cmd.exe /c rd %localappdata%\ScriptingWindowsHost /s /q" >> Setup.vbs
echo 		objShell.Run "reg.exe delete HKCU\Software\ScriptingWindowsHost /va /f" >> Setup.vbs
echo 		unins=msgbox("SWH was succefully removed from your computer",4160,"SWH was succefully removed from your computer") >> Setup.vbs
echo 		WScript.Quit >> Setup.vbs
echo 		objShell.Run "taskkill.exe /f /im wscript.exe" >> Setup.vbs
echo 	End If >> Setup.vbs
echo End If >> Setup.vbs
start /wait wscript.exe Setup.vbs
del Setup.vbs /q
echo.
cd /d %cdirectory%
title %title%
goto swh
















:widedir
dir /w
echo.
goto swh

:xdiskbootask
choice /c:NY /m "Are you sure you want to start SWH in boot mode? (y/n)" /n
if errorlevel 2 goto xdiskboot 
if errorlevel 1 echo.&goto swh


:xdiskboot
echo Starting SWH with X: drive compatibility...
echo.
set /p localdisk=Letter of the disk where Windows is installed (Ex: C): 
set localdisk2=%localdisk%:
set /p localappdataboot=Location of directory %localappdata%: 
set /p surelocalappdata=Make sure that %localappdataboot% is the correct name. To continue, type Y. To change, type N: 
if /i %surelocalappdata%==y (
	:startingbootmode
	set localappdata=%localappdataboot%
	set pathswh=%localappdata%\ScriptingWindowsHost
	mkdir %pathswh%>nul
	mkdir %pathswh%\Settings>nul
	mkdir %pathswh%\Temp>nul
	echo. > %pathswh%\SWH_History.txt
	echo SWH was configured to run on boot mode
	set xdiskcomp=(Disk compatibility)
	pause>nul
	echo.
	goto startswh
) else (
	set /p correctlocalappdatanamebootask=Correct name of %localappdataboot%: 
	goto surecorrectlocalappdata
)


:surecorrectlocalappdata
set /p correctlocalappdatanameboot=This time %localappdata% is %correctlocalappdatanamebootask%? (y/n): 
if /i %correctlocalappdatanameboot%==y (goto startingbootmode) else (
	echo You will be changed to SWH (Normal mode)
	echo.
	goto swh
)


echo.
goto swh

:firmwareaccess
if %admin%==0 (goto errornotadminBIOS)
set /p sureenterbios=Are you sure do you want to enter computer firmware? The computer will be restarted (y/n): 
set sureenterbios2="%sureenterbios%"
if /i %sureenterbios2%=="y" (goto enteringBIOS) else (
	echo.
	goto swh
)
:enteringBIOS
echo Entering computer firmware... (UEFI/BIOS)
shutdown -r -t 0 -fw
echo.
goto swh

:errornotadminBIOS
echo swh=msgbox("To access computer firmware you will need administrator privileges",4112,"Access denied. Run SWH as administrator") > %pathswh%\Temp\FW_ErrorAdmin.vbs
start /wait wscript.exe "%pathswh%\Temp\FW_ErrorAdmin.vbs"
echo.
goto swh

:userinfo
set /p userinfo_=User that you would to have his information: 
net user %userinfo_%
echo.
goto swh

:incommand
echo Incorrect command: %cmd% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd\
echo %incotext%
echo.
cd /d "%cdirectory%"
goto swh

:cmdClip
set /p texttclip=Text to copy in the clipboard: 
cd\
echo %texttclip% | clip
cd /d "%cdirectory%"
echo.
echo %texttclip% copied to the clipboard
echo.
goto swh

:winver
ver
cd\
echo.
cd /d "%cdirectory%"
goto swh

:accessonlyuser
if %admin%==0 (
	echo.
	echo Please run blockusers as administrator
	echo.
	goto swh
)
echo.
if %userblock%==0 (
	set %userblock%=1
	goto blockusers
)
if %userblock%==1 (
	set userblock=0
	goto unblockusers
)
:blockusers
set /p userblock=Are you sure you want to block SWH for all users except "%username%"? (y/n): 
if /i %userblock%==y (
	echo %username%> %programfiles%\SWH\ApplicationData\BU.dat
	echo All users except "%username%" has been blocked
	echo.
	goto swh
) else (
	echo.
	goto swh
)

:unblockusers
set /p userunblock=Are you sure you want to unblock SWH for all users? (y/n): 
if /i %userunblock%==y (
	del %programfiles%\SWH\ApplicationData\BU.dat /q
	echo All users has been unblocked
	echo.
	goto swh
) else (
	echo.
	goto swh
)


:setpassword
if %admin%==0 goto adminpermission
echo.
if "%psd%"=="[{CLSID:8t4tvry4893tvy2nq4928trvyn14098vny84309tvny493q8tvn0943tyvnu0q943t8vn204vmy10vn05}]" (goto notpasswordsettet)
set /p enterpassword2setit=Enter the current password to change it: 
set enterpassword2setit="%enterpassword2setit%" 
if not "%psd%"==""%enterpassword2setit%"" (goto errorremovingpsd)
:notpasswordsettet
set /p setpassword1=Password to set in SWH: 
echo.
if /i %password2qwerty%=="" (goto swh)
echo SWH is checking if the password is sure... SWH has a database of more than 100 passwords that aren't secure.
set password2qwerty="%setpassword1%"
if /i %password2qwerty%=="qwerty" (goto easypassword)
if /i %password2qwerty%=="123456" (goto easypassword)
if /i %password2qwerty%=="qwertz" (goto easypassword)
if /i %password2qwerty%=="azerty" (goto easypassword)
if /i %password2qwerty%=="654321" (goto easypassword)
if /i %password2qwerty%=="123123" (goto easypassword)
if /i %password2qwerty%=="password" (goto easypassword)
if /i %password2qwerty%=="12345678" (goto easypassword)
if /i %password2qwerty%=="1234567" (goto easypassword)
if /i %password2qwerty%=="12345" (goto easypassword)
if /i %password2qwerty%=="abcdef" (goto easypassword)
if /i %password2qwerty%=="qwertyuiop" (goto easypassword)
if /i %password2qwerty%=="abc123" (goto easypassword)
if /i %password2qwerty%=="passw0rd" (goto easypassword)
if /i %password2qwerty%=="login" (goto easypassword)
if /i %password2qwerty%=="abcdefghi" (goto easypassword)
if /i %password2qwerty%=="000000" (goto easypassword)
if /i %password2qwerty%=="100000" (goto easypassword)
if /i %password2qwerty%=="010101" (goto easypassword)
if /i %password2qwerty%=="111111" (goto easypassword)
if /i %password2qwerty%=="191919" (goto easypassword)
if /i %password2qwerty%=="poiuytrewq" (goto easypassword)
if /i %password2qwerty%=="asdfghjklñ" (goto easypassword)
if /i %password2qwerty%=="zxcvbnm" (goto easypassword)
if /i %password2qwerty%=="mnbvcxz" (goto easypassword)
if /i %password2qwerty%=="ñlkjhgfdsa" (goto easypassword)
if /i %password2qwerty%=="abcde" (goto easypassword)
if /i %password2qwerty%=="abcd" (goto easypassword)
if /i %password2qwerty%=="abc" (goto easypassword)
if /i %password2qwerty%=="ab" (goto easypassword)
if /i %password2qwerty%=="a" (goto easypassword)
if /i %password2qwerty%=="xyz" (goto easypassword)
if /i %password2qwerty%=="321" (goto easypassword)
if /i %password2qwerty%=="987654321" (goto easypassword)
if /i %password2qwerty%=="121212" (goto easypassword)
if /i %password2qwerty%=="1" (goto easypassword)
if /i %password2qwerty%=="2" (goto easypassword)
if /i %password2qwerty%=="3" (goto easypassword)
if /i %password2qwerty%=="4" (goto easypassword)
if /i %password2qwerty%=="5" (goto easypassword)
if /i %password2qwerty%=="6" (goto easypassword)
if /i %password2qwerty%=="7" (goto easypassword)
if /i %password2qwerty%=="8" (goto easypassword)
if /i %password2qwerty%=="9" (goto easypassword)
if /i %password2qwerty%=="10" (goto easypassword)
if /i %password2qwerty%=="11" (goto easypassword)
if /i %password2qwerty%=="letmein" (goto easypassword)
if /i %password2qwerty%=="baseball" (goto easypassword)
if /i %password2qwerty%=="monkey" (goto easypassword)
if /i %password2qwerty%=="internet" (goto easypassword)
if /i %password2qwerty%=="swh" (goto easypassword)
if /i %password2qwerty%=="trustno1" (goto easypassword)
if /i %password2qwerty%=="log1n" (goto easypassword)
if /i %password2qwerty%=="dragon" (goto easypassword)
if /i %password2qwerty%=="superman" (goto easypassword)
if /i %password2qwerty%=="welcome" (goto easypassword)
if /i %password2qwerty%=="1234" (goto easypassword)
if /i %password2qwerty%=="0" (goto easypassword)
if /i %password2qwerty%=="cheese" (goto easypassword)
if /i %password2qwerty%=="lifehack" (goto easypassword)
if /i %password2qwerty%=="11" (goto easypassword)
if /i %password2qwerty%=="666666" (goto easypassword)
if /i %password2qwerty%=="98654321" (goto easypassword)
if /i %password2qwerty%=="jordan" (goto easypassword)
if /i %password2qwerty%=="consumer" (goto easypassword)
if /i %password2qwerty%=="pepper" (goto easypassword)
if /i %password2qwerty%=="pokemon" (goto easypassword)
if /i %password2qwerty%=="batman" (goto easypassword)
if /i %password2qwerty%=="gizmodo" (goto easypassword)
if /i %password2qwerty%=="%username%" (goto easypassword)
if /i %password2qwerty%=="adobe123" (goto easypassword)
if /i %password2qwerty%=="iloveyou" (goto easypassword)
if /i %password2qwerty%=="raspberry" (goto easypassword)
if /i %password2qwerty%=="admin" (goto easypassword)
if /i %password2qwerty%=="ubnt" (goto easypassword)
if /i %password2qwerty%=="test" (goto easypassword)
if /i %password2qwerty%=="user" (goto easypassword)
if /i %password2qwerty%=="blink182" (goto easypassword)
if /i %password2qwerty%=="password1" (goto easypassword)
if /i %password2qwerty%=="myspace1" (goto easypassword)
if /i %password2qwerty%=="sunshine" (goto easypassword)
if /i %password2qwerty%=="princess" (goto easypassword)
if /i %password2qwerty%=="football" (goto easypassword)
if /i %password2qwerty%=="!@#$%^&*" (goto easypassword)
if /i %password2qwerty%=="aa123456" (goto easypassword)
if /i %password2qwerty%=="donald" (goto easypassword)
if /i %password2qwerty%=="qwerty123" (goto easypassword)
if /i %password2qwerty%=="123456789" (goto easypassword)
if /i %password2qwerty%=="000" (goto easypassword)
if /i %password2qwerty%=="windows" (goto easypassword)
if /i %password2qwerty%=="mypc" (goto easypassword)
if /i %password2qwerty%=="computer" (goto easypassword)
if /i %password2qwerty%=="bypass" (goto easypassword)
if /i %password2qwerty%=="diamond" (goto easypassword)
if /i %password2qwerty%=="l0gin" (goto easypassword)
if /i %password2qwerty%=="l0g1n" (goto easypassword)
if /i %password2qwerty%=="google" (goto easypassword)
if /i %password2qwerty%=="hello" (goto easypassword)
if /i %password2qwerty%=="hi" (goto easypassword)
if /i %password2qwerty%=="access" (goto easypassword)
if /i %password2qwerty%=="sure" (goto easypassword)
if /i %password2qwerty%=="321qwerty" (goto easypassword)
if /i %password2qwerty%=="321azerty" (goto easypassword)
if /i %password2qwerty%=="321qwertz" (goto easypassword)
if /i %password2qwerty%=="123" (goto easypassword)







echo.
echo Sure password. SWH cannot find this password on his database.
echo.
set /p setpassword2=Repeat password: 
if "%setpassword2%"=="%setpassword1%" (goto changingpassword) else (goto errorchangingpassword)

:easypassword
echo.
echo This password is too easy to know. Please choose another password
echo.
goto swh

:errorchangingpassword
echo.
echo Two passwords are not the same
echo.
goto swh

:changingpassword


cd /d %pathswh%\Temp



echo Option Explicit > Encrypt.vbs
echo Dim temp, key, objShell, objFSO, crypt >> Encrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Encrypt.vbs
echo temp = "%setpassword2%" >> Encrypt.vbs
echo key = "4Ou8fa94pfx3WV3AsnhoAz7xWbtkA5T36SMX7sOB9I8WazaCirdOT1HfhBJBKvZlQDMRIGEH49vPK5KTDPTaIPVT8h3F57QW3RYbJ0WrT90Fxk3EBcMCz0APGZebZWkZH2JvGuFqs8mvICYG4uZW2MYnXwPmnVa8S4HCEgeQRPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4IRQ0261QCeJHPBj71LKIqGDbWBTrLBh8wPONCYVM0F4RPIDoWdH8V9S263pW2PMA5kgIkn2ONZ9j7WCZP38Vf4" >> Encrypt.vbs
echo temp = Encrypt(temp,key) >> Encrypt.vbs

echo Set objFSO = createobject("scripting.filesystemobject") >> Encrypt.vbs
echo Set crypt = objfso.createtextfile("PS.dat",true)  >> Encrypt.vbs
echo crypt.writeline "" ^&temp >> Encrypt.vbs
echo crypt.close >> Encrypt.vbs

echo temp = Decrypt(temp,key) >> Encrypt.vbs
echo Function encrypt(Str, key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str = StrReverse(str) >> Encrypt.vbs
echo  For x = 1 To LenStr >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = keypos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs >> Encrypt.vbs
echo  Next >> Encrypt.vbs
echo  encrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
echo Function Decrypt(str,key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str=StrReverse(str) >> Encrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = KeyPos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs
echo       Next >> Encrypt.vbs
echo       Newstr=StrReverse(Newstr) >> Encrypt.vbs
echo       Decrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
if exist "%programfiles%\SWH\ApplicationData\PS.dat" (del "%programfiles%\SWH\ApplicationData\PS.dat" /q)
start /wait WScript.exe "%pathswh%\Temp\Encrypt.vbs"
copy "%pathswh%\Temp\PS.dat" "%programfiles%\SWH\ApplicationData\PS.dat">nul
if exist "%pathswh%\Temp\PS.dat" (del "%pathswh%\Temp\PS.dat /q")



echo.
cd /d "%cdirectory%"
echo New password is %setpassword1%
echo.
if exist "%pathswh%\Temp\Encrypt.vbs" (del "%pathswh%\Temp\Encrypt.vbs" /q)
goto swh

:removepassword
echo.
set /p removingpasswordchk=To remove the password you need to enter it first: 
if "%removingpasswordchk%"=="%psd%" (goto removingpsd) else (goto errorremovingpsd)
:removingpsd
del "%programfiles%\SWH\ApplicationData\PS.dat" /q
echo.
echo Password succefully removed
echo.
goto swh

:errorremovingpsd
echo.
echo Incorrect password
echo.
goto swh

:adminpermission
echo.
echo Please run SWH as administrator.
echo.
goto swh

:swhver
cd\
echo.
if "%securever%"=="%ver%" (echo SWH Version: %ver%) else (set ver=%securever%&echo SWH Version: %ver%)
echo.
cd /d "%cdirectory%"
goto swh

:read
if %moreCMD%==1 (goto ReadMore)
set /p read=Text to read: 
echo.
type %read%
echo.
echo.
goto swh
:ReadMore
set /p readMore=Text to read: 
echo.
more %readMore%
echo.
echo.
goto swh

:moreWalk
echo.
if %moreCMD%==1 (
	set moreCMD=0
	echo More has been disabled.
	goto swh
)
if %moreCMD%==0 ( 
	set moreCMD=1
	echo More has been enabled.
	goto swh
)


:scriptproject2
echo.
echo Projects will come soon. To install it in the future, please install each SWH update
echo.
goto swh

:cdDisk
cd\
echo.
goto swh

:cdBack
cd..
echo.
goto swh


:updateswh
echo.
echo SWH is now checking for updates... If an update is founded, SWH will install automatically
echo This process may take some time
if not %admin%==1 (goto swh_adminUpdate)
echo 'Set your settings > "%pathswh%\Temp\SWH_Downloader.vbs"
echo     strFileURL = "https://raw.githubusercontent.com/anic17/SWH/master/SWH.bat" >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo     strHDLocation = "SWH.bat" >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo    ' Fetch the file >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo     Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP") >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo     objXMLHTTP.open "GET", strFileURL, false>> "%pathswh%\Temp\SWH_Downloader.vbs"
echo     objXMLHTTP.send() >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo     If objXMLHTTP.Status = 200 Then >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       Set objADOStream = CreateObject("ADODB.Stream") >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       objADOStream.Open >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       objADOStream.Type = 1 'adTypeBinary >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       objADOStream.Write objXMLHTTP.ResponseBody >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       objADOStream.Position = 0    'Set the stream position to the start >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       Set objFSO = Createobject("Scripting.FileSystemObject") >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo         If objFSO.Fileexists(strHDLocation) Then objFSO.DeleteFile strHDLocation >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       Set objFSO = Nothing >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       objADOStream.SaveToFile strHDLocation>> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       objADOStream.Close >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo       Set objADOStream = Nothing >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo     End if >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo     Set objXMLHTTP = Nothing >> "%pathswh%\Temp\SWH_Downloader.vbs"
echo.
rem This VBScript downloading script was founded on: https://serverfault.com/questions/29707/download-file-from-vbscript
start wscript.exe "%pathswh%\Temp\SWH_Downloader.vbs"
echo.
if exist "%pathswh%\Temp\SWH.bat" (del "%pathswh%\Temp\SWH.bat" /q)
:chking_IfUpdatedSWH
if exist "%pathswh%\Temp\SWH.bat" (goto supdated)
goto :chking_IfUpdatedSWH
:supdated
move "%pathswh%\SWH.bat" "%pathswh%\OldSWH\SWH.bat">nul
move "%pathswh%\Temp\SWH.bat" "%pathswh%\SWH.bat">nul
echo SWH has been updated!
echo swh=Msgbox("SWH has succefully been updated",4160,"SWH has succefully been updated") > %pathswh%\Temp\SUpdated.vbs
start /wait wscript.exe "%pathswh%\Temp\SUpdated.vbs"
echo.
goto swh
:swh_adminUpdate
echo Set WshShell = WScript.CreateObject("WScript.Shell") > %pathswh%\Temp\AdminSWH.vbs
echo If WScript.Arguments.Length = 0 Then >> %pathswh%\Temp\AdminSWH.vbs
echo   Set ObjShell = CreateObject("Shell.Application") >> %pathswh%\Temp\AdminSWH.vbs
echo   ObjShell.ShellExecute "wscript.exe" _ >> %pathswh%\Temp\AdminSWH.vbs
echo     , """" ^& WScript.ScriptFullName ^& """ /admin", , "RunAs",1 >> %pathswh%\Temp\AdminSWH.vbs
echo   WScript.Quit >> %pathswh%\Temp\AdminSWH.vbs
echo End if >> %pathswh%\Temp\AdminSWH.vbs
echo Set ObjShell = CreateObject("WScript.Shell") >> %pathswh%\Temp\AdminSWH.vbs
echo objShell.Run "cmd.exe /c %pathswh%\SWH.bat /c updateswh" >> %pathswh%\Temp\AdminSWH.vbs
echo.
start WScript.exe "%pathswh%\Temp\AdminSWH.vbs"
exit /B




:decrypttext
echo.
echo Note: SWH only can decrypt text encrypted by it
echo.
set /p texttodecrypt=Text to decrypt: 

cd /d "%pathswh%"
echo Option Explicit > Decrypt.vbs
echo Dim temp, key, objShell, objFSO, decrypt >> Decrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Decrypt.vbs
echo temp = "%texttodecrypt%" >> Decrypt.vbs
echo key = "huasHIYhkasdho1" >> Decrypt.vbs
echo temp = DecryptING(temp,key) >> Decrypt.vbs
echo Set objFSO = createobject("scripting.filesystemobject")>> Decrypt.vbs 
echo Set decrypt = objfso.createtextfile("decrypt.txt",true) >> Decrypt.vbs
echo decrypt.writeline "" ^&temp >> Decrypt.vbs
echo decrypt.close >> Decrypt.vbs
echo temp = DecryptING(temp,key) >> Decrypt.vbs
echo Function encrypt(Str, key) >> Decrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str = StrReverse(str) >> Decrypt.vbs
echo  For x = 1 To LenStr >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = keypos+1 >> Decrypt.vbs
echo       If KeyPos > lenKey Then KeyPos = 1 >> Decrypt.vbs
echo  Next >> Decrypt.vbs
echo  Decrypt = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
echo Function DecryptING(str,key)>> Decrypt.vbs 
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Decrypt.vbs
echo  Newstr = "" >> Decrypt.vbs
echo  lenKey = Len(key) >> Decrypt.vbs
echo  KeyPos = 1 >> Decrypt.vbs
echo  LenStr = Len(Str) >> Decrypt.vbs
echo  str=StrReverse(str) >> Decrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Decrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Decrypt.vbs
echo       KeyPos = KeyPos+1 >> Decrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Decrypt.vbs 
echo       Next >> Decrypt.vbs
echo       Newstr=StrReverse(Newstr)>> Decrypt.vbs 
echo       DecryptING = Newstr >> Decrypt.vbs
echo End Function >> Decrypt.vbs
echo.
start wscript.exe "%pathswh%\Decrypt.vbs"
cd /d "%cdirectory%"
goto swh

















:encrypttext

if exist %pathswh%\Temp\encrypt.txt (del %pathswh%\Temp\encrypt.txt /q>nul)
if exist %pathswh%\Temp\encrypt.vbs (del %pathswh%\Temp\encrypt.vbs /q>nul)
set /p texttoencrypt=Text to encrypt: 
cd /d "%pathswh%\Temp"

echo Option Explicit > Encrypt.vbs
echo Dim temp, key, objShell, objFSO, crypt >> Encrypt.vbs
echo Set objShell = WScript.CreateObject("WScript.Shell") >> Encrypt.vbs
echo temp = "%texttoencrypt%" >> Encrypt.vbs
echo key = "huasHIYhkasdho1" >> Encrypt.vbs
echo temp = Encrypt(temp,key) >> Encrypt.vbs

echo Set objFSO = createobject("scripting.filesystemobject") >> Encrypt.vbs
echo Set crypt = objfso.createtextfile("encrypt.txt",true)  >> Encrypt.vbs
echo crypt.writeline "" ^&temp >> Encrypt.vbs
echo crypt.close >> Encrypt.vbs

echo temp = Decrypt(temp,key) >> Encrypt.vbs
echo Function encrypt(Str, key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str = StrReverse(str) >> Encrypt.vbs
echo  For x = 1 To LenStr >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) + Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = keypos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs >> Encrypt.vbs
echo  Next >> Encrypt.vbs
echo  encrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
echo Function Decrypt(str,key) >> Encrypt.vbs
echo  Dim lenKey, KeyPos, LenStr, x, Newstr >> Encrypt.vbs
echo  Newstr = "" >> Encrypt.vbs
echo  lenKey = Len(key) >> Encrypt.vbs
echo  KeyPos = 1 >> Encrypt.vbs >> Encrypt.vbs
echo  LenStr = Len(Str) >> Encrypt.vbs
echo  str=StrReverse(str) >> Encrypt.vbs
echo  For x = LenStr To 1 Step -1 >> Encrypt.vbs
echo       Newstr = Newstr ^& chr(asc(Mid(str,x,1)) - Asc(Mid(key,KeyPos,1))) >> Encrypt.vbs
echo       KeyPos = KeyPos+1 >> Encrypt.vbs
echo       If KeyPos ^> lenKey Then KeyPos = 1 >> Encrypt.vbs
echo       Next >> Encrypt.vbs
echo       Newstr=StrReverse(Newstr) >> Encrypt.vbs
echo       Decrypt = Newstr >> Encrypt.vbs
echo End Function >> Encrypt.vbs
start /wait wscript.exe "%pathswh%\Temp\encrypt.vbs"
echo.
type "%pathswh%\Temp\encrypt.txt"
echo.
set /p encryptcopyclip=Copy encrypted text to the clipboard (y/n): 
if /i "%encryptcopyclip%"=="y" (
	clip < %pathswh%\Temp\encrypt.txt
)
cd /d "%cdirectory%"
goto swh








:SWHdiskCleaner
if not %admin%==0 (goto correctdiskcleaner)
echo.
echo Please run SWH Disk Cleaner as administrator
echo swh=msgbox("Please run SWH Disk Cleaner as administrator",4112,"Please run SWH Disk Cleaner as administrator") > %pathswh%\rundiskadmin.vbs
start /wait wscript.exe "%pathswh%\rundiskadmin.vbs"
echo.
goto swh


:correctdiskcleaner



rem SWH Disk Cleaner
echo.
title Scripting Windows Host Disk Cleaner
echo Welcome to the Scripting Windows Host Disk Cleaner
echo.
echo Press "C" to clear disk space, press "Q" to quit
choice /c:QC /N>nul
if errorlevel 2 goto clsDisk
if errorlevel 1 goto swh

:clsDisk
echo.
echo Searching junk...
if not exist *.* (
	set sizeJunkWinTemp=0
	goto passedWinTempJunk
)
cd /d %SystemRoot%\Temp
copy *.* JunkWinTemp>nul
for %%W in (JunkWinTemp) do (set sizeJunkWinTemp=%%~zW)
:passedWinTempJunk
cd /d "%tmp%"
if not exist *.* (
	set sizeJunkTemp=0
	goto passedDownloadsTemp
)
copy *.* JunkTemp>nul
for %%T in (JunkTemp) do (set sizeJunkTemp=%%~zT)
timeout /t 1 /nobreak>nul
:passedDownloadsTemp
cd /d "%userprofile%\Downloads"
if not exist *.* (
	set sizeJunkDownloads=0
	goto passedDownloadsJunk
)
copy *.* JunkDownloads>nul
for %%D in (JunkDownloads) do (set sizeJunkDownloads=%%~zD)
timeout /t 1 /nobreak>nul
cd /d "%pathswh%\Temp"
copy *.* JunkSWHTemp
for %%S in (JunkSWHTemp) do (set sizeJunkSWHtemp=%%~zS)

:passedDownloadsJunk



set /a totalJunkSWH_DiskCleaner=%sizeJunkWinTemp%+%sizeJunkTemp%+%sizeJunkDownloads%+%sizeJunkSWHtemp%

set /a totalJunkKB=%totalJunkSWH_DiskCleaner%/1024

rem Size on kB of Rubbish
set /a swhtempJunkKB=%sizeJunkSWHtemp%/1024
set /a wintempJunkKB=%sizeJunkWinTemp%/1024
set /a downloadsJunkKB=%sizeJunkDownloads%/1024
set /a tempJunkKB=%sizeJunkTemp%/1024


echo.
echo A total space of %totalJunkSWH_DiskCleaner% bytes can be cleaned (%totalJunkKB% kB)
echo.
echo Downloads: %sizeJunkDownloads% Bytes (%downloadsJunkKB% kB)
echo Temp: %sizeJunkTemp% Bytes (%tempJunkKB% kB)
echo Windows Temp: %sizeJunkWinTemp% Bytes (%wintempJunkKB% kB)
echo SWH Temp files: %sizeJunkSWHtemp% Bytes (%swhtempJunkKB% kB)
echo.
del "%userprofile%\Downloads" /q>nul
del "%SystemRoot%\Temp\JunkWinTemp" /q>nul
del "%tmp%\JunkTemp" /q>nul
set /p surecleardiskspace=Clear all this files? (%totalJunkSWH_DiskCleaner% Bytes will be cleaned, %totalJunkKB% kB) (y/n): 
if /i "%surecleardiskspace%"=="y" (
	echo Clearing Downloads...
	del %userprofile%\Downloads /s /q>nul
	echo Clearing Temp...
	del %tmp% /s /q>nul
	echo Clearing Windows Temp...
	del %systemroot%\Temp /s /q>nul
	echo Clearing SWH Temp files...
	del %pathswh%\Temp /q>nul
	echo.
	echo Cleaned %totalJunkKB% kB!
)
echo.
cd /d %cdirectory%
goto swh














:settings
echo.
set /p settingssave=Settings (Type "helpsettings" in SWH Console to see the available settings): 
set settingssave2="%settingssave%"
set settingssave=%settingssave2%
if %settingssave%=="size" (goto SettingsSize)
if %settingssave%=="consoletext" (goto SettingContext) else (goto incosetting)
:incosetting
echo.
echo This setting does not exist. Type "helpsettings" to see the settings avaiable.
echo.
goto swh
:SettingsSize
set /p settingssizesave=Are you sure that you would change the default console size? (y/n): 
if %settingssizesave%==y (goto savingsettingssize1) else (
	echo.
	goto swh
)
:settingcontext
set /p commandtoexecute4=New text on console line: 
set cmdte4="%commandtoexecute4%"
if "%cmdte4%"=="%commandtoexecute%"  (
	echo You need to change the console line
	echo.
	goto swh
) else (
	set /p surecontextnew=Are you sure that you would change the default console text? (y/n): 
	if "%surecontextnew%"=="y" (goto changingconsoletext) else (goto nochangingcontext)
)

:hsettings
echo.
echo Settings:
echo.
echo prompt: Changes the %commandtoexecute% text
echo size: Changes the default size
echo 
echo.
goto swh

:changingconsoletext
echo %commandtoexecute4% > %localappdata%\ScriptingWindowsHost\Settings\ConsoleText.opt
echo.
goto swh
:nochangingcontext
echo.
goto swh

:abstartswh
if not exist "%pathswh%\SWH.*" (
	echo.
	echo Please install SWH to use this function
	echo.
	echo You can install it with the command "setup"
	echo Note: Install SWH requires administrator privileges
	echo.
	goto swh
)

echo @echo off > "%pathswh%\Temp\CommandSWH.bat"
echo mode con: cols=15 lines=1 >> "%pathswh%\Temp\CommandSWH.bat"
echo start conhost.exe "%pathswh%\%~nx0" >> "%pathswh%\Temp\CommandSWH.bat"
echo exit >> "%pathswh%\Temp\CommandSWH.bat"
cd /d %pathswh%\Temp
start conhost.exe CommandSWH.bat
exit /b

:clsTemp
echo.
set /p sureclstmp=Are you sure would remove temporal files? (y/n): 
if /i "%sureclstmp%"=="y" (
	del %tmp% /s /q /f >nul
	rd %tmp% /s /q >nul
	echo.
	goto swh
) else (
	echo.
	goto swh
)
:clsWinTMP
echo.
echo Note: Clear Windows temporal files in %windir%\Temp requires administrator permission
echo.
set /p sureclsWinTMP=Are you sure would remove Windows tempotal files in %SystemRoot%\Temp? (y/n): 
if /i "sureclsWinTMP"=="y" (
	del %Systemroot%\Temp /s /q /f>nul
	echo.
	goto swh
) else (
	echo.
	goto swh
)


:execinfo
echo.
echo SWH executed at: %execdate% %exectime%
echo Executed with the name of "%~nx0", in directory "%execdir%"
echo SWH size: %~z0 Bytes (%sizeSWHkB% kB)
echo SWH modification date: %~t0
echo SWH version: %ver%
if %admin%==1 (echo SWH is running with administrator privileges) else (echo SWH is not running with administrator privileges)
:execinfoCHKifinstalled_
if "%~dpnx0"=="%Localappdata%\ScriptingWindowsHost\%~nx0" (
	echo Using the installed version
) else (goto execinfoCHKinstall)
echo.
goto swh
:execinfoCHKinstall
if exist "%Localappdata%\ScriptingWindowsHost\%~nx0" (
	echo SWH is installed, using portable version
	echo.
	goto swh
) else (goto CHKinstallexecinfo)
:CHKinstallexecinfo
if not exist "%Localappdata%\%~nx0" (
	echo SWH is not installed, using portable version.
	echo.
	goto swh
)



:resetsettings
echo.
set /p rsettings=Are you sure that you would reset ALL settings? (y/n): 
if /i "%rsettings%"=="Y" (goto rstingset) else (
	echo.
	goto swh
)
:rstingset
cd /d %pathswh%
rd Settings /s /q
md Settings
echo.
cd %cdirectory%
goto swh

:faq
echo.
echo Frequent asked questions
echo.
echo.
echo 1)
echo Why if I change the path it adds %Windir% and %Windir%\System32?
echo.
echo It adds it automatically because many SWH functions work with this path.
echo.
echo.
echo 2)
echo Can I remove this two paths (%Windir% and %Windir%\System32)?
echo.
echo Yes, you can change it with the command "systempath"
echo.
echo.
echo 3) If I typed "systempath", how I add the %windir% and %windir%\System32 variables?
echo.
echo You need to type "systempath" if the system path is disabled.
echo.
echo 4)
echo With what method of encryption my password is ensured?
echo.
echo SWH uses a self-created encryption method. We cannot say it, because decrypting the password will be easier.
goto swh

:commandCom
if not exist %Windir%\System32\command.com (goto commandcom_NotExist)
cd /d "%Windir%\System32"
start command.com
cd /d "%cdirectory%"
goto swh
:commandcom_NotExist
echo swh=MsgBox("SWH can't find the file %windir%\System32\command.com",4112,"SWH can't find the file %windir%\System32\command.com") > %pathswh%\Temp\ErrorCommand.vbs
start /wait wscript.exe "%pathswh%\Temp\ErrorCommand.vbs"
echo.
goto swh


:SysInfo
echo.
%windir%\System32\systeminfo.exe
echo.
goto swh

:Syspath
if %syspathvar%==1 goto aftersyspathvar
set syspathvar=1
:RsysPathvar
echo.
echo Path stablished only %path%
echo.
echo.
echo Note that setting an incorrect path will make SWH not work good.
goto swh

:aftersyspathvar
set syspathvar=0
goto RsysPathvar

:chPath
echo.
echo Note: Changing incorrectelly the path can do that SWH don't work!
echo.
if %syspathvar%==1 (
	echo Path won't add %Windir% and %Windir%\System32 because systempath is disabled.
	echo.
)
if %syspathvar%==0 (
	echo Path will add %Windir% and %Windir%\System32 because systempath is enabled.
	echo.
)
echo Press Y to change path, press N to return to SWH
choice /c:NY /N>nul
if errorlevel==2 (goto changingpath)
if errorlevel==1 (
	echo.
	goto swh
)
goto swh
:changingpath
set oldpath=%path%
set /p newpath=New path: 
path=%newpath%
echo Path %oldpath% changed to %newpath%
if %syspathvar%==1 (goto swh)
path=%newpath%;%Windir%;%Windir%\System32
goto swh


:randomnumber
echo.
echo Note: SWH cannot generate random numbers bigger than 32757
echo.
set /p ranksmallest=Smallest possible random number: 
set /p rankbiggest=Biggest possible random number: 
echo.
set /a ResultRandom=(%RANDOM%*%rankbiggest%/32768)+%ranksmallest%
echo %ResultRandom%
echo.
goto swh

:ipconfig
echo.
ipconfig
echo.
goto swh

:swhzip
echo.
title Scripting Windows Host File Compressor
echo Welcome to the Scripting Windows Host file compressor.
:startcompress123
set direc=%cd%
set direcTest="%direc%"
if %direcTest%=="{CLSID-SWH-SWHZIP12456vW7vrCt67Bt78R7vyu7vcr5659ov93590fcb598-5tc54t3c3d3h6s5yf-x35yv45yc335y}" (goto specifyDIRSWHZIP)
if exist %direc% (
	cd %direc%
	goto ftc12
) else (
	echo.
	echo "%direc%" directory is not existent. Please check "%direc%" is the correct name.
	echo.
	goto swh
)
:specifyDIRSWHZIP
echo.
echo Please specify a directory
echo.
goto swh


:ftc12
echo.
set /p ftc=File to compress (You can autocomplete file name with Tab key): 
if exist %ftc% (
	goto surecompressing14
) else (
	echo %ftc% file doesn't exist!
	echo Please check "%ftc%" is the correct name.
	echo.
	goto swh
)
:surecompressing14
echo.
set ext=swhzip
set /p surecmpr=Are you sure that you would to compress %ftc% to the name of %ftc%.swhzip? (y/n): 
if /i "%surecmpr%"=="y" (goto cmprssing)
if /i "%surecmpr%"=="N" (goto cancelcmprs) else (goto impocmprs)
:cmprssing
echo.
echo Compressing... Please wait


md "%pathswh%\SWHZip\%ftc%"


powershell -Command Compress-Archive %ftc% %ftc%.zip>nul

ren %ftc%.zip %ftc%.%ext%



echo ren %ftc%.* %ftc%.zip >> DecompressorSWH%ran%.cmd
echo powershell -Command Expand-Archive %ftc%.zip>> DecompressorSWH%ran%.cmd
echo del DecompressorSWH%ran%.cmd /q >> DecompressorSWH%ran%.cmd
echo exit /B >> DecompressorSWH%ran%.cmd

copy "%ftc%" "%localappdata%\ScriptingWindowsHost\SwhZip\%ftc%">nul
echo %ftc% is compressed to the name %ftc%.%ext%
echo.
echo Press any key to exit SWHZip...
pause>nul
echo.
title Scripting Windows Host Console
goto swh

:impocmprs
echo.
echo "%surecmpr%" is not a valid option.
echo.
echo Press any key to exit SWHZip...
pause>nul
title Scripting Windows Host Console
goto swh
:cancelcmprs
echo.
echo "%ftc%" compression canceled.
echo.
echo Press any key to exit SWHZip...
pause>nul
title Scripting Windows Host Console
goto swh






:savingsettingssize1
echo cols=%colmodesize% lines=%linemodesize% > %localappdata%\ScriptingWindowsHost\Settings\Size.opt
echo.
goto swh
:SWHrunDialog
echo.
set runfile=0{SWH-RUN-KEY______RUN.Antibug_DeteCtor}
set /p runfile=Folder, file or Internet ressource to open: 
set runfile2="%runfile%"
set runfile=%runfile2%
if %runfile%=="0{SWH-RUN-KEY______RUN.Antibug_DeteCtor}" (goto errorRunning)
start %runfile%
echo.
goto swh

:errorRunning
echo.
echo You need to enter the name of the file, folder or Internet ressource that you would open
cd /d %userprofile%\AppData\Local\ScriptingWindowsHost
echo swh=MsgBox("You need to write the name, you can't put on blank",4112,"You need to write the name, you can't put on blank") > %pathswh%\Temp\ErrorRun.vbs
start /wait wscript.exe ErrorRun.vbs
cd /d %cdirectory%
echo.
goto swh

:title
set /p titlecon=Title of SWH Console: 
title %titlecon%
echo.
echo Title: %titlecon% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:vol
set /p voldisk=Disk to see his volume (Type only the letter, ex C ): 
vol %voldisk%
echo.
echo Volume >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:variable
echo.
echo Note: changing SWH variables can do SWH that doesn't work correctly.
echo See "swhvariables" for info of the variables that you mustn't change
echo.
set /p variablename=Variable name: 
set /p variabletext=Variable text: 
set %variablename%=%variabletext%
echo.
echo Variable: variablename:%variablename%; variabletext:%variabletext% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:swhvariables
echo.
echo SWH variables:
echo.
echo cd: Sets the %cd% text. Changing will do that SWH don't change the directory
echo cdirectory: cdirectory is the second directory variable, used for internal commands
echo cmd: cmd is the command variable. Changing it could make that commands don't work correctly.
echo commandtoexecute: It is the %commandtoexecute% text. It can be changed by "prompt".
echo localappdata: Changing LocalAppData will make many errors of the correct working of SWH
echo ver: Ver is the variable that shows the SWH Version. Changing will not show the actual version.
echo.
echo SwhVariables >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:bugs
echo Bugs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo Fixed bugs:
echo 0xe0000001: If you write "not swh" it closes automatically
echo 0xe0000002: If you write ">", "<", "&" or "|" it closes automatically
echo 0xe0000003: The text decryptor is bugged (Now)
echo.
goto swh

:bootconfig
cd /d %SystemRoot%\System32
start msconfig.exe
cd /d %cdirectory%
echo.
echo SystemConfig: %SystemRoot%\System32\msconfig.exe >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh


:consoleinput
echo Note: To put special symbols ^< ^> ^& ^| please type ^^ before the symbol
set /p commandtoexecute=New text of the console line: 
echo.
echo Consoleinput: %commandtoexecute% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:PowerShell
start powershell.exe
echo.
echo PowerShell >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:networkconnections
echo Loading... Please wait.
echo.
net view
echo.
echo NetworkConnections: net view >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:searchfiles
set /p searchfiles=File or folder to search: 
echo.
echo Searching %searchfiles%... Please wait.
echo.
dir /s /b %searchfiles% > %pathswh%\Temp\Search.tmp
echo.
cd /d "%pathswh%\Temp"
for %%a in (Search.tmp) do (set searchTmpSize=%%~za)
if %searchTmpSize% lss 100 (
	echo Cannot find %searchfiles%
	echo.
	echo Search %searchfiles% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	cd /d "%cdirectory%"
	goto swh
)
for /f "tokens=1,2* delims=," %%a in (Search.tmp) do (echo Founded result: %%a)
cd /d "%cdirectory%"
echo.
echo Search %searchfiles% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:url
set /p url=URL to access: 
iexplore.exe %url%
echo.
echo URL: %url% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:history
if %moreCMD%==1 (goto moreHist)
echo.
type %pathswh%\SWH_History.txt
:sizeHistoryBytes
for %%H in (%pathswh%\SWH_History.txt) do (set sizeHistory=%%~zH)
echo.
echo Size of SWH history: %sizeHistory% Bytes
echo History:VIEWED >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
goto swh

:moreHist
echo.
more %pathswh%\SWH_History.txt
echo.
goto sizeHistoryBytes

:clearhistory
echo OptionsCanHistoryCleared:ClearHistory >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %pathswh%\Temp
set /p clearhist=Are you sure that you would clear the history? (y/n): 
if /i "%clearhist%"=="y" (goto clearhist) else (
	echo.
	cd /d %cdirectory%
	goto swh
)
:clearhist
del %pathswh%\SWH_History.txt /q>nul
echo SWH=MsgBox("History was succefully cleared",4160,"Done!") > SWHClHist.vbs
start /wait SWHClHist.vbs
echo History:CLEARED >> %pathswh%\SWH_History.txt
cd /d "%cdirectory%"
echo.
goto swh

:trexgame
cd /d %localappdata%\ScriptingWindowsHost
if exist T-RexGame.html (
	goto CHKchromeins
	start T-RexGame.html
	echo.
	cd /d %cdirectory%
	echo T-RexGame.html: played >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	goto nostartTREX
)
:CHKchromeins
if exist %programfiles%\Google

:nostartTREX
echo T-Rex: Error: %localappdata%\ScriptingWindowsHost\T-RexGame.html not founded >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo Error! File %localappdata%\ScriptingWindowsHost\T-RexGame.html not founded.
echo SWH=MsgBox("File T-RexGame.html not founded",4112,"SWH can't found the T-rex Game file") > "%pathswh%\Temp\ErrorT-Rex.vbs"
start /wait wscript.exe "%pathswh%\Temp\ErrorT-Rex.vbs"
echo.
cd /d %cdirectory%
goto swh

:cancelshutdown
echo cancelshutdown >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
shutdown /a
echo.
goto swh
:cmdscreen
echo cmd.exe >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
start
echo.
goto swh

:cd
set /p chdirectory=Directory to access: 
if exist %chdirectory% (
	cd /d %chdirectory% 
	set chdirectory=%cd%
	echo.
	goto swh
) else (
	set cdirectory=%cd%
	echo Directory "%chdirectory%" not founded!
	echo cd %cdirectory% does not exist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
)
echo.
echo cd %cdirectory% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:voice
set /p voicetext=Text to pronounce: 
echo dim speech > C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
echo SWH="%voicetext%" >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
echo set speech=CreateObject("sapi.SpVoice") >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
echo speech.speak SWH >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs
start wscript.exe "C:\Users\%username%\AppData\Local\ScriptingWindowsHost\Temp\SWH_Voice.vbs"
echo.
echo Voice: %voicetext% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:mkdir
set /p foldername=Folder name: 
mkdir %foldername%
echo.
echo folder %foldername% Location: %cdirectory% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:start
set /p startexec=Program or file to execute: 
set /p startexecprog=Program to open "%startexec%" (Write "None" to execute %startexec% without programs): 
if /i "%startexecprog%"=="None" (
	start %startexec%
	echo execute %startexec% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
) else (
	start "%startexecprog%" "%startexec%"
	echo.
	echo execute %startexec% %startexecprog% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
)

:file
echo.
set /p namefile=Name of the file: 
set /p filecreation=Text to the file: 
echo %filecreation% > %namefile%
echo.
echo file:%namefile% text:%filecreation% location:%cdirectory% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:shutdown
set /p resetorshutdown=Restart (1) or shutdown (2): 
if "%resetorshutdown%"=="1" (goto resettime)
if "%resetorshutdown%"=="2" (goto rshutdowntime) else (
	echo "%resetorshutdown%" is not a possible option.
	echo Shutdown %resetorshutdown% is not possible option.
	echo Valid options are 1 and 2
	echo.
	goto swh
)

:rshutdowntime
set /p shutdowntime=Time to shut down computer: 
set /p commentshutdown=Comment (Press "Enter" to don't say a comment): 
if "%commentshutdown%"=="None" (
	shutdown -s -t %shutdowntime%
	echo.
	goto swh
) else (
	shutdown -s -t %shutdowntime% -c "%commentshutdown%"
)
echo.
echo shutdown-shutdown %shutdowntime% %commentshutdown% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo Shutting down...
echo.
goto swh

:resettime
set resettime=30
set /p resettimepc=Time to restart computer: 
set commentreset=PC will shutdown in %resettimepc%
set /p commentreset=Comment (Press "Enter" to don't say a comment): 
shutdown -s -t %resettimepc% -c "%commentreset%"

echo shutdown-reset %resettimepc% %commentreset%>> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
goto swh


:cls
cls
echo Clear >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:color
set textcolor=DOS_SWH.BAT
set backgroundcolor=DOS_SWH.BAT
set /p textcolor=Color of text: 
set /p backgroundcolor=Color of background: 
if "%backgroundcolor%"=="%textcolor%" (
	if "%textcolor%"=="%backgroundcolor%"=="DOS_SWH.BAT" (
		echo You need to enter valid values to change the color.
		echo.
		goto swh
		echo Color: Error: No valid values to change the color (%backgroundcolor%%textcolor%)
	) else (
		goto nochangecolor1	
	)
	:nochangecolor
	echo.
	echo Two colors can't be the same. Choose different colors.
	echo.
	echo Color: Error: Two colors are the same (%backgroundcolor%%textcolor%)
	goto swh
) else (
	color %backgroundcolor%%textcolor%
	echo.
	goto swh
)
:del
echo.
echo Warning! Use with precaution!
echo.
set /p delfile=File to delete: 
if not exist %delfile% (
	echo.
	echo %delfile% does not exist. Check that %delfile% is the correct name.
	echo.
	goto swh
)
set /p suredelete=Are you sure that do you want to delete %delfile%? (y/n) 
if "%suredelete%"=="y" (
	del %delfile%
	echo del %delfile% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
) else (
	echo.
	goto swh
)

:tasklist
echo tasklist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
%windir%\System32\tasklist.exe
echo.
goto swh

:taskmgr
echo taskmgr >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
start taskmgr.exe "%systemroot%\System32\TaskMgr.exe"
echo.
goto swh


:taskkill
set taskkillpidim=0
set /p taskkillpidim=By PID (1) or process name (IM) (2): 
if "%taskkillpidim%"=="1" (goto tskillPID_FnoF)
if "%taskkillpidim%"=="2" (goto tskillIM_FnoF) else (
	echo.
	echo "%taskkillpidim%" is not a possible option
	echo.
	goto swh
)

:tskillPID_FnoF
set /p taskkillPIDFnoF=Forced (1) or not forced (2): 
if "%taskkillPIDFnoF%"=="1" (goto tskillyfPID)
if "%taskkillPIDFnoF%"=="2" (goto tskillnfPID) else (
	echo.
	echo "%taskkillPIDFnoF%" is not a possible option
	echo.
	goto swh
)

:tskillIM_FnoF
set /p taskkillIMFnoF=Forced (1) or not forced (2): 
if "%taskkillIMFnoF%"=="1" (goto tskillyfIM)
if "%taskkillIMFnoF%"=="2" (goto tskillnfIM) else (
	echo.
	echo "%taskkillIMFnoF%" is not a possible option
	echo.
	goto swh
)
:tskillyfIM
set /p taskkillprocessf=Process to finish (IM): 
if /i "%taskkillprocessf%"=="csrss.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="lsass.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="winlogon.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="System" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="Registry" (goto accessdeniedEndTask)
if /i "%taskkillprocessf%"=="svchost.exe" (echo Access denied) else (taskkill /f /im %taskkillprocessf%)
echo.
echo EndTask:%taskkillprocessf% Forced>> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh
:tskillnfIM
set /p taskkillprocessnf=Process to finish (IM): 
if /i "%taskkillprocessnf%"=="csrss.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="lsass.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="winlogon.exe" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="System" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="Registry" (goto accessdeniedEndTask)
if /i "%taskkillprocessnf%"=="svchost.exe" (echo Access denied) else (taskkill /im %taskkillprocessnf%)
echo.
echo EndTask:%taskkillprocessnf% No forced >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:accessdeniedEndTask
echo Access denied
echo.
goto swh
:tskillyfPID
set /p taskkillprocessPIDf=Process to finish (PID): 
taskkill.exe /f /pid %taskkillprocessPIDf%
echo.
echo EndTask:%taskkillprocessPIDf% Forced>> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh
:tskillnfPID
set /p taskkillprocessPIDnf=Process to finish (PID): 
taskkill /pid %taskkillprocessPIDnf%
echo.
echo EndTask:%taskkillprocessPIDnf% No forced >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh


:rfolder
set /p removefolder=Folder to remove: 
set removefolderexist="%removefolder%"
if /I not exist "%removefolder%" (
	echo "%removefolder%" does not exist. Check that you writted the correct folder name
	echo.
	goto swh
)
set /p surerfolder=Are you sure that do you want to remove %removefolder%? (y/n): 
if /i "%surerfolder%"=="y" (
	:removefl235
	rd %removefolder%
	echo removefolder: %removefolder% > %pathswh%\SWH_History.txt
	echo.
	goto swh
) else (
	echo.
	goto swh
)

:copyfiles
echo.
echo Note: If the file has spaces, please type ""
set /p copyfiles1rt=Files to copy: 
set /p copyfiles2rt=Destination of copied files (If you type a filename, the file will be renamed): 
set copyfiles2=
set copyfiles1=
copy %copyfiles1rt% %copyfiles2rt%
echo.
echo Copy: %copyfiles1% -- %copyfiles2% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:msgbox
cd /d %localappdata%\ScriptingWindowsHost
set /p whatmsg=Message: With any symbol (1), with a red cross (2), with a question mark (3), with a danger symbol (4) or with an information symbol (5): 
if "%whatmsg%"=="1" (goto msg1)
if "%whatmsg%"=="2" (goto msg2)
if "%whatmsg%"=="3" (goto msg3)
if "%whatmsg%"=="4" (goto msg4)
if "%whatmsg%"=="5" (goto msg5) else (goto inmsg)
:inmsg
echo "%whatmsg%" is not a possible option.
echo.
echo ErrorMsg:%whatmsg% >> %homedrive%\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d "%cdirectory%"
goto swh
:msg1
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",0,"%titlemsgbox%") > SwhMsgBox0.vbs
start /wait SwhMsgBox0.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%,0,SwhMsgBox0.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
:msg2
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",16,"%titlemsgbox%") > SwhMsgBox16.vbs
start /wait SwhMsgBox16.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%,16,SwhMsgBox16.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
:msg3
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",32,"%titlemsgbox%") > SwhMsgBox32.vbs
start /wait SwhMsgBox32.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%,32,SwhMsgBox.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
echo
:msg4
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",48,"%titlemsgbox%") > SwhMsgBox48.vbs
start /wait SwhMsgBox48.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%, SwhMsgBox48.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh

:msg5
set /p textmsgbox=Text to say in the message box: 
set /p titlemsgbox=Title to say in the message box: 
echo swh=msgbox("%textmsgbox%",64,"%titlemsgbox%") > SwhMsgBox64.vbs
start /wait SwhMsgBox64.vbs
echo.
echo Msgbox;text:%textmsgbox%,title:%titlemsgbox%, SwhMsgBox64.vbs >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
cd /d %cdirectory%
goto swh
echo

:chdate
echo.
echo Date: %date%
echo.
echo Note: change date requires administrator permission
echo.
set /p newdateday=Day: 
set /p newdatemonth=Month: 
set /p newdateyear=Year: 
echo.
set /p surenewdate=Are you sure that you would change the date? (y/n) 
if %surenewdate%==y (
	date %newdateday%-%newdatemonth%-%newdateyear%
	echo.
	echo Date:%newdateday%-%newdatemonth%-%newdateyear% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	echo.
	goto swh
)
:chtime
echo.
echo Time: %time%
echo.
echo Note: change time requires administrator permission
echo.
set /p newhourS=Seconds: 
set /p newhourMIN=Minutes: 
set /p newhourH=Hours: 
echo surenewhour=Are you sure that you would change the hour? (y/n) 
if %surenewhour%==y (
	time %newhourH%:%newhourMIN%:%newhourS%
	echo.
	echo Time:%newhourH%:%newhourMIN%:%newhourS%>> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	echo.
	goto swh
)

:echosay
set /p say=Text to say: 
echo.
echo %say%
echo.
echo Say:%say% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:credits
echo.
echo Credits:
echo.
echo Developper: anic17
echo Coded with: Batch, VBScript, Power
echo.
echo Credits >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo (c) Copyright 2019 SWH. All rights reserved
pause>nul
echo.
goto swh

:dir
dir
echo.
echo dir:%cd% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:rename
set /p filetorename=File to rename: 
if not exist %filetorename% (
	echo %filetorename% does not exist!
	echo Please verify that %filetorename% is in the correct location.
	echo.
	echo Rename: Error: %filetorename% does not exist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	goto swh
) else (
	goto yesrename
)
:yesrename
set /p newnamefile=New name of %filetorename%: 
if %filetorename%==%newnamefile% (
	echo The two names are the same.
	echo Please write a different name.
	echo.
	echo Rename: Error: Two names are the same (%newnamefile%) >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
	echo.
	goto swh
) else (
	ren %filetorename% %newnamefile%
	echo Rename: %filetorename% --^> %newnamefile%
	echo.
	goto swh
)

:calc
echo.
echo SWH calculator is based in a 32 bits system
echo It will only be capable to make operations less than 2 147 483 648 (2,147 billion)
echo.
set /p whatcalc=Addition (1), subtraction (2), multiplication (3), division (4): 
if %whatcalc%==1 (goto calcsuma)
if %whatcalc%==2 (goto calcresta)
if %whatcalc%==3 (goto calcmulti)
if %whatcalc%==4 (goto calcdiv) else (goto incocalc)

:incocalc
echo "%whatcalc%" is not an existing option.
echo.
goto swh
:calcsuma
set /p firstnumbersuma=First number: 
set /p secondnumbersuma=Second number: 
set /a resultsuma=%firstnumbersuma%+%secondnumbersuma%
echo %resultsuma%
echo.
echo CalcAdd:%firstnumbersuma%+%secondnumbersuma%=%resultsuma% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh
:calcresta
set /p firstnumberresta=First number: 
set /p secondnumberresta=Second number: 
set /a resultresta=%firstnumberresta%-%secondnumberresta%
echo %resultresta%
echo.
echo CalcSub:%firstnumberresta%-%secondnumberresta%=%resultresta% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh
:calcmulti
set /p firstnumbermulti=First number: 
set /p secondnumbermulti=Second number: 
set /a resultmulti=%firstnumbermulti%*%secondnumbermulti%
echo %resultmulti%
echo CalcMulti:%firstnumbermulti%*%secondnumbermulti%=%resultmulti% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
goto swh
:calcdiv
set /p firstnumberdivision=First number: 
set /p secondnumberdivision=Second number: 
set /a resultdivision=%firstnumberdivision%/%secondnumberdivision%
echo %resultdivision%
echo CalcDiv:%firstnumberdivision%/%secondnumberdivision%=%resultdivision% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
echo.
goto swh

:consize
set /p colmodesize=Columns of SWH console: 
set /p linemodesize=Lines of SWH console: 
mode con: cols=%colmodesize% lines=%linemodesize%
echo.
if %colmodesize%==0 (goto settingssizemodecon1)
echo Console:Cols:%colmodesize%,Line:%linemodesize% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\SWH_History.txt
goto swh

:scriptproject
cls
echo Welcome to the Scripting Windows Host Project Creator
title Scripting Windows Host Project Maker
echo If you need help, you can type on SWH Console "helpproject"
echo.
echo This project will be created in C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects
set /p projectname=Project name: 
echo.
echo @echo off > C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd

:commandPROJECT
set /p commandsproject=Commands to do the project: 
:other1PROJECT
if %commandsproject%==execute (goto startPROJECT)
if %commandsproject%==folder (goto mkdirPROJECT)
if %commandsproject%==shutdown (goto shutdownPROJECT)
if %commandsproject%==cd (goto cdPROJECT)
if %commandsproject%==file (goto filePROJECT)
if %commandsproject%==clear (goto clsPROJECT)
if %commandsproject%==del (goto delPROJECT)
if %commandsproject%==color (goto colorPROJECT)
if %commandsproject%==endtask (goto taskkillPROJECT)
if %commandsproject%==tasklist (goto tasklistPROJECT)
if %commandsproject%==taskmgr (goto taskmgrPROJECT)
if %commandsproject%==removefolder (goto rfolderPROJECT)
if %commandsproject%==exit (exitPROJECT)
if %commandsproject%==copy (goto copyfilesPROJECT)
if %commandsproject%==cmd (goto cmdscreenPROJECT)
if %commandsproject%==swh (goto startswhPROJECT)
if %commandsproject%==msg (goto msgboxPROJECT)
if %commandsproject%==date (goto chdatePROJECT)
if %commandsproject%==time (goto chtimePROJECT)
if %commandsproject%==say (goto echosayPROJECT)
if %commandsproject%==credits (goto creditsPROJECT)
if %commandsproject%==directory (goto dirPROJECT)
if %commandsproject%==dir (goto dirPROJECT)
if %commandsproject%==cancelshutdown (goto cancelshutdownPROJECT)
if %commandsproject%==renamefile (goto renamePROJECT)
if %commandsproject%==history (goto historyPROJECT)
if %commandsproject%==clearhistory (goto clearhistoryPROJECT)
if %commandsproject%==calc (goto calcPROJECT)
if %commandsproject%==calculator (goto calcPROJECT)
if %commandsproject%==size (goto consizePROJECT)
if %commandsproject%==project (goto scriptprojectPROJECT)
if %commandsproject%==helpproject (goto HelpProjectPROJECT)
if %commandsproject%==exit (goto goingswh) else (goto incommandPROJECT)

:goingswh
echo.
cls
goto startswh
:startPROJECT
set /p startexecPROJECT=Program or file to execute (%projectname%): 
echo start %startexecPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT

:incommandPROJECT
echo "%commandsproject%" don't exist or is it unavaiable for SWH Projects!
echo.
goto swh
:mkdirPROJECT
echo Location of the folder (%projectname%): 
set /p foldername=Folder name: 
echo mkdir %foldername% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
:shutdownPROJECT
set /p sdORrst=Shutdown (1) or restart (2) (%projectname%): 
if %sdORrst%==1 (goto shutdownPROJECTsd) else (goto restartPROJECTrst)
:restartPROJECTrst
set /p timerstPROJECT=Time to restart computer (%projectname%): 
echo shutdown -r -t %timerstPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
goto commandPROJECT
:shutdownPROJECTsd
set /p timesdPROJECT=Time to shut down computer (%projectname%): 
echo shutdown -s -t %timesdPROJECT >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
goto commandPROJECT

:cdPROJECT
set /p cdPROJECT=Directory to access (%projectname%): 
echo cd %cdPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
goto commandPROJECT
:filePROJECT
set /p filenamePROJECT=Name of the file (%projectname%): 
:filetextPROJECT
set /p textPROJECT=Text of the file (Write "None" to stop writing the file): 
if %textPROJECT%==None (goto filecreatedPROJECT) else (goto filetextPROJECT)
echo %textPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
:filecreatedPROJECT
echo.
goto commandPROJECT
:scriptprojectPROJECT
echo "project" can't be executed as a project file.
echo.
goto swh
:clsPROJECT
echo cls >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:delPROJECT
set /p delPROJECT=File to delete (%projectname%): 
echo del %delPROJECT% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:colorPROJECT
set /p textcolor=Color of text (%projectname%): 
set /p backgroundcolor=Color of background (%projectname%): 
echo color %backgroundcolor%%textcolor% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:taskkillPROJECT
set /p taskkillPROJECT=Process to finish (%projectname%): 
echo taskkill /f /im %projectname% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:tasklistPROJECT
echo tasklist >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:rfolderPROJECT
set /p removefolderPROJECT=Folder to remove (%projectname%): 
echo rd %projectname% >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:exitswhPROJECT
echo.
goto swh
:copyfilesPROJECT
set /p copyfiles1rtPROJECT=Files to copy (%projectname%): 
set /p copyfiles2rtPROJECT=Files to move (%projectname%): 
echo copy "%copyfiles1rtPROJECT%" "%copyfiles2rtPROJECT%" >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:cmdscreenPROJECT
echo start >> C:\Users\%username%\AppData\Local\ScriptingWindowsHost\MyProjects\%projectname%.cmd
echo.
goto commandPROJECT
:startswhPROJECT
echo "startswh" is not a valid optin for SWH Projects
echo.
goto commandPROJECT