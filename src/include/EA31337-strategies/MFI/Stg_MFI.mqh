//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements MFI strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_MFI.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_MFI : public Strategy {

  public:

  void Stg_MFI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_MFI *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams mfi_iparams(10, INDI_MFI);
    MFI_Params mfi1_iparams(MFI_Period_M1);
    StgParams mfi1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_MFI(mfi1_iparams, mfi_iparams, cparams1), NULL, NULL);
    mfi1_sparams.SetSignals(MFI1_SignalMethod, MFI1_OpenCondition1, MFI1_OpenCondition2, MFI1_CloseCondition, NULL, MFI_SignalLevel, NULL);
    mfi1_sparams.SetStops(MFI_TrailingProfitMethod, MFI_TrailingStopMethod);
    mfi1_sparams.SetMaxSpread(MFI1_MaxSpread);
    mfi1_sparams.SetId(MFI1);
    return (new Stg_MFI(mfi1_sparams, "MFI1"));
  }
  static Stg_MFI *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams mfi_iparams(10, INDI_MFI);
    MFI_Params mfi5_iparams(MFI_Period_M5);
    StgParams mfi5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_MFI(mfi5_iparams, mfi_iparams, cparams5), NULL, NULL);
    mfi5_sparams.SetSignals(MFI5_SignalMethod, MFI5_OpenCondition1, MFI5_OpenCondition2, MFI5_CloseCondition, NULL, MFI_SignalLevel, NULL);
    mfi5_sparams.SetStops(MFI_TrailingProfitMethod, MFI_TrailingStopMethod);
    mfi5_sparams.SetMaxSpread(MFI5_MaxSpread);
    mfi5_sparams.SetId(MFI5);
    return (new Stg_MFI(mfi5_sparams, "MFI5"));
  }
  static Stg_MFI *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams mfi_iparams(10, INDI_MFI);
    MFI_Params mfi15_iparams(MFI_Period_M15);
    StgParams mfi15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_MFI(mfi15_iparams, mfi_iparams, cparams15), NULL, NULL);
    mfi15_sparams.SetSignals(MFI15_SignalMethod, MFI15_OpenCondition1, MFI15_OpenCondition2, MFI15_CloseCondition, NULL, MFI_SignalLevel, NULL);
    mfi15_sparams.SetStops(MFI_TrailingProfitMethod, MFI_TrailingStopMethod);
    mfi15_sparams.SetMaxSpread(MFI15_MaxSpread);
    mfi15_sparams.SetId(MFI15);
    return (new Stg_MFI(mfi15_sparams, "MFI15"));
  }
  static Stg_MFI *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams mfi_iparams(10, INDI_MFI);
    MFI_Params mfi30_iparams(MFI_Period_M30);
    StgParams mfi30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_MFI(mfi30_iparams, mfi_iparams, cparams30), NULL, NULL);
    mfi30_sparams.SetSignals(MFI30_SignalMethod, MFI30_OpenCondition1, MFI30_OpenCondition2, MFI30_CloseCondition, NULL, MFI_SignalLevel, NULL);
    mfi30_sparams.SetStops(MFI_TrailingProfitMethod, MFI_TrailingStopMethod);
    mfi30_sparams.SetMaxSpread(MFI30_MaxSpread);
    mfi30_sparams.SetId(MFI30);
    return (new Stg_MFI(mfi30_sparams, "MFI30"));
  }
  static Stg_MFI *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if MFI indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double mfi_0 = ((Indi_MFI *) this.Data()).GetValue(0);
    double mfi_1 = ((Indi_MFI *) this.Data()).GetValue(1);
    double mfi_2 = ((Indi_MFI *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      // Buy: Crossing 20 upwards.
      case ORDER_TYPE_BUY:
        _result = mfi_1 > 0 && mfi_1 < (50 - _signal_level1);
        if (METHOD(_signal_method, 0)) _result &= mfi_0 >= (50 - _signal_level1);
        break;
      // Sell: Crossing 80 downwards.
      case ORDER_TYPE_SELL:
        _result = mfi_1 > 0 && mfi_1 > (50 + _signal_level1);
        if (METHOD(_signal_method, 0)) _result &= mfi_0 <= (50 - _signal_level1);
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
