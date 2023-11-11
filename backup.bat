@echo off
if "%~2" == "" exit /b
if not "%~3" == "" exit /b
pushd "%~dp0"
if /i "%~1" == "-b" call :backup %2
if /i "%~1" == "-r" call :restore %2
if /i "%~2" == "-b" call :backup %1
if /i "%~2" == "-r" call :restore %1
popd
exit /b

:backup
echo su> temp.sh
echo cd /data/data>> temp.sh
echo tar zcf %1.user.tgz ./%1>> temp.sh
echo mv ./%1.user.tgz /storage/emulated/0>> temp.sh
echo cd /storage/emulated/0/Android/data>> temp.sh
echo tar zcf %1.storage.tgz ./%1>> temp.sh
echo mv ./%1.storage.tgz /storage/emulated/0>> temp.sh
echo cd /data/user_de/0>> temp.sh
echo tar zcf %1.user_de.tgz ./%1>> temp.sh
echo mv ./%1.user_de.tgz /storage/emulated/0>> temp.sh
echo cd /storage/emulated/0/Android/media>> temp.sh
echo tar zcf %1.media.tgz ./%1>> temp.sh
echo mv ./%1.media.tgz /storage/emulated/0>> temp.sh
echo exit>> temp.sh
echo exit>> temp.sh
adb.exe shell < temp.sh
del temp.sh
adb.exe pull /storage/emulated/0/%1.user.tgz
adb.exe pull /storage/emulated/0/%1.storage.tgz
adb.exe pull /storage/emulated/0/%1.user_de.tgz
adb.exe pull /storage/emulated/0/%1.media.tgz
echo su> temp.sh
echo rm /storage/emulated/0/%1.user.tgz>> temp.sh
echo rm /storage/emulated/0/%1.storage.tgz>> temp.sh
echo rm /storage/emulated/0/%1.user_de.tgz>> temp.sh
echo rm /storage/emulated/0/%1.media.tgz>> temp.sh
echo exit>> temp.sh
echo exit>> temp.sh
adb.exe shell < temp.sh
del temp.sh
exit /b

:restore
adb.exe push %1.user.tgz /storage/emulated/0
adb.exe push %1.storage.tgz /storage/emulated/0
adb.exe push %1.user_de.tgz /storage/emulated/0
adb.exe push %1.media.tgz /storage/emulated/0
echo su> temp.sh
echo am force-stop %1>> temp.sh
echo cd /data/data>> temp.sh
echo mv /storage/emulated/0/%1.user.tgz .>> temp.sh
echo tar zxf %1.user.tgz>> temp.sh
echo rm ./%1.user.tgz>> temp.sh
echo cd /storage/emulated/0/Android/data>> temp.sh
echo mv /storage/emulated/0/%1.storage.tgz .>> temp.sh
echo tar zxf %1.storage.tgz>> temp.sh
echo rm ./%1.storage.tgz>> temp.sh
echo cd /data/user_de/0>> temp.sh
echo mv /storage/emulated/0/%1.user_de.tgz .>> temp.sh
echo tar zxf %1.user_de.tgz>> temp.sh
echo rm ./%1.user_de.tgz>> temp.sh
echo cd /storage/emulated/0/Android/media>> temp.sh
echo mv /storage/emulated/0/%1.media.tgz .>> temp.sh
echo tar zxf %1.media.tgz>> temp.sh
echo rm ./%1.media.tgz>> temp.sh
echo cd />> temp.sh
echo UID=`dumpsys package %1 ^| grep userId`>> temp.sh
echo UID=${UID##*=}>> temp.sh
echo chown -R $UID:$UID /data/data/%1>> temp.sh
echo restorecon -R /data/data/%1>> temp.sh
echo chown -R $UID:$UID /storage/emulated/0/Android/data/%1>> temp.sh
echo restorecon -R /storage/emulated/0/Android/data/%1>> temp.sh
echo chown -R $UID:$UID /data/user_de/0/%1>> temp.sh
echo restorecon -R /data/user_de/0/%1>> temp.sh
echo chown -R $UID:$UID /storage/emulated/0/Android/media/%1>> temp.sh
echo restorecon -R /storage/emulated/0/Android/media/%1>> temp.sh
echo exit>> temp.sh
echo exit>> temp.sh
adb.exe shell < temp.sh
del temp.sh
exit /b

