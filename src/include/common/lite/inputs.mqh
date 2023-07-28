//+------------------------------------------------------------------+
//|                                                         inputs.h |
//|                                 Copyright 2016-2022, EA31337 Ltd |
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
#else
input group "Active strategy"
#endif
int EA_Strategy_Filter = 2047;                     // S-Filter(0=n/a,All=2047,1=M1,2=M5,4=M15,8=M30,16=H1,32=H2,64=H4)
input ENUM_STRATEGY Strategy_M1 = STRAT_NONE;      // Strategy on M1
input ENUM_STRATEGY Strategy_M5 = STRAT_NONE;      // Strategy on M5
input ENUM_STRATEGY Strategy_M15 = STRAT_NONE;     // Strategy on M15
input ENUM_STRATEGY Strategy_M30 = STRAT_NONE;     // Strategy on M30
input ENUM_STRATEGY Strategy_H1 = STRAT_TMA_TRUE;  // Strategy on H1
input ENUM_STRATEGY Strategy_H2 = STRAT_HEIKEN_ASHI;  // Strategy on H2
input ENUM_STRATEGY Strategy_H3 = STRAT_HEIKEN_ASHI;  // Strategy on H3
input ENUM_STRATEGY Strategy_H4 = STRAT_HEIKEN_ASHI;  // Strategy on H4
input ENUM_STRATEGY Strategy_H6 = STRAT_AC;           // Strategy on H6
input ENUM_STRATEGY Strategy_H8 = STRAT_AC;           // Strategy on H8
input ENUM_STRATEGY Strategy_H12 = STRAT_ENVELOPES;   // Strategy on H12
