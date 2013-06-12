# basic shell commands
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -lFh'

alias x=exit
alias c=clear

alias 'cd..'='cd ..'

alias e='emacs -nw' # -fg white -bg black'
alias se='sudo emacs -nw -fg white -bg black'

alias powerdown='sudo shutdown -h now'
alias pd=powerdown
alias reboot='sudo reboot'

alias upgrade='sudo apt-get update; sudo apt-get upgrade -y; sudo apt-get autoclean'
alias dist-upgrade='sudo apt-get update; sudo apt-get dist-upgrade;'

# maven
alias 'mvc'='mvn clean'
alias 'mvce'='mvn clean eclipse:clean'
alias 'mvi'='mvn install -DskipTests'
alias 'mvie'='mvn install -DskipTests eclipse:eclipse -DdownloadSources=true -DdownloadJavadoc=true'
alias 'mve'='mvn eclipse:eclipse -DdownloadSources=true -DdownloadJavadoc=true'
alias 'mvec'='mvn eclipse:clean'
alias 'mvci'='mvn clean install -DskipTests'
alias 'mvcie'='mvn clean install -DskipTests eclipse:eclipse -DdownloadSources=true -DdownloadJavadoc=true'

# git
alias 'ga'="git add"
alias 'gb'="git branch"
alias 'gba'="git branch -a"
alias 'gc'="git commit"
alias 'gca'="git commit -a"
alias 'gco'="git checkout"
alias 'gl'="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias 'gp'="git push origin HEAD"
alias 'gru'="git remote update"
alias 'gs'="git status -sb"
alias 'gsl'='git shortlog --pretty=format:"%Cgreen(%cr)%Creset - %s"'

#dz ssh
alias divzero='ssh thomas@divzero.at'
alias home='ssh thomas@home.rauschig.org'

#quick rename tools
alias gmv='qmv -f destination-only -e geany'

#gs merge
alias pdfmerge='gs -q -sPAPERSIZE=a4 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=pdfmerge.pdf'

# functions
## git
gsync() {
  git remote update

  if [ ! $1 ]; then
    branch="origin"
  else
    branch=$1
  fi

  git reset --hard $branch/master
}

## maven
### remove abandoned bundles (bundles with only a target folder)
rmab() {
  for p in `find -name "target"`; do
    if [ ! -d $p ]; then
      continue
    fi
    
    parent=`dirname $p`
    
    files=($parent/*)
    
    if [ `basename ${files[0]}` = "target" ]; then
      if [ ! ${files[1]} ]; then
        echo "rm -rf $parent"
        rm -rf $parent
      fi
    fi
  done;
}

### maven recursive clean (this is so ugly ...)
mvnrc() {
  # remove all abandoned bundles first
  rmab

  poms=$(find . -type f -name pom.xml -print |
    perl -n -e '$x = $_; $x =~ tr%/%%cd; print length($x), " $_";' |
    sort -k 1n -k 2 |
    sed 's/^[0-9][0-9]* //');

  for pom in $poms
  do
    path=`dirname $pom`

    found=0
    for t in `find $path -name target -o -name .project`; do
      found=1
      break
    done

    if [ $found == 0 ]; then
      echo "skipping $pom"
      continue
    fi

    echo -n "cleaning $pom ..."
    mvn -U -fn -B -q -f $pom clean eclipse:clean
    echo " done!"
  done
}


## extract
ex () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.exe)       cabextract $1  ;;
	  *.jar)       jar xvf $1     ;;
          *)           echo "'$1': unrecognized file compression" ;;
      esac
  else
      echo "'$1' is not a valid file"
  fi
}

## chmod restore
##   recursively sets chmod of files to 644 and directories to 755
chres() {
  if [ $1 ]; then
    folder=$1
  else
    folder="./"
  fi

  for i in `find $folder -type d`; do
    chmod 755 $i
  done
  for i in `find $folder -type f`; do
    chmod 644 $i
  done
}

## clone from bitbucket
gcbb() {
    if [ ! -d $1 ]; then
        git clone git@bitbucket.org:$1.git $2
    else
        echo "$1 already exists"
    fi
}
## clone frame github
gcgh() {
    if [ ! -d $1 ]; then
        git clone git@github.com:$1.git $2
    else
        echo "$1 already exists"
    fi
}

## remap control to caps lock (remove capslock)
rmcaps() {
    xmodmap -e 'remove Lock = Caps_Lock'
    xmodmap -e 'keysym Caps_Lock = Control_L'
    xmodmap -e 'add Control = Control_L'
}
