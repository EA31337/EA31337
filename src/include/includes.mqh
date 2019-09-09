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

// Includes strategy classes.
#include "EA31337-strategies/AC/Stg_AC.mqh"
#include "EA31337-strategies/AD/Stg_AD.mqh"
#include "EA31337-strategies/ADX/Stg_ADX.mqh"
#include "EA31337-strategies/Alligator/Stg_Alligator.mqh"
#include "EA31337-strategies/ATR/Stg_ATR.mqh"
#include "EA31337-strategies/ATR/Stg_ATR.mqh"
#include "EA31337-strategies/Awesome/Stg_Awesome.mqh"
#include "EA31337-strategies/Bands/Stg_Bands.mqh"
#include "EA31337-strategies/BearsPower/Stg_BearsPower.mqh"
#include "EA31337-strategies/BullsPower/Stg_BullsPower.mqh"
#include "EA31337-strategies/BWMFI/Stg_BWMFI.mqh"
#include "EA31337-strategies/CCI/Stg_CCI.mqh"
#include "EA31337-strategies/DeMarker/Stg_DeMarker.mqh"
#include "EA31337-strategies/Envelopes/Stg_Envelopes.mqh"
#include "EA31337-strategies/Force/Stg_Force.mqh"
#include "EA31337-strategies/Fractals/Stg_Fractals.mqh"
#include "EA31337-strategies/Gator/Stg_Gator.mqh"
#include "EA31337-strategies/Ichimoku/Stg_Ichimoku.mqh"
#include "EA31337-strategies/MA/Stg_MA.mqh"
#include "EA31337-strategies/MACD/Stg_MACD.mqh"
#include "EA31337-strategies/MFI/Stg_MFI.mqh"
#include "EA31337-strategies/Momentum/Stg_Momentum.mqh"
#include "EA31337-strategies/OBV/Stg_OBV.mqh"
#include "EA31337-strategies/OSMA/Stg_OSMA.mqh"
#include "EA31337-strategies/RSI/Stg_RSI.mqh"
#include "EA31337-strategies/RVI/Stg_RVI.mqh"
#include "EA31337-strategies/SAR/Stg_SAR.mqh"
#include "EA31337-strategies/StdDev/Stg_StdDev.mqh"
#include "EA31337-strategies/Stoch/Stg_Stoch.mqh"
#include "EA31337-strategies/WPR/Stg_WPR.mqh"
#include "EA31337-strategies/ZigZag/Stg_ZigZag.mqh"
