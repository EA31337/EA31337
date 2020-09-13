//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements MACD strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_MACD.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --"; // >>> MACD <<<
INPUT int MACD_Period_Fast = 2; // Period Fast
INPUT int MACD_Period_Slow = 20; // Period Slow
INPUT int MACD_Period_Signal = 29; // Period for signal
INPUT ENUM_APPLIED_PRICE MACD_Applied_Price = (ENUM_APPLIED_PRICE) 2; // Applied Price
INPUT int MACD_Shift = 0; // Shift
#ifndef __rider__
INPUT ENUM_TRAIL_TYPE MACD_TrailingStopMethod = 1; // Trail stop method
INPUT ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = 8; // Trail profit method
#else
ENUM_TRAIL_TYPE MACD_TrailingStopMethod = 0; // Trail stop method
ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = 0; // Trail profit method
#endif
INPUT double MACD_SignalLevel = 2; // Signal level
#ifndef __advanced__
INPUT int MACD1_SignalMethod = 7; // Signal method for M1 (-7-7)
INPUT int MACD5_SignalMethod = 7; // Signal method for M5 (-7-7)
INPUT int MACD15_SignalMethod = 3; // Signal method for M15 (-7-7)
INPUT int MACD30_SignalMethod = -1; // Signal method for M30 (-7-7)
#else
int MACD1_SignalMethod = 0; // Signal method for M1 (-7-7)
int MACD5_SignalMethod = 0; // Signal method for M5 (-7-7)
int MACD15_SignalMethod = 0; // Signal method for M15 (-7-7)
int MACD30_SignalMethod = 0; // Signal method for M30 (-7-7)
#endif
#ifdef __advanced__
INPUT int MACD1_OpenCondition1 = 874; // Open condition 1 for M1 (0-1023)
INPUT int MACD1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
INPUT ENUM_MARKET_EVENT MACD1_CloseCondition = 24; // Close condition for M1
INPUT int MACD5_OpenCondition1 = 486; // Open condition 1 for M5 (0-1023)
INPUT int MACD5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
INPUT ENUM_MARKET_EVENT MACD5_CloseCondition = 2; // Close condition for M5
INPUT int MACD15_OpenCondition1 = 874; // Open condition 1 for M15 (0-1023)
INPUT int MACD15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
INPUT ENUM_MARKET_EVENT MACD15_CloseCondition = 3; // Close condition for M15
INPUT int MACD30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
INPUT int MACD30_OpenCondition2 = 971; // Open condition 2 for M30 (0-1023)
INPUT ENUM_MARKET_EVENT MACD30_CloseCondition = 3; // Close condition for M30
#else
int MACD1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int MACD1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT MACD1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
int MACD5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int MACD5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT MACD5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
int MACD15_OpenCondition1 = 0; // Open condition 1 for M15 (0-1023)
int MACD15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT MACD15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
int MACD30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
int MACD30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT MACD30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
#endif
INPUT double MACD1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double MACD5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double MACD15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double MACD30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_MACD : public Strategy {

  public:

  void Stg_MACD(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_MACD *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams macd_iparams(10, INDI_MACD);
    MACD_Params macd1_iparams(MACD_Period_Fast, MACD_Period_Slow, MACD_Period_Signal, MACD_Applied_Price);
    StgParams macd1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_MACD(macd1_iparams, macd_iparams, cparams1), NULL, NULL);
    macd1_sparams.SetSignals(MACD1_SignalMethod, MACD1_OpenCondition1, MACD1_OpenCondition2, MACD1_CloseCondition, NULL, MACD_SignalLevel, NULL);
    macd1_sparams.SetStops(MACD_TrailingProfitMethod, MACD_TrailingStopMethod);
    macd1_sparams.SetMaxSpread(MACD1_MaxSpread);
    macd1_sparams.SetId(MACD1);
    return (new Stg_MACD(macd1_sparams, "MACD1"));
  }
  static Stg_MACD *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams macd_iparams(10, INDI_MACD);
    MACD_Params macd5_iparams(MACD_Period_Fast, MACD_Period_Slow, MACD_Period_Signal, MACD_Applied_Price);
    StgParams macd5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_MACD(macd5_iparams, macd_iparams, cparams5), NULL, NULL);
    macd5_sparams.SetSignals(MACD5_SignalMethod, MACD5_OpenCondition1, MACD5_OpenCondition2, MACD5_CloseCondition, NULL, MACD_SignalLevel, NULL);
    macd5_sparams.SetStops(MACD_TrailingProfitMethod, MACD_TrailingStopMethod);
    macd5_sparams.SetMaxSpread(MACD5_MaxSpread);
    macd5_sparams.SetId(MACD5);
    return (new Stg_MACD(macd5_sparams, "MACD5"));
  }
  static Stg_MACD *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams macd_iparams(10, INDI_MACD);
    MACD_Params macd15_iparams(MACD_Period_Fast, MACD_Period_Slow, MACD_Period_Signal, MACD_Applied_Price);
    StgParams macd15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_MACD(macd15_iparams, macd_iparams, cparams15), NULL, NULL);
    macd15_sparams.SetSignals(MACD15_SignalMethod, MACD15_OpenCondition1, MACD15_OpenCondition2, MACD15_CloseCondition, NULL, MACD_SignalLevel, NULL);
    macd15_sparams.SetStops(MACD_TrailingProfitMethod, MACD_TrailingStopMethod);
    macd15_sparams.SetMaxSpread(MACD15_MaxSpread);
    macd15_sparams.SetId(MACD15);
    return (new Stg_MACD(macd15_sparams, "MACD15"));
  }
  static Stg_MACD *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams macd_iparams(10, INDI_MACD);
    MACD_Params macd30_iparams(MACD_Period_Fast, MACD_Period_Slow, MACD_Period_Signal, MACD_Applied_Price);
    StgParams macd30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_MACD(macd30_iparams, macd_iparams, cparams30), NULL, NULL);
    macd30_sparams.SetSignals(MACD30_SignalMethod, MACD30_OpenCondition1, MACD30_OpenCondition2, MACD30_CloseCondition, NULL, MACD_SignalLevel, NULL);
    macd30_sparams.SetStops(MACD_TrailingProfitMethod, MACD_TrailingStopMethod);
    macd30_sparams.SetMaxSpread(MACD30_MaxSpread);
    macd30_sparams.SetId(MACD30);
    return (new Stg_MACD(macd30_sparams, "MACD30"));
  }
  static Stg_MACD *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if MACD indicator is on buy.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double macd_0_main   = ((Indi_MACD *) this.Data()).GetValue(LINE_MAIN, 0);
    double macd_0_signal = ((Indi_MACD *) this.Data()).GetValue(LINE_SIGNAL, 0);
    double macd_1_main   = ((Indi_MACD *) this.Data()).GetValue(LINE_MAIN, 1);
    double macd_1_signal = ((Indi_MACD *) this.Data()).GetValue(LINE_SIGNAL, 1);
    double macd_2_main   = ((Indi_MACD *) this.Data()).GetValue(LINE_MAIN, 2);
    double macd_2_signal = ((Indi_MACD *) this.Data()).GetValue(LINE_SIGNAL, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    double gap = _signal_level1 * pip_size;
    switch (cmd) {
      /* TODO:
            //20. MACD (1)
            //VERSION EXISTS, THAT THE SIGNAL TO BUY IS TRUE ONLY IF MACD<0, SIGNAL TO SELL - IF MACD>0
            //Buy: MACD rises above the signal line
            //Sell: MACD falls below the signal line
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)<iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,1)
            && iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)>=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,0))
            {f20=1;}
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)>iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,1)
            && iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)<=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,0))
            {f20=-1;}

            //21. MACD (2)
            //Buy: crossing 0 upwards
            //Sell: crossing 0 downwards
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)<0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)>=0)
            {f21=1;}
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)>0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)<=0)
            {f21=-1;}
      */
      case ORDER_TYPE_BUY:
        _result = macd_0_main > macd_0_signal + gap; // MACD rises above the signal line.
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= macd_2_main < macd_2_signal;
          if (METHOD(_signal_method, 1)) _result &= macd_0_main >= 0;
          if (METHOD(_signal_method, 2)) _result &= macd_1_main < 0;
        }
        break;
      case ORDER_TYPE_SELL:
        _result = macd_0_main < macd_0_signal - gap; // MACD falls below the signal line.
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= macd_2_main > macd_2_signal;
          if (METHOD(_signal_method, 1)) _result &= macd_0_main <= 0;
          if (METHOD(_signal_method, 2)) _result &= macd_1_main > 0;
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
