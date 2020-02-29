//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements AD strategy. Based on A/D (Accumulation/Distribution) indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_AD.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __AD_Parameters__ = "-- AD strategy params --";  // >>> AD <<<
INPUT int AD_Shift = 0;                                       // Shift (relative to the current bar, 0 - default)
INPUT int AD_SignalOpenMethod = 0;                            // Signal open method (0-1)
INPUT double AD_SignalOpenLevel = 0.0004;                     // Signal open level (>0.0001)
INPUT int AD_SignalOpenFilterMethod = 0;                      // Signal open filter method
INPUT int AD_SignalOpenBoostMethod = 0;                       // Signal open filter method
INPUT int AD_SignalCloseMethod = 0;                           // Signal close method
INPUT double AD_SignalCloseLevel = 0.0004;                    // Signal close level (>0.0001)
INPUT int AD_PriceLimitMethod = 0;                            // Price limit method
INPUT double AD_PriceLimitLevel = 0;                          // Price limit level
INPUT double AD_MaxSpread = 6.0;                              // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_AD_Params : StgParams {
  unsigned int AD_Period;
  ENUM_APPLIED_PRICE AD_Applied_Price;
  int AD_Shift;
  int AD_SignalOpenMethod;
  double AD_SignalOpenLevel;
  int AD_SignalOpenFilterMethod;
  int AD_SignalOpenBoostMethod;
  int AD_SignalCloseMethod;
  double AD_SignalCloseLevel;
  int AD_PriceLimitMethod;
  double AD_PriceLimitLevel;
  double AD_MaxSpread;

  // Constructor: Set default param values.
  Stg_AD_Params()
      : AD_Shift(::AD_Shift),
        AD_SignalOpenMethod(::AD_SignalOpenMethod),
        AD_SignalOpenLevel(::AD_SignalOpenLevel),
        AD_SignalOpenFilterMethod(::AD_SignalOpenFilterMethod),
        AD_SignalOpenBoostMethod(::AD_SignalOpenBoostMethod),
        AD_SignalCloseMethod(::AD_SignalCloseMethod),
        AD_SignalCloseLevel(::AD_SignalCloseLevel),
        AD_PriceLimitMethod(::AD_PriceLimitMethod),
        AD_PriceLimitLevel(::AD_PriceLimitLevel),
        AD_MaxSpread(::AD_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_AD : public Strategy {
 public:
  Stg_AD(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_AD *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_AD_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_AD_Params>(_params, _tf, stg_ad_m1, stg_ad_m5, stg_ad_m15, stg_ad_m30, stg_ad_h1, stg_ad_h4,
                                   stg_ad_h4);
    }
    // Initialize strategy parameters.
    ADParams ad_params(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_AD(ad_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.AD_SignalOpenMethod, _params.AD_SignalOpenLevel, _params.AD_SignalOpenFilterMethod,
                       _params.AD_SignalOpenBoostMethod, _params.AD_SignalCloseMethod, _params.AD_SignalCloseLevel);
    sparams.SetMaxSpread(_params.AD_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_AD(sparams, "AD");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double ad_0 = ((Indi_AD *)this.Data()).GetValue(0);
    double ad_1 = ((Indi_AD *)this.Data()).GetValue(1);
    double ad_2 = ((Indi_AD *)this.Data()).GetValue(2);
    switch (_cmd) {
      // Buy: indicator growth at downtrend.
      case ORDER_TYPE_BUY:
        _result = ad_0 >= ad_1 + _level && Chart().GetClose(0) <= Chart().GetClose(1);
        if (METHOD(_method, 0)) _result &= Open[CURR] > Close[CURR];
        break;
      // Sell: indicator fall at uptrend.
      case ORDER_TYPE_SELL:
        _result = ad_0 <= ad_1 - _level && Chart().GetClose(0) >= Chart().GetClose(1);
        if (METHOD(_method, 0)) _result &= Open[CURR] < Close[CURR];
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
