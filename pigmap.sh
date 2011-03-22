#!/bin/bash

declare -a worlds=(Kubo Nether)
numworlds=${#worlds[@]}

date
if [ "$(ps aux|egrep -v 'grep|pigmap.sh'|egrep 'python|rsync|pigmap')" ] 
then
	echo Running process found exiting
	exit 0
else
	echo "Starting Update"

	cd /home/minecraft/pigmap
    sh ../scripts/server.sh stopsave

    for ((i=0;i<$numworlds;i++)); do
        rsync -vur --delete ../server/${worlds[$i]}/ maps/${worlds[$i]} > ${worlds[$i]}.chunklist
    done

    sh ../scripts/server.sh startsave
    
    for ((i=0;i<$numworlds;i++)); do
        nice 19 ./pigmap -i maps/${worlds[$i]} -g images -o output/${worlds[$i]} -r ${worlds[$i]}.chunklist -h 2 -x
    done

fi
date
