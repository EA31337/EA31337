//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_ATR_EURUSD_H4_Params : Stg_ATR_Params {
  Stg_ATR_EURUSD_H4_Params() {
    ATR_Period = 14;
    ATR_Applied_Price = 1;
    ATR_Shift = 0;
    ATR_SignalOpenMethod = 0;
    ATR_SignalOpenLevel = 0;
    ATR_SignalCloseMethod = 0;
    ATR_SignalCloseLevel = 0;
    ATR_PriceLimitMethod = 0;
    ATR_PriceLimitLevel = 0;
    ATR_MaxSpread = 0;
  }
} stg_atr_h4;
