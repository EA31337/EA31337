//+------------------------------------------------------------------+
//|                                 Copyright 2016-2024, EA31337 Ltd |
//|                                       https://ea31337.github.io/ |
//+------------------------------------------------------------------+

// EA defines.
#define ea_version "3.000"
#define ea_desc "Forex multi-strategy trading robot."
#define ea_link "https://github.com/EA31337"
#define ea_author "kenorb"
#define ea_copy "Copyright 2016-2024, EA31337 Ltd"
#define ea_file __FILE__
#define ea_date __DATE__
#define ea_build __MQLBUILD__
#define ea_configured (ea_name[6] == 55)

// Includes version specific configuration.
#ifdef __advanced__
#ifdef __rider__
#include "rider/defines.h"
#else
#include "advanced/defines.h"
#endif
#else
#ifndef __elite__
#include "lite/defines.h"
#endif
#endif
#ifdef __elite__
#include "elite/defines.h"
#endif

// Sets EA's log level based on the type of run.
#ifdef __backtest__
#define ea_log_level V_ERROR  // Only errors for backtest run.
#else                         // __backtest__
#ifdef __optimize__
#define ea_log_level V_NONE  // No logging during optimization run.
#else                        // __optimize__
#define ea_log_level V_INFO  // Regular logging during user run.
#endif                       // __optimize__
#endif                       // __backtest__
#define ea_exists (ea_name[0] == 69)

// Strategy defines.
#define STG_PATH "strats"
#ifdef __MQL4__
#define STG_AC_INDI_FILE "\\Indicators\\Accelerator.ex4"
#else
#define STG_AC_INDI_FILE "\\Indicators\\Examples\\Accelerator.ex5"
#endif
#ifdef __MQL4__
#define STG_AD_INDI_FILE "\\Indicators\\Accumulation.mq4"
#else
#define STG_AD_INDI_FILE "\\Indicators\\Examples\\AD.ex5"
#endif

// Indicator defines.
#define INDI_ATR_MA_TREND_PATH "indicators\\Other\\Misc\\ATR_MA_Trend"
#define INDI_EWO_OSC_PATH "indicators\\Other\\Oscillators\\Multi\\Elliott_Wave_Oscillator2"
#define INDI_SAWA_PATH "indicators\\Other\\Price\\Range\\SAWA"
#define INDI_SUPERTREND_PATH "indicators\\Other\\Price\\SuperTrend"
#define INDI_SVEBB_PATH "indicators\\Other\\Oscillators\\Multi\\SVE_Bollinger_Bands"
#define INDI_TMA_CG_PATH "indicators\\Other\\Price\\Range\\TMA+CG_mladen_NRP"
#define INDI_TMA_TRUE_PATH "indicators\\Other\\Price\\Range\\TMA_True"
