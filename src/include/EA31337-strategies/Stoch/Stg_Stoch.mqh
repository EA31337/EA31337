//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Stochastic strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Stochastic.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __Stochastic_Parameters__ = "-- Settings for the Stochastic Oscillator --"; // >>> STOCHASTIC <<<
uint Stochastic_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
uint Stochastic_KPeriod = 5; // K line period
uint Stochastic_DPeriod = 5; // D line period
uint Stochastic_Slowing = 5; // Slowing
ENUM_MA_METHOD Stochastic_MA_Method = MODE_SMA; // Moving Average method
ENUM_STO_PRICE Stochastic_Price_Field = 0; // Price (0 - Low/High or 1 - Close/Close)
uint Stochastic_Shift = 0; // Shift (relative to the current bar)
ENUM_TRAIL_TYPE Stochastic_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Stochastic_TrailingProfitMethod = 1; // Trail profit method
double Stochastic_SignalLevel = 0.00000000; // Signal level
int Stochastic1_SignalMethod = 0; // Signal method for M1 (0-
int Stochastic5_SignalMethod = 0; // Signal method for M5 (0-
int Stochastic15_SignalMethod = 0; // Signal method for M15 (0-
int Stochastic30_SignalMethod = 0; // Signal method for M30 (0-
int Stochastic1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Stochastic1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Stochastic1_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M1
int Stochastic5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Stochastic5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Stochastic5_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M5
int Stochastic15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Stochastic15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Stochastic15_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M15
int Stochastic30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Stochastic30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Stochastic30_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M30
double Stochastic1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Stochastic5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Stochastic15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Stochastic30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Stoch : public Strategy {

  public:

  void Stg_Stoch(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Stoch *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams stoch_iparams(10, INDI_STOCHASTIC);
    Stoch_Params stoch1_iparams(Stochastic_KPeriod, Stochastic_DPeriod, Stochastic_Slowing, Stochastic_MA_Method, Stochastic_Price_Field);
    StgParams stoch1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Stochastic(stoch1_iparams, stoch_iparams, cparams1), NULL, NULL);
    stoch1_sparams.SetSignals(Stochastic1_SignalMethod, Stochastic1_OpenCondition1, Stochastic1_OpenCondition2, Stochastic1_CloseCondition, NULL, Stochastic_SignalLevel, NULL);
    stoch1_sparams.SetStops(Stochastic_TrailingProfitMethod, Stochastic_TrailingStopMethod);
    stoch1_sparams.SetMaxSpread(Stochastic1_MaxSpread);
    stoch1_sparams.SetId(STOCHASTIC1);
    return (new Stg_Stoch(stoch1_sparams, "Stochastic1"));
  }
  static Stg_Stoch *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams stoch_iparams(10, INDI_STOCHASTIC);
    Stoch_Params stoch5_iparams(Stochastic_KPeriod, Stochastic_DPeriod, Stochastic_Slowing, Stochastic_MA_Method, Stochastic_Price_Field);
    StgParams stoch5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Stochastic(stoch5_iparams, stoch_iparams, cparams5), NULL, NULL);
    stoch5_sparams.SetSignals(Stochastic5_SignalMethod, Stochastic5_OpenCondition1, Stochastic5_OpenCondition2, Stochastic5_CloseCondition, NULL, Stochastic_SignalLevel, NULL);
    stoch5_sparams.SetStops(Stochastic_TrailingProfitMethod, Stochastic_TrailingStopMethod);
    stoch5_sparams.SetMaxSpread(Stochastic5_MaxSpread);
    stoch5_sparams.SetId(STOCHASTIC5);
    return (new Stg_Stoch(stoch5_sparams, "Stochastic5"));
  }
  static Stg_Stoch *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams stoch_iparams(10, INDI_STOCHASTIC);
    Stoch_Params stoch15_iparams(Stochastic_KPeriod, Stochastic_DPeriod, Stochastic_Slowing, Stochastic_MA_Method, Stochastic_Price_Field);
    StgParams stoch15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Stochastic(stoch15_iparams, stoch_iparams, cparams15), NULL, NULL);
    stoch15_sparams.SetSignals(Stochastic15_SignalMethod, Stochastic15_OpenCondition1, Stochastic15_OpenCondition2, Stochastic15_CloseCondition, NULL, Stochastic_SignalLevel, NULL);
    stoch15_sparams.SetStops(Stochastic_TrailingProfitMethod, Stochastic_TrailingStopMethod);
    stoch15_sparams.SetMaxSpread(Stochastic15_MaxSpread);
    stoch15_sparams.SetId(STOCHASTIC15);
    return (new Stg_Stoch(stoch15_sparams, "Stochastic15"));
  }
  static Stg_Stoch *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams stoch_iparams(10, INDI_STOCHASTIC);
    Stoch_Params stoch30_iparams(Stochastic_KPeriod, Stochastic_DPeriod, Stochastic_Slowing, Stochastic_MA_Method, Stochastic_Price_Field);
    StgParams stoch30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Stochastic(stoch30_iparams, stoch_iparams, cparams30), NULL, NULL);
    stoch30_sparams.SetSignals(Stochastic30_SignalMethod, Stochastic30_OpenCondition1, Stochastic30_OpenCondition2, Stochastic30_CloseCondition, NULL, Stochastic_SignalLevel, NULL);
    stoch30_sparams.SetStops(Stochastic_TrailingProfitMethod, Stochastic_TrailingStopMethod);
    stoch30_sparams.SetMaxSpread(Stochastic30_MaxSpread);
    stoch30_sparams.SetId(STOCHASTIC30);
    return (new Stg_Stoch(stoch30_sparams, "Stochastic30"));
  }
  static Stg_Stoch *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Stochastic indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double stoch_0 = ((Indi_Stochastic *) this.Data()).GetValue(0);
    double stoch_1 = ((Indi_Stochastic *) this.Data()).GetValue(1);
    double stoch_2 = ((Indi_Stochastic *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
        /* TODO:
              //   if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,LINE_MAIN,0)>iStochastic(NULL,0,5,3,3,MODE_SMA,0,LINE_SIGNAL,0)) return(0);
              // if(stoch4h<stoch4h2){ //Sell signal
              // if(stoch4h>stoch4h2){//Buy signal

              //28. Stochastic Oscillator (1)
              //Buy: main lline rises above 20 after it fell below this point
              //Sell: main line falls lower than 80 after it rose above this point
              if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,1)<20
              &&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,0)>=20)
              {f28=1;}
              if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,1)>80
              &&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,0)<=80)
              {f28=-1;}

              //29. Stochastic Oscillator (2)
              //Buy: main line goes above the signal line
              //Sell: signal line goes above the main line
              if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,1)<iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_SIGNAL,1)
              && iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,0)>=iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_SIGNAL,0))
              {f29=1;}
              if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,1)>iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_SIGNAL,1)
              && iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_MAIN,0)<=iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,LINE_SIGNAL,0))
              {f29=-1;}
        */
      case ORDER_TYPE_BUY:
        /*
          bool _result = Stochastic_0[LINE_LOWER] != 0.0 || Stochastic_1[LINE_LOWER] != 0.0 || Stochastic_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[CURR];
          if (METHOD(_signal_method, 1)) _result &= !Stochastic_On_Sell(tf);
          if (METHOD(_signal_method, 2)) _result &= Stochastic_On_Buy(fmin(period + 1, M30));
          if (METHOD(_signal_method, 3)) _result &= Stochastic_On_Buy(M30);
          if (METHOD(_signal_method, 4)) _result &= Stochastic_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 5)) _result &= !Stochastic_On_Sell(M30);
          */
      break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = Stochastic_0[LINE_UPPER] != 0.0 || Stochastic_1[LINE_UPPER] != 0.0 || Stochastic_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[CURR];
          if (METHOD(_signal_method, 1)) _result &= !Stochastic_On_Buy(tf);
          if (METHOD(_signal_method, 2)) _result &= Stochastic_On_Sell(fmin(period + 1, M30));
          if (METHOD(_signal_method, 3)) _result &= Stochastic_On_Sell(M30);
          if (METHOD(_signal_method, 4)) _result &= Stochastic_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 5)) _result &= !Stochastic_On_Buy(M30);
          */
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};

