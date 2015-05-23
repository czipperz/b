#C

This is a clone of [Jump](https://github.com/flavio/jump) that uses a shell script.

##Usage

Bookmark something using

    c --add bookmark-name
    c -a bookmark-name

Edit previous bookmarks or add manual ones using

    c --edit
	c -e

Get help

    c --help
	c -h

List bookmarks

    c --list
	c -l

Display the path of a bookmark

    c --path bookmark-name
	c -p bookmark-name

Jump to a bookmark (the dot makes it run the cd in the current terminal)

    . c bookmark-name

Jump to a sub directory of a bookmark

    . c bookmark-name/path/to/final/directory
