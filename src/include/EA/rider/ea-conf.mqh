//+------------------------------------------------------------------+
//|                                                      ea-conf.mqh |
//|                            Copyright 2016, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| EA global configuration for Rider
//+------------------------------------------------------------------+

#ifdef __backtest__
#define ea_name    "EA31337 Rider (Backtest)"
#else
#define ea_name    "EA31337 Rider"
#endif

//+------------------------------------------------------------------+
//| Assign the license.
//+------------------------------------------------------------------+

#ifndef __nolicense__
  extern string E_Mail = "";
  extern string License = "";
#else
  #ifndef __backtest__
  string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
  string License = "52-30101111-11-46101107112101-17120101-64-17";
  #else
  string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
  string License = "63-30101111-11-46101107112101-17120101-64-1711411111010";
  #endif
#endif
