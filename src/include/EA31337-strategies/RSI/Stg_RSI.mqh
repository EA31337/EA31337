//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements RSI strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_RSI.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --"; // >>> RSI <<<
INPUT uint RSI_Active_Tf = 12; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
INPUT int RSI_Period_M1 = 36; // Period for M1
INPUT int RSI_Period_M5 = 10; // Period for M5
INPUT int RSI_Period_M15 = 4; // Period for M15
INPUT int RSI_Period_M30 = 2; // Period for M30
INPUT ENUM_APPLIED_PRICE RSI_Applied_Price = (ENUM_APPLIED_PRICE) 0; // Applied Price
INPUT uint RSI_Shift = 4; // Shift
INPUT ENUM_TRAIL_TYPE RSI_TrailingStopMethod = 6; // Trail stop method
INPUT ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = 11; // Trail profit method
INPUT int RSI_SignalLevel = 40; // Signal level (-49-49)
INPUT int RSI1_SignalMethod = -63; // Signal method for M1 (-63-63)
INPUT int RSI5_SignalMethod = -61; // Signal method for M5 (-63-63)
INPUT int RSI15_SignalMethod = -63; // Signal method for M15 (-63-63)
INPUT int RSI30_SignalMethod = 0; // Signal method for M30 (-63-63)
INPUT int RSI1_OpenCondition1 = 1; // Open condition 1 for M1 (0-1023)
INPUT int RSI1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
INPUT ENUM_MARKET_EVENT RSI1_CloseCondition = 1; // Close condition for M1
INPUT int RSI5_OpenCondition1 = 1; // Open condition 1 for M5 (0-1023)
INPUT int RSI5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
INPUT ENUM_MARKET_EVENT RSI5_CloseCondition = 31; // Close condition for M5
INPUT int RSI15_OpenCondition1 = 389; // Open condition 1 for M15 (0-1023)
INPUT int RSI15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
INPUT ENUM_MARKET_EVENT RSI15_CloseCondition = 1; // Close condition for M15
INPUT int RSI30_OpenCondition1 = 195; // Open condition 1 for M30 (0-1023)
INPUT int RSI30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
INPUT ENUM_MARKET_EVENT RSI30_CloseCondition = 1; // Close condition for M30
double RSI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double RSI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double RSI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double RSI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_RSI : public Strategy {

  public:

  void Stg_RSI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_RSI *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams rsi_iparams(10, INDI_RSI);
    RSI_Params rsi1_iparams(RSI_Period_M1, RSI_Applied_Price);
    StgParams rsi1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_RSI(rsi1_iparams, rsi_iparams, cparams1), NULL, NULL);
    rsi1_sparams.SetSignals(RSI1_SignalMethod, RSI1_OpenCondition1, RSI1_OpenCondition2, RSI1_CloseCondition, NULL, RSI_SignalLevel, NULL);
    rsi1_sparams.SetStops(RSI_TrailingProfitMethod, RSI_TrailingStopMethod);
    rsi1_sparams.SetMaxSpread(RSI1_MaxSpread);
    rsi1_sparams.SetId(RSI1);
    return (new Stg_RSI(rsi1_sparams, "RSI1"));
  }
  static Stg_RSI *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams rsi_iparams(10, INDI_RSI);
    RSI_Params rsi5_iparams(RSI_Period_M5, RSI_Applied_Price);
    StgParams rsi5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_RSI(rsi5_iparams, rsi_iparams, cparams5), NULL, NULL);
    rsi5_sparams.SetSignals(RSI5_SignalMethod, RSI5_OpenCondition1, RSI5_OpenCondition2, RSI5_CloseCondition, NULL, RSI_SignalLevel, NULL);
    rsi5_sparams.SetStops(RSI_TrailingProfitMethod, RSI_TrailingStopMethod);
    rsi5_sparams.SetMaxSpread(RSI5_MaxSpread);
    rsi5_sparams.SetId(RSI5);
    return (new Stg_RSI(rsi5_sparams, "RSI5"));
  }
  static Stg_RSI *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams rsi_iparams(10, INDI_RSI);
    RSI_Params rsi15_iparams(RSI_Period_M15, RSI_Applied_Price);
    StgParams rsi15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_RSI(rsi15_iparams, rsi_iparams, cparams15), NULL, NULL);
    rsi15_sparams.SetSignals(RSI15_SignalMethod, RSI15_OpenCondition1, RSI15_OpenCondition2, RSI15_CloseCondition, NULL, RSI_SignalLevel, NULL);
    rsi15_sparams.SetStops(RSI_TrailingProfitMethod, RSI_TrailingStopMethod);
    rsi15_sparams.SetMaxSpread(RSI15_MaxSpread);
    rsi15_sparams.SetId(RSI15);
    return (new Stg_RSI(rsi15_sparams, "RSI15"));
  }
  static Stg_RSI *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams rsi_iparams(10, INDI_RSI);
    RSI_Params rsi30_iparams(RSI_Period_M30, RSI_Applied_Price);
    StgParams rsi30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_RSI(rsi30_iparams, rsi_iparams, cparams30), NULL, NULL);
    rsi30_sparams.SetSignals(RSI30_SignalMethod, RSI30_OpenCondition1, RSI30_OpenCondition2, RSI30_CloseCondition, NULL, RSI_SignalLevel, NULL);
    rsi30_sparams.SetStops(RSI_TrailingProfitMethod, RSI_TrailingStopMethod);
    rsi30_sparams.SetMaxSpread(RSI30_MaxSpread);
    rsi30_sparams.SetId(RSI30);
    return (new Stg_RSI(rsi30_sparams, "RSI30"));
  }
  static Stg_RSI *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if RSI indicator is on buy.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 - 1st signal level to consider the signal
   *   _signal_level2 - 2nd signal level to consider the signal
   * @result bool
   * Returns true on signal for the given _cmd, otherwise false.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double rsi_0 = ((Indi_RSI *) this.Data()).GetValue(0);
    double rsi_1 = ((Indi_RSI *) this.Data()).GetValue(1);
    double rsi_2 = ((Indi_RSI *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    bool is_valid = fmin(fmin(rsi_0, rsi_1), rsi_2) > 0;
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = rsi_0 > 0 && rsi_0 < (50 - _signal_level1);
        if (_result && VerboseDebug) {
          PrintFormat("RSI %s on buy: %g < %g", this.Chart().TfToString(), rsi_0, 50 - _signal_level1);
        }
        if (_signal_method != 0) {
          _result &= is_valid;
          if (METHOD(_signal_method, 0)) _result &= rsi_0 < rsi_1;
          if (METHOD(_signal_method, 1)) _result &= rsi_1 < rsi_2;
          if (METHOD(_signal_method, 2)) _result &= rsi_1 < (50 - _signal_level1);
          if (METHOD(_signal_method, 3)) _result &= rsi_2  < (50 - _signal_level1);
          if (METHOD(_signal_method, 4)) _result &= rsi_0 - rsi_1 > rsi_1 - rsi_2;
          if (METHOD(_signal_method, 5)) _result &= rsi_2 > 50;
        }
        break;
      case ORDER_TYPE_SELL:
        _result = rsi_0 > 0 && rsi_0 > (50 + _signal_level1);
        if (_result && VerboseDebug) {
          PrintFormat("RSI %s on sell: %g > %g", this.Chart().TfToString(), rsi_0, 50 + _signal_level1);
        }
        if (_signal_method != 0) {
          _result &= is_valid;
          if (METHOD(_signal_method, 0)) _result &= rsi_0 > rsi_1;
          if (METHOD(_signal_method, 1)) _result &= rsi_1 > rsi_2;
          if (METHOD(_signal_method, 2)) _result &= rsi_1 > (50 + _signal_level1);
          if (METHOD(_signal_method, 3)) _result &= rsi_2  > (50 + _signal_level1);
          if (METHOD(_signal_method, 4)) _result &= rsi_1 - rsi_0 > rsi_2 - rsi_1;
          if (METHOD(_signal_method, 5)) _result &= rsi_2 < 50;
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == _cmd;
    return _result;
  }

};
