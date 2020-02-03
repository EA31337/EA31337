//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_AC_EURUSD_M15_Params : Stg_AC_Params {
  Stg_AC_EURUSD_M15_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M15;
    AC_Shift = 0;
    AC_SignalOpenMethod = 0;
    AC_SignalOpenLevel = 0;
    AC_SignalCloseMethod = 0;
    AC_SignalCloseLevel = 0;
    AC_PriceLimitMethod = 0;
    AC_PriceLimitLevel = 0;
    AC_MaxSpread = 0;
  }
};
