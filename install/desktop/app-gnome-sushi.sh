#!/bin/bash

# Gives you previews in the file manager when pressing space
# Note: gnome-sushi may not be available in all Arch repositories
# It's an optional enhancement and the file manager works fine without it
echo "gnome-sushi is optional and may not be available in all Arch repositories"
echo "The file manager works fine without it"
# Attempting installation, but not failing if unavailable
paru -S --noconfirm gnome-sushi 2>/dev/null || true
