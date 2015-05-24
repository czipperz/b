# Maintainer: Czipperz <czipperz@gmail.com>
pkgname=b
pkgver=1.0
pkgrel=1
pkgdesc='Allows for easy bookmark manipulation on the shell.'
arch=("any")
url='https://github.com/czipperz/b'

_gitroot=git://github.com/czipperz/b.git
_gitname=b

source=("$_gitroot")

package() {
	cd $srcdir/$_gitname
	install -Dm755 b $pkgdir/usr/bin/b
	if [ -f /usr/bin/zsh ]; then
		echo "Now setting up zsh auto complete"
		mkdir -p "$srcdir$HOME/.oh-my-zsh/functions"
		install -Dm755 _b "$srcdir$HOME/.oh-my-zsh/functions"
		if [ -f $HOME/.zshrc ]; then
			cp $HOME/.zshrc $srcdir$HOME
		fi
		echo 'fpath=( $HOME/.oh-my-zsh/functions $fpath )' >> $srcdir$HOME/.zshrc
	fi
}
md5sums=('SKIP')
