#!/bin/bash
path=~/Wallpapers

name=""
fullpath=/
modifier=".png"

pywal() {
	if [ -x "$(command -v wal)" ]; then
		wal -i "$fullpath" -n > /dev/null 2> /dev/null

	fi
	~/.config/dunst/reload_dunst.sh > /dev/null 2> /dev/null
	notify-send 'Changed background' $name --icon=dialog-information

	~/.config/glava/change_glava.sh > /dev/null 2> /dev/null

}

uiSelect() {
	name=$(ls "$path" | rofi -dmenu)
	fullpath="$path/$name"
	modifier=$(echo -e "no\\nblur" | rofi -dmenu )
}

setBackground() {
	extension=$(echo "$name" | awk -F . '{print $NF}')
	output="/tmp/wallpaper.$extension"

	if [ "$modifier" == "no" ]; then
		cp "$fullpath" "$output"
	elif [ "$modifier" == "blur" ]; then
		convert "$fullpath" -blur 0x8 "$output"
	fi
	
	if [ "$XDG_CURRENT_DESKTOP" == "ubuntu:GNOME" ]; then
		dconf write "/org/gnome/desktop/background/picture-uri" "'file:///$output'"
	elif [ "$XDG_CURRENT_DESKTOP" == "GNOME" ]; then
		dconf write "/org/gnome/desktop/background/picture-uri" "'file:///$output'"
	else
		feh --bg-scale "$output"
	fi
  	
	pywal
}

addBackground() {
	url=$(xclip -selection c -o)
	name=$(zenity --entry --text "Filename")

	curl -o "$path/$name" "$url"
}

if ! [ -z "$1" ]; then
	name="$1"
	fullpath="$name"	
	modifier="no"
	setBackground
else
	action=$(echo -e "set\\nadd" | rofi -dmenu)
	if [ "$action" == "set" ]; then
		uiSelect
		setBackground
	elif [ "$action" == "add" ]; then
		addBackground
	fi
fi

