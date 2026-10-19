# Third-party notices

## ADS131E08 driver – Minchul Jun

The ADS131E08 driver in this repository is based on Minchul Jun's
**ads131e08** library, a C library for the TI ADS131E08 for STM32 (STM32CubeMX / HAL):

- Source: <https://github.com/mcjun37/ads131e08>
- Author: Minchul Jun (mcjun37@naver.com)

Files in this repository derived from it:

| File | Notes |
|---|---|
| `Software/ADC_readout/lib/ADS131E08.c`, `ADS131E08.h` | Original STM32 version, kept as reference |
| `Software/ADC_readout/lib/ADS131E08esp32.cpp`, `ADS131E08esp32.h` | Port to ESP32 / Arduino by Thomas Schreck |
| `Software/MMM_Migration/lib/ADS131E08*` | Copies of the files above |

These files remain under the original license from their file headers, reproduced below. That license
applies to these files only. The rest of this repository is covered by the licenses in `LICENSE`.

```
Copyright 2021 Minchul Jun (mcjun37@naver.com).  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY MINCHUL JUN ``AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL MINCHUL JUN OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are
those of the authors and should not be interpreted as representing official
policies, either expressed or implied, of Minchul Jun.
```

Because this notice must also come with binary redistributions (condition 2), keep this file in
anything that ships compiled firmware, such as release `.bin` files.

## Arduino libraries (not included, installed separately)

| Library | Used for | License |
|---|---|---|
| Arduino-ESP32 core (Espressif) | WiFi, SPI, Preferences | LGPL-2.1 |
| FastLED | SK6812 status LEDs | MIT |
| ArduinoJson (Benoît Blanchon) | MMM client settings | MIT |

## Component libraries

Some symbols, footprints and 3D models in `PCB/components/` were downloaded from SnapEDA or from
component manufacturers. They are subject to their providers' terms and are included only so the
KiCad project opens without missing libraries.
