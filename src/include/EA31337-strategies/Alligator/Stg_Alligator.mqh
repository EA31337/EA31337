//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Alligator strategy.
 */

// Includes.
#include "..\..\EA31337-classes\Indicators\Indi_Alligator.mqh"
#include "..\..\EA31337-classes\Strategy.mqh"

// User input params.
INPUT string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --"; // >>> ALLIGATOR <<<
INPUT int Alligator_Period_Jaw = 30; // Jaw Period
INPUT int Alligator_Period_Teeth = 10; // Teeth Period
INPUT int Alligator_Period_Lips = 34; // Lips Period
INPUT int Alligator_Shift_Jaw = 0; // Jaw Shift
INPUT int Alligator_Shift_Teeth = 11; // Teeth Shift
INPUT int Alligator_Shift_Lips = 0; // Lips Shift
INPUT ENUM_MA_METHOD Alligator_MA_Method = 2; // MA Method
INPUT ENUM_APPLIED_PRICE Alligator_Applied_Price = (ENUM_APPLIED_PRICE) 0; // Applied Price
INPUT int Alligator_Shift = 0; // Shift
#ifndef __rider__
INPUT ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = 22; // Trail stop method
INPUT ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = 8; // Trail profit method
#else
ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = 0; // Trail stop method
ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = 0; // Trail profit method
#endif
INPUT double Alligator_SignalLevel = 0.3; // Signal level
#ifndef __advanced__
INPUT int Alligator1_SignalMethod = 1; // Signal method for M1 (-63-63)
INPUT int Alligator5_SignalMethod = 9; // Signal method for M5 (-63-63)
INPUT int Alligator15_SignalMethod = 18; // Signal method for M15 (-63-63)
INPUT int Alligator30_SignalMethod = 20; // Signal method for M30 (-63-63)
#else
int Alligator1_SignalMethod = 0; // Signal method for M1 (-63-63)
int Alligator5_SignalMethod = 0; // Signal method for M5 (-63-63)
int Alligator15_SignalMethod = 0; // Signal method for M15 (-63-63)
int Alligator30_SignalMethod = 0; // Signal method for M30 (-63-63)
#endif
#ifdef __advanced__
INPUT int Alligator1_OpenCondition1 = 98; // Open condition 1 for M1 (0-1023)
INPUT int Alligator1_OpenCondition2 = 583; // Open condition 2 for M1 (0-1023)
INPUT ENUM_MARKET_EVENT Alligator1_CloseCondition = 12; // Close condition for M1
INPUT int Alligator5_OpenCondition1 = 874; // Open condition 1 for M5 (0-1023)
INPUT int Alligator5_OpenCondition2 = 777; // Open condition 2 for M5 (0-1023)
INPUT ENUM_MARKET_EVENT Alligator5_CloseCondition = 13; // Close condition for M5
INPUT int Alligator15_OpenCondition1 = 486; // Open condition 1 for M15 (0-1023)
INPUT int Alligator15_OpenCondition2 = 1; // Open condition 2 for M15 (0-1023)
INPUT ENUM_MARKET_EVENT Alligator15_CloseCondition = 15; // Close condition for M15
INPUT int Alligator30_OpenCondition1 = 292; // Open condition 1 for M30 (0-1023)
INPUT int Alligator30_OpenCondition2 = 680; // Open condition 2 for M30 (0-1023)
INPUT ENUM_MARKET_EVENT Alligator30_CloseCondition = 11; // Close condition for M30
#else
int Alligator1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Alligator1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT Alligator1_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M1
int Alligator5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Alligator5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT Alligator5_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M5
int Alligator15_OpenCondition1 = 0; // Open condition 1 for M15 (0-1023)
int Alligator15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT Alligator15_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M15
int Alligator30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
int Alligator30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT Alligator30_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M30
#endif
INPUT double Alligator1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double Alligator5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double Alligator15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double Alligator30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Alligator : public Strategy {

  public:

  void Stg_Alligator(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Alligator *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams alli_iparams(10, INDI_ALLIGATOR);
    Alligator_Params alli1_iparams(
      Alligator_Period_Jaw, Alligator_Shift_Jaw,
      Alligator_Period_Teeth, Alligator_Shift_Teeth,
      Alligator_Period_Lips, Alligator_Shift_Lips,
      Alligator_MA_Method, Alligator_Applied_Price);
    StgParams alli1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Alligator(alli1_iparams, alli_iparams, cparams1), NULL, NULL);
    alli1_sparams.SetSignals(Alligator1_SignalMethod, Alligator1_OpenCondition1, Alligator1_OpenCondition2, Alligator1_CloseCondition, NULL, Alligator_SignalLevel, NULL);
    alli1_sparams.SetStops(Alligator_TrailingProfitMethod, Alligator_TrailingStopMethod);
    alli1_sparams.SetMaxSpread(Alligator1_MaxSpread);
    alli1_sparams.SetId(ALLIGATOR1);
    return (new Stg_Alligator(alli1_sparams, "Alligator1"));
  }
  static Stg_Alligator *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams alli_iparams(10, INDI_ALLIGATOR);
    Alligator_Params alli5_iparams(
      Alligator_Period_Jaw, Alligator_Shift_Jaw,
      Alligator_Period_Teeth, Alligator_Shift_Teeth,
      Alligator_Period_Lips, Alligator_Shift_Lips,
      Alligator_MA_Method, Alligator_Applied_Price);
    StgParams alli5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Alligator(alli5_iparams, alli_iparams, cparams5), NULL, NULL);
    alli5_sparams.SetSignals(Alligator5_SignalMethod, Alligator5_OpenCondition1, Alligator5_OpenCondition2, Alligator5_CloseCondition, NULL, Alligator_SignalLevel, NULL);
    alli5_sparams.SetStops(Alligator_TrailingProfitMethod, Alligator_TrailingStopMethod);
    alli5_sparams.SetMaxSpread(Alligator5_MaxSpread);
    alli5_sparams.SetId(ALLIGATOR5);
    return (new Stg_Alligator(alli5_sparams, "Alligator5"));
  }
  static Stg_Alligator *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams alli_iparams(10, INDI_ALLIGATOR);
    Alligator_Params alli15_iparams(
      Alligator_Period_Jaw, Alligator_Shift_Jaw,
      Alligator_Period_Teeth, Alligator_Shift_Teeth,
      Alligator_Period_Lips, Alligator_Shift_Lips,
      Alligator_MA_Method, Alligator_Applied_Price);
    StgParams alli15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Alligator(alli15_iparams, alli_iparams, cparams15), NULL, NULL);
    alli15_sparams.SetSignals(Alligator15_SignalMethod, Alligator15_OpenCondition1, Alligator15_OpenCondition2, Alligator15_CloseCondition, NULL, Alligator_SignalLevel, NULL);
    alli15_sparams.SetStops(Alligator_TrailingProfitMethod, Alligator_TrailingStopMethod);
    alli15_sparams.SetMaxSpread(Alligator15_MaxSpread);
    alli15_sparams.SetId(ALLIGATOR15);
    return (new Stg_Alligator(alli15_sparams, "Alligator15"));
  }
  static Stg_Alligator *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams alli_iparams(10, INDI_ALLIGATOR);
    Alligator_Params alli30_iparams(
      Alligator_Period_Jaw, Alligator_Shift_Jaw,
      Alligator_Period_Teeth, Alligator_Shift_Teeth,
      Alligator_Period_Lips, Alligator_Shift_Lips,
      Alligator_MA_Method, Alligator_Applied_Price);
    StgParams alli30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Alligator(alli30_iparams, alli_iparams, cparams30), NULL, NULL);
    alli30_sparams.SetSignals(Alligator30_SignalMethod, Alligator30_OpenCondition1, Alligator30_OpenCondition2, Alligator30_CloseCondition, NULL, Alligator_SignalLevel, NULL);
    alli30_sparams.SetStops(Alligator_TrailingProfitMethod, Alligator_TrailingStopMethod);
    alli30_sparams.SetMaxSpread(Alligator30_MaxSpread);
    alli30_sparams.SetId(ALLIGATOR30);
    return (new Stg_Alligator(alli30_sparams, "Alligator30"));
  }
  static Stg_Alligator *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Alligator indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    // [x][0] - The Blue line (Alligator's Jaw), [x][1] - The Red Line (Alligator's Teeth), [x][2] - The Green Line (Alligator's Lips)
    bool _result = false;
    double alligator_0_jaw   = ((Indi_Alligator *) this.Data()).GetValue(LINE_JAW, 0);
    double alligator_0_teeth = ((Indi_Alligator *) this.Data()).GetValue(LINE_TEETH, 0);
    double alligator_0_lips  = ((Indi_Alligator *) this.Data()).GetValue(LINE_LIPS, 0);
    double alligator_1_jaw   = ((Indi_Alligator *) this.Data()).GetValue(LINE_JAW, 1);
    double alligator_1_teeth = ((Indi_Alligator *) this.Data()).GetValue(LINE_TEETH, 1);
    double alligator_1_lips  = ((Indi_Alligator *) this.Data()).GetValue(LINE_LIPS, 1);
    double alligator_2_jaw   = ((Indi_Alligator *) this.Data()).GetValue(LINE_JAW, 2);
    double alligator_2_teeth = ((Indi_Alligator *) this.Data()).GetValue(LINE_TEETH, 2);
    double alligator_2_lips  = ((Indi_Alligator *) this.Data()).GetValue(LINE_LIPS, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    double gap = _signal_level1 * pip_size;
    switch(cmd) {
      case ORDER_TYPE_BUY:
        _result = (
          alligator_0_lips > alligator_0_teeth + gap && // Check if Lips are above Teeth ...
          alligator_0_teeth > alligator_0_jaw + gap // ... Teeth are above Jaw ...
          );
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= (
            alligator_0_lips > alligator_1_lips && // Check if Lips increased.
            alligator_0_teeth > alligator_1_teeth && // Check if Teeth increased.
            alligator_0_jaw > alligator_1_jaw // // Check if Jaw increased.
            );
          if (METHOD(_signal_method, 1)) _result &= (
            alligator_1_lips > alligator_2_lips && // Check if Lips increased.
            alligator_1_teeth > alligator_2_teeth && // Check if Teeth increased.
            alligator_1_jaw > alligator_2_jaw // // Check if Jaw increased.
            );
          if (METHOD(_signal_method, 2)) _result &= alligator_0_lips > alligator_2_lips; // Check if Lips increased.
          if (METHOD(_signal_method, 3)) _result &= alligator_0_lips - alligator_0_teeth > alligator_0_teeth - alligator_0_jaw;
          if (METHOD(_signal_method, 4)) _result &= (
            alligator_2_lips <= alligator_2_teeth || // Check if Lips are below Teeth and ...
            alligator_2_lips <= alligator_2_jaw || // ... Lips are below Jaw and ...
            alligator_2_teeth <= alligator_2_jaw // ... Teeth are below Jaw ...
            );
        }
        break;
      case ORDER_TYPE_SELL:
        _result = (
          alligator_0_lips + gap < alligator_0_teeth && // Check if Lips are below Teeth and ...
          alligator_0_teeth + gap < alligator_0_jaw // ... Teeth are below Jaw ...
          );
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= (
            alligator_0_lips < alligator_1_lips && // Check if Lips decreased.
            alligator_0_teeth < alligator_1_teeth && // Check if Teeth decreased.
            alligator_0_jaw < alligator_1_jaw // // Check if Jaw decreased.
            );
          if (METHOD(_signal_method, 1)) _result &= (
            alligator_1_lips < alligator_2_lips && // Check if Lips decreased.
            alligator_1_teeth < alligator_2_teeth && // Check if Teeth decreased.
            alligator_1_jaw < alligator_2_jaw // // Check if Jaw decreased.
            );
          if (METHOD(_signal_method, 2)) _result &= alligator_0_lips < alligator_2_lips; // Check if Lips decreased.
          if (METHOD(_signal_method, 3)) _result &= alligator_0_teeth - alligator_0_lips > alligator_0_jaw - alligator_0_teeth;
          if (METHOD(_signal_method, 4)) _result &= (
            alligator_2_lips >= alligator_2_teeth || // Check if Lips are above Teeth ...
            alligator_2_lips >= alligator_2_jaw || // ... Lips are above Jaw ...
            alligator_2_teeth >= alligator_2_jaw // ... Teeth are above Jaw ...
            );
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
