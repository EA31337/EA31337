//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_AD_EURUSD_M15_Params : Stg_AD_Params {
  Stg_AD_EURUSD_M15_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M15;
    AD_Shift = 0;
    AD_SignalOpenMethod = 0;
    AD_SignalOpenLevel = 0;
    AD_SignalCloseMethod = 0;
    AD_SignalCloseLevel = 0;
    AD_PriceLimitMethod = 0;
    AD_PriceLimitLevel = 0;
    AD_MaxSpread = 0;
  }
} stg_ad_m15;
