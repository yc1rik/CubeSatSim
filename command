#!/bin/bash

echo -e "\nCommand and Control script for CubeSatSim v1.3.2\n"

	FILE=/home/pi/CubeSatSim/command_control
	if [ -f "$FILE" ]; then
    		echo "Radio command and control is ON"
#			echo "Turning Command and control to OFF"
#			sudo rm /home/pi/CubeSatSim/command_control
#			echo "rebooting"
#			sudo systemctl stop rpitx
#			sudo reboot now	
#		fi

	else 
    		echo "Radio command and control is OFF"

		while true
		do
			sleep 60
		done

#		exit 1
	fi

echo "Waiting 20 seconds for USB"

sleep 20

FILE=/home/pi/CubeSatSim/command_control_direwolf
if [[ $(arecord -l | grep card) ]] && [ -f "$FILE" ]; then

	echo "Starting Direwolf DTMF and APRS Command and Control"

	if [ "$1" = "d" ]; then
	
		echo "debug mode"
	
		direwolf -c /home/pi/CubeSatSim/direwolf-cc.conf -t 0l -D 3 | python3 /home/pi/CubeSatSim/dtmf_aprs_cc.py d
	
	else
	
		direwolf -c /home/pi/CubeSatSim/direwolf-cc.conf -t 0l -D 3 | python3 /home/pi/CubeSatSim/dtmf_aprs_cc.py
	
	fi
else

	if [ -f "$FILE" ]; then

		echo "Direwolf mode set but no USB soundcard detected!"
		echo "Instead, starting Carrier (squelch) Command and Control"

	else

		echo "Starting Carrier (squelch) Command and Control"

	fi

	if [ "$1" = "d" ]; then
	
		echo "debug mode"
	
		python3 /home/pi/CubeSatSim/squelch_cc.py d
	
	else
	
		python3 /home/pi/CubeSatSim/squelch_cc.py
	
	fi	 
fi
