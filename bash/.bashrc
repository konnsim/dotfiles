#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# convenience aliases
alias ebrc='nano ~/.bashrc'
alias sbrc='source ~/.bashrc'
alias ehyprcfg='nano ~/.config/hypr/hyprland.conf'
alias pi='sudo pacman -S'
alias pu='sudo pacman -Syu'
alias pr='sudo pacman -Rs'
alias ps='sudo pacman -Ss'
alias pc='sudo pacman -Scc'

# nvm
source /usr/share/nvm/init-nvm.sh

# pnpm
alias pn='pnpm'

# direnv
eval "$(direnv hook bash)"

# work logging
alias git-log='~/scripts/worklog.sh'

# copy/paste aliases
alias clip='wl-copy'
alias paste='wl-paste'
