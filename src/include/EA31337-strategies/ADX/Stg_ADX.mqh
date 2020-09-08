//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ADX strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_ADX.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __ADX_Parameters__ = "-- Settings for the Average Directional Movement Index indicator --"; // >>> ADX <<<
INPUT ENUM_TRAIL_TYPE ADX_TrailingStopMethod = 17; // Trail stop method
INPUT ENUM_TRAIL_TYPE ADX_TrailingProfitMethod = -10; // Trail profit method
INPUT uint ADX_Period_M1 = 46; // Period for M1
INPUT uint ADX_Period_M5 = 20; // Period for M5
INPUT uint ADX_Period_M15 = 64; // Period for M15
INPUT uint ADX_Period_M30 = 56; // Period for M30
INPUT ENUM_APPLIED_PRICE ADX_Applied_Price = (ENUM_APPLIED_PRICE) 2; // Applied Price
INPUT double ADX_SignalLevel = 20.1; // Signal level
INPUT uint ADX_Shift = 0; // Shift (relative to the current bar, 0 - default)
#ifndef __advanced__
INPUT int ADX1_SignalMethod = 1; // Signal method for M1 (0-?)
INPUT int ADX5_SignalMethod = 1; // Signal method for M5 (0-?)
INPUT int ADX15_SignalMethod = 1; // Signal method for M15 (0-?)
INPUT int ADX30_SignalMethod = 1; // Signal method for M30 (0-?)
#else
int ADX1_SignalMethod = 0; // Signal method for M1 (0-?)
int ADX5_SignalMethod = 0; // Signal method for M5 (0-?)
int ADX15_SignalMethod = 0; // Signal method for M15 (0-?)
int ADX30_SignalMethod = 0; // Signal method for M30 (0-?)
#endif
#ifdef __advanced__
INPUT int ADX1_OpenCondition1 = 971; // Open condition 1 for M1 (0-1023)
INPUT int ADX1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
INPUT ENUM_MARKET_EVENT ADX1_CloseCondition = 13; // Close condition for M1
INPUT int ADX5_OpenCondition1 = 971; // Open condition 1 for M5 (0-1023)
INPUT int ADX5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
INPUT ENUM_MARKET_EVENT ADX5_CloseCondition = 11; // Close condition for M5
INPUT int ADX15_OpenCondition1 = 1; // Open condition 1 for M15 (0-)
INPUT int ADX15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
INPUT ENUM_MARKET_EVENT ADX15_CloseCondition = 1; // Close condition for M15
INPUT int ADX30_OpenCondition1 = 292; // Open condition 1 for M30 (0-)
INPUT int ADX30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
INPUT ENUM_MARKET_EVENT ADX30_CloseCondition = 24; // Close condition for M30
#else
int ADX1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int ADX1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ADX1_CloseCondition = C_ADX_BUY_SELL; // Close condition for M1
int ADX5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int ADX5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ADX5_CloseCondition = C_ADX_BUY_SELL; // Close condition for M5
int ADX15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int ADX15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ADX15_CloseCondition = C_ADX_BUY_SELL; // Close condition for M15
int ADX30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int ADX30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ADX30_CloseCondition = C_ADX_BUY_SELL; // Close condition for M30
#endif
INPUT double ADX1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double ADX5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double ADX15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double ADX30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

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
