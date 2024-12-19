#include <FastLED.h>
#include <SPI.h>
#include "lib\ADS131E08esp32.cpp"
#include <ICM42670P.h>

#define NUM_LEDS 2 //setup the SK6812 LEDS
#define DATA_PIN 21

#define ADC_RESET 7 //setup the ADS131E08
#define ADC_START 8
#define ADC_DRDY 9
#define ADC_CS 10
#define ADC_MOSI 11 
#define ADC_SCLK 12
#define ADC_MISO 13

#define VSPI_MISO 37  //pins for IMU
#define VSPI_MOSI 35
#define VSPI_SCLK 36
#define VSPI_SS   39


CRGB leds[NUM_LEDS];

SPIClass* vspi = NULL;
SPIClass* hspi = NULL;

ICM42670* IMU = NULL;

void setup() {
  Serial.begin(115200);
  while(!Serial) {}

  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); //initialize PWR_ON LED
  FastLED.setBrightness(100);
  leds[0] = CRGB::Green; FastLED.show();
  

  hspi = new SPIClass(HSPI);                        //SPI initialization moved into this file
  vspi = new SPIClass(FSPI);                        //using FSPI as the IDE doesn't recognize VSPI 
  hspi->begin(ADC_SCLK, ADC_MISO, ADC_MOSI, ADC_CS);
  vspi->begin(VSPI_SCLK, VSPI_MISO, VSPI_MOSI, VSPI_SS);

  /*/code to  test if SPI works in general -> works as intended
  IMU = new ICM42670(*vspi, 39);
  int  ret = IMU->begin();
  if (ret != 0) {
    Serial.print("ICM42670 initialization failed: ");
    Serial.println(ret);
    while(1);
  }
  // Accel ODR = 100 Hz and Full Scale Range = 16G
  IMU->startAccel(100,16);
  // Gyro ODR = 100 Hz and Full Scale Range = 2000 dps
  IMU->startGyro(100,2000);
  // Wait IMU to start
  delay(100);
  */

  pinMode(ADC_RESET, OUTPUT);
  pinMode(ADC_START, OUTPUT);
  pinMode(ADC_DRDY, INPUT_PULLUP);
  pinMode(ADC_CS, OUTPUT);

  attachInterrupt(digitalPinToInterrupt(ADC_DRDY), ADS131E08_drdy_int_handl, LOW);

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

  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_GPIO_ADDRESS, 0b11110000, 2);
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_RREG, E08_GPIO_ADDRESS, 0, 1);
  }


  

void loop() {
  /*/code to see if SPI works in general
  	inv_imu_sensor_event_t imu_event;

  // Get last event
  IMU->getDataFromRegisters(imu_event);

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
  */

  //TODO: communicate with ADS131E08

  leds[1] = CRGB::Black; FastLED.show();
  delay(300);
  leds[1] = CRGB::Blue; FastLED.show();
	
}