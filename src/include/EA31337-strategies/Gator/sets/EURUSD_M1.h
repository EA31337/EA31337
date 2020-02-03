//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Gator_EURUSD_M1_Params : Stg_Gator_Params {
  Stg_Gator_EURUSD_M1_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M1;
    Gator_Period_Jaw = 6;
    Gator_Period_Teeth = 10;
    Gator_Period_Lips = 8;
    Gator_Shift_Jaw = 5;
    Gator_Shift_Teeth = 7;
    Gator_Shift_Lips = 5;
    Gator_MA_Method = 2;
    Gator_Applied_Price = 3;
    Gator_Shift = 0;
    Gator_SignalOpenMethod = 0;
    Gator_SignalOpenLevel = 36;
    Gator_SignalCloseMethod = 0;
    Gator_SignalCloseLevel = 36;
    Gator_PriceLimitMethod = 0;
    Gator_PriceLimitLevel = 0;
    Gator_MaxSpread = 2;
  }
};
