#!/bin/sh
if [ "$EULA" = "TRUE" ]; then
	echo "# EULA accepted semi-automatically by container.\ 
		eula=true" >eula.txt

	rm -f server.properties
	[ -f "/init/server.properties" ] && cp /init/server.properties server.properties
	touch server.properties

	if [ -n "$RCON_PASSWORD" ]; then
		grep "^rcon.password" server.properties || echo "rcon.password=$RCON_PASSWORD" >>server.properties
		grep "^enable-rcon" server.properties || echo "enable-rcon=true" >>server.properties
	fi

	grep "^sync-chunk-writes" server.properties || echo "sync-chunk-writes=false" >>server.properties
	exec java -Xms6G -Xmx6G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true $JVM_ARGS -jar server.jar --nogui
else
	echo "Mojang EULA not accepted. Run with -e EULA=TRUE to accept."
fi
