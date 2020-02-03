//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Fractals strategy.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_Fractals.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __Fractals_Parameters__ = "-- Fractals strategy params --";  // >>> FRACTALS <<<
INPUT int Fractals_Shift = 0;                                             // Shift
INPUT int Fractals_SignalOpenMethod = 3;                                  // Signal open method (-3-3)
INPUT double Fractals_SignalOpenLevel = 0;                                   // Signal open level
INPUT int Fractals_SignalOpenFilterMethod = 0;                                   // Signal open filter method
INPUT int Fractals_SignalOpenBoostMethod = 0;                                   // Signal open boost method
INPUT int Fractals_SignalCloseMethod = 3;                                 // Signal close method (-3-3)
INPUT int Fractals_SignalCloseLevel = 0;                                  // Signal close level
INPUT int Fractals_PriceLimitMethod = 0;                                  // Price limit method
INPUT double Fractals_PriceLimitLevel = 0;                                // Price limit level
INPUT double Fractals_MaxSpread = 6.0;                                    // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_Fractals_Params : Stg_Params {
  int Fractals_Shift;
  int Fractals_SignalOpenMethod;
  double Fractals_SignalOpenLevel;
  int Fractals_SignalOpenFilterMethod;
  int Fractals_SignalOpenBoostMethod;
  int Fractals_SignalCloseMethod;
  double Fractals_SignalCloseLevel;
  int Fractals_PriceLimitMethod;
  double Fractals_PriceLimitLevel;
  double Fractals_MaxSpread;

  // Constructor: Set default param values.
  Stg_Fractals_Params()
      : Fractals_Shift(::Fractals_Shift),
        Fractals_SignalOpenMethod(::Fractals_SignalOpenMethod),
        Fractals_SignalOpenLevel(::Fractals_SignalOpenLevel),
        Fractals_SignalOpenFilterMethod(::Fractals_SignalOpenFilterMethod),
        Fractals_SignalOpenBoostMethod(::Fractals_SignalOpenBoostMethod),
        Fractals_SignalCloseMethod(::Fractals_SignalCloseMethod),
        Fractals_SignalCloseLevel(::Fractals_SignalCloseLevel),
        Fractals_PriceLimitMethod(::Fractals_PriceLimitMethod),
        Fractals_PriceLimitLevel(::Fractals_PriceLimitLevel),
        Fractals_MaxSpread(::Fractals_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_Fractals : public Strategy {
 public:
  Stg_Fractals(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Fractals *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_Fractals_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_Fractals_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_Fractals_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_Fractals_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_Fractals_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_Fractals_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_Fractals_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    IndicatorParams fractals_iparams(10, INDI_FRACTALS);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_Fractals(fractals_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.Fractals_SignalOpenMethod, _params.Fractals_SignalOpenMethod,
_params.Fractals_SignalOpenFilterMethod, _params.Fractals_SignalOpenBoostMethod,
                       _params.Fractals_SignalCloseMethod, _params.Fractals_SignalCloseMethod);
    sparams.SetMaxSpread(_params.Fractals_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_Fractals(sparams, "Fractals");
    return _strat;
  }

  /**
   * Check if Fractals indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double fractals_0_lower = ((Indi_Fractals *)this.Data()).GetValue(LINE_LOWER, 0);
    double fractals_0_upper = ((Indi_Fractals *)this.Data()).GetValue(LINE_UPPER, 0);
    double fractals_1_lower = ((Indi_Fractals *)this.Data()).GetValue(LINE_LOWER, 1);
    double fractals_1_upper = ((Indi_Fractals *)this.Data()).GetValue(LINE_UPPER, 1);
    double fractals_2_lower = ((Indi_Fractals *)this.Data()).GetValue(LINE_LOWER, 2);
    double fractals_2_upper = ((Indi_Fractals *)this.Data()).GetValue(LINE_UPPER, 2);
    bool lower = (fractals_0_lower != 0.0 || fractals_1_lower != 0.0 || fractals_2_lower != 0.0);
    bool upper = (fractals_0_upper != 0.0 || fractals_1_upper != 0.0 || fractals_2_upper != 0.0);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = lower;
        if (METHOD(_method, 0)) _result &= Open[CURR] > Close[PREV];
        if (METHOD(_method, 1)) _result &= this.Chart().GetBid() > Open[CURR];
        // if (METHOD(_method, 0)) _result &= !Trade_Fractals(Convert::NegateOrderType(_cmd), PERIOD_M30);
        // if (METHOD(_method, 1)) _result &= !Trade_Fractals(Convert::NegateOrderType(_cmd),
        // Convert::IndexToTf(fmax(index + 1, M30))); if (METHOD(_method, 2)) _result &=
        // !Trade_Fractals(Convert::NegateOrderType(_cmd), Convert::IndexToTf(fmax(index + 2, M30))); if
        // (METHOD(_method, 1)) _result &= !Fractals_On_Sell(tf); if (METHOD(_method, 3)) _result &=
        // Fractals_On_Buy(M30);
        break;
      case ORDER_TYPE_SELL:
        _result = upper;
        if (METHOD(_method, 0)) _result &= Open[CURR] < Close[PREV];
        if (METHOD(_method, 1)) _result &= this.Chart().GetAsk() < Open[CURR];
        // if (METHOD(_method, 0)) _result &= !Trade_Fractals(Convert::NegateOrderType(_cmd), PERIOD_M30);
        // if (METHOD(_method, 1)) _result &= !Trade_Fractals(Convert::NegateOrderType(_cmd),
        // Convert::IndexToTf(fmax(index + 1, M30))); if (METHOD(_method, 2)) _result &=
        // !Trade_Fractals(Convert::NegateOrderType(_cmd), Convert::IndexToTf(fmax(index + 2, M30))); if
        // (METHOD(_method, 1)) _result &= !Fractals_On_Buy(tf); if (METHOD(_method, 3)) _result &=
        // Fractals_On_Sell(M30);
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
