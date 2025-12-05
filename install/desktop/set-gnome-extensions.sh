#!/bin/bash

sudo pacman -S --noconfirm extension-manager libgtop clutter
pipx install gnome-extensions-cli --system-site-packages

# Disable default extensions if they exist
# Note: These are Ubuntu-specific extensions that may not be present on Arch
gnome-extensions disable ding@rastersoft.com 2>/dev/null || true

# Pause to assure user is ready to accept confirmations
gum confirm "To install Gnome extensions, you need to accept some confirmations. Ready?"

# Install new extensions
gext install tiling-assistant@leleat-on-github
gext install dash-to-dock@micxgx.gmail.com
gext install tactile@lundal.io
gext install just-perfection-desktop@just-perfection
gext install blur-my-shell@aunetx
gext install space-bar@luchrioh
gext install undecorate@sun.wxg@gmail.com
gext install tophat@fflewddur.github.io
gext install AlphabeticalAppGrid@stuarthayhurst

# Compile gsettings schemas in order to be able to set them
sudo cp ~/.local/share/gnome-shell/extensions/tiling-assistant@leleat-on-github/schemas/org.gnome.shell.extensions.tiling-assistant.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo cp ~/.local/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas/org.gnome.shell.extensions.dash-to-dock.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo cp ~/.local/share/gnome-shell/extensions/just-perfection-desktop\@just-perfection/schemas/org.gnome.shell.extensions.just-perfection.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo cp ~/.local/share/gnome-shell/extensions/blur-my-shell\@aunetx/schemas/org.gnome.shell.extensions.blur-my-shell.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo cp ~/.local/share/gnome-shell/extensions/space-bar\@luchrioh/schemas/org.gnome.shell.extensions.space-bar.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo cp ~/.local/share/gnome-shell/extensions/tophat@fflewddur.github.io/schemas/org.gnome.shell.extensions.tophat.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo cp ~/.local/share/gnome-shell/extensions/AlphabeticalAppGrid\@stuarthayhurst/schemas/org.gnome.shell.extensions.AlphabeticalAppGrid.gschema.xml /usr/share/glib-2.0/schemas/ 2>/dev/null || true
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# Configure Tiling Assistant
gsettings set org.gnome.shell.extensions.tiling-assistant window-gap 8 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tiling-assistant tile-by-default false 2>/dev/null || true

# Configure Dash to Dock
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode ADAPTIVE 2>/dev/null || true

# Configure Tactile
gsettings set org.gnome.shell.extensions.tactile col-0 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile col-1 2 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile col-2 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile col-3 0 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile row-0 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile row-1 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile gap-size 32 2>/dev/null || true

# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection animation 2 2>/dev/null || true
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.just-perfection workspace true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false 2>/dev/null || true

# Configure Blur My Shell
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default' 2>/dev/null || true

# Configure Space Bar
gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []" 2>/dev/null || true

# Configure TopHat
gsettings set org.gnome.shell.extensions.tophat show-icons false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-cpu false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-disk false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-mem false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-fs false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits 2>/dev/null || true

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end' 2>/dev/null || true
