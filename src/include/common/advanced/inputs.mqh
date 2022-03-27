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
input ENUM_STRATEGY Strategy_M1 = STRAT_NONE;        // Strategy on M1
input ENUM_STRATEGY Strategy_M5 = STRAT_NONE;        // Strategy on M5
input ENUM_STRATEGY Strategy_M15 = STRAT_INDICATOR;  // Strategy on M15
input ENUM_STRATEGY Strategy_M30 = STRAT_ENVELOPES;  // Strategy on M30
input ENUM_STRATEGY Strategy_H1 = STRAT_ICHIMOKU;    // Strategy on H1
input ENUM_STRATEGY Strategy_H2 = STRAT_AD;          // Strategy on H2
input ENUM_STRATEGY Strategy_H3 = STRAT_AMA;         // Strategy on H3
input ENUM_STRATEGY Strategy_H4 = STRAT_ASI;         // Strategy on H4
input ENUM_STRATEGY Strategy_H6 = STRAT_PIVOT;       // Strategy on H6
input ENUM_STRATEGY Strategy_H8 = STRAT_OBV;         // Strategy on H8
input ENUM_STRATEGY Strategy_H12 = STRAT_NONE;       // Strategy on H12

#ifdef __MQL4__
input static string __Strategies_Stops__ = "-- Strategies' stops --";  // >>> STRATEGIES' STOPS <<<
#else
input group "Strategies' stops"
#endif
input ENUM_STRATEGY EA_Stops_M1 = STRAT_NONE;    // Stop loss on M1
input ENUM_STRATEGY EA_Stops_M5 = STRAT_NONE;    // Stop loss on M5
input ENUM_STRATEGY EA_Stops_M15 = STRAT_FORCE;  // Stop loss on M15
input ENUM_STRATEGY EA_Stops_M30 = STRAT_RSI;    // Stop loss on M30
input ENUM_STRATEGY EA_Stops_H1 = STRAT_AC;      // Stop loss on H1
input ENUM_STRATEGY EA_Stops_H2 = STRAT_PIVOT;   // Stop loss on H2
input ENUM_STRATEGY EA_Stops_H3 = STRAT_FORCE;   // Stop loss on H3
input ENUM_STRATEGY EA_Stops_H4 = STRAT_AC;      // Stop loss on H4
input ENUM_STRATEGY EA_Stops_H6 = STRAT_MA;      // Stop loss on H6
input ENUM_STRATEGY EA_Stops_H8 = STRAT_BANDS;   // Stop loss on H8
input ENUM_STRATEGY EA_Stops_H12 = STRAT_NONE;   // Stop loss on H12

#ifdef __MQL4__
input string __Signal_Filters__ = "-- Signal filters --";  // >>> SIGNAL FILTERS <<<
#else
input group "Signal filters"
#endif
input int EA_SignalOpenFilterMethod = 37;   // Open (1=!BarO,2=Trend,4=PP,8=OppO,16=Peak,32=BetterO,64=!Eq<1%)
input int EA_SignalCloseFilterMethod = 40;  // Close (1=!BarO,2=!Trend,4=!PP,8=O>H,16=Peak,32=BetterO,64=Eq>1%)
input int EA_SignalOpenFilterTime = 3;      // Time (1=CHGO,2=FR,4=HK,8=LON,16=NY,32=SY,64=TYJ,128=WGN)
int EA_SignalOpenStrategyFilter = 0;        // Strategy (0-EachSignal,1=FirstOnly,2=HourlyConfirmed)
input int EA_TickFilterMethod = 32;  // Tick (1=PerMin,2=Peaks,4=PeaksMins,8=Unique,16=MiddleBar,32=Open,64=10thBar)

#ifdef __MQL4__
input string __EA_Tasks__ = "-- EA's tasks --";  // >>> EA's TASKS <<<
#else
input group "EA's tasks"
#endif
input ENUM_EA_ADV_COND EA_Task1_If = EA_ADV_COND_TRADE_EQUITY_GT_05PC;         // 1: Task's condition
input ENUM_EA_ADV_ACTION EA_Task1_Then = EA_ADV_ACTION_ORDERS_CLOSE_ALL;       // 1: Task's action
input ENUM_EA_ADV_COND EA_Task2_If = EA_ADV_COND_TRADE_EQUITY_GT_02PC;         // 2: Task's condition
input ENUM_EA_ADV_ACTION EA_Task2_Then = EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND;  // 2: Task's action
input ENUM_EA_ADV_COND EA_Task3_If = EA_ADV_COND_TRADE_EQUITY_LT_05PC;         // 3: Task's condition
input ENUM_EA_ADV_ACTION EA_Task3_Then = EA_ADV_ACTION_CLOSE_MOST_PROFIT;      // 3: Task's action
// input float EA_Task1_If_Arg = 0;                                 // 1: Task's condition argument
// input float EA_Task1_Then_Arg = 0;                               // 1: Task's action argument

#ifdef __MQL4__
input string __Order_Params__ = "-- Orders' limits --";  // >>> ORDERS' LIMITS <<<
#else
input group "Orders' limits"
#endif
input float EA_OrderCloseLoss = 200;  // Close loss (in pips)
input float EA_OrderCloseProfit = 0;  // Close profit (in pips)
input int EA_OrderCloseTime = 0;      // Close time in mins (>0) or bars (<0)
