//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                                 Copyright 2016-2021, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Sets EA mode (Lite, Advanced or Rider).
#include "common/mode.h"

// Includes common files.
#include "common/code-conf.h"
#include "common/define.h"
#include "common/enum.h"

// Includes class files.
#include "classes/Chart.mqh"
#include "classes/EA.mqh"
#include "classes/Msg.mqh"
#include "classes/Terminal.mqh"
#include "classes/Trade.mqh"

// Includes indicator classes.
#include "classes/Indicators/Indi_AC.mqh"
#include "classes/Indicators/Indi_AD.mqh"
#include "classes/Indicators/Indi_ADX.mqh"
#include "classes/Indicators/Indi_AO.mqh"
#include "classes/Indicators/Indi_ATR.mqh"
#include "classes/Indicators/Indi_Alligator.mqh"
#include "classes/Indicators/Indi_BWMFI.mqh"
#include "classes/Indicators/Indi_Bands.mqh"
#include "classes/Indicators/Indi_BearsPower.mqh"
#include "classes/Indicators/Indi_BullsPower.mqh"
#include "classes/Indicators/Indi_CCI.mqh"
#include "classes/Indicators/Indi_DEMA.mqh"
#include "classes/Indicators/Indi_DeMarker.mqh"
#include "classes/Indicators/Indi_Envelopes.mqh"
#include "classes/Indicators/Indi_Force.mqh"
#include "classes/Indicators/Indi_Fractals.mqh"
#include "classes/Indicators/Indi_Gator.mqh"
#include "classes/Indicators/Indi_HeikenAshi.mqh"
#include "classes/Indicators/Indi_Ichimoku.mqh"
#include "classes/Indicators/Indi_MA.mqh"
#include "classes/Indicators/Indi_MACD.mqh"
#include "classes/Indicators/Indi_MFI.mqh"
#include "classes/Indicators/Indi_Momentum.mqh"
#include "classes/Indicators/Indi_OBV.mqh"
#include "classes/Indicators/Indi_OsMA.mqh"
#include "classes/Indicators/Indi_RSI.mqh"
#include "classes/Indicators/Indi_RVI.mqh"
#include "classes/Indicators/Indi_SAR.mqh"
#include "classes/Indicators/Indi_StdDev.mqh"
#include "classes/Indicators/Indi_Stochastic.mqh"
#include "classes/Indicators/Indi_WPR.mqh"
#include "classes/Indicators/Indi_ZigZag.mqh"

// EA structs.
#include "common/struct.h"

// Strategy enums.
#include "strategies/enum.h"

// Main user inputs.
#include "inputs.h"

// Strategy includes.
INPUT string __Strategy_Parameters__ = "-- Strategy parameters --";  // >>> STRATEGIES <<<
#include "strategies/strategies.h"

// End of user inputs.
input string __EA_Parameters__ =
    "-- End of input parameters for " + ea_name + " v" + ea_version + " --";  // >>> EA31337 <<<
