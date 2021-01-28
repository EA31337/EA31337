//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                       Copyright 2016-2021, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//|                                                     ea-input.mqh |
//+------------------------------------------------------------------+

/*
 *  This file is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


// Includes.
#include "..\enum.h"

//+------------------------------------------------------------------+
//| Inputs.
//+------------------------------------------------------------------+

// Includes strategies.
input static string __Strategy_Timeframes__ =
    "-- Strategy's timeframes --";      // >>> STRATEGY'S TIMEFRAMES (1-255: M1=1,M5=2,M15=4,M30=8,H1=16,H4=32...) <<<
input unsigned int AC_Active_Tf = 0;    // AC: Activated timeframes
input unsigned int AD_Active_Tf = 0;    // AD: Activated timeframes
input unsigned int ADX_Active_Tf = 0;   // ADX: Activated timeframes
input unsigned int Alligator_Active_Tf = 0;    // Alligator: Activated timeframes
input unsigned int ATR_Active_Tf = 0;          // ATR: Activated timeframes
input unsigned int Awesome_Active_Tf =  0;     // Awesome: Activated timeframes
input unsigned int Bands_Active_Tf = 1;        // Bands: Activated timeframes
input unsigned int BearsPower_Active_Tf = 8;   // BearsPower: Activated timeframes
input unsigned int BullsPower_Active_Tf = 8;   // BullsPower: Activated timeframes
input unsigned int BWMFI_Active_Tf = 0;        // BWMFI: Activated timeframes
input unsigned int CCI_Active_Tf = 8;          // CCI: Activated timeframes
input unsigned int DeMarker_Active_Tf = 8;     // DeMarker: Activated timeframes
input unsigned int ElliottWave_Active_Tf = 0;  // ElliottWave: Activated timeframes
input unsigned int Envelopes_Active_Tf = 0;    // Envelopes: Activated timeframes
input unsigned int Force_Active_Tf =  0;       // Force: Activated timeframes
input unsigned int Fractals_Active_Tf = 0;     // Fractals: Activated timeframes
input unsigned int Gator_Active_Tf =  0;       // Gator: Activated timeframes
input unsigned int Ichimoku_Active_Tf = 10;    // Ichimoku: Activated timeframes
input unsigned int MA_Active_Tf = 0;           // MA: Activated timeframes
input unsigned int MACD_Active_Tf = 2;         // MACD: Activated timeframes
input unsigned int MFI_Active_Tf =  0;         // MFI: Activated timeframes
input unsigned int Momentum_Active_Tf = 8;     // Momentum: Activated timeframes
input unsigned int OBV_Active_Tf =  0;         // OBV: Activated timeframes
input unsigned int OSMA_Active_Tf = 0;         // OsMA: Activated timeframes
input unsigned int RSI_Active_Tf = 0;          // RSI: Activated timeframes
input unsigned int RVI_Active_Tf = 0;          // RVI: Activated timeframes
input unsigned int SAR_Active_Tf = 4;          // SAR: Activated timeframes
input unsigned int StdDev_Active_Tf = 0;       // StdDev: Activated timeframes
input unsigned int Stochastic_Active_Tf = 0;   // Stochastic: Activated timeframes
input unsigned int WPR_Active_Tf = 0;          // WPR: Activated timeframes
input unsigned int ZigZag_Active_Tf = 4;       // ZigZag: Activated timeframes

extern string __Trade_Params__ = "-- EA's trade parameters --";  // >>> EA's TRADE <<<
input double EA_LotSize = 0;                                     // Lot size (0 = auto)
