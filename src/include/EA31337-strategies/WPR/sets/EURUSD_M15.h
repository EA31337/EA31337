//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_WPR_EURUSD_M15_Params : Stg_WPR_Params {
  Stg_WPR_EURUSD_M15_Params() {
    WPR_Period = 2;
    WPR_Shift = 0;
    WPR_SignalOpenMethod = -63;
    WPR_SignalOpenLevel = 36;
    WPR_SignalCloseMethod = 1;
    WPR_SignalCloseLevel = 36;
    WPR_PriceLimitMethod = 0;
    WPR_PriceLimitLevel = 0;
    WPR_MaxSpread = 4;
  }
} stg_wpr_m15;
