//+------------------------------------------------------------------+
//|                                                         define.h |
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
#define ea_configured (ea_name[6] == 55)

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
