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
#else
input group "Active strategy"
#endif
input ENUM_STRATEGY Strategy_M1 = (ENUM_STRATEGY)STRAT_NONE;            // Strategy on M1
input ENUM_STRATEGY Strategy_M5 = (ENUM_STRATEGY)STRAT_AWESOME;         // Strategy on M5
input ENUM_STRATEGY Strategy_M15 = (ENUM_STRATEGY)STRAT_RSI;            // Strategy on M15
input ENUM_STRATEGY Strategy_M30 = (ENUM_STRATEGY)STRAT_RSI;            // Strategy on M30
input ENUM_STRATEGY Strategy_H1 = STRAT_NONE;          // Strategy on H1
input ENUM_STRATEGY Strategy_H4 = STRAT_NONE;          // Strategy on H4

#ifdef __MQL4__
input static string __Strategies_Stops__ = "-- Strategies' stops --";  // >>> STRATEGIES' STOPS <<<
#else
input group "Strategies' stops"
#endif
input ENUM_STRATEGY EA_Stops = (ENUM_STRATEGY)STRAT_AD;  // Stop loss

#ifdef __MQL4__
input string __EA_Actions__ = "-- EA's actions --";  // >>> EA's ACTIONS <<<
#else
input group "EA's actions"
#endif
input ENUM_EA_ADV_COND EA_Action1_If = EA_ADV_COND_NONE;        // 1: Action's condition
input ENUM_EA_ADV_ACTION EA_Action1_Then = EA_ADV_ACTION_NONE;  // 1: Action to execute
// input float EA_Action1_If_Arg = 0;                                 // 1: Action's condition argument
// input float EA_Action1_Then_Arg = 0;                               // 1: Action's argument

// input static string __EA_Order_Params__ = "-- EA's order params --";  // >>> EA's ORDERS <<<

#ifdef __MQL4__
input string __Strategies_Signal_Filters__ = "-- Strategies' signal filters --";  // >>> STRATEGIES' SIGNAL FILTERS <<<
#else
input group "Strategies' signal filters"
#endif
input int EA_SignalOpenFilter = 40;                             // Signal open filter
input int EA_SignalCloseFilter = 84;                            // Signal close filter (-127-127)
input int EA_SignalOpenFilterTime = 10;                         // Signal open filter time (-255-255)
