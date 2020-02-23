//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_RSI_EURUSD_H1_Params : Stg_RSI_Params {
  Stg_RSI_EURUSD_H1_Params() {
    symbol = "EURUSD";
    tf = PERIOD_H1;
    RSI_Period = 2;
    RSI_Applied_Price = 3;
    RSI_Shift = 0;
    RSI_SignalOpenMethod = 0;
    RSI_SignalOpenLevel = 36;
    RSI_SignalCloseMethod = 0;
    RSI_SignalCloseLevel = 36;
    RSI_PriceLimitMethod = 0;
    RSI_PriceLimitLevel = 0;
    RSI_MaxSpread = 6;
  }
} stg_rsi_h1;
