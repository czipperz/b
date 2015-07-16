#!/bin/bash

if (( $# == 0 )); then
    echo "Need at least one args. Try \`--help'"
    exit 1
fi

case "$1" in
    --add|-a)
	echo "$2 $(pwd)" >> $HOME/.b-list ;;
    --list|-l)
	if [ ! -f $HOME/.b-list ]; then touch $HOME/.b-list; fi
	while read i; do
	    echo "$(echo "$i" | awk '{ print $1 }')\t$(echo "$i" | awk '{ print $2 }')"
	done < $HOME/.b-list
	;;
    --path|-p)
	echo $(cat $HOME/.b-list | egrep "^$2" | awk '{ print $2 }')
	;;
    --edit|-e)
	$EDITOR $HOME/.b-list
	;;
    --help|-h)
	echo "B is a program that allows you to jump between directories fast"
	echo "If it doesn't seem to work, you MUST use \`. b bookmark-name\` syntax"
	echo
	echo "USAGE \`b [option]\`:"
	echo "  --add  or -a will allow you bookmark the current directory and save it with a given name"
	echo "  --edit or -e will open the bookmark of directories in $EDITOR"
	echo "  --help or -h to display this message"
	echo "  --list or -l will list the bookmarks of directores"
	echo "  --path or -p will display the path of the bookmark"
	echo
	echo "If the above are not found, it will attempt to jump to the directory"
	echo "Use \`. b bookmark-name\`"
	;;
    *)
	if [ 1 -eq $(echo "$1" | grep -c '^/') ]; then
	    cd $1
	else
	    call="$1"
	    val=""
	    if [ 1 -eq $(echo "$1" | grep -c '[^\\]/') ]; then
		call=$(echo "$1" | perl -pe 's/^(((?<=\\)\/|[^\/])*).*/$1/')
		val=$(echo "$1" | perl -pe 's/^((?<=\\)\/|[^\/])*//')
	    fi
	    cdto=$(cat $HOME/.b-list | grep -F "$call" | grep "^$call" | awk '{ print $2 }')
	    if [ -z "$cdto" ]; then
		cd $1
	    else
		cd $cdto/$val
	    fi
	fi
	;;
esac
