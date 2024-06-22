#!/bin/bash
set -eu -o pipefail

JAVA=$(brew --prefix openjdk\@11 || brew --prefix openjdk)/bin/java
BUILD=build/
DIST=build/dist/
INPUT=inputs/orig/mpc-installer.MPC_7.0.3.5.62.jar.zip
INPUT_MD5=82e169d048149182fbfc6a569fe147e1
DOWNLOAD_URL="https://d3b2us605ptvk2.cloudfront.net/download/kxii/v2.7.0/mpc-installer.MPC_7.0.3.5.62.jar.zip"
TEMP_INPUT=/tmp/mpc.jar

echo "Testing Java ($JAVA)..."
$JAVA --version || echo "Brew Java needs to be installed"

rm -rf $BUILD || true
mkdir $BUILD

calculate_md5() {
    if command -v md5sum &> /dev/null; then
        md5sum "$1" | awk '{ print $1 }'
    else
        md5 -q "$1"
    fi
}

# Check if the input file exists and has the correct MD5 hash
if [[ -f "$INPUT" ]]; then
    EXISTING_MD5=$(calculate_md5 "$INPUT")
    if [[ "$EXISTING_MD5" == "$INPUT_MD5" ]]; then
        echo "File already exists and MD5 matches. No download needed."
    else
        echo "File exists but MD5 does not match. Downloading again."
        curl -o "$TEMP_INPUT" "$DOWNLOAD_URL"
        DOWNLOADED_MD5=$(calculate_md5 "$TEMP_INPUT")
        if [[ "$DOWNLOADED_MD5" == "$INPUT_MD5" ]]; then
            mv "$TEMP_INPUT" "$INPUT"
        else
            echo "Downloaded file MD5 does not match. Exiting."
            exit 1
        fi
    fi
else
    echo "File does not exist. Downloading..."
    curl -o "$TEMP_INPUT" "$DOWNLOAD_URL"
    DOWNLOADED_MD5=$(calculate_md5 "$TEMP_INPUT")
    if [[ "$DOWNLOADED_MD5" == "$INPUT_MD5" ]]; then
        mv "$TEMP_INPUT" "$INPUT"
    else
        echo "Downloaded file MD5 does not match. Exiting."
        exit 1
    fi
fi

echo Extracting installer...
unzip $INPUT -d $BUILD > build/install.log
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

bsdiff inputs/orig/mpc-installer.MPC_7.0.3.5.62.jar.zip build/dist/RaritanMPC.app.zip build/dist/RaritanMPC.app.zip.bspatch
