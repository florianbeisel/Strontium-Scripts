#!/bin/bash

date
if [ "$(ps aux|egrep -v 'grep|pigmap.sh'|egrep 'python|rsync|pigmap')" ] 
then
	echo Running process found exiting
	exit 0
else
	echo "Starting Update"

	cd /home/minecraft/pigmap
        sh ../scripts/server.sh stopsave

	rsync -vur --delete ../server/Strontium/ maps/Strontium > Strontium.chunklist
	rsync -vur --delete ../server/EyeOfTerror/ maps/EyeOfTerror > EyeOfTerror.chunklist
       #rsync -vur --delete [...]

        sh ../scripts/server.sh startsave

	nice -19 ./pigmap -i maps/Strontium -g images -o output/Strontium -r Strontium.chunklist -h 2 -x
	nice -19 ./pigmap -i maps/EyeOfTerror -g images -o output/EyeOfTerror -r EyeOfTerror.chunklist -h 2 -x

	#python gmap.py --cachedir=cache/Strontium/unlit -p2 maps/Strontium/ output/Strontium/
	#python gmap.py --cachedir=cache/EyeOfTerror/unlit -p2 maps/EyeOfTerror/ output/EyeOfTerror/

fi
date
