//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements BWMFI strategy based on the Market Facilitation Index indicator
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_BWMFI.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __BWMFI_Parameters__ = "-- BWMFI strategy params --";  // >>> BWMFI <<<
INPUT int BWMFI_Shift = 0;                                          // Shift (relative to the current bar, 0 - default)
INPUT int BWMFI_SignalOpenMethod = 0;                               // Signal open method (0-1)
INPUT double BWMFI_SignalOpenLevel = 0.0004;                        // Signal open level (>0.0001)
INPUT int BWMFI_SignalOpenFilterMethod = 0;                        // Signal open filter method
INPUT int BWMFI_SignalOpenBoostMethod = 0;                        // Signal open boost method
INPUT int BWMFI_SignalCloseMethod = 0;                              // Signal close method
INPUT double BWMFI_SignalCloseLevel = 0.0004;                       // Signal close level (>0.0001)
INPUT int BWMFI_PriceLimitMethod = 0;                               // Price limit method
INPUT double BWMFI_PriceLimitLevel = 0;                             // Price limit level
INPUT double BWMFI_MaxSpread = 6.0;                                 // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_BWMFI_Params : Stg_Params {
  int BWMFI_Shift;
  int BWMFI_SignalOpenMethod;
  double BWMFI_SignalOpenLevel;
  int BWMFI_SignalOpenFilterMethod;
  int BWMFI_SignalOpenBoostMethod;
  int BWMFI_SignalCloseMethod;
  double BWMFI_SignalCloseLevel;
  int BWMFI_PriceLimitMethod;
  double BWMFI_PriceLimitLevel;
  double BWMFI_MaxSpread;

  // Constructor: Set default param values.
  Stg_BWMFI_Params()
      : BWMFI_Shift(::BWMFI_Shift),
        BWMFI_SignalOpenMethod(::BWMFI_SignalOpenMethod),
        BWMFI_SignalOpenLevel(::BWMFI_SignalOpenLevel),
        BWMFI_SignalOpenFilterMethod(::BWMFI_SignalOpenFilterMethod),
        BWMFI_SignalOpenBoostMethod(::BWMFI_SignalOpenBoostMethod),
        BWMFI_SignalCloseMethod(::BWMFI_SignalCloseMethod),
        BWMFI_SignalCloseLevel(::BWMFI_SignalCloseLevel),
        BWMFI_PriceLimitMethod(::BWMFI_PriceLimitMethod),
        BWMFI_PriceLimitLevel(::BWMFI_PriceLimitLevel),
        BWMFI_MaxSpread(::BWMFI_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_BWMFI : public Strategy {
 public:
  Stg_BWMFI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_BWMFI *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_BWMFI_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_BWMFI_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_BWMFI_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_BWMFI_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_BWMFI_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_BWMFI_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_BWMFI_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    IndicatorParams bwmfi_iparams(10, INDI_BWMFI);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_BWMFI(bwmfi_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.BWMFI_SignalOpenMethod, _params.BWMFI_SignalOpenLevel, _params.BWMFI_SignalOpenFilterMethod, _params.BWMFI_SignalOpenBoostMethod, _params.BWMFI_SignalCloseMethod,
                       _params.BWMFI_SignalCloseLevel);
    sparams.SetMaxSpread(_params.BWMFI_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_BWMFI(sparams, "BWMFI");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double bwmfi_0 = ((Indi_BWMFI *)this.Data()).GetValue(0);
    double bwmfi_1 = ((Indi_BWMFI *)this.Data()).GetValue(1);
    double bwmfi_2 = ((Indi_BWMFI *)this.Data()).GetValue(2);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        /*
          bool _result = BWMFI_0[LINE_LOWER] != 0.0 || BWMFI_1[LINE_LOWER] != 0.0 || BWMFI_2[LINE_LOWER] != 0.0;
          if (METHOD(_method, 0)) _result &= Open[CURR] > Close[CURR];
        */
        break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = BWMFI_0[LINE_UPPER] != 0.0 || BWMFI_1[LINE_UPPER] != 0.0 || BWMFI_2[LINE_UPPER] != 0.0;
          if (METHOD(_method, 0)) _result &= Open[CURR] < Close[CURR];
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
