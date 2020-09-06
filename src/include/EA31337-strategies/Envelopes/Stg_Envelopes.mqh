//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Envelopes strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Envelopes.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --"; // >>> ENVELOPES <<<
INPUT int Envelopes_MA_Period_M1 = 2; // Period for M1
INPUT int Envelopes_MA_Period_M5 = 4; // Period for M5
INPUT int Envelopes_MA_Period_M15 = 10; // Period for M15
INPUT int Envelopes_MA_Period_M30 = 10; // Period for M30
INPUT double Envelopes_Deviation_M1 = 0.1; // Deviation for M1
INPUT double Envelopes_Deviation_M5 = 0.3; // Deviation for M5
INPUT double Envelopes_Deviation_M15 = 0.4; // Deviation for M15
INPUT double Envelopes_Deviation_M30 = 0.5; // Deviation for M30
INPUT ENUM_MA_METHOD Envelopes_MA_Method = 1; // MA Method
INPUT int Envelopes_MA_Shift = 0; // MA Shift
INPUT ENUM_APPLIED_PRICE Envelopes_Applied_Price = (ENUM_APPLIED_PRICE) 0; // Applied Price
INPUT int Envelopes_Shift = 2; // Shift
INPUT ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = 2; // Trail stop method
INPUT ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = -3; // Trail profit method
/* @todo INPUT */ int Envelopes_SignalLevel = 0; // Signal level
INPUT int Envelopes1_SignalMethod = -13; // Signal method for M1 (-127-127)
INPUT int Envelopes5_SignalMethod = 34; // Signal method for M5 (-127-127)
INPUT int Envelopes15_SignalMethod = -127; // Signal method for M15 (-127-127)
INPUT int Envelopes30_SignalMethod = 36; // Signal method for M30 (-127-127)
INPUT int Envelopes1_OpenCondition1 = 1; // Open condition 1 for M1 (0-1023)
INPUT int Envelopes1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
INPUT ENUM_MARKET_EVENT Envelopes1_CloseCondition = 13; // Close condition for M1
//
INPUT int Envelopes5_OpenCondition1 = 1; // Open condition 1 for M5 (0-1023)
INPUT int Envelopes5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
INPUT ENUM_MARKET_EVENT Envelopes5_CloseCondition = 7; // Close condition for M5
//
INPUT int Envelopes15_OpenCondition1 = 292; // Open condition 1 for M15 (0-1023)
INPUT int Envelopes15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
INPUT ENUM_MARKET_EVENT Envelopes15_CloseCondition = 29; // Close condition for M15
//
INPUT int Envelopes30_OpenCondition1 = 292; // Open condition 1 for M30 (0-1023)
INPUT int Envelopes30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
INPUT ENUM_MARKET_EVENT Envelopes30_CloseCondition = 29; // Close condition for M30
//
INPUT double Envelopes1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double Envelopes5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double Envelopes15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double Envelopes30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Envelopes : public Strategy {

  public:

  void Stg_Envelopes(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Envelopes *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams env_iparams(10, INDI_ENVELOPES);
    Envelopes_Params env1_iparams(Envelopes_MA_Period_M1, Envelopes_MA_Shift, Envelopes_MA_Method, Envelopes_Applied_Price, Envelopes_Deviation_M1);
    StgParams env1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Envelopes(env1_iparams, env_iparams, cparams1), NULL, NULL);
    env1_sparams.SetSignals(Envelopes1_SignalMethod, Envelopes1_OpenCondition1, Envelopes1_OpenCondition2, Envelopes1_CloseCondition, NULL, Envelopes_SignalLevel, NULL);
    env1_sparams.SetStops(Envelopes_TrailingProfitMethod, Envelopes_TrailingStopMethod);
    env1_sparams.SetMaxSpread(Envelopes1_MaxSpread);
    env1_sparams.SetId(ENVELOPES1);
    return (new Stg_Envelopes(env1_sparams, "Envelopes1"));
  }
  static Stg_Envelopes *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams env_iparams(10, INDI_ENVELOPES);
    Envelopes_Params env5_iparams(Envelopes_MA_Period_M5, Envelopes_MA_Shift, Envelopes_MA_Method, Envelopes_Applied_Price, Envelopes_Deviation_M5);
    StgParams env5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Envelopes(env5_iparams, env_iparams, cparams5), NULL, NULL);
    env5_sparams.SetSignals(Envelopes5_SignalMethod, Envelopes5_OpenCondition1, Envelopes5_OpenCondition2, Envelopes5_CloseCondition, NULL, Envelopes_SignalLevel, NULL);
    env5_sparams.SetStops(Envelopes_TrailingProfitMethod, Envelopes_TrailingStopMethod);
    env5_sparams.SetMaxSpread(Envelopes5_MaxSpread);
    env5_sparams.SetId(ENVELOPES5);
    return (new Stg_Envelopes(env5_sparams, "Envelopes5"));
  }
  static Stg_Envelopes *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams env_iparams(10, INDI_ENVELOPES);
    Envelopes_Params env15_iparams(Envelopes_MA_Period_M15, Envelopes_MA_Shift, Envelopes_MA_Method, Envelopes_Applied_Price, Envelopes_Deviation_M15);
    StgParams env15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Envelopes(env15_iparams, env_iparams, cparams15), NULL, NULL);
    env15_sparams.SetSignals(Envelopes15_SignalMethod, Envelopes15_OpenCondition1, Envelopes15_OpenCondition2, Envelopes15_CloseCondition, NULL, Envelopes_SignalLevel, NULL);
    env15_sparams.SetStops(Envelopes_TrailingProfitMethod, Envelopes_TrailingStopMethod);
    env15_sparams.SetMaxSpread(Envelopes15_MaxSpread);
    env15_sparams.SetId(ENVELOPES15);
    return (new Stg_Envelopes(env15_sparams, "Envelopes15"));
  }
  static Stg_Envelopes *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams env_iparams(10, INDI_ENVELOPES);
    Envelopes_Params env30_iparams(Envelopes_MA_Period_M30, Envelopes_MA_Shift, Envelopes_MA_Method, Envelopes_Applied_Price, Envelopes_Deviation_M30);
    StgParams env30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Envelopes(env30_iparams, env_iparams, cparams30), NULL, NULL);
    env30_sparams.SetSignals(Envelopes30_SignalMethod, Envelopes30_OpenCondition1, Envelopes30_OpenCondition2, Envelopes30_CloseCondition, NULL, Envelopes_SignalLevel, NULL);
    env30_sparams.SetStops(Envelopes_TrailingProfitMethod, Envelopes_TrailingStopMethod);
    env30_sparams.SetMaxSpread(Envelopes30_MaxSpread);
    env30_sparams.SetId(ENVELOPES30);
    return (new Stg_Envelopes(env30_sparams, "Envelopes30"));
  }
  static Stg_Envelopes *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Envelopes indicator is on sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double envelopes_0_main  = ((Indi_Envelopes *) this.Data()).GetValue(LINE_MAIN, 0);
    double envelopes_0_lower = ((Indi_Envelopes *) this.Data()).GetValue(LINE_LOWER, 0);
    double envelopes_0_upper = ((Indi_Envelopes *) this.Data()).GetValue(LINE_UPPER, 0);
    double envelopes_1_main  = ((Indi_Envelopes *) this.Data()).GetValue(LINE_MAIN, 1);
    double envelopes_1_lower = ((Indi_Envelopes *) this.Data()).GetValue(LINE_LOWER, 1);
    double envelopes_1_upper = ((Indi_Envelopes *) this.Data()).GetValue(LINE_UPPER, 1);
    double envelopes_2_main  = ((Indi_Envelopes *) this.Data()).GetValue(LINE_MAIN, 2);
    double envelopes_2_lower = ((Indi_Envelopes *) this.Data()).GetValue(LINE_LOWER, 2);
    double envelopes_2_upper = ((Indi_Envelopes *) this.Data()).GetValue(LINE_UPPER, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        _result = Low[CURR] < envelopes_0_lower || Low[PREV] < envelopes_0_lower; // price low was below the lower band
        // _result = _result || (envelopes_0_main > envelopes_2_main && Open[CURR] > envelopes_0_upper);
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] > envelopes_0_lower; // FIXME
          if (METHOD(_signal_method, 1)) _result &= envelopes_0_main < envelopes_1_main;
          if (METHOD(_signal_method, 2)) _result &= envelopes_0_lower < envelopes_1_lower;
          if (METHOD(_signal_method, 3)) _result &= envelopes_0_upper < envelopes_1_upper;
          if (METHOD(_signal_method, 4)) _result &= envelopes_0_upper - envelopes_0_lower > envelopes_1_upper - envelopes_1_lower;
          if (METHOD(_signal_method, 5)) _result &= this.Chart().GetAsk() < envelopes_0_main;
          if (METHOD(_signal_method, 6)) _result &= Close[CURR] < envelopes_0_upper;
          //if (METHOD(_signal_method, 7)) _result &= _chart.GetAsk() > Close[PREV];
        }
        break;
      case ORDER_TYPE_SELL:
        _result = High[CURR] > envelopes_0_upper || High[PREV] > envelopes_0_upper; // price high was above the upper band
        // _result = _result || (envelopes_0_main < envelopes_2_main && Open[CURR] < envelopes_0_lower);
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] < envelopes_0_upper; // FIXME
          if (METHOD(_signal_method, 1)) _result &= envelopes_0_main > envelopes_1_main;
          if (METHOD(_signal_method, 2)) _result &= envelopes_0_lower > envelopes_1_lower;
          if (METHOD(_signal_method, 3)) _result &= envelopes_0_upper > envelopes_1_upper;
          if (METHOD(_signal_method, 4)) _result &= envelopes_0_upper - envelopes_0_lower > envelopes_1_upper - envelopes_1_lower;
          if (METHOD(_signal_method, 5)) _result &= this.Chart().GetAsk() > envelopes_0_main;
          if (METHOD(_signal_method, 6)) _result &= Close[CURR] > envelopes_0_upper;
          //if (METHOD(_signal_method, 7)) _result &= _chart.GetAsk() < Close[PREV];
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
