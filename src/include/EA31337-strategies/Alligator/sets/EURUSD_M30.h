//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Alligator_EURUSD_M30_Params : Stg_Alligator_Params {
  Stg_Alligator_EURUSD_M30_Params() {
    Alligator_Period_Jaw = 16;
    Alligator_Period_Teeth = 8;
    Alligator_Period_Lips = 6;
    Alligator_Shift_Jaw = 0;
    Alligator_Shift_Teeth = 0;
    Alligator_Shift_Lips = 0;
    Alligator_MA_Method = 2;
    Alligator_Applied_Price = 4;
    Alligator_Shift = 2;
    Alligator_SignalOpenMethod = 0;
    Alligator_SignalOpenLevel = 0.1;
    Alligator_SignalCloseMethod = 0;
    Alligator_SignalCloseLevel = 0.1;
    Alligator_PriceLimitMethod = 0;
    Alligator_PriceLimitLevel = 0;
    Alligator_MaxSpread = 5;
  }
} stg_alli_m30;
