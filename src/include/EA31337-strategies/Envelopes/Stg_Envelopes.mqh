//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Envelopes strategy the Envelopes indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_Envelopes.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __Envelopes_Parameters__ = "-- Envelopes strategy params --";  // >>> ENVELOPES <<<
INPUT int Envelopes_MA_Period = 6;                                          // Period
INPUT double Envelopes_Deviation = 0.5;                                     // Deviation for M1
INPUT ENUM_MA_METHOD Envelopes_MA_Method = 3;                               // MA Method
INPUT int Envelopes_MA_Shift = 0;                                           // MA Shift
INPUT ENUM_APPLIED_PRICE Envelopes_Applied_Price = 3;                       // Applied Price
INPUT int Envelopes_Shift = 0;                                              // Shift
INPUT int Envelopes_SignalOpenMethod = 48;                                  // Signal open method (-127-127)
INPUT double Envelopes_SignalOpenLevel = 0;                                 // Signal open level
INPUT int Envelopes_SignalOpenFilterMethod = 0;                             // Signal open filter method
INPUT int Envelopes_SignalOpenBoostMethod = 0;                              // Signal open filter method
INPUT int Envelopes_SignalCloseMethod = 48;                                 // Signal close method (-127-127)
INPUT int Envelopes_SignalCloseLevel = 0;                                   // Signal close level
INPUT int Envelopes_PriceLimitMethod = 0;                                   // Price limit method
INPUT double Envelopes_PriceLimitLevel = 0;                                 // Price limit level
INPUT double Envelopes_MaxSpread = 6.0;                                     // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_Envelopes_Params : Stg_Params {
  int Envelopes_MA_Period;
  double Envelopes_Deviation;
  ENUM_MA_METHOD Envelopes_MA_Method;
  int Envelopes_MA_Shift;
  ENUM_APPLIED_PRICE Envelopes_Applied_Price;
  int Envelopes_Shift;
  int Envelopes_SignalOpenMethod;
  double Envelopes_SignalOpenLevel;
  int Envelopes_SignalOpenFilterMethod;
  int Envelopes_SignalOpenBoostMethod;
  double Envelopes_SignalCloseLevel;
  int Envelopes_SignalCloseMethod;
  int Envelopes_PriceLimitMethod;
  double Envelopes_PriceLimitLevel;
  double Envelopes_MaxSpread;

  // Constructor: Set default param values.
  Stg_Envelopes_Params()
      : Envelopes_MA_Period(::Envelopes_MA_Period),
        Envelopes_Deviation(::Envelopes_Deviation),
        Envelopes_MA_Method(::Envelopes_MA_Method),
        Envelopes_MA_Shift(::Envelopes_MA_Shift),
        Envelopes_Applied_Price(::Envelopes_Applied_Price),
        Envelopes_Shift(::Envelopes_Shift),
        Envelopes_SignalOpenMethod(::Envelopes_SignalOpenMethod),
        Envelopes_SignalOpenLevel(::Envelopes_SignalOpenLevel),
        Envelopes_SignalOpenFilterMethod(::Envelopes_SignalOpenFilterMethod),
        Envelopes_SignalOpenBoostMethod(::Envelopes_SignalOpenBoostMethod),
        Envelopes_SignalCloseMethod(::Envelopes_SignalCloseMethod),
        Envelopes_SignalCloseLevel(::Envelopes_SignalCloseLevel),
        Envelopes_PriceLimitMethod(::Envelopes_PriceLimitMethod),
        Envelopes_PriceLimitLevel(::Envelopes_PriceLimitLevel),
        Envelopes_MaxSpread(::Envelopes_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_Envelopes : public Strategy {
 public:
  Stg_Envelopes(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Envelopes *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_Envelopes_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_Envelopes_Params>(_params, _tf, stg_env_m1, stg_env_m5, stg_env_m15, stg_env_m30, stg_env_h1,
                                          stg_env_h4, stg_env_h4);
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    Envelopes_Params env_params(_params.Envelopes_MA_Period, _params.Envelopes_MA_Shift, _params.Envelopes_MA_Method,
                                _params.Envelopes_Applied_Price, _params.Envelopes_Deviation);
    IndicatorParams env_iparams(10, INDI_ENVELOPES);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_Envelopes(env_params, env_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.Envelopes_SignalOpenMethod, _params.Envelopes_SignalOpenLevel,
                       _params.Envelopes_SignalOpenFilterMethod, _params.Envelopes_SignalOpenBoostMethod,
                       _params.Envelopes_SignalCloseMethod, _params.Envelopes_SignalCloseMethod);
    sparams.SetMaxSpread(_params.Envelopes_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_Envelopes(sparams, "Envelopes");
    return _strat;
  }

  /**
   * Check if Envelopes indicator is on sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double env_0_lower = ((Indi_Envelopes *)this.Data()).GetValue(LINE_LOWER, 0);
    double env_0_upper = ((Indi_Envelopes *)this.Data()).GetValue(LINE_UPPER, 0);
    double env_0_main = (env_0_upper + env_0_lower) / 2;
    double env_1_lower = ((Indi_Envelopes *)this.Data()).GetValue(LINE_LOWER, 1);
    double env_1_upper = ((Indi_Envelopes *)this.Data()).GetValue(LINE_UPPER, 1);
    double env_1_main = (env_1_upper + env_1_lower) / 2;
    double env_2_lower = ((Indi_Envelopes *)this.Data()).GetValue(LINE_LOWER, 2);
    double env_2_upper = ((Indi_Envelopes *)this.Data()).GetValue(LINE_UPPER, 2);
    double env_2_main = (env_2_upper + env_2_lower) / 2;
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = Low[CURR] < env_0_lower || Low[PREV] < env_0_lower;  // price low was below the lower band
        // _result = _result || (env_0_main > env_2_main && Open[CURR] > env_0_upper);
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= Open[CURR] > env_0_lower;  // FIXME
          if (METHOD(_method, 1)) _result &= env_0_main < env_1_main;
          if (METHOD(_method, 2)) _result &= env_0_lower < env_1_lower;
          if (METHOD(_method, 3)) _result &= env_0_upper < env_1_upper;
          if (METHOD(_method, 4)) _result &= env_0_upper - env_0_lower > env_1_upper - env_1_lower;
          if (METHOD(_method, 5)) _result &= this.Chart().GetAsk() < env_0_main;
          if (METHOD(_method, 6)) _result &= Close[CURR] < env_0_upper;
          // if (METHOD(_method, 7)) _result &= _chart.GetAsk() > Close[PREV];
        }
        break;
      case ORDER_TYPE_SELL:
        _result = High[CURR] > env_0_upper || High[PREV] > env_0_upper;  // price high was above the upper band
        // _result = _result || (env_0_main < env_2_main && Open[CURR] < env_0_lower);
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= Open[CURR] < env_0_upper;  // FIXME
          if (METHOD(_method, 1)) _result &= env_0_main > env_1_main;
          if (METHOD(_method, 2)) _result &= env_0_lower > env_1_lower;
          if (METHOD(_method, 3)) _result &= env_0_upper > env_1_upper;
          if (METHOD(_method, 4)) _result &= env_0_upper - env_0_lower > env_1_upper - env_1_lower;
          if (METHOD(_method, 5)) _result &= this.Chart().GetAsk() > env_0_main;
          if (METHOD(_method, 6)) _result &= Close[CURR] > env_0_upper;
          // if (METHOD(_method, 7)) _result &= _chart.GetAsk() < Close[PREV];
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

    double env_0_lower = ((Indi_Envelopes *)this.Data()).GetValue(LINE_LOWER, 0);
    double env_0_upper = ((Indi_Envelopes *)this.Data()).GetValue(LINE_UPPER, 0);
    double env_0_main = (env_0_upper + env_0_lower) / 2;
    double env_1_lower = ((Indi_Envelopes *)this.Data()).GetValue(LINE_LOWER, 1);
    double env_1_upper = ((Indi_Envelopes *)this.Data()).GetValue(LINE_UPPER, 1);
    double env_1_main = (env_1_upper + env_1_lower) / 2;
    double env_2_lower = ((Indi_Envelopes *)this.Data()).GetValue(LINE_LOWER, 2);
    double env_2_upper = ((Indi_Envelopes *)this.Data()).GetValue(LINE_UPPER, 2);
    double env_2_main = (env_2_upper + env_2_lower) / 2;

    double open_curr = Chart().GetOpen();
    double close_curr = Chart().GetClose();
    double ask_curr = Chart().GetAsk();

    switch (_cmd) {
      case ORDER_TYPE_BUY:
        switch (_method) {
          case 0:
            _result = env_2_lower;
            break;
          case 1:
            _result = env_2_lower;
            break;
        }
        break;
      case ORDER_TYPE_SELL:
        switch (_method) {
          case 0:
            _result = env_2_upper;
            break;
          case 1:
            _result = env_2_upper;
            break;
        }
        break;
    }
    return _result;
  }
};
