#!/bin/bash

# Virtualbox allows you to run VMs for other flavors of Linux or even Windows
# See https://ubuntu.com/tutorials/how-to-run-ubuntu-desktop-on-a-virtual-machine-using-virtualbox#1-overview
# for a guide on how to run Ubuntu inside it.

sudo pacman -S --noconfirm virtualbox virtualbox-host-modules-arch
paru -S --noconfirm virtualbox-ext-oracle
sudo usermod -aG vboxusers ${USER}
