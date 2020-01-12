//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements OSMA strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_OSMA.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __OSMA_Parameters__ = "-- Settings for the Moving Average of Oscillator indicator --"; // >>> OSMA <<<
uint OSMA_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
ENUM_TRAIL_TYPE OSMA_TrailingStopMethod = (ENUM_TRAIL_TYPE)25; // Trail stop method
ENUM_TRAIL_TYPE OSMA_TrailingProfitMethod = (ENUM_TRAIL_TYPE)1; // Trail profit method
int OSMA_Period_Fast = 8; // Period Fast
int OSMA_Period_Slow = 6; // Period Slow
int OSMA_Period_Signal = 9; // Period for signal
ENUM_APPLIED_PRICE OSMA_Applied_Price = 4; // Applied Price
double OSMA_SignalLevel = -0.2; // Signal level
int OSMA1_SignalMethod = 120; // Signal method for M1 (0-
int OSMA5_SignalMethod = 49; // Signal method for M5 (0-
int OSMA15_SignalMethod = -71; // Signal method for M15 (0-
int OSMA30_SignalMethod = -95; // Signal method for M30 (0-
int OSMA1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int OSMA1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT OSMA1_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M1
int OSMA5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int OSMA5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT OSMA5_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M5
int OSMA15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int OSMA15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT OSMA15_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M15
int OSMA30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int OSMA30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT OSMA30_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M30
double OSMA1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double OSMA5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double OSMA15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double OSMA30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_OSMA : public Strategy {

  public:

  void Stg_OSMA(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_OSMA *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams osma_iparams(10, INDI_OSMA);
    OsMA_Params osma1_iparams(OSMA_Period_Fast, OSMA_Period_Slow, OSMA_Period_Signal, OSMA_Applied_Price);
    StgParams osma1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_OsMA(osma1_iparams, osma_iparams, cparams1), NULL, NULL);
    osma1_sparams.SetSignals(OSMA1_SignalMethod, OSMA1_OpenCondition1, OSMA1_OpenCondition2, OSMA1_CloseCondition, NULL, OSMA_SignalLevel, NULL);
    osma1_sparams.SetStops(OSMA_TrailingProfitMethod, OSMA_TrailingStopMethod);
    osma1_sparams.SetMaxSpread(OSMA1_MaxSpread);
    osma1_sparams.SetId(OSMA1);
    return (new Stg_OSMA(osma1_sparams, "OSMA1"));
  }
  static Stg_OSMA *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams osma_iparams(10, INDI_OSMA);
    OsMA_Params osma5_iparams(OSMA_Period_Fast, OSMA_Period_Slow, OSMA_Period_Signal, OSMA_Applied_Price);
    StgParams osma5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_OsMA(osma5_iparams, osma_iparams, cparams5), NULL, NULL);
    osma5_sparams.SetSignals(OSMA5_SignalMethod, OSMA5_OpenCondition1, OSMA5_OpenCondition2, OSMA5_CloseCondition, NULL, OSMA_SignalLevel, NULL);
    osma5_sparams.SetStops(OSMA_TrailingProfitMethod, OSMA_TrailingStopMethod);
    osma5_sparams.SetMaxSpread(OSMA5_MaxSpread);
    osma5_sparams.SetId(OSMA5);
    return (new Stg_OSMA(osma5_sparams, "OSMA5"));
  }
  static Stg_OSMA *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams osma_iparams(10, INDI_OSMA);
    OsMA_Params osma15_iparams(OSMA_Period_Fast, OSMA_Period_Slow, OSMA_Period_Signal, OSMA_Applied_Price);
    StgParams osma15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_OsMA(osma15_iparams, osma_iparams, cparams15), NULL, NULL);
    osma15_sparams.SetSignals(OSMA15_SignalMethod, OSMA15_OpenCondition1, OSMA15_OpenCondition2, OSMA15_CloseCondition, NULL, OSMA_SignalLevel, NULL);
    osma15_sparams.SetStops(OSMA_TrailingProfitMethod, OSMA_TrailingStopMethod);
    osma15_sparams.SetMaxSpread(OSMA15_MaxSpread);
    osma15_sparams.SetId(OSMA15);
    return (new Stg_OSMA(osma15_sparams, "OSMA15"));
  }
  static Stg_OSMA *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams osma_iparams(10, INDI_OSMA);
    OsMA_Params osma30_iparams(OSMA_Period_Fast, OSMA_Period_Slow, OSMA_Period_Signal, OSMA_Applied_Price);
    StgParams osma30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_OsMA(osma30_iparams, osma_iparams, cparams30), NULL, NULL);
    osma30_sparams.SetSignals(OSMA30_SignalMethod, OSMA30_OpenCondition1, OSMA30_OpenCondition2, OSMA30_CloseCondition, NULL, OSMA_SignalLevel, NULL);
    osma30_sparams.SetStops(OSMA_TrailingProfitMethod, OSMA_TrailingStopMethod);
    osma30_sparams.SetMaxSpread(OSMA30_MaxSpread);
    osma30_sparams.SetId(OSMA30);
    return (new Stg_OSMA(osma30_sparams, "OSMA30"));
  }
  static Stg_OSMA *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if OSMA indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double osma_0 = ((Indi_OsMA *) this.Data()).GetValue(0);
    double osma_1 = ((Indi_OsMA *) this.Data()).GetValue(1);
    double osma_2 = ((Indi_OsMA *) this.Data()).GetValue(2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      /*
        //22. Moving Average of Oscillator (MACD histogram) (1)
        //Buy: histogram is below zero and changes falling direction into rising (5 columns are taken)
        //Sell: histogram is above zero and changes its rising direction into falling (5 columns are taken)
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f22=1;}
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f22=-1;}
      */

      /*
        //23. Moving Average of Oscillator (MACD histogram) (2)
        //To use the indicator it should be correlated with another trend indicator
        //Flag 23 is 1, when MACD histogram recommends to buy (i.e. histogram is sloping upwards)
        //Flag 23 is -1, when MACD histogram recommends to sell (i.e. histogram is sloping downwards)
        //3 columns are taken for calculation
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f23=1;}
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f23=-1;}
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

