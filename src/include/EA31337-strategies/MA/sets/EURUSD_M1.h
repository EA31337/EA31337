//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_MA_EURUSD_M1_Params : Stg_MA_Params {
  Stg_MA_EURUSD_M1_Params() {
    MA_Period = 32;
    MA_MA_Shift = 0;
    MA_Method = 1;
    MA_Applied_Price = 3;
    MA_Shift = 0;
    MA_SignalOpenMethod = 0;
    MA_SignalOpenLevel = 36;
    MA_SignalCloseMethod = 0;
    MA_SignalCloseLevel = 36;
    MA_PriceLimitMethod = 0;
    MA_PriceLimitLevel = 0;
    MA_MaxSpread = 2;
  }
} stg_ma_m1;
