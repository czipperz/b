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
'--help'|'-h')
	echo "C is a program that allows you to jump between directories fast"
	echo "If it doesn't seem to work, you MUST use \`. c bookmark-name\` syntax"
	echo
	echo "USAGE \`c [option]\`:"
	echo "  --add  or -a will allow you bookmark the current directory and save it with a given name"
	echo "  --edit or -e will open the bookmark of directories in $EDITOR"
	echo "  --help or -h to display this message"
	echo "  --list or -l will list the bookmarks of directores"
	echo "  --path or -p will display the path of the bookmark"
	echo
	echo "If the above are not found, it will attempt to jump to the directory"
	echo "Use \`. c bookmark-name\`"
	;;
*)
	val=""   #the additional folders
	call="$1"
	if [ 1 -eq $(echo "$1" | grep -c '[^\\]/') ]; then   #ex that pass: file/folder/sub , file/ss , file/ <- this still works
		call=$(echo "$1" | perl -pe 's/^(((?<=\\)\/|[^\/])*).*/$1/')
		val=$(echo "$1" | perl -pe 's/^((?<=\\)\/|[^\/])*//')
	fi
	cdto=$(cat $HOME/.c-list | egrep "^$call" | sed -r "s/^$call //")
	cd $cdto/$val
	;;
esac
