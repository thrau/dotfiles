#!/bin/bash

# check for repository
if ! git rev-parse --git-dir > /dev/null; then exit 1; fi

# get some info on the current repository
remotes=$(git remote)
branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
gitdir=$(git rev-parse --git-dir)

# check for force flag to skip prompt
force=1
update=1
push=1
for opt in $@; do
    case $opt in
	"-f") force=0 ;;
	"-u") update=0 ;;
	"-p") push=0 ;;
	*)    echo "[WARN]: Unknown option $opt"
    esac
done

# checks whether the repository has the given remote
has-remote() {
    case "${remotes[@]}" in *"$1"*) return 0 ;; esac
    return 1
}

# echos either upstream origin depending on what should be used (upstream is prefferred)
get-remote() {
    if has-remote "upstream"; then
	remote="upstream"
    else
	if has-remote "origin"; then
	    remote="origin"
	else
	    echo  "[ERROR] repository has no usable remotes" >&2
	    return 1
	fi
    fi

    echo $remote
    return 0;
}

remote=$(get-remote)

if [ ! $? -eq 0 ]; then
    exit 1;
fi

if [ $update -eq 0 ]; then
    echo "git fetch $remote"
    git fetch $remote
fi

# check whether we have unstaged/uncommited changes
git diff-index --quiet HEAD # returns 0 on a clean working dir
if [ ! $? -eq 0 ] && [ ! $force -eq 0 ]; then
    echo "Warning: You have unstaged/uncommitted changes that could get lost"

    prompt() {
	echo "Do you wish to continue? (y)es, (n)o, (s)tatus, (d)iff"
	
	read answer
	
	case $answer in
	    "y") return 0 ;;
	    "n") return 1 ;;
	    "s") git status -sb ;;
	    "d") git diff --color ;; # this isn't very clever because it ignores staged changes
	    *)   echo "Invalid option" ;;
	esac
	
	prompt
	return $?
    }

    prompt

    if [ ! $? -eq 0 ]; then
	echo "Okay, bailing";
	exit 1;
    fi
fi

echo "git reset --hard $remote/$branch"
git reset --hard $remote/$branch

if [ $push -eq 0 ] && [ $remote == "upstream" ] && has-remote "origin"; then
    echo "git push -f origin $branch"
    git push -f origin $branch
fi
