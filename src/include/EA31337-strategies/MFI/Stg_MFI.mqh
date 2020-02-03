//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements MFI strategy based on the Money Flow Index indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_MFI.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __MFI_Parameters__ = "-- MFI strategy params --";  // >>> MFI <<<
INPUT int MFI_Period = 2;                                       // Period
INPUT int MFI_Shift = 0;                                        // Shift (relative to the current bar, 0 - default)
INPUT int MFI_SignalOpenMethod = 0;                             // Signal open method (0-1)
INPUT double MFI_SignalOpenLevel = 0.9;                         // Signal open level
INPUT int MFI_SignalOpenFilterMethod = 0;                         // Signal open filter method
INPUT int MFI_SignalOpenBoostMethod = 0;                         // Signal open boost method
INPUT int MFI_SignalCloseMethod = 0;                            // Signal close method (0-1)
INPUT double MFI_SignalCloseLevel = 0.9;                        // Signal close level
INPUT int MFI_PriceLimitMethod = 0;                             // Price limit method
INPUT double MFI_PriceLimitLevel = 0;                           // Price limit level
INPUT double MFI_MaxSpread = 6.0;                               // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_MFI_Params : Stg_Params {
  unsigned int MFI_Period;
  int MFI_Shift;
  int MFI_SignalOpenMethod;
  double MFI_SignalOpenLevel;
  int MFI_SignalOpenFilterMethod;
  int MFI_SignalOpenBoostMethod;
  int MFI_SignalCloseMethod;
  double MFI_SignalCloseLevel;
  int MFI_PriceLimitMethod;
  double MFI_PriceLimitLevel;
  double MFI_MaxSpread;

  // Constructor: Set default param values.
  Stg_MFI_Params()
      : MFI_Period(::MFI_Period),
        MFI_Shift(::MFI_Shift),
        MFI_SignalOpenMethod(::MFI_SignalOpenMethod),
        MFI_SignalOpenLevel(::MFI_SignalOpenLevel),
        MFI_SignalOpenFilterMethod(::MFI_SignalOpenFilterMethod),
        MFI_SignalOpenBoostMethod(::MFI_SignalOpenBoostMethod),
        MFI_SignalCloseMethod(::MFI_SignalCloseMethod),
        MFI_SignalCloseLevel(::MFI_SignalCloseLevel),
        MFI_PriceLimitMethod(::MFI_PriceLimitMethod),
        MFI_PriceLimitLevel(::MFI_PriceLimitLevel),
        MFI_MaxSpread(::MFI_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_MFI : public Strategy {
 public:
  Stg_MFI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_MFI *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_MFI_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_MFI_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_MFI_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_MFI_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_MFI_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_MFI_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_MFI_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    MFI_Params mfi_params(_params.MFI_Period);
    IndicatorParams mfi_iparams(10, INDI_MFI);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_MFI(mfi_params, mfi_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.MFI_SignalOpenMethod, _params.MFI_SignalOpenLevel, _params.MFI_SignalCloseMethod,
_params.MFI_SignalOpenFilterMethod, _params.MFI_SignalOpenBoostMethod,
                       _params.MFI_SignalCloseLevel);
    sparams.SetMaxSpread(_params.MFI_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_MFI(sparams, "MFI");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double mfi_0 = ((Indi_MFI *)this.Data()).GetValue(0);
    double mfi_1 = ((Indi_MFI *)this.Data()).GetValue(1);
    double mfi_2 = ((Indi_MFI *)this.Data()).GetValue(2);
    switch (_cmd) {
      // Buy: Crossing 20 upwards.
      case ORDER_TYPE_BUY:
        _result = mfi_1 > 0 && mfi_1 < (50 - _level);
        if (METHOD(_method, 0)) _result &= mfi_0 >= (50 - _level);
        break;
      // Sell: Crossing 80 downwards.
      case ORDER_TYPE_SELL:
        _result = mfi_1 > 0 && mfi_1 > (50 + _level);
        if (METHOD(_method, 0)) _result &= mfi_0 <= (50 - _level);
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
