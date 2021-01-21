//+------------------------------------------------------------------+
//|                                                   properties.mqh |
//|                       Copyright 2016-2021, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// EA defines.
#define ea_version "2.000"
#define ea_desc "Multi-strategy trading robot."
#define ea_link "https://github.com/EA31337"
#define ea_author "kenorb"
#define ea_copy "Copyright 2016-2021, 31337 Investments Ltd"
#define ea_file __FILE__
#define ea_date __DATE__
#define ea_build __MQLBUILD__

// Includes version specific configuration.
#ifdef __advanced__
#ifdef __rider__
#include "rider/defines.h"
#else
#include "advanced/defines.h"
#endif
#else
#include "lite/defines.h"
#endif

// EA properties.
#ifdef __MQL4__
#property description ea_name
#property description ea_desc
#endif
#property version ea_version
#property link ea_link
#property copyright ea_copy
#property icon "resources\\favicon.ico"
