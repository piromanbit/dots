[[ $- != *i* ]] && return

export PATH="$PATH:$HOME/.local/bin"
exec fish;
