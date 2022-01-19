#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$SCRIPT_DIR"
cd ../Resources
pwd
[ -d '/usr/local/opt/openjdk@11/bin/' ] || \
	osascript -e 'tell application (path to frontmost application as text) to display dialog "Could not find OpenJDK 11. Please install via Brew." buttons {"OK"} with icon stop'
PATH='/usr/local/opt/openjdk@11/bin/':$PATH \
	java \
		-Xdock:icon=kvm.icns \
		-Xdock:name="Raritan MPC" \
		-Djava.security.properties=java.security \
		-cp sMpc.jar:sClientLib.jar:sFoxtrot.jar com.raritan.rrc.ui.RRCApplication
