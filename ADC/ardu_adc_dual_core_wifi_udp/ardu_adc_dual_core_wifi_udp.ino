#include <FastLED.h>
#include <SPI.h>
#include "../lib/ADS131E08esp32.cpp"
#include <WiFi.h>
#include <WiFiUdp.h>

struct chanData_float{
  byte chan[8][3];
};


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


TaskHandle_t aquireTask;
TaskHandle_t sendTask;
QueueHandle_t datatransferQueue;
void aquireTaskCode(void* params);
void sendTaskCode(void* params);

int ADC_stat[3];
float ADC_chan_voltage[8];
_adcConfE* adcConfRead;







struct chanData_float *chanData_send_ptr;

void  IRAM_ATTR DRDY_read_int_handle(){
    
    ADS131E08_send_rdata_cmd(ADS131E08_ADC20);
    //ADS131E08_receive_data(ADS131E08_ADC20); -> needs to be finished in library
    //ADS131E08_parse_adc_data(ADS131E08_ADC20);
    
    
    chanData_send_ptr = (struct chanData_float*) malloc(sizeof(struct chanData_float));
    if (chanData_send_ptr != NULL) {
    for (int i = 0; i < NUMB_ADC_CH; i++) {
       chanData_send_ptr->chan[i][0] = adcConfRead->rxBuf[3*i+4];
       chanData_send_ptr->chan[i][1] = adcConfRead->rxBuf[3*i+5];
       chanData_send_ptr->chan[i][2] = adcConfRead->rxBuf[3*i+6];
    }
    xQueueSendFromISR(datatransferQueue, (void *) &chanData_send_ptr, NULL);
    }
    

}







void setup() {
  Serial.begin(921600);
  //while(!Serial) {}               // this line is only to be used if Serial connection should be enforced
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS); //initialize PWR_ON LED
  FastLED.setBrightness(50);
  leds[0] = CRGB::Green; FastLED.show();


  hspi = new SPIClass(HSPI);                        //SPI initialization moved into this file
  vspi = new SPIClass(FSPI);                        //using FSPI as the IDE doesn't recognize VSPI 
  hspi->begin(ADC_SCLK, ADC_MISO, ADC_MOSI, ADC_CS);
  vspi->begin(VSPI_SCLK, VSPI_MISO, VSPI_MOSI, VSPI_SS);


  pinMode(ADC_RESET, OUTPUT);
  pinMode(ADC_START, OUTPUT);
  pinMode(ADC_DRDY, INPUT_PULLUP);
  pinMode(ADC_CS, OUTPUT);

  attachInterrupt(digitalPinToInterrupt(ADC_DRDY), ADS131E08_drdy_int_handl, LOW);

  //TODO: initialize ADS131E08
  // ADC, VCAP1 > 1.1v takes about 1.3 seconds, 2 seconds delay to be stable status
  delay(2000);
  //Serial.println(getCpuFrequencyMhz());
  ADS131E08_init(ADS131E08_ADC20, hspi, ADC_RESET, ADC_CS, ADC_DRDY, ADC_START);
  Serial.println("passed init...");

  // Initialize signal(CS, START, nRESET)
  ADS131E08_initialize_signal();
  delay(500);
  Serial.println("passed initialize Singal...");

   // Start up
  ADS131E08_startup(ADS131E08_ADC20);
  Serial.println("passed startup...");
  adcConfRead = getadcConfE0();

  // Set start signal in initial flow at power up
  ADS131E08_control_start_signal(SET_SIGNAL);
  Serial.println("passed control start signal...");

  detachInterrupt(digitalPinToInterrupt(ADC_DRDY));

  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_GPIO_ADDRESS, 0b10000111, 1); //turns on white LED for testing (RREG/ WREG) -> successful
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_RREG, E08_GPIO_ADDRESS, 0, 1);

  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_RREG, E08_CONFIG1_ADDRESS, 0, 1);//configure sample rate (example how to configure with masks)
  uint8_t conf1 = adcConfRead->rxBuf[0] & (~E08_CONFIG1_DR_MASK);
  conf1 |= E08_CONFIG1_DR_MASK & E08_DR_4KSPS;
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CONFIG1_ADDRESS, conf1, 1);
  
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_SDATAC, 0, 0, 1); //stop continuous data readout
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CONFIG2_ADDRESS, 0xE3, 1);//configure test signal
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH1SET_ADDRESS, 0x10, 1);//set CH1 to extern measurement
  //ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH1SET_ADDRESS, 0x90, 1);//set CH1 to pwr_dwn
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH2SET_ADDRESS, 0x15, 1);//set CH2 to test signal
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH3SET_ADDRESS, 0x15, 1);//set CH3 to test signal
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH4SET_ADDRESS, 0x15, 1);//set CH4 to test signal
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH5SET_ADDRESS, 0x15, 1);//set CH5 to test signal
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH6SET_ADDRESS, 0x15, 1);//set CH6 to test signal
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH7SET_ADDRESS, 0x15, 1);//set CH7 to test signal
  ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_CH8SET_ADDRESS, 0x15, 1);//set CH8 to test signal
  digitalWrite(ADC_START, HIGH); //start conversion
  //ADS131E08_send_rdatac_command();


  datatransferQueue = xQueueCreate(512, sizeof(struct chanData_float *));
  if(datatransferQueue == NULL) Serial.println("Queue not initialized");
  xTaskCreatePinnedToCore(sendTaskCode, "sendTask", 8192, NULL, 1, &sendTask, 0);
  }





void aquireTaskCode(void* params){
  //ADS131E08_send_command(adcConfE0, ADS131E08_CMD_WREG, E08_GPIO_ADDRESS, 0b11000011, 1);//turn on red + white LED to signal start of task
  attachInterrupt(digitalPinToInterrupt(ADC_DRDY), DRDY_read_int_handle, FALLING);
  while(1){
    vTaskDelay(1);
    /*while(digitalRead(ADC_DRDY)){
    //  vTaskDelay(0);
    }
    ADS131E08_send_rdata_cmd(ADS131E08_ADC20);
    //ADS131E08_receive_data(ADS131E08_ADC20); -> needs to be finished in library
    ADS131E08_parse_adc_data(ADS131E08_ADC20);
    //ADC_stat[0] = adcConfRead->sr.mp[E08_FAULT_STATP_ADDRESS];    commented out until a need for status information arises
    //ADC_stat[1] = adcConfRead->sr.mp[E08_FAULT_STATN_ADDRESS];
    //ADC_stat[2] = adcConfRead->sr.mp[E08_GPIO_ADDRESS];

    chanData_send_ptr = (struct chanData_float*) malloc(sizeof(struct chanData_float));
    if (chanData_send_ptr != NULL) {
    for (int i = 0; i < NUMB_ADC_CH; i++) {
       chanData_send_ptr->chan[i] = adcConfRead->chData[i].v;
    }
    xQueueSend(datatransferQueue, (void *) &chanData_send_ptr, portMAX_DELAY);
    }*/
  }
}

//TODO: chanData as array of pointers instead of dynamic
//TODO: String to char for performance


void sendTaskCode(void* params){

  
  // AP credentials
  const char *ssid = "ESP32_Hotspot";
  const char *password = "123456789";  // Minimum 8 characters


  // UDP settings
  WiFiUDP udp;
  const int udpPort = 8080;  // Listen on port 8080
  char incomingPacket[255];  // Buffer to store incoming data
  
    // Start the ESP32 as an Access Point (Hotspot)
  Serial.println("Setting up Access Point...");
  WiFi.softAP(ssid, password);
  
  // Print the ESP32 AP IP address
  Serial.println("Access Point Started!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());  // Print the AP's IP address (usually 192.168.4.1)

  // Start the UDP communication
  udp.begin(udpPort);
  Serial.println("UDP listening on port 8080 - start MATLAB script");
  
  byte buffer[2048]; // 8 floats * 4 bytes each => 32 bytes * 64 datasets = 
  while(1){
        // Check if there is any incoming UDP packet
  int packetSize = udp.parsePacket();
  vTaskDelay(1);
  if (packetSize) {
    // Read the incoming packet into the buffer
    int len = udp.read(incomingPacket, 255);
    if (len > 0) {
      incomingPacket[len] = 0;  // Null-terminate the string
    }
    
    // Print the received data to the Serial Monitor
    //Serial.print("Received packet: ");
    Serial.println(incomingPacket);
    int remoteIP = 0;
    remoteIP = udp.remoteIP();
    if (remoteIP != 0){
      // Convert the floats to byte array using typecast
      xTaskCreatePinnedToCore(aquireTaskCode, "aquireTask", 8192, NULL, 1, &aquireTask, 1);
      while(1){
        if(uxQueueSpacesAvailable(datatransferQueue) > 448)vTaskDelay(1);
        else{
        for(int j = 0; j < 64; j++){
        struct chanData_float *chanData_recv_ptr;
        if(xQueueReceive(datatransferQueue, &(chanData_recv_ptr), portMAX_DELAY)){
          for(int i = 0; i < 8; i++){
            memcpy(buffer + (4 * i) + (24*j), &chanData_recv_ptr->chan[i], 3);   
          }
          free(chanData_recv_ptr);
        }
        }
          // Send the buffer over UDP
          udp.beginPacket(udp.remoteIP(), udp.remotePort());
          udp.write(buffer, sizeof(buffer));  
          udp.endPacket();
        }
      }
    }
  }
  }
}





void loop() {
  //vTaskDelay(portMAX_DELAY);
}



