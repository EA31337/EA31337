//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements RVI strategy based on the Relative Vigor Index indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_RVI.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __RVI_Parameters__ = "-- RVI strategy params --";  // >>> RVI <<<
INPUT unsigned int RVI_Period = 10;                             // Averaging period
INPUT ENUM_SIGNAL_LINE RVI_Mode = 0;                            // Indicator line index.
INPUT int RVI_Shift = 2;                                        // Shift
INPUT int RVI_SignalOpenMethod = 0;                             // Signal open method (0-
INPUT double RVI_SignalOpenLevel = 0.00000000;                  // Signal open level
INPUT int RVI_SignalOpenFilterMethod = 0.00000000;              // Signal open filter method
INPUT int RVI_SignalOpenBoostMethod = 0.00000000;               // Signal open boost method
INPUT int RVI_SignalCloseMethod = 0;                            // Signal close method (0-
INPUT double RVI_SignalCloseLevel = 0.00000000;                 // Signal close level
INPUT int RVI_PriceLimitMethod = 0;                             // Price limit method
INPUT double RVI_PriceLimitLevel = 0;                           // Price limit level
INPUT double RVI_MaxSpread = 6.0;                               // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_RVI_Params : StgParams {
  unsigned int RVI_Period;
  ENUM_SIGNAL_LINE RVI_Mode;
  int RVI_Shift;
  int RVI_SignalOpenMethod;
  double RVI_SignalOpenLevel;
  int RVI_SignalOpenFilterMethod;
  int RVI_SignalOpenBoostMethod;
  int RVI_SignalCloseMethod;
  double RVI_SignalCloseLevel;
  int RVI_PriceLimitMethod;
  double RVI_PriceLimitLevel;
  double RVI_MaxSpread;

  // Constructor: Set default param values.
  Stg_RVI_Params()
      : RVI_Period(::RVI_Period),
        RVI_Mode(::RVI_Mode),
        RVI_Shift(::RVI_Shift),
        RVI_SignalOpenMethod(::RVI_SignalOpenMethod),
        RVI_SignalOpenLevel(::RVI_SignalOpenLevel),
        RVI_SignalOpenFilterMethod(::RVI_SignalOpenFilterMethod),
        RVI_SignalOpenBoostMethod(::RVI_SignalOpenBoostMethod),
        RVI_SignalCloseMethod(::RVI_SignalCloseMethod),
        RVI_SignalCloseLevel(::RVI_SignalCloseLevel),
        RVI_PriceLimitMethod(::RVI_PriceLimitMethod),
        RVI_PriceLimitLevel(::RVI_PriceLimitLevel),
        RVI_MaxSpread(::RVI_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_RVI : public Strategy {
 public:
  Stg_RVI(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_RVI *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_RVI_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_RVI_Params>(_params, _tf, stg_rvi_m1, stg_rvi_m5, stg_rvi_m15, stg_rvi_m30, stg_rvi_h1,
                                    stg_rvi_h4, stg_rvi_h4);
    }
    // Initialize strategy parameters.
    RVIParams rvi_params(_params.RVI_Period);
    rvi_params.SetTf(_tf);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_RVI(rvi_params), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.RVI_SignalOpenMethod, _params.RVI_SignalOpenLevel, _params.RVI_SignalCloseMethod,
                       _params.RVI_SignalOpenFilterMethod, _params.RVI_SignalOpenBoostMethod,
                       _params.RVI_SignalCloseLevel);
    sparams.SetMaxSpread(_params.RVI_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_RVI(sparams, "RVI");
    return _strat;
  }

  /**
   * Check if RVI indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    /*
    double rvi_0 = ((Indi_RVI *) this.Data()).GetValue(0);
    double rvi_1 = ((Indi_RVI *) this.Data()).GetValue(1);
    double rvi_2 = ((Indi_RVI *) this.Data()).GetValue(2);
    */
    switch (_cmd) {
      /*
        //26. RVI
        //RECOMMENDED TO USE WITH A TREND INDICATOR
        //Buy: main line (green) crosses signal (red) upwards
        //Sell: main line (green) crosses signal (red) downwards
        if(iRVI(NULL,pirvi,pirviu,LINE_MAIN,1)<iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,1)
        && iRVI(NULL,pirvi,pirviu,LINE_MAIN,0)>=iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,0))
        {f26=1;}
        if(iRVI(NULL,pirvi,pirviu,LINE_MAIN,1)>iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,1)
        && iRVI(NULL,pirvi,pirviu,LINE_MAIN,0)<=iRVI(NULL,pirvi,pirviu,LINE_SIGNAL,0))
        {f26=-1;}
      */
      case ORDER_TYPE_BUY:
        break;
      case ORDER_TYPE_SELL:
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
