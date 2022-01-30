//+------------------------------------------------------------------+
//|                                                      code-conf.h |
//|                                 Copyright 2016-2022, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| Predefined code configurations.
//+------------------------------------------------------------------+

// Rider mode implies Advanced.
#ifdef __rider__
#define __advanced__
#endif

#ifdef __limited__
#define __noboost__   // Disable boosting for limited mode.
#define __nofactor__  // No booting factor for daily, weekly and monthly strategies.
#define __trend__     // Trade with trend.
//#define __noactions__ // Disable actions for limited mode.
#endif

// Testing mode (for troubleshooting).
#ifdef __testing__     // Mode for testing components.
#define __disabled__   // Disable all strategies by default.
#define __noactions__  // Disable conditioned actions by default.
#define __noboost__    // Disable boosting by default.
#define __nospreads__  // Disable spread limits.
#define __nodebug__    // Disable debug messages by default.
#endif

// Optimization mode.
#ifdef __optimize__
#define __input__    // Enable param inputs.
#undef __backtest__  // Disable backtesting mode.
#undef __debug__     // Disable debug messages.
#undef __disabled__  // Always shows inputs.
#undef __trace__     // Disable trace messages.
#endif

// Backtest mode.
#ifdef __backtest__
#endif

// Property mode.
#ifndef __property__
#ifdef __MQL4__
#define __property__  // Always load properties for MQL4.
#else
#ifdef __cli__
#define __property__  // Load properties when compiling in CLI due to MQL5 bug.
#endif
#endif
#endif

// Release mode.
#ifdef _RELEASE
// Macro is defined when compiling in release mode.
// @see: https://www.mql5.com/en/docs/basis/preprosessor/conditional_compilation
#ifndef __release__
#define __release__
#endif
#endif

#ifdef __release__
#undef __disabled__      // Enable all strategies by default.
#undef __backtest__      // Disable backtesting mode.
#undef __optimize__      // Disable optimization mode.
#undef __noboost__       // Enable boosting by default.
#undef __nospreads__     // Enable spread limitation by default.
#undef __limited__       // Disable safe mode by default.
#undef __experimental__  // Disable experimental features.
#undef __debug__         // Disable debug messages.
#undef __trace__         // Disable trace messages.
#endif

#define ea_auth (ea_author[5] == 98)
