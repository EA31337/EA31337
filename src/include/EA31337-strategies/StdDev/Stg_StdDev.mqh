//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements StdDev strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_StdDev.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __StdDev_Parameters__ = "-- Settings for the Standard Deviation indicator --"; // >>> STDDEV <<<
uint StdDev_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
int StdDev_MA_Period = 10; // Period
int StdDev_MA_Shift = 0; // Shift
ENUM_MA_METHOD StdDev_MA_Method = 1; // MA Method
ENUM_APPLIED_PRICE StdDev_Applied_Price = PRICE_CLOSE; // Applied Price
int StdDev_Shift = 0; // Shift
ENUM_TRAIL_TYPE StdDev_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE StdDev_TrailingProfitMethod = 1; // Trail profit method
double StdDev_SignalLevel = 0.00000000; // Signal level
int StdDev1_SignalMethod = 0; // Signal method for M1 (0-
int StdDev5_SignalMethod = 0; // Signal method for M5 (0-
int StdDev15_SignalMethod = 0; // Signal method for M15 (0-
int StdDev30_SignalMethod = 0; // Signal method for M30 (0-
int StdDev1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int StdDev1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT StdDev1_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M1
int StdDev5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int StdDev5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT StdDev5_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M5
int StdDev15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int StdDev15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT StdDev15_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M15
int StdDev30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int StdDev30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT StdDev30_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M30
double StdDev1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double StdDev5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double StdDev15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double StdDev30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_StdDev : public Strategy {

  public:

  void Stg_StdDev(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_StdDev *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams stddev_iparams(10, INDI_STDDEV);
    StdDev_Params stddev1_iparams(StdDev_MA_Period, StdDev_MA_Shift, StdDev_MA_Method, StdDev_Applied_Price);
    StgParams stddev1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_StdDev(stddev1_iparams, stddev_iparams, cparams1), NULL, NULL);
    stddev1_sparams.SetSignals(StdDev1_SignalMethod, StdDev1_OpenCondition1, StdDev1_OpenCondition2, StdDev1_CloseCondition, NULL, StdDev_SignalLevel, NULL);
    stddev1_sparams.SetStops(StdDev_TrailingProfitMethod, StdDev_TrailingStopMethod);
    stddev1_sparams.SetMaxSpread(StdDev1_MaxSpread);
    stddev1_sparams.SetId(STDDEV1);
    return (new Stg_StdDev(stddev1_sparams, "StdDev1"));
  }
  static Stg_StdDev *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams stddev_iparams(10, INDI_STDDEV);
    StdDev_Params stddev5_iparams(StdDev_MA_Period, StdDev_MA_Shift, StdDev_MA_Method, StdDev_Applied_Price);
    StgParams stddev5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_StdDev(stddev5_iparams, stddev_iparams, cparams5), NULL, NULL);
    stddev5_sparams.SetSignals(StdDev5_SignalMethod, StdDev5_OpenCondition1, StdDev5_OpenCondition2, StdDev5_CloseCondition, NULL, StdDev_SignalLevel, NULL);
    stddev5_sparams.SetStops(StdDev_TrailingProfitMethod, StdDev_TrailingStopMethod);
    stddev5_sparams.SetMaxSpread(StdDev5_MaxSpread);
    stddev5_sparams.SetId(STDDEV5);
    return (new Stg_StdDev(stddev5_sparams, "StdDev5"));
  }
  static Stg_StdDev *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams stddev_iparams(10, INDI_STDDEV);
    StdDev_Params stddev15_iparams(StdDev_MA_Period, StdDev_MA_Shift, StdDev_MA_Method, StdDev_Applied_Price);
    StgParams stddev15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_StdDev(stddev15_iparams, stddev_iparams, cparams15), NULL, NULL);
    stddev15_sparams.SetSignals(StdDev15_SignalMethod, StdDev15_OpenCondition1, StdDev15_OpenCondition2, StdDev15_CloseCondition, NULL, StdDev_SignalLevel, NULL);
    stddev15_sparams.SetStops(StdDev_TrailingProfitMethod, StdDev_TrailingStopMethod);
    stddev15_sparams.SetMaxSpread(StdDev15_MaxSpread);
    stddev15_sparams.SetId(STDDEV15);
    return (new Stg_StdDev(stddev15_sparams, "StdDev15"));
  }
  static Stg_StdDev *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams stddev_iparams(10, INDI_STDDEV);
    StdDev_Params stddev30_iparams(StdDev_MA_Period, StdDev_MA_Shift, StdDev_MA_Method, StdDev_Applied_Price);
    StgParams stddev30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_StdDev(stddev30_iparams, stddev_iparams, cparams30), NULL, NULL);
    stddev30_sparams.SetSignals(StdDev30_SignalMethod, StdDev30_OpenCondition1, StdDev30_OpenCondition2, StdDev30_CloseCondition, NULL, StdDev_SignalLevel, NULL);
    stddev30_sparams.SetStops(StdDev_TrailingProfitMethod, StdDev_TrailingStopMethod);
    stddev30_sparams.SetMaxSpread(StdDev30_MaxSpread);
    stddev30_sparams.SetId(STDDEV30);
    return (new Stg_StdDev(stddev30_sparams, "StdDev30"));
  }
  static Stg_StdDev *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if StdDev indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double stddev_0 = ((Indi_StdDev *) this.Data()).GetValue(0);
    double stddev_1 = ((Indi_StdDev *) this.Data()).GetValue(1);
    double stddev_2 = ((Indi_StdDev *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      /*
        //27. Standard Deviation
        //Doesn't give independent signals. Is used to define volatility (trend strength).
        //Principle: the trend must be strengthened. Together with this Standard Deviation goes up.
        //Growth on 3 consecutive bars is analyzed
        //Flag is 1 when Standard Deviation rises, 0 - when no growth, -1 - never.
        if (iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,2)<=iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,1)&&iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,1)<=iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,0))
        {f27=1;}
      */
      case ORDER_TYPE_BUY:
        /*
          bool _result = StdDev_0[LINE_LOWER] != 0.0 || StdDev_1[LINE_LOWER] != 0.0 || StdDev_2[LINE_LOWER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] > Close[CURR];
          */
      break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = StdDev_0[LINE_UPPER] != 0.0 || StdDev_1[LINE_UPPER] != 0.0 || StdDev_2[LINE_UPPER] != 0.0;
          if (METHOD(_signal_method, 0)) _result &= Open[CURR] < Close[CURR];
          */
      break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
