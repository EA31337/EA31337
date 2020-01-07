//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements OBV strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_OBV.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __OBV_Parameters__ = "-- Settings for the On Balance Volume indicator --"; // >>> OBV <<<
uint OBV_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
ENUM_TRAIL_TYPE OBV_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE OBV_TrailingProfitMethod = 1; // Trail profit method
ENUM_APPLIED_PRICE OBV_Applied_Price = PRICE_CLOSE; // Applied Price
double OBV_SignalLevel = 0.00000000; // Signal level
int OBV1_SignalMethod = 0; // Signal method for M1 (0-
int OBV5_SignalMethod = 0; // Signal method for M5 (0-
int OBV15_SignalMethod = 0; // Signal method for M15 (0-
int OBV30_SignalMethod = 0; // Signal method for M30 (0-
int OBV1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int OBV1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT OBV1_CloseCondition = C_OBV_BUY_SELL; // Close condition for M1
int OBV5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int OBV5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT OBV5_CloseCondition = C_OBV_BUY_SELL; // Close condition for M5
int OBV15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int OBV15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT OBV15_CloseCondition = C_OBV_BUY_SELL; // Close condition for M15
int OBV30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int OBV30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT OBV30_CloseCondition = C_OBV_BUY_SELL; // Close condition for M30
double OBV1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double OBV5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double OBV15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double OBV30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_OBV : public Strategy {

  public:

  void Stg_OBV(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_OBV *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams obv_iparams(10, INDI_OBV);
    OBV_Params obv1_iparams(OBV_Applied_Price); // @fixme: MQL5
    StgParams obv1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_OBV(obv1_iparams, obv_iparams, cparams1), NULL, NULL);
    obv1_sparams.SetSignals(OBV1_SignalMethod, OBV1_OpenCondition1, OBV1_OpenCondition2, OBV1_CloseCondition, NULL, OBV_SignalLevel, NULL);
    obv1_sparams.SetStops(OBV_TrailingProfitMethod, OBV_TrailingStopMethod);
    obv1_sparams.SetMaxSpread(OBV1_MaxSpread);
    obv1_sparams.SetId(OBV1);
    return (new Stg_OBV(obv1_sparams, "OBV1"));
  }
  static Stg_OBV *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams obv_iparams(10, INDI_OBV);
    OBV_Params obv5_iparams(OBV_Applied_Price); // @fixme: MQL5
    StgParams obv5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_OBV(obv5_iparams, obv_iparams, cparams5), NULL, NULL);
    obv5_sparams.SetSignals(OBV5_SignalMethod, OBV5_OpenCondition1, OBV5_OpenCondition2, OBV5_CloseCondition, NULL, OBV_SignalLevel, NULL);
    obv5_sparams.SetStops(OBV_TrailingProfitMethod, OBV_TrailingStopMethod);
    obv5_sparams.SetMaxSpread(OBV5_MaxSpread);
    obv5_sparams.SetId(OBV5);
    return (new Stg_OBV(obv5_sparams, "OBV5"));
  }
  static Stg_OBV *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams obv_iparams(10, INDI_OBV);
    OBV_Params obv15_iparams(OBV_Applied_Price); // @fixme: MQL5
    StgParams obv15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_OBV(obv15_iparams, obv_iparams, cparams15), NULL, NULL);
    obv15_sparams.SetSignals(OBV15_SignalMethod, OBV15_OpenCondition1, OBV15_OpenCondition2, OBV15_CloseCondition, NULL, OBV_SignalLevel, NULL);
    obv15_sparams.SetStops(OBV_TrailingProfitMethod, OBV_TrailingStopMethod);
    obv15_sparams.SetMaxSpread(OBV15_MaxSpread);
    obv15_sparams.SetId(OBV15);
    return (new Stg_OBV(obv15_sparams, "OBV15"));
  }
  static Stg_OBV *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams obv_iparams(10, INDI_OBV);
    OBV_Params obv30_iparams(OBV_Applied_Price); // @fixme: MQL5
    StgParams obv30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_OBV(obv30_iparams, obv_iparams, cparams30), NULL, NULL);
    obv30_sparams.SetSignals(OBV30_SignalMethod, OBV30_OpenCondition1, OBV30_OpenCondition2, OBV30_CloseCondition, NULL, OBV_SignalLevel, NULL);
    obv30_sparams.SetStops(OBV_TrailingProfitMethod, OBV_TrailingStopMethod);
    obv30_sparams.SetMaxSpread(OBV30_MaxSpread);
    obv30_sparams.SetId(OBV30);
    return (new Stg_OBV(obv30_sparams, "OBV30"));
  }
  static Stg_OBV *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if OBV indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double obv_0 = ((Indi_OBV *) this.Data()).GetValue(0);
    double obv_1 = ((Indi_OBV *) this.Data()).GetValue(1);
    double obv_2 = ((Indi_OBV *) this.Data()).GetValue(2);
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

