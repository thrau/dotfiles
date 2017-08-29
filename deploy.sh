#!/bin/bash

deploy() {
	echo -n "deploying $1 ... "

	src=$HOME/$1
	dest=$HOME/.dotfiles/$1

	if [ -f $src ]; then
		if [ ! $force ]; then
			confirm-overwrite $src $dest

			if [ $? == 1 ]; then
				echo " skipping."
				return 1
			fi
		fi

		rm $src
	fi

	ln -s $dest $HOME/

	echo " done!"
}

confirm-overwrite() {
	src=$1
	dest=$2

	diff -q $src $dest > /dev/null

	if [ $? != 0 ]; then
		echo "files differ!"
		echo " $src differs from $dest."
		echo " Do you wish to continue? (y)es, (n)o, (v)iew diff"

		read answer
		if [ $answer == 'v' ]; then
			diff $src $dest

			echo "overwrite? [y/n]"
			read really

			if [ $really == 'n' ]; then
				return 1
			fi
		elif [ $answer != 'y' ]; then
			return 1
		fi
	fi

	return 0
}

confirm() {
	echo "This will overwrite existing dotfiles in your home directory."
	echo "Are you sure you want to do this? [y/n]";
	read answer

	if [ $answer != "y" ]; then
		echo "okay, bailing."
		return 1;
	fi

	return 0;
}

while getopts ":y" opt; do
	if [ $opt == "y" ]; then
		force=1
	fi
done

if [ ! $force ]; then
	confirm
	if [ $? == 1 ]; then
		exit 1;
	fi
fi

deploy .gitconfig
deploy .environment
deploy .bashrc
deploy .zshrc
deploy .aliases
deploy .functions
deploy .tmux.conf

mkdir -p $HOME/bin
ln -s $HOME/.dotfiles/bin/* $HOME/bin
