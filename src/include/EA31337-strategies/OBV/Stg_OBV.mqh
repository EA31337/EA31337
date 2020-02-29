//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements OBV strategy based on the On Balance Volume indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_OBV.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __OBV_Parameters__ = "-- OBV strategy params --";  // >>> OBV <<<
INPUT ENUM_APPLIED_PRICE OBV_Applied_Price = PRICE_CLOSE;       // Applied Price
INPUT int OBV_Shift = 0;                                        // Shift
INPUT int OBV_SignalOpenMethod = 0;                             // Signal open method (0-
INPUT double OBV_SignalOpenLevel = 0.00000000;                  // Signal open level
INPUT int OBV_SignalOpenFilterMethod = 0.00000000;              // Signal open filter method
INPUT int OBV_SignalOpenBoostMethod = 0.00000000;               // Signal open boost method
INPUT int OBV_SignalCloseMethod = 0;                            // Signal close method (0-
INPUT double OBV_SignalCloseLevel = 0.00000000;                 // Signal close level
INPUT int OBV_PriceLimitMethod = 0;                             // Price limit method
INPUT double OBV_PriceLimitLevel = 0;                           // Price limit level
INPUT double OBV_MaxSpread = 6.0;                               // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_OBV_Params : StgParams {
  ENUM_APPLIED_PRICE OBV_Applied_Price;
  int OBV_Shift;
  int OBV_SignalOpenMethod;
  double OBV_SignalOpenLevel;
  int OBV_SignalOpenFilterMethod;
  int OBV_SignalOpenBoostMethod;
  int OBV_SignalCloseMethod;
  double OBV_SignalCloseLevel;
  int OBV_PriceLimitMethod;
  double OBV_PriceLimitLevel;
  double OBV_MaxSpread;

  // Constructor: Set default param values.
  Stg_OBV_Params()
      : OBV_Applied_Price(::OBV_Applied_Price),
        OBV_Shift(::OBV_Shift),
        OBV_SignalOpenMethod(::OBV_SignalOpenMethod),
        OBV_SignalOpenLevel(::OBV_SignalOpenLevel),
        OBV_SignalOpenFilterMethod(::OBV_SignalOpenFilterMethod),
        OBV_SignalOpenBoostMethod(::OBV_SignalOpenBoostMethod),
        OBV_SignalCloseMethod(::OBV_SignalCloseMethod),
        OBV_SignalCloseLevel(::OBV_SignalCloseLevel),
        OBV_PriceLimitMethod(::OBV_PriceLimitMethod),
        OBV_PriceLimitLevel(::OBV_PriceLimitLevel),
        OBV_MaxSpread(::OBV_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_OBV : public Strategy {
 public:
  Stg_OBV(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_OBV *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_OBV_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_OBV_Params>(_params, _tf, stg_obv_m1, stg_obv_m5, stg_obv_m15, stg_obv_m30, stg_obv_h1,
                                    stg_obv_h4, stg_obv_h4);
    }
    // Initialize strategy parameters.
    OBVParams obv_params(_params.OBV_Applied_Price);
    obv_params.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_OBV(obv_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.OBV_SignalOpenMethod, _params.OBV_SignalOpenLevel, _params.OBV_SignalCloseMethod,
                       _params.OBV_SignalOpenFilterMethod, _params.OBV_SignalOpenBoostMethod,
                       _params.OBV_SignalCloseLevel);
    sparams.SetMaxSpread(_params.OBV_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_OBV(sparams, "OBV");
    return _strat;
  }

  /**
   * Check if OBV indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double obv_0 = ((Indi_OBV *)this.Data()).GetValue(0);
    double obv_1 = ((Indi_OBV *)this.Data()).GetValue(1);
    double obv_2 = ((Indi_OBV *)this.Data()).GetValue(2);
    switch (_cmd) {
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
