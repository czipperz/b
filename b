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
	    _b_cdDone=''
	    _b_call="$1"
	    _b_val=""
	    if [ 1 -eq "$(echo "$1" | grep -c '[^\\]/')" ]; then
		_b_call="$(echo "$1" | perl -pe 's/^(((?<=\\)\/|[^\/])*).*/$1/')"
		_b_val="$(echo "$1" | perl -pe 's/^((?<=\\)\/|[^\/])*\///')"
	    fi

	    _b_lines="$(cat "$HOME/.b-list" | wc -l)"
	    for (( i=$_b_lines; i >= 1; i-- )); do
		_b_line="$(tail -n $i "$HOME/.b-list" | head -n 1)"
		if [ "$(echo "$_b_line" | awk '{ print $1 }')" = "$call" ]; then
		    cd "$(echo "$_b_line" | awk '{ print $2 }')/$_b_val"
		    _b_cdDone=' '
		    break
		fi
	    done

	    if [ -z "$_b_cdDone" ]; then
		if [ -d "$_b_call" ]; then
		    if [ -d "$_b_call/$_b_val" ]; then
			cd "$_b_call/$_b_val"
			_b_cdDone=' '
		    else
			echo "Only the base directory was found, will execute \`cd \"$_b_call\""
			cd "$_b_call"
		    fi
		else

		    _b_dest='..'
		    _b_start="$(pwd | perl -pe 's|^/||' | perl -pe 's|/|\n|g' | wc -l)"
		    for i in {${_b_start}..2}; do
			if [ "$(pwd | cut -d/ -f$i)" = "$1" ]; then
			    cd "$_b_dest/$_b_val"
			    _b_cdDone=' '
			    break
			fi
			_b_dest="$_b_dest/.."
		    done
		fi
	    fi
	fi
	if [ -z "$_b_cdDone" ]; then
	    exit 1
	fi
	;;
esac
