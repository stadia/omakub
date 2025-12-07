#!/bin/bash

# Remove geekbench package from AUR
paru -Rns --noconfirm geekbench

# Remove the symlink we created during installation
sudo rm -f /usr/local/bin/geekbench6
