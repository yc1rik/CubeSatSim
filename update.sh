#!/bin/bash

echo -e "\nupdate script for CubeSatSim\n"

if [ "$1" = "u" ]; then

  sudo apt-get update && sudo apt-get dist-upgrade -y

  sudo apt-get install -y wiringpi git libasound2-dev i2c-tools cpulimit

fi

cd /home/pi/CubeSatSim

git pull > .updated

make debug

FLAG=0

if [[ $(diff systemd/cubesatsim.service /etc/systemd/system/cubesatsim.service) ]]; then
  echo "copying cubesatsim.service"
  sudo cp systemd/cubesatsim.service /etc/systemd/system/cubesatsim.service
  FLAG=1
else
  echo "no changes to cubesatsim.service"
fi

if [[ $(diff systemd/rpitx.service /etc/systemd/system/rpitx.service) ]]; then
  echo "copying rpitx.service"
  sudo cp systemd/rpitx.service /etc/systemd/system/rpitx.service
  FLAG=1
else
  echo "no changes to rpitx.service"
fi

if [ $FLAG -eq 1 ]; then
  echo "systemctl daemon-reload and restart"
  sudo systemctl daemon-reload
  sudo systemctl restart cubesatsim
else
  grep 'changed' /home/pi/CubeSatSim/.updated
  if [[ $(grep 'changed' /home/pi/CubeSatSim/.updated) ]]; then
    echo "systemctl restart cubesatsim"
    sudo systemctl restart cubesatsim
  else
    echo "nothing to do"
  fi  
fi
