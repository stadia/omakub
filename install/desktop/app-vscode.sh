#!/bin/bash

# Install Visual Studio Code from AUR
paru -S --noconfirm visual-studio-code-bin

mkdir -p ~/.config/Code/User
cp ~/.local/share/omakub/configs/vscode.json ~/.config/Code/User/settings.json

# Install default supported themes
code --install-extension enkia.tokyo-night