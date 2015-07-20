#b

`b` is a powerful way to bookmark and cd all at once!

Installation is at the end. Hit `<END>` to get there fast

##Usage

Bookmark something using

    $ b --add bookmark-name
    $ b -a bookmark-name

Remove a bookmark using

    $ b --remove bookmark-name
    $ b -r bookmark-name

Get help

    $ b --help
    $ b -h

List bookmarks

    $ b --list
    $ b -l

Display the path of a bookmark

    $ b --path bookmark-name
    $ b -p bookmark-name

Jump to a bookmark (the dot makes it run the script in the current terminal)

    $ . b bookmark-name

Jump to a sub directory of a bookmark

    $ . b bookmark-name/path/to/final/directory

Use b like `cd`!

    $ . b /home/czipperz/dotfiles

Use b to go down directories (note that this has higher priority than using normal `cd`)

	DIRECTORY               COMMANDS AND OUTPUT
	~                       $ pwd
	                        /home/czipperz
	~/tests/czipperz/stuff  $ . b czipperz
	~/tests/czipperz        $ . b czipperz
	~                       $ . b tests
	~/tests                 $ . b czipperz
	~                       $

You could add the following alias to shorten the command

    alias b='. b'

##Priorities

As you have seen above, `b` can do many different things. Here is the order in which it decides what to do:
1. It will try to bounce to a bookmark or a bookmark's subdirectory
2. It will try to `cd` to the directory specified (if it exists)
3. It will then resort to bounce to a head directory (like a named `../`)

##Installation

Clone the repository: `git clone https://github.com/czipperz/b && cd b`

Install: `sudo cp b /usr/bin`

Steps for zsh autocomplete:

* Make a custom functions directory. If you're running **[Oh My Zsh](https://github.com/robbyrussell/oh-my-zsh)** (you should) then make it in `$HOME/.oh-my-zsh/functions`, otherwise you should install *Oh My Zsh* first then repeat.
* Copy `_b` to `$HOME/.oh-my-zsh/functions`.
* Execute `echo 'fpath=( $HOME/.oh-my-zsh/functions $fpath )' >> $HOME/.zshrc`
