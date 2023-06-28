ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gallifrey"

plugins=(colored-man-pages)

source $ZSH/oh-my-zsh.sh

export PATH="/opt/miniconda3/bin:$PATH"
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

export TERM=xterm-256color

autoload -U compinit; compinit

eval "$(mcfly init zsh)"
eval "$(zoxide init zsh)"

alias pac="sudo pacman -Syu"
alias pacremove="sudo pacman -Rns"

alias light="xrandr --output eDP --brightness"
alias sound="amixer set Master"
alias mute="amixer set Master toggle"
