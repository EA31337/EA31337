//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements WPR strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_WPR.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_WPR : public Strategy {

  public:

  void Stg_WPR(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_WPR *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams wpr_iparams(10, INDI_WPR);
    WPR_Params wpr1_iparams(WPR_Period_M1);
    StgParams wpr1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_WPR(wpr1_iparams, wpr_iparams, cparams1), NULL, NULL);
    wpr1_sparams.SetSignals(WPR1_SignalMethod, WPR1_OpenCondition1, WPR1_OpenCondition2, WPR1_CloseCondition, NULL, WPR_SignalLevel, NULL);
    wpr1_sparams.SetStops(WPR_TrailingProfitMethod, WPR_TrailingStopMethod);
    wpr1_sparams.SetMaxSpread(WPR1_MaxSpread);
    wpr1_sparams.SetId(WPR1);
    return (new Stg_WPR(wpr1_sparams, "WPR1"));
  }
  static Stg_WPR *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams wpr_iparams(10, INDI_WPR);
    WPR_Params wpr5_iparams(WPR_Period_M5);
    StgParams wpr5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_WPR(wpr5_iparams, wpr_iparams, cparams5), NULL, NULL);
    wpr5_sparams.SetSignals(WPR5_SignalMethod, WPR5_OpenCondition1, WPR5_OpenCondition2, WPR5_CloseCondition, NULL, WPR_SignalLevel, NULL);
    wpr5_sparams.SetStops(WPR_TrailingProfitMethod, WPR_TrailingStopMethod);
    wpr5_sparams.SetMaxSpread(WPR5_MaxSpread);
    wpr5_sparams.SetId(WPR5);
    return (new Stg_WPR(wpr5_sparams, "WPR5"));
  }
  static Stg_WPR *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams wpr_iparams(10, INDI_WPR);
    WPR_Params wpr15_iparams(WPR_Period_M15);
    StgParams wpr15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_WPR(wpr15_iparams, wpr_iparams, cparams15), NULL, NULL);
    wpr15_sparams.SetSignals(WPR15_SignalMethod, WPR15_OpenCondition1, WPR15_OpenCondition2, WPR15_CloseCondition, NULL, WPR_SignalLevel, NULL);
    wpr15_sparams.SetStops(WPR_TrailingProfitMethod, WPR_TrailingStopMethod);
    wpr15_sparams.SetMaxSpread(WPR15_MaxSpread);
    wpr15_sparams.SetId(WPR15);
    return (new Stg_WPR(wpr15_sparams, "WPR15"));
  }
  static Stg_WPR *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams wpr_iparams(10, INDI_WPR);
    WPR_Params wpr30_iparams(WPR_Period_M30);
    StgParams wpr30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_WPR(wpr30_iparams, wpr_iparams, cparams30), NULL, NULL);
    wpr30_sparams.SetSignals(WPR30_SignalMethod, WPR30_OpenCondition1, WPR30_OpenCondition2, WPR30_CloseCondition, NULL, WPR_SignalLevel, NULL);
    wpr30_sparams.SetStops(WPR_TrailingProfitMethod, WPR_TrailingStopMethod);
    wpr30_sparams.SetMaxSpread(WPR30_MaxSpread);
    wpr30_sparams.SetId(WPR30);
    return (new Stg_WPR(wpr30_sparams, "WPR30"));
  }
  static Stg_WPR *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if WPR indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double wpr_0 = ((Indi_WPR *) this.Data()).GetValue(0);
    double wpr_1 = ((Indi_WPR *) this.Data()).GetValue(1);
    double wpr_2 = ((Indi_WPR *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();

    switch (cmd) {
      case ORDER_TYPE_BUY:
        _result = wpr_0 > 50 + _signal_level1;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= wpr_0 < wpr_1;
          if (METHOD(_signal_method, 1)) _result &= wpr_1 < wpr_2;
          if (METHOD(_signal_method, 2)) _result &= wpr_1 > 50 + _signal_level1;
          if (METHOD(_signal_method, 3)) _result &= wpr_2  > 50 + _signal_level1;
          if (METHOD(_signal_method, 4)) _result &= wpr_1 - wpr_0 > wpr_2 - wpr_1;
          if (METHOD(_signal_method, 5)) _result &= wpr_1 > 50 + _signal_level1 + _signal_level1 / 2;
        }
        /* @todo
           //30. Williams Percent Range
           //Buy: crossing -80 upwards
           //Sell: crossing -20 downwards
           if (iWPR(NULL,piwpr,piwprbar,1)<-80&&iWPR(NULL,piwpr,piwprbar,0)>=-80)
           {f30=1;}
           if (iWPR(NULL,piwpr,piwprbar,1)>-20&&iWPR(NULL,piwpr,piwprbar,0)<=-20)
           {f30=-1;}
        */
        break;
      case ORDER_TYPE_SELL:
        _result = wpr_0 < 50 - _signal_level1;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= wpr_0 > wpr_1;
          if (METHOD(_signal_method, 1)) _result &= wpr_1 > wpr_2;
          if (METHOD(_signal_method, 2)) _result &= wpr_1 < 50 - _signal_level1;
          if (METHOD(_signal_method, 3)) _result &= wpr_2  < 50 - _signal_level1;
          if (METHOD(_signal_method, 4)) _result &= wpr_0 - wpr_1 > wpr_1 - wpr_2;
          if (METHOD(_signal_method, 5)) _result &= wpr_1 > 50 - _signal_level1 - _signal_level1 / 2;
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};

