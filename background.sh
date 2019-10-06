#!/bin/bash
path=~/Wallpapers

pywal() {
  if [ -x "$(command -v wal)" ]; then
    wal -i $fullpath -n
  fi
}

setBackground() {
  name=$(ls $path | dmenu -l 12)
  fullpath=$path/$name

  extension=$(echo "$name" | awk -F . '{print $NF}')
  modifier=$(echo -e "no\nblur" | dmenu -l 2)
  output="/tmp/wallpaper.$extension"

  if [ "$modifier" == "no" ]; then
    cp $fullpath $output
  elif [ "$modifier" == "blur" ]; then
    convert $fullpath -blur 0x8 $output
  fi

  if [ "$XDG_CURRENT_DESKTOP" == "ubuntu:GNOME" ]; then
    dconf write "/org/gnome/desktop/background/picture-uri" "'file:///$output'"
    pywal
	elif [ "$XDG_CURRENT_DESKTOP" == "GNOME" ]; then
		dconf write "/org/gnome/desktop/background/picture-uri" "'file:///$output'"
    pywal
  else
    feh --bg-scale $output
<<<<<<< HEAD
  fi

  if [ -x "$(command -v wal)" ]; then
    wal -i $fullpath -n
=======
    pywal
>>>>>>> 3488b1ce483cde9977b6c25a380ed69c698d1015
  fi
}

addBackground() {
	url=$(xclip -selection c -o)
	name=$(zenity --entry --text "Filename")

	curl -o $path/$name $url
}

action=$(echo -e "set\nadd\nsetup" | dmenu -l 3)

if [ "$action" == "set" ]; then
	setBackground
elif [ "$action" == "add" ]; then
	addBackground
elif [ "$action" == "setup" ]; then
	apt-get install zenity dmenu feh xclip imagemagick
fi
