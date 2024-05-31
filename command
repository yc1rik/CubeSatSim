#!/bin/bash

echo -e "\ninstallation script for CubeSatSim v1.3.2\n"

FILE=/home/pi/CubeSatSim/sim.cfg
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "creating $FILE"
    echo "AMSAT 1 0.0 0.0" > /home/pi/CubeSatSim/sim.cfg
fi

FILE=/home/pi/CubeSatSim/command_tx
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "creating $FILE"
    echo "True\n" > /home/pi/CubeSatSim/command_tx
fi

FILE=/home/pi/CubeSatSim/command_count.txt
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "creating $FILE"
    echo "0\n" > /home/pi/CubeSatSim/command_count.txt
fi

cd

CubeSatSim/config -c -n

CubeSatSim/config -l -n
  
sudo apt-get update && sudo apt-get dist-upgrade -y

# removed wiringpi and python-picamera python3-picamera 
sudo apt-get install -y git libasound2-dev i2c-tools build-essential libgd-dev libmagic-dev minicom

cd /tmp

wget https://project-downloads.drogon.net/wiringpi-latest.deb

sudo dpkg -i wiringpi-latest.deb


cd

#changed to python3-smbus
sudo apt install -y python3-pip python3-smbus

sudo pip3 install --upgrade setuptools

sudo pip3 install adafruit-blinka RPI.GPIO adafruit-extended-bus adafruit-circuitpython-ina219



cd ~/CubeSatSim

git pull --no-rebase

make debug

FILE=/home/pi/CubeSatSim/.mode
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
    echo "creating $FILE"
    echo "f" > .mode
fi

cd

git clone https://github.com/alanbjohnston/direwolf.git

cd direwolf

make -j

sudo make install

make install-rpi


cd

git clone https://github.com/alanbjohnston/pi-power-button.git

cd pi-power-button

git checkout reboot-mode-change

./script/install


cd

git clone https://github.com/alanbjohnston/PiSSTVpp.git

cd PiSSTVpp

make pisstvpp

echo "Copying SSTV image 1"
cp /home/pi/CubeSatSim/sstv/sstv_image_1_320_x_256.jpg /home/pi/CubeSatSim/sstv_image_1_320_x_256.jpg

echo "Copying SSTV image 2"
cp /home/pi/CubeSatSim/sstv/sstv_image_2_320_x_256.jpg /home/pi/CubeSatSim/sstv_image_2_320_x_256.jpg

cd

git clone https://github.com/alanbjohnston/rpitx.git

cd rpitx

./install.sh


cd

cd

sudo cp ~/CubeSatSim/systemd/cubesatsim.service /etc/systemd/system/cubesatsim.service

sudo systemctl enable cubesatsim

sudo cp ~/CubeSatSim/systemd/rpitx.service /etc/systemd/system/rpitx.service

sudo systemctl enable rpitx

sudo cp /boot/config.txt /boot/config.txt.0

sudo cp /boot/cmdline.txt /boot/cmdline.txt.0


sudo raspi-config nonint do_i2c 0

sudo raspi-config nonint do_camera 0

sudo raspi-config nonint do_legacy 0

#if [ "$1" = "u" ]; then
#fi

##  sudo sed -i 's/console=serial0,115200 //g' /boot/cmdline.txt
  

  sudo sed -i 's/console=serial0,115200 //g' /boot/cmdline.txt

  sudo sed -i 's/console=tty1 r/console=tty1 maxcpus=1 r/g' /boot/cmdline.txt # single core if Pi Zero 2

  sudo sed -i 's/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g' /boot/config.txt
  
  if [[ $(grep 'dtoverlay=i2c-gpio,bus=3,i2c_gpio_delay_us=1,i2c_gpio_sda=23,i2c_gpio_scl=24' /boot/config.txt) ]]; then
    echo "dtoverlay=i2c-gpio already in /boot/config.txt"
  else
    echo "adding dtoverlay=i2c-gpio to /boot/config.txt"
    sudo sh -c 'echo "\ndtoverlay=i2c-gpio,bus=3,i2c_gpio_delay_us=1,i2c_gpio_sda=23,i2c_gpio_scl=24" >> /boot/config.txt'
  fi

  if [[ $(grep 'enable_uart=1' /boot/config.txt) ]]; then
    echo "enable_uart=1 already in /boot/config.txt"
  else
    echo "adding enable_uart=1 to /boot/config.txt"
    sudo sh -c 'echo "\nenable_uart=1" >> /boot/config.txt'
  fi
  
  if [[ $(grep 'dtoverlay=disable-bt' /boot/config.txt) ]]; then
    echo "dtoverlay=disable-bt already in /boot/config.txt"
  else
    echo "adding dtoverlay=disable-bt to /boot/config.txt"
    sudo sh -c 'echo "\ndtoverlay=disable-bt" >> /boot/config.txt'
  fi
  
  if [[ $(grep 'dtoverlay=dwc2' /boot/config.txt) ]]; then
    echo "dtoverlay=dwc2 aalready in /boot/config.txt"
  else
    echo "adding dtoverlay=dwc2 to /boot/config.txt"
    sudo sh -c 'echo "\ndtoverlay=dwc2" >> /boot/config.txt'
  fi

  if [[ $(grep 'modules-load=dwc2,g_ether' /boot/cmdline.txt) ]]; then
    echo "modules-load=dwc2,g_ether already in /boot/cmdline.txt"
  else
    echo "adding modules-load=dwc2,g_ether to /boot/cmdline.txt"
    sudo sed -i 's/ rootwait/ rootwait modules-load=dwc2,g_ether/g' /boot/cmdline.txt
  fi
  
  if [[ $(grep 'dtparam=audio=on' /boot/config.txt) ]]; then
    echo "dtparam=audio=on already in /boot/config.txt"
  else
    echo "adding dtparam=audio=on to /boot/config.txt"
    sudo sh -c 'echo "\ndtparam=audio=on" >> /boot/config.txt'
  fi

  if [[ $(grep 'dtoverlay=audremap,enable_jack=on' /boot/config.txt) ]]; then
    echo "dtoverlay=audremap,enable_jack=on already in /boot/config.txt"
  else
    echo "adding dtoverlay=audremap,enable_jack=on to /boot/config.txt"
    sudo sh -c 'echo "\ndtoverlay=audremap,enable_jack=on" >> /boot/config.txt'
  fi

  if [[ $(grep 'dtoverlay=pwm,pin=18,func=2' /boot/config.txt) ]]; then
    echo "dtoverlay=pwm,pin=18,func=2 already in /boot/config.txt"
  else
    echo "adding  to /boot/config.txt"
    sudo sh -c 'echo "\ndtoverlay=pwm,pin=18,func=2" >> /boot/config.txt'
  fi

  if [[ $(grep 'disable_splash=1 ' /boot/config.txt) ]]; then
    echo "disable_splash=1 already in /boot/config.txt"
  else
    echo "adding  to /boot/config.txt"
    sudo sh -c 'echo "\ndisable_splash=1" >> /boot/config.txt'
  fi

  if [[ $(grep 'boot_delay=0' /boot/config.txt) ]]; then
    echo "boot_delay=0 already in /boot/config.txt"
  else
    echo "adding  to /boot/config.txt"
    sudo sh -c 'echo "\nboot_delay=0" >> /boot/config.txt'
  fi

  if ! grep -q force_turbo=1 /boot/config.txt ; then sudo sh -c 'echo "force_turbo=1" >> /boot/config.txt'; fi

sudo sh -c 'echo "\n" >> /boot/config.txt'

changed=0
value=`cat /home/pi/CubeSatSim/sim.cfg`
echo "$value" > /dev/null
set -- $value

if [ -z "$1" ] ; then n1="AMSAT" ; changed=1 ; else n1=$1 ; fi # callsign
if [ -z "$2" ] ; then n2="0" ; changed=1 ; else n2=$2 ; fi # reset count
if [ -z "$3" ] ; then n3="0" ; changed=1 ; else n3=$3 ; fi # lat
if [ -z "$4" ] ; then n4="0" ; changed=1 ; else n4=$4 ; fi # lon
if [ -z "$5" ] ; then n5="no" ; changed=1 ; else n5=$5 ; fi # sim mode
if [ -z "$6" ] ; then n6="3" ; changed=1 ; else n6=$6 ; fi # squelch
if [ -z "$7" ] ; then n7="434.9000" ; changed=1 ; else n7=$7 ; fi # transmit frequency
if [ -z "$8" ] ; then n8="435.0000" ; changed=1 ; else n8=$8 ; fi # receive frequency
if [ -z "$9" ] ; then n9="no" ; changed=1 ; else n9=$9 ; fi # hab mode

if [ $changed -eq 1 ]; then
	echo -e "Current sim.cfg configuration file:"	
	echo
	echo $1 $2 $3 $4 $5 $6 $7 $8 $9
	echo -e "\nCubeSatSim configuraation sim.cfg file updated to: \n"
	echo
	echo $n1 $n2 $n3 $n4 $n5 $n6 $n7 $n8 $n9
	echo $n1 $n2 $n3 $n4 $n5 $n6 $n7 $n8 $n9 > /home/pi/CubeSatSim/sim.cfg
	echo
fi

echo "Would you like to reboot to complete the installation (y/n)?"

read -r ANS

if [ "$ANS" = "y" ]; then

    sudo reboot now

else

    echo "The CubeSatSim software will start next time you reboot"
    
fi
