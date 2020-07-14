//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BWMFI strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_BWMFI.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __BWMFI_Parameters__ = "-- Settings for the Market Facilitation Index indicator --"; // >>> BWMFI <<<
ENUM_TRAIL_TYPE BWMFI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BWMFI_TrailingProfitMethod = 1; // Trail profit method
double BWMFI_SignalLevel = 0.00000000; // Signal level
INPUT uint BWMFI_Shift = 0; // Shift (relative to the current bar, 0 - default)
int BWMFI1_SignalMethod = 0; // Signal method for M1 (0-
int BWMFI5_SignalMethod = 0; // Signal method for M5 (0-
int BWMFI15_SignalMethod = 0; // Signal method for M15 (0-
int BWMFI30_SignalMethod = 0; // Signal method for M30 (0-
int BWMFI1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int BWMFI1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BWMFI1_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M1
int BWMFI5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int BWMFI5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BWMFI5_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M5
int BWMFI15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int BWMFI15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BWMFI15_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M15
int BWMFI30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int BWMFI30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BWMFI30_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M30
double BWMFI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BWMFI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BWMFI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BWMFI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_BWMFI : public Strategy {

  public:

  void Stg_BWMFI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BWMFI *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams bwmfi_iparams(10, INDI_BWMFI);
    StgParams bwmfi1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_BWMFI(bwmfi_iparams, cparams1), NULL, NULL);
    bwmfi1_sparams.SetSignals(BWMFI1_SignalMethod, BWMFI1_OpenCondition1, BWMFI1_OpenCondition2, BWMFI1_CloseCondition, NULL, BWMFI_SignalLevel, NULL);
    bwmfi1_sparams.SetStops(BWMFI_TrailingProfitMethod, BWMFI_TrailingStopMethod);
    bwmfi1_sparams.SetMaxSpread(BWMFI1_MaxSpread);
    bwmfi1_sparams.SetId(BWMFI1);
    return (new Stg_BWMFI(bwmfi1_sparams, "BWMFI1"));
  }
  static Stg_BWMFI *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams bwmfi_iparams(10, INDI_BWMFI);
    StgParams bwmfi5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_BWMFI(bwmfi_iparams, cparams5), NULL, NULL);
    bwmfi5_sparams.SetSignals(BWMFI5_SignalMethod, BWMFI5_OpenCondition1, BWMFI5_OpenCondition2, BWMFI5_CloseCondition, NULL, BWMFI_SignalLevel, NULL);
    bwmfi5_sparams.SetStops(BWMFI_TrailingProfitMethod, BWMFI_TrailingStopMethod);
    bwmfi5_sparams.SetMaxSpread(BWMFI5_MaxSpread);
    bwmfi5_sparams.SetId(BWMFI5);
    return (new Stg_BWMFI(bwmfi5_sparams, "BWMFI5"));
  }
  static Stg_BWMFI *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams bwmfi_iparams(10, INDI_BWMFI);
    StgParams bwmfi15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_BWMFI(bwmfi_iparams, cparams15), NULL, NULL);
    bwmfi15_sparams.SetSignals(BWMFI15_SignalMethod, BWMFI15_OpenCondition1, BWMFI15_OpenCondition2, BWMFI15_CloseCondition, NULL, BWMFI_SignalLevel, NULL);
    bwmfi15_sparams.SetStops(BWMFI_TrailingProfitMethod, BWMFI_TrailingStopMethod);
    bwmfi15_sparams.SetMaxSpread(BWMFI15_MaxSpread);
    bwmfi15_sparams.SetId(BWMFI15);
    return (new Stg_BWMFI(bwmfi15_sparams, "BWMFI15"));
  }
  static Stg_BWMFI *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams bwmfi_iparams(10, INDI_BWMFI);
    StgParams bwmfi30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_BWMFI(bwmfi_iparams, cparams30), NULL, NULL);
    bwmfi30_sparams.SetSignals(BWMFI30_SignalMethod, BWMFI30_OpenCondition1, BWMFI30_OpenCondition2, BWMFI30_CloseCondition, NULL, BWMFI_SignalLevel, NULL);
    bwmfi30_sparams.SetStops(BWMFI_TrailingProfitMethod, BWMFI_TrailingStopMethod);
    bwmfi30_sparams.SetMaxSpread(BWMFI30_MaxSpread);
    bwmfi30_sparams.SetId(BWMFI30);
    return (new Stg_BWMFI(bwmfi30_sparams, "BWMFI30"));
  }
  static Stg_BWMFI *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if BWMFI indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double bwmfi_0 = ((Indi_BWMFI *) this.Data()).GetValue(0);
    double bwmfi_1 = ((Indi_BWMFI *) this.Data()).GetValue(1);
    double bwmfi_2 = ((Indi_BWMFI *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        /*
          bool _result = BWMFI_0[LINE_LOWER] != 0.0 || BWMFI_1[LINE_LOWER] != 0.0 || BWMFI_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[CURR];
        */
      break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = BWMFI_0[LINE_UPPER] != 0.0 || BWMFI_1[LINE_UPPER] != 0.0 || BWMFI_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[CURR];
        */
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
