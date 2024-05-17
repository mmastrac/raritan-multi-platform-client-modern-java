java -Djava.security.properties=java.security -cp sMpc.jar:sClientLib.jar:sFoxtrot.jar com.raritan.rrc.ui.RRCApplication &
while true;
do
    echo Looking
    (wmctrl -l | grep "Raritan") && break
    sleep 1
done
echo Found
wmctrl -r "Raritan Multi-Platform Client" -b toggle,fullscreen
