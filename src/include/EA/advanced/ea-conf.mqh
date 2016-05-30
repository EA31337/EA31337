//+------------------------------------------------------------------+
//|                                                      ea-conf.mqh |
//|                            Copyright 2016, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| EA global configuration for Advanced
//+------------------------------------------------------------------+

#ifdef __backtest__
#define ea_name    "EA31337 Advanced (Backtest)"
#else
#define ea_name    "EA31337 Advanced"
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
  string License = "46-30101111-11-46101107112101-17120101";
  #else
  string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
  string License = "57-30101111-11-46101107112101-17120101-64-1711411";
  #endif
#endif
