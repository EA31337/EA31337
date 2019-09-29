//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Includes code configuration.
#include "EA31337/ea-mode.mqh"
#include "EA31337/ea-code-conf.mqh"
#include "EA31337/ea-defaults.mqh"
#include "EA31337/ea-enums.mqh"
#include "EA31337/ea-properties.mqh"

// Includes version specific configuration.
#ifdef __advanced__
  #ifdef __rider__
    #include "EA31337/rider/ea-conf.mqh"
  #else
    #include "EA31337/advanced/ea-conf.mqh"
  #endif
#else
  #include "EA31337/lite/ea-conf.mqh"
#endif

// Includes version specific user input params.
extern string __EA_Parameters__ = "-- Input EA parameters for " + ea_name + " v" + ea_version + " --"; // >>> EA31337 <<<
#ifdef __advanced__ // Include default input settings based on the mode.
  #ifdef __rider__
    #include "EA31337/rider/ea-input.mqh"
  #else
    #include "EA31337/advanced/ea-input.mqh"
  #endif
#else
  #include "EA31337/lite/ea-input.mqh"
#endif

// Includes class files.
#include "EA31337-classes/Account.mqh"
#include "EA31337-classes/Array.mqh"
#include "EA31337-classes/Chart.mqh"
#include "EA31337-classes/Collection.mqh"
#include "EA31337-classes/Condition.mqh"
#include "EA31337-classes/Convert.mqh"
#include "EA31337-classes/DateTime.mqh"
// #include "EA31337-classes/Draw.mqh"
#include "EA31337-classes/File.mqh"
#include "EA31337-classes/Order.mqh"
#include "EA31337-classes/Orders.mqh"
#include "EA31337-classes/Market.mqh"
#include "EA31337-classes/Math.mqh"
#include "EA31337-classes/MD5.mqh"
#include "EA31337-classes/Misc.mqh"
#include "EA31337-classes/Msg.mqh"
#include "EA31337-classes/Report.mqh"
#include "EA31337-classes/Stats.mqh"
#include "EA31337-classes/Strategy.mqh"
#include "EA31337-classes/String.mqh"
#include "EA31337-classes/SummaryReport.mqh"
#include "EA31337-classes/Terminal.mqh"
#include "EA31337-classes/Tester.mqh"
#include "EA31337-classes/Tests.mqh"
#include "EA31337-classes/Ticker.mqh"
#include "EA31337-classes/Trade.mqh"
#ifdef __profiler__
#include "EA31337-classes/Profiler.mqh"
#endif

// Includes strategies.
INPUT string __Strategy_Parameters__ = "-- Strategy parameters --"; // >>> STRATEGIES <<<
#include "EA31337-strategies/strategies.mqh"