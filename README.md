# My dotfiles

## Package groups

This repository is split into stow packages:
- `base` - user dirs and shared local bin scripts
- `shell` - bash/fish configuration
- `nvim` - Neovim configuration
- `wm` - niri/waybar/wofi/swaylock/alacritty/theme assets
- `media` - mpd/mpv/ncmpcpp
- `dev` - bun/vpn/dev tooling config

## Setup (recommended)

Use `just` as the entrypoint:
```
just install-deps
just stow-all
just check
```

Stow a single group:
```
just stow group=nvim
```

Restow or unstow a group:
```
just restow group=wm
just unstow group=media
```

## JS/TS tooling

Default JS/TS workflow uses `bun`:
- `ni` -> `bun install`
- `nr` -> `bun run`
- `nx` -> `bunx`

`npm` is shimmed to `bun` via `~/.local/bin/npm` for Mason and legacy scripts.

## Neovim / Mason troubleshooting

- Run sync/update:
```
:Lazy sync
:MasonUpdate
```
- If `gopls` fails, install Go:
```
sudo pacman -S go
```
- Quick diagnostics:
```
just doctor
```
