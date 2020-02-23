//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ATR strategy based on the Average True Range indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_ATR.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __ATR_Parameters__ = "-- ATR strategy params --";  // >>> ATR <<<
INPUT int ATR_Period = 14;                                      // Period
INPUT int ATR_Shift = 0;                                        // Shift (relative to the current bar, 0 - default)
INPUT int ATR_SignalOpenMethod = 0;                             // Signal open method (0-31)
INPUT double ATR_SignalOpenLevel = 0;                           // Signal open level
INPUT int ATR_SignalOpenFilterMethod = 0;                       // Signal open filter method
INPUT int ATR_SignalOpenBoostMethod = 0;                        // Signal open boost method
INPUT int ATR_SignalCloseMethod = 0;                            // Signal close method
INPUT double ATR_SignalCloseLevel = 0;                          // Signal close level
INPUT int ATR_PriceLimitMethod = 0;                             // Price limit method
INPUT double ATR_PriceLimitLevel = 0;                           // Price limit level
INPUT double ATR_MaxSpread = 6.0;                               // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_ATR_Params : Stg_Params {
  unsigned int ATR_Period;
  ENUM_APPLIED_PRICE ATR_Applied_Price;
  int ATR_Shift;
  int ATR_SignalOpenMethod;
  double ATR_SignalOpenLevel;
  int ATR_SignalOpenFilterMethod;
  int ATR_SignalOpenBoostMethod;
  int ATR_SignalCloseMethod;
  double ATR_SignalCloseLevel;
  int ATR_PriceLimitMethod;
  double ATR_PriceLimitLevel;
  double ATR_MaxSpread;

  // Constructor: Set default param values.
  Stg_ATR_Params()
      : ATR_Period(::ATR_Period),
        ATR_Shift(::ATR_Shift),
        ATR_SignalOpenMethod(::ATR_SignalOpenMethod),
        ATR_SignalOpenLevel(::ATR_SignalOpenLevel),
        ATR_SignalOpenFilterMethod(::ATR_SignalOpenFilterMethod),
        ATR_SignalOpenBoostMethod(::ATR_SignalOpenBoostMethod),
        ATR_SignalCloseMethod(::ATR_SignalCloseMethod),
        ATR_SignalCloseLevel(::ATR_SignalCloseLevel),
        ATR_PriceLimitMethod(::ATR_PriceLimitMethod),
        ATR_PriceLimitLevel(::ATR_PriceLimitLevel),
        ATR_MaxSpread(::ATR_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_ATR : public Strategy {
 public:
  Stg_ATR(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_ATR *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_ATR_Params _params;
    if (!Terminal::IsOptimization()) {
      SetParamsByTf<Stg_ATR_Params>(_params, _tf, stg_atr_m1, stg_atr_m5, stg_atr_m15, stg_atr_m30, stg_atr_h1,
                                    stg_atr_h4, stg_atr_h4);
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    ATR_Params atr_params(_params.ATR_Period);
    IndicatorParams atr_iparams(10, INDI_ATR);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_ATR(atr_params, atr_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.ATR_SignalOpenMethod, _params.ATR_SignalOpenLevel, _params.ATR_SignalOpenFilterMethod,
                       _params.ATR_SignalOpenBoostMethod, _params.ATR_SignalCloseMethod, _params.ATR_SignalCloseLevel);
    sparams.SetMaxSpread(_params.ATR_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_ATR(sparams, "ATR");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double atr_0 = ((Indi_ATR *)this.Data()).GetValue(0);
    double atr_1 = ((Indi_ATR *)this.Data()).GetValue(1);
    double atr_2 = ((Indi_ATR *)this.Data()).GetValue(2);
    switch (_cmd) {
      //   if(iATR(NULL,0,12,0)>iATR(NULL,0,20,0)) return(0);
      /*
        //6. Average True Range - ATR
        //Doesn't give independent signals. Is used to define volatility (trend strength).
        //principle: trend must be strengthened. Together with that ATR grows.
        //Because of the chart form it is inconvenient to analyze rise/fall. Only exceeding of threshold value is
        checked.
        //Flag is 1 when ATR is above threshold value (i.e. there is a trend), 0 - when ATR is below threshold value, -1
        - never. if (iATR(NULL,piatr,piatru,0)>=minatr) {f6=1;}
      */
      case ORDER_TYPE_BUY:
        // bool _result = atr_0;
        /*
          if (METHOD(_method, 0)) _result &= Open[CURR] > Close[CURR];
          */
        break;
      case ORDER_TYPE_SELL:
        /*
          bool _result = ATR_0[LINE_UPPER] != 0.0 || ATR_1[LINE_UPPER] != 0.0 || ATR_2[LINE_UPPER] != 0.0;
          if (METHOD(_method, 0)) _result &= Open[CURR] < Close[CURR];
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
