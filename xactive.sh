#!/bin/bash
class_name='konsole'

# regex for extracting hex id's
grep_id='0[xX][a-zA-Z0-9]\{7\}'

#Storing timestamp and will use timediff to prevent xprop duplicates
timestp=$(date +%s)

xprop -spy -root _NET_ACTIVE_WINDOW | grep --line-buffered -o $grep_id |
while read -r id; do
	class="`xprop -id $id WM_CLASS | grep $class_name`"
	newtime=$(date +%s)
	timediff=$((newtime-timestp))
	if [ $timediff -gt 0 ]; then
		if [ -n "$class" ]; then
			# Check if Super key is Control key, if so then keys will swap
			# xmodmap -pke | grep -e '133.*Control' >/dev/null
			setxkbmap -query | grep -q 'swap_lwin_lctl'
			if [ $? -eq 0 ]; then
				setxkbmap -option
				# xmodmap ~/.Xmodmap.terminal
				# echo "Cleared setxkbmap options"
				# echo
			fi
		else
			# Check if Super key is Super, if so then keys will swap
			# xmodmap -pke | grep -e '133.*Super' >/dev/null
			setxkbmap -query | grep -vq 'swap_lwin_lctl' >/dev/null
			if [ $? -eq 0 ]; then
				setxkbmap -option ctrl:swap_lwin_lctl
				# xmodmap ~/.Xmodmap.gui
				# echo "setxkbmap option to swap lwin and lctrl"
				# echo
			fi
		fi
		timestp=$(date +%s)
	fi
done
