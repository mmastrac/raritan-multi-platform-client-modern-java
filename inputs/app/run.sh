#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"
cd ../Resources

PATH=$PATH:/usr/local/bin/
JAVA=$(brew --prefix openjdk\@11)/bin/java

#set >> /tmp/log.txt
#echo PWD: $(pwd) >> /tmp/log.txt
#echo JAVA: $JAVA >> /tmp/log.txt

$JAVA --version || \
	osascript -e 'tell application (path to frontmost application as text) to display dialog "Could not find OpenJDK 11. Please install via Brew (brew install openjdk@11)." buttons {"OK"} with icon stop'

$JAVA \
	-Xdock:icon=kvm.icns \
	-Xdock:name="Raritan MPC" \
	-Djava.security.properties=java.security \
	-cp sMpc.jar:sClientLib.jar:sFoxtrot.jar com.raritan.rrc.ui.RRCApplication
