#!/bin/bash

# Needed for all installers
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm curl git unzip

# Run terminal installers
for installer in ~/.local/share/omakub/install/terminal/*.sh; do source $installer; done
