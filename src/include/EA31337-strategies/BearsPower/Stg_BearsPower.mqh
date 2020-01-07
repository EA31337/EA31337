//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BearsPower strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_BearsPower.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __BearsPower_Parameters__ = "-- Settings for the Bears Power indicator --"; // >>> BEARS POWER <<<
uint BearsPower_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
ENUM_TRAIL_TYPE BearsPower_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BearsPower_TrailingProfitMethod = 1; // Trail profit method
int BearsPower_Period = 13; // Period
ENUM_APPLIED_PRICE BearsPower_Applied_Price = PRICE_CLOSE; // Applied Price
double BearsPower_SignalLevel = 0.00000000; // Signal level
uint BearsPower_Shift = 0; // Shift (relative to the current bar, 0 - default)
int BearsPower1_SignalMethod = 0; // Signal method for M1 (0-
int BearsPower5_SignalMethod = 0; // Signal method for M5 (0-
int BearsPower15_SignalMethod = 0; // Signal method for M15 (0-
int BearsPower30_SignalMethod = 0; // Signal method for M30 (0-
int BearsPower1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int BearsPower1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BearsPower1_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M1
int BearsPower5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int BearsPower5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BearsPower5_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M5
int BearsPower15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int BearsPower15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BearsPower15_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M15
int BearsPower30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int BearsPower30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BearsPower30_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M30
double BearsPower1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BearsPower5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BearsPower15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BearsPower30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_BearsPower : public Strategy {

  public:

  void Stg_BearsPower(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BearsPower *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams bearspower_iparams(10, INDI_BEARS);
    BearsPower_Params bearspower1_iparams(BearsPower_Period, BearsPower_Applied_Price);
    StgParams bearspower1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_BearsPower(bearspower1_iparams, bearspower_iparams, cparams1), NULL, NULL);
    bearspower1_sparams.SetSignals(BearsPower1_SignalMethod, BearsPower1_OpenCondition1, BearsPower1_OpenCondition2, BearsPower1_CloseCondition, NULL, BearsPower_SignalLevel, NULL);
    bearspower1_sparams.SetStops(BearsPower_TrailingProfitMethod, BearsPower_TrailingStopMethod);
    bearspower1_sparams.SetMaxSpread(BearsPower1_MaxSpread);
    bearspower1_sparams.SetId(BEARSPOWER1);
    return (new Stg_BearsPower(bearspower1_sparams, "BearsPower1"));
  }
  static Stg_BearsPower *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams bearspower_iparams(10, INDI_BEARS);
    BearsPower_Params bearspower5_iparams(BearsPower_Period, BearsPower_Applied_Price);
    StgParams bearspower5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_BearsPower(bearspower5_iparams, bearspower_iparams, cparams5), NULL, NULL);
    bearspower5_sparams.SetSignals(BearsPower5_SignalMethod, BearsPower5_OpenCondition1, BearsPower5_OpenCondition2, BearsPower5_CloseCondition, NULL, BearsPower_SignalLevel, NULL);
    bearspower5_sparams.SetStops(BearsPower_TrailingProfitMethod, BearsPower_TrailingStopMethod);
    bearspower5_sparams.SetMaxSpread(BearsPower5_MaxSpread);
    bearspower5_sparams.SetId(BEARSPOWER5);
    return (new Stg_BearsPower(bearspower5_sparams, "BearsPower5"));
  }
  static Stg_BearsPower *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams bearspower_iparams(10, INDI_BEARS);
    BearsPower_Params bearspower15_iparams(BearsPower_Period, BearsPower_Applied_Price);
    StgParams bearspower15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_BearsPower(bearspower15_iparams, bearspower_iparams, cparams15), NULL, NULL);
    bearspower15_sparams.SetSignals(BearsPower15_SignalMethod, BearsPower15_OpenCondition1, BearsPower15_OpenCondition2, BearsPower15_CloseCondition, NULL, BearsPower_SignalLevel, NULL);
    bearspower15_sparams.SetStops(BearsPower_TrailingProfitMethod, BearsPower_TrailingStopMethod);
    bearspower15_sparams.SetMaxSpread(BearsPower15_MaxSpread);
    bearspower15_sparams.SetId(BEARSPOWER15);
    return (new Stg_BearsPower(bearspower15_sparams, "BearsPower15"));
  }
  static Stg_BearsPower *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams bearspower_iparams(10, INDI_BEARS);
    BearsPower_Params bearspower30_iparams(BearsPower_Period, BearsPower_Applied_Price);
    StgParams bearspower30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_BearsPower(bearspower30_iparams, bearspower_iparams, cparams30), NULL, NULL);
    bearspower30_sparams.SetSignals(BearsPower30_SignalMethod, BearsPower30_OpenCondition1, BearsPower30_OpenCondition2, BearsPower30_CloseCondition, NULL, BearsPower_SignalLevel, NULL);
    bearspower30_sparams.SetStops(BearsPower_TrailingProfitMethod, BearsPower_TrailingStopMethod);
    bearspower30_sparams.SetMaxSpread(BearsPower30_MaxSpread);
    bearspower30_sparams.SetId(BEARSPOWER30);
    return (new Stg_BearsPower(bearspower30_sparams, "BearsPower30"));
  }
  static Stg_BearsPower *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if BearsPower indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double bears_0 = ((Indi_BearsPower *) this.Data()).GetValue(0);
    double bears_1 = ((Indi_BearsPower *) this.Data()).GetValue(1);
    double bears_2 = ((Indi_BearsPower *) this.Data()).GetValue(2);
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
