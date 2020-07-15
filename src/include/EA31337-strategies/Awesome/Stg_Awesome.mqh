//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Awesome strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_AO.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __Awesome_Parameters__ = "-- Settings for the Awesome oscillator --"; // >>> AWESOME <<<
ENUM_TRAIL_TYPE Awesome_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Awesome_TrailingProfitMethod = 1; // Trail profit method
double Awesome_SignalLevel = 0.00000000; // Signal level
uint Awesome_Shift = 0; // Shift (relative to the current bar, 0 - default)
int Awesome1_SignalMethod = 0; // Signal method for M1 (0-31)
int Awesome5_SignalMethod = 0; // Signal method for M5 (0-31)
int Awesome15_SignalMethod = 0; // Signal method for M15 (0-31)
int Awesome30_SignalMethod = 0; // Signal method for M30 (0-31)
int Awesome1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Awesome1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Awesome1_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M1
int Awesome5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Awesome5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Awesome5_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M5
int Awesome15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Awesome15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Awesome15_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M15
int Awesome30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Awesome30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Awesome30_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M30
double Awesome1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Awesome5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Awesome15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Awesome30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Awesome : public Strategy {

  public:

  void Stg_Awesome(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Awesome *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams ao_iparams(10, INDI_AO);
    StgParams ao1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_AO(ao_iparams, cparams1), NULL, NULL);
    ao1_sparams.SetSignals(Awesome1_SignalMethod, Awesome1_OpenCondition1, Awesome1_OpenCondition2, Awesome1_CloseCondition, NULL, Awesome_SignalLevel, NULL);
    ao1_sparams.SetStops(Awesome_TrailingProfitMethod, Awesome_TrailingStopMethod);
    ao1_sparams.SetMaxSpread(Awesome1_MaxSpread);
    ao1_sparams.SetId(AWESOME1);
    return (new Stg_Awesome(ao1_sparams, "Awesome1"));
  }
  static Stg_Awesome *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams ao_iparams(10, INDI_AO);
    StgParams ao5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_AO(ao_iparams, cparams5), NULL, NULL);
    ao5_sparams.SetSignals(Awesome5_SignalMethod, Awesome5_OpenCondition1, Awesome5_OpenCondition2, Awesome5_CloseCondition, NULL, Awesome_SignalLevel, NULL);
    ao5_sparams.SetStops(Awesome_TrailingProfitMethod, Awesome_TrailingStopMethod);
    ao5_sparams.SetMaxSpread(Awesome5_MaxSpread);
    ao5_sparams.SetId(AWESOME5);
    return (new Stg_Awesome(ao5_sparams, "Awesome5"));
  }
  static Stg_Awesome *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams ao_iparams(10, INDI_AO);
    StgParams ao15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_AO(ao_iparams, cparams15), NULL, NULL);
    ao15_sparams.SetSignals(Awesome15_SignalMethod, Awesome15_OpenCondition1, Awesome15_OpenCondition2, Awesome15_CloseCondition, NULL, Awesome_SignalLevel, NULL);
    ao15_sparams.SetStops(Awesome_TrailingProfitMethod, Awesome_TrailingStopMethod);
    ao15_sparams.SetMaxSpread(Awesome15_MaxSpread);
    ao15_sparams.SetId(AWESOME15);
    return (new Stg_Awesome(ao15_sparams, "Awesome15"));
  }
  static Stg_Awesome *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams ao_iparams(10, INDI_AO);
    StgParams ao30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_AO(ao_iparams, cparams30), NULL, NULL);
    ao30_sparams.SetSignals(Awesome30_SignalMethod, Awesome30_OpenCondition1, Awesome30_OpenCondition2, Awesome30_CloseCondition, NULL, Awesome_SignalLevel, NULL);
    ao30_sparams.SetStops(Awesome_TrailingProfitMethod, Awesome_TrailingStopMethod);
    ao30_sparams.SetMaxSpread(Awesome30_MaxSpread);
    ao30_sparams.SetId(AWESOME30);
    return (new Stg_Awesome(ao30_sparams, "Awesome30"));
  }
  static Stg_Awesome *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Awesome indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double ao_0 = ((Indi_AO *) this.Data()).GetValue(0);
    double ao_1 = ((Indi_AO *) this.Data()).GetValue(1);
    double ao_2 = ((Indi_AO *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      /*
        //7. Awesome Oscillator
        //Buy: 1. Signal "saucer" (3 positive columns, medium column is smaller than 2 others); 2. Changing from negative values to positive.
        //Sell: 1. Signal "saucer" (3 negative columns, medium column is larger than 2 others); 2. Changing from positive values to negative.
        if ((iAO(NULL,piao,2)>0&&iAO(NULL,piao,1)>0&&iAO(NULL,piao,0)>0&&iAO(NULL,piao,1)<iAO(NULL,piao,2)&&iAO(NULL,piao,1)<iAO(NULL,piao,0))||(iAO(NULL,piao,1)<0&&iAO(NULL,piao,0)>0))
        {f7=1;}
        if ((iAO(NULL,piao,2)<0&&iAO(NULL,piao,1)<0&&iAO(NULL,piao,0)<0&&iAO(NULL,piao,1)>iAO(NULL,piao,2)&&iAO(NULL,piao,1)>iAO(NULL,piao,0))||(iAO(NULL,piao,1)>0&&iAO(NULL,piao,0)<0))
        {f7=-1;}
      */
      case ORDER_TYPE_BUY:
        /*
          bool _result = Awesome_0[LINE_LOWER] != 0.0 || Awesome_1[LINE_LOWER] != 0.0 || Awesome_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[CURR];
          if (METHOD(_signal_method, 1)) _result &= !Awesome_On_Sell(tf);
          if (METHOD(_signal_method, 2)) _result &= Awesome_On_Buy(fmin(period + 1, M30));
          if (METHOD(_signal_method, 3)) _result &= Awesome_On_Buy(M30);
          if (METHOD(_signal_method, 4)) _result &= Awesome_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 5)) _result &= !Awesome_On_Sell(M30);
          */
      break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = Awesome_0[LINE_UPPER] != 0.0 || Awesome_1[LINE_UPPER] != 0.0 || Awesome_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[CURR];
          if (METHOD(_signal_method, 1)) _result &= !Awesome_On_Buy(tf);
          if (METHOD(_signal_method, 2)) _result &= Awesome_On_Sell(fmin(period + 1, M30));
          if (METHOD(_signal_method, 3)) _result &= Awesome_On_Sell(M30);
          if (METHOD(_signal_method, 4)) _result &= Awesome_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 5)) _result &= !Awesome_On_Buy(M30);
          */
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
