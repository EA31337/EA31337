//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Ichimoku_EURUSD_M1_Params : Stg_Ichimoku_Params {
  Stg_Ichimoku_EURUSD_M1_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M1;
    Ichimoku_Period_Tenkan_Sen = 9;
    Ichimoku_Period_Kijun_Sen = 26;
    Ichimoku_Period_Senkou_Span_B = 52;
    Ichimoku_Shift = 0;
    Ichimoku_SignalOpenMethod = 0;
    Ichimoku_SignalOpenLevel = 36;
    Ichimoku_SignalCloseMethod = 0;
    Ichimoku_SignalCloseLevel = 36;
    Ichimoku_PriceLimitMethod = 0;
    Ichimoku_PriceLimitLevel = 0;
    Ichimoku_MaxSpread = 2;
  }
};
