#!/bin/bash

set -e

ascii_art='________                  __        ___.
\_____  \   _____ _____  |  | ____ _\_ |__
 /   |   \ /     \\__   \ |  |/ /  |  \ __ \
/    |    \  Y Y  \/ __ \|    <|  |  / \_\ \
\_______  /__|_|  (____  /__|_ \____/|___  /
        \/      \/     \/     \/         \/
'

echo -e "$ascii_art"
echo "=> Omakub is for fresh Arch Linux installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

# Update system and install base tools
sudo pacman -Syu --noconfirm >/dev/null
sudo pacman -S --noconfirm git base-devel >/dev/null

# Install paru (AUR helper)
if ! command -v paru &> /dev/null; then
	echo "Installing paru (AUR helper)..."
	cd /tmp
	git clone https://aur.archlinux.org/paru.git >/dev/null 2>&1
	cd paru
	makepkg -si --noconfirm >/dev/null 2>&1
	cd ..
	rm -rf paru
	cd -
fi

echo "Cloning Omakub..."
rm -rf ~/.local/share/omakub
git clone --branch arch https://github.com/stadia/omakub.git ~/.local/share/omakub >/dev/null

echo "Installation starting..."
source ~/.local/share/omakub/install.sh
