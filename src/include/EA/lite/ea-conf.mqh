//+------------------------------------------------------------------+
//|                                                      ea-conf.mqh |
//|                       Copyright 2016-2017, 31337 Investments Ltd |
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
  string E_Mail = ea_name + ea_version + ea_copy + ea_file + "@ea31337.com";
  string License = "77-30101111-11-46-55-51-51-41-51-17101-6410";
  #else
  string E_Mail = ea_name + ea_version + ea_copy + ea_file + "@ea31337.com";
  string License = "77-30101111-11-46-55-51-51-41-51-17101-64104113101-461";
  #endif
#endif