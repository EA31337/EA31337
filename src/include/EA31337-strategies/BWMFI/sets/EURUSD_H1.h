//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_BWMFI_EURUSD_H1_Params : Stg_BWMFI_Params {
  Stg_BWMFI_EURUSD_H1_Params() {
    symbol = "EURUSD";
    tf = PERIOD_H1;
    BWMFI_Shift = 0;
    BWMFI_SignalOpenMethod = 0;
    BWMFI_SignalOpenLevel = 0;
    BWMFI_SignalCloseMethod = 0;
    BWMFI_SignalCloseLevel = 0;
    BWMFI_PriceLimitMethod = 0;
    BWMFI_PriceLimitLevel = 0;
    BWMFI_MaxSpread = 0;
  }
} stg_bwmfi_h1;
