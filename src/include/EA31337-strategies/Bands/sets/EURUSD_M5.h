//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Bands_EURUSD_M5_Params : Stg_Bands_Params {
  Stg_Bands_EURUSD_M5_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M5;
    Bands_Period = 2;
    Bands_Deviation = 0.3;
    Bands_HShift = 0;
    Bands_Applied_Price = PRICE_CLOSE;
    Bands_Shift = 0;
    Bands_SignalOpenMethod = 0;
    Bands_SignalOpenLevel = 18;
    Bands_SignalCloseMethod = 0;
    Bands_SignalCloseLevel = 18;
    Bands_PriceLimitMethod = 0;
    Bands_PriceLimitLevel = 0;
    Bands_MaxSpread = 3;
  }
};
