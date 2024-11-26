// this is an example from https://github.com/FastLED/FastLED
// New feature! Overclocking WS2812
// #define FASTLED_OVERCLOCK 1.2 // 20% overclock ~ 960 khz.
#include <FastLED.h>
#define NUM_LEDS 2
#define DATA_PIN 21
CRGB leds[NUM_LEDS];
void setup() { FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); }
void loop() {
	leds[0] = CRGB::Blue; FastLED.show(); 
	leds[1] = CRGB::Yellow; FastLED.show(); 
  delay(300);
	leds[0] = CRGB::Red; FastLED.show(); 
  leds[1] = CRGB::Green; FastLED.show(); 
  delay(300);
}
