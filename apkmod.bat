@echo off
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
FOR %%F IN (place-APK-here-for-modding/*.APK) DO (
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
echo  APK Mod ^| Current Project: %capp% ^| 2013
echo.
echo.
echo  Simple Tasks:
echo.
echo   1   Coming Soon
echo   2   Extract APK
echo   3   Zip APK 
echo   4   Sign APK (No system APK's)
echo   5   Zipalign APK (Do once APK is created and signed)
echo   6   Install APK (No system APK's, do adb push)
echo   7   Zip, Sign, Install APK (All in one step)
echo   8   ADB push (Only for system APK's)
echo.
echo   9   Clean Files and Folders
echo  10   Set your current project
echo  11   About 
echo  12   Google+
echo  13   Twitter
echo  14   Quit
echo.
echo.
SET /P menunr=Make Your Decision:
IF %menunr%==1 (goto restart)
IF %menunr%==10 (goto filesel)
IF %menunr%==12 (goto gplus)
IF %menunr%==9 (goto cleanp)
if %capp%==None goto noproj
IF %menunr%==2 (goto ex)
IF %menunr%==3 (goto zip)
IF %menunr%==4 (goto si)
IF %menunr%==5 (goto zipa)
IF %menunr%==6 (goto ins)
IF %menunr%==7 (goto alli)
IF %menunr%==8 (goto apu)
IF %menunr%==11 (goto about)
IF %menunr%==13 (goto twitter)
IF %menunr%==14 (goto quit)
:WHAT
echo I guess that number wasn't for the program...
PAUSE
goto restart
:cleanp
echo 1. Clean This Project's Folder
echo 2. Clean All APK's in Modding Folder
echo 3. Clean All OGG's in OGG Folder
echo 4. Clean All APK's in Optimize Folder
echo 5. Clean All APK's in Signing Folder
echo 6. Clean All Projects
echo 7. Clean All Folders/Files
echo 8. Go Back To Main Menu
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
rmdir /S /Q place-APK-here-for-modding > nul
mkdir place-APK-here-for-modding
)
IF %menuna%==5 (
rmdir /S /Q place-APK-here-for-signing > nul
mkdir place-APK-here-for-signing
)
IF %menuna%==7 (
rmdir /S /Q %userprofile%\APKtool > nul
rmdir /S /Q projects\%capp% > nul
mkdir projects\%capp%
rmdir /S /Q place-APK-here-for-modding > nul
mkdir place-APK-here-for-modding
rmdir /S /Q place-APK-here-for-signing > nul
mkdir place-APK-here-for-signing
rmdir /S /Q %userprofile%\APKtool > nul
rmdir /S /Q projects > nul
mkdir projects
)
IF %menuna%==6 (
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
:about
cls
echo.
echo About:
echo.
echo APK Mod 1.0
echo APKTool v1.3.2
echo 7za v4.6.5
echo Android Asset Packaging Tool v0.2
echo.
echo 1. Create log
echo 2. Go back to main menu
echo.
SET /P menunr=Make Your Decision:
IF %menunr%==1 (Start "Adb Log" other\signer 2)
goto restart
:portAPK
echo Im going to try resigning the APK and see if that works
echo Did it successfully install (y/n) ^?
echo Ok, lets try looking through for any shared uid, if i find any i will remove them
:filesel
cls
set /A count=0
FOR %%F IN (place-APK-here-for-modding/*.APK) DO (
set /A count+=1
set a!count!=%%F
if /I !count! LEQ 9 (echo ^- !count!  - %%F )
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
rem FOR %%F IN ("%~dp0place-APK-here-for-signing\*.APK") DO adb install -r "%%F"
rem goto restart
:alli
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cls
echo 1    System APK (Retains signature)
echo 2    Regular APK (Removes signature for re-signing)
SET /P menunr=Please make your decision: 
IF %menunr%==1 (goto sys1)
IF %menunr%==2 (goto oa1)
:sys1
echo Zipping APK
cd other
7za a -tzip "../place-APK-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (

PAUSE
)
cd ..
goto si1
:oa1
cd other
echo Zipping APK
rmdir /S /Q "../out/META-INF"
7za a -tzip "../place-APK-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
PAUSE
)
cd ..
:si1
cd other
echo Signing APK
java -Xmx%heapy%m -jar signAPK.jar -w testkey.x509.pem testkey.pk8 ../place-APK-here-for-modding/unsigned%capp% ../place-APK-here-for-modding/signed%capp%
if errorlevel 1 (
PAUSE
)
DEL /Q "../place-APK-here-for-modding/unsigned%capp%"
cd ..
:ins1
echo Waiting for device
adb wait-for-device
echo Installing APK
adb install -r place-APK-here-for-modding/signed%capp%
if errorlevel 1 (
PAUSE
)
goto restart
:asi
cd other
DEL /Q "../place-APK-here-for-signing/signed.APK"
FOR %%F in (../place-APK-here-for-signing/*) DO call signer "%%F"
cd ..
goto restart
:dan
if (%INPUT%)==(zp) GOTO zipb
if (%INPUT%)==(z) GOTO zipo
:zipb
@echo Optimizing %~1...
cd other
md "APKopt_temp_%~n1"
md optimized
dir /b
7za x -o"APKopt_temp_%~n1" "../place-APK-here-to-batch-optimize/%~n1%~x1"
mkdir temp
xcopy "APKopt_temp_%~n1\res\*.9.png" "temp" /S /Y
roptipng -o99 "APKopt_temp_%~n1\**\*.png"
del /q "..\place-APK-here-to-batch-optimize\%~n1%~x1"
xcopy "temp" "APKopt_temp_%~n1\res" /S /Y
rmdir "temp" /S /Q
if (%INPUT%)==(p) GOTO ponly
7za a -tzip "optimized\%~n1.unaligned.APK" "%~dp0other\APKopt_temp_%~n1\*" -mx%usrc% 
rd /s /q "APKopt_temp_%~n1"
zipalign -v 4 "optimized\%~n1.unaligned.APK" "optimized\%~n1.APK"
del /q "optimized\%~n1.unaligned.APK"
goto endab
:ponly
7za a -tzip "optimized\%~n1.APK" "%~dp0other\APKopt_temp_%~n1\*" -mx%usrc%
rd /s /q "APKopt_temp_%~n1"
goto endab
:zipo
@echo Optimizing %~1...
zipalign -v 4 "%~dp0place-APK-here-to-batch-optimize\%~n1%~x1" "%~dp0place-APK-here-to-batch-optimize\u%~n1%~x1"
del /q "%~dp0place-APK-here-to-batch-optimize\%~n1%~x1"
rename "%~dp0place-APK-here-to-batch-optimize\u%~n1%~x1" "%~n1%~x1"
goto endab
:dirnada
echo %capp% has not been extracted, please do so before doing this step
PAUSE
goto restart
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
:ap
echo Where do you want adb to pull the APK from? 
echo Example of input : /system/app/launcher.APK
set /P INPUT=Type input: %=%
echo Pulling APK
adb pull %INPUT% "%~dp0place-APK-here-for-modding\something.APK"
if errorlevel 1 (
PAUSE
goto restart
)
:renameagain
echo What filename would you like this app to be stored as ?
echo Eg (launcher.APK)
set /P INPUT=Type input: %=%
IF EXIST "%~dp0place-APK-here-for-modding\%INPUT%" (
echo File Already Exists, Try Another Name
PAUSE
goto renameagain)
rename "%~dp0place-APK-here-for-modding\something.APK" %INPUT%
echo Would you like to set this as your current project (y/n)?
set /P inab=Type input: %=%
if %inab%==y (set capp=%INPUT%)
goto restart
:zipa
echo Zipaligning APK
IF EXIST "%~dp0place-APK-here-for-modding\signed%capp%" zipalign -f 4 "%~dp0place-APK-here-for-modding\signed%capp%" "%~dp0place-APK-here-for-modding\signedaligned

%capp%"

IF EXIST "%~dp0place-APK-here-for-modding\unsigned%capp%" zipalign -f 4 "%~dp0place-APK-here-for-modding\unsigned%capp%" "%~dp0place-APK-here-for-modding

\unsignedaligned%capp%"

if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
DEL /Q "%~dp0place-APK-here-for-modding\signed%capp%"
DEL /Q "%~dp0place-APK-here-for-modding\unsigned%capp%"
rename "%~dp0place-APK-here-for-modding\signedaligned%capp%" signed%capp%
rename "%~dp0place-APK-here-for-modding\unsignedaligned%capp%" unsigned%capp%
goto restart
:ex
cd other
echo Extracting APK
IF EXIST "../projects/%capp%" (rmdir /S /Q "../projects/%capp%")
7za x -o"../projects/%capp%" "../place-APK-here-for-modding/%capp%"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
cd ..
goto restart
:zip
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cls
echo 1    System APK (Retains signature)
echo 2    Regular APK (Removes signature for re-signing)
SET /P menunr=Please make your decision: 
IF %menunr%==1 (goto sys)
IF %menunr%==2 (goto oa)
:sys
echo Zipping APK
cd other
7za a -tzip "../place-APK-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
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
7za a -tzip "../place-APK-here-for-modding/unsigned%capp%" "../projects/%capp%/*" -mx%usrc%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)

cd ..
goto restart
:nq2
rmdir /S /Q "%~dp0keep"
7za x -o"../keep" "../place-APK-here-for-modding/%capp%"
echo In the APK manager folder u'll find
echo a keep folder. Within it, delete 
echo everything you have modified and leave
echo files that you haven't. If you have modified
echo any xml, then delete resources.arsc from that 
echo folder as well. Once done then press enter 
echo on this script.
PAUSE
7za a -tzip "../place-APK-here-for-modding/unsigned%capp%" "../keep/*" -mx%usrc% -r
rmdir /S /Q "%~dp0keep"
cd ..
goto restart
:nq3
7za x -o"../projects/temp" "../place-APK-here-for-modding/%capp%" META-INF -r
7za a -tzip "../place-APK-here-for-modding/unsigned%capp%" "../projects/temp/*" -mx%usrc% -r
rmdir /S /Q "%~dp0projects/temp"
:q1
cd ..
goto restart
:si
cd other
echo Signing APK
java -Xmx%heapy%m -jar signAPK.jar -w testkey.x509.pem testkey.pk8 ../place-APK-here-for-modding/unsigned%capp% ../place-APK-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)

DEL /Q "../place-APK-here-for-modding/unsigned%capp%"
cd ..
goto restart
:ins
echo Waiting for device
adb wait-for-device
echo Installing APK
adb install -r place-APK-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
goto restart
:all
IF NOT EXIST "%~dp0projects\%capp%" GOTO dirnada
cd other
echo Building APK
IF EXIST "%~dp0place-APK-here-for-modding\unsigned%capp%" (del /Q "%~dp0place-APK-here-for-modding\unsigned%capp%")
java -Xmx%heapy%m -jar APKtool.jar b "../projects/%capp%" "%~dp0place-APK-here-for-modding\unsigned%capp%"
if errorlevel 1 (
echo "An Error Occured"
PAUSE
goto restart
)
echo Signing APK
java -Xmx%heapy%m -jar signAPK.jar -w testkey.x509.pem testkey.pk8 ../place-APK-here-for-modding/unsigned%capp% ../place-APK-here-for-modding/signed%capp%
if errorlevel 1 (
echo "An Error Occured"
PAUSE
)
DEL /Q "../place-APK-here-for-modding/unsigned%capp%"
cd ..
echo Waiting for device
adb wait-for-device
echo Installing APK
adb install -r place-APK-here-for-modding/signed%capp%
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
