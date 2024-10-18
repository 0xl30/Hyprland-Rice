# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="fino"

plugins=( 
    git
    archlinux
    zsh-autocomplete
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# Environment Variable 
export GOPATH=$HOME/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# API Tokens 
#export GITHUB_TOKEN=
#export VIRUSTOTAL_TOKEN=

# Alias Commands
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias lbin='cd /usr/local/bin/'
alias Wordlist='cd /usr/share/seclists/'

# Auto Run
neofetch

