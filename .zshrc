# load custom environment variables
if [ -f ~/.environment ]; then
    . ~/.environment
fi

# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e
bindkey ';5D' backward-word
bindkey ';5C' forward-word

# Helps alt-backspace kill words stop at forward slashes
#WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# This would be an alternative way to achieve something similar
# but it also stops at dashes
#autoload -U select-word-style
#select-word-style bash

# Keep 5000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

if [ -f ~/.functions ]; then
    . ~/.functions
fi

if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/thomas/workspace/localstack/localstack-pro-samples/appsync-graphql-api/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/thomas/workspace/localstack/localstack-pro-samples/appsync-graphql-api/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/thomas/workspace/localstack/localstack-pro-samples/appsync-graphql-api/node_modules/tabtab/.completions/sls.zsh ]] && . /home/thomas/workspace/localstack/localstack-pro-samples/appsync-graphql-api/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/thomas/workspace/localstack/localstack-pro-samples/appsync-graphql-api/node_modules/tabtab/.completions/slss.zsh ]] && . /home/thomas/workspace/localstack/localstack-pro-samples/appsync-graphql-api/node_modules/tabtab/.completions/slss.zsh