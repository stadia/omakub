#!/bin/bash

# Display system information in the terminal
sudo pacman -S --noconfirm fastfetch

# Only attempt to set configuration if fastfetch is not already set
if [ ! -f "$HOME/.config/fastfetch/config.jsonc" ]; then
  # Use Omakub fastfetch config
  mkdir -p ~/.config/fastfetch
  cp ~/.local/share/omakub/configs/fastfetch.jsonc ~/.config/fastfetch/config.jsonc
fi
