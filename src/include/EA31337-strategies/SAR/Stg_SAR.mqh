//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements SAR strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_SAR.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_SAR : public Strategy {

  public:

  void Stg_SAR(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_SAR *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams sar_iparams(10, INDI_SAR);
    SAR_Params sar1_iparams(SAR_Step, SAR_Maximum_Stop);
    StgParams sar1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_SAR(sar1_iparams, sar_iparams, cparams1), NULL, NULL);
    sar1_sparams.SetSignals(SAR1_SignalMethod, SAR1_OpenCondition1, SAR1_OpenCondition2, SAR1_CloseCondition, NULL, SAR_SignalLevel, NULL);
    sar1_sparams.SetStops(SAR_TrailingProfitMethod, SAR_TrailingStopMethod);
    sar1_sparams.SetMaxSpread(SAR1_MaxSpread);
    sar1_sparams.SetId(SAR1);
    return (new Stg_SAR(sar1_sparams, "SAR1"));
  }
  static Stg_SAR *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams sar_iparams(10, INDI_SAR);
    SAR_Params sar5_iparams(SAR_Step, SAR_Maximum_Stop);
    StgParams sar5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_SAR(sar5_iparams, sar_iparams, cparams5), NULL, NULL);
    sar5_sparams.SetSignals(SAR5_SignalMethod, SAR5_OpenCondition1, SAR5_OpenCondition2, SAR5_CloseCondition, NULL, SAR_SignalLevel, NULL);
    sar5_sparams.SetStops(SAR_TrailingProfitMethod, SAR_TrailingStopMethod);
    sar5_sparams.SetMaxSpread(SAR5_MaxSpread);
    sar5_sparams.SetId(SAR5);
    return (new Stg_SAR(sar5_sparams, "SAR5"));
  }
  static Stg_SAR *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams sar_iparams(10, INDI_SAR);
    SAR_Params sar15_iparams(SAR_Step, SAR_Maximum_Stop);
    StgParams sar15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_SAR(sar15_iparams, sar_iparams, cparams15), NULL, NULL);
    sar15_sparams.SetSignals(SAR15_SignalMethod, SAR15_OpenCondition1, SAR15_OpenCondition2, SAR15_CloseCondition, NULL, SAR_SignalLevel, NULL);
    sar15_sparams.SetStops(SAR_TrailingProfitMethod, SAR_TrailingStopMethod);
    sar15_sparams.SetMaxSpread(SAR15_MaxSpread);
    sar15_sparams.SetId(SAR15);
    return (new Stg_SAR(sar15_sparams, "SAR15"));
  }
  static Stg_SAR *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams sar_iparams(10, INDI_SAR);
    SAR_Params sar30_iparams(SAR_Step, SAR_Maximum_Stop);
    StgParams sar30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_SAR(sar30_iparams, sar_iparams, cparams30), NULL, NULL);
    sar30_sparams.SetSignals(SAR30_SignalMethod, SAR30_OpenCondition1, SAR30_OpenCondition2, SAR30_CloseCondition, NULL, SAR_SignalLevel, NULL);
    sar30_sparams.SetStops(SAR_TrailingProfitMethod, SAR_TrailingStopMethod);
    sar30_sparams.SetMaxSpread(SAR30_MaxSpread);
    sar30_sparams.SetId(SAR30);
    return (new Stg_SAR(sar30_sparams, "SAR30"));
  }
  static Stg_SAR *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if SAR indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal (in pips)
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double sar_0 = ((Indi_SAR *) this.Data()).GetValue(0);
    double sar_1 = ((Indi_SAR *) this.Data()).GetValue(1);
    double sar_2 = ((Indi_SAR *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    double gap = _signal_level1 * pip_size;
    switch (cmd) {
      case ORDER_TYPE_BUY:
        _result = sar_0 + gap < Open[CURR] || sar_1 + gap < Open[PREV];
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= sar_1 - gap > this.Chart().GetAsk();
          if (METHOD(_signal_method, 1)) _result &= sar_0 < sar_1;
          if (METHOD(_signal_method, 2)) _result &= sar_0 - sar_1 <= sar_1 - sar_2;
          if (METHOD(_signal_method, 3)) _result &= sar_2 > this.Chart().GetAsk();
          if (METHOD(_signal_method, 4)) _result &= sar_0 <= Close[CURR];
          if (METHOD(_signal_method, 5)) _result &= sar_1 > Close[PREV];
          if (METHOD(_signal_method, 6)) _result &= sar_1 > Open[PREV];
        }
        break;
      case ORDER_TYPE_SELL:
        _result = sar_0 - gap > Open[CURR] || sar_1 - gap > Open[PREV];
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= sar_1 + gap < this.Chart().GetAsk();
          if (METHOD(_signal_method, 1)) _result &= sar_0 > sar_1;
          if (METHOD(_signal_method, 2)) _result &= sar_1 - sar_0 <= sar_2 - sar_1;
          if (METHOD(_signal_method, 3)) _result &= sar_2 < this.Chart().GetAsk();
          if (METHOD(_signal_method, 4)) _result &= sar_0 >= Close[CURR];
          if (METHOD(_signal_method, 5)) _result &= sar_1 < Close[PREV];
          if (METHOD(_signal_method, 6)) _result &= sar_1 < Open[PREV];
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};

