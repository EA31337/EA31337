//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_RVI_EURUSD_H4_Params : Stg_RVI_Params {
  Stg_RVI_EURUSD_H4_Params() {
    RVI_Period = 2;
    RVI_Mode = 0;
    RVI_Shift = 0;
    RVI_SignalOpenMethod = 0;
    RVI_SignalOpenLevel = 36;
    RVI_SignalCloseMethod = 1;
    RVI_SignalCloseLevel = 36;
    RVI_PriceLimitMethod = 0;
    RVI_PriceLimitLevel = 0;
    RVI_MaxSpread = 10;
  }
} stg_rvi_h4;
