//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Ichimoku strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Ichimoku.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
string __Ichimoku_Parameters__ = "-- Settings for the Ichimoku Kinko Hyo indicator --"; // >>> ICHIMOKU <<<
uint Ichimoku_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
ENUM_TRAIL_TYPE Ichimoku_TrailingStopMethod = (ENUM_TRAIL_TYPE)22; // Trail stop method
ENUM_TRAIL_TYPE Ichimoku_TrailingProfitMethod = (ENUM_TRAIL_TYPE)1; // Trail profit method
int Ichimoku_Period_Tenkan_Sen = 9; // Period Tenkan Sen
int Ichimoku_Period_Kijun_Sen = 26; // Period Kijun Sen
int Ichimoku_Period_Senkou_Span_B = 52; // Period Senkou Span B
double Ichimoku_SignalLevel = 0.00000000; // Signal level
int Ichimoku1_SignalMethod = 0; // Signal method for M1 (0-
int Ichimoku5_SignalMethod = 0; // Signal method for M5 (0-
int Ichimoku15_SignalMethod = 0; // Signal method for M15 (0-
int Ichimoku30_SignalMethod = 0; // Signal method for M30 (0-
int Ichimoku1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Ichimoku1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Ichimoku1_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M1
int Ichimoku5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Ichimoku5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Ichimoku5_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M5
int Ichimoku15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Ichimoku15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Ichimoku15_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M15
int Ichimoku30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Ichimoku30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Ichimoku30_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M30
double Ichimoku1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Ichimoku5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Ichimoku15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Ichimoku30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Ichimoku : public Strategy {

  public:

  void Stg_Ichimoku(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Ichimoku *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams ichimoku_iparams(10, INDI_ICHIMOKU);
    Ichimoku_Params ichimoku1_iparams(Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B);
    StgParams ichimoku1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Ichimoku(ichimoku1_iparams, ichimoku_iparams, cparams1), NULL, NULL);
    ichimoku1_sparams.SetSignals(Ichimoku1_SignalMethod, Ichimoku1_OpenCondition1, Ichimoku1_OpenCondition2, Ichimoku1_CloseCondition, NULL, Ichimoku_SignalLevel, NULL);
    ichimoku1_sparams.SetStops(Ichimoku_TrailingProfitMethod, Ichimoku_TrailingStopMethod);
    ichimoku1_sparams.SetMaxSpread(Ichimoku1_MaxSpread);
    ichimoku1_sparams.SetId(ICHIMOKU1);
    return (new Stg_Ichimoku(ichimoku1_sparams, "Ichimoku1"));
  }
  static Stg_Ichimoku *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams ichimoku_iparams(10, INDI_ICHIMOKU);
    Ichimoku_Params ichimoku5_iparams(Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B);
    StgParams ichimoku5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Ichimoku(ichimoku5_iparams, ichimoku_iparams, cparams5), NULL, NULL);
    ichimoku5_sparams.SetSignals(Ichimoku5_SignalMethod, Ichimoku5_OpenCondition1, Ichimoku5_OpenCondition2, Ichimoku5_CloseCondition, NULL, Ichimoku_SignalLevel, NULL);
    ichimoku5_sparams.SetStops(Ichimoku_TrailingProfitMethod, Ichimoku_TrailingStopMethod);
    ichimoku5_sparams.SetMaxSpread(Ichimoku5_MaxSpread);
    ichimoku5_sparams.SetId(ICHIMOKU5);
    return (new Stg_Ichimoku(ichimoku5_sparams, "Ichimoku5"));
  }
  static Stg_Ichimoku *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams ichimoku_iparams(10, INDI_ICHIMOKU);
    Ichimoku_Params ichimoku15_iparams(Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B);
    StgParams ichimoku15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Ichimoku(ichimoku15_iparams, ichimoku_iparams, cparams15), NULL, NULL);
    ichimoku15_sparams.SetSignals(Ichimoku15_SignalMethod, Ichimoku15_OpenCondition1, Ichimoku15_OpenCondition2, Ichimoku15_CloseCondition, NULL, Ichimoku_SignalLevel, NULL);
    ichimoku15_sparams.SetStops(Ichimoku_TrailingProfitMethod, Ichimoku_TrailingStopMethod);
    ichimoku15_sparams.SetMaxSpread(Ichimoku15_MaxSpread);
    ichimoku15_sparams.SetId(ICHIMOKU15);
    return (new Stg_Ichimoku(ichimoku15_sparams, "Ichimoku15"));
  }
  static Stg_Ichimoku *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams ichimoku_iparams(10, INDI_ICHIMOKU);
    Ichimoku_Params ichimoku30_iparams(Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B);
    StgParams ichimoku30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Ichimoku(ichimoku30_iparams, ichimoku_iparams, cparams30), NULL, NULL);
    ichimoku30_sparams.SetSignals(Ichimoku30_SignalMethod, Ichimoku30_OpenCondition1, Ichimoku30_OpenCondition2, Ichimoku30_CloseCondition, NULL, Ichimoku_SignalLevel, NULL);
    ichimoku30_sparams.SetStops(Ichimoku_TrailingProfitMethod, Ichimoku_TrailingStopMethod);
    ichimoku30_sparams.SetMaxSpread(Ichimoku30_MaxSpread);
    ichimoku30_sparams.SetId(ICHIMOKU30);
    return (new Stg_Ichimoku(ichimoku30_sparams, "Ichimoku30"));
  }
  static Stg_Ichimoku *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Ichimoku indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double ichimoku_0_tenkan_sen    = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_TENKANSEN, 0);
    double ichimoku_0_kijun_sen     = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_KIJUNSEN, 0);
    double ichimoku_0_senkou_span_a = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_SENKOUSPANA, 0);
    double ichimoku_0_senkou_span_b = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_SENKOUSPANB, 0);
    double ichimoku_0_chikou_span   = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_CHIKOUSPAN, 0);
    double ichimoku_1_tenkan_sen    = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_TENKANSEN, 1);
    double ichimoku_1_kijun_sen     = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_KIJUNSEN, 1);
    double ichimoku_1_senkou_span_a = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_SENKOUSPANA, 1);
    double ichimoku_1_senkou_span_b = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_SENKOUSPANB, 1);
    double ichimoku_1_chikou_span   = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_CHIKOUSPAN, 1);
    double ichimoku_2_tenkan_sen    = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_TENKANSEN, 2);
    double ichimoku_2_kijun_sen     = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_KIJUNSEN, 2);
    double ichimoku_2_senkou_span_a = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_SENKOUSPANA, 2);
    double ichimoku_2_senkou_span_b = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_SENKOUSPANB, 2);
    double ichimoku_2_chikou_span   = ((Indi_Ichimoku *) this.Data()).GetValue(LINE_CHIKOUSPAN, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    switch (cmd) {
      /*
        //15. Ichimoku Kinko Hyo (1)
        //Buy: Price crosses Senkou Span-B upwards; price is outside Senkou Span cloud
        //Sell: Price crosses Senkou Span-B downwards; price is outside Senkou Span cloud
        if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,1)>iClose(NULL,pich2,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0)<=iClose(NULL,pich2,0)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)<iClose(NULL,pich2,0))
        {f15=1;}
        if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,1)<iClose(NULL,pich2,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0)>=iClose(NULL,pich2,0)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)>iClose(NULL,pich2,0))
        {f15=-1;}
      */
      /*
        //16. Ichimoku Kinko Hyo (2)
        //Buy: Tenkan-sen crosses Kijun-sen upwards
        //Sell: Tenkan-sen crosses Kijun-sen downwards
        //VERSION EXISTS, IN THIS CASE PRICE MUSTN'T BE IN THE CLOUD!
        if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,1)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,0)>=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,0))
        {f16=1;}
        if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,1)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,0)<=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,0))
        {f16=-1;}
      */

      /*
        //17. Ichimoku Kinko Hyo (3)
        //Buy: Chinkou Span crosses chart upwards; price is ib the cloud
        //Sell: Chinkou Span crosses chart downwards; price is ib the cloud
        if ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+1)<iClose(NULL,pich2,pkijun+1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+0)>=iClose(NULL,pich2,pkijun+0))&&((iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))||(iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))))
        {f17=1;}
        if ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+1)>iClose(NULL,pich2,pkijun+1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+0)<=iClose(NULL,pich2,pkijun+0))&&((iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))||(iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))))
        {f17=-1;}
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

