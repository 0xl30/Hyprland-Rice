# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnosterzak"

plugins=(
    git
    archlinux
    zsh-autocomplete
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

#fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

# Alias Commands
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias lbin='cd /usr/local/bin/'
alias wordlist='cd /usr/share/seclists/'


$HOME/.config/fastfetch/random-image.sh