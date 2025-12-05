#!/bin/bash

# Install Docker from official repos
sudo pacman -S --noconfirm docker docker-compose docker-buildx

# Enable Docker service
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}

# Limit log size to avoid running out of disk
sudo mkdir -p /etc/docker
echo '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json >/dev/null
sudo systemctl restart docker.service
