#!/bin/bash

# Linux Kernel Manager
# Arch uses a different kernel management system
# Use `linux` for latest, `linux-lts` for LTS, or `linux-zen` for Zen kernel
echo "Arch Linux manages kernels differently than Ubuntu"
echo "Available kernels:"
echo "  - sudo pacman -S linux (latest)"
echo "  - sudo pacman -S linux-lts (LTS)"
echo "  - sudo pacman -S linux-zen (Zen)"
echo ""
echo "To install a specific kernel, run:"
echo "  sudo pacman -S linux-zen"
