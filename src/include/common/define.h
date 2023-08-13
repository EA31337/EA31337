//+------------------------------------------------------------------+
//|                                                         define.h |
//|                                 Copyright 2016-2023, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// EA defines.
#define ea_version "2.013"
#define ea_desc "Forex multi-strategy trading robot."
#define ea_link "https://github.com/EA31337"
#define ea_author "kenorb"
#define ea_copy "Copyright 2016-2023, EA31337 Ltd"
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
#include "lite/defines.h"
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
