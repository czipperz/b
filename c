#!/bin/bash

case "$1" in
'--add'|'-a') echo "$2 $(pwd)" >> $HOME/.c-list ;;
'--list'|'-l')
	if [ ! -f $HOME/.c-list ]; then
		touch $HOME/.c-list
	fi
	cat $HOME/.c-list
	;;
'--path'|'-p') echo $2 ;;
*) echo "GOING TO $1" ;;
esac
