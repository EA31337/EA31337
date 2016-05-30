//+------------------------------------------------------------------+
//|                                                      ea-conf.mqh |
//|                            Copyright 2016, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| EA global configuration for Lite
//+------------------------------------------------------------------+

#ifdef __backtest__
#define ea_name    "EA31337 Lite (Backtest)"
#else
#define ea_name    "EA31337 Lite"
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
  string License = "51-30101111-11-46101107112101-17120101-64-1";
  #else
  string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
  string License = "62-30101111-11-46101107112101-17120101-64-171141111101";
  #endif
#endif
