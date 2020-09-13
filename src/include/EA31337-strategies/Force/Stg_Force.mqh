//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Force strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Force.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __Force_Parameters__ = "-- Settings for the Force Index indicator --"; // >>> FORCE <<<
#ifndef __rider__
INPUT ENUM_TRAIL_TYPE Force_TrailingStopMethod = 17; // Trail stop method
INPUT ENUM_TRAIL_TYPE Force_TrailingProfitMethod = -5; // Trail profit method
#else
ENUM_TRAIL_TYPE Force_TrailingStopMethod = 0; // Trail stop method
ENUM_TRAIL_TYPE Force_TrailingProfitMethod = 0; // Trail profit method
#endif
INPUT int Force_Period_M1 = 14; // Period for M1
INPUT int Force_Period_M5 = 20; // Period for M5
INPUT int Force_Period_M15 = 14; // Period for M15
INPUT int Force_Period_M30 = 16; // Period for M30
INPUT ENUM_MA_METHOD Force_MA_Method = 0; // MA Method
INPUT ENUM_APPLIED_PRICE Force_Applied_Price = (ENUM_APPLIED_PRICE) 1; // Applied Price
INPUT double Force_SignalLevel = 1.2; // Signal level
INPUT uint Force_Shift = 0; // Shift (relative to the current bar, 0 - default)
#ifndef __advanced__
INPUT int Force1_SignalMethod = 0; // Signal method for M1 (0-
INPUT int Force5_SignalMethod = 0; // Signal method for M5 (0-
INPUT int Force15_SignalMethod = 0; // Signal method for M15 (0-
INPUT int Force30_SignalMethod = 0; // Signal method for M30 (0-
#else
int Force1_SignalMethod = 0; // Signal method for M1 (0-
int Force5_SignalMethod = 0; // Signal method for M5 (0-
int Force15_SignalMethod = 0; // Signal method for M15 (0-
int Force30_SignalMethod = 0; // Signal method for M30 (0-
#endif
#ifdef __advanced__
INPUT int Force1_OpenCondition1 = 1; // Open condition 1 for M1 (0-1023)
INPUT int Force1_OpenCondition2 = 1; // Open condition 2 for M1 (0-)
INPUT ENUM_MARKET_EVENT Force1_CloseCondition = 1; // Close condition for M1
INPUT int Force5_OpenCondition1 = 292; // Open condition 1 for M5 (0-1023)
INPUT int Force5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
INPUT ENUM_MARKET_EVENT Force5_CloseCondition = 1; // Close condition for M5
INPUT int Force15_OpenCondition1 = 1; // Open condition 1 for M15 (0-)
INPUT int Force15_OpenCondition2 = 1; // Open condition 2 for M15 (0-)
INPUT ENUM_MARKET_EVENT Force15_CloseCondition = 1; // Close condition for M15
INPUT int Force30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
INPUT int Force30_OpenCondition2 = 98; // Open condition 2 for M30 (0-)
INPUT ENUM_MARKET_EVENT Force30_CloseCondition = 4; // Close condition for M30
#else
int Force1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Force1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Force1_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M1
int Force5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Force5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Force5_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M5
int Force15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Force15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Force15_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M15
int Force30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Force30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Force30_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M30
#endif
INPUT double Force1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double Force5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double Force15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double Force30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Force : public Strategy {

  public:

  void Stg_Force(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Force *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams force_iparams(10, INDI_FORCE);
    Force_Params force1_iparams(Force_Period_M1, Force_MA_Method, Force_Applied_Price);
    StgParams force1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Force(force1_iparams, force_iparams, cparams1), NULL, NULL);
    force1_sparams.SetSignals(Force1_SignalMethod, Force1_OpenCondition1, Force1_OpenCondition2, Force1_CloseCondition, NULL, Force_SignalLevel, NULL);
    force1_sparams.SetStops(Force_TrailingProfitMethod, Force_TrailingStopMethod);
    force1_sparams.SetMaxSpread(Force1_MaxSpread);
    force1_sparams.SetId(FORCE1);
    return (new Stg_Force(force1_sparams, "Force1"));
  }
  static Stg_Force *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams force_iparams(10, INDI_FORCE);
    Force_Params force5_iparams(Force_Period_M5, Force_MA_Method, Force_Applied_Price);
    StgParams force5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Force(force5_iparams, force_iparams, cparams5), NULL, NULL);
    force5_sparams.SetSignals(Force5_SignalMethod, Force5_OpenCondition1, Force5_OpenCondition2, Force5_CloseCondition, NULL, Force_SignalLevel, NULL);
    force5_sparams.SetStops(Force_TrailingProfitMethod, Force_TrailingStopMethod);
    force5_sparams.SetMaxSpread(Force5_MaxSpread);
    force5_sparams.SetId(FORCE5);
    return (new Stg_Force(force5_sparams, "Force5"));
  }
  static Stg_Force *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams force_iparams(10, INDI_FORCE);
    Force_Params force15_iparams(Force_Period_M15, Force_MA_Method, Force_Applied_Price);
    StgParams force15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Force(force15_iparams, force_iparams, cparams15), NULL, NULL);
    force15_sparams.SetSignals(Force15_SignalMethod, Force15_OpenCondition1, Force15_OpenCondition2, Force15_CloseCondition, NULL, Force_SignalLevel, NULL);
    force15_sparams.SetStops(Force_TrailingProfitMethod, Force_TrailingStopMethod);
    force15_sparams.SetMaxSpread(Force15_MaxSpread);
    force15_sparams.SetId(FORCE15);
    return (new Stg_Force(force15_sparams, "Force15"));
  }
  static Stg_Force *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams force_iparams(10, INDI_FORCE);
    Force_Params force30_iparams(Force_Period_M30, Force_MA_Method, Force_Applied_Price);
    StgParams force30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Force(force30_iparams, force_iparams, cparams30), NULL, NULL);
    force30_sparams.SetSignals(Force30_SignalMethod, Force30_OpenCondition1, Force30_OpenCondition2, Force30_CloseCondition, NULL, Force_SignalLevel, NULL);
    force30_sparams.SetStops(Force_TrailingProfitMethod, Force_TrailingStopMethod);
    force30_sparams.SetMaxSpread(Force30_MaxSpread);
    force30_sparams.SetId(FORCE30);
    return (new Stg_Force(force30_sparams, "Force30"));
  }
  static Stg_Force *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Force Index indicator is on buy or sell.
   *
   * Note: To use the indicator it should be correlated with another trend indicator.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double force_0 = ((Indi_Force *) this.Data()).GetValue(0);
    double force_1 = ((Indi_Force *) this.Data()).GetValue(1);
    double force_2 = ((Indi_Force *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        // FI recommends to buy (i.e. FI<0).
        _result = force_0 < -_signal_level1;
        break;
      case ORDER_TYPE_SELL:
        // FI recommends to sell (i.e. FI>0).
        _result = force_0 > _signal_level1;
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
