//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ZigZag strategy based on the ZigZag indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_ZigZag.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __ZigZag_Parameters__ = "-- ZigZag strategy params --";  // >>> ZIGZAG <<<
INPUT int ZigZag_Depth = 0;                                           // Depth
INPUT int ZigZag_Deviation = 0;                                       // Deviation
INPUT int ZigZag_Backstep = 0;                                        // Deviation
INPUT int ZigZag_Shift = 0;                                           // Shift (relative to the current bar)
INPUT int ZigZag_SignalOpenMethod = 0;                                // Signal open method (0-31)
INPUT double ZigZag_SignalOpenLevel = 0.00000000;                     // Signal open level
INPUT int ZigZag_SignalOpenFilterMethod = 0.00000000;                 // Signal open filter method
INPUT int ZigZag_SignalOpenBoostMethod = 0.00000000;                  // Signal open boost method
INPUT int ZigZag_SignalCloseMethod = 0;                               // Signal close method (0-31)
INPUT double ZigZag_SignalCloseLevel = 0.00000000;                    // Signal close level
INPUT int ZigZag_PriceLimitMethod = 0;                                // Price limit method
INPUT double ZigZag_PriceLimitLevel = 0;                              // Price limit level
INPUT double ZigZag_MaxSpread = 6.0;                                  // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_ZigZag_Params : Stg_Params {
  int ZigZag_Depth;
  int ZigZag_Deviation;
  int ZigZag_Backstep;
  int ZigZag_Shift;
  int ZigZag_SignalOpenMethod;
  double ZigZag_SignalOpenLevel;
  int ZigZag_SignalOpenFilterMethod;
  int ZigZag_SignalOpenBoostMethod;
  int ZigZag_SignalCloseMethod;
  double ZigZag_SignalCloseLevel;
  int ZigZag_PriceLimitMethod;
  double ZigZag_PriceLimitLevel;
  double ZigZag_MaxSpread;

  // Constructor: Set default param values.
  Stg_ZigZag_Params()
      : ZigZag_Depth(::ZigZag_Depth),
        ZigZag_Deviation(::ZigZag_Deviation),
        ZigZag_Backstep(::ZigZag_Backstep),
        ZigZag_Shift(::ZigZag_Shift),
        ZigZag_SignalOpenMethod(::ZigZag_SignalOpenMethod),
        ZigZag_SignalOpenLevel(::ZigZag_SignalOpenLevel),
        ZigZag_SignalOpenFilterMethod(::ZigZag_SignalOpenFilterMethod),
        ZigZag_SignalOpenBoostMethod(::ZigZag_SignalOpenBoostMethod),
        ZigZag_SignalCloseMethod(::ZigZag_SignalCloseMethod),
        ZigZag_SignalCloseLevel(::ZigZag_SignalCloseLevel),
        ZigZag_PriceLimitMethod(::ZigZag_PriceLimitMethod),
        ZigZag_PriceLimitLevel(::ZigZag_PriceLimitLevel),
        ZigZag_MaxSpread(::ZigZag_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_ZigZag : public Strategy {
 public:
  Stg_ZigZag(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_ZigZag *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_ZigZag_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_ZigZag_Params>(_params, _tf, stg_zigzag_m1, stg_zigzag_m5, stg_zigzag_m15, stg_zigzag_m30,
                                       stg_zigzag_h1, stg_zigzag_h4, stg_zigzag_h4);
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    ZigZag_Params zz_params(_params.ZigZag_Depth, _params.ZigZag_Deviation, _params.ZigZag_Backstep);
    IndicatorParams zz_iparams(10, INDI_ZIGZAG);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_ZigZag(zz_params, zz_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.ZigZag_SignalOpenMethod, _params.ZigZag_SignalOpenMethod,
                       _params.ZigZag_SignalOpenFilterMethod, _params.ZigZag_SignalOpenBoostMethod,
                       _params.ZigZag_SignalCloseMethod, _params.ZigZag_SignalCloseMethod);
    sparams.SetMaxSpread(_params.ZigZag_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_ZigZag(sparams, "ZigZag");
    return _strat;
  }

  /**
   * Check if ZigZag indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double zigzag_0 = ((Indi_ZigZag *)this.Data()).GetValue(0);
    double zigzag_1 = ((Indi_ZigZag *)this.Data()).GetValue(1);
    double zigzag_2 = ((Indi_ZigZag *)this.Data()).GetValue(2);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        /*
          bool _result = ZigZag_0[LINE_LOWER] != 0.0 || ZigZag_1[LINE_LOWER] != 0.0 || ZigZag_2[LINE_LOWER] != 0.0;
          if (METHOD(_method, 0)) _result &= Open[CURR] > Close[CURR];
          if (METHOD(_method, 1)) _result &= !ZigZag_On_Sell(tf);
          if (METHOD(_method, 2)) _result &= ZigZag_On_Buy(fmin(period + 1, M30));
          if (METHOD(_method, 3)) _result &= ZigZag_On_Buy(M30);
          if (METHOD(_method, 4)) _result &= ZigZag_2[LINE_LOWER] != 0.0;
          if (METHOD(_method, 5)) _result &= !ZigZag_On_Sell(M30);
          */
        break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = ZigZag_0[LINE_UPPER] != 0.0 || ZigZag_1[LINE_UPPER] != 0.0 || ZigZag_2[LINE_UPPER] != 0.0;
          if (METHOD(_method, 0)) _result &= Open[CURR] < Close[CURR];
          if (METHOD(_method, 1)) _result &= !ZigZag_On_Buy(tf);
          if (METHOD(_method, 2)) _result &= ZigZag_On_Sell(fmin(period + 1, M30));
          if (METHOD(_method, 3)) _result &= ZigZag_On_Sell(M30);
          if (METHOD(_method, 4)) _result &= ZigZag_2[LINE_UPPER] != 0.0;
          if (METHOD(_method, 5)) _result &= !ZigZag_On_Buy(M30);
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
