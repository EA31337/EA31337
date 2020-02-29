//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements RSI strategy based on Relative Strength Index indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_RSI.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __RSI_Parameters__ = "-- RSI strategy params --";  // >>> RSI <<<
INPUT int RSI_Period = 2;                                       // Period
INPUT ENUM_APPLIED_PRICE RSI_Applied_Price = 3;                 // Applied Price
INPUT int RSI_Shift = 0;                                        // Shift
INPUT int RSI_SignalOpenMethod = 0;                             // Signal open method (-63-63)
INPUT double RSI_SignalOpenLevel = 36;                          // Signal open level (-49-49)
INPUT int RSI_SignalOpenFilterMethod = 36;                      // Signal open filter method (-49-49)
INPUT int RSI_SignalOpenBoostMethod = 36;                       // Signal open boost method (-49-49)
INPUT int RSI_SignalCloseMethod = 0;                            // Signal close method (-63-63)
INPUT double RSI_SignalCloseLevel = 36;                         // Signal close level (-49-49)
INPUT int RSI_PriceLimitMethod = 0;                             // Price limit method
INPUT double RSI_PriceLimitLevel = 0;                           // Price limit level
INPUT double RSI_MaxSpread = 0;                                 // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_RSI_Params : StgParams {
  unsigned int RSI_Period;
  ENUM_APPLIED_PRICE RSI_Applied_Price;
  int RSI_Shift;
  int RSI_SignalOpenMethod;
  double RSI_SignalOpenLevel;
  int RSI_SignalOpenFilterMethod;
  int RSI_SignalOpenBoostMethod;
  int RSI_SignalCloseMethod;
  double RSI_SignalCloseLevel;
  int RSI_PriceLimitMethod;
  double RSI_PriceLimitLevel;
  double RSI_MaxSpread;

  // Constructor: Set default param values.
  Stg_RSI_Params()
      : RSI_Period(::RSI_Period),
        RSI_Applied_Price(::RSI_Applied_Price),
        RSI_Shift(::RSI_Shift),
        RSI_SignalOpenMethod(::RSI_SignalOpenMethod),
        RSI_SignalOpenLevel(::RSI_SignalOpenLevel),
        RSI_SignalOpenFilterMethod(::RSI_SignalOpenFilterMethod),
        RSI_SignalOpenBoostMethod(::RSI_SignalOpenBoostMethod),
        RSI_SignalCloseMethod(::RSI_SignalCloseMethod),
        RSI_SignalCloseLevel(::RSI_SignalCloseLevel),
        RSI_PriceLimitMethod(::RSI_PriceLimitMethod),
        RSI_PriceLimitLevel(::RSI_PriceLimitLevel),
        RSI_MaxSpread(::RSI_MaxSpread) {}
  void Init() {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_RSI : public Strategy {
 public:
  Stg_RSI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  /**
   * Initialize strategy's instance.
   */
  static Stg_RSI *Init(ENUM_TIMEFRAMES _tf = NULL, unsigned long _magic_no = 0, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_RSI_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_RSI_Params>(_params, _tf, stg_rsi_m1, stg_rsi_m5, stg_rsi_m15, stg_rsi_m30, stg_rsi_h1,
                                    stg_rsi_h4, stg_rsi_h4);
    }
    // Initialize strategy parameters.
    RSIParams rsi_params(_params.RSI_Period, _params.RSI_Applied_Price);
    rsi_params.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_RSI(rsi_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no > 0 ? _magic_no : rand());
    sparams.SetSignals(_params.RSI_SignalOpenMethod, _params.RSI_SignalOpenLevel, _params.RSI_SignalCloseMethod,
                       _params.RSI_SignalOpenFilterMethod, _params.RSI_SignalOpenBoostMethod,
                       _params.RSI_SignalCloseLevel);
    sparams.SetPriceLimits(_params.RSI_PriceLimitMethod, _params.RSI_PriceLimitLevel);
    sparams.SetMaxSpread(_params.RSI_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_RSI(sparams, "RSI");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, double _level) {
    bool _result = false;
    double rsi_0 = ((Indi_RSI *)this.Data()).GetValue(0);
    double rsi_1 = ((Indi_RSI *)this.Data()).GetValue(1);
    double rsi_2 = ((Indi_RSI *)this.Data()).GetValue(2);
    bool is_valid = fmin(fmin(rsi_0, rsi_1), rsi_2) > 0;
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = rsi_0 > 0 && rsi_0 < (50 - _level);
        if (_method != 0) {
          _result &= is_valid;
          if (METHOD(_method, 0)) _result &= rsi_0 < rsi_1;
          if (METHOD(_method, 1)) _result &= rsi_1 < rsi_2;
          if (METHOD(_method, 2)) _result &= rsi_1 < (50 - _level);
          if (METHOD(_method, 3)) _result &= rsi_2 < (50 - _level);
          if (METHOD(_method, 4)) _result &= rsi_0 - rsi_1 > rsi_1 - rsi_2;
          if (METHOD(_method, 5)) _result &= rsi_2 > 50;
        }
        break;
      case ORDER_TYPE_SELL:
        _result = rsi_0 > 0 && rsi_0 > (50 + _level);
        if (_method != 0) {
          _result &= is_valid;
          if (METHOD(_method, 0)) _result &= rsi_0 > rsi_1;
          if (METHOD(_method, 1)) _result &= rsi_1 > rsi_2;
          if (METHOD(_method, 2)) _result &= rsi_1 > (50 + _level);
          if (METHOD(_method, 3)) _result &= rsi_2 > (50 + _level);
          if (METHOD(_method, 4)) _result &= rsi_1 - rsi_0 > rsi_2 - rsi_1;
          if (METHOD(_method, 5)) _result &= rsi_2 < 50;
        }
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
  bool SignalClose(ENUM_ORDER_TYPE _cmd, int _method, double _level) {
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
