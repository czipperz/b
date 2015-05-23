#B

B as in bookmarks

This is a partial clone of [Jump](https://github.com/flavio/jump) that uses a shell script.

##Usage

Bookmark something using

    b --add bookmark-name
    b -a bookmark-name

Edit previous bookmarks or add manual ones using

    b --edit
	b -e

Get help

    b --help
	b -h

List bookmarks

    b --list
	b -l

Display the path of a bookmark

    b --path bookmark-name
	b -p bookmark-name

Jump to a bookmark (the dot makes it run the cd in the current terminal)

    . b bookmark-name

Jump to a sub directory of a bookmark

    . b bookmark-name/path/to/final/directory

You could add the following to your `$HOME/.bashrc` (or .zshrc) to shorten the command

    alias b='. b'
