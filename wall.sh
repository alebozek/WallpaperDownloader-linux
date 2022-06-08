#!/bin/bash

#VARIABLES
DIRECTORY="$HOME/Wallpapers"
USAGE="USAGE: d for only downloading the wallpapers and dw for downloading and setting the wallpapers with feh."
WALL=0

download() {
	echo "Downloading... Please wait a second"
	json=".wal.json"
	curl -s -o $json "https://www.reddit.com/r/wallpapers/top/.json?t=day&limit=1"
	url=`jq .data.children[0].data.url $json | sed 's/"//g'`
	id=`jq .data.children[0].data.id $json | sed 's/"//g'`
	img="$DIRECTORY/$id.png"
	if [ "$url" != "null" ]
	then
		echo "Image found! Downloading..."
		curl -s -o $img $url
		echo "Done"
		if [ $WALL -eq 1 ];then
			set_wallpaper
		fi
		rm $json
		return 0
	else
		echo "Retrying..."
        	download
	fi
}

set_wallpaper(){
	echo "Setting wallpaper..."
	feh --bg-scale $img
	echo "Done"
}

check_folder() {
	if [ -d $DIRECTORY ];then
		echo "Directory exists"
	else
		mkdir -p $DIRECTORY
		echo "Directory created"
	fi
}

work() {
	check_folder
	download
}

if [ "${!#}" == "dw" ];then
	WALL=1
	work
elif [ "${!#}" == "d" ];then
	work
elif [ 0 -eq "$#" ];then
	echo $USAGE
fi
