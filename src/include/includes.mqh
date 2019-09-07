//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Includes code configuration.
#include "EA31337\ea-mode.mqh"
#include "EA31337\ea-code-conf.mqh"
#include "EA31337\ea-defaults.mqh"
#include "EA31337\ea-enums.mqh"
#include "EA31337\ea-properties.mqh"

// Includes version specific configuration.
#ifdef __advanced__
  #ifdef __rider__
    #include "EA31337\rider\ea-conf.mqh"
  #else
    #include "EA31337\advanced\ea-conf.mqh"
  #endif
#else
  #include "EA31337\lite\ea-conf.mqh"
#endif

// Includes class files.
#include "EA31337-classes\Account.mqh"
#include "EA31337-classes\Array.mqh"
#include "EA31337-classes\Chart.mqh"
#include "EA31337-classes\Collection.mqh"
#include "EA31337-classes\Condition.mqh"
#include "EA31337-classes\Convert.mqh"
#include "EA31337-classes\DateTime.mqh"
// #include "EA31337-classes\Draw.mqh"
#include "EA31337-classes\File.mqh"
#include "EA31337-classes\Order.mqh"
#include "EA31337-classes\Orders.mqh"
#include "EA31337-classes\Market.mqh"
#include "EA31337-classes\Math.mqh"
#include "EA31337-classes\MD5.mqh"
#include "EA31337-classes\Misc.mqh"
#include "EA31337-classes\Msg.mqh"
#include "EA31337-classes\Report.mqh"
#include "EA31337-classes\Stats.mqh"
#include "EA31337-classes\Strategy.mqh"
#include "EA31337-classes\String.mqh"
#include "EA31337-classes\SummaryReport.mqh"
#include "EA31337-classes\Terminal.mqh"
#include "EA31337-classes\Tester.mqh"
#include "EA31337-classes\Tests.mqh"
#include "EA31337-classes\Ticker.mqh"
#include "EA31337-classes\Trade.mqh"
#ifdef __profiler__
#include "EA31337-classes\Profiler.mqh"
#endif

// Includes technical indicator classes.
#include "EA31337-classes\Indicators\Indi_AC.mqh"
#include "EA31337-classes\Indicators\Indi_AD.mqh"
#include "EA31337-classes\Indicators\Indi_ADX.mqh"
#include "EA31337-classes\Indicators\Indi_AO.mqh"
#include "EA31337-classes\Indicators\Indi_ATR.mqh"
#include "EA31337-classes\Indicators\Indi_Alligator.mqh"
#include "EA31337-classes\Indicators\Indi_BWMFI.mqh"
#include "EA31337-classes\Indicators\Indi_Bands.mqh"
#include "EA31337-classes\Indicators\Indi_BearsPower.mqh"
#include "EA31337-classes\Indicators\Indi_BullsPower.mqh"
#include "EA31337-classes\Indicators\Indi_CCI.mqh"
#include "EA31337-classes\Indicators\Indi_DeMarker.mqh"
#include "EA31337-classes\Indicators\Indi_Envelopes.mqh"
#include "EA31337-classes\Indicators\Indi_Force.mqh"
#include "EA31337-classes\Indicators\Indi_Fractals.mqh"
#include "EA31337-classes\Indicators\Indi_Gator.mqh"
#include "EA31337-classes\Indicators\Indi_HeikenAshi.mqh"
#include "EA31337-classes\Indicators\Indi_Ichimoku.mqh"
#include "EA31337-classes\Indicators\Indi_MA.mqh"
#include "EA31337-classes\Indicators\Indi_MACD.mqh"
#include "EA31337-classes\Indicators\Indi_MFI.mqh"
#include "EA31337-classes\Indicators\Indi_Momentum.mqh"
#include "EA31337-classes\Indicators\Indi_OBV.mqh"
#include "EA31337-classes\Indicators\Indi_OsMA.mqh"
#include "EA31337-classes\Indicators\Indi_RSI.mqh"
#include "EA31337-classes\Indicators\Indi_RVI.mqh"
#include "EA31337-classes\Indicators\Indi_SAR.mqh"
#include "EA31337-classes\Indicators\Indi_StdDev.mqh"
#include "EA31337-classes\Indicators\Indi_Stochastic.mqh"
#include "EA31337-classes\Indicators\Indi_WPR.mqh"
#include "EA31337-classes\Indicators\Indi_ZigZag.mqh"