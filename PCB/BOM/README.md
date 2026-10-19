# Bill of Materials – Multi-Ferro-DAQ v1.3

41 line items, 117 placed parts. Machine-readable version: [`BOM_Multi-Ferro-DAQ_v1.3.csv`](BOM_Multi-Ferro-DAQ_v1.3.csv). JLCPCB assembly files (BOM/CPL with LCSC numbers only) remain in [`../jlcpcb/production_files`](../jlcpcb/production_files).

Manufacturer part numbers were resolved from the LCSC numbers in the KiCad schematic. Any equivalent part with the same specs can be substituted, **except the items marked critical**.

## Critical parts

- **RF1, RF2, RF3, RF4, RF5, RF6, RF7, RF8** (HVCB0805KDL1G00): CRITICAL – charge-amp feedback resistor R_F. Sets τ = R_F·C_F = 0.68 s and the low-frequency corner; ±10 % tolerance applies directly to τ. Hand-solder footprint.
- **CF1, CF2, CF3, CF4, CF5, CF6, CF7, CF8** (0805CG681J500NT): CRITICAL – charge-amp feedback capacitor C_F; sets gain ≈ 1/C_F. Must be C0G/NP0; do not substitute X7R. Hand-solder footprint.

## Populated parts

| # | Qty | Designators | Value / function | Manufacturer | MPN | Package | Key specs | LCSC | Datasheet |
|---|---|---|---|---|---|---|---|---|---|
| 1 | 1 | IC1 | ADS131E08IPAGR | Texas Instruments | `ADS131E08IPAGR` | TQFP-64 | 8-ch, 24-bit simultaneous-sampling ΔΣ ADC, up to 64 kSPS, SPI | [C190276](https://www.lcsc.com/product-detail/C190276.html) | [PDF](https://www.lcsc.com/datasheet/C190276.pdf) |
| 2 | 1 | IC2 | TP4056 | TOP POWER ASIC | `TP4056X-42-ESOP8` | ESOP-8 | 1-cell Li-ion linear charger, 4.2 V, ≤1 A | [C2763448](https://www.lcsc.com/product-detail/C2763448.html) | [PDF](https://www.lcsc.com/datasheet/C2763448.pdf) |
| 3 | 1 | IC3 | TLV9051IDBVR | Texas Instruments | `TLV9051IDBVR` | SOT-23-5 | RRIO op-amp, 5 MHz, 1.8–6 V | [C1849429](https://www.lcsc.com/product-detail/C1849429.html) | [PDF](https://www.lcsc.com/datasheet/C1849429.pdf) |
| 4 | 1 | IC5 | TPS7A9101DSKR | Texas Instruments | `TPS7A9101DSKR` | WSON-10 2.5×2.5 | 1 A adjustable low-noise LDO, 4.7 µV_RMS | [C2878140](https://www.lcsc.com/product-detail/C2878140.html) | [PDF](https://www.lcsc.com/datasheet/C2878140.pdf) |
| 5 | 1 | IC7 | LM2775QDSGRQ1 | Texas Instruments | `LM2775QDSGRQ1` | WSON-8 2×2 | Switched-cap boost, 5 V out, 200 mA | [C2071153](https://www.lcsc.com/product-detail/C2071153.html) | [PDF](https://www.lcsc.com/datasheet/C2071153.pdf) |
| 6 | 2 | U1, U4 | AD8608ARUZ-REEL | Analog Devices | `AD8608ARUZ-REEL` | TSSOP-14 | Quad CMOS RRIO op-amp, 2.7–5.5 V, 10 MHz GBW, 1 pA I_b, 75 µV V_os | [C578777](https://www.lcsc.com/product-detail/C578777.html) | [PDF](https://www.lcsc.com/datasheet/C578777.pdf) |
| 7 | 1 | U3 | ICM-42670-P | TDK InvenSense | `ICM-42670-P` | LGA-14 2.5×3 mm | 6-axis IMU, I²C/SPI/I3C | [C3288646](https://www.lcsc.com/product-detail/C3288646.html) | [PDF](https://www.lcsc.com/datasheet/C3288646.pdf) |
| 8 | 1 | U2 | ESP32-S3-MINI-1-N8 | Espressif | `ESP32-S3-MINI-1-N8` | SMD module | ESP32-S3, 8 MB flash, Wi-Fi/BLE 5, PCB antenna | [C2913206](https://www.lcsc.com/product-detail/C2913206.html) | [PDF](https://www.lcsc.com/datasheet/C2913206.pdf) |
| 9 | 1 | Q1 | DMG2305 | TECH PUBLIC | `DMG2305UX` | SOT-23 | P-MOSFET, −20 V, 4.1 A, 52 mΩ @ 4.5 V | [C2940629](https://www.lcsc.com/product-detail/C2940629.html) | [PDF](https://www.lcsc.com/datasheet/C2940629.pdf) |
| 10 | 1 | D1 | D_Schottky | R+O | `BAT60B` | SOD-323 | Schottky, 10 V, 3 A, 0.6 V @ 1 A | [C7502695](https://www.lcsc.com/product-detail/C7502695.html) | [PDF](https://www.lcsc.com/datasheet/C7502695.pdf) |
| 11 | 1 | U5 | WE-TVS-82400102 | Würth Elektronik | `82400102` | SOT-23-6 | 2-ch low-capacitance TVS array (WE-TVS), USB | [C1975330](https://www.lcsc.com/product-detail/C1975330.html) | [link](https://uk.farnell.com/wurth-elektronik/82400102/diode-tvs-2-ch-esd-usb1-2-s0t23/dp/1825875) |
| 12 | 2 | D2, D3 | LED_R | Hubei KENTO | `KT-0603R` | 0603 | Red, 615–630 nm | [C2286](https://www.lcsc.com/product-detail/C2286.html) | [PDF](https://www.lcsc.com/datasheet/C2286.pdf) |
| 13 | 1 | D4 | LED_W | Hubei KENTO | `KT-0603W` | 0603 | White | [C2290](https://www.lcsc.com/product-detail/C2290.html) | [PDF](https://www.lcsc.com/datasheet/C2290.pdf) |
| 14 | 2 | D5, D6 | SK6812MINI-HS | OPSCO | `SK6812MINI-HS` | 3.5×3.5 mm | Addressable RGB LED, 5 V | [C2922787](https://www.lcsc.com/product-detail/C2922787.html) | [PDF](https://www.lcsc.com/datasheet/C2922787.pdf) |
| 15 | 7 | R1, R12, R13, R15, R16, R17, R2 | 10k | UNI-ROYAL | `0603WAF1002T5E` | 0603 | 10 kΩ ±1 %, 100 mW, thick film | [C25804](https://www.lcsc.com/product-detail/C25804.html) | [PDF](https://www.lcsc.com/datasheet/C25804.pdf) |
| 16 | 2 | R19, R20 | 5.1k | UNI-ROYAL | `0603WAF5101T5E` | 0603 | 5.1 kΩ ±1 %, 100 mW, thick film | [C23186](https://www.lcsc.com/product-detail/C23186.html) | [PDF](https://www.lcsc.com/datasheet/C23186.pdf) |
| 17 | 1 | R27 | 27R | UNI-ROYAL | `0603WAF270JT5E` | 0603 | 27 Ω ±1 %, 100 mW, thick film | [C25190](https://www.lcsc.com/product-detail/C25190.html) | [PDF](https://www.lcsc.com/datasheet/C25190.pdf) |
| 18 | 4 | R28, R29, R30, Rf_Op1 | 0R | UNI-ROYAL | `0603WAF0000T5E` | 0603 | 0 Ω jumper, 100 mW | [C21189](https://www.lcsc.com/product-detail/C21189.html) | [PDF](https://www.lcsc.com/datasheet/C21189.pdf) |
| 19 | 3 | R3, R4, R5 | 100R | UNI-ROYAL | `0603WAF1000T5E` | 0603 | 100 Ω ±1 %, 100 mW, thick film | [C22775](https://www.lcsc.com/product-detail/C22775.html) | [PDF](https://www.lcsc.com/datasheet/C22775.pdf) |
| 20 | 1 | R32 | 1.15k | YAGEO | `RT0603BRE071K15L` | 0603 | 1.15 kΩ ±0.1 %, 100 mW, ±50 ppm/K, thin film | [C861724](https://www.lcsc.com/product-detail/C861724.html) | [PDF](https://www.lcsc.com/datasheet/C861724.pdf) |
| 21 | 2 | R33, R7 | 3.57k | YAGEO | `RT0603BRE073K57L` | 0603 | 3.57 kΩ ±0.1 %, 100 mW, ±50 ppm/K, thin film | [C326745](https://www.lcsc.com/product-detail/C326745.html) | [PDF](https://www.lcsc.com/datasheet/C326745.pdf) |
| 22 | 1 | R6 | 1k | UNI-ROYAL | `0603WAF1001T5E` | 0603 | 1 kΩ ±1 %, 100 mW, thick film | [C21190](https://www.lcsc.com/product-detail/C21190.html) | [PDF](https://www.lcsc.com/datasheet/C21190.pdf) |
| 23 | 8 | RF1, RF2, RF3, RF4, RF5, RF6, RF7, RF8 | 1G | Stackpole (SEI) | `HVCB0805KDL1G00` | 0805 | 1 GΩ ±10 %, 200 mW, 600 V, ±200 ppm/K, thick film | [C2484710](https://www.lcsc.com/product-detail/C2484710.html) | [PDF](https://www.lcsc.com/datasheet/C2484710.pdf) |
| 24 | 16 | C1, C8, C9, CS11, CS16, CS18, CS2, CS31, CS34, CS39, CS40, CS41, CS42, CS50, CS52, CS9 | 10u | Samsung Electro-Mechanics | `CL10A106KP8NNNC` | 0603 | 10 µF ±10 %, 10 V, X5R | [C19702](https://www.lcsc.com/product-detail/C19702.html) | [PDF](https://www.lcsc.com/datasheet/C19702.pdf) |
| 25 | 11 | CCH1, CS10, CS12, CS13, CS14, CS4, CS47, CS48, CS5, CS7, CS8 | 1u | Samsung Electro-Mechanics | `CL10A105KB8NNNC` | 0603 | 1 µF ±10 %, 50 V, X5R | [C15849](https://www.lcsc.com/product-detail/C15849.html) | [PDF](https://www.lcsc.com/datasheet/C15849.pdf) |
| 26 | 8 | CF1, CF2, CF3, CF4, CF5, CF6, CF7, CF8 | 680p | FH (Fenghua) | `0805CG681J500NT` | 0805 | 680 pF ±5 %, 50 V, C0G/NP0 | [C1835](https://www.lcsc.com/product-detail/C1835.html) | [PDF](https://www.lcsc.com/datasheet/C1835.pdf) |
| 27 | 14 | CS1, CS15, CS17, CS19, CS29, CS3, CS32, CS37, CS38, CS43, CS44, CS46, CS51, CS53 | 100n | YAGEO | `CC0603KRX7R9BB104` | 0603 | 100 nF ±10 %, 50 V, X7R | [C14663](https://www.lcsc.com/product-detail/C14663.html) | [PDF](https://www.lcsc.com/datasheet/C14663.pdf) |
| 28 | 1 | CS21 | 680n | CCTC | `TCC0603X7R684K500CT` | 0603 | 680 nF ±10 %, 50 V, X7R | [C5360852](https://www.lcsc.com/product-detail/C5360852.html) | [PDF](https://www.lcsc.com/datasheet/C5360852.pdf) |
| 29 | 3 | CS28, CS30, CS6 | 22u | Samsung Electro-Mechanics | `CL10A226MQ8NRNC` | 0603 | 22 µF ±20 %, 6.3 V, X5R | [C59461](https://www.lcsc.com/product-detail/C59461.html) | [PDF](https://www.lcsc.com/datasheet/C59461.pdf) |
| 30 | 2 | CS33, CS49 | 10n | FH (Fenghua) | `0603B103K500NT` | 0603 | 10 nF ±10 %, 50 V, X7R | [C57112](https://www.lcsc.com/product-detail/C57112.html) | [PDF](https://www.lcsc.com/datasheet/C57112.pdf) |
| 31 | 2 | FB1, FB2 | FerriteBead | Würth Elektronik | `742792641` | 0603 | Ferrite bead, 300 Ω @ 100 MHz, 2 A, 150 mΩ | [C2649308](https://www.lcsc.com/product-detail/C2649308.html) | [link](https://fat.lcsc.com/product-detail/Ferrite-Beads_Wurth-Elektronik-742792641_C2649308.html) |
| 32 | 1 | L1 | Choke_Wurth_WE-CNSW_744232090 | Würth Elektronik | `744232090` | 1206 (WE-CNSW) | Common-mode choke, 90 Ω @ 100 MHz, 370 mA, USB 2.0 | [C2649327](https://www.lcsc.com/product-detail/C2649327.html) | [link](https://www.digikey.co.uk/en/products/detail/w%C3%BCrth-elektronik/744232090/1638873) |
| 33 | 2 | GPIO1, GPIO2 | Conn_01x02_Pin | XFCN | `PZ254V-11-02P` | THT, 2.54 mm | 1×2 pin header | [C492401](https://www.lcsc.com/product-detail/C492401.html) | [PDF](https://www.lcsc.com/datasheet/C492401.pdf) |
| 34 | 2 | J1, J5 | 8P8C_Shielded | CKMTW | `R-RJ45R08P-B000` | THT, right angle | RJ45 8P8C, shielded, no LEDs, no magnetics | [C386756](https://www.lcsc.com/product-detail/C386756.html) | [PDF](https://www.lcsc.com/datasheet/C386756.pdf) |
| 35 | 2 | J2, J3 | Conn_01x04_Socket | JST | `BM04B-SRSS-TBT(LF)(SN)` | SMD, 1.0 mm | SH 1×4 header, vertical | [C495539](https://www.lcsc.com/product-detail/C495539.html) | [PDF](https://www.lcsc.com/datasheet/C495539.pdf) |
| 36 | 1 | J4 | Conn_01x02_Pin | JST | `B2B-PH-K-E(LF)(SN)` | THT, 2.0 mm | PH 1×2 header | [C594142](https://www.lcsc.com/product-detail/C594142.html) | [PDF](https://www.lcsc.com/datasheet/C594142.pdf) |
| 37 | 1 | J6 | TYPE-C-31-M-12 | Korean Hroparts (HRO) | `TYPE-C-31-M-12` | SMD | USB Type-C receptacle, 16 pin | [C165948](https://www.lcsc.com/product-detail/C165948.html) | [PDF](https://www.lcsc.com/datasheet/C165948.pdf) |
| 38 | 1 | S1 | SK-12D02-VG3 | Korean Hroparts (HRO) | `SK-12D02-VG3` | THT, right angle | SPDT slide switch | [C136723](https://www.lcsc.com/product-detail/C136723.html) | [PDF](https://www.lcsc.com/datasheet/C136723.pdf) |
| 39 | 2 | S2, S3 | SKRPABE010 | ALPS ALPINE | `SKRPABE010` | SMD 4.2×3.2 mm | Tactile switch, SPST-NO | [C115360](https://www.lcsc.com/product-detail/C115360.html) | [PDF](https://www.lcsc.com/datasheet/C115360.pdf) |
| 40 | 1 | H2 | MountingHole_Pad | YIYUAN | `SMTSOM330BTR` | SMT standoff | M3 threaded SMT standoff, tin-plated copper | [C5221843](https://www.lcsc.com/product-detail/C5221843.html) | [PDF](https://www.lcsc.com/datasheet/C5221843.pdf) |
| 41 | 1 | J7 | RFShield_TwoPieces | Laird | `BMI-S-204-F` | SMD, 32 × 32 mm | Two-piece board-level RF shield – frame (soldered) | [C5241024](https://www.lcsc.com/product-detail/C5241024.html) | [link](https://azcus.digikey.com/en/products/detail/laird-technologies-emi/BMI-S-204-F/2175891) |

## Hand-fitted after assembly

| Qty | For | Manufacturer | MPN | Notes |
|---|---|---|---|---|
| 1 | J7 | Laird | `BMI-S-204-C` | Not part of the JLCPCB assembly – order separately and press onto the J7 frame after assembly. |

## Not populated (DNP) – optional external ADC clock and debug header

| Designator | Value | Footprint | Purpose |
|---|---|---|---|
| Y1 | Abracon ASCO-series oscillator (frequency not specified in schematic) | 3225, 4-pin | Optional external ADC clock |
| CS20 | 1 µF, 0603 | C_0603 | Decoupling for Y1 |
| CS22 | 100 nF, 0603 | C_0603 | Decoupling for Y1 |
| CLKSEL1, CLK_EN1 | 3-pad solder jumper, default 1–2 bridged | SolderJumper-3 | ADC clock selection – internal oscillator by default |
| UART0 | 1×2 pin header, 1.27 mm | PinHeader_1x02_P1.27mm | UART debug |

## Board features without parts

Solder jumpers (factory state from the footprint): JP1, JP4 (3-pad, 1–2 bridged); JP_SH/GND1, JP_SH/USB1 (bridged); JP2, JP3, JP_ADC_RefP1 (open). Test points: ADC_TESTP1, ADC_TESTN1, ADC_Daisy1, CS_External1, TP_3.3V2, TP_5V1, TP_ADC_*PWDN1, TP_ADC_*RST1, TP_CS1, TP_DRDY1, TP_GND1, TP_GND2, TP_MISO1, TP_MOSI1, TP_SCLK1, TP_OP_N1, TP_OP_P1, TP_OP_OUT1, TP_REFp1, TP_SHIELD1, TP_VBIAS1.

## Off-board items (not in this BOM)

- 1S Li-ion/LiPo battery with JST-PH 2-pin plug – must have built-in protection (the TP4056 charger has none).
- RJ45 (T-568B) cables or adapters to the sensors – pinout is printed on the silkscreen.
- Enclosure / strap for wearable use.
