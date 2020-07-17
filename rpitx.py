#!/usr/bin/env python

import RPi.GPIO as GPIO
import subprocess
import time
import os

GPIO.setmode(GPIO.BCM)
GPIO.setup(27, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.setup(12, GPIO.IN, pull_up_down=GPIO.PUD_UP)
transmit = False
if GPIO.input(12) == False:
	transmit = True
if GPIO.input(27) == False:
	transmit = True

print(transmit)

file = open("/home/pi/CubeSatSim/sim.cfg")
callsign = file.readline().split(" ")[0]
print(callsign)

if __name__ == "__main__":
#    print(f"Arguments count: {len(sys.argv)}")
#    for i, arg in enumerate(sys.argv):
#        print(f"Argument {i:>6}: {arg}")
#
    print 'Length: ', len(sys.argv)
    
    if (len(sys.argv)) > 1:
#        print("There are arguments!")
        if (('a' == sys.argv[1]) or ('afsk' in sys.argv[1])):
            print("AFSK") 
#	    os.system("sleep infinity")
        elif (('b' == sys.argv[1]) or ('bpsk' in sys.argv[1])):
            print("BPSK")
#	    os.system("sudo nc -l 8080 | csdr convert_i16_f | csdr fir_interpolate_cc 2 | csdr dsb_fc | csdr bandpass_fir_fft_cc 0.002 0.06 0.01 | csdr fastagc_ff | sudo /home/pi/rpitx/sendiq -i /dev/stdin -s 96000 -f 434.8945e6 -t float")
	else:
            mode = FSK
            print("FSK") 
#	    os.system("sudo nc -l 8080 | csdr convert_i16_f | csdr gain_ff 7000 | csdr convert_f_samplerf 20833 | sudo /home/pi/rpitx/rpitx -i- -m RF -f 434.897e3")
