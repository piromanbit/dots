#!/bin/bash

STATE_FILE="$HOME/.cache/theme_state"
THEME_DIR="$HOME/.config/theme_assets"
ALACRITTY_LINK="$HOME/.config/alacritty/colors.toml"
SWAYLOCK_LINK="$HOME/.config/swaylock/wallpaper.jpg"

# 1. Чтение текущего состояния
if [ -f "$STATE_FILE" ]; then
  CURRENT_THEME=$(cat "$STATE_FILE")
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
echo "$NEW_THEME" > "$STATE_FILE"

# 4. Обновление Alacritty
ln -sf "$THEME_DIR/alacritty/${NEW_THEME}.toml" "$ALACRITTY_LINK"

# 5. Обновление обоев Niri
pkill swaybg
swaybg -i "$THEME_DIR/wallpapers/${NEW_THEME}.jpg" & disown
ln -sf "$THEME_DIR/wallpapers/${NEW_THEME}.jpg" "$SWAYLOCK_LINK"

# 6. Обновление осстояния для NeoVim
NVIM_STATE="$HOME/.local/share/nvim/theme_state"
mkdir -p "$(dirname "$NVIM_STATE")"
echo "$NEW_THEME" > "$NVIM_STATE"
