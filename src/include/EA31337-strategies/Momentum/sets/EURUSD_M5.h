//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Momentum_EURUSD_M5_Params : Stg_Momentum_Params {
  Stg_Momentum_EURUSD_M5_Params() {
    Momentum_Period = 2;
    Momentum_Applied_Price = 3;
    Momentum_Shift = 0;
    Momentum_SignalOpenMethod = -61;
    Momentum_SignalOpenLevel = 36;
    Momentum_SignalCloseMethod = 1;
    Momentum_SignalCloseLevel = 36;
    Momentum_PriceLimitMethod = 0;
    Momentum_PriceLimitLevel = 0;
    Momentum_MaxSpread = 3;
  }
} stg_mom_m5;
