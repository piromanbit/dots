#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="$HOME/.cache/theme_state"
THEME_DIR="$HOME/.config/theme_assets"
ALACRITTY_LINK="$HOME/.config/alacritty/colors.toml"
SWAYLOCK_LINK="$HOME/.config/swaylock/wallpaper.jpg"

# 1. Чтение текущего состояния
if [[ -f "$STATE_FILE" ]]; then
  CURRENT_THEME="$(<"$STATE_FILE")"
else
  CURRENT_THEME="catppuccin"
fi

# 2. Переключение
if [ "$CURRENT_THEME" = "gruvbox-material" ]; then
  NEW_THEME="catppuccin"
else
  NEW_THEME="gruvbox-material"
fi

# 3. Запись новой истины в кэш
mkdir -p "$(dirname "$STATE_FILE")"
echo "$NEW_THEME" > "$STATE_FILE"

# 4. Обновление Alacritty
if [[ ! -f "$THEME_DIR/alacritty/${NEW_THEME}.toml" ]]; then
  echo "Theme file not found: $THEME_DIR/alacritty/${NEW_THEME}.toml" >&2
  exit 1
fi
ln -sf "$THEME_DIR/alacritty/${NEW_THEME}.toml" "$ALACRITTY_LINK"

# 5. Обновление обоев Niri
if [[ ! -f "$THEME_DIR/wallpapers/${NEW_THEME}.jpg" ]]; then
  echo "Wallpaper not found: $THEME_DIR/wallpapers/${NEW_THEME}.jpg" >&2
  exit 1
fi
if command -v pkill >/dev/null 2>&1; then
  pkill swaybg || true
fi
if command -v swaybg >/dev/null 2>&1; then
  swaybg -i "$THEME_DIR/wallpapers/${NEW_THEME}.jpg" >/dev/null 2>&1 &
fi
ln -sf "$THEME_DIR/wallpapers/${NEW_THEME}.jpg" "$SWAYLOCK_LINK"

# 6. Обновление состояния для NeoVim
NVIM_STATE="$HOME/.local/share/nvim/theme_state"
mkdir -p "$(dirname "$NVIM_STATE")"
echo "$NEW_THEME" > "$NVIM_STATE"
