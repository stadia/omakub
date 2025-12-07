#!/bin/bash

# Remove official packages with pacman
sudo pacman -R --noconfirm virtualbox virtualbox-host-modules-arch

# Remove AUR package with paru
paru -Rns --noconfirm virtualbox-ext-oracle
