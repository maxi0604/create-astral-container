#!/bin/sh
if [ "$EULA" = "TRUE" ]; then
	echo "# EULA accepted semi-automatically by container.\ 
    eula=true" >eula.txt
	exec java "$JVM_ARGS" -jar server.jar --nogui
else
	echo "Mojang EULA not accepted. Run with -e EULA=TRUE to accept."
fi
