#include <FastLED.h>
#include <SPI.h>
#include "lib\ADS131E08esp32.cpp"
#include "lib\spi_multiple_buses.c"

#define NUM_LEDS 2 //setup the SK6812 LEDS
#define DATA_PIN 21



CRGB leds[NUM_LEDS];

void setup() { 
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); //initialize PWR_ON LED
  leds[0] = CRGB::Green; FastLED.show();
  
  SPIClass* vspi = NULL;
  SPIClass* hspi = NULL;
  mSPIsetup(vspi, hspi); 

  Serial.begin(115200);
  while(!Serial) {}
}


  

void loop() {

  leds[1] = CRGB::Black; FastLED.show();
  delay(300);
  leds[1] = CRGB::Beige; FastLED.show();
	
}