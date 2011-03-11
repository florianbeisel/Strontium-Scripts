#!/bin/bash
# Simple bukkit startup script by Piffey
# This is by no means a clean script, but it will get the job done.
# Suggestions? Improvements? Let me know at Piffey.com
 
# All of the screen stuff was adapted from ragon's <frederik.engels24 AT gmail DOT com> script for his Arch Linux package.
# Reason: I don't use screen, but it's likely the best option for anyone looking for a simple script they can run and ignore.
# His script worked perfect for my first server too. Thanks ragon.
 
# Set these values to match your server's settings.
 
backupdir=/home/minecraft/backup/
bukkitdir=/home/minecraft/server/
bukkitfilename=craftbukkit.jar
bukkitupdate=craftbukkit-updater.jar
 
backupmsg="You's a big fine server, won't ya back that thing up. World file who ya playin wit, back dat thing up."
 
dateformat=$(date '+%Y%m%dh%Hm%M')
 
# Make sure you change this to the name of your world folder! Add additional worlds by separating them with a white space. If you only have one world, change this to have only one value like "world" or "creative".
declare -a worlds=(Strontium EyeOfTerror)
numworlds=${#worlds[@]}
 
# Set these for the amount of RAM you want to allocate. Good practice is to have the numbers match.
# This is the Java heap max and initial size.
 
javaparams="-server -Xmx5500M -Xms2048M"
 
# You can find this location with "whereis java". Make sure this points to the binary.
 
javaloc=/usr/bin/java
 
# This currently points to the "preferred" release for bukkit which is kind of like a stable version.
# Change this value if you want to use the snapshot release.
bukkiturl=http://ci.bukkit.org/job/dev-CraftBukkit/promotion/latest/Recommended/artifact/target/craftbukkit-0.0.1-SNAPSHOT.jar
 
startbukkit()
{
    if [ "$(screen -ls | grep bukkit)" == "" ] ; then
        cd $bukkitdir
        screen -S bukkit -dmS $javaloc $javaparams -jar $bukkitdir$bukkitfilename
        echo "Starting bukkit server."
    else
        echo "Bukkit is already running."
        exit 0
    fi
}
 
stopbukkit()
{
    if [ "$(screen -ls | grep bukkit)" == "" ] ; then
        echo "Bukkit is not running."
        exit 0
    else
        screen -S bukkit -p 0 -X stuff "stop$(echo -ne '\r')"
        sleep 5
    fi
}

stopsave()
{
    if [ "$(screen -ls | grep bukkit)" == "" ] ; then
        echo "Bukkit is not running."
        exit 0
    else
        screen -S bukkit -p 0 -X stuff "save-all$(echo -ne '\r')"
        screen -S bukkit -p 0 -X stuff "save-off$(echo -ne '\r')"
        sleep 5
    fi
}

startsave()
{
    if [ "$(screen -ls | grep bukkit)" == "" ] ; then
        echo "Bukkit is not running."
        exit 0
    else
        screen -S bukkit -p 0 -X stuff "save-on$(echo -ne '\r')"
        sleep 5
    fi
}

 
updatebukkit()
{
    if [ "$(screen -ls | grep bukkit)" == "" ] ; then
        sleep 0
    else
        screen -S bukkit -p 0 -X stuff "say Going down for an update in 60 seconds.$(echo -ne '\r')"
        sleep 55
        screen -S bukkit -p 0 -X stuff "say Going down for an update in 5 seconds.$(echo -ne '\r')"
        sleep 5
        stopbukkit        
    fi
 
    wget -O $bukkitdir$bukkitupdate $bukkiturl
    sleep 5
    mv $bukkitdir$bukkitupdate $bukkitdir$bukkitfilename
    sleep 5
}
 
backupbukkit()
{
    echo "Starting multiworld backup..."
    if [ "$(screen -ls | grep bukkit)" == "" ] ; then
        sleep 0
    else
        screen -S bukkit -p 0 -X stuff "say '$backupmsg' $(echo -ne '\r')"
        screen -S bukkit -p 0 -X stuff "save-all$(echo -ne '\r')"
        sleep 5
        screen -S bukkit -p 0 -X stuff "save-off$(echo -ne '\r')"
    fi
    if [ -d $backupdir ] ; then
        sleep 0
    else
        mkdir -p $backupdir
    fi
    for ((i=0;i<$numworlds;i++)); do
        cp -R $bukkitdir${worlds[$i]} $backupdir$dateformat
        echo "Saving '${worlds[$i]}' to '$backupdir$dateformat'"
    done
 
    if [ "$(screen -ls | grep bukkit)" == "" ] ; then
        sleep 0
    else
        sleep 5
        screen -S bukkit -p 0 -X stuff "save-on$(echo -ne '\r')"
    fi
    echo "Backup complete."
}
 
case $1 in
    start)
        startbukkit
        ;;
    stop)
        stopbukkit
        ;;
    startsave)
        startsave
        ;;
    stopsave)
        stopsave
        ;;
    restart)
        stopbukkit
        sleep 5
        startbukkit
        ;;
    update)
        updatebukkit
        ;;
    backup)
        backupbukkit
        ;;
    friendlystop)
        screen -S bukkit -p 0 -X stuff "say Going down in 5 minutes.$(echo -ne '\r')"
        sleep 240
        screen -S bukkit -p 0 -X stuff "say Going down in 60 seconds.$(echo -ne '\r')"
        sleep 55
        screen -S bukkit -p 0 -X stuff "say Going down in 5 seconds.$(echo -ne '\r')"
        sleep 5
        stopbukkit
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|update|backup|friendlystart}"
esac
 
exit 0
