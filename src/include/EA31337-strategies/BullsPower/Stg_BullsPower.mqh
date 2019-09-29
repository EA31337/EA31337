//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BullsPower strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_BullsPower.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __BullsPower_Parameters__ = "-- Settings for the Bulls Power indicator --"; // >>> BULLS POWER <<<
uint BullsPower_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
ENUM_TRAIL_TYPE BullsPower_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BullsPower_TrailingProfitMethod = 1; // Trail profit method
int BullsPower_Period = 13; // Period
ENUM_APPLIED_PRICE BullsPower_Applied_Price = PRICE_CLOSE; // Applied Price
double BullsPower_SignalLevel = 0.00000000; // Signal level
uint BullsPower_Shift = 0; // Shift (relative to the current bar, 0 - default)
int BullsPower1_SignalMethod = 0; // Signal method for M1 (0-
int BullsPower5_SignalMethod = 0; // Signal method for M5 (0-
int BullsPower15_SignalMethod = 0; // Signal method for M15 (0-
int BullsPower30_SignalMethod = 0; // Signal method for M30 (0-
int BullsPower1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int BullsPower1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BullsPower1_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M1
int BullsPower5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int BullsPower5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BullsPower5_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M5
int BullsPower15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int BullsPower15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BullsPower15_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M15
int BullsPower30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int BullsPower30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BullsPower30_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M30
double BullsPower1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BullsPower5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BullsPower15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BullsPower30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_BullsPower : public Strategy {

  public:

  void Stg_BullsPower(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BullsPower *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower1_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_BullsPower(bullspower1_iparams, bullspower_iparams, cparams1), NULL, NULL);
    bullspower1_sparams.SetSignals(BullsPower1_SignalMethod, BullsPower1_OpenCondition1, BullsPower1_OpenCondition2, BullsPower1_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower1_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower1_sparams.SetMaxSpread(BullsPower1_MaxSpread);
    bullspower1_sparams.SetId(BULLSPOWER1);
    return (new Stg_BullsPower(bullspower1_sparams, "BullsPower1"));
  }
  static Stg_BullsPower *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower5_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_BullsPower(bullspower5_iparams, bullspower_iparams, cparams5), NULL, NULL);
    bullspower5_sparams.SetSignals(BullsPower5_SignalMethod, BullsPower5_OpenCondition1, BullsPower5_OpenCondition2, BullsPower5_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower5_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower5_sparams.SetMaxSpread(BullsPower5_MaxSpread);
    bullspower5_sparams.SetId(BULLSPOWER5);
    return (new Stg_BullsPower(bullspower5_sparams, "BullsPower5"));
  }
  static Stg_BullsPower *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower15_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_BullsPower(bullspower15_iparams, bullspower_iparams, cparams15), NULL, NULL);
    bullspower15_sparams.SetSignals(BullsPower15_SignalMethod, BullsPower15_OpenCondition1, BullsPower15_OpenCondition2, BullsPower15_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower15_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower15_sparams.SetMaxSpread(BullsPower15_MaxSpread);
    bullspower15_sparams.SetId(BULLSPOWER15);
    return (new Stg_BullsPower(bullspower15_sparams, "BullsPower15"));
  }
  static Stg_BullsPower *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams bullspower_iparams(10, INDI_BULLS);
    BullsPower_Params bullspower30_iparams(BullsPower_Period, BullsPower_Applied_Price);
    StgParams bullspower30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_BullsPower(bullspower30_iparams, bullspower_iparams, cparams30), NULL, NULL);
    bullspower30_sparams.SetSignals(BullsPower30_SignalMethod, BullsPower30_OpenCondition1, BullsPower30_OpenCondition2, BullsPower30_CloseCondition, NULL, BullsPower_SignalLevel, NULL);
    bullspower30_sparams.SetStops(BullsPower_TrailingProfitMethod, BullsPower_TrailingStopMethod);
    bullspower30_sparams.SetMaxSpread(BullsPower30_MaxSpread);
    bullspower30_sparams.SetId(BULLSPOWER30);
    return (new Stg_BullsPower(bullspower30_sparams, "BullsPower30"));
  }
  static Stg_BullsPower *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if BullsPower indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double bulls_0 = ((Indi_BullsPower *) this.Data()).GetValue(0);
    double bulls_1 = ((Indi_BullsPower *) this.Data()).GetValue(1);
    double bulls_2 = ((Indi_BullsPower *) this.Data()).GetValue(2);
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

