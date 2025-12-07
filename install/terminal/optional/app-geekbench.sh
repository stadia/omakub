#!/bin/bash

# Install geekbench from AUR
paru -S --noconfirm geekbench

# The AUR package installs to /usr/bin/geekbench6
# Create symlink for consistency with original script
sudo ln -sf /usr/bin/geekbench6 /usr/local/bin/geekbench6

echo "Run as geekbench6 from the terminal"
