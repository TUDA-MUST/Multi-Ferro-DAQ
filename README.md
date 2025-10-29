# Multi-Ferro-DAQ
Measurement Setup to analyze upt to eight sources of charge (e.g. ferroelectric sensors) simultaneously. Those can be connected via two RJ45 connectors, four sorces per connector.
The PCB aims to be used mobile, strapped to the test person, therefore it batterypowered and transmits its data in mV per WiFi with up to 2000 samples per second.
The ESP32 microcontrolers on the PCB should be flashed with the Arduino script in /ADC/ardu_adc_dual_core_wifi_tcp/ardu_adc_dual_core_wifi_tcp.ino.


# Setup:

At startup the ESP32 cycles through a setup phase during which the status LED turns YELLOW. When the status LED turns MAGENTA, the EPS32 is ready to start a measurement. A white Flash under the shielding of the charge amplifiers and the ADC signals that the ADC was setup and is communicating. Connect to the WiFi Hotspot the ESP32 creates with the 

SSID "ESP32_Hotspot" and 

password "123456789".

Afterwards you can communicate with it on TCP port 8080.  

The ESP32 expects to be handed some initialization values in a hardcoded format and order. Garbage bytes can be sent and the ESP32 will initialize with default values:

1. 1x int64:  the maximum number of samples to collect in this measurement (The PCB will reset itself afterwards).
2. 1x uint32: the sample rate of the ADC (1000, 2000, 4000, 8000, 16000, 32000, 64000). Sample rates above 2000 will result in sample loss and are not recommended.
3. 8x uint16: the settings-registers for CHAN1-CHAN8 of the ADC. As only the lower byte is utilized, set the upper byte to zero.
4. 8x uint8:  the preamp values for the individual channels from CHAN1 to CHAN8. This will overwrite the preamp values previously set in the settins-registers. The preamp value will be factored out by the microcontroller before sending the data.

For further deatails and a working example look inside the MATLAB script /ADC/Matlab/ADC_WiFi_readout_TCP.m.

Afterwards the status LED should turn GREEN and will remain GREEN until the measurement times out or is stopped by the user.

The PCB can be powered via the USB-C or the battery port. The battery can be charged by the PCB. If the RED battery indicator LED is glowing steadily, the battery is being charged, if the indicator LED is blinking fast, while the PCB is powered on, no battery was detected.

# Usage:

After setup the microcontroller will send the data in TCP packages to a client until the timeout is reached or the measurement is stopped by sending any byte to the microcontroller via TCP. The incoming bytesream consists of segments of nine floats that represent a sample. The first eight floats are the values of CHAN1 to CHAN8 of the ADC in mv and are in a range from -2500mV to +2500mV. The ninth channel is the timestamp of the sample in µs in regards to when the ESP32 was last reset. If a channel reads -9999mV or +9999mV the negative or positive fault flags of the ADC were activated and the measured value exceeds -2375mV or +2375mV, or 95% of the input range.

After a measurement has ended, the PCB will automatically be reinitialized and is ready again, as soon as the status LED turns MAGENTA. Alternatively the PCB can be reinitialized by pressing the RESET button.

There is also an IMU placed on the PCB which is tested, but not used in the current version of the code running on the ESP32.
