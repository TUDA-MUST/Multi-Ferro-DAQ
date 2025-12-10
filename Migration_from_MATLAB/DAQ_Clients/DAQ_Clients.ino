//This program should be uploaded with Events and Arduino running on
//core 0.

#include <FastLED.h>
#include <SPI.h>
#include "../lib/ADS131E08esp32.cpp"
#include "../lib/tcp_client_network.cpp"


Preferences prefs;


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

#define BUFFERSIZE 39              //utilizes TCP packges only 98.2%
#define DATASET_SIZE_BYTES 36      // 9 floats * 4 bytes
#define DATAQUEUE_SIZE 1024



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

    chanData_send_ptr->faultp = (adcConfRead->rxBuf[1] & 0x0F) << 4 + (adcConfRead->rxBuf[2] & 0xF0) >> 4;
    chanData_send_ptr->faultn = (adcConfRead->rxBuf[2] & 0x0F) << 4 + (adcConfRead->rxBuf[3] & 0xF0) >> 4;

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
  //Serial.printf("The faultbytes read to: %#X for positive and %#X for negative flags.\n", chanData_recv_ptr->faultp, chanData_recv_ptr->faultn);
  for(int i = 0; i < 8; i++){
    char chanfilter = 1 << i;
    if(chanData_recv_ptr->faultp & chanfilter){                     //the value of +/- 9999 is used to indicate out of bounds errors 
      u.float_variable = 9999;
    }else if(chanData_recv_ptr->faultn & chanfilter){
      u.float_variable = -9999;
    }else{
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


  // -------------------------
  // NETWORK SETUP
  // -------------------------
  String clientName;

  leds[0] = CRGB::Yellow;   // WiFi connecting
  FastLED.show();

  wifiConnectAndAllowOverride(clientName);


  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_GPIO_ADDRESS, 0b00001111, 1); //turns off white LED to save power when connected to WiFi
  IPAddress hostIP = discoverHostUDP();

  WiFiClient client = connectToHost(hostIP, 8080);

  sendHandshakePackage(client, 9);
  client.flush();

  // -------------------------
  // READY TO RECEIVE SETTINGS
  // -------------------------
  leds[0] = CRGB::Magenta;
  FastLED.show();

  Serial.println("TCP connected — waiting for SETTINGS package…");

  TcpPackage settingsPkg;
  settingsPkg.package_type = PING_PACKAGE;

  while (settingsPkg.package_type != SETTINGS_PACKAGE) {
    getNextTcpPackage(client, settingsPkg);
    Serial.print(".");
  }
  Serial.println("\nSettings received!");

  // -------------------------
  // APPLY SETTINGS
  // (your ADC config code unchanged)
  // -------------------------

  union {
      byte cntarray[8];
      int64_t cntnmbr;
  } measurecnt;

  union {
      byte readarray[16];
      uint16_t uint_hword[8];
      uint32_t uint_word[4];
  } inputbuff;

  memcpy(measurecnt.cntarray, settingsPkg.package, 8);
  memcpy(inputbuff.readarray, settingsPkg.package + 8, 4);
  set_sample_rate(inputbuff.uint_word);
  memcpy(inputbuff.readarray, settingsPkg.package + 12, 16);
  set_channels(inputbuff.uint_hword);
  memcpy(inputbuff.readarray, settingsPkg.package + 28, 8);
  byte amparr[8];
  for (int i = 0; i < set_preamp(inputbuff.readarray); i++) {
      amparr[i] = inputbuff.readarray[i];
  }


  // -------------------------
  // READY TO ACQUIRE
  // -------------------------
    
  Serial.println("ESP32 successfully connected to Client Monitor for Measurement");
  leds[0] = CRGB::Green; FastLED.show();                                   //signals that the connection has been established and a measurement is ongoing
  xTaskCreatePinnedToCore(aquireTaskCode, "aquireTask", 8192, NULL, 1, &aquireTask, 1);         //start collecting data
  client.flush();

  //create data package
  byte buffer[DATASET_SIZE_BYTES * BUFFERSIZE];
  TcpPackage dataPkg;
  dataPkg.package_type = DATA_PACKAGE;      // mark as DATA_PACKAGE
  dataPkg.package_size = sizeof(buffer);    // size of the binary blob
  dataPkg.package = buffer;                 // pointer to  buffer
  // Send package header first: 1 byte type + 4 bytes size
  uint8_t header[5];
  header[0] = dataPkg.package_type;
  header[1] = (dataPkg.package_size >> 24) & 0xFF;
  header[2] = (dataPkg.package_size >> 16) & 0xFF;
  header[3] = (dataPkg.package_size >> 8) & 0xFF;
  header[4] = (dataPkg.package_size >> 0) & 0xFF;
  uint32_t total = 5 + dataPkg.package_size;
  uint8_t* out = (uint8_t*)malloc(total);

  //Serial.printf("There are %ld samples to be collected\n", measurecnt.cntnmbr);

  while(1){

    for(int i = 0; i < measurecnt.cntnmbr;){                                                     //this loop ends the measurement after the set amount of samples
      while (client.available() > 0) {
          getNextTcpPackage(client, settingsPkg);

          switch(settingsPkg.package_type) {
              case STOP_PACKAGE:
                  Serial.println("STOP requested by host.");
                  vTaskDelete(aquireTask);
                  client.stop();
                  WiFi.disconnect();
                  free(out);
                  delay(100);
                  ESP.restart();
                  break;

              case TIMESTAMP_PACKAGE:
                  //Serial.println("Received TIMESTAMP_PACKAGE request.");
                  respondWithTimestampPackage(client, settingsPkg);
                  break;

              case PING_PACKAGE:
                  //Serial.println("Received PING_PACKAGE.");
                  // Optionally respond to ping here
                  break;

              case SETTINGS_PACKAGE:
                  Serial.println("Received SETTINGS_PACKAGE.");
                  // Handle settings update if needed
                  break;

              case DATA_PACKAGE:
                  Serial.println("Received unexpected DATA_PACKAGE.");
                  break;

              default:
                  Serial.printf("Received unknown package type: %d\n", settingsPkg.package_type);
                  break;
          }
      }

                                                                 
      
      if(uxQueueSpacesAvailable(datatransferQueue) > DATAQUEUE_SIZE - DATASET_SIZE_BYTES * BUFFERSIZE)vTaskDelay(1);
      else{
      for(int j = 0; j < BUFFERSIZE; j++){                                                                //this loop wil wait for a package of 64 samples to be available and package them into the buffer
        struct chanData_float *chanData_recv_ptr;
        if(xQueueReceive(datatransferQueue, &(chanData_recv_ptr), portMAX_DELAY)){
          convert_data(chanData_recv_ptr, amparr);
          for(int i = 0; i < 9; i++){
            memcpy(buffer + (4 * i) + (DATASET_SIZE_BYTES*j), &chanData_recv_ptr->chan[i], 4);   
          }
          free(chanData_recv_ptr);
        }
      }
      
      memcpy(out, header, 5);
      memcpy(out + 5, dataPkg.package, dataPkg.package_size);

      client.write(out, total);   // single TCP write()
      i += BUFFERSIZE;
      }
    }
    free(out);
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



  datatransferQueue = xQueueCreate(DATAQUEUE_SIZE, sizeof(struct chanData_float *));                //setting up queue to send data from aquisirion ISR to the task converting it and sending it out via WiFi 
  if(datatransferQueue == NULL) Serial.println("Queue not initialized");
  xTaskCreatePinnedToCore(sendTaskCode, "sendTask", 8192, NULL, 1, &sendTask, 0);        //start the task that sends out data on core 0, this task will start the other task/ ISR
}




/////////////////////////////////////////////////////////////////////////////////////////////



// loop is not used in this programm
void loop() {
  vTaskDelay(portMAX_DELAY);
}




