//wouldn't compile with the .h file : DAQ-main\ADC\ardu_adc_test/ardu_adc_test.ino:31: undefined reference to `mSPIsetup(SPIClass*, SPIClass*)

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

#if !defined(CONFIG_IDF_TARGET_ESP32)
#define VSPI FSPI
#endif

static const int spiClk = 1000000;  // 1 MHz

extern void mSPIsetup(SPIClass* vspi, SPIClass* hspi);
extern void spiSendCommand(SPIClass *spi, byte data);