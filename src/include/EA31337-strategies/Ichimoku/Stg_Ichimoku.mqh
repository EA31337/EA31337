//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Ichimoku strategy based on the Ichimoku Kinko Hyo indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_Ichimoku.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __Ichimoku_Parameters__ = "-- Ichimoku strategy params --";  // >>> ICHIMOKU <<<
INPUT int Ichimoku_Period_Tenkan_Sen = 9;                                 // Period Tenkan Sen
INPUT int Ichimoku_Period_Kijun_Sen = 26;                                 // Period Kijun Sen
INPUT int Ichimoku_Period_Senkou_Span_B = 52;                             // Period Senkou Span B
INPUT int Ichimoku_Shift = 0;                                             // Shift
INPUT int Ichimoku_SignalOpenMethod = 0;                                  // Signal open method (0-
INPUT double Ichimoku_SignalOpenLevel = 0.00000000;                       // Signal open level
INPUT int Ichimoku_SignalOpenFilterMethod = 0.00000000;                   // Signal open filter method
INPUT int Ichimoku_SignalOpenBoostMethod = 0.00000000;                    // Signal open boost method
INPUT int Ichimoku_SignalCloseMethod = 0;                                 // Signal close method (0-
INPUT double Ichimoku_SignalCloseLevel = 0.00000000;                      // Signal close level
INPUT int Ichimoku_PriceLimitMethod = 0;                                  // Price limit method
INPUT double Ichimoku_PriceLimitLevel = 0;                                // Price limit level
INPUT double Ichimoku_MaxSpread = 6.0;                                    // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_Ichimoku_Params : StgParams {
  int Ichimoku_Period_Tenkan_Sen;
  int Ichimoku_Period_Kijun_Sen;
  int Ichimoku_Period_Senkou_Span_B;
  int Ichimoku_Shift;
  int Ichimoku_SignalOpenMethod;
  double Ichimoku_SignalOpenLevel;
  int Ichimoku_SignalOpenFilterMethod;
  int Ichimoku_SignalOpenBoostMethod;
  int Ichimoku_SignalCloseMethod;
  double Ichimoku_SignalCloseLevel;
  int Ichimoku_PriceLimitMethod;
  double Ichimoku_PriceLimitLevel;
  double Ichimoku_MaxSpread;

  // Constructor: Set default param values.
  Stg_Ichimoku_Params()
      : Ichimoku_Period_Tenkan_Sen(::Ichimoku_Period_Tenkan_Sen),
        Ichimoku_Period_Kijun_Sen(::Ichimoku_Period_Kijun_Sen),
        Ichimoku_Period_Senkou_Span_B(::Ichimoku_Period_Senkou_Span_B),
        Ichimoku_Shift(::Ichimoku_Shift),
        Ichimoku_SignalOpenMethod(::Ichimoku_SignalOpenMethod),
        Ichimoku_SignalOpenLevel(::Ichimoku_SignalOpenLevel),
        Ichimoku_SignalOpenFilterMethod(::Ichimoku_SignalOpenFilterMethod),
        Ichimoku_SignalOpenBoostMethod(::Ichimoku_SignalOpenBoostMethod),
        Ichimoku_SignalCloseMethod(::Ichimoku_SignalCloseMethod),
        Ichimoku_SignalCloseLevel(::Ichimoku_SignalCloseLevel),
        Ichimoku_PriceLimitMethod(::Ichimoku_PriceLimitMethod),
        Ichimoku_PriceLimitLevel(::Ichimoku_PriceLimitLevel),
        Ichimoku_MaxSpread(::Ichimoku_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_Ichimoku : public Strategy {
 public:
  Stg_Ichimoku(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Ichimoku *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_Ichimoku_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_Ichimoku_Params>(_params, _tf, stg_ichi_m1, stg_ichi_m5, stg_ichi_m15, stg_ichi_m30,
                                         stg_ichi_h1, stg_ichi_h4, stg_ichi_h4);
    }
    // Initialize strategy parameters.
    IchimokuParams ichi_params(_params.Ichimoku_Period_Tenkan_Sen, _params.Ichimoku_Period_Kijun_Sen,
                                _params.Ichimoku_Period_Senkou_Span_B);
    ichi_params.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_Ichimoku(ichi_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.Ichimoku_SignalOpenMethod, _params.Ichimoku_SignalOpenMethod,
                       _params.Ichimoku_SignalOpenFilterMethod, _params.Ichimoku_SignalOpenBoostMethod,
                       _params.Ichimoku_SignalCloseMethod, _params.Ichimoku_SignalCloseMethod);
    sparams.SetMaxSpread(_params.Ichimoku_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_Ichimoku(sparams, "Ichimoku");
    return _strat;
  }

  /**
   * Check if Ichimoku indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double ichimoku_0_tenkan_sen = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_TENKANSEN, 0);
    double ichimoku_0_kijun_sen = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_KIJUNSEN, 0);
    double ichimoku_0_senkou_span_a = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_SENKOUSPANA, 0);
    double ichimoku_0_senkou_span_b = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_SENKOUSPANB, 0);
    double ichimoku_0_chikou_span = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_CHIKOUSPAN, 0);
    double ichimoku_1_tenkan_sen = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_TENKANSEN, 1);
    double ichimoku_1_kijun_sen = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_KIJUNSEN, 1);
    double ichimoku_1_senkou_span_a = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_SENKOUSPANA, 1);
    double ichimoku_1_senkou_span_b = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_SENKOUSPANB, 1);
    double ichimoku_1_chikou_span = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_CHIKOUSPAN, 1);
    double ichimoku_2_tenkan_sen = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_TENKANSEN, 2);
    double ichimoku_2_kijun_sen = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_KIJUNSEN, 2);
    double ichimoku_2_senkou_span_a = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_SENKOUSPANA, 2);
    double ichimoku_2_senkou_span_b = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_SENKOUSPANB, 2);
    double ichimoku_2_chikou_span = ((Indi_Ichimoku *)this.Data()).GetValue(LINE_CHIKOUSPAN, 2);
    switch (_cmd) {
      /*
        //15. Ichimoku Kinko Hyo (1)
        //Buy: Price crosses Senkou Span-B upwards; price is outside Senkou Span cloud
        //Sell: Price crosses Senkou Span-B downwards; price is outside Senkou Span cloud
        if
        (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,1)>iClose(NULL,pich2,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0)<=iClose(NULL,pich2,0)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)<iClose(NULL,pich2,0))
        {f15=1;}
        if
        (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,1)<iClose(NULL,pich2,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0)>=iClose(NULL,pich2,0)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)>iClose(NULL,pich2,0))
        {f15=-1;}
      */
      /*
        //16. Ichimoku Kinko Hyo (2)
        //Buy: Tenkan-sen crosses Kijun-sen upwards
        //Sell: Tenkan-sen crosses Kijun-sen downwards
        //VEIchimokuON EXISTS, IN THIS CASE PRICE MUSTN'T BE IN THE CLOUD!
        if
        (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,1)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,0)>=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,0))
        {f16=1;}
        if
        (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,1)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,0)<=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,0))
        {f16=-1;}
      */

      /*
        //17. Ichimoku Kinko Hyo (3)
        //Buy: Chinkou Span crosses chart upwards; price is ib the cloud
        //Sell: Chinkou Span crosses chart downwards; price is ib the cloud
        if
        ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+1)<iClose(NULL,pich2,pkijun+1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+0)>=iClose(NULL,pich2,pkijun+0))&&((iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))||(iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))))
        {f17=1;}
        if
        ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+1)>iClose(NULL,pich2,pkijun+1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+0)<=iClose(NULL,pich2,pkijun+0))&&((iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))||(iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))))
        {f17=-1;}
      */
      case ORDER_TYPE_BUY:
        break;
      case ORDER_TYPE_SELL:
        break;
    }
    return _result;
  }

  /**
   * Check strategy's opening signal additional filter.
   */
  bool SignalOpenFilter(ENUM_ORDER_TYPE _cmd, int _method = 0) {
    bool _result = true;
    if (_method != 0) {
      // if (METHOD(_method, 0)) _result &= Trade().IsTrend(_cmd);
      // if (METHOD(_method, 1)) _result &= Trade().IsPivot(_cmd);
      // if (METHOD(_method, 2)) _result &= Trade().IsPeakHours(_cmd);
      // if (METHOD(_method, 3)) _result &= Trade().IsRoundNumber(_cmd);
      // if (METHOD(_method, 4)) _result &= Trade().IsHedging(_cmd);
      // if (METHOD(_method, 5)) _result &= Trade().IsPeakBar(_cmd);
    }
    return _result;
  }

  /**
   * Gets strategy's lot size boost (when enabled).
   */
  double SignalOpenBoost(ENUM_ORDER_TYPE _cmd, int _method = 0) {
    bool _result = 1.0;
    if (_method != 0) {
      // if (METHOD(_method, 0)) if (Trade().IsTrend(_cmd)) _result *= 1.1;
      // if (METHOD(_method, 1)) if (Trade().IsPivot(_cmd)) _result *= 1.1;
      // if (METHOD(_method, 2)) if (Trade().IsPeakHours(_cmd)) _result *= 1.1;
      // if (METHOD(_method, 3)) if (Trade().IsRoundNumber(_cmd)) _result *= 1.1;
      // if (METHOD(_method, 4)) if (Trade().IsHedging(_cmd)) _result *= 1.1;
      // if (METHOD(_method, 5)) if (Trade().IsPeakBar(_cmd)) _result *= 1.1;
    }
    return _result;
  }

  /**
   * Check strategy's closing signal.
   */
  bool SignalClose(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    return SignalOpen(Order::NegateOrderType(_cmd), _method, _level);
  }

  /**
   * Gets price limit value for profit take or stop loss.
   */
  double PriceLimit(ENUM_ORDER_TYPE _cmd, ENUM_ORDER_TYPE_VALUE _mode, int _method = 0, double _level = 0.0) {
    double _trail = _level * Market().GetPipSize();
    int _direction = Order::OrderDirection(_cmd) * (_mode == ORDER_TYPE_SL ? -1 : 1);
    double _default_value = Market().GetCloseOffer(_cmd) + _trail * _method * _direction;
    double _result = _default_value;
    switch (_method) {
      case 0: {
        // @todo
      }
    }
    return _result;
  }
};
