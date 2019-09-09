//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements AD strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_AD.mqh"
#include "../../EA31337-classes/Strategy.mqh"

class Stg_AD : public Strategy {

  public:

  void Stg_AD(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_AD *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams ad_iparams(10, INDI_AD);
    StgParams ad1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_AD(ad_iparams, cparams1), NULL, NULL);
    ad1_sparams.SetSignals(AD1_SignalMethod, AD1_OpenCondition1, AD1_OpenCondition2, AD1_CloseCondition, NULL, AD_SignalLevel, NULL);
    ad1_sparams.SetStops(AD_TrailingProfitMethod, AD_TrailingStopMethod);
    ad1_sparams.SetMaxSpread(AD1_MaxSpread);
    ad1_sparams.SetId(AD1);
    return (new Stg_AD(ad1_sparams, "AD1"));
  }
  static Stg_AD *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams ad_iparams(10, INDI_AD);
    StgParams ad5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_AD(ad_iparams, cparams5), NULL, NULL);
    ad5_sparams.SetSignals(AD5_SignalMethod, AD5_OpenCondition1, AD5_OpenCondition2, AD5_CloseCondition, NULL, AD_SignalLevel, NULL);
    ad5_sparams.SetStops(AD_TrailingProfitMethod, AD_TrailingStopMethod);
    ad5_sparams.SetMaxSpread(AD5_MaxSpread);
    ad5_sparams.SetId(AD5);
    return (new Stg_AD(ad5_sparams, "AD5"));
  }
  static Stg_AD *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams ad_iparams(10, INDI_AD);
    StgParams ad15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_AD(ad_iparams, cparams15), NULL, NULL);
    ad15_sparams.SetSignals(AD15_SignalMethod, AD15_OpenCondition1, AD15_OpenCondition2, AD15_CloseCondition, NULL, AD_SignalLevel, NULL);
    ad15_sparams.SetStops(AD_TrailingProfitMethod, AD_TrailingStopMethod);
    ad15_sparams.SetMaxSpread(AD15_MaxSpread);
    ad15_sparams.SetId(AD15);
    return (new Stg_AD(ad15_sparams, "AD15"));
  }
  static Stg_AD *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams ad_iparams(10, INDI_AD);
    StgParams ad30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_AD(ad_iparams, cparams30), NULL, NULL);
    ad30_sparams.SetSignals(AD30_SignalMethod, AD30_OpenCondition1, AD30_OpenCondition2, AD30_CloseCondition, NULL, AD_SignalLevel, NULL);
    ad30_sparams.SetStops(AD_TrailingProfitMethod, AD_TrailingStopMethod);
    ad30_sparams.SetMaxSpread(AD30_MaxSpread);
    ad30_sparams.SetId(AD30);
    return (new Stg_AD(ad30_sparams, "AD30"));
  }
  static Stg_AD *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if A/D (Accumulation/Distribution) indicator is on buy or sell.
   *
   * Main principle - convergence/divergence.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double ad_0 = ((Indi_AD *) this.Data()).GetValue(0);
    double ad_1 = ((Indi_AD *) this.Data()).GetValue(1);
    double ad_2 = ((Indi_AD *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      // Buy: indicator growth at downtrend.
      case ORDER_TYPE_BUY:
        _result = ad_0 >= ad_1 + _signal_level1 && chart.GetClose(0) <= chart.GetClose(1);
        if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[CURR];
      break;
      // Sell: indicator fall at uptrend.
      case ORDER_TYPE_SELL:
        _result = ad_0 <= ad_1 - _signal_level1 && chart.GetClose(0) >= chart.GetClose(1);
        if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[CURR];
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};