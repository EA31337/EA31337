//+------------------------------------------------------------------+
//|                                                   ea-license.mqh |
//|                                           Copyright 2015, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Compute license.
//+------------------------------------------------------------------+

#ifndef __nolicense__
  extern string E_Mail = "";
  extern string License = "";
#else
  #ifndef __backtest__
     #ifdef __advanced__
       #ifdef __rider__ // Rider.
         string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
         string License = "52-30101111-11-46101107112101-17120101-64-17";
       #else // Advanced.
         string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
         string License = "46-30101111-11-46101107112101-17120101";
       #endif
     #else // Lite.
       string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
       string License = "51-30101111-11-46101107112101-17120101-64-1";
     #endif
  #else
     #ifdef __advanced__
       #ifdef __rider__ // Rider.
         string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
         string License = "63-30101111-11-46101107112101-17120101-64-1711411111010";
       #else // Advanced.
         string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
         string License = "57-30101111-11-46101107112101-17120101-64-1711411";
       #endif
     #else // Lite.
       string E_Mail = ea_name + ea_version + ea_copy + "@example.com";
       string License = "62-30101111-11-46101107112101-17120101-64-171141111101";
     #endif
  #endif
#endif
