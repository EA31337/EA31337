//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_OBV_EURUSD_M15_Params : Stg_OBV_Params {
  Stg_OBV_EURUSD_M15_Params() {
    OBV_Applied_Price = 3;
    OBV_Shift = 0;
    OBV_SignalOpenMethod = -63;
    OBV_SignalOpenLevel = 36;
    OBV_SignalCloseMethod = 1;
    OBV_SignalCloseLevel = 36;
    OBV_PriceLimitMethod = 0;
    OBV_PriceLimitLevel = 0;
    OBV_MaxSpread = 4;
  }
} stg_obv_m15;
