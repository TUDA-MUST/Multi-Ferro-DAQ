//This program should be uploaded with Events and Arduino running on
//core 0.

#include <FastLED.h>
#include <SPI.h>
#include "../lib/ADS131E08esp32.cpp"
#include <WiFi.h>
#include <WiFiClient.h>

struct chanData_float{
  byte chan[9][4];                  //stores data measured in channels, ninth entry stores time
  byte faultp;                      //saves if inputs exceed threshold on positive input
  byte faultn;                      //saves if inputs exceed threshold on negative input
};



#define NUM_LEDS 2                  //setup the SK6812 LEDS
#define DATA_PIN 21

#define ADC_PWRDWN 6                //setup the ADS131E08
#define ADC_RESET 7 
#define ADC_START 8
#define ADC_DRDY 9
#define ADC_CS 10
#define ADC_MOSI 11 
#define ADC_SCLK 12
#define ADC_MISO 13

#define VSPI_MISO 37                //pins for IMU
#define VSPI_MOSI 35
#define VSPI_SCLK 36
#define VSPI_SS   39


CRGB leds[NUM_LEDS];

SPIClass* vspi = NULL;
SPIClass* hspi = NULL;


TaskHandle_t aquireTask;
TaskHandle_t sendTask;
QueueHandle_t datatransferQueue;
void aquireTaskCode(void* params);
void sendTaskCode(void* params);

int ADC_stat[3];
float ADC_chan_voltage[8];
_adcConfE* adcConfRead;
                            

struct chanData_float *chanData_send_ptr;



/////////////////////////////////////////////////////////////////////////////////////////////




// this ISR handles the data aquisition from the ADS131E08 and saves the raw channel data,
// faultbits and time of aquisition (in regards to system startup) in a queue

void  IRAM_ATTR DRDY_read_int_handle(){
    
    ADS131E08_send_rdata_cmd(ADS131E08_ADC20);    
    
    chanData_send_ptr = (struct chanData_float*) malloc(sizeof(struct chanData_float));
    if (chanData_send_ptr != NULL) {
    for (int i = 0; i < NUMB_ADC_CH; i++) {
       chanData_send_ptr->chan[i][0] = adcConfRead->rxBuf[3*i+4];           //reading out the 24-bits of data per channel
       chanData_send_ptr->chan[i][1] = adcConfRead->rxBuf[3*i+5];
       chanData_send_ptr->chan[i][2] = adcConfRead->rxBuf[3*i+6];
    }

    chanData_send_ptr->faultp = adcConfRead->rxBuf[1];
    chanData_send_ptr->faultn = adcConfRead->rxBuf[2];

    union {
    float float_variable;
    byte temp_array[4];
    } u;

    u.float_variable = (float) esp_timer_get_time();
    memcpy(chanData_send_ptr->chan[8], u.temp_array, 4);

    xQueueSendFromISR(datatransferQueue, (void *) &chanData_send_ptr, NULL);
    }
    

}




/////////////////////////////////////////////////////////////////////////////////////////////




inline void convert_data(struct chanData_float *chanData_recv_ptr, byte amparr[8]){ // converts 8 adc channels to mV for Schlaubi 
  
  union {                                                           // Create union of shared memory space
    float float_variable;
    byte temp_array[4];
  } u;

  const float unitFS = 4000.0f / 8388608.0f;                        // unit: mV (if unit is V, calculated value is out of 'float' range)(4V / (2^24/2))
	const uint32_t boundaryValue = 0x7FFFFF;                          // threshold of positive value 
	int signFlg = 0;		                                              // +: 1, -: -1
  
  for(int i = 0; i < 8; i++){
    char chanfilter = 1 << i;
    if(chanData_recv_ptr->faultp & chanfilter){                     //the value of +/- 9999 is used to indicate out of bounds errors 
      u.float_variable = 9999;
    }else if(chanData_recv_ptr->faultn & chanfilter){
      u.float_variable = -9999;
    }
    if(0 ==1){}else{
      uint32_t reg = ((uint32_t)((uint8_t)chanData_recv_ptr->chan[i][0] << 16) & 0x00FF0000) | ((uint32_t)((uint8_t)chanData_recv_ptr->chan[i][1] << 8) & 0x0000FF00) | ((uint32_t)((uint8_t)chanData_recv_ptr->chan[i][2] << 0) & 0x000000FF);
      if (reg > boundaryValue)                                      // negative value
      {
          reg = (0xFFFFFF - reg) + 1;                               // if value is 0xFFFFFF, register is -FS/2^23. so plus 1 
          signFlg = -1;
      }
      else                                                          // positive value
      {
          signFlg = 1;
      }

      u.float_variable = (unitFS * (float)reg * (float)signFlg / amparr[i]);      // convert register to mVolt
    }
    memcpy(chanData_recv_ptr->chan[i], u.temp_array, 4);
  }
}





/////////////////////////////////////////////////////////////////////////////////////////////





inline void set_sample_rate(uint32_t wordarr[2]){
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_RREG, E08_CONFIG1_ADDRESS, 0, 1);       //configure sample rate (example how to configure with masks)
  uint8_t conf1 = adcConfRead->rxBuf[0] & (~E08_CONFIG1_DR_MASK);
  switch (wordarr[0]){
    case 1000: conf1 |= E08_CONFIG1_DR_MASK & E08_DR_1KSPS;
               break;
    case 2000: conf1 |= E08_CONFIG1_DR_MASK & E08_DR_2KSPS;
               break;
    case 4000: conf1 |= E08_CONFIG1_DR_MASK & E08_DR_4KSPS;
               break;
    case 8000: conf1 |= E08_CONFIG1_DR_MASK & E08_DR_8KSPS;
               break;
    case 16000: conf1 |= E08_CONFIG1_DR_MASK & E08_DR_16KSPS;
               break;
    case 32000: conf1 |= E08_CONFIG1_DR_MASK & E08_DR_32KSPS;
               break;
    case 64000: conf1 |= E08_CONFIG1_DR_MASK & E08_DR_64KSPS;
               break;
    default: return;
  }
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CONFIG1_ADDRESS, conf1, 1);
}




/////////////////////////////////////////////////////////////////////////////////////////////





inline void set_channels(uint16_t hword[8]){
  for(int i = 0; i < 8; i++){
    ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH1SET_ADDRESS+i, hword[i], 1);
  }
}




/////////////////////////////////////////////////////////////////////////////////////////////






int set_preamp(byte amparr[16]){
  for(int i = 0; i < 8; i++){
    ADS131E08_send_command(adcConfE0, ADS131E08_CMD_RREG, E08_CH1SET_ADDRESS + i, 0, 1);
    uint8_t conf1 = adcConfRead->rxBuf[0] & (~E08_CH1SET_GAIN_MASK);   
    switch(amparr[i]){
      case 1: conf1 |= E08_CH1SET_GAIN_MASK & E08_CH1SET_PGA_GAIN_1;
              break;
      case 2: conf1 |= E08_CH1SET_GAIN_MASK & E08_CH1SET_PGA_GAIN_2;
              break;
      case 4: conf1 |= E08_CH1SET_GAIN_MASK & E08_CH1SET_PGA_GAIN_4;
              break;
      case 8: conf1 |= E08_CH1SET_GAIN_MASK & E08_CH1SET_PGA_GAIN_8;
              break;
      case 12: conf1 |= E08_CH1SET_GAIN_MASK & E08_CH1SET_PGA_GAIN_12;
              break;
      default: return i;
    }
    ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH1SET_ADDRESS + i, conf1, 1);
  }
  return 8;
}





/////////////////////////////////////////////////////////////////////////////////////////////




void aquireTaskCode(void* params){              
  attachInterrupt(digitalPinToInterrupt(ADC_DRDY), DRDY_read_int_handle, FALLING);
  while(1){
    vTaskDelay(1);
  }
}



/////////////////////////////////////////////////////////////////////////////////////////////





void sendTaskCode(void* params){

  
  // Access Point credentials
  const char *ssid = "ESP32_Hotspot";
  const char *password = "123456789";                    // Minimum 8 characters


  // TCP settings
  
  const int serverPort = 8080;                           // Listen on port 8080
  
  // Start the ESP32 as an Access Point (Hotspot)

  Serial.println("Setting up Access Point...");
  WiFi.softAP(ssid, password);
  WiFiServer server(serverPort);                         // Create a server object to listen for incoming connections
  WiFiClient client;
  server.begin();

  // Print the ESP32 AP IP address

  Serial.println("Access Point Started!");               
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());                       // Print the AP's IP address (usually 192.168.4.1)

  // Start the TCP communication
  
  Serial.println("TCP waiting on port 8080 - start MATLAB script");
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_GPIO_ADDRESS, 0b00001111, 1);   //turns off white LED to save power
  leds[0] = CRGB::Magenta; FastLED.show();                                                  // signals that the ESP & ADS131E08 are set up and ready to communicate

  byte buffer[2304];                                                                        // 9 floats * 4 bytes each => 36 bytes * 64 datasets = 2304 bytes buffer
  byte amparr[8];                                                                       

  
  while(1){
    while(1){
      client = server.available();
      if(client) break;
      vTaskDelay(1);
    }

    // currently the data is given raw by defining the order in which it has to arrive. Maybe in later revision a package can
    // have a leading identifier for a more elegant solution

    delay(200);                                                               //give Matlab time to send initialization data
    union {
      byte cntarray[8];
      int64_t cntnmbr;
    } measurecnt;
    union{
      byte readarray[16];
      uint16_t uint_hword[8]; 
      uint32_t uint_word[4];
    }inputbuff;

    for(int i = 0; i < 8; i++){                                              // get sample size (int64_t)
      measurecnt.cntarray[i] = client.read();
    }
    delay(200);

    for(int i = 0; i < 4; i++){                                              // get sample rate
      inputbuff.readarray[i] = client.read();
    }delay(200);
    set_sample_rate(inputbuff.uint_word);

    for(int i = 0; i < 16; i++){                                              // get individual channels settings
      inputbuff.readarray[i] = client.read();
    }delay(200);
    set_channels(inputbuff.uint_hword);


    for(int i = 0; i < 8; i++){                                              // get amp values for preamp for each channel
      inputbuff.readarray[i] = client.read();
    }delay(200);
    for(int i = 0; i < set_preamp(inputbuff.readarray);i++){                 //sets preamp values in config reg ond ADS131
      amparr[i] = inputbuff.readarray[i];                                    // saves preampvalues for later use
    }                                         
    

    
    Serial.println("ESP32 successfully connected to MATLAB");
    leds[0] = CRGB::Green; FastLED.show();                                   //signals that the connection has been established and a measurement is ongoing

    xTaskCreatePinnedToCore(aquireTaskCode, "aquireTask", 8192, NULL, 1, &aquireTask, 1);         //start collecting data
    client.flush();
    
    for(int i = 0; i < measurecnt.cntnmbr;){                                                      //this loop ends the measurement after the set amount of samples
      if(client.read() >= 0) break;                                                               //exit measurement loop, if client sends something
      
      if(uxQueueSpacesAvailable(datatransferQueue) > 448)vTaskDelay(1);
      else{
      for(int j = 0; j < 64; j++){                                                                //this loop wil wait for a package of 64 samples to be available and package them into the buffer
        struct chanData_float *chanData_recv_ptr;
        if(xQueueReceive(datatransferQueue, &(chanData_recv_ptr), portMAX_DELAY)){
          convert_data(chanData_recv_ptr, amparr);
          for(int i = 0; i < 9; i++){
            memcpy(buffer + (4 * i) + (36*j), &chanData_recv_ptr->chan[i], 4);   
          }
          free(chanData_recv_ptr);
        }
      }
      client.write(buffer, sizeof(buffer));                                                      //sending out buffer to MATLAB client via TCP
      i += 64;
      }
    }
    vTaskDelete(aquireTask);
    client.stop();
    WiFi.disconnect();
    delay(100);
    ESP.restart();                                                                               //   <- stop gap measure because I can't figure out how to connect to MATLAB again
    leds[0] = CRGB::Magenta; FastLED.show();
  }
}





////////////////////////////////////////////////////////////////////////////////////////////







void setup() {
  Serial.begin(921600);
  //while(!Serial) {}                                                    // this line is only to be used if Serial connection should be enforced
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);                   //initialize PWR_ON LED
  FastLED.setBrightness(5);                                              //don't get too bright to save power
  leds[0] = CRGB::Orange; FastLED.show();                                //singals that the ESP32 is busy and not ready to communicate


  hspi = new SPIClass(HSPI);                                             //SPI initialization moved into this file
  vspi = new SPIClass(FSPI);                                             //using FSPI as the IDE doesn't recognize VSPI 
  hspi->begin(ADC_SCLK, ADC_MISO, ADC_MOSI, ADC_CS);
  vspi->begin(VSPI_SCLK, VSPI_MISO, VSPI_MOSI, VSPI_SS);


  pinMode(ADC_RESET, OUTPUT);
  pinMode(ADC_START, OUTPUT);
  pinMode(ADC_DRDY, INPUT_PULLUP);
  pinMode(ADC_CS, OUTPUT);
  pinMode(ADC_PWRDWN, OUTPUT);

  digitalWrite(ADC_PWRDWN, HIGH);

  attachInterrupt(digitalPinToInterrupt(ADC_DRDY), ADS131E08_drdy_int_handl, LOW);

  
  delay(2000);                                                          // ADC, VCAP1 > 1.1v takes about 1.3 seconds, 2 seconds delay to be stable status

  ADS131E08_init(ADS131E08_ADC20, hspi, ADC_RESET, ADC_CS, ADC_DRDY, ADC_START);
  Serial.println("passed init...");

  ADS131E08_initialize_signal();                                        // Initialize signal(CS, START, nRESET)
  delay(500);
  Serial.println("passed initialize Singal...");

  ADS131E08_startup(ADS131E08_ADC20);
  Serial.println("passed startup...");
  adcConfRead = getadcConfE0();

  ADS131E08_control_start_signal(SET_SIGNAL);                          // Set start signal in initial flow at power up
  Serial.println("passed control start signal...");

  detachInterrupt(digitalPinToInterrupt(ADC_DRDY));

  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_GPIO_ADDRESS, 0b10000111, 1); //turns on white LED for testing (RREG/ WREG) -> successful
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_RREG, E08_GPIO_ADDRESS, 0, 1);
  delay(40);

  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_RREG, E08_CONFIG1_ADDRESS, 0, 1);       //configure sample rate (example how to configure with masks)
  uint8_t conf1 = adcConfRead->rxBuf[0] & (~E08_CONFIG1_DR_MASK);
  conf1 |= E08_CONFIG1_DR_MASK & E08_DR_2KSPS;
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CONFIG1_ADDRESS, conf1, 1);
  
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CONFIG3_ADDRESS, 0xEC, 1);    //setting V_ref to 4V and activating OPAMP
  
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_SDATAC, 0, 0, 1);                       //stop continuous data readout
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CONFIG2_ADDRESS, 0xE3, 1);    //configure test signal E3: extern, F4: intern
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH1SET_ADDRESS, 0x10, 1);     //set CH1 to extern measurement //10: measurement, 15: test signal, 90: pwr down
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH2SET_ADDRESS, 0x10, 1);
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH3SET_ADDRESS, 0x10, 1);
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH4SET_ADDRESS, 0x10, 1);
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH5SET_ADDRESS, 0x10, 1);
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH6SET_ADDRESS, 0x10, 1);
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH7SET_ADDRESS, 0x10, 1);
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH8SET_ADDRESS, 0x10, 1);
  digitalWrite(ADC_START, HIGH);                                                         //start conversion



  datatransferQueue = xQueueCreate(512, sizeof(struct chanData_float *));                //setting up queue to send data from aquisirion ISR to the task converting it and sending it out via WiFi 
  if(datatransferQueue == NULL) Serial.println("Queue not initialized");
  xTaskCreatePinnedToCore(sendTaskCode, "sendTask", 8192, NULL, 1, &sendTask, 0);        //start the task that sends out data on core 0, this task will start the other task/ ISR
}




/////////////////////////////////////////////////////////////////////////////////////////////



// loop is not used in this programm
void loop() {
  vTaskDelay(portMAX_DELAY);
}




