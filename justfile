set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

groups := "base shell nvim wm media dev"
base_pkgs := "stow just"
shell_pkgs := "bash fish zoxide eza fastfetch qt5ct qt6ct papirus-icon-theme gtk-engine-murrine gruvbox-material-gtk-theme-git gruvbox-material-icon-theme-git"
nvim_pkgs := "neovim ripgrep fd lua-language-server"
wm_pkgs := "niri waybar wofi swaylock alacritty swaybg gammastep"
media_pkgs := "mpd mpv ncmpcpp"
dev_pkgs := "git curl bun go"

# Single string for install-deps: `()` dependency args do not expand nested `{{ }}`.
all_pkgs := base_pkgs + " " + shell_pkgs + " " + nvim_pkgs + " " + wm_pkgs + " " + media_pkgs + " " + dev_pkgs

# Prefer paru, then yay (both install repo + AUR). Install one: paru — https://github.com/Morganamilo/paru
_install_if_missing pkgs:
    #!/usr/bin/env bash
    set -euo pipefail
    helper=
    if command -v paru >/dev/null 2>&1; then helper=paru
    elif command -v yay >/dev/null 2>&1; then helper=yay
    else
      echo "No AUR helper found. Install paru or yay, then re-run." >&2
      echo "  paru: https://github.com/Morganamilo/paru  |  yay: https://github.com/Jguer/yay" >&2
      exit 1
    fi
    echo "Using: $helper"
    PKGS='{{ pkgs }}'
    missing=()
    for pkg in $PKGS; do
      if ! pacman -Qi "$pkg" >/dev/null 2>&1; then missing+=("$pkg"); fi
    done
    if [ "${#missing[@]}" -gt 0 ]; then
      echo "Installing missing packages: ${missing[*]}"
      "$helper" -S --needed --noconfirm "${missing[@]}"
    else
      echo "All requested packages are already installed."
    fi

install-deps: (_install_if_missing all_pkgs)

stow group:
    bash -c 'case "{{ group }}" in base|shell|nvim|wm|media|dev) stow --target="$HOME" "{{ group }}" ;; *) echo "Unknown group: {{ group }}"; exit 1 ;; esac'

unstow group:
    bash -c 'case "{{ group }}" in base|shell|nvim|wm|media|dev) stow -D --target="$HOME" "{{ group }}" ;; *) echo "Unknown group: {{ group }}"; exit 1 ;; esac'

restow group:
    bash -c 'case "{{ group }}" in base|shell|nvim|wm|media|dev) stow -R --target="$HOME" "{{ group }}" ;; *) echo "Unknown group: {{ group }}"; exit 1 ;; esac'

stow-all:
    bash -c 'for group in {{ groups }}; do echo "Stowing: $group"; stow --target="$HOME" "$group"; done'

check:
    command -v stow >/dev/null
    command -v nvim >/dev/null
    command -v bun >/dev/null
    nvim --headless "+lua print('NVIM_OK')" +qa

doctor:
    bash -c 'echo "== Core commands =="; for cmd in stow nvim bun go npm; do if command -v "$cmd" >/dev/null 2>&1; then echo "OK: $cmd -> $(command -v "$cmd")"; else echo "MISSING: $cmd"; fi; done; echo "== AUR helper (just install-deps) =="; if command -v paru >/dev/null 2>&1; then echo "OK: paru -> $(command -v paru)"; elif command -v yay >/dev/null 2>&1; then echo "OK: yay -> $(command -v yay)"; else echo "MISSING: paru or yay — required for install-deps"; fi; echo "== Optional: Node (GitHub Copilot LSP) =="; if command -v node >/dev/null 2>&1; then echo "OK: node $(node -v) (Copilot default server wants 22+)"; else echo "SKIP: node not in PATH — install only if you use Copilot (e.g. pacman -S nodejs)"; fi; echo "== Mason npm shim =="; if command -v npm >/dev/null 2>&1; then tmp_dir="$(mktemp -d)"; ( cd "$tmp_dir" && npm init -y >/dev/null 2>&1 || true ); rm -rf "$tmp_dir"; echo "npm shim init check finished"; fi; echo "== GitHub Copilot =="; echo "Neovim: :Copilot auth; proxy: http://127.0.0.1:2026 (see nvim copilot.lua)."; echo "== GTK/Qt theme (Gruvbox Material medium dark) =="; if [ -d /usr/share/themes/Gruvbox-Material-Dark-medium ]; then echo "OK: GTK theme directory found"; else echo "MISSING: /usr/share/themes/Gruvbox-Material-Dark-medium — run: just install-deps"; fi; if pacman -Qi gruvbox-material-icon-theme-git >/dev/null 2>&1 || pacman -Qi gruvbox-material-icon-theme >/dev/null 2>&1; then echo "OK: gruvbox-material icon theme (package installed)"; else echo "MISSING: gruvbox-material-icon-theme-git — run: just install-deps"; fi; for c in qt5ct qt6ct; do command -v "$c" >/dev/null 2>&1 && echo "OK: $c" || echo "MISSING: $c"; done'

# Runic.jl formatter for Julia (conform.nvim `runic`); uses shared env @runic on XDG depot
install-julia-runic:
    bash -c 'command -v julia >/dev/null || { echo "julia not found"; exit 1; }; julia --project=@runic --startup-file=no --history-file=no -e "using Pkg; Pkg.add(\"Runic\")"; echo "Done. Ensure base is stowed so ~/.local/bin/runic is available."'
