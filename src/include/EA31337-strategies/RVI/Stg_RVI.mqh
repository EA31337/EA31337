//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements RVI strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_RVI.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
#ifndef __noparams__
string __RVI_Parameters__ = "-- Settings for the Relative Vigor Index indicator --"; // >>> RVI <<<
uint RVI_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
uint RVI_Period = 10; // Period
ENUM_TRAIL_TYPE RVI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE RVI_TrailingProfitMethod = 1; // Trail profit method
int RVI_Shift = 2; // Shift
double RVI_SignalLevel = 0.00000000; // Signal level
int RVI1_SignalMethod = 0; // Signal method for M1 (0-
int RVI5_SignalMethod = 0; // Signal method for M5 (0-
int RVI15_SignalMethod = 0; // Signal method for M15 (0-
int RVI30_SignalMethod = 0; // Signal method for M30 (0-
int RVI1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int RVI1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT RVI1_CloseCondition = C_RVI_BUY_SELL; // Close condition for M1
int RVI5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int RVI5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT RVI5_CloseCondition = C_RVI_BUY_SELL; // Close condition for M5
int RVI15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int RVI15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT RVI15_CloseCondition = C_RVI_BUY_SELL; // Close condition for M15
int RVI30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int RVI30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT RVI30_CloseCondition = C_RVI_BUY_SELL; // Close condition for M30
double RVI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double RVI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double RVI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double RVI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)
#endif

class Stg_RVI : public Strategy {

  public:

  void Stg_RVI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_RVI *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams rvi_iparams(10, INDI_RVI);
    RVI_Params rvi1_iparams(RVI_Period);
    StgParams rvi1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_RVI(rvi1_iparams, rvi_iparams, cparams1), NULL, NULL);
    rvi1_sparams.SetSignals(RVI1_SignalMethod, RVI1_OpenCondition1, RVI1_OpenCondition2, RVI1_CloseCondition, NULL, RVI_SignalLevel, NULL);
    rvi1_sparams.SetStops(RVI_TrailingProfitMethod, RVI_TrailingStopMethod);
    rvi1_sparams.SetMaxSpread(RVI1_MaxSpread);
    rvi1_sparams.SetId(RVI1);
    return (new Stg_RVI(rvi1_sparams, "RVI1"));
  }
  static Stg_RVI *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams rvi_iparams(10, INDI_RVI);
    RVI_Params rvi5_iparams(RVI_Period);
    StgParams rvi5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_RVI(rvi5_iparams, rvi_iparams, cparams5), NULL, NULL);
    rvi5_sparams.SetSignals(RVI5_SignalMethod, RVI5_OpenCondition1, RVI5_OpenCondition2, RVI5_CloseCondition, NULL, RVI_SignalLevel, NULL);
    rvi5_sparams.SetStops(RVI_TrailingProfitMethod, RVI_TrailingStopMethod);
    rvi5_sparams.SetMaxSpread(RVI5_MaxSpread);
    rvi5_sparams.SetId(RVI5);
    return (new Stg_RVI(rvi5_sparams, "RVI5"));
  }
  static Stg_RVI *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams rvi_iparams(10, INDI_RVI);
    RVI_Params rvi15_iparams(RVI_Period);
    StgParams rvi15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_RVI(rvi15_iparams, rvi_iparams, cparams15), NULL, NULL);
    rvi15_sparams.SetSignals(RVI15_SignalMethod, RVI15_OpenCondition1, RVI15_OpenCondition2, RVI15_CloseCondition, NULL, RVI_SignalLevel, NULL);
    rvi15_sparams.SetStops(RVI_TrailingProfitMethod, RVI_TrailingStopMethod);
    rvi15_sparams.SetMaxSpread(RVI15_MaxSpread);
    rvi15_sparams.SetId(RVI15);
    return (new Stg_RVI(rvi15_sparams, "RVI15"));
  }
  static Stg_RVI *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams rvi_iparams(10, INDI_RVI);
    RVI_Params rvi30_iparams(RVI_Period);
    StgParams rvi30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_RVI(rvi30_iparams, rvi_iparams, cparams30), NULL, NULL);
    rvi30_sparams.SetSignals(RVI30_SignalMethod, RVI30_OpenCondition1, RVI30_OpenCondition2, RVI30_CloseCondition, NULL, RVI_SignalLevel, NULL);
    rvi30_sparams.SetStops(RVI_TrailingProfitMethod, RVI_TrailingStopMethod);
    rvi30_sparams.SetMaxSpread(RVI30_MaxSpread);
    rvi30_sparams.SetId(RVI30);
    return (new Stg_RVI(rvi30_sparams, "RVI30"));
  }
  static Stg_RVI *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if RVI indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    /*
    double rvi_0 = ((Indi_RVI *) this.Data()).GetValue(0);
    double rvi_1 = ((Indi_RVI *) this.Data()).GetValue(1);
    double rvi_2 = ((Indi_RVI *) this.Data()).GetValue(2);
    */
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      /*
        //26. RVI
        //RECOMMENDED TO USE WITH A TREND INDICATOR
        //Buy: main line (green) crosses signal (red) upwards
        //Sell: main line (green) crosses signal (red) downwards
        if(iRVI(NULL,pirvi,pirviu,LINE_MAIN,1)<iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,1)
        && iRVI(NULL,pirvi,pirviu,LINE_MAIN,0)>=iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,0))
        {f26=1;}
        if(iRVI(NULL,pirvi,pirviu,LINE_MAIN,1)>iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,1)
        && iRVI(NULL,pirvi,pirviu,LINE_MAIN,0)<=iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,0))
        {f26=-1;}
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

