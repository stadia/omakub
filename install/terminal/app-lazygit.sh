#!/bin/bash

# Install lazygit from official repository
sudo pacman -S --noconfirm lazygit

# Create config directory and file
mkdir -p ~/.config/lazygit/
touch ~/.config/lazygit/config.yml
