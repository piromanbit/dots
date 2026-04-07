# GTK/Qt — same as ~/.config/environment.d/90-ui-theme.conf (fish-started GUIs)
set -x GTK_THEME Gruvbox-Material-Dark-medium
set -x GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc":"$XDG_CONFIG_HOME/gtk-2.0/gtkrc.mine"
set -x QT_QPA_PLATFORMTHEME qt6ct
set -x QT_QPA_PLATFORMTHEME_qt5 qt5ct
set -x XCURSOR_THEME Adwaita
set -x XCURSOR_SIZE 24

set -x CARGO_HOME "$XDG_DATA_HOME/cargo"
set -x RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -x GIT_CONFIG_GLOBAL "$XDG_CONFIG_HOME/git/config"
set -x ANSIBLE_HOME "$XDG_CONFIG_HOME/ansible"
set -x ANSIBLE_CONFIG "$XDG_CONFIG_HOME/ansible.cfg"
set -x ANSIBLE_GALAXY_CACHE_DIR "$XDG_CACHE_HOME/ansible/galaxy_cache"
set -x ANSIBLE_LOCAL_TEMP "$XDG_CACHE_HOME/ansible/tmp"
set -x ANSIBLE_SSH_CONTROL_PATH_DIR "$XDG_CACHE_HOME/ansible/cp"
set -x ANSIBLE_ASYNC_DIR "$XDG_CACHE_HOME/ansible_async"
set -x ANSIBLE_CONFIG "$XDG_CONFIG_HOME/ansible/ansible.cfg"
set -x W3M_DIR "$XDG_CONFIG_HOME/w3m"
set -x GOPATH "$XDG_CONFIG_HOME/go"
set -x GOMODCACHE "$XDG_CACHE_HOME/go/mod"
set -x _JAVA_OPTIONS "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java"
set -x PYTHON_HISTORY "$XDG_STATE_HOME/python_history"
set -x BUN_INSTALL "$XDG_DATA_HOME/bun"
set -x JULIA_DEPOT_PATH "$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
set -x JULIAUP_DEPOT_PATH "$XDG_DATA_HOME/julia"
set -x WGETRC "$XDG_CONFIG_HOME/wgetrc"
set -x VSCODE_PORTABLE "$XDG_DATA_HOME/vscode"
set -x CURSOT_PORTABLE "$XDG_DATA_HOME/cursor"
fish_add_path "$BUN_INSTALL/bin"
fish_add_path "$XDG_DATA_HOME/juliaup/bin"

set -gx COPILOT_HTTP_PROXY "http://127.0.0.1:8118"
