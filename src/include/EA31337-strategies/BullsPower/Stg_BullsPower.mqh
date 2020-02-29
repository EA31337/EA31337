//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BullsPower strategy based on the Bulls Power indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_BullsPower.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __BullsPower_Parameters__ = "-- BullsPower strategy params --";  // >>> BULLS POWER <<<
INPUT int BullsPower_Period = 13;                                             // Period
INPUT ENUM_APPLIED_PRICE BullsPower_Applied_Price = PRICE_CLOSE;              // Applied Price
INPUT int BullsPower_Shift = 0;                         // Shift (relative to the current bar, 0 - default)
INPUT int BullsPower_SignalOpenMethod = 0;              // Signal open method (0-
INPUT double BullsPower_SignalOpenLevel = 0.00000000;   // Signal open level
INPUT int BullsPower_SignalOpenFilterMethod = 0;        // Signal filter method
INPUT int BullsPower_SignalOpenBoostMethod = 0;         // Signal boost method
INPUT int BullsPower_SignalCloseMethod = 0;             // Signal close method
INPUT double BullsPower_SignalCloseLevel = 0.00000000;  // Signal close level
INPUT int BullsPower_PriceLimitMethod = 0;              // Price limit method
INPUT double BullsPower_PriceLimitLevel = 0;            // Price limit level
INPUT double BullsPower_MaxSpread = 6.0;                // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_BullsPower_Params : StgParams {
  unsigned int BullsPower_Period;
  ENUM_APPLIED_PRICE BullsPower_Applied_Price;
  int BullsPower_Shift;
  int BullsPower_SignalOpenMethod;
  double BullsPower_SignalOpenLevel;
  int BullsPower_SignalOpenFilterMethod;
  int BullsPower_SignalOpenBoostMethod;
  int BullsPower_SignalCloseMethod;
  double BullsPower_SignalCloseLevel;
  int BullsPower_PriceLimitMethod;
  double BullsPower_PriceLimitLevel;
  double BullsPower_MaxSpread;

  // Constructor: Set default param values.
  Stg_BullsPower_Params()
      : BullsPower_Period(::BullsPower_Period),
        BullsPower_Applied_Price(::BullsPower_Applied_Price),
        BullsPower_Shift(::BullsPower_Shift),
        BullsPower_SignalOpenMethod(::BullsPower_SignalOpenMethod),
        BullsPower_SignalOpenLevel(::BullsPower_SignalOpenLevel),
        BullsPower_SignalOpenFilterMethod(::BullsPower_SignalOpenFilterMethod),
        BullsPower_SignalOpenBoostMethod(::BullsPower_SignalOpenBoostMethod),
        BullsPower_SignalCloseMethod(::BullsPower_SignalCloseMethod),
        BullsPower_SignalCloseLevel(::BullsPower_SignalCloseLevel),
        BullsPower_PriceLimitMethod(::BullsPower_PriceLimitMethod),
        BullsPower_PriceLimitLevel(::BullsPower_PriceLimitLevel),
        BullsPower_MaxSpread(::BullsPower_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_BullsPower : public Strategy {
 public:
  Stg_BullsPower(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BullsPower *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_BullsPower_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_BullsPower_Params>(_params, _tf, stg_bulls_m1, stg_bulls_m5, stg_bulls_m15, stg_bulls_m30,
                                           stg_bulls_h1, stg_bulls_h4, stg_bulls_h4);
    }
    // Initialize strategy parameters.
    BullsPowerParams bp_params(_params.BullsPower_Period, _params.BullsPower_Applied_Price);
    bp_params.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_BullsPower(bp_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.BullsPower_SignalOpenMethod, _params.BullsPower_SignalOpenMethod,
                       _params.BullsPower_SignalOpenFilterMethod, _params.BullsPower_SignalOpenBoostMethod,
                       _params.BullsPower_SignalCloseMethod, _params.BullsPower_SignalCloseMethod);
    sparams.SetMaxSpread(_params.BullsPower_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_BullsPower(sparams, "BullsPower");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double bulls_0 = ((Indi_BullsPower *)this.Data()).GetValue(0);
    double bulls_1 = ((Indi_BullsPower *)this.Data()).GetValue(1);
    double bulls_2 = ((Indi_BullsPower *)this.Data()).GetValue(2);
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
