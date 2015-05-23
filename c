#!/bin/bash

case "$1" in
'--add'|'-a')
	echo "$2 $(pwd)" >> $HOME/.c-list ;;
'--list'|'-l')
	if [ ! -f $HOME/.c-list ]; then
		touch $HOME/.c-list
	fi
	cat $HOME/.c-list
	;;
'--path'|'-p')
	echo $(cat $HOME/.c-list | egrep "^$2" | sed -r "s/$2 //")
	;;
'--edit'|'-e')
	$EDITOR $HOME/.c-list
	;;
*)
	val=""
	call="$1"
	if [ 1 -eq $(echo "$1" | grep -c '[^\\]/') ]; then
		call=$(echo "$1" | sed -r "s/^([^\\]\/).*/\1/")
		val=$(echo "$1" | sed -r "s///")
	fi
	cdto=$(cat $HOME/.c-list | egrep "^$1" | sed -r "s/^$1 //")
	cd $cdto
	echo "If this doesn't work, try \`. c $1\`"
	;;
esac
