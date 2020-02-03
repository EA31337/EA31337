//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Awesome strategy based on for the Awesome oscillator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_AO.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __Awesome_Parameters__ = "-- Awesome strategy params --";  // >>> Awesome <<<
INPUT int Awesome_Shift = 0;                     // Shift (relative to the current bar, 0 - default)
INPUT int Awesome_SignalOpenMethod = 0;          // Signal open method (0-1)
INPUT double Awesome_SignalOpenLevel = 0.0004;   // Signal open level (>0.0001)
INPUT int Awesome_SignalOpenFilterMethod = 0;          // Signal open filter method (0-1)
INPUT int Awesome_SignalOpenBoostMethod = 0;          // Signal open boost method (0-1)
INPUT double Awesome_SignalCloseLevel = 0.0004;  // Signal close level (>0.0001)
INPUT int Awesome_SignalCloseMethod = 0;         // Signal close method
INPUT int Awesome_PriceLimitMethod = 0;          // Price limit method
INPUT double Awesome_PriceLimitLevel = 0;        // Price limit level
INPUT double Awesome_MaxSpread = 6.0;            // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_Awesome_Params : Stg_Params {
  unsigned int Awesome_Period;
  ENUM_APPLIED_PRICE Awesome_Applied_Price;
  int Awesome_Shift;
  int Awesome_SignalOpenMethod;
  double Awesome_SignalOpenLevel;
  int Awesome_SignalOpenFilterMethod;
  int Awesome_SignalOpenBoostMethod;
  double Awesome_SignalCloseLevel;
  int Awesome_SignalCloseMethod;
  int Awesome_PriceLimitMethod;
  double Awesome_PriceLimitLevel;
  double Awesome_MaxSpread;

  // Constructor: Set default param values.
  Stg_Awesome_Params()
      : Awesome_Shift(::Awesome_Shift),
        Awesome_SignalOpenMethod(::Awesome_SignalOpenMethod),
        Awesome_SignalOpenLevel(::Awesome_SignalOpenLevel),
        Awesome_SignalOpenFilterMethod(::Awesome_SignalOpenFilterMethod),
        Awesome_SignalOpenBoostMethod(::Awesome_SignalOpenBoostMethod),
        Awesome_SignalCloseMethod(::Awesome_SignalCloseMethod),
        Awesome_SignalCloseLevel(::Awesome_SignalCloseLevel),
        Awesome_PriceLimitMethod(::Awesome_PriceLimitMethod),
        Awesome_PriceLimitLevel(::Awesome_PriceLimitLevel),
        Awesome_MaxSpread(::Awesome_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_Awesome : public Strategy {
 public:
  Stg_Awesome(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Awesome *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_Awesome_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_Awesome_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_Awesome_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_Awesome_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_Awesome_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_Awesome_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_Awesome_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    IndicatorParams ao_iparams(10, INDI_AO);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_AO(ao_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.Awesome_SignalOpenMethod, _params.Awesome_SignalOpenLevel, _params.Awesome_SignalOpenFilterMethod,_params.Awesome_SignalOpenBoostMethod,
                       _params.Awesome_SignalCloseMethod, _params.Awesome_SignalCloseMethod);
    sparams.SetMaxSpread(_params.Awesome_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_Awesome(sparams, "Awesome");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double ao_0 = ((Indi_AO *)this.Data()).GetValue(0);
    double ao_1 = ((Indi_AO *)this.Data()).GetValue(1);
    double ao_2 = ((Indi_AO *)this.Data()).GetValue(2);
    switch (_cmd) {
      /*
        //7. Awesome Oscillator
        //Buy: 1. Signal "saucer" (3 positive columns, medium column is smaller than 2 others); 2. Changing from
        negative values to positive.
        //Sell: 1. Signal "saucer" (3 negative columns, medium column is larger than 2 others); 2. Changing from
        positive values to negative. if
        ((iAO(NULL,piao,2)>0&&iAO(NULL,piao,1)>0&&iAO(NULL,piao,0)>0&&iAO(NULL,piao,1)<iAO(NULL,piao,2)&&iAO(NULL,piao,1)<iAO(NULL,piao,0))||(iAO(NULL,piao,1)<0&&iAO(NULL,piao,0)>0))
        {f7=1;}
        if
        ((iAO(NULL,piao,2)<0&&iAO(NULL,piao,1)<0&&iAO(NULL,piao,0)<0&&iAO(NULL,piao,1)>iAO(NULL,piao,2)&&iAO(NULL,piao,1)>iAO(NULL,piao,0))||(iAO(NULL,piao,1)>0&&iAO(NULL,piao,0)<0))
        {f7=-1;}
      */
      case ORDER_TYPE_BUY:
        /*
          bool _result = Awesome_0[LINE_LOWER] != 0.0 || Awesome_1[LINE_LOWER] != 0.0 || Awesome_2[LINE_LOWER] != 0.0;
          if (METHOD(_method, 0)) _result &= Open[CURR] > Close[CURR];
          if (METHOD(_method, 1)) _result &= !Awesome_On_Sell(tf);
          if (METHOD(_method, 2)) _result &= Awesome_On_Buy(fmin(period + 1, M30));
          if (METHOD(_method, 3)) _result &= Awesome_On_Buy(M30);
          if (METHOD(_method, 4)) _result &= Awesome_2[LINE_LOWER] != 0.0;
          if (METHOD(_method, 5)) _result &= !Awesome_On_Sell(M30);
          */
        break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = Awesome_0[LINE_UPPER] != 0.0 || Awesome_1[LINE_UPPER] != 0.0 || Awesome_2[LINE_UPPER] != 0.0;
          if (METHOD(_method, 0)) _result &= Open[CURR] < Close[CURR];
          if (METHOD(_method, 1)) _result &= !Awesome_On_Buy(tf);
          if (METHOD(_method, 2)) _result &= Awesome_On_Sell(fmin(period + 1, M30));
          if (METHOD(_method, 3)) _result &= Awesome_On_Sell(M30);
          if (METHOD(_method, 4)) _result &= Awesome_2[LINE_UPPER] != 0.0;
          if (METHOD(_method, 5)) _result &= !Awesome_On_Buy(M30);
          */
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
