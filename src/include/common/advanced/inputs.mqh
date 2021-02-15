//+------------------------------------------------------------------+
//|                                                         inputs.h |
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
input static string __Strategies_Active__ = "-- Active strategies --";     // >>> ACTIVE STRATEGIES <<<
input ENUM_STRATEGY Strategy_M1 = (ENUM_STRATEGY)0;                        // Strategy on M1
input ENUM_STRATEGY Strategy_M5 = (ENUM_STRATEGY)0;                        // Strategy on M5
input ENUM_STRATEGY Strategy_M15 = (ENUM_STRATEGY)27;                      // Strategy on M15
input ENUM_STRATEGY Strategy_M30 = (ENUM_STRATEGY)27;                      // Strategy on M30

input static string __EA_Stops__ = "-- EA's stops --";  // >>> EA's STOPS (SL/TP) <<<
input ENUM_STRATEGY EA_Stops_M1 = (ENUM_STRATEGY)0;            // Stop loss on M1
input ENUM_STRATEGY EA_Stops_M5 = (ENUM_STRATEGY)0;            // Stop loss on M5
input ENUM_STRATEGY EA_Stops_M15 = (ENUM_STRATEGY)29;          // Stop loss on M15
input ENUM_STRATEGY EA_Stops_M30 = (ENUM_STRATEGY)19;          // Stop loss on M30
// input ENUM_STRATEGY EA_Stops_H1 = (ENUM_STRATEGY)0;   // Stop loss on H1
// input ENUM_STRATEGY EA_Stops_H4 = (ENUM_STRATEGY)0;   // Stop loss on H4

input static string __EA_Order_Params__ = "-- EA's order params --";  // >>> EA's ORDERS <<<
input int EA_OrderCloseTime_M1 = 0;                                   // Close time on M1 in mins (>0) or bars (<0)
input int EA_OrderCloseTime_M5 = 0;                                   // Close time on M5 in mins (>0) or bars (<0)
input int EA_OrderCloseTime_M15 = 0;                                  // Close time on M15 in mins (>0) or bars (<0)
input int EA_OrderCloseTime_M30 = 0;                                  // Close time on M30 in mins (>0) or bars (<0)
// input int EA_OrderCloseTime_H1 = 0;   // Close time on H1 in mins (>0) or bars (<0)
// input int EA_OrderCloseTime_H4 = 0;   // Close time on H4 in mins (>0) or bars (<0)

extern string __Trade_Params__ = "-- EA's trade parameters --";  // >>> EA's TRADE <<<
input double EA_LotSize = 0;                                     // Lot size (0 = auto)
