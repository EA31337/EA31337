//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Fractals_EURUSD_M15_Params : Stg_Fractals_Params {
  Stg_Fractals_EURUSD_M15_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M15;
    Fractals_Shift = 0;
    Fractals_SignalOpenMethod = -63;
    Fractals_SignalOpenLevel = 36;
    Fractals_SignalCloseMethod = 1;
    Fractals_SignalCloseLevel = 36;
    Fractals_PriceLimitMethod = 0;
    Fractals_PriceLimitLevel = 0;
    Fractals_MaxSpread = 4;
  }
} stg_fractals_m15;
