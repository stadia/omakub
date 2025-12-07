#!/bin/bash

# Remove Windsurf package from AUR
paru -Rns --noconfirm windsurf-bin

# Remove Windsurf configuration files
rm -rf ~/.config/windsurf
