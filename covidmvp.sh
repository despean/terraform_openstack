#!/bin/bash
## deploy covid mvp
DIRECTORY="COVID-MVP"
if [ ! -d "$DIRECTORY" ]; then
  sudo git clone https://github.com/cidgoh/COVID-MVP.git
fi

cd COVID-MVP
sudo git pull
sudo docker-compose -f production.yml build
sudo docker-compose -f production.yml up
