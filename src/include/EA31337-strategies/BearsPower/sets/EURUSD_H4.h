//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_BearsPower_EURUSD_H4_Params : Stg_BearsPower_Params {
  Stg_BearsPower_EURUSD_H4_Params() {
    symbol = "EURUSD";
    tf = PERIOD_H4;
    BearsPower_Period = 13;
    BearsPower_Applied_Price = 1;
    BearsPower_Shift = 0;
    BearsPower_SignalOpenMethod = 0;
    BearsPower_SignalOpenLevel = 0;
    BearsPower_SignalCloseMethod = 0;
    BearsPower_SignalCloseLevel = 0;
    BearsPower_PriceLimitMethod = 0;
    BearsPower_PriceLimitLevel = 0;
    BearsPower_MaxSpread = 0;
  }
} stg_bears_h4;
