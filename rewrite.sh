#!/bin/bash
set -eu -o pipefail

JAVA=`which java`
BUILD=build/
DIST=build/dist/

rm -rf $BUILD || true
mkdir $BUILD

echo Extracting installer...
unzip inputs/orig/mpc-installer.MPC_7.0.3.5.62.jar.zip -d $BUILD > build/install.log
$JAVA -jar $BUILD/mpc-installer.MPC_7.0.3.5.62.jar -options inputs/orig/install.properties 2>&1 > build/install.log

rm -rf $BUILD
mkdir $BUILD
mkdir $DIST

cp /tmp/raritan-temp/Raritan*.app/Contents/Resources/Java/*.jar $BUILD/

cp inputs/app/java.security $DIST/

echo Rewriting jars...
$JAVA -jar inputs/rewrite/proguard.jar @inputs/rewrite/rewrite-all.pro -injars inputs/sunjar/sunbase64.jar:$BUILD/'sClientLib.jar(!META-INF/*)' \
	-outjars $DIST/sClientLib.jar > $BUILD/rewrite1.log
$JAVA -jar inputs/rewrite/proguard.jar @inputs/rewrite/rewrite-all.pro -injars inputs/sunjar/sunbase64.jar:$BUILD/'sMpc.jar(!META-INF/*)' \
	-outjars $DIST/sMpc.jar > $BUILD/rewrite2.log

echo Building app...

cp $BUILD/AmpPb.jar $DIST/
cp $BUILD/jaws.jar $DIST/
cp $BUILD/sdeploy.jar $DIST/
cp $BUILD/sFoxtrot.jar $DIST/

mkdir -p $BUILD/jars
cp $DIST/*.jar $BUILD/jars/

cp inputs/app/run.sh $DIST/run.sh
chmod a+x $DIST/run.sh

APP="$DIST/Raritan MPC.app"
mkdir -p "$APP/Contents/MacOS/"
mv $DIST/run.sh "$APP/Contents/MacOS/Raritan MPC"
mkdir -p "$APP/Contents/Resources/"
mv $DIST/java.security "$APP/Contents/Resources/"
mv $DIST/*.jar "$APP/Contents/Resources/"

cp inputs/app/Info.plist "$APP/Contents/"
cp inputs/app/kvm.icns "$APP/Contents/Resources/"

pushd "$DIST"
zip -9r "RaritanMPC.app.zip" "Raritan MPC.app"
popd

