//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                       Copyright 2016-2021, 31337 Investments Ltd |
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

//+------------------------------------------------------------------+
//| Inputs.
//+------------------------------------------------------------------+

// Include input params based on the EA mode.
input static string __EA_Mode_Parameters__ =
    "-- EA parameters for " + ea_name + " v" + ea_version + " --";  // >>> EA31337 <<<
#ifdef __advanced__
#ifdef __rider__
#include "common/rider/inputs.mqh"
#else
#include "common/advanced/inputs.mqh"
#endif
#else
#include "common/lite/inputs.mqh"
#endif

// input string __Trade_Parameters__ = "-- Trade parameters --"; // >>> TRADE <<<
// input ulong TimeframeFilter = 0; // Timeframes filter (0 - auto)
// input double MinPipChangeToTrade = 0.4; // Min pip change to trade (0 = every tick)

input string __EA_Logging_Parameters__ = "-- Settings for logging & messages --";  // >>> LOGS & MESSAGES <<<
input ENUM_LOG_LEVEL VerboseLevel = V_INFO;                                        // Level of log verbosity
// input bool WriteSummaryReport = true;                                           // Write summary report on finish

input string __EA_Other_Parameters__ = "-- Other parameters --";  // >>> OTHER PARAMETERS <<<
input bool EA_DisplayDetailsOnChart = true;                       // Display EA details on chart
input uint EA_MagicNumber = 31337;                                // Starting EA magic number
