#!/bin/bash

# Remove Neovim package
sudo pacman -Rns --noconfirm neovim

# Remove Neovim configuration and data files
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

# Remove desktop file if it exists
rm -f ~/.local/share/applications/Neovim.desktop
