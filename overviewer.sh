#!/bin/bash

if [ "$(ps aux|grep -v grep|egrep 'python|rsync')" ] 
then
	echo Running process found exiting
	exit 0
else
	echo "Starting Update"

	cd /home/minecraft/overviewer
        sh ../scripts/server.sh stopsave

	rsync -vur --delete ../server/Strontium/ maps/Strontium > Strontium.chunklist
	rsync -vur --delete ../server/EyeOfTerror/ maps/EyeOfTerror > EyeOfTerror.chunklist
       #rsync -vur --delete [...]

        sh ../scripts/server.sh startsave

	python gmap.py --cachedir=cache/Strontium/unlit -p2 maps/Strontium/ output/Strontium/
	python gmap.py --cachedir=cache/EyeOfTerror/unlit -p2 maps/EyeOfTerror/ output/EyeOfTerror/

fi
