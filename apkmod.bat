@echo off
msg * Read the introduction // Lies die Anleitung
setlocal enabledelayedexpansion
COLOR 07
if (%1)==(0) goto skipme
if (%1) neq () goto adbi
:skipme
mode con:cols=81 lines=40
:skipme
set usrc=9
set capp=None
java -version
if errorlevel 1 goto errjava
adb version
if errorlevel 1 goto erradb
set /A count=0
FOR %%F IN (apk-folder/*.APK) DO (
set /A count+=1
set tmpstore=%%~nF%%~xF
)
if %count%==1 (set capp=%tmpstore%)
cls
:restart
cd "%~dp0"
set menunr=GARBAGE
cls
echo.
echo APK Mod ^| Current Project: %capp% ^| 2013
echo.
echo.
echo   Tasks:
echo.
echo   1 Coming Soon
echo   2 Extract APK
echo   3 Zip APK
echo   4 Sign APK (No system APK's)
echo   5 Zipalign APK (Do once APK is created and signed)
echo   6 Install APK (No system APK's, do adb push)
echo   7 Zip, Sign, Install APK (All in one step)
echo   8 ADB push (Only for system APK's)
echo   9 Clean Files and Folders
echo  10 Set your current project
echo.
echo.
echo  11 Google+
echo  12 Twitter
echo  14 Code on GitHub
echo  13 Quit
echo.
echo.
SET /P menunr=Make Your Decision:
IF %menunr%==1 (goto restart)
IF %menunr%==10 (goto filesel)
IF %menunr%==11 (goto gplus)
IF %menunr%==9 (goto cleanp)
if %capp%==None goto noproj
IF %menunr%==2 (goto ex)
IF %menunr%==3 (goto zip)
IF %menunr%==4 (goto si)
IF %menunr%==5 (goto zipa)
IF %menunr%==6 (goto ins)
IF %menunr%==7 (goto alli)
IF %menunr%==8 (goto apu)
IF %menunr%==12 (goto twitter)
IF %menunr%==13 (goto quit)
IF %menunr%==14 (goto github)
:WHAT
echo I guess that number wasn't for the program...
PAUSE
goto restart
:cleanp
echo 1. Clean This Project's Folder
echo 2. Clean All APK's in Modding Folder
echo 3. Clean All APK's in Signing Folder
echo 4. Clean All Projects
echo 5. Clean All Folders/Files
echo 6. Go Back To Main Menu
SET /P menuna=Please make your decision:
echo Clearing Directories
IF %menuna%==1 (
if %capp%==None goto noproj
rmdir /S /Q %userprofile%\APKtool > nul
rmdir /S /Q projects\%capp% > nul
mkdir projects\%capp%
)
IF %menuna%==2 (
rmdir /S /Q %userprofile%\APKtool > nul
rmdir /S /Q apk-folder > nul
mkdir apk-folder
)
IF %menuna%==3 (
rmdir /S /Q sign-apk > nul
mkdir sign-apk
)
IF %menuna%==5 (
rmdir /S /Q %userprofile%\APKtool > nul
rmdir /S /Q projects\%capp% > nul
mkdir projects\%capp%
rmdir /S /Q apk-folder > nul
mkdir apk-folder
rmdir /S /Q sign-apk > nul
mkdir sign-apk
rmdir /S /Q %userprofile%\APKtool > nul
rmdir /S /Q projects > nul
mkdir projects
)
IF %menuna%==4 (
rmdir /S /Q %userprofile%\APKtool > nul
rmdir /S /Q projects > nul
mkdir projects
)
goto restart
:twitter
cls
start http://twitter.com/motravl
goto restart
:gplus
cls
start http://gplus.to/motravl
goto restart
:github
cls
start https://github.com/mtrvl/apk-mod/blob/master/apkmod.bat
goto restart
:filesel
cls
set /A count=0
FOR %%F IN (apk-folder/*.APK) DO (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 (echo ^- !count! - %%F )
if /I !count! GTR 10 (echo ^- !count! - %%F )
)
echo.
echo Choose the app to be set as current project?
set /P INPUT=Enter It's Number: %=%
if /I %INPUT% GTR !count! (goto chc)
if /I %INPUT% LSS 1 (goto chc)
set capp=!a%INPUT%!
goto restart
:chc
set capp=None
goto restart
rem :bins
rem echo Waiting for device
rem adb wait-for-device
rem echo Installing APKs
rem FOR %%F IN ("%~dp0sign-apk\*.APK") DO adb install -r "%%F"
rem goto restart
:alli
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cls
echo 1 System APK (Retains signature)
echo 2 Regular APK (Removes the signature for re-signing)
SET /P menunr=Please make your decision:
IF %menunr%==1 (goto sys1)
IF %menunr%==2 (goto oa1)
:sys1
echo Zipping APK
cd other
7za a -tzip "../apk-folder/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (

PAUSE
)
cd ..
goto si1
:oa1
cd other
echo Zipping APK
rmdir /S /Q "../out/META-INF"
7za a -tzip "../apk-folder/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
PAUSE
)
cd ..
:si1
cd other
echo Signing APK
java -Xmx%heapy%m -jar signAPK.jar -w testkey.x509.pem testkey.pk8 ../apk-folder/unsigned%capp% ../apk-folder/signed%capp%
if errorlevel 1 (
PAUSE
)
DEL /Q "../apk-folder/unsigned%capp%"
cd ..
:ins1
echo Waiting for device
adb wait-for-device
echo Installing APK
adb install -r apk-folder/signed%capp%
if errorlevel 1 (
PAUSE
)
goto restart
:asi
cd other
DEL /Q "../sign-apk/signed.APK"
FOR %%F in (../sign-apk/*) DO call signer "%%F"
cd ..
goto restart
:dan
if (%INPUT%)==(zp) GOTO zipb
if (%INPUT%)==(z) GOTO zipo

:opt
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
mkdir temp
xcopy "%~dp0projects\%capp%\res\*.9.png" "%~dp0temp" /S /Y
cd other
echo Optimizing Png's
roptipng -o99 "../projects/%capp%/**/*.png"
cd ..
xcopy "%~dp0temp" "%~dp0projects\%capp%\res" /S /Y
rmdir temp /S /Q
goto restart
:noproj
PAUSE
goto restart
)
:renameagain
echo What filename would you like this app to be stored as ?
echo Eg (launcher.APK)
set /P INPUT=Type input: %=%
IF EXIST "%~dp0apk-folder\%INPUT%" (
echo File Already Exists, Try Another Name
PAUSE
goto renameagain)
rename "%~dp0apk-folder\something.APK" %INPUT%
echo Would you like to set this as your current project (y/n)?
set /P inab=Type input: %=%
if %inab%==y (set capp=%INPUT%)
goto restart
:zipa
echo Zipaligning APK
IF EXIST "%~dp0apk-folder\signed%capp%" zipalign -f 4 "%~dp0apk-folder\signed%capp%" "%~dp0apk-folder\signedaligned

%capp%"

IF EXIST "%~dp0apk-folder\unsigned%capp%" zipalign -f 4 "%~dp0apk-folder\unsigned%capp%" "%~dp0apk-folder

\unsignedaligned%capp%"

if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
DEL /Q "%~dp0apk-folder\signed%capp%"
DEL /Q "%~dp0apk-folder\unsigned%capp%"
rename "%~dp0apk-folder\signedaligned%capp%" signed%capp%
rename "%~dp0apk-folder\unsignedaligned%capp%" unsigned%capp%
goto restart
:ex
cd other
echo Extracting APK
IF EXIST "../projects/%capp%" (rmdir /S /Q "../projects/%capp%")
7za x -o"../projects/%capp%" "../apk-folder/%capp%"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
cd ..
goto restart
:zip
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cls
echo 1 System APK (Retains signature)
echo 2 Regular APK (Removes the signature for re-signing)
SET /P menunr=Please make your decision:
IF %menunr%==1 (goto sys)
IF %menunr%==2 (goto oa)
:sys
echo Zipping APK
cd other
7za a -tzip "../apk-folder/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)

cd ..
goto restart
:oa
cd other
echo Zipping APK
rmdir /S /Q "../out/META-INF"
7za a -tzip "../apk-folder/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)

cd ..
goto restart
:nq2
rmdir /S /Q "%~dp0keep"
7za x -o"../keep" "../apk-folder/%capp%"
echo In the APK manager folder u'll find
echo a keep folder. Within it, delete
echo everything you have modified and leave
echo files that you haven't. If you have modified
echo any xml, then delete resources.arsc from that
echo folder as well. Once done then press enter
echo on this script.
PAUSE
7za a -tzip "../apk-folder/unsigned%capp%" "../keep/*" -mx%usrc% -r
rmdir /S /Q "%~dp0keep"
cd ..
goto restart
:nq3
7za x -o"../projects/temp" "../apk-folder/%capp%" META-INF -r
7za a -tzip "../apk-folder/unsigned%capp%" "../projects/temp/*" -mx%usrc% -r
rmdir /S /Q "%~dp0projects/temp"
:q1
cd ..
goto restart
:si
cd other
echo Signing APK
java -Xmx%heapy%m -jar signAPK.jar -w testkey.x509.pem testkey.pk8 ../apk-folder/unsigned%capp% ../apk-folder/signed%capp%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)

DEL /Q "../apk-folder/unsigned%capp%"
cd ..
goto restart
:ins
echo Waiting for device
adb wait-for-device
echo Installing APK
adb install -r apk-folder/signed%capp%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
goto restart
:all
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cd other
echo Building APK
IF EXIST "%~dp0apk-folder\unsigned%capp%" (del /Q "%~dp0apk-folder\unsigned%capp%")
java -Xmx%heapy%m -jar APKtool.jar b "../projects/%capp%" "%~dp0apk-folder\unsigned%capp%"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
goto restart
)
echo Signing APK
java -Xmx%heapy%m -jar signAPK.jar -w testkey.x509.pem testkey.pk8 ../apk-folder/unsigned%capp% ../apk-folder/signed%capp%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
DEL /Q "../apk-folder/unsigned%capp%"
cd ..
echo Waiting for device
adb wait-for-device
echo Installing APK
adb install -r apk-folder/signed%capp%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
goto restart
:errjava
cls
echo Java was not found, install Java to use the programm
PAUSE
goto restart
:erradb
cls
echo Adb was not found, install ADB to modify APK's
PAUSE
goto restart
:adbi
mode con:cols=48 lines=8
echo Waiting for device
adb wait-for-device
set count=0
:loop
if "%~n1"=="" goto :endloop
echo Installing %~n1
adb install -r %1
shift
set /a count+=1
goto :loop
:endloop
goto quit
:endab
cd ..
@echo Optimization complete for %~1
:quit
