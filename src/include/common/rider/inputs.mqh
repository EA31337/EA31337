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
input ENUM_STRATEGY Strategy_M1 = STRAT_NONE;              // Strategy on M1 (filter=1)
input ENUM_STRATEGY Strategy_M5 = STRAT_NONE;              // Strategy on M5 (filter=2)
input ENUM_STRATEGY Strategy_M15 = STRAT_META_TREND;       // Strategy on M15 (filter=4)
input ENUM_STRATEGY Strategy_M30 = STRAT_MACD;             // Strategy on M30 (filter=8)
input ENUM_STRATEGY Strategy_H1 = STRAT_OSCILLATOR_CROSS;  // Strategy on H1 (filter=16)
input ENUM_STRATEGY Strategy_H2 = STRAT_TMAT_SVEBB;        // Strategy on H2 (filter=32)
input ENUM_STRATEGY Strategy_H3 = STRAT_META_SCALPER;      // Strategy on H3 (filter=64)
input ENUM_STRATEGY Strategy_H4 = STRAT_META_DOUBLE;       // Strategy on H4 (filter=128)
input ENUM_STRATEGY Strategy_H6 = STRAT_TMAT_SVEBB;        // Strategy on H6 (filter=256)
input ENUM_STRATEGY Strategy_H8 = STRAT_META_TIMEZONE;     // Strategy on H8 (filter=512)
input ENUM_STRATEGY Strategy_H12 = STRAT_GATOR;            // Strategy on H12 (filter=1024)
input int EA_Strategy_Filter = 2047;  // Filter(0=n/a,All=2047,1=M1,2=M5,4=M15,8=M30,16=H1,32=H2,64=H3)

#ifdef __MQL4__
input static string __Strategies_Stops__ = "-- Strategies' stops --";  // >>> STRATEGIES' STOPS <<<
#else
input group "Strategies' stops"
#endif
input ENUM_STRATEGY EA_Stops_Strat = STRAT_SAR;  // Stop loss strategy
input ENUM_TIMEFRAMES EA_Stops_Tf = PERIOD_D1;   // Stop loss timeframe

#ifdef __MQL4__
input string __EA_Tasks__ = "-- EA's tasks --";  // >>> EA's TASKS <<<
#else
input group "EA's tasks"
#endif
input ENUM_EA_ADV_COND EA_Task1_If = EA_ADV_COND_TRADE_EQUITY_GT_05PC;             // 1: Task's condition (filter=1)
input ENUM_EA_ADV_ACTION EA_Task1_Then = EA_ADV_ACTION_ORDERS_CLOSE_ALL;           // 1: Task's action (filter=1)
input ENUM_EA_ADV_COND EA_Task2_If = EA_ADV_COND_TRADE_EQUITY_LT_05PC;             // 2: Task's condition (filter=2)
input ENUM_EA_ADV_ACTION EA_Task2_Then = EA_ADV_ACTION_CLOSE_MOST_PROFIT;          // 2: Task's action (filter=2)
input ENUM_EA_ADV_COND EA_Task3_If = EA_ADV_COND_TRADE_EQUITY_LT_05PC;             // 3: Task's condition (filter=4)
input ENUM_EA_ADV_ACTION EA_Task3_Then = EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT;  // 3: Task's action (filter=4)
input ENUM_EA_ADV_COND EA_Task4_If = EA_ADV_COND_TRADE_EQUITY_GT_RMARGIN;          // 4: Task's condition (filter=8)
input ENUM_EA_ADV_ACTION EA_Task4_Then = EA_ADV_ACTION_CLOSE_MOST_LOSS;            // 4: Task's action (filter=8)
input ENUM_EA_ADV_COND EA_Task5_If = EA_ADV_COND_NONE;                             // 5: Task's condition (filter=16)
input ENUM_EA_ADV_ACTION EA_Task5_Then = EA_ADV_ACTION_NONE;                       // 5: Task's action (filter=16)
input int EA_Tasks_Filter = 31;  // Tasks' filter (0=None,1=1st,2=2nd,4=3rd,8=4th,16=5th,31=All)

// input static string __EA_Order_Params__ = "-- EA's order params --";  // >>> EA's ORDERS <<<

#ifdef __MQL4__
input string __Signal_Filters__ = "-- Signal filters --";  // >>> SIGNAL FILTERS <<<
#else
input group "Signal filters"
#endif
input int EA_SignalOpenFilterMethod = 32;   // Open(1=!BarO,2=Trend,4=PP,8=OppO,16=Peak,32=BetterO,64=InLoss)
input int EA_SignalCloseFilterMethod = 32;  // Close(1=!BarO,2=!Trend,4=!PP,8=O>H,16=Peak,32=BetterO,64=InProfit)
input int EA_SignalOpenFilterTime = 3;      // Time (1=CHGO,2=FR,4=HK,8=LON,16=NY,32=SY,64=TYJ,128=WGN)
int EA_SignalOpenStrategyFilter = 2;        // Strategy (0-EachSignal,1=FirstOnly,2=HourlyConfirmed)
input int EA_TickFilterMethod = 32;  // Tick (1=PerMin,2=Peaks,4=PeaksMins,8=Unique,16=MiddleBar,32=Open,64=10thBar)
