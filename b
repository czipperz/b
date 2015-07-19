#!/bin/bash

if (( $# == 0 )); then
    echo "Need at least one args. Try \`--help'"
    exit 1
fi

case "$1" in
    --add|-a)
	echo "$2 $(pwd)" >> "$HOME/.b-list"
	;;
    --remove|-r)
	echo "This could cause loss of memory..."
	_b_lines="$(cat "$HOME/.b-list" | wc -l)"
	for (( i=$_b_lines; i >= 1; i-- )); do
	    _b_line="$(tail -n $i "$HOME/.b-list" | head -n 1)"
	    if [ "$(echo "$_b_line" | awk '{ print $1 }')" != "$2" ]; then
		echo "$_b_line" >> "/tmp/.b-$$"
	    fi
	done
	mv "/tmp/.b-$$" "$HOME/.b-list"
	echo "Done"
	;;
    --list|-l)
	if [ ! -f "$HOME/.b-list" ]; then touch "$HOME/.b-list"; fi
	cat "$HOME/.b-list" | perl -pe 's/^([^ ]+) (.*)/$1 = $2/'
	;;
    --path|-p)
	echo $(cat "$HOME/.b-list" | egrep "^$2" | awk '{ print $2 }')
	;;
    --help|-h)
	echo "B is a program that allows you to jump between directories fast"
	echo "If it doesn't seem to work, you MUST use \`. b bookmark-name\` syntax"
	echo
	echo "USAGE \`b [option]\`:"
	echo "  --add  or -a will allow you bookmark the current directory and save it with a given name"
	echo "  --help or -h to display this message"
	echo "  --list or -l will list the bookmarks of directores"
	echo "  --path or -p will display the path of the bookmark"
	echo
	echo "If the above are not found, it will attempt to jump to the directory"
	echo "Use \`. b bookmark-name\`"
	;;
    *)
	if [ 1 -eq $(echo "$1" | grep -c '^/') ]; then
	    cd "$1"
	else
	    cdDone=''
	    call="$1"
	    val=""
	    if [ 1 -eq "$(echo "$1" | grep -c '[^\\]/')" ]; then
		call="$(echo "$1" | perl -pe 's/^(((?<=\\)\/|[^\/])*).*/$1/')"
		val="$(echo "$1" | perl -pe 's/^((?<=\\)\/|[^\/])*\///')"
	    fi
	    lines="$(cat "$HOME/.b-list" | wc -l)"
	    for (( i=$lines; i >= 1; i-- )); do
		line="$(tail -n $i "$HOME/.b-list" | head -n 1)"
		if [ "$(echo "$line" | awk '{ print $1 }')" = "$call" ]; then
		    cd "$(echo "$line" | awk '{ print $2 }')/$val"
		    cdDone=' '
		    break
		fi
	    done
	    if [ -z "$cdDone" ]; then
		dest='..'
		start="$(pwd | perl -pe 's|^/||' | perl -pe 's|/|\n|g' | wc -l)"
		for i in {${start}..2}; do
		    if [ "$(pwd | cut -d/ -f$i)" = "$1" ]; then
			cd "$dest/$val"
			cdDone=' '
			break
		    fi
		    dest="$dest/.."
		done
		if [ -z "$cdDone" ]; then
		    cd "$call/$val"
		fi
	    fi
	fi
	;;
esac
