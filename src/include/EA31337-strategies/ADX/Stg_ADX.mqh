//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ADX strategy based on the Average Directional Movement Index indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_ADX.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __ADX_Parameters__ = "-- ADX strategy params --";  // >>> ADX <<<
INPUT int ADX_Period = 14;                                      // Averaging period
INPUT ENUM_APPLIED_PRICE ADX_Applied_Price = PRICE_HIGH;        // Applied price.
INPUT int ADX_Shift = 0;                                        // Shift (relative to the current bar, 0 - default)
INPUT int ADX_SignalOpenMethod = 0;                             // Signal open method (0-1)
INPUT double ADX_SignalOpenLevel = 0.0004;                      // Signal open level (>0.0001)
INPUT int ADX_SignalOpenFilterMethod = 0;                       // Signal open filter method
INPUT int ADX_SignalOpenBoostMethod = 0;                        // Signal open boost method
INPUT int ADX_SignalCloseMethod = 0;                            // Signal close method
INPUT double ADX_SignalCloseLevel = 0.0004;                     // Signal close level (>0.0001)
INPUT int ADX_PriceLimitMethod = 0;                             // Price limit method
INPUT double ADX_PriceLimitLevel = 0;                           // Price limit level
INPUT double ADX_MaxSpread = 6.0;                               // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_ADX_Params : Stg_Params {
  unsigned int ADX_Period;
  ENUM_APPLIED_PRICE ADX_Applied_Price;
  int ADX_Shift;
  int ADX_SignalOpenMethod;
  double ADX_SignalOpenLevel;
  int ADX_SignalOpenFilterMethod;
  int ADX_SignalOpenBoostMethod;
  int ADX_SignalCloseMethod;
  double ADX_SignalCloseLevel;
  int ADX_PriceLimitMethod;
  double ADX_PriceLimitLevel;
  double ADX_MaxSpread;

  // Constructor: Set default param values.
  Stg_ADX_Params()
      : ADX_Period(::ADX_Period),
        ADX_Applied_Price(::ADX_Applied_Price),
        ADX_Shift(::ADX_Shift),
        ADX_SignalOpenMethod(::ADX_SignalOpenMethod),
        ADX_SignalOpenLevel(::ADX_SignalOpenLevel),
        ADX_SignalOpenFilterMethod(::ADX_SignalOpenFilterMethod),
        ADX_SignalOpenBoostMethod(::ADX_SignalOpenBoostMethod),
        ADX_SignalCloseMethod(::ADX_SignalCloseMethod),
        ADX_SignalCloseLevel(::ADX_SignalCloseLevel),
        ADX_PriceLimitMethod(::ADX_PriceLimitMethod),
        ADX_PriceLimitLevel(::ADX_PriceLimitLevel),
        ADX_MaxSpread(::ADX_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_ADX : public Strategy {
 public:
  Stg_ADX(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_ADX *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_ADX_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_ADX_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_ADX_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_ADX_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_ADX_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_ADX_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_ADX_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    ADX_Params adx_params(_params.ADX_Period, _params.ADX_Applied_Price);
    IndicatorParams adx_iparams(10, INDI_ADX);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_ADX(adx_params, adx_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.ADX_SignalOpenMethod, _params.ADX_SignalOpenLevel, _params.ADX_SignalOpenFilterMethod,
                       _params.ADX_SignalOpenBoostMethod, _params.ADX_SignalCloseMethod, _params.ADX_SignalCloseLevel);
    sparams.SetMaxSpread(_params.ADX_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_ADX(sparams, "ADX");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double adx_0_main = ((Indi_ADX *)this.Data()).GetValue(LINE_MAIN_ADX, 0);
    double adx_0_plusdi = ((Indi_ADX *)this.Data()).GetValue(LINE_PLUSDI, 0);
    double adx_0_minusdi = ((Indi_ADX *)this.Data()).GetValue(LINE_MINUSDI, 0);
    double adx_1_main = ((Indi_ADX *)this.Data()).GetValue(LINE_MAIN_ADX, 1);
    double adx_1_plusdi = ((Indi_ADX *)this.Data()).GetValue(LINE_PLUSDI, 1);
    double adx_1_minusdi = ((Indi_ADX *)this.Data()).GetValue(LINE_MINUSDI, 1);
    double adx_2_main = ((Indi_ADX *)this.Data()).GetValue(LINE_MAIN_ADX, 2);
    double adx_2_plusdi = ((Indi_ADX *)this.Data()).GetValue(LINE_PLUSDI, 2);
    double adx_2_minusdi = ((Indi_ADX *)this.Data()).GetValue(LINE_MINUSDI, 2);
    switch (_cmd) {
      // Buy: +DI line is above -DI line, ADX is more than a certain value and grows (i.e. trend strengthens).
      case ORDER_TYPE_BUY:
        _result = adx_0_minusdi < adx_0_plusdi && adx_0_main >= _level;
        if (METHOD(_method, 0)) _result &= adx_0_main > adx_1_main;
        if (METHOD(_method, 1)) _result &= adx_1_main > adx_2_main;
        break;
      // Sell: -DI line is above +DI line, ADX is more than a certain value and grows (i.e. trend strengthens).
      case ORDER_TYPE_SELL:
        _result = adx_0_minusdi > adx_0_plusdi && adx_0_main >= _level;
        if (METHOD(_method, 0)) _result &= adx_0_main > adx_1_main;
        if (METHOD(_method, 1)) _result &= adx_1_main > adx_2_main;
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