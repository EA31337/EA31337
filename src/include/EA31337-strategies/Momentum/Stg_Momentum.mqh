//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Momentum strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Momentum.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_Momentum : public Strategy {

  public:

  void Stg_Momentum(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Momentum *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams mom_iparams(10, INDI_MOMENTUM);
    Momentum_Params mom1_iparams(Momentum_Period, Momentum_Applied_Price);
    StgParams mom1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Momentum(mom1_iparams, mom_iparams, cparams1), NULL, NULL);
    mom1_sparams.SetSignals(Momentum1_SignalMethod, Momentum1_OpenCondition1, Momentum1_OpenCondition2, Momentum1_CloseCondition, NULL, Momentum_SignalLevel, NULL);
    mom1_sparams.SetStops(Momentum_TrailingProfitMethod, Momentum_TrailingStopMethod);
    mom1_sparams.SetMaxSpread(Momentum1_MaxSpread);
    mom1_sparams.SetId(MOM1);
    return (new Stg_Momentum(mom1_sparams, "Momentum1"));
  }
  static Stg_Momentum *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams mom_iparams(10, INDI_MOMENTUM);
    Momentum_Params mom5_iparams(Momentum_Period, Momentum_Applied_Price);
    StgParams mom5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Momentum(mom5_iparams, mom_iparams, cparams5), NULL, NULL);
    mom5_sparams.SetSignals(Momentum5_SignalMethod, Momentum5_OpenCondition1, Momentum5_OpenCondition2, Momentum5_CloseCondition, NULL, Momentum_SignalLevel, NULL);
    mom5_sparams.SetStops(Momentum_TrailingProfitMethod, Momentum_TrailingStopMethod);
    mom5_sparams.SetMaxSpread(Momentum5_MaxSpread);
    mom5_sparams.SetId(MOM5);
    return (new Stg_Momentum(mom5_sparams, "Momentum5"));
  }
  static Stg_Momentum *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams mom_iparams(10, INDI_MOMENTUM);
    Momentum_Params mom15_iparams(Momentum_Period, Momentum_Applied_Price);
    StgParams mom15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Momentum(mom15_iparams, mom_iparams, cparams15), NULL, NULL);
    mom15_sparams.SetSignals(Momentum15_SignalMethod, Momentum15_OpenCondition1, Momentum15_OpenCondition2, Momentum15_CloseCondition, NULL, Momentum_SignalLevel, NULL);
    mom15_sparams.SetStops(Momentum_TrailingProfitMethod, Momentum_TrailingStopMethod);
    mom15_sparams.SetMaxSpread(Momentum15_MaxSpread);
    mom15_sparams.SetId(MOM15);
    return (new Stg_Momentum(mom15_sparams, "Momentum15"));
  }
  static Stg_Momentum *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams mom_iparams(10, INDI_MOMENTUM);
    Momentum_Params mom30_iparams(Momentum_Period, Momentum_Applied_Price);
    StgParams mom30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Momentum(mom30_iparams, mom_iparams, cparams30), NULL, NULL);
    mom30_sparams.SetSignals(Momentum30_SignalMethod, Momentum30_OpenCondition1, Momentum30_OpenCondition2, Momentum30_CloseCondition, NULL, Momentum_SignalLevel, NULL);
    mom30_sparams.SetStops(Momentum_TrailingProfitMethod, Momentum_TrailingStopMethod);
    mom30_sparams.SetMaxSpread(Momentum30_MaxSpread);
    mom30_sparams.SetId(MOM30);
    return (new Stg_Momentum(mom30_sparams, "Momentum30"));
  }
  static Stg_Momentum *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Momentum indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double momentum_0 = ((Indi_Momentum *) this.Data()).GetValue(0);
    double momentum_1 = ((Indi_Momentum *) this.Data()).GetValue(1);
    double momentum_2 = ((Indi_Momentum *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        break;
      case ORDER_TYPE_SELL:
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};

