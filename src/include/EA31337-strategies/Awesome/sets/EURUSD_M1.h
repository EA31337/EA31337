//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Awesome_EURUSD_M1_Params : Stg_Awesome_Params {
  Stg_Awesome_EURUSD_M1_Params() {
    Awesome_Shift = 0;
    Awesome_SignalOpenMethod = 0;
    Awesome_SignalOpenLevel = 0;
    Awesome_SignalCloseMethod = 0;
    Awesome_SignalCloseLevel = 0;
    Awesome_PriceLimitMethod = 0;
    Awesome_PriceLimitLevel = 0;
    Awesome_MaxSpread = 0;
  }
} stg_ao_m1;
