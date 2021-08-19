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
input group "Active strategies"
#endif
input ENUM_STRATEGY Strategy_M1 = (ENUM_STRATEGY)STRAT_NONE;   // Strategy on M1
input ENUM_STRATEGY Strategy_M5 = (ENUM_STRATEGY)STRAT_NONE;   // Strategy on M5
input ENUM_STRATEGY Strategy_M15 = (ENUM_STRATEGY)STRAT_MFI;   // Strategy on M15
input ENUM_STRATEGY Strategy_M30 = (ENUM_STRATEGY)STRAT_MACD;  // Strategy on M30

#ifdef __MQL4__
input static string __Strategies_Stops__ = "-- Strategies' stops --";  // >>> STRATEGIES' STOPS <<<
#else
input group "Strategies' stops"
#endif
input ENUM_STRATEGY EA_Stops_M1 = (ENUM_STRATEGY)STRAT_NONE;       // Stop loss on M1
input ENUM_STRATEGY EA_Stops_M5 = (ENUM_STRATEGY)STRAT_NONE;       // Stop loss on M5
input ENUM_STRATEGY EA_Stops_M15 = (ENUM_STRATEGY)STRAT_MOMENTUM;  // Stop loss on M15
input ENUM_STRATEGY EA_Stops_M30 = (ENUM_STRATEGY)STRAT_WPR;       // Stop loss on M30
// input ENUM_STRATEGY EA_Stops_H1 = (ENUM_STRATEGY)0;   // Stop loss on H1
// input ENUM_STRATEGY EA_Stops_H4 = (ENUM_STRATEGY)0;   // Stop loss on H4

#ifdef __MQL4__
input string __Strategies_Signal_Filters__ = "-- Strategies' signal filters --";  // >>> STRATEGIES' SIGNAL FILTERS <<<
#else
input group "Strategies' signal filters"
#endif
input int EA_SignalOpenFilter = 40;   // Signal open filter (-127-127)
input int EA_SignalCloseFilter = 16;  // Signal close filter (-127-127)

#ifdef __MQL4__
input string __EA_Actions__ = "-- EA's actions --";  // >>> EA's ACTIONS <<<
#else
input group "EA's actions"
#endif
input ENUM_EA_ADV_COND EA_Action1_If = EA_ADV_COND_NONE;        // 1: Action's condition
input ENUM_EA_ADV_ACTION EA_Action1_Then = EA_ADV_ACTION_NONE;  // 1: Action to execute
// input float EA_Action1_If_Arg = 0;                                 // 1: Action's condition argument
// input float EA_Action1_Then_Arg = 0;                               // 1: Action's argument

#ifdef __MQL4__
input string __Order_Params__ = "-- Orders' limits --";  // >>> ORDERS' LIMITS <<<
#else
input group "Orders' limits"
#endif
input float EA_OrderCloseLoss = 0;    // Close loss (in pips)
input float EA_OrderCloseProfit = 0;  // Close profit (in pips)
input int EA_OrderCloseTime = 0;      // Close time in mins (>0) or bars (<0)
