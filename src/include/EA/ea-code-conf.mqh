//+------------------------------------------------------------------+
//|                                                 ea-code-conf.mqh |
//|                                           Copyright 2015, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, kenorb"
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| Predefined code configurations.
//+------------------------------------------------------------------+
#ifdef __testing__
  #define __disabled__  // Disable all strategies by default.
  #define __noactions__ // Disable conditioned actions by default.
  #define __noboost__   // Disable boosting by default.
  #define __nospreads__ // Disable spread limits.
  #define __nodebug__   // Disable debug messages by default.
#endif

#ifdef __release__
  #undef __disabled__  // Enable all strategies by default.
  #undef __noboost__   // Enable boosting by default.
  #undef __nospreads__ // Enable spread limitation by default.
  #undef __limited__   // Disable safe mode by default.
  #undef __rider__     // Disable rider strategy by default.
  #undef __experimental__
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