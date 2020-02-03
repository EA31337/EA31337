//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements WPR strategy based on the Larry Williams' Percent Range indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_WPR.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __WPR_Parameters__ = "-- WPR strategy params --";  // >>> WPR <<<
INPUT int WPR_Period = 11;                                      // Period
INPUT int WPR_Shift = 0;                                        // Shift
INPUT int WPR_SignalOpenMethod = -46;                           // Signal open method (-63-63)
INPUT double WPR_SignalOpenLevel = 20;                             // Signal open level
INPUT int WPR_SignalOpenFilterMethod = 20;                             // Signal open filter method
INPUT int WPR_SignalOpenBoostMethod = 20;                             // Signal open boost method
INPUT int WPR_SignalCloseMethod = -46;                          // Signal close method (-63-63)
INPUT int WPR_SignalCloseLevel = 20;                            // Signal close level
INPUT int WPR_PriceLimitMethod = 0;                             // Price limit method
INPUT double WPR_PriceLimitLevel = 0;                           // Price limit level
INPUT double WPR_MaxSpread = 6.0;                               // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_WPR_Params : Stg_Params {
  unsigned int WPR_Period;
  int WPR_Shift;
  int WPR_SignalOpenMethod;
  double WPR_SignalOpenLevel;
  int WPR_SignalOpenFilterMethod;
  int WPR_SignalOpenBoostMethod;
  int WPR_SignalCloseMethod;
  double WPR_SignalCloseLevel;
  int WPR_PriceLimitMethod;
  double WPR_PriceLimitLevel;
  double WPR_MaxSpread;

  // Constructor: Set default param values.
  Stg_WPR_Params()
      : WPR_Period(::WPR_Period),
        WPR_Shift(::WPR_Shift),
        WPR_SignalOpenMethod(::WPR_SignalOpenMethod),
        WPR_SignalOpenLevel(::WPR_SignalOpenLevel),
        WPR_SignalOpenFilterMethod(::WPR_SignalOpenFilterMethod),
        WPR_SignalOpenBoostMethod(::WPR_SignalOpenBoostMethod),
        WPR_SignalCloseMethod(::WPR_SignalCloseMethod),
        WPR_SignalCloseLevel(::WPR_SignalCloseLevel),
        WPR_PriceLimitMethod(::WPR_PriceLimitMethod),
        WPR_PriceLimitLevel(::WPR_PriceLimitLevel),
        WPR_MaxSpread(::WPR_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_WPR : public Strategy {
 public:
  Stg_WPR(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_WPR *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_WPR_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_WPR_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_WPR_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_WPR_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_WPR_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_WPR_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_WPR_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    WPR_Params wpr_params(_params.WPR_Period);
    IndicatorParams wpr_iparams(10, INDI_WPR);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_WPR(wpr_params, wpr_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.WPR_SignalOpenMethod, _params.WPR_SignalOpenLevel, _params.WPR_SignalCloseMethod,
_params.WPR_SignalOpenFilterMethod, _params.WPR_SignalOpenBoostMethod,
                       _params.WPR_SignalCloseLevel);
    sparams.SetMaxSpread(_params.WPR_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_WPR(sparams, "WPR");
    return _strat;
  }

  /**
   * Check if WPR indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double wpr_0 = ((Indi_WPR *)this.Data()).GetValue(0);
    double wpr_1 = ((Indi_WPR *)this.Data()).GetValue(1);
    double wpr_2 = ((Indi_WPR *)this.Data()).GetValue(2);

    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = wpr_0 > 50 + _level;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= wpr_0 < wpr_1;
          if (METHOD(_method, 1)) _result &= wpr_1 < wpr_2;
          if (METHOD(_method, 2)) _result &= wpr_1 > 50 + _level;
          if (METHOD(_method, 3)) _result &= wpr_2 > 50 + _level;
          if (METHOD(_method, 4)) _result &= wpr_1 - wpr_0 > wpr_2 - wpr_1;
          if (METHOD(_method, 5)) _result &= wpr_1 > 50 + _level + _level / 2;
        }
        /* @todo
           //30. Williams Percent Range
           //Buy: crossing -80 upwards
           //Sell: crossing -20 downwards
           if (iWPR(NULL,piwpr,piwprbar,1)<-80&&iWPR(NULL,piwpr,piwprbar,0)>=-80)
           {f30=1;}
           if (iWPR(NULL,piwpr,piwprbar,1)>-20&&iWPR(NULL,piwpr,piwprbar,0)<=-20)
           {f30=-1;}
        */
        break;
      case ORDER_TYPE_SELL:
        _result = wpr_0 < 50 - _level;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= wpr_0 > wpr_1;
          if (METHOD(_method, 1)) _result &= wpr_1 > wpr_2;
          if (METHOD(_method, 2)) _result &= wpr_1 < 50 - _level;
          if (METHOD(_method, 3)) _result &= wpr_2 < 50 - _level;
          if (METHOD(_method, 4)) _result &= wpr_0 - wpr_1 > wpr_1 - wpr_2;
          if (METHOD(_method, 5)) _result &= wpr_1 > 50 - _level - _level / 2;
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
    switch (_method) {
      case 0: {
        // @todo
      }
    }
    return _result;
  }
};
