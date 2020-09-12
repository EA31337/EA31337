//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Fractals strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Fractals.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --"; // >>> FRACTALS <<<
INPUT int Fractals_Shift = 0; // Shift
#ifndef __rider__
INPUT ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = 9; // Trail stop method
INPUT ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = 25; // Trail profit method
#else
ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = 0; // Trail stop method
ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = 0; // Trail profit method
#endif
/* @todo INPUT */ int Fractals_SignalLevel = 0; // Signal level
#ifndef __advanced__
INPUT int Fractals1_SignalMethod = 3; // Signal method for M1 (-3-3)
INPUT int Fractals5_SignalMethod = 3; // Signal method for M5 (-3-3)
INPUT int Fractals15_SignalMethod = 1; // Signal method for M15 (-3-3)
INPUT int Fractals30_SignalMethod = 1; // Signal method for M30 (-3-3)
#else
int Fractals1_SignalMethod = 0; // Signal method for M1 (-3-3)
int Fractals5_SignalMethod = 0; // Signal method for M5 (-3-3)
int Fractals15_SignalMethod = 0; // Signal method for M15 (-3-3)
int Fractals30_SignalMethod = 0; // Signal method for M30 (-3-3)
#endif
#ifdef __advanced__
INPUT int Fractals1_OpenCondition1 = 874; // Open condition 1 for M1 (0-1023)
INPUT int Fractals1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
INPUT ENUM_MARKET_EVENT Fractals1_CloseCondition = 20; // Close condition for M1
INPUT int Fractals5_OpenCondition1 = 874; // Open condition 1 for M5 (0-1023)
INPUT int Fractals5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
INPUT ENUM_MARKET_EVENT Fractals5_CloseCondition = 1; // Close condition for M5
INPUT int Fractals15_OpenCondition1 = 874; // Open condition 1 for M15 (0-)
INPUT int Fractals15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
INPUT ENUM_MARKET_EVENT Fractals15_CloseCondition = 14; // Close condition for M15
INPUT int Fractals30_OpenCondition1 = 971; // Open condition 1 for M30 (0-)
INPUT int Fractals30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
INPUT ENUM_MARKET_EVENT Fractals30_CloseCondition = 11; // Close condition for M30
#else
int Fractals1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Fractals1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Fractals1_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M1
int Fractals5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Fractals5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Fractals5_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M5
int Fractals15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Fractals15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Fractals15_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M15
int Fractals30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Fractals30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Fractals30_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M30
#endif
INPUT double Fractals1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double Fractals5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double Fractals15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double Fractals30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Fractals : public Strategy {

  public:

  void Stg_Fractals(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Fractals *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams fractals_iparams(10, INDI_FRACTALS);
    StgParams fractals1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Fractals(fractals_iparams, cparams1), NULL, NULL);
    fractals1_sparams.SetSignals(Fractals1_SignalMethod, Fractals1_OpenCondition1, Fractals1_OpenCondition2, Fractals1_CloseCondition, NULL, Fractals_SignalLevel, NULL);
    fractals1_sparams.SetStops(Fractals_TrailingProfitMethod, Fractals_TrailingStopMethod);
    fractals1_sparams.SetMaxSpread(Fractals1_MaxSpread);
    fractals1_sparams.SetId(FRACTALS1);
    return (new Stg_Fractals(fractals1_sparams, "Fractals1"));
  }
  static Stg_Fractals *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams fractals_iparams(10, INDI_FRACTALS);
    StgParams fractals5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Fractals(fractals_iparams, cparams5), NULL, NULL);
    fractals5_sparams.SetSignals(Fractals5_SignalMethod, Fractals5_OpenCondition1, Fractals5_OpenCondition2, Fractals5_CloseCondition, NULL, Fractals_SignalLevel, NULL);
    fractals5_sparams.SetStops(Fractals_TrailingProfitMethod, Fractals_TrailingStopMethod);
    fractals5_sparams.SetMaxSpread(Fractals5_MaxSpread);
    fractals5_sparams.SetId(FRACTALS5);
    return (new Stg_Fractals(fractals5_sparams, "Fractals5"));
  }
  static Stg_Fractals *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams fractals_iparams(10, INDI_FRACTALS);
    StgParams fractals15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Fractals(fractals_iparams, cparams15), NULL, NULL);
    fractals15_sparams.SetSignals(Fractals15_SignalMethod, Fractals15_OpenCondition1, Fractals15_OpenCondition2, Fractals15_CloseCondition, NULL, Fractals_SignalLevel, NULL);
    fractals15_sparams.SetStops(Fractals_TrailingProfitMethod, Fractals_TrailingStopMethod);
    fractals15_sparams.SetMaxSpread(Fractals15_MaxSpread);
    fractals15_sparams.SetId(FRACTALS15);
    return (new Stg_Fractals(fractals15_sparams, "Fractals15"));
  }
  static Stg_Fractals *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams fractals_iparams(10, INDI_FRACTALS);
    StgParams fractals30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Fractals(fractals_iparams, cparams30), NULL, NULL);
    fractals30_sparams.SetSignals(Fractals30_SignalMethod, Fractals30_OpenCondition1, Fractals30_OpenCondition2, Fractals30_CloseCondition, NULL, Fractals_SignalLevel, NULL);
    fractals30_sparams.SetStops(Fractals_TrailingProfitMethod, Fractals_TrailingStopMethod);
    fractals30_sparams.SetMaxSpread(Fractals30_MaxSpread);
    fractals30_sparams.SetId(FRACTALS30);
    return (new Stg_Fractals(fractals30_sparams, "Fractals30"));
  }
  static Stg_Fractals *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Fractals indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double fractals_0_lower = ((Indi_Fractals *) this.Data()).GetValue(LINE_LOWER, 0);
    double fractals_0_upper = ((Indi_Fractals *) this.Data()).GetValue(LINE_UPPER, 0);
    double fractals_1_lower = ((Indi_Fractals *) this.Data()).GetValue(LINE_LOWER, 1);
    double fractals_1_upper = ((Indi_Fractals *) this.Data()).GetValue(LINE_UPPER, 1);
    double fractals_2_lower = ((Indi_Fractals *) this.Data()).GetValue(LINE_LOWER, 2);
    double fractals_2_upper = ((Indi_Fractals *) this.Data()).GetValue(LINE_UPPER, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    bool lower = (fractals_0_lower != 0.0 || fractals_1_lower != 0.0 || fractals_2_lower != 0.0);
    bool upper = (fractals_0_upper != 0.0 || fractals_1_upper != 0.0 || fractals_2_upper != 0.0);
    switch (cmd) {
      case ORDER_TYPE_BUY:
        _result = lower;
        if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[PREV];
        if (METHOD(_signal_method, 1)) _result &= this.Chart().GetBid() > Open[CURR];
        // if (METHOD(_signal_method, 0)) _result &= !Trade_Fractals(Convert::NegateOrderType(cmd), PERIOD_M30);
        // if (METHOD(_signal_method, 1)) _result &= !Trade_Fractals(Convert::NegateOrderType(cmd), Convert::IndexToTf(fmax(index + 1, M30)));
        // if (METHOD(_signal_method, 2)) _result &= !Trade_Fractals(Convert::NegateOrderType(cmd), Convert::IndexToTf(fmax(index + 2, M30)));
        // if (METHOD(_signal_method, 1)) _result &= !Fractals_On_Sell(tf);
        // if (METHOD(_signal_method, 3)) _result &= Fractals_On_Buy(M30);
        break;
      case ORDER_TYPE_SELL:
        _result = upper;
        if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[PREV];
        if (METHOD(_signal_method, 1)) _result &= this.Chart().GetAsk() < Open[CURR];
        // if (METHOD(_signal_method, 0)) _result &= !Trade_Fractals(Convert::NegateOrderType(cmd), PERIOD_M30);
        // if (METHOD(_signal_method, 1)) _result &= !Trade_Fractals(Convert::NegateOrderType(cmd), Convert::IndexToTf(fmax(index + 1, M30)));
        // if (METHOD(_signal_method, 2)) _result &= !Trade_Fractals(Convert::NegateOrderType(cmd), Convert::IndexToTf(fmax(index + 2, M30)));
        // if (METHOD(_signal_method, 1)) _result &= !Fractals_On_Buy(tf);
        // if (METHOD(_signal_method, 3)) _result &= Fractals_On_Sell(M30);
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
