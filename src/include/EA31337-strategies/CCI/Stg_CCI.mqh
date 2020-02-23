//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements CCI strategy based on the Commodity Channel Index indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_CCI.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __CCI_Parameters__ = "-- CCI strategy params --";  // >>> CCI <<<
INPUT int CCI_Shift = 1;                                        // Shift (0 for default)
INPUT int CCI_Period = 58;                                      // Period
INPUT ENUM_APPLIED_PRICE CCI_Applied_Price = 2;                 // Applied Price
INPUT int CCI_SignalOpenMethod = 0;                             // Signal open method (-63-63)
INPUT double CCI_SignalOpenLevel = 18;                          // Signal open level (-49-49)
INPUT int CCI_SignalOpenFilterMethod = 0;                       // Signal open filter method
INPUT int CCI_SignalOpenBoostMethod = 0;                        // Signal open boost method
INPUT int CCI_SignalCloseMethod = 0;                            // Signal close method (-63-63)
INPUT double CCI_SignalCloseLevel = 18;                         // Signal close level (-49-49)
INPUT int CCI_PriceLimitMethod = 0;                             // Price limit method (0-6)
INPUT double CCI_PriceLimitLevel = 0;                           // Price limit level
double CCI_MaxSpread = 6.0;                                     // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_CCI_Params : Stg_Params {
  unsigned int CCI_Period;
  ENUM_APPLIED_PRICE CCI_Applied_Price;
  int CCI_Shift;
  int CCI_SignalOpenMethod;
  double CCI_SignalOpenLevel;
  int CCI_SignalOpenFilterMethod;
  int CCI_SignalOpenBoostMethod;
  int CCI_SignalCloseMethod;
  double CCI_SignalCloseLevel;
  int CCI_PriceLimitMethod;
  double CCI_PriceLimitLevel;
  double CCI_MaxSpread;

  // Constructor: Set default param values.
  Stg_CCI_Params()
      : CCI_Period(::CCI_Period),
        CCI_Applied_Price(::CCI_Applied_Price),
        CCI_Shift(::CCI_Shift),
        CCI_SignalOpenMethod(::CCI_SignalOpenMethod),
        CCI_SignalOpenLevel(::CCI_SignalOpenLevel),
        CCI_SignalOpenFilterMethod(::CCI_SignalOpenFilterMethod),
        CCI_SignalOpenBoostMethod(::CCI_SignalOpenBoostMethod),
        CCI_SignalCloseMethod(::CCI_SignalCloseMethod),
        CCI_SignalCloseLevel(::CCI_SignalCloseLevel),
        CCI_PriceLimitMethod(::CCI_PriceLimitMethod),
        CCI_PriceLimitLevel(::CCI_PriceLimitLevel),
        CCI_MaxSpread(::CCI_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_CCI : public Strategy {
 public:
  Stg_CCI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_CCI *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_CCI_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_CCI_Params>(_params, _tf, stg_cci_m1, stg_cci_m5, stg_cci_m15, stg_cci_m30, stg_cci_h1,
                                    stg_cci_h4, stg_cci_h4);
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    CCI_Params cci_params(_params.CCI_Period, _params.CCI_Applied_Price);
    IndicatorParams cci_iparams(10, INDI_CCI);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_CCI(cci_params, cci_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.CCI_SignalOpenMethod, _params.CCI_SignalOpenLevel, _params.CCI_SignalOpenFilterMethod,
                       _params.CCI_SignalOpenBoostMethod, _params.CCI_SignalCloseMethod, _params.CCI_SignalCloseLevel);
    sparams.SetMaxSpread(_params.CCI_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_CCI(sparams, "CCI");
    return _strat;
  }

  /**
   * Check if CCI indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double cci_0 = ((Indi_CCI *)this.Data()).GetValue(0);
    double cci_1 = ((Indi_CCI *)this.Data()).GetValue(1);
    double cci_2 = ((Indi_CCI *)this.Data()).GetValue(2);
    switch (_cmd) {
      case ORDER_TYPE_BUY:
        _result = cci_0 > 0 && cci_0 < -_level;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= cci_0 > cci_1;
          if (METHOD(_method, 1)) _result &= cci_1 > cci_2;
          if (METHOD(_method, 2)) _result &= cci_1 < -_level;
          if (METHOD(_method, 3)) _result &= cci_2 < -_level;
          if (METHOD(_method, 4)) _result &= cci_0 - cci_1 > cci_1 - cci_2;
          if (METHOD(_method, 5)) _result &= cci_2 > 0;
        }
        break;
      case ORDER_TYPE_SELL:
        _result = cci_0 > 0 && cci_0 > _level;
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= cci_0 < cci_1;
          if (METHOD(_method, 1)) _result &= cci_1 < cci_2;
          if (METHOD(_method, 2)) _result &= cci_1 > _level;
          if (METHOD(_method, 3)) _result &= cci_2 > _level;
          if (METHOD(_method, 4)) _result &= cci_1 - cci_0 > cci_2 - cci_1;
          if (METHOD(_method, 5)) _result &= cci_2 < 0;
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
