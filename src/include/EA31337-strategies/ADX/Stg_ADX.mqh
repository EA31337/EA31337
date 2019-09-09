//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ADX strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_ADX.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_ADX : public Strategy {

  public:

  void Stg_ADX(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_ADX *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams adx_iparams(10, INDI_ADX);
    ADX_Params adx1_iparams(ADX_Period_M1, ADX_Applied_Price);
    StgParams adx1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_ADX(adx1_iparams, adx_iparams, cparams1), NULL, NULL);
    adx1_sparams.SetSignals(ADX1_SignalMethod, ADX1_OpenCondition1, ADX1_OpenCondition2, ADX1_CloseCondition, NULL, ADX_SignalLevel, NULL);
    adx1_sparams.SetStops(ADX_TrailingProfitMethod, ADX_TrailingStopMethod);
    adx1_sparams.SetMaxSpread(ADX1_MaxSpread);
    adx1_sparams.SetId(ADX1);
    return (new Stg_ADX(adx1_sparams, "ADX1"));
  }
  static Stg_ADX *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams adx_iparams(10, INDI_ADX);
    ADX_Params adx5_iparams(ADX_Period_M5, ADX_Applied_Price);
    StgParams adx5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_ADX(adx5_iparams, adx_iparams, cparams5), NULL, NULL);
    adx5_sparams.SetSignals(ADX5_SignalMethod, ADX5_OpenCondition1, ADX5_OpenCondition2, ADX5_CloseCondition, NULL, ADX_SignalLevel, NULL);
    adx5_sparams.SetStops(ADX_TrailingProfitMethod, ADX_TrailingStopMethod);
    adx5_sparams.SetMaxSpread(ADX5_MaxSpread);
    adx5_sparams.SetId(ADX5);
    return (new Stg_ADX(adx5_sparams, "ADX5"));
  }
  static Stg_ADX *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams adx_iparams(10, INDI_ADX);
    ADX_Params adx15_iparams(ADX_Period_M15, ADX_Applied_Price);
    StgParams adx15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_ADX(adx15_iparams, adx_iparams, cparams15), NULL, NULL);
    adx15_sparams.SetSignals(ADX15_SignalMethod, ADX15_OpenCondition1, ADX15_OpenCondition2, ADX15_CloseCondition, NULL, ADX_SignalLevel, NULL);
    adx15_sparams.SetStops(ADX_TrailingProfitMethod, ADX_TrailingStopMethod);
    adx15_sparams.SetMaxSpread(ADX15_MaxSpread);
    adx15_sparams.SetId(ADX15);
    return (new Stg_ADX(adx15_sparams, "ADX15"));
  }
  static Stg_ADX *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams adx_iparams(10, INDI_ADX);
    ADX_Params adx30_iparams(ADX_Period_M30, ADX_Applied_Price);
    StgParams adx30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_ADX(adx30_iparams, adx_iparams, cparams30), NULL, NULL);
    adx30_sparams.SetSignals(ADX30_SignalMethod, ADX30_OpenCondition1, ADX30_OpenCondition2, ADX30_CloseCondition, NULL, ADX_SignalLevel, NULL);
    adx30_sparams.SetStops(ADX_TrailingProfitMethod, ADX_TrailingStopMethod);
    adx30_sparams.SetMaxSpread(ADX30_MaxSpread);
    adx30_sparams.SetId(ADX30);
    return (new Stg_ADX(adx30_sparams, "ADX30"));
  }
  static Stg_ADX *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if ADX indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double adx_0_main    = ((Indi_ADX *) this.Data()).GetValue(LINE_MAIN_ADX, 0);
    double adx_0_plusdi  = ((Indi_ADX *) this.Data()).GetValue(LINE_PLUSDI, 0);
    double adx_0_minusdi = ((Indi_ADX *) this.Data()).GetValue(LINE_MINUSDI, 0);
    double adx_1_main    = ((Indi_ADX *) this.Data()).GetValue(LINE_MAIN_ADX, 1);
    double adx_1_plusdi  = ((Indi_ADX *) this.Data()).GetValue(LINE_PLUSDI, 1);
    double adx_1_minusdi = ((Indi_ADX *) this.Data()).GetValue(LINE_MINUSDI, 1);
    double adx_2_main    = ((Indi_ADX *) this.Data()).GetValue(LINE_MAIN_ADX, 2);
    double adx_2_plusdi  = ((Indi_ADX *) this.Data()).GetValue(LINE_PLUSDI, 2);
    double adx_2_minusdi = ((Indi_ADX *) this.Data()).GetValue(LINE_MINUSDI, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      // Buy: +DI line is above -DI line, ADX is more than a certain value and grows (i.e. trend strengthens).
      case ORDER_TYPE_BUY:
        _result = adx_0_minusdi < adx_0_plusdi && adx_0_main >= _signal_level1;
        if (METHOD(_signal_method, 0)) _result &= adx_0_main > adx_1_main;
        if (METHOD(_signal_method, 1)) _result &= adx_1_main > adx_2_main;
      break;
      // Sell: -DI line is above +DI line, ADX is more than a certain value and grows (i.e. trend strengthens).
      case ORDER_TYPE_SELL:
        _result = adx_0_minusdi > adx_0_plusdi && adx_0_main >= _signal_level1;
        if (METHOD(_signal_method, 0)) _result &= adx_0_main > adx_1_main;
        if (METHOD(_signal_method, 1)) _result &= adx_1_main > adx_2_main;
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
