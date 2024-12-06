/*
 * This is an alteration of a STM32 library for an esp32.
 * as I use his source code I (Thomas Schreck) have to include:
 *
 * Copyright 2021 Minchul Jun (mcjun37@naver.com).  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY MINCHUL JUN ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL MINCHUL JUN OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of Minchul Jun.
 *
 */

#include "ADS131E08esp32.h"
#include <stdlib.h>
#include <string.h>

_adcConfE* adcConfE0 = NULL;
_adcConfE* adcConfE1 = NULL;

SPISettings* schlaubiHSPI = new SPISettings(17000000, MSBFIRST, SPI_MODE1);

void ADS131E08_control_start_signal(_signalState onOff);
void ADS131E08_control_reset_signal(_signalState onOff);
void ADS131E08_control_cs_signal(_adcType adcType, _signalState onOff);
bool ADS131E08_read_cs_signal(_adcType adcType);
HAL_StatusTypeDef ADS131E08_startup(_adcType adcType);
HAL_StatusTypeDef ADS131E08_send_command(_adcConfE* adcConfE, uint16_t cmd, uint16_t addr, uint8_t regs, uint16_t regNo);
void ADS131E08_set_default_register(_adcConfE* adcConfE);

/////////////////////////////////////////////////////////////////////////

void ADS131E08_init(_adcType adcType, SPIClass* hspi, uint16_t nreset, uint16_t cs,uint16_t ndrdy, uint16_t start)
{

    if(adcType == ADS131E08_ADC20)
    {
        adcConfE0                  = (_adcConfE*)malloc(sizeof(_adcConfE));
        memset(adcConfE0, 0, sizeof(_adcConfE));
        adcConfE0->type            = adcType;
        adcConfE0->stat            = ADS131E08_INIT;                                //ports lose relevancy on esp32 as each pin has a unique number
        adcConfE0->hspi            = hspi;                                          //and thus the ports are set to 0
        adcConfE0->nReset.port     = 0;
        adcConfE0->nReset.pin      = nreset;
        adcConfE0->cs.port         = 0;
        adcConfE0->cs.pin          = cs;
        adcConfE0->nDrdy.port      = 0;
        adcConfE0->nDrdy.pin       = ndrdy;
        adcConfE0->start.port      = 0;
        adcConfE0->start.pin       = start;
        adcConfE0->bufLen          = E08_WORDS_IN_FRAME * E08_WORD_LENGTH + 1;      // 9 Words x 24 Bits = 216 Bits (27 Bytes) + 1 (command byte)
        adcConfE0->rxBuf           = (uint8_t*)malloc(adcConfE0->bufLen);
        memset(adcConfE0->rxBuf, 0, adcConfE0->bufLen);
        adcConfE0->txBuf           = (uint8_t*)malloc(adcConfE0->bufLen);

        ADS131E08_set_default_register(adcConfE0);
    }
    else if(adcType == ADS131E08_ADC21)
    {
        adcConfE1                  = (_adcConfE*)malloc(sizeof(_adcConfE));
        memset(adcConfE1, 0, sizeof(_adcConfE));
        adcConfE1->type            = adcType;
        adcConfE1->stat            = ADS131E08_INIT;
        adcConfE1->hspi            = hspi;
        adcConfE1->nReset.port     = 0;
        adcConfE1->nReset.pin      = nreset;
        adcConfE1->cs.port         = 0;
        adcConfE1->cs.pin          = cs;
        adcConfE1->nDrdy.port      = 0;
        adcConfE1->nDrdy.pin       = ndrdy;
        adcConfE1->start.port      = 0;
        adcConfE1->start.pin       = start;
        adcConfE1->bufLen          = E08_WORDS_IN_FRAME * E08_WORD_LENGTH;      // 9 Words x 24 Bits
        adcConfE1->rxBuf           = (uint8_t*)malloc(adcConfE1->bufLen);
        memset(adcConfE1->rxBuf, 0, adcConfE1->bufLen);
        adcConfE1->txBuf           = (uint8_t*)malloc(adcConfE1->bufLen);

        ADS131E08_set_default_register(adcConfE1);
    }
    else 
    {
        if(Serial) Serial.println("ADS131_init: adcType not recognized");
    }

    return;
}


///////////////////////////////////////////////////////////////////////////////////

SPIClass* ADS131E08_is_spi_type(_adcType adcType)
{
    if(adcType == ADS131E08_ADC20)
    {
        return adcConfE0->hspi;
    }
    else if(adcType == ADS131E08_ADC21)
    {
        return adcConfE1->hspi;
    }      
    else
    {
        Serial.println("ADS131E08_is_spi_type: SPIClass is NULL!");
        return NULL;
    }
}


///////////////////////////////////////////////////////////////////////////////////

_ADS131E08_stat ADS131E08_is_adc_status(_adcType adcType)
{
    if(adcType == ADS131E08_ADC20)
    {
        return adcConfE0->stat;
    }
    else if(adcType == ADS131E08_ADC21)
    {
        return adcConfE1->stat;
    }    
    else
    {
        return 0;
    }
}

///////////////////////////////////////////////////////////////////////////////////

void ADS131E08_set_adc_status(_adcType adcType, _ADS131E08_stat stat)
{
    if(adcType == ADS131E08_ADC20)
    {
        adcConfE0->stat  = stat;
    }
    else if(adcType == ADS131E08_ADC21)
    {
        adcConfE1->stat = stat;
    }
    else
    {
        Serial.println("ADS131E08_set_adc_status: was not able to set adc_status!");
    }
    return;
}

///////////////////////////////////////////////////////////////////////////////////


HAL_StatusTypeDef ADS131E08_send_command(_adcConfE* adcConfE, uint16_t cmd, uint16_t addr, uint8_t regs, uint16_t regNo)
{
    const uint16_t cmdLen = 2;        // Command byte length (2 Bytes)
    HAL_StatusTypeDef result = HAL_OK;

    memset(adcConfE->txBuf, 0, adcConfE->bufLen);
    switch(cmd)
    {
        case ADS131E08_CMD_WAKEUP:
        case ADS131E08_CMD_STANDBY:
        case ADS131E08_CMD_RESET:
        case ADS131E08_CMD_RDATAC:
        case ADS131E08_CMD_SDATAC:
        case ADS131E08_CMD_RDATA:
            adcConfE->txBuf[0] = ADS131E08_UPPER(cmd);
            adcConfE->txBuf[1] = ADS131E08_LOWER(cmd);
            adcConfE->txBuf[2] = 0;
            adcConfE->txBuf[3] = 0;
            adcConfE->command = cmd;
            adcConfE->regAddr = 0;
            break;
        case ADS131E08_CMD_RREG:    // ADS131E08_CMD_RREGS
            adcConfE->txBuf[0] = ADS131E08_UPPER(ADS131E08_REG_COMMAND(cmd,addr,regNo));
            adcConfE->txBuf[1] = ADS131E08_LOWER(ADS131E08_REG_COMMAND(cmd,addr,regNo));
            adcConfE->txBuf[2] = 0;
            adcConfE->txBuf[3] = 0;
            adcConfE->command = cmd;
            adcConfE->regAddr = addr;
            adcConfE->regs = regs;
            break;
        case ADS131E08_CMD_WREG:
            adcConfE->txBuf[0] = ADS131E08_UPPER(ADS131E08_REG_COMMAND(cmd,addr,regNo));
            adcConfE->txBuf[1] = ADS131E08_LOWER(ADS131E08_REG_COMMAND(cmd,addr,regNo));
            adcConfE->txBuf[2] = ADS131E08_UPPER(ADS131E08_REG_REGDATA(regs));
            adcConfE->txBuf[3] = ADS131E08_LOWER(ADS131E08_REG_REGDATA(regs));
            adcConfE->command = cmd;
            adcConfE->regAddr = addr;
            adcConfE->regs = regs;
            break;
        default:
            break;
    }

    // Wait until cs pin is reset to send data
    while(0 == ADS131E08_read_cs_signal(adcConfE->type))
    {
        Serial.println("Waiting for CS @ADS131E08 to turn low...");
    }

    hspi.beginTransaction(schlaubiHSPI);

    ADS131E08_control_cs_signal(adcConfE->type, RESET_SIGNAL);

    //TODO: rewrite to support eps32 SPI
    if(cmd == ADS131E08_CMD_RREG)        
    {
        result = HAL_SPI_TransmitReceive(adcConfE->hspi, adcConfE->txBuf, adcConfE->rxBuf, cmdLen, 10);
        memset(adcConfE->rxBuf, 0, adcConfE->bufLen);
        result = HAL_SPI_Receive(adcConfE->hspi, adcConfE->rxBuf, regNo, 500);        

        // Update Register Status
        adcConfE->sr.mp[adcConfE->regAddr] = adcConfE->rxBuf[0];
    }
    else if(cmd == ADS131E08_CMD_WREG)
    {
        result = HAL_SPI_TransmitReceive(adcConfE->hspi, adcConfE->txBuf, adcConfE->rxBuf, regNo + cmdLen, 10);
    }
    else if(cmd == ADS131E08_CMD_RDATA)
    {
        memset(adcConfE->rxBuf, 0, adcConfE->bufLen);
        result = HAL_SPI_TransmitReceive(adcConfE->hspi, adcConfE->txBuf, adcConfE->rxBuf, 28, 10);
    }
    else
    {
        result = HAL_SPI_TransmitReceive(adcConfE->hspi, adcConfE->txBuf, adcConfE->rxBuf, cmdLen, 10);
    }
    ADS131E08_control_cs_signal(adcConfE->type, SET_SIGNAL);

    return result;
}


///////////////////////////////////////////////////////////////////////////////////