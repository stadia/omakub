#!/bin/bash

sudo pacman -Rns --noconfirm docker docker-compose docker-buildx
sudo groupdel docker
