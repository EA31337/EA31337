//+------------------------------------------------------------------+
//|                                                ea-properties.mqh |
//|                                           Copyright 2015, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| EA properties.
//+------------------------------------------------------------------+

#define ea_desc    "Multi-strategy advanced trading robot."
#define ea_version "1.067"
#define ea_build   __DATETIME__ // FIXME: It's empty
#define ea_link    "https://github.com/EA31337"
#define ea_author  "kenorb"
#define ea_copy    "Copyright 2015, kenorb"

// Get the correct name of EA.
#ifndef __backtest__
   #ifdef __advanced__
     #ifdef __rider__
       #define ea_name    "EA31337 Rider"
     #else
       #define ea_name    "EA31337"
     #endif
   #else
     #define ea_name    "EA31337 Lite"
   #endif
#else
   #ifdef __advanced__
     #ifdef __rider__
       #define ea_name    "EA31337 Rider (Backtest)"
     #else
       #define ea_name    "EA31337 (Backtest)"
     #endif
   #else
     #define ea_name    "EA31337 Lite (Backtest)"
   #endif
#endif

#property description ea_name
#property description ea_desc
#property copyright   ea_author
#property link        ea_link
#property version     ea_version
#property copyright   ea_copy
