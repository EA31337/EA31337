//+------------------------------------------------------------------+
//|                                                         inputs.h |
//|                                 Copyright 2016-2024, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 *  This file is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.

 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.

 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// Includes.
#include "..\enum.h"

//+------------------------------------------------------------------+
//| Inputs.
//+------------------------------------------------------------------+

// Includes strategies.
#ifdef __MQL4__
input static string __Strategies_Active__ = "-- Main Strategy 1 - Main params --";  // >>> ACTIVE STRATEGIES <<<
#else
input group "Main Strategy 1 - Main params"
#endif
input ENUM_STRATEGY EA_Strategy1_Main = STRAT_META_MA_CROSS;                   // Strategy 1
input int EA_Strategy1_Tfs = M15B + M30B + H1B + H2B + H3B + H4B + H6B + H8B;  // Timeframe filter (0-65536)

#ifdef __MQL4__
input string __Signal_Filters__ = "-- Main Strategy 1 - Signal filters --";  // >>> SIGNAL FILTERS <<<
#else
input group "Main Strategy 1 - Signal filters"
#endif
input int EA_Strategy1_SignalOpenFilterMethod = -64;  // Open(1=!BarO,2=Trend,4=PP,8=OppO,16=Peak,32=BetterO,64=InLoss)
input int EA_Strategy1_SignalCloseFilterMethod =
    12;                                            // Close(1=!BarO,2=!Trend,4=!PP,8=O>H,16=Peak,32=BetterO,64=InProfit)
input int EA_Strategy1_SignalOpenFilterTime = 13;  // Time(1=CHGO,2=FR,4=HK,8=LON,16=NY,32=SY,64=TYJ,128=WGN)
int EA_Strategy1_SignalOpenStrategyFilter = 2;     // Strategy(0-EachSignal,1=FirstOnly,2=HourlyConfirmed)
input int EA_Strategy1_TickFilterMethod = 32;  // Tick(1=PerMin,2=Peaks,4=PeaksMins,8=Uniq,16=MidBar,32=Open,64=10thBar)

#ifdef __MQL4__
input string __Order_Params__ = "-- Main Strategy 1 - Orders' limits --";  // >>> ORDERS' LIMITS <<<
#else
input group "Main Strategy 1 - Orders' limits"
#endif
input float EA_Strategy1_OrderCloseLoss = 300;    // Close loss (in pips)
input float EA_Strategy1_OrderCloseProfit = 120;  // Close profit (in pips)
input int EA_Strategy1_OrderCloseTime = -90;      // Close time in mins (>0) or bars (<0)
