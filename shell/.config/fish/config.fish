set -U fish_greeting
zoxide init fish | source

status is-interactive; and begin
    alias e 'eza -l --icons'
    alias ea 'eza -la --icons'
    alias ff fastfetch
    alias v nvim
    alias cr 'cargo run'
    alias crr 'cargo run --release'
    alias cb 'cargo build'
    alias cbr 'cargo build --release'
    alias ct 'cargo test'
    alias ca 'cargo add'
    alias ni 'bun install'
    alias nr 'bun run'
    alias nx 'bunx'
    source ~/.config/fish/functions/notes.fish

    if test -f ~/.config/fish/secrets.fish
      source ~/.config/fish/secrets.fish
    end

    set -x XDG_DATA_HOME "$HOME/.local/share"
    set -x XDG_CONFIG_HOME "$HOME/.config"
    set -x XDG_CACHE_HOME "$HOME/.cache"
    set -x XDG_STATE_HOME "$HOME/.local/state"

    set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
    set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
    set -x GIT_CONFIG_GLOBAL "$XDG_CONFIG_HOME/git/config"
    set -x ANSIBLE_CONFIG "$XDG_CONFIG_HOME/ansible/ansible.cfg"
    set -x W3M_DIR "$XDG_CONFIG_HOME/w3m"
    set -x GOPATH "$XDG_CONFIG_HOME/go"
    set -x GOMODCACHE "$XDG_CACHE_HOME/go/mod"
    set -x _JAVA_OPTIONS "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java"
    set -x PYTHON_HISTORY "$XDG_STATE_HOME/python_history"
    set -x BUN_INSTALL "$XDG_DATA_HOME/bun"
    fish_add_path "$BUN_INSTALL/bin"

    function fish_prompt
        set -l last_status $status
        set -l stat
        if test $last_status -ne 0
            set stat (set_color red)"[$last_status]"(set_color yellow)
        end

        string join "" -- (set_color green) (prompt_pwd) ' ' (set_color yellow) $stat '> '
    end
end
