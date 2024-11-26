//this file uses code snippets from the ICM42670P example projects

#include <FastLED.h>
#include <ICM42670P.h>

#define NUM_LEDS 2 //setup the SK6812 LEDS
#define DATA_PIN 21

// Instantiate an ICM42670 with SPI interface and CS on pin 8
ICM42670 IMU(SPI,39);

CRGB leds[NUM_LEDS];

void setup() { 
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); //initialize PWR_ON LED
  leds[0] = CRGB::Green; FastLED.show(); 

  int ret;
  Serial.begin(115200);
  while(!Serial) {}

  // Initializing the ICM42670
  ret = IMU.begin();
  if (ret != 0) {
    Serial.print("ICM42670 initialization failed: ");
    Serial.println(ret);
    while(1);
  }
  // Accel ODR = 100 Hz and Full Scale Range = 16G
  IMU.startAccel(100,16);
  // Gyro ODR = 100 Hz and Full Scale Range = 2000 dps
  IMU.startGyro(100,2000);
  // Wait IMU to start
  delay(100);
   }

void loop() {
	inv_imu_sensor_event_t imu_event;

  // Get last event
  IMU.getDataFromRegisters(imu_event);

  // Format data for Serial Plotter
  Serial.print("AccelX:");
  Serial.println(imu_event.accel[0]);
  Serial.print("AccelY:");
  Serial.println(imu_event.accel[1]);
  Serial.print("AccelZ:");
  Serial.println(imu_event.accel[2]);
  Serial.print("GyroX:");
  Serial.println(imu_event.gyro[0]);
  Serial.print("GyroY:");
  Serial.println(imu_event.gyro[1]);
  Serial.print("GyroZ:");
  Serial.println(imu_event.gyro[2]);
  Serial.print("Temperature:");
  Serial.println(imu_event.temperature);
  leds[1] = CRGB::Black; FastLED.show();
  delay(300);
  leds[1] = CRGB::Beige; FastLED.show();
	
}
