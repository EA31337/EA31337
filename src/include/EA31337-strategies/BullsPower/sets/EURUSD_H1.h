//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_BullsPower_EURUSD_H1_Params : Stg_BullsPower_Params {
  Stg_BullsPower_EURUSD_H1_Params() {
    BullsPower_Period = 13;
    BullsPower_Applied_Price = 1;
    BullsPower_Shift = 0;
    BullsPower_SignalOpenMethod = 0;
    BullsPower_SignalOpenLevel = 0;
    BullsPower_SignalCloseMethod = 0;
    BullsPower_SignalCloseLevel = 0;
    BullsPower_PriceLimitMethod = 0;
    BullsPower_PriceLimitLevel = 0;
    BullsPower_MaxSpread = 0;
  }
} stg_bulls_h1;
