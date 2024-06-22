// Mods to this file by Alan B Johnston KU2Y
//
// changed setup to aio_setup and loop to aio_loop 
//
// You must put your account and WiFi info and rename config file as config.h
//
// Adafruit IO Publish Example
//
// Adafruit invests time and resources providing this open source code.
// Please support Adafruit and open source hardware by purchasing
// products from Adafruit!
//
// Written by Todd Treece for Adafruit Industries
// Copyright (c) 2016 Adafruit Industries
// Licensed under the MIT license.
//
// All text above must be included in any redistribution.

/************************** Configuration ***********************************/

// edit the config.h tab and enter your Adafruit IO credentials
// and any additional configuration needed for WiFi, cellular,
// or ethernet clients.
#include "config.h"

/************************ Example Starts Here *******************************/

// this int will hold the current count for our sketch
int count = 0;
bool aio_connected = false;
unsigned long delay;

// set up the 'counter' feed
//AdafruitIO_Feed *counter = io.feed("counter");
AdafruitIO_Feed *temperature = io.feed("temperature");
AdafruitIO_Feed *pressure = io.feed("pressure");
AdafruitIO_Feed *altitude = io.feed("altitude");
AdafruitIO_Feed *humidity = io.feed("humidity");

void aio_setup() {
/*
  // start the serial connection
  Serial.begin(115200);

  // wait for serial monitor to open
  while(! Serial);
*/
  Serial.print("\nConnecting to Adafruit IO");

  // connect to io.adafruit.com
  io.connect();

/*  // wait for a connection
  while(io.status() < AIO_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  // we are connected
  Serial.println();
  Serial.println(io.statusText());
*/
  delay = millis();
}

void aio_loop(float tlm[]) {

  if (!aio_connected) {
    if (io.status() < AIO_CONNECTED) {
       Serial.println("\nConnecting to Adafruit IO...");
    } else {
      Serial.print("\nSuccessfully connected to Adafruit IO! Status: ");
//      Serial.println();
      Serial.println(io.statusText());
      aio_connected = true;
    }
  } else {
    // io.run(); is required for all sketches.
    // it should always be present at the top of your loop
    // function. it keeps the client connected to
    // io.adafruit.com, and processes any incoming data.
    io.run();

    if ((millis() - delay) > 8000)    {  // Only send if 8 seconds have passed 
      delay = millis();
      // save count to the 'counter' feed on Adafruit IO
      Serial.print("\nSending to Adafruit IO -> ");
    //  Serial.println(count);
    //  counter->save(count);
      Serial.print(tlm[0]);
      temperature->save(tlm[0]);
      Serial.print(" ");
      Serial.print(tlm[1]);
      pressure->save(tlm[1]);
      Serial.print(" ");
      Serial.print(tlm[2]);
      altitude->save(tlm[2]);
      Serial.print(" ");
      Serial.print(tlm[3]);
      humidity->save(tlm[3]);
  
      Serial.println(" ");
      
      // increment the count by 1
      count++;
    
      // Adafruit IO is rate limited for publishing, so a delay is required in
      // between feed->save events. In this example, we will wait three seconds
      // (1000 milliseconds == 1 second) during each loop. 
      //    delay(10000); // 1000
    }
  }
}
