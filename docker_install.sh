#!/bin/bash

#Make sure no previous versions of docker exist.
sudo apt-get remove docker docker-engine docker.io containerd runc
# Update apt repositories
echo "updating VM"
sudo apt-get update -y
echo "setup docker repositories"
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
# Add Docker’s official GPG key / Repository:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker engine
echo "installing Docker engine"
sudo apt-get update -y
sudo apt-get install  -y docker-ce docker-ce-cli containerd.io
# Install Docker compose
echo "installing Docker compose"
sudo apt install -y docker-compose
# Verify Docker correct installation
sudo usermod -aG docker $USER
## installation complete
echo "installation complete--"

