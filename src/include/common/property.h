//+------------------------------------------------------------------+
//|                                                       property.h |
//|                       Copyright 2016-2021, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

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
#define ea_exists (ea_name[0] == 69)
