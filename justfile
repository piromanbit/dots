set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

groups := "base shell nvim wm media dev"
base_pkgs := "stow just"
shell_pkgs := "bash fish zoxide eza fastfetch"
nvim_pkgs := "neovim ripgrep fd lua-language-server"
wm_pkgs := "niri waybar wofi swaylock alacritty swaybg"
media_pkgs := "mpd mpv ncmpcpp"
dev_pkgs := "git curl bun go"

_install_if_missing pkgs:
    bash -c 'missing=(); for pkg in "$@"; do if ! pacman -Qi "$pkg" >/dev/null 2>&1; then missing+=("$pkg"); fi; done; if [ "${#missing[@]}" -gt 0 ]; then echo "Installing missing packages: ${missing[*]}"; sudo pacman -S --needed --noconfirm "${missing[@]}"; else echo "All requested packages are already installed."; fi' _ {{ pkgs }}

install-deps:
    just _install_if_missing "{{ base_pkgs }} {{ shell_pkgs }} {{ nvim_pkgs }} {{ wm_pkgs }} {{ media_pkgs }} {{ dev_pkgs }}"

stow group:
    bash -c 'case "$1" in base|shell|nvim|wm|media|dev) stow --target="$HOME" "$1" ;; *) echo "Unknown group: $1"; exit 1 ;; esac' _ "{{ group }}"

unstow group:
    bash -c 'case "$1" in base|shell|nvim|wm|media|dev) stow -D --target="$HOME" "$1" ;; *) echo "Unknown group: $1"; exit 1 ;; esac' _ "{{ group }}"

restow group:
    bash -c 'case "$1" in base|shell|nvim|wm|media|dev) stow -R --target="$HOME" "$1" ;; *) echo "Unknown group: $1"; exit 1 ;; esac' _ "{{ group }}"

stow-all:
    bash -c 'for group in {{ groups }}; do echo "Stowing: $group"; stow --target="$HOME" "$group"; done'

check:
    command -v stow >/dev/null
    command -v nvim >/dev/null
    command -v bun >/dev/null
    nvim --headless "+lua print('NVIM_OK')" +qa

doctor:
    bash -c 'echo "== Core commands =="; for cmd in stow nvim bun go npm; do if command -v "$cmd" >/dev/null 2>&1; then echo "OK: $cmd -> $(command -v "$cmd")"; else echo "MISSING: $cmd"; fi; done; echo "== Mason npm shim =="; if command -v npm >/dev/null 2>&1; then tmp_dir="$(mktemp -d)"; ( cd "$tmp_dir" && npm init -y >/dev/null 2>&1 || true ); rm -rf "$tmp_dir"; echo "npm shim init check finished"; fi'
