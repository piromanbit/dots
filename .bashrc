[[ $- != *i* ]] && return

export XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$XDG_STATE_HOME/bash"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export PATH="$PATH:$HOME/.local/bin"
exec fish;
