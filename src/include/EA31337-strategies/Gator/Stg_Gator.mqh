//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Gator strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Gator.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __Gator_Parameters__ = "-- Settings for the Gator oscillator --"; // >>> GATOR <<<
uint Gator_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
int Gator_Period_Jaw = 6; // Jaw Period
int Gator_Period_Teeth = 10; // Teeth Period
int Gator_Period_Lips = 8; // Lips Period
int Gator_Shift_Jaw = 5; // Jaw Shift
int Gator_Shift_Teeth = 7; // Teeth Shift
int Gator_Shift_Lips = 5; // Lips Shift
ENUM_MA_METHOD Gator_MA_Method = 2; // MA Method
ENUM_APPLIED_PRICE Gator_Applied_Price = 3; // Applied Price
int Gator_Shift = 2; // Shift
ENUM_TRAIL_TYPE Gator_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Gator_TrailingProfitMethod = 1; // Trail profit method
double Gator_SignalLevel = 0.00000000; // Signal level
int Gator1_SignalMethod = 0; // Signal method for M1 (0-
int Gator5_SignalMethod = 0; // Signal method for M5 (0-
int Gator15_SignalMethod = 0; // Signal method for M15 (0-
int Gator30_SignalMethod = 0; // Signal method for M30 (0-
int Gator1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Gator1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Gator1_CloseCondition = C_GATOR_BUY_SELL; // Close condition // Close condition for M1
int Gator5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Gator5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Gator5_CloseCondition = C_GATOR_BUY_SELL; // Close condition for M5
int Gator15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Gator15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Gator15_CloseCondition = C_GATOR_BUY_SELL; // Close condition for M15
int Gator30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Gator30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Gator30_CloseCondition = C_GATOR_BUY_SELL; // Close condition for M30
double Gator1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Gator5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Gator15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Gator30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Gator : public Strategy {

  public:

  void Stg_Gator(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Gator *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams gator_iparams(10, INDI_GATOR);
    Gator_Params gator1_iparams(
      Gator_Period_Jaw, Gator_Shift_Jaw,
      Gator_Period_Teeth, Gator_Shift_Teeth,
      Gator_Period_Lips, Gator_Shift_Lips,
      Gator_MA_Method, Gator_Applied_Price);
    StgParams gator1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Gator(gator1_iparams, gator_iparams, cparams1), NULL, NULL);
    gator1_sparams.SetSignals(Gator1_SignalMethod, Gator1_OpenCondition1, Gator1_OpenCondition2, Gator1_CloseCondition, NULL, Gator_SignalLevel, NULL);
    gator1_sparams.SetStops(Gator_TrailingProfitMethod, Gator_TrailingStopMethod);
    gator1_sparams.SetMaxSpread(Gator1_MaxSpread);
    gator1_sparams.SetId(GATOR1);
    return (new Stg_Gator(gator1_sparams, "Gator1"));
  }
  static Stg_Gator *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams gator_iparams(10, INDI_GATOR);
    Gator_Params gator5_iparams(
      Gator_Period_Jaw, Gator_Shift_Jaw,
      Gator_Period_Teeth, Gator_Shift_Teeth,
      Gator_Period_Lips, Gator_Shift_Lips,
      Gator_MA_Method, Gator_Applied_Price);
    StgParams gator5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Gator(gator5_iparams, gator_iparams, cparams5), NULL, NULL);
    gator5_sparams.SetSignals(Gator5_SignalMethod, Gator5_OpenCondition1, Gator5_OpenCondition2, Gator5_CloseCondition, NULL, Gator_SignalLevel, NULL);
    gator5_sparams.SetStops(Gator_TrailingProfitMethod, Gator_TrailingStopMethod);
    gator5_sparams.SetMaxSpread(Gator5_MaxSpread);
    gator5_sparams.SetId(GATOR5);
    return (new Stg_Gator(gator5_sparams, "Gator5"));
  }
  static Stg_Gator *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams gator_iparams(10, INDI_GATOR);
    Gator_Params gator15_iparams(
      Gator_Period_Jaw, Gator_Shift_Jaw,
      Gator_Period_Teeth, Gator_Shift_Teeth,
      Gator_Period_Lips, Gator_Shift_Lips,
      Gator_MA_Method, Gator_Applied_Price);
    StgParams gator15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Gator(gator15_iparams, gator_iparams, cparams15), NULL, NULL);
    gator15_sparams.SetSignals(Gator15_SignalMethod, Gator15_OpenCondition1, Gator15_OpenCondition2, Gator15_CloseCondition, NULL, Gator_SignalLevel, NULL);
    gator15_sparams.SetStops(Gator_TrailingProfitMethod, Gator_TrailingStopMethod);
    gator15_sparams.SetMaxSpread(Gator15_MaxSpread);
    gator15_sparams.SetId(GATOR15);
    return (new Stg_Gator(gator15_sparams, "Gator15"));
  }
  static Stg_Gator *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams gator_iparams(10, INDI_GATOR);
    Gator_Params gator30_iparams(
      Gator_Period_Jaw, Gator_Shift_Jaw,
      Gator_Period_Teeth, Gator_Shift_Teeth,
      Gator_Period_Lips, Gator_Shift_Lips,
      Gator_MA_Method, Gator_Applied_Price);
    StgParams gator30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Gator(gator30_iparams, gator_iparams, cparams30), NULL, NULL);
    gator30_sparams.SetSignals(Gator30_SignalMethod, Gator30_OpenCondition1, Gator30_OpenCondition2, Gator30_CloseCondition, NULL, Gator_SignalLevel, NULL);
    gator30_sparams.SetStops(Gator_TrailingProfitMethod, Gator_TrailingStopMethod);
    gator30_sparams.SetMaxSpread(Gator30_MaxSpread);
    gator30_sparams.SetId(GATOR30);
    return (new Stg_Gator(gator30_sparams, "Gator30"));
  }
  static Stg_Gator *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Gator Oscillator is on buy or sell.
   *
   * Note: It doesn't give independent signals. Is used for Alligator correction.
   * Principle: trend must be strengthened. Together with this Gator Oscillator goes up.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double gator_0_jaw   = ((Indi_Gator *) this.Data()).GetValue(LINE_JAW, 0);
    double gator_0_teeth = ((Indi_Gator *) this.Data()).GetValue(LINE_TEETH, 0);
    double gator_0_lips  = ((Indi_Gator *) this.Data()).GetValue(LINE_LIPS, 0);
    double gator_1_jaw   = ((Indi_Gator *) this.Data()).GetValue(LINE_JAW, 1);
    double gator_1_teeth = ((Indi_Gator *) this.Data()).GetValue(LINE_TEETH, 1);
    double gator_1_lips  = ((Indi_Gator *) this.Data()).GetValue(LINE_LIPS, 1);
    double gator_2_jaw   = ((Indi_Gator *) this.Data()).GetValue(LINE_JAW, 2);
    double gator_2_teeth = ((Indi_Gator *) this.Data()).GetValue(LINE_TEETH, 2);
    double gator_2_lips  = ((Indi_Gator *) this.Data()).GetValue(LINE_LIPS, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    double gap = _signal_level1 * pip_size;
    switch (cmd) {
      /*
        //4. Gator Oscillator
        //Lower part of diagram is taken for calculations. Growth is checked on 4 periods.
        //The flag is 1 of trend is strengthened, 0 - no strengthening, -1 - never.
        //Uses part of Alligator's variables
        if (iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,3)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,2)
        &&iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,2)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,1)
        &&iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,1)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,0))
        {f4=1;}
      */
      case ORDER_TYPE_BUY:
        break;
      case ORDER_TYPE_SELL:
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};

