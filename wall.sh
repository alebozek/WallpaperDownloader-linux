#!/bin/bash

download() {
	echo "Downloading... Please wait a second"
	json=".wal.json"
	curl -s -o $json "https://www.reddit.com/r/wallpapers/top/.json?t=day&limit=1"
	url=`jq .data.children[0].data.url $json | sed 's/"//g'`
	id=`jq .data.children[0].data.id $json | sed 's/"//g'`
	img="$id.png"
	if [ "$url" != "null" ]
	then
		echo "Image found! Downloading..."
		curl -s -o $img $url
		echo "Done"
		set_wallpaper
		rm $json
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
download
