//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_DeMarker_EURUSD_M30_Params : Stg_DeMarker_Params {
  Stg_DeMarker_EURUSD_M30_Params() {
    DeMarker_Period = 2;
    DeMarker_Shift = 0;
    DeMarker_SignalOpenMethod = 0;
    DeMarker_SignalOpenLevel = 36;
    DeMarker_SignalCloseMethod = 1;
    DeMarker_SignalCloseLevel = 36;
    DeMarker_PriceLimitMethod = 0;
    DeMarker_PriceLimitLevel = 0;
    DeMarker_MaxSpread = 5;
  }
} stg_dm_m30;
