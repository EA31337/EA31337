//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
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

// Includes user input params.
#include "ea-inputs.mqh"

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
#include "EA31337-classes/Log.mqh"
#include "EA31337-classes/MD5.mqh"
#include "EA31337-classes/Mail.mqh"
#include "EA31337-classes/Market.mqh"
#include "EA31337-classes/Math.mqh"
#include "EA31337-classes/Misc.mqh"
#include "EA31337-classes/Msg.mqh"
#include "EA31337-classes/Order.mqh"
#include "EA31337-classes/Orders.mqh"
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
