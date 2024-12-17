
// DEPRECATED!!!!


/* The ESP32 has four SPi buses, however as of right now only two of
 * them are available to use, HSPI and VSPI. Simply using the SPI API
 * as illustrated in Arduino examples will use VSPI, leaving HSPI unused.
 *
 * However if we simply initialize two instance of the SPI class for both
 * of these buses both can be used. However when just using these the Arduino
 * way only will actually be outputting at a time.
 *
 * Logic analyzer capture is in the same folder as this example as
 * "multiple_bus_output.png"
 *
 * created 30/04/2018 by Alistair Symonds
 * 
 * altered 06/12/2024 by Thomas Schreck as per LGPL-2.1 licencense 
 * 
 */
#include <SPI.h>

// Define ALTERNATE_PINS to use non-standard GPIO pins for SPI bus

#ifdef ALTERNATE_PINS
#define VSPI_MISO 2
#define VSPI_MOSI 4
#define VSPI_SCLK 0
#define VSPI_SS   33

#define HSPI_MISO 26
#define HSPI_MOSI 27
#define HSPI_SCLK 25
#define HSPI_SS   32
#else
#define VSPI_MISO 37
#define VSPI_MOSI 35
#define VSPI_SCLK 36
#define VSPI_SS   39

#define HSPI_MISO 13
#define HSPI_MOSI 11
#define HSPI_SCLK 12
#define HSPI_SS   10
#endif
/*
#if !defined(CONFIG_IDF_TARGET_ESP32)
#define VSPI FSPI
#endif
*/
static const int spiClk = 1000000;  // 1 MHz


void mSPIsetup(SPIClass* vspi, SPIClass* hspi) {
  //initialize two instances of the SPIClass attached to VSPI and HSPI respectively
  vspi = new SPIClass(VSPI);
  hspi = new SPIClass(HSPI);
  //clock miso mosi ss

#ifndef ALTERNATE_PINS
  //initialize vspi with default pins
  vspi->begin(VSPI_SCLK, VSPI_MISO, VSPI_MOSI, VSPI_SS);
#else
  //alternatively route through GPIO pins of your choice
  vspi->begin(VSPI_SCLK, VSPI_MISO, VSPI_MOSI, VSPI_SS);  //SCLK, MISO, MOSI, SS
#endif

#ifndef ALTERNATE_PINS
  //initialize hspi with default pins
  hspi->begin(HSPI_SCLK, HSPI_MISO, HSPI_MOSI, HSPI_SS);
#else
  //alternatively route through GPIO pins
  hspi->begin(HSPI_SCLK, HSPI_MISO, HSPI_MOSI, HSPI_SS);  //SCLK, MISO, MOSI, SS
#endif

  //set up slave select pins as outputs as the Arduino API
  //doesn't handle automatically pulling SS low
  pinMode(vspi->pinSS, OUTPUT);  //VSPI SS
  pinMode(hspi->pinSS, OUTPUT);  //HSPI SS
}


/* the loop function runs over and over again until power down or reset
void loop() {
  //use the SPI buses
  spiCommand(vspi, 0b01010101);  // junk data to illustrate usage
  spiCommand(hspi, 0b11001100);
  delay(100);
}
*/

void spiSendCommand(SPIClass *spi, byte data) {
  //use it as you would the regular arduino SPI API
  spi->beginTransaction(SPISettings(spiClk, MSBFIRST, SPI_MODE1));
  digitalWrite(spi->pinSS(), LOW);  //pull SS slow to prep other end for transfer
  spi->transfer(data);
  digitalWrite(spi->pinSS(), HIGH);  //pull ss high to signify end of data transfer
  spi->endTransaction();
}