#!/bin/bash

if (( $# == 0 )); then
    cd
    pwd
else
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
            cat "$HOME/.b-list" | egrep "^$2" | awk '{ print $2 }'
            ;;
        --help|-h)
            echo "\`b\` is a powerful way to bookmark and cd all at once!"
            echo "If it doesn't seem to work, you MUST use \`. b bookmark-name\` syntax"
            echo "Note that all variables used have a prefix of \`_b_\` to prevent collisions"
            echo
            echo "USAGE \`b [option]\`:"
            echo "  --add     -a  -- add a bookmark at current directory with a given name"
            echo "  --help    -h  -- display this message"
            echo "  --list    -l  -- list the bookmarks and where they point"
            echo "  --path    -p  -- display the path of a given bookmark"
            echo "  --remove  -r  -- remove a bookmark"
            echo
            echo "If the above options are not used, it will attempt to jump to the directory given"
            echo "It will search for a directory to jump to in this order:"
            echo " 1. Bookmarks"
            echo " 2. Something from \`ls -A\`"
            echo " 3. CD toward \`/\` by named \`../\`s"
            echo " 4. Something from \`$HOME\`"
            echo " 5. Something from \`/\`"
            ;;
        *)
            if [ 1 -eq $(echo "$1" | grep -c '^/') -o "$1" = '-' ]; then
                cd "$1"
            else
                _b_cdDone=''
                _b_call="$1"
                _b_val=""
                _b_counter=bookmark
                if [ 1 -eq "$(echo "$1" | grep -c '[^\\]/')" ]; then
                    _b_call="$(echo "$1" | perl -pe 's;^(((?<=\\)/|[^/])*).*;$1;')"
                    _b_val="$(echo "$1" | perl -pe  's;^((?<=\\)/|[^/])*/;;')"
                fi
                while [ -z "$_b_cdDone" ]; do
                    case $_b_counter in
                        bookmark)
                            _b_lines="$(cat "$HOME/.b-list" | wc -l)"
                            for (( i=$_b_lines; i >= 1; i-- )); do
                                _b_line="$(tail -n $i "$HOME/.b-list" | head -n 1)"
                                if [ "$(echo "$_b_line" | awk '{ print $1 }')" = "$_b_call" ]; then
                                    cd "$(echo "$_b_line" | awk '{ print $2 }')"
                                    if [ ! -z "$_b_val" ]; then
                                        if [ -d "$_b_val" ]; then
                                            cd "$_b_val"
                                        else
                                            echo -n "Only the base directory of the bookmark \`$(echo "$_b_line" | awk '{ print $1 }')\`"
                                            echo "was found, will only execute \`cd \"$(echo "$_b_line" | awk '{ print $2 }')\"\`."
                                        fi
                                    fi
                                    _b_cdDone=' '
                                    break
                                fi
                            done
                            _b_counter='upRaw'
                            ;;
                        upRaw)
                            if [ 1 -eq "$(echo "$_b_call" | egrep -c '^\.\.+$')" ]; then
                                _b_dirFix="$(echo "$_b_call" | perl -pe 's/^.//' | wc -c)"
                                for (( _b_index=1; _b_index<$_b_dirFix; _b_index++ )); do
                                    cd ..
                                done
                                _b_cdDone=' '
                            fi
                            _b_counter='raw'
                            ;;
                        raw)
                            if [ -d "$_b_call" ]; then
                                if [ -d "$_b_call/$_b_val" ]; then
                                    cd "$_b_call/$_b_val"
                                else
                                    echo -n "Only the base directory of this raw cd was found,"
                                    echo " will execute \`cd \"$_b_call\"\`"
                                    cd "$_b_call"
                                fi
                                _b_cdDone=' '
                            fi
                            _b_counter='upNamed'
                            ;;
                        upNamed)
                            _b_dest='..'
                            _b_start="$(pwd | perl -pe 's|^/||' | perl -pe 's|/|\n|g' | wc -l)"
                            if (( $_b_start != 1 )); then
                                for i in {${_b_start}..2}; do
                                    if [ "$(pwd | cut -d/ -f$i 2>/dev/null)" = "$_b_call" ]; then
                                        cd "../$_b_dest/$_b_call/$_b_val"
                                        _b_cdDone=' '
                                        break
                                    fi
                                    if [ -d "$_b_dest/$_b_call" ]; then
                                        cd "$_b_dest/$_b_call/$_b_val"
                                        _b_cdDone=' '
                                        break
                                    fi
                                    _b_dest="$_b_dest/.."
                                done
                            fi
                            _b_counter='home'
                            ;;
                        home)
                            if [ -d "$HOME/$_b_call" ]; then
                                if [ -d "$HOME/$_b_call/$_b_val" ]; then
                                    cd "$HOME/$_b_call/$_b_val"
                                else
                                    echo -n "Only the base directory of this \"home\" cd was found,"
                                    echo " will only execute \`cd \"$HOME/$_b_call\"\`."
                                    cd "$HOME/$_b_call"
                                fi
                                _b_cdDone=' '
                            fi
                            _b_counter='slash'
                            ;;
                        slash)
                            if [ -d "/$_b_call" ]; then
                                if [ -d "/$_b_call/$_b_val" ]; then
                                    cd "/$_b_call/$_b_val"
                                else
                                    echo -n "Only the base directory of this \"/\" cd was found,"
                                    echo " will only execute \`cd \"/$_b_call\"\`."
                                    cd "/$_b_call"
                                fi
                                _b_cdDone=' '
                            fi
                            _b_counter='nop'
                            ;;
                        nop)
                            echo -n "Could not find a suitable solution to bounce to"
                            echo " (this has been not been detected as a bookmark, super, or normal cd)."
                            _b_cdDone=' '
                            ;;
                    esac
                done
            fi
            pwd
            ;;
    esac
fi
