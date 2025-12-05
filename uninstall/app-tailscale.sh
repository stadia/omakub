#!/bin/bash

sudo pacman -R --noconfirm tailscale
sudo systemctl disable tailscaled.service
