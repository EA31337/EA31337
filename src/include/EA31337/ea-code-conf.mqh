//+------------------------------------------------------------------+
//|                                                 ea-code-conf.mqh |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016-2019, kenorb"
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| Predefined code configurations.
//+------------------------------------------------------------------+
#ifdef __testing__      // Mode for testing components.
  #define __disabled__  // Disable all strategies by default.
  #define __noactions__ // Disable conditioned actions by default.
  #define __noboost__   // Disable boosting by default.
  #define __nospreads__ // Disable spread limits.
  #define __nodebug__   // Disable debug messages by default.
#endif

#ifdef __optimize__
  #undef __backtest__     // Disable backtesting mode.
  #undef __debug__        // Disable debug messages.
  #undef __trace__        // Disable trace messages.
#endif

#ifdef __backtest__
  #ifndef __input__
    #define __input__
  #endif
  #define __debug__
  #ifndef __profiler__
    #define __profiler__
  #endif
#endif

#ifdef __rider__
  #define __advanced__  // Rider mode works only with advanced mode.
  #define __nofactor__  // No booting factor for daily, weekly and monthly strategies.
#endif

#ifdef __limited__
  #define __noboost__   // Disable boosting for limited mode.
  #define __nofactor__  // No booting factor for daily, weekly and monthly strategies.
  #define __trend__     // Trade with trend.
  //#define __noactions__ // Disable actions for limited mode.
#endif

#ifdef __release__
  #ifndef __input__
    #define __input__
  #endif
  #undef __disabled__     // Enable all strategies by default.
  #undef __backtest__     // Disable backtesting mode.
  #undef __optimize__     // Disable optimization mode.
  #undef __noboost__      // Enable boosting by default.
  #undef __nospreads__    // Enable spread limitation by default.
  #undef __limited__      // Disable safe mode by default.
  #undef __experimental__ // Disable experimental features.
  #undef __debug__        // Disable debug messages.
  #undef __trace__        // Disable trace messages.
#endif
