//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements AC strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_AC.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_AC : public Strategy {

  public:

  void Stg_AC(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_AC *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams ac_iparams(10, INDI_AC);
    StgParams ac1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_AC(ac_iparams, cparams1), NULL, NULL);
    ac1_sparams.SetSignals(AC1_SignalMethod, AC1_OpenCondition1, AC1_OpenCondition2, AC1_CloseCondition, NULL, AC_SignalLevel, NULL);
    ac1_sparams.SetStops(AC_TrailingProfitMethod, AC_TrailingStopMethod);
    ac1_sparams.SetMaxSpread(AC1_MaxSpread);
    ac1_sparams.SetId(AC1);
    return (new Stg_AC(ac1_sparams, "AC1"));
  }
  static Stg_AC *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams ac_iparams(10, INDI_AC);
    StgParams ac5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_AC(ac_iparams, cparams5), NULL, NULL);
    ac5_sparams.SetSignals(AC5_SignalMethod, AC5_OpenCondition1, AC5_OpenCondition2, AC5_CloseCondition, NULL, AC_SignalLevel, NULL);
    ac5_sparams.SetStops(AC_TrailingProfitMethod, AC_TrailingStopMethod);
    ac5_sparams.SetMaxSpread(AC5_MaxSpread);
    ac5_sparams.SetId(AC5);
    return (new Stg_AC(ac5_sparams, "AC5"));
  }
  static Stg_AC *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams ac_iparams(10, INDI_AC);
    StgParams ac15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_AC(ac_iparams, cparams15), NULL, NULL);
    ac15_sparams.SetSignals(AC15_SignalMethod, AC15_OpenCondition1, AC15_OpenCondition2, AC15_CloseCondition, NULL, AC_SignalLevel, NULL);
    ac15_sparams.SetStops(AC_TrailingProfitMethod, AC_TrailingStopMethod);
    ac15_sparams.SetMaxSpread(AC15_MaxSpread);
    ac15_sparams.SetId(AC15);
    return (new Stg_AC(ac15_sparams, "AC15"));
  }
  static Stg_AC *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams ac_iparams(10, INDI_AC);
    StgParams ac30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_AC(ac_iparams, cparams30), NULL, NULL);
    ac30_sparams.SetSignals(AC30_SignalMethod, AC30_OpenCondition1, AC30_OpenCondition2, AC30_CloseCondition, NULL, AC_SignalLevel, NULL);
    ac30_sparams.SetStops(AC_TrailingProfitMethod, AC_TrailingStopMethod);
    ac30_sparams.SetMaxSpread(AC30_MaxSpread);
    ac30_sparams.SetId(AC30);
    return (new Stg_AC(ac30_sparams, "AC30"));
  }
  static Stg_AC *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if AC indicator is on buy or sell.
   *
   * @param
   *   _chart (Chart) - given chart to check
   *   cmd (int) - type of trade order command
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (float) - signal level to use
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double ac_0 = ((Indi_AC *) this.Data()).GetValue(0);
    double ac_1 = ((Indi_AC *) this.Data()).GetValue(1);
    double ac_2 = ((Indi_AC *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    bool is_valid = fmin(fmin(ac_0, ac_1), ac_2) != 0;
    switch (_cmd) {
      /*
        //1. Acceleration/Deceleration — AC
        //Buy: if the indicator is above zero and 2 consecutive columns are green or if the indicator is below zero and 3 consecutive columns are green
        //Sell: if the indicator is below zero and 2 consecutive columns are red or if the indicator is above zero and 3 consecutive columns are red
        if ((iAC(NULL,piac,0)>=0&&iAC(NULL,piac,0)>iAC(NULL,piac,1)&&iAC(NULL,piac,1)>iAC(NULL,piac,2))||(iAC(NULL,piac,0)<=0
        && iAC(NULL,piac,0)>iAC(NULL,piac,1)&&iAC(NULL,piac,1)>iAC(NULL,piac,2)&&iAC(NULL,piac,2)>iAC(NULL,piac,3)))
        if ((iAC(NULL,piac,0)<=0&&iAC(NULL,piac,0)<iAC(NULL,piac,1)&&iAC(NULL,piac,1)<iAC(NULL,piac,2))||(iAC(NULL,piac,0)>=0
        && iAC(NULL,piac,0)<iAC(NULL,piac,1)&&iAC(NULL,piac,1)<iAC(NULL,piac,2)&&iAC(NULL,piac,2)<iAC(NULL,piac,3)))
      */
      case ORDER_TYPE_BUY:
        _result = ac_0 > _signal_level1 && ac_0 > ac_1;
        if (_signal_method != 0) {
          _result &= is_valid;
          if (METHOD(_signal_method, 0)) _result &= ac_1 > ac_2; // @todo: one more bar.
          //if (METHOD(_signal_method, 0)) _result &= ac_1 > ac_2;
        }
      break;
      case ORDER_TYPE_SELL:
        _result = ac_0 < -_signal_level1 && ac_0 < ac_1;
        if (_signal_method != 0) {
          _result &= is_valid;
          if (METHOD(_signal_method, 0)) _result &= ac_1 < ac_2; // @todo: one more bar.
          //if (METHOD(_signal_method, 0)) _result &= ac_1 < ac_2;
        }
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == _cmd;
    return _result;
  }

};