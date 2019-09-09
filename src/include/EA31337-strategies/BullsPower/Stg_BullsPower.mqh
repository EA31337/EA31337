//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BullsPower strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_BullsPower.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_BullsPower : public Strategy {

  public:

  void Stg_BullsPower(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BullsPower *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower1_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_BullsPower(bullspower1_iparams, bullspower_iparams, cparams1), NULL, NULL);
    bullspower1_sparams.SetSignals(BullsPower1_SignalMethod, BullsPower1_OpenCondition1, BullsPower1_OpenCondition2, BullsPower1_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower1_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower1_sparams.SetMaxSpread(BullsPower1_MaxSpread);
    bullspower1_sparams.SetId(BULLSPOWER1);
    return (new Stg_BullsPower(bullspower1_sparams, "BullsPower1"));
  }
  static Stg_BullsPower *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower5_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_BullsPower(bullspower5_iparams, bullspower_iparams, cparams5), NULL, NULL);
    bullspower5_sparams.SetSignals(BullsPower5_SignalMethod, BullsPower5_OpenCondition1, BullsPower5_OpenCondition2, BullsPower5_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower5_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower5_sparams.SetMaxSpread(BullsPower5_MaxSpread);
    bullspower5_sparams.SetId(BULLSPOWER5);
    return (new Stg_BullsPower(bullspower5_sparams, "BullsPower5"));
  }
  static Stg_BullsPower *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower15_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_BullsPower(bullspower15_iparams, bullspower_iparams, cparams15), NULL, NULL);
    bullspower15_sparams.SetSignals(BullsPower15_SignalMethod, BullsPower15_OpenCondition1, BullsPower15_OpenCondition2, BullsPower15_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower15_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower15_sparams.SetMaxSpread(BullsPower15_MaxSpread);
    bullspower15_sparams.SetId(BULLSPOWER15);
    return (new Stg_BullsPower(bullspower15_sparams, "BullsPower15"));
  }
  static Stg_BullsPower *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower30_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_BullsPower(bullspower30_iparams, bullspower_iparams, cparams30), NULL, NULL);
    bullspower30_sparams.SetSignals(BullsPower30_SignalMethod, BullsPower30_OpenCondition1, BullsPower30_OpenCondition2, BullsPower30_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower30_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower30_sparams.SetMaxSpread(BullsPower30_MaxSpread);
    bullspower30_sparams.SetId(BULLSPOWER30);
    return (new Stg_BullsPower(bullspower30_sparams, "BullsPower30"));
  }
  static Stg_BullsPower *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if BullsPower indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double bulls_0 = ((Indi_BullsPower *) this.Data()).GetValue(0);
    double bulls_1 = ((Indi_BullsPower *) this.Data()).GetValue(1);
    double bulls_2 = ((Indi_BullsPower *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        // @todo
      break;
      case ORDER_TYPE_SELL:
        // @todo
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};

