//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Force strategy for the Force Index indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_Force.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __Force_Parameters__ = "-- Force strategy params --";  // >>> FORCE <<<
INPUT int Force_Period = 38;                                        // Period
INPUT ENUM_MA_METHOD Force_MA_Method = 0;                           // MA Method
INPUT ENUM_APPLIED_PRICE Force_Applied_Price = 2;                   // Applied Price
INPUT int Force_Shift = 1;                                          // Shift (relative to the current bar, 0 - default)
INPUT int Force_SignalOpenMethod = 0;                               // Signal open method (0-
INPUT double Force_SignalOpenLevel = 0;                             // Signal open level
INPUT int Force_SignalOpenFilterMethod = 0;                             // Signal open filter method
INPUT int Force_SignalOpenBoostMethod = 0;                             // Signal open boost method
INPUT int Force_SignalCloseMethod = 0;                              // Signal close method (0-
INPUT double Force_SignalCloseLevel = 0;                            // Signal close level
INPUT int Force_PriceLimitMethod = 0;                               // Price limit method
INPUT double Force_PriceLimitLevel = 0;                             // Price limit level
INPUT double Force_MaxSpread = 6.0;                                 // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_Force_Params : Stg_Params {
  unsigned int Force_Period;
  ENUM_MA_METHOD Force_MA_Method;
  ENUM_APPLIED_PRICE Force_Applied_Price;
  int Force_Shift;
  int Force_SignalOpenMethod;
  double Force_SignalOpenLevel;
  int Force_SignalOpenFilterMethod;
  int Force_SignalOpenBoostMethod;
  int Force_SignalCloseMethod;
  double Force_SignalCloseLevel;
  int Force_PriceLimitMethod;
  double Force_PriceLimitLevel;
  double Force_MaxSpread;

  // Constructor: Set default param values.
  Stg_Force_Params()
      : Force_Period(::Force_Period),
        Force_MA_Method(::Force_MA_Method),
        Force_Applied_Price(::Force_Applied_Price),
        Force_Shift(::Force_Shift),
        Force_SignalOpenMethod(::Force_SignalOpenMethod),
        Force_SignalOpenLevel(::Force_SignalOpenLevel),
        Force_SignalOpenFilterMethod(::Force_SignalOpenFilterMethod),
        Force_SignalOpenBoostMethod(::Force_SignalOpenBoostMethod),
        Force_SignalCloseMethod(::Force_SignalCloseMethod),
        Force_SignalCloseLevel(::Force_SignalCloseLevel),
        Force_PriceLimitMethod(::Force_PriceLimitMethod),
        Force_PriceLimitLevel(::Force_PriceLimitLevel),
        Force_MaxSpread(::Force_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_Force : public Strategy {
 public:
  Stg_Force(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Force *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_Force_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_Force_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_Force_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_Force_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_Force_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_Force_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_Force_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    Force_Params force_params(_params.Force_Period, _params.Force_MA_Method, _params.Force_Applied_Price);
    IndicatorParams force_iparams(10, INDI_FORCE);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_Force(force_params, force_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.Force_SignalOpenMethod, _params.Force_SignalOpenLevel, _params.Force_SignalCloseMethod,
_params.Force_SignalOpenFilterMethod, _params.Force_SignalOpenBoostMethod,
                       _params.Force_SignalCloseLevel);
    sparams.SetMaxSpread(_params.Force_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_Force(sparams, "Force");
    return _strat;
  }

  /**
   * Check if Force Index indicator is on buy or sell.
   *
   * Note: To use the indicator it should be correlated with another trend indicator.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double force_0 = ((Indi_Force *)this.Data()).GetValue(0);
    double force_1 = ((Indi_Force *)this.Data()).GetValue(1);
    double force_2 = ((Indi_Force *)this.Data()).GetValue(2);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // FI recommends to buy (i.e. FI<0).
        _result = force_0 < -_level;
        break;
      case ORDER_TYPE_SELL:
        // FI recommends to sell (i.e. FI>0).
        _result = force_0 > _level;
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
