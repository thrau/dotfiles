#!/bin/bash

deploy() {
    echo -n "deploying $1 ... "
    
    src=$HOME/$1
    dest=$HOME/.dotfiles/$1

    if [ -f $src ]; then
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

		if [ $answer == 'n' ]; then
		    echo " skipping."
		    return 1
		fi
	    elif [ $answer != 'y' ]; then
		echo " skipping."
		return 1
	    fi
	fi

	rm $src	
    fi

    ln -s $dest $HOME/

    echo " done!"
}

echo "This will overwrite existing dotfiles in your home directory."
echo "Are you sure you want to do this? [y/n]";
read answer

if [ $answer != "y" ]; then
    echo "okay, bailing."
    exit 0;
fi

deploy .gitconfig
deploy .bashrc
deploy .zshrc
deploy .bash_aliases
