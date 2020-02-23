//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_OBV_EURUSD_M1_Params : Stg_OBV_Params {
  Stg_OBV_EURUSD_M1_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M1;
    OBV_Applied_Price = 3;
    OBV_Shift = 0;
    OBV_SignalOpenMethod = 0;
    OBV_SignalOpenLevel = 36;
    OBV_SignalCloseMethod = 0;
    OBV_SignalCloseLevel = 36;
    OBV_PriceLimitMethod = 0;
    OBV_PriceLimitLevel = 0;
    OBV_MaxSpread = 2;
  }
} stg_obv_m1;
