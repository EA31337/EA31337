//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements MA strategy based the Moving Average indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_MA.mqh>
#include <EA31337-classes/Strategy.mqh>

// User params.
string __MA_Parameters__ = "-- MA strategy params --";  // >>> MA <<<
int MA_Period = 12;                                     // Period
int MA_MA_Shift = 0;                                    // MA Shift
ENUM_MA_METHOD MA_Method = 1;                           // MA Method
ENUM_APPLIED_PRICE MA_Applied_Price = 6;                // Applied Price
int MA_Shift = 0;                                       // Shift
int MA_SignalOpenMethod = 48;                           // Signal open method (-127-127)
double MA_SignalOpenLevel = -0.6;                       // Signal open level
int MA_SignalOpenFilterMethod = 0;                       // Signal open filter method
int MA_SignalOpenBoostMethod = 0;                       // Signal open boost method
int MA_SignalCloseMethod = 48;                          // Signal close method (-127-127)
double MA_SignalCloseLevel = -0.6;                      // Signal close level
int MA_PriceLimitMethod = 0;                            // Price limit method
double MA_PriceLimitLevel = 0;                          // Price limit level
double MA_MaxSpread = 6.0;                              // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_MA_Params : Stg_Params {
  unsigned int MA_Period;
  int MA_MA_Shift;
  ENUM_MA_METHOD MA_Method;
  ENUM_APPLIED_PRICE MA_Applied_Price;
  int MA_Shift;
  int MA_SignalOpenMethod;
  double MA_SignalOpenLevel;
  int MA_SignalOpenFilterMethod;
  int MA_SignalOpenBoostMethod;
  int MA_SignalCloseMethod;
  double MA_SignalCloseLevel;
  int MA_PriceLimitMethod;
  double MA_PriceLimitLevel;
  double MA_MaxSpread;

  // Constructor: Set default param values.
  Stg_MA_Params()
      : MA_Period(::MA_Period),
        MA_MA_Shift(::MA_MA_Shift),
        MA_Method(::MA_Method),
        MA_Applied_Price(::MA_Applied_Price),
        MA_Shift(::MA_Shift),
        MA_SignalOpenMethod(::MA_SignalOpenMethod),
        MA_SignalOpenLevel(::MA_SignalOpenLevel),
        MA_SignalOpenFilterMethod(::MA_SignalOpenFilterMethod),
        MA_SignalOpenBoostMethod(::MA_SignalOpenBoostMethod),
        MA_SignalCloseMethod(::MA_SignalCloseMethod),
        MA_SignalCloseLevel(::MA_SignalCloseLevel),
        MA_PriceLimitMethod(::MA_PriceLimitMethod),
        MA_PriceLimitLevel(::MA_PriceLimitLevel),
        MA_MaxSpread(::MA_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_MA : public Strategy {
 public:
  Stg_MA(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_MA *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_MA_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_MA_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_MA_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_MA_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_MA_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_MA_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_MA_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    MA_Params ma_params(_params.MA_Period, _params.MA_MA_Shift, _params.MA_Method, _params.MA_Applied_Price);
    IndicatorParams ma_iparams(10, INDI_MA);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_MA(ma_params, ma_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.MA_SignalOpenMethod, _params.MA_SignalOpenLevel, _params.MA_SignalCloseMethod,
_params.MA_SignalOpenFilterMethod, _params.MA_SignalOpenBoostMethod,
                       _params.MA_SignalCloseLevel);
    sparams.SetMaxSpread(_params.MA_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_MA(sparams, "MA");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double ma_0 = ((Indi_MA *)Data()).GetValue(0);
    double ma_1 = ((Indi_MA *)Data()).GetValue(1);
    double ma_2 = ((Indi_MA *)Data()).GetValue(2);
    double gap = _level * Market().GetPipSize();
/*
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = ma_0_fast > ma_0_medium + gap;
        _result &= ma_0_medium > ma_0_slow;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= ma_0_fast > ma_0_slow + gap;
          if (METHOD(_method, 1)) _result &= ma_0_medium > ma_0_slow;
          if (METHOD(_method, 2)) _result &= ma_0_slow > ma_1_slow;
          if (METHOD(_method, 3)) _result &= ma_0_fast > ma_1_fast;
          if (METHOD(_method, 4)) _result &= ma_0_fast - ma_0_medium > ma_0_medium - ma_0_slow;
          if (METHOD(_method, 5)) _result &= (ma_1_medium < ma_1_slow || ma_2_medium < ma_2_slow);
          if (METHOD(_method, 6)) _result &= (ma_1_fast < ma_1_medium || ma_2_fast < ma_2_medium);
        }
        break;
      case ORDER_TYPE_SELL:
        _result = ma_0_fast < ma_0_medium - gap;
        _result &= ma_0_medium < ma_0_slow;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= ma_0_fast < ma_0_slow - gap;
          if (METHOD(_method, 1)) _result &= ma_0_medium < ma_0_slow;
          if (METHOD(_method, 2)) _result &= ma_0_slow < ma_1_slow;
          if (METHOD(_method, 3)) _result &= ma_0_fast < ma_1_fast;
          if (METHOD(_method, 4)) _result &= ma_0_medium - ma_0_fast > ma_0_slow - ma_0_medium;
          if (METHOD(_method, 5)) _result &= (ma_1_medium > ma_1_slow || ma_2_medium > ma_2_slow);
          if (METHOD(_method, 6)) _result &= (ma_1_fast > ma_1_medium || ma_2_fast > ma_2_medium);
        }
        break;
    }
*/
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
