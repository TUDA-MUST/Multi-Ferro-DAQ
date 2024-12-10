#include <FastLED.h>
#include <SPI.h>
#include "lib\ADS131E08esp32.cpp"
#include "lib\spi_multiple_buses.c"

#define NUM_LEDS 2 //setup the SK6812 LEDS
#define DATA_PIN 21



CRGB leds[NUM_LEDS];

void setup() {
  Serial.begin(115200);
  while(!Serial) {}

  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); //initialize PWR_ON LED
  leds[0] = CRGB::Green; FastLED.show();
  
  SPIClass* vspi = NULL;
  SPIClass* hspi = NULL;
  mSPIsetup(vspi, hspi); 

  //TODO: initialize ADS131E08
  // ADC, VCAP1 > 1.1v takes about 1.3 seconds, 2 seconds delay to be stable status
  delay(2000);

  ADS131E08_init(ADS131E08_ADC20, hspi, 7, 10, 9, 8);
  Serial.println("passed init...");

  // Initialize signal(CS, START, nRESET)
  ADS131E08_initialize_signal();
  delay(500);
  Serial.println("passed initialize Singal...");

   // Start up
  ADS131E08_startup(ADS131E08_ADC20);
  Serial.println("passed startup...");
  
  // Set start signal in initial flow at power up
  ADS131E08_control_start_signal(SET_SIGNAL);
  Serial.println("passed control start signal...");
  }


  

void loop() {

  //TODO: communicate with ADS131E08

  leds[1] = CRGB::Black; FastLED.show();
  delay(300);
  leds[1] = CRGB::Beige; FastLED.show();
	
}