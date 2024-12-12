#include <FastLED.h>
#include <SPI.h>
#include "lib\ADS131E08esp32.cpp"
#include "lib\spi_multiple_buses.c"

#define NUM_LEDS 2 //setup the SK6812 LEDS
#define DATA_PIN 21

#define ADC_RESET 7 //setup the ADS131E08
#define ADC_START 8
#define ADC_DRDY 9
#define ADC_CS 10
#define ADC_MOSI 11 
#define ADC_SCLK 12
#define ADC_MISO 13



CRGB leds[NUM_LEDS];

void setup() {
  Serial.begin(115200);
  while(!Serial) {}

  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); //initialize PWR_ON LED
  FastLED.setBrightness(100);
  leds[0] = CRGB::Green; FastLED.show();
  
  SPIClass* vspi = NULL;
  SPIClass* hspi = NULL;
  mSPIsetup(vspi, hspi); 

  pinMode(ADC_RESET, OUTPUT);
  pinMode(ADC_START, OUTPUT);
  pinMode(ADC_DRDY, OUTPUT);
  pinMode(ADC_CS, OUTPUT);

  //TODO: initialize ADS131E08
  // ADC, VCAP1 > 1.1v takes about 1.3 seconds, 2 seconds delay to be stable status
  delay(2000);

  ADS131E08_init(ADS131E08_ADC20, hspi, ADC_RESET, ADC_CS, ADC_DRDY, ADC_START);
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