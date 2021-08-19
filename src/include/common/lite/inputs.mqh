//+------------------------------------------------------------------+
//|                                                         inputs.h |
//|                                 Copyright 2016-2021, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
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
#ifdef __MQL4__
input static string __Strategies_Active__ = "-- Active strategies --";  // >>> ACTIVE STRATEGIES <<<
input ENUM_STRATEGY Strategy_M1 = STRAT_NONE;                           // Strategy on M1
input ENUM_STRATEGY Strategy_M5 = STRAT_NONE;                           // Strategy on M5
input ENUM_STRATEGY Strategy_M15 = STRAT_BANDS;                         // Strategy on M15
input ENUM_STRATEGY Strategy_M30 = STRAT_BANDS;                         // Strategy on M30
input ENUM_STRATEGY Strategy_H1 = STRAT_RSI;                            // Strategy on H1
input ENUM_STRATEGY Strategy_H4 = STRAT_RSI;                            // Strategy on H4
#else
input group "Active strategy" input ENUM_STRATEGY Strategy_M1 = STRAT_NONE;  // Strategy on M1
input ENUM_STRATEGY Strategy_M5 = STRAT_NONE;                                // Strategy on M5
input ENUM_STRATEGY Strategy_M15 = STRAT_ZIGZAG;                             // Strategy on M15
input ENUM_STRATEGY Strategy_M30 = STRAT_ZIGZAG;                             // Strategy on M30
input ENUM_STRATEGY Strategy_H1 = STRAT_RSI;                                 // Strategy on H1
input ENUM_STRATEGY Strategy_H4 = STRAT_RSI;                                 // Strategy on H4
#endif

#ifdef __MQL4__
input string __Trade_Params__ = "-- Trade parameters --";  // >>> TRADE <<<
#else
input group "Trade parameters"
#endif
input int EA_SignalOpenFilter = 40;  // Signal open filter
int EA_SignalCloseFilter = 0;        // Signal close filter
