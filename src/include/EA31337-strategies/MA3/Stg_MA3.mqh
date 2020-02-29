//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements MA strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_MA.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User params.
string __MA3_Parameters__ = "-- MA strategy params --";  // >>> MA <<<
int MA3_Period_Fast = 12;                                // Period Fast
int MA3_Period_Medium = 12;                              // Period Medium
int MA3_Period_Slow = 12;                                // Period Slow
int MA3_MA_Shift = 0;                                    // MA Shift
int MA3_MA_Shift_Fast = 0;                               // MA Shift Fast
int MA3_MA_Shift_Medium = 0;                             // MA Shift Medium
int MA3_MA_Shift_Slow = 0;                               // MA Shift Slow
ENUM_MA_METHOD MA3_Method = 1;                           // MA Method
ENUM_APPLIED_PRICE MA3_Applied_Price = 6;                // Applied Price
int MA3_Shift = 0;                                       // Shift
int MA3_SignalOpenMethod = 48;                           // Signal open method (-127-127)
double MA3_SignalOpenLevel = -0.6;                       // Signal open level
int MA3_SignalOpenFilterMethod = 0;                      // Signal open filter method
int MA3_SignalOpenBoostMethod = 0;                       // Signal open boost method
int MA3_SignalCloseMethod = 48;                          // Signal close method (-127-127)
double MA3_SignalCloseLevel = -0.6;                      // Signal close level
int MA3_PriceLimitMethod = 0;                            // Price limit method
double MA3_PriceLimitLevel = 0;                          // Price limit level
double MA3_MaxSpread = 6.0;                              // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_MA3_Params : StgParams {
  unsigned int MA3_Period_Fast;
  unsigned int MA3_Period_Medium;
  unsigned int MA3_Period_Slow;
  int MA3_MA_Shift;
  int MA3_MA_Shift_Fast;
  int MA3_MA_Shift_Medium;
  int MA3_MA_Shift_Slow;
  ENUM_MA_METHOD MA3_Method;
  ENUM_APPLIED_PRICE MA3_Applied_Price;
  int MA3_Shift;
  int MA3_SignalOpenMethod;
  double MA3_SignalOpenLevel;
  int MA3_SignalOpenFilterMethod;
  int MA3_SignalOpenBoostMethod;
  int MA3_SignalCloseMethod;
  double MA3_SignalCloseLevel;
  int MA3_PriceLimitMethod;
  double MA3_PriceLimitLevel;
  double MA3_MaxSpread;

  // Constructor: Set default param values.
  Stg_MA3_Params()
      : MA3_Period_Fast(::MA3_Period_Fast),
        MA3_Period_Medium(::MA3_Period_Medium),
        MA3_Period_Slow(::MA3_Period_Slow),
        MA3_MA_Shift(::MA3_MA_Shift),
        MA3_MA_Shift_Fast(::MA3_MA_Shift_Fast),
        MA3_MA_Shift_Medium(::MA3_MA_Shift_Medium),
        MA3_MA_Shift_Slow(::MA3_MA_Shift_Slow),
        MA3_Method(::MA3_Method),
        MA3_Applied_Price(::MA3_Applied_Price),
        MA3_Shift(::MA3_Shift),
        MA3_SignalOpenMethod(::MA3_SignalOpenMethod),
        MA3_SignalOpenLevel(::MA3_SignalOpenLevel),
        MA3_SignalOpenFilterMethod(::MA3_SignalOpenFilterMethod),
        MA3_SignalOpenBoostMethod(::MA3_SignalOpenBoostMethod),
        MA3_SignalCloseMethod(::MA3_SignalCloseMethod),
        MA3_SignalCloseLevel(::MA3_SignalCloseLevel),
        MA3_PriceLimitMethod(::MA3_PriceLimitMethod),
        MA3_PriceLimitLevel(::MA3_PriceLimitLevel),
        MA3_MaxSpread(::MA3_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_MA3 : public Strategy {
 public:
  void Stg_MA3(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_MA3 *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_MA3_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_MA3_Params>(_params, _tf, stg_ma3_m1, stg_ma3_m5, stg_ma3_m15, stg_ma3_m30, stg_ma3_h1,
                                    stg_ma3_h4, stg_ma3_h4);
    }
    // Initialize strategy parameters.
    MAParams ma_params_fast(_params.MA3_Period_Fast, _params.MA3_MA_Shift_Fast, _params.MA3_Method,
                             _params.MA3_Applied_Price);
    MAParams ma_params_medium(_params.MA3_Period_Medium, _params.MA3_MA_Shift_Medium, _params.MA3_Method,
                               _params.MA3_Applied_Price);
    MAParams ma_params_slow(_params.MA3_Period_Slow, _params.MA3_MA_Shift_Slow, _params.MA3_Method,
                             _params.MA3_Applied_Price);
    ma_params_fast.SetTf(_tf);
    ma_params_medium.SetTf(_tf);
    ma_params_slow.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_MA(ma_params_fast), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.MA3_SignalOpenMethod, _params.MA3_SignalOpenLevel, _params.MA3_SignalCloseMethod,
                       _params.MA3_SignalOpenFilterMethod, _params.MA3_SignalOpenBoostMethod,
                       _params.MA3_SignalCloseLevel);
    sparams.SetMaxSpread(_params.MA3_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_MA3(sparams, "MA");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    /*
    double ma_0_fast = ma_fast[this.Chart().TfToIndex()][CURR];
    double ma_0_medium = ma_medium[this.Chart().TfToIndex()][CURR];
    double ma_0_slow = ma_slow[this.Chart().TfToIndex()][CURR];
    double ma_1_fast = ma_fast[this.Chart().TfToIndex()][PREV];
    double ma_1_medium = ma_medium[this.Chart().TfToIndex()][PREV];
    double ma_1_slow = ma_slow[this.Chart().TfToIndex()][PREV];
    double ma_2_fast = ma_fast[this.Chart().TfToIndex()][FAR];
    double ma_2_medium = ma_medium[this.Chart().TfToIndex()][FAR];
    double ma_2_slow = ma_slow[this.Chart().TfToIndex()][FAR];
    */
    /*
    @todo:
    double ma_0 = ((Indi_MA *) this.Data()).GetValue(0);
    double ma_1 = ((Indi_MA *) this.Data()).GetValue(1);
    double ma_2 = ((Indi_MA *) this.Data()).GetValue(2);
    */
    double gap = _level * Market().GetPipSize();
    /*
        switch (cmd) {
          case ORDER_TYPE_BUY:
            _result = ma_0_fast > ma_0_medium + gap;
            _result &= ma_0_medium > ma_0_slow;
            if (_signal_method != 0) {
              if (METHOD(_signal_method, 0)) _result &= ma_0_fast > ma_0_slow + gap;
              if (METHOD(_signal_method, 1)) _result &= ma_0_medium > ma_0_slow;
              if (METHOD(_signal_method, 2)) _result &= ma_0_slow > ma_1_slow;
              if (METHOD(_signal_method, 3)) _result &= ma_0_fast > ma_1_fast;
              if (METHOD(_signal_method, 4)) _result &= ma_0_fast - ma_0_medium > ma_0_medium - ma_0_slow;
              if (METHOD(_signal_method, 5)) _result &= (ma_1_medium < ma_1_slow || ma_2_medium < ma_2_slow);
              if (METHOD(_signal_method, 6)) _result &= (ma_1_fast < ma_1_medium || ma_2_fast < ma_2_medium);
            }
            break;
          case ORDER_TYPE_SELL:
            _result = ma_0_fast < ma_0_medium - gap;
            _result &= ma_0_medium < ma_0_slow;
            if (_signal_method != 0) {
              if (METHOD(_signal_method, 0)) _result &= ma_0_fast < ma_0_slow - gap;
              if (METHOD(_signal_method, 1)) _result &= ma_0_medium < ma_0_slow;
              if (METHOD(_signal_method, 2)) _result &= ma_0_slow < ma_1_slow;
              if (METHOD(_signal_method, 3)) _result &= ma_0_fast < ma_1_fast;
              if (METHOD(_signal_method, 4)) _result &= ma_0_medium - ma_0_fast > ma_0_slow - ma_0_medium;
              if (METHOD(_signal_method, 5)) _result &= (ma_1_medium > ma_1_slow || ma_2_medium > ma_2_slow);
              if (METHOD(_signal_method, 6)) _result &= (ma_1_fast > ma_1_medium || ma_2_fast > ma_2_medium);
            }
            break;
        }
    */
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
    /*
    double ma_0_fast = ma_fast[this.Chart().TfToIndex()][CURR];
    double ma_0_medium = ma_medium[this.Chart().TfToIndex()][CURR];
    double ma_0_slow = ma_slow[this.Chart().TfToIndex()][CURR];
    double ma_1_fast = ma_fast[this.Chart().TfToIndex()][PREV];
    double ma_1_medium = ma_medium[this.Chart().TfToIndex()][PREV];
    double ma_1_slow = ma_slow[this.Chart().TfToIndex()][PREV];
    double ma_2_fast = ma_fast[this.Chart().TfToIndex()][FAR];
    double ma_2_medium = ma_medium[this.Chart().TfToIndex()][FAR];
    double ma_2_slow = ma_slow[this.Chart().TfToIndex()][FAR];
    */
    double gap = _level * Market().GetPipSize();
    double _diff = 0;
    /*
    switch (_method) {
      case 0: {
        _diff = fabs(open_0 - ma_0_fast);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 1: {
        _diff = fabs(open_0 - ma_0_medium);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 2: {
        _diff = fabs(open_0 - ma_0_slow);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 3: {
        _diff = fabs(open_0 - ma_1_fast);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 4: {
        _diff = fabs(open_0 - ma_1_medium);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 5: {
        _diff = fabs(open_0 - ma_1_slow);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 6: {
        _diff = fabs(open_0 - ma_2_fast);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 7: {
        _diff = fabs(open_0 - ma_2_medium);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 8: {
        _diff = fabs(open_0 - ma_2_slow);
        _result = open_0 + (_diff + _trail) * _direction;
      }
      case 9: {
        _diff = fmax(fabs(open_0 - fmax(ma_0_fast, ma_1_fast)), fabs(open_0 - fmin(ma_0_fast, ma_1_fast)));
        _result = open_0 + (_diff + _trail) * _direction;
      }
    }
    */
    return _result;
  }
};
