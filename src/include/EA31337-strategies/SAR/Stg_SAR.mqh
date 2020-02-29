//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements SAR strategy based on the Parabolic Stop and Reverse system indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_SAR.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __SAR_Parameters__ = "-- SAR strategy params --";  // >>> SAR <<<
INPUT double SAR_Step = 0.05;                                   // Step
INPUT double SAR_Maximum_Stop = 0.4;                            // Maximum stop
INPUT int SAR_Shift = 0;                                        // Shift
INPUT int SAR_SignalOpenMethod = 91;                            // Signal open method (-127-127)
INPUT double SAR_SignalOpenLevel = 0;                           // Signal open level
INPUT int SAR_SignalOpenFilterMethod = 0;                       // Signal open filter method
INPUT int SAR_SignalOpenBoostMethod = 0;                        // Signal open boost method
INPUT int SAR_SignalCloseMethod = 91;                           // Signal close method (-127-127)
INPUT double SAR_SignalCloseLevel = 0;                          // Signal close level
INPUT int SAR_PriceLimitMethod = 0;                             // Price limit method
INPUT double SAR_PriceLimitLevel = 0;                           // Price limit level
INPUT double SAR_MaxSpread = 6.0;                               // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_SAR_Params : StgParams {
  double SAR_Step;
  double SAR_Maximum_Stop;
  int SAR_Shift;
  int SAR_SignalOpenMethod;
  double SAR_SignalOpenLevel;
  int SAR_SignalOpenFilterMethod;
  int SAR_SignalOpenBoostMethod;
  int SAR_SignalCloseMethod;
  double SAR_SignalCloseLevel;
  int SAR_PriceLimitMethod;
  double SAR_PriceLimitLevel;
  double SAR_MaxSpread;

  // Constructor: Set default param values.
  Stg_SAR_Params()
      : SAR_Step(::SAR_Step),
        SAR_Maximum_Stop(::SAR_Maximum_Stop),
        SAR_Shift(::SAR_Shift),
        SAR_SignalOpenMethod(::SAR_SignalOpenMethod),
        SAR_SignalOpenLevel(::SAR_SignalOpenLevel),
        SAR_SignalOpenFilterMethod(::SAR_SignalOpenFilterMethod),
        SAR_SignalOpenBoostMethod(::SAR_SignalOpenBoostMethod),
        SAR_SignalCloseMethod(::SAR_SignalCloseMethod),
        SAR_SignalCloseLevel(::SAR_SignalCloseLevel),
        SAR_PriceLimitMethod(::SAR_PriceLimitMethod),
        SAR_PriceLimitLevel(::SAR_PriceLimitLevel),
        SAR_MaxSpread(::SAR_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_SAR : public Strategy {
 public:
  Stg_SAR(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_SAR *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_SAR_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_SAR_Params>(_params, _tf, stg_sar_m1, stg_sar_m5, stg_sar_m15, stg_sar_m30, stg_sar_h1,
                                    stg_sar_h4, stg_sar_h4);
    }
    // Initialize strategy parameters.
    SARParams sar_params(_params.SAR_Step, _params.SAR_Maximum_Stop);
    sar_params.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_SAR(sar_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.SAR_SignalOpenMethod, _params.SAR_SignalOpenLevel, _params.SAR_SignalOpenFilterMethod,
                       _params.SAR_SignalOpenBoostMethod, _params.SAR_SignalCloseMethod, _params.SAR_SignalCloseLevel);
    sparams.SetMaxSpread(_params.SAR_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_SAR(sparams, "SAR");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double open_0 = Chart().GetOpen(0);
    double open_1 = Chart().GetOpen(1);
    double close_0 = Chart().GetClose(0);
    double close_1 = Chart().GetClose(1);
    double sar_0 = ((Indi_SAR *)Data()).GetValue(0);
    double sar_1 = ((Indi_SAR *)Data()).GetValue(1);
    double sar_2 = ((Indi_SAR *)Data()).GetValue(2);
    double gap = _level * Market().GetPipSize();
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = sar_0 + gap < open_0;
        _result |= sar_1 + gap < open_1;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= sar_1 - gap > Market().GetAsk();
          if (METHOD(_method, 1)) _result &= sar_0 < sar_1;
          if (METHOD(_method, 2)) _result &= sar_0 - sar_1 <= sar_1 - sar_2;
          if (METHOD(_method, 3)) _result &= sar_2 > Market().GetAsk();
          if (METHOD(_method, 4)) _result &= sar_0 <= close_0;
          if (METHOD(_method, 5)) _result &= sar_1 > close_1;
          if (METHOD(_method, 6)) _result &= sar_1 > open_1;
        }
        break;
      case ORDER_TYPE_SELL:
        _result = sar_0 - gap > open_0;
        _result |= sar_1 - gap > open_1;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= sar_1 + gap < Market().GetAsk();
          if (METHOD(_method, 1)) _result &= sar_0 > sar_1;
          if (METHOD(_method, 2)) _result &= sar_1 - sar_0 <= sar_2 - sar_1;
          if (METHOD(_method, 3)) _result &= sar_2 < Market().GetAsk();
          if (METHOD(_method, 4)) _result &= sar_0 >= close_0;
          if (METHOD(_method, 5)) _result &= sar_1 < close_1;
          if (METHOD(_method, 6)) _result &= sar_1 < open_1;
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
    double open_0 = Chart().GetOpen(0);
    double sar_0 = ((Indi_SAR *)Data()).GetValue(0);
    double sar_1 = ((Indi_SAR *)Data()).GetValue(1);
    double sar_2 = ((Indi_SAR *)Data()).GetValue(2);
    double gap = _level * Market().GetPipSize();
    double _diff = 0;
    switch (_method) {
      case 0:
        _diff = fabs(open_0 - sar_0);
        _result = open_0 + (_diff + _trail) * _direction;
        break;
      case 1:
        _diff = fmax(fabs(open_0 - fmax(sar_0, sar_1)), fabs(open_0 - fmin(sar_0, sar_1)));
        _result = open_0 + (_diff + _trail) * _direction;
        break;
    }
    return _result;
  }
};
