//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BearsPower strategy based on the Bears Power indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_BearsPower.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __BearsPower_Parameters__ = "-- BearsPower strategy params --";  // >>> BEARS POWER <<<
INPUT int BearsPower_Period = 13;                                             // Period
INPUT ENUM_APPLIED_PRICE BearsPower_Applied_Price = PRICE_CLOSE;              // Applied Price
INPUT int BearsPower_Shift = 0;                         // Shift (relative to the current bar, 0 - default)
INPUT int BearsPower_SignalOpenMethod = 0;              // Signal open method (0-
INPUT double BearsPower_SignalOpenLevel = 0.00000000;   // Signal open level
INPUT int BearsPower_SignalOpenFilterMethod = 0;        // Signal filter method
INPUT int BearsPower_SignalOpenBoostMethod = 0;         // Signal boost method
INPUT int BearsPower_SignalCloseMethod = 0;             // Signal close method
INPUT double BearsPower_SignalCloseLevel = 0.00000000;  // Signal close level
INPUT int BearsPower_PriceLimitMethod = 0;              // Price limit method
INPUT double BearsPower_PriceLimitLevel = 0;            // Price limit level
INPUT double BearsPower_MaxSpread = 6.0;                // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_BearsPower_Params : StgParams {
  unsigned int BearsPower_Period;
  ENUM_APPLIED_PRICE BearsPower_Applied_Price;
  int BearsPower_Shift;
  int BearsPower_SignalOpenMethod;
  double BearsPower_SignalOpenLevel;
  int BearsPower_SignalOpenFilterMethod;
  int BearsPower_SignalOpenBoostMethod;
  int BearsPower_SignalCloseMethod;
  double BearsPower_SignalCloseLevel;
  double BearsPower_PriceLimitLevel;
  int BearsPower_PriceLimitMethod;
  double BearsPower_MaxSpread;

  // Constructor: Set default param values.
  Stg_BearsPower_Params()
      : BearsPower_Period(::BearsPower_Period),
        BearsPower_Applied_Price(::BearsPower_Applied_Price),
        BearsPower_Shift(::BearsPower_Shift),
        BearsPower_SignalOpenMethod(::BearsPower_SignalOpenMethod),
        BearsPower_SignalOpenLevel(::BearsPower_SignalOpenLevel),
        BearsPower_SignalOpenFilterMethod(::BearsPower_SignalOpenFilterMethod),
        BearsPower_SignalOpenBoostMethod(::BearsPower_SignalOpenBoostMethod),
        BearsPower_SignalCloseMethod(::BearsPower_SignalCloseMethod),
        BearsPower_SignalCloseLevel(::BearsPower_SignalCloseLevel),
        BearsPower_PriceLimitMethod(::BearsPower_PriceLimitMethod),
        BearsPower_PriceLimitLevel(::BearsPower_PriceLimitLevel),
        BearsPower_MaxSpread(::BearsPower_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_BearsPower : public Strategy {
 public:
  Stg_BearsPower(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BearsPower *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_BearsPower_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_BearsPower_Params>(_params, _tf, stg_bears_m1, stg_bears_m5, stg_bears_m15, stg_bears_m30,
                                           stg_bears_h1, stg_bears_h4, stg_bears_h4);
    }
    // Initialize strategy parameters.
    BearsPowerParams bp_params(_params.BearsPower_Period, _params.BearsPower_Applied_Price);
    bp_params.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_BearsPower(bp_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.BearsPower_SignalOpenMethod, _params.BearsPower_SignalOpenMethod,
                       _params.BearsPower_SignalOpenFilterMethod, _params.BearsPower_SignalOpenBoostMethod,
                       _params.BearsPower_SignalCloseMethod, _params.BearsPower_SignalCloseMethod);
    sparams.SetMaxSpread(_params.BearsPower_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_BearsPower(sparams, "BearsPower");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double bears_0 = ((Indi_BearsPower *)this.Data()).GetValue(0);
    double bears_1 = ((Indi_BearsPower *)this.Data()).GetValue(1);
    double bears_2 = ((Indi_BearsPower *)this.Data()).GetValue(2);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        // @todo
        break;
      case ORDER_TYPE_SELL:
        // @todo
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
