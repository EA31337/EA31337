//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ATR strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_ATR.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __ATR_Parameters__ = "-- Settings for the Average True Range indicator --"; // >>> ATR <<<
uint ATR_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
ENUM_TRAIL_TYPE ATR_TrailingStopMethod = 7; // Trail stop method
ENUM_TRAIL_TYPE ATR_TrailingProfitMethod = 22; // Trail profit method
int ATR_Period_M1 = 14; // Period for M1
int ATR_Period_M5 = 14; // Period for M5
int ATR_Period_M15 = 14; // Period for M15
int ATR_Period_M30 = 14; // Period for M30
double ATR_SignalLevel = 0.00000000; // Signal level
uint ATR_Shift = 0; // Shift (relative to the current bar, 0 - default)
int ATR1_SignalMethod = 0; // Signal method for M1 (0-31)
int ATR5_SignalMethod = 0; // Signal method for M5 (0-31)
int ATR15_SignalMethod = 0; // Signal method for M15 (0-31)
int ATR30_SignalMethod = 0; // Signal method for M30 (0-31)
int ATR1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int ATR1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ATR1_CloseCondition = 1; // Close condition for M1
int ATR5_OpenCondition1 = 971; // Open condition 1 for M5 (0-1023)
int ATR5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ATR5_CloseCondition = 1; // Close condition for M5
int ATR15_OpenCondition1 = 292; // Open condition 1 for M15 (0-)
int ATR15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ATR15_CloseCondition = 1; // Close condition for M15
int ATR30_OpenCondition1 = 292; // Open condition 1 for M30 (0-)
int ATR30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ATR30_CloseCondition = 1; // Close condition for M30
double ATR1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double ATR5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double ATR15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double ATR30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_ATR : public Strategy {

  public:

  void Stg_ATR(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_ATR *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams atr_iparams(10, INDI_ATR);
    ATR_Params atr1_iparams(ATR_Period_M1);
    StgParams atr1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_ATR(atr1_iparams, atr_iparams, cparams1), NULL, NULL);
    atr1_sparams.SetSignals(ATR1_SignalMethod, ATR1_OpenCondition1, ATR1_OpenCondition2, ATR1_CloseCondition, NULL, ATR_SignalLevel, NULL);
    atr1_sparams.SetStops(ATR_TrailingProfitMethod, ATR_TrailingStopMethod);
    atr1_sparams.SetMaxSpread(ATR1_MaxSpread);
    atr1_sparams.SetId(ATR1);
    return (new Stg_ATR(atr1_sparams, "ATR1"));
  }
  static Stg_ATR *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams atr_iparams(10, INDI_ATR);
    ATR_Params atr5_iparams(ATR_Period_M5);
    StgParams atr5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_ATR(atr5_iparams, atr_iparams, cparams5), NULL, NULL);
    atr5_sparams.SetSignals(ATR5_SignalMethod, ATR5_OpenCondition1, ATR5_OpenCondition2, ATR5_CloseCondition, NULL, ATR_SignalLevel, NULL);
    atr5_sparams.SetStops(ATR_TrailingProfitMethod, ATR_TrailingStopMethod);
    atr5_sparams.SetMaxSpread(ATR5_MaxSpread);
    atr5_sparams.SetId(ATR5);
    return (new Stg_ATR(atr5_sparams, "ATR5"));
  }
  static Stg_ATR *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams atr_iparams(10, INDI_ATR);
    ATR_Params atr15_iparams(ATR_Period_M15);
    StgParams atr15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_ATR(atr15_iparams, atr_iparams, cparams15), NULL, NULL);
    atr15_sparams.SetSignals(ATR15_SignalMethod, ATR15_OpenCondition1, ATR15_OpenCondition2, ATR15_CloseCondition, NULL, ATR_SignalLevel, NULL);
    atr15_sparams.SetStops(ATR_TrailingProfitMethod, ATR_TrailingStopMethod);
    atr15_sparams.SetMaxSpread(ATR15_MaxSpread);
    atr15_sparams.SetId(ATR15);
    return (new Stg_ATR(atr15_sparams, "ATR15"));
  }
  static Stg_ATR *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams atr_iparams(10, INDI_ATR);
    ATR_Params atr30_iparams(ATR_Period_M30);
    StgParams atr30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_ATR(atr30_iparams, atr_iparams, cparams30), NULL, NULL);
    atr30_sparams.SetSignals(ATR30_SignalMethod, ATR30_OpenCondition1, ATR30_OpenCondition2, ATR30_CloseCondition, NULL, ATR_SignalLevel, NULL);
    atr30_sparams.SetStops(ATR_TrailingProfitMethod, ATR_TrailingStopMethod);
    atr30_sparams.SetMaxSpread(ATR30_MaxSpread);
    atr30_sparams.SetId(ATR30);
    return (new Stg_ATR(atr30_sparams, "ATR30"));
  }
  static Stg_ATR *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if ATR indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double atr_0 = ((Indi_ATR *) this.Data()).GetValue(0);
    double atr_1 = ((Indi_ATR *) this.Data()).GetValue(1);
    double atr_2 = ((Indi_ATR *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      //   if(iATR(NULL,0,12,0)>iATR(NULL,0,20,0)) return(0);
      /*
        //6. Average True Range - ATR
        //Doesn't give independent signals. Is used to define volatility (trend strength).
        //principle: trend must be strengthened. Together with that ATR grows.
        //Because of the chart form it is inconvenient to analyze rise/fall. Only exceeding of threshold value is checked.
        //Flag is 1 when ATR is above threshold value (i.e. there is a trend), 0 - when ATR is below threshold value, -1 - never.
        if (iATR(NULL,piatr,piatru,0)>=minatr)
        {f6=1;}
      */
      case ORDER_TYPE_BUY:
        //bool _result = atr_0;
        /*
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[CURR];
          */
      break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = ATR_0[LINE_UPPER] != 0.0 || ATR_1[LINE_UPPER] != 0.0 || ATR_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[CURR];
        */
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
