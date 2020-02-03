//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines strategy's parameter values for the given pair symbol and timeframe.
struct Stg_Stochastic_EURUSD_M15_Params : Stg_Stochastic_Params {
  Stg_Stochastic_EURUSD_M15_Params() {
    symbol = "EURUSD";
    tf = PERIOD_M15;
    Stochastic_KPeriod = 5;
    Stochastic_DPeriod = 5;
    Stochastic_Slowing = 5;
    Stochastic_MA_Method = 0;
    Stochastic_Price_Field = 0;
    Stochastic_Shift = 0;
    Stochastic_SignalOpenMethod = -63;
    Stochastic_SignalOpenLevel = 36;
    Stochastic_SignalCloseMethod = 1;
    Stochastic_SignalCloseLevel = 36;
    Stochastic_PriceLimitMethod = 0;
    Stochastic_PriceLimitLevel = 0;
    Stochastic_MaxSpread = 4;
  }
};
