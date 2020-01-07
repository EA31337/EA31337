//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ZigZag strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_ZigZag.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __ZigZag_Parameters__ = "-- Settings for the ZigZag indicator --"; // >>> ZIGZAG <<<
uint ZigZag_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
uint ZigZag_Depth = 0; // Depth
uint ZigZag_Deviation = 0; // Deviation
uint ZigZag_Backstep = 0; // Deviation
uint ZigZag_Shift = 0; // Shift (relative to the current bar)
ENUM_TRAIL_TYPE ZigZag_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE ZigZag_TrailingProfitMethod = 1; // Trail profit method
double ZigZag_SignalLevel = 0.00000000; // Signal level
int ZigZag1_SignalMethod = 0; // Signal method for M1 (0-31)
int ZigZag5_SignalMethod = 0; // Signal method for M5 (0-31)
int ZigZag15_SignalMethod = 0; // Signal method for M15 (0-31)
int ZigZag30_SignalMethod = 0; // Signal method for M30 (0-31)
int ZigZag1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int ZigZag1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ZigZag1_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M1
int ZigZag5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int ZigZag5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ZigZag5_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M5
int ZigZag15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int ZigZag15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ZigZag15_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M15
int ZigZag30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int ZigZag30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ZigZag30_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M30
double ZigZag1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double ZigZag5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double ZigZag15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double ZigZag30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_ZigZag : public Strategy {

  public:

  void Stg_ZigZag(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_ZigZag *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams zigzag_iparams(10, INDI_ZIGZAG);
    ZigZag_Params zigzag1_iparams(ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep);
    StgParams zigzag1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_ZigZag(zigzag1_iparams, zigzag_iparams, cparams1), NULL, NULL);
    zigzag1_sparams.SetSignals(ZigZag1_SignalMethod, ZigZag1_OpenCondition1, ZigZag1_OpenCondition2, ZigZag1_CloseCondition, NULL, ZigZag_SignalLevel, NULL);
    zigzag1_sparams.SetStops(ZigZag_TrailingProfitMethod, ZigZag_TrailingStopMethod);
    zigzag1_sparams.SetMaxSpread(ZigZag1_MaxSpread);
    zigzag1_sparams.SetId(ZIGZAG1);
    return (new Stg_ZigZag(zigzag1_sparams, "ZigZag1"));
  }
  static Stg_ZigZag *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams zigzag_iparams(10, INDI_ZIGZAG);
    ZigZag_Params zigzag5_iparams(ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep);
    StgParams zigzag5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_ZigZag(zigzag5_iparams, zigzag_iparams, cparams5), NULL, NULL);
    zigzag5_sparams.SetSignals(ZigZag5_SignalMethod, ZigZag5_OpenCondition1, ZigZag5_OpenCondition2, ZigZag5_CloseCondition, NULL, ZigZag_SignalLevel, NULL);
    zigzag5_sparams.SetStops(ZigZag_TrailingProfitMethod, ZigZag_TrailingStopMethod);
    zigzag5_sparams.SetMaxSpread(ZigZag5_MaxSpread);
    zigzag5_sparams.SetId(ZIGZAG5);
    return (new Stg_ZigZag(zigzag5_sparams, "ZigZag5"));
  }
  static Stg_ZigZag *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams zigzag_iparams(10, INDI_ZIGZAG);
    ZigZag_Params zigzag15_iparams(ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep);
    StgParams zigzag15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_ZigZag(zigzag15_iparams, zigzag_iparams, cparams15), NULL, NULL);
    zigzag15_sparams.SetSignals(ZigZag15_SignalMethod, ZigZag15_OpenCondition1, ZigZag15_OpenCondition2, ZigZag15_CloseCondition, NULL, ZigZag_SignalLevel, NULL);
    zigzag15_sparams.SetStops(ZigZag_TrailingProfitMethod, ZigZag_TrailingStopMethod);
    zigzag15_sparams.SetMaxSpread(ZigZag15_MaxSpread);
    zigzag15_sparams.SetId(ZIGZAG15);
    return (new Stg_ZigZag(zigzag15_sparams, "ZigZag15"));
  }
  static Stg_ZigZag *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams zigzag_iparams(10, INDI_ZIGZAG);
    ZigZag_Params zigzag30_iparams(ZigZag_Depth, ZigZag_Deviation, ZigZag_Backstep);
    StgParams zigzag30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_ZigZag(zigzag30_iparams, zigzag_iparams, cparams30), NULL, NULL);
    zigzag30_sparams.SetSignals(ZigZag30_SignalMethod, ZigZag30_OpenCondition1, ZigZag30_OpenCondition2, ZigZag30_CloseCondition, NULL, ZigZag_SignalLevel, NULL);
    zigzag30_sparams.SetStops(ZigZag_TrailingProfitMethod, ZigZag_TrailingStopMethod);
    zigzag30_sparams.SetMaxSpread(ZigZag30_MaxSpread);
    zigzag30_sparams.SetId(ZIGZAG30);
    return (new Stg_ZigZag(zigzag30_sparams, "ZigZag30"));
  }
  static Stg_ZigZag *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if ZigZag indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double zigzag_0 = ((Indi_ZigZag *) this.Data()).GetValue(0);
    double zigzag_1 = ((Indi_ZigZag *) this.Data()).GetValue(1);
    double zigzag_2 = ((Indi_ZigZag *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      case ORDER_TYPE_BUY:
        /*
          bool _result = ZigZag_0[LINE_LOWER] != 0.0 || ZigZag_1[LINE_LOWER] != 0.0 || ZigZag_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[CURR];
          if (METHOD(_signal_method, 1)) _result &= !ZigZag_On_Sell(tf);
          if (METHOD(_signal_method, 2)) _result &= ZigZag_On_Buy(fmin(period + 1, M30));
          if (METHOD(_signal_method, 3)) _result &= ZigZag_On_Buy(M30);
          if (METHOD(_signal_method, 4)) _result &= ZigZag_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 5)) _result &= !ZigZag_On_Sell(M30);
          */
      break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = ZigZag_0[LINE_UPPER] != 0.0 || ZigZag_1[LINE_UPPER] != 0.0 || ZigZag_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[CURR];
          if (METHOD(_signal_method, 1)) _result &= !ZigZag_On_Buy(tf);
          if (METHOD(_signal_method, 2)) _result &= ZigZag_On_Sell(fmin(period + 1, M30));
          if (METHOD(_signal_method, 3)) _result &= ZigZag_On_Sell(M30);
          if (METHOD(_signal_method, 4)) _result &= ZigZag_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 5)) _result &= !ZigZag_On_Buy(M30);
          */
      break;
    }
    return _result;
  }

};

