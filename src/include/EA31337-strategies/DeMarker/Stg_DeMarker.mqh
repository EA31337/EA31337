//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements DeMarker strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_DeMarker.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --"; // >>> DEMARKER <<<
INPUT uint DeMarker_Active_Tf = 8; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
INPUT int DeMarker_Period_M1 = 74; // Period for M1
INPUT int DeMarker_Period_M5 = 38; // Period for M5
INPUT int DeMarker_Period_M15 = 16; // Period for M15
INPUT int DeMarker_Period_M30 = 34; // Period for M30
INPUT int DeMarker_Shift = 4; // Shift
INPUT double DeMarker_SignalLevel = 0.2; // Signal level (0.0-0.5)
INPUT ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = 1; // Trail stop method
INPUT ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = 25; // Trail profit method
INPUT int DeMarker1_SignalMethod = 12; // Signal method for M1 (-31-31)
INPUT int DeMarker5_SignalMethod = 12; // Signal method for M5 (-31-31)
INPUT int DeMarker15_SignalMethod = 4; // Signal method for M15 (-31-31)
INPUT int DeMarker30_SignalMethod = 12; // Signal method for M30 (-31-31)
INPUT int DeMarker1_OpenCondition1 = 680; // Open condition 1 for M1 (0-1023)
INPUT int DeMarker1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
INPUT ENUM_MARKET_EVENT DeMarker1_CloseCondition = 1; // Close condition for M1
INPUT int DeMarker5_OpenCondition1 = 971; // Open condition 1 for M5 (0-1023)
INPUT int DeMarker5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
INPUT ENUM_MARKET_EVENT DeMarker5_CloseCondition = 1; // Close condition for M5
INPUT int DeMarker15_OpenCondition1 = 874; // Open condition 1 for M15 (0-1023)
INPUT int DeMarker15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
INPUT ENUM_MARKET_EVENT DeMarker15_CloseCondition = 1; // Close condition for M15
INPUT int DeMarker30_OpenCondition1 = 195; // Open condition 1 for M30 (0-1023)
INPUT int DeMarker30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
INPUT ENUM_MARKET_EVENT DeMarker30_CloseCondition = 1; // Close condition for M30
INPUT double DeMarker1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double DeMarker5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double DeMarker15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double DeMarker30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_DeMarker : public Strategy {

  public:

  void Stg_DeMarker(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_DeMarker *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams dm_iparams(10, INDI_DEMARKER);
    DeMarker_Params dm1_iparams(DeMarker_Period_M1);
    StgParams dm1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_DeMarker(dm1_iparams, dm_iparams, cparams1), NULL, NULL);
    dm1_sparams.SetSignals(DeMarker1_SignalMethod, DeMarker1_OpenCondition1, DeMarker1_OpenCondition2, DeMarker1_CloseCondition, NULL, DeMarker_SignalLevel, NULL);
    dm1_sparams.SetStops(DeMarker_TrailingProfitMethod, DeMarker_TrailingStopMethod);
    dm1_sparams.SetMaxSpread(DeMarker1_MaxSpread);
    dm1_sparams.SetId(DEMARKER1);
    return (new Stg_DeMarker(dm1_sparams, "DeMarker1"));
  }
  static Stg_DeMarker *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams dm_iparams(10, INDI_DEMARKER);
    DeMarker_Params dm5_iparams(DeMarker_Period_M5);
    StgParams dm5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_DeMarker(dm5_iparams, dm_iparams, cparams5), NULL, NULL);
    dm5_sparams.SetSignals(DeMarker5_SignalMethod, DeMarker5_OpenCondition1, DeMarker5_OpenCondition2, DeMarker5_CloseCondition, NULL, DeMarker_SignalLevel, NULL);
    dm5_sparams.SetStops(DeMarker_TrailingProfitMethod, DeMarker_TrailingStopMethod);
    dm5_sparams.SetMaxSpread(DeMarker5_MaxSpread);
    dm5_sparams.SetId(DEMARKER5);
    return (new Stg_DeMarker(dm5_sparams, "DeMarker5"));
  }
  static Stg_DeMarker *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams dm_iparams(10, INDI_DEMARKER);
    DeMarker_Params dm15_iparams(DeMarker_Period_M15);
    StgParams dm15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_DeMarker(dm15_iparams, dm_iparams, cparams15), NULL, NULL);
    dm15_sparams.SetSignals(DeMarker15_SignalMethod, DeMarker15_OpenCondition1, DeMarker15_OpenCondition2, DeMarker15_CloseCondition, NULL, DeMarker_SignalLevel, NULL);
    dm15_sparams.SetStops(DeMarker_TrailingProfitMethod, DeMarker_TrailingStopMethod);
    dm15_sparams.SetMaxSpread(DeMarker15_MaxSpread);
    dm15_sparams.SetId(DEMARKER15);
    return (new Stg_DeMarker(dm15_sparams, "DeMarker15"));
  }
  static Stg_DeMarker *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams dm_iparams(10, INDI_DEMARKER);
    DeMarker_Params dm30_iparams(DeMarker_Period_M30);
    StgParams dm30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_DeMarker(dm30_iparams, dm_iparams, cparams30), NULL, NULL);
    dm30_sparams.SetSignals(DeMarker30_SignalMethod, DeMarker30_OpenCondition1, DeMarker30_OpenCondition2, DeMarker30_CloseCondition, NULL, DeMarker_SignalLevel, NULL);
    dm30_sparams.SetStops(DeMarker_TrailingProfitMethod, DeMarker_TrailingStopMethod);
    dm30_sparams.SetMaxSpread(DeMarker30_MaxSpread);
    dm30_sparams.SetId(DEMARKER30);
    return (new Stg_DeMarker(dm30_sparams, "DeMarker30"));
  }
  static Stg_DeMarker *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if DeMarker indicator is on buy or sell.
   * Demarker Technical Indicator is based on the comparison of the period maximum with the previous period maximum.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double demarker_0 = ((Indi_DeMarker *) this.Data()).GetValue(0);
    double demarker_1 = ((Indi_DeMarker *) this.Data()).GetValue(1);
    double demarker_2 = ((Indi_DeMarker *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        _result = demarker_0 < 0.5 - _signal_level1;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= demarker_1 < 0.5 - _signal_level1;
          if (METHOD(_signal_method, 1)) _result &= demarker_2 < 0.5 - _signal_level1; // @to-remove?
          if (METHOD(_signal_method, 2)) _result &= demarker_0 < demarker_1; // @to-remove?
          if (METHOD(_signal_method, 3)) _result &= demarker_1 < demarker_2; // @to-remove?
          if (METHOD(_signal_method, 4)) _result &= demarker_1 < 0.5 - _signal_level1 - _signal_level1/2;
        }
        // PrintFormat("DeMarker buy: %g <= %g", demarker_0, 0.5 - _signal_level1);
        break;
      case ORDER_TYPE_SELL:
        _result = demarker_0 > 0.5 + _signal_level1;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= demarker_1 > 0.5 + _signal_level1;
          if (METHOD(_signal_method, 1)) _result &= demarker_2 > 0.5 + _signal_level1;
          if (METHOD(_signal_method, 2)) _result &= demarker_0 > demarker_1;
          if (METHOD(_signal_method, 3)) _result &= demarker_1 > demarker_2;
          if (METHOD(_signal_method, 4)) _result &= demarker_1 > 0.5 + _signal_level1 + _signal_level1/2;
        }
        // PrintFormat("DeMarker sell: %g >= %g", demarker_0, 0.5 + _signal_level1);
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
