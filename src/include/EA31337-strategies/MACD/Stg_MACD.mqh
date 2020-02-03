//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements MACD strategy based on the Moving Averages Convergence/Divergence indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_MACD.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __MACD_Parameters__ = "-- MACD strategy params --";  // >>> MACD <<<
INPUT int MACD_Period_Fast = 23;                                  // Period Fast
INPUT int MACD_Period_Slow = 21;                                  // Period Slow
INPUT int MACD_Period_Signal = 10;                                // Period for signal
INPUT ENUM_APPLIED_PRICE MACD_Applied_Price = PRICE_CLOSE;        // Applied Price
INPUT int MACD_Shift = 3;                                         // Shift
INPUT int MACD_SignalOpenMethod = -26;                            // Signal open method (-31-31)
INPUT double MACD_SignalOpenLevel = 0.1;                          // Signal open level
INPUT int MACD_SignalOpenFilterMethod = 0;                          // Signal open filter method
INPUT int MACD_SignalOpenBoostMethod = 0;                          // Signal open boost method
INPUT int MACD_SignalCloseMethod = -26;                           // Signal close method (-31-31)
INPUT double MACD_SignalCloseLevel = 0.1;                         // Signal close level
INPUT int MACD_PriceLimitMethod = 0;                              // Price limit method
INPUT double MACD_PriceLimitLevel = 0;                            // Price limit level
INPUT double MACD_MaxSpread = 6.0;                                // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_MACD_Params : Stg_Params {
  int MACD_Period_Fast;
  int MACD_Period_Slow;
  int MACD_Period_Signal;
  ENUM_APPLIED_PRICE MACD_Applied_Price;
  int MACD_Shift;
  int MACD_SignalOpenMethod;
  double MACD_SignalOpenLevel;
  int MACD_SignalOpenFilterMethod;
  int MACD_SignalOpenBoostMethod;
  int MACD_SignalCloseMethod;
  double MACD_SignalCloseLevel;
  int MACD_PriceLimitMethod;
  double MACD_PriceLimitLevel;
  double MACD_MaxSpread;

  // Constructor: Set default param values.
  Stg_MACD_Params()
      : MACD_Period_Fast(::MACD_Period_Fast),
        MACD_Period_Slow(::MACD_Period_Slow),
        MACD_Period_Signal(::MACD_Period_Signal),
        MACD_Applied_Price(::MACD_Applied_Price),
        MACD_Shift(::MACD_Shift),
        MACD_SignalOpenMethod(::MACD_SignalOpenMethod),
        MACD_SignalOpenLevel(::MACD_SignalOpenLevel),
        MACD_SignalOpenFilterMethod(::MACD_SignalOpenFilterMethod),
        MACD_SignalOpenBoostMethod(::MACD_SignalOpenBoostMethod),
        MACD_SignalCloseMethod(::MACD_SignalCloseMethod),
        MACD_SignalCloseLevel(::MACD_SignalCloseLevel),
        MACD_PriceLimitMethod(::MACD_PriceLimitMethod),
        MACD_PriceLimitLevel(::MACD_PriceLimitLevel),
        MACD_MaxSpread(::MACD_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_MACD : public Strategy {
 public:
  Stg_MACD(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_MACD *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_MACD_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_MACD_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_MACD_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_MACD_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_MACD_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_MACD_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_MACD_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    MACD_Params macd_params(_params.MACD_Period_Fast, _params.MACD_Period_Slow, _params.MACD_Period_Signal,
                            _params.MACD_Applied_Price);
    IndicatorParams macd_iparams(10, INDI_MACD);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_MACD(macd_params, macd_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.MACD_SignalOpenMethod, _params.MACD_SignalOpenLevel, _params.MACD_SignalCloseMethod,
_params.MACD_SignalOpenFilterMethod, _params.MACD_SignalOpenBoostMethod,
                       _params.MACD_SignalCloseLevel);
    sparams.SetMaxSpread(_params.MACD_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_MACD(sparams, "MACD");
    return _strat;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double macd_0_main = ((Indi_MACD *)this.Data()).GetValue(LINE_MAIN, 0);
    double macd_0_signal = ((Indi_MACD *)this.Data()).GetValue(LINE_SIGNAL, 0);
    double macd_1_main = ((Indi_MACD *)this.Data()).GetValue(LINE_MAIN, 1);
    double macd_1_signal = ((Indi_MACD *)this.Data()).GetValue(LINE_SIGNAL, 1);
    double macd_2_main = ((Indi_MACD *)this.Data()).GetValue(LINE_MAIN, 2);
    double macd_2_signal = ((Indi_MACD *)this.Data()).GetValue(LINE_SIGNAL, 2);
    double gap = _level * Market().GetPipSize();
    switch (_cmd) {
      /* TODO:
            //20. MACD (1)
            //VEMACDON EXISTS, THAT THE SIGNAL TO BUY IS TRUE ONLY IF MACD<0, SIGNAL TO SELL - IF MACD>0
            //Buy: MACD rises above the signal line
            //Sell: MACD falls below the signal line
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)<iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,1)
            &&
         iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)>=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,0))
            {f20=1;}
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)>iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,1)
            &&
         iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)<=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_SIGNAL,0))
            {f20=-1;}

            //21. MACD (2)
            //Buy: crossing 0 upwards
            //Sell: crossing 0 downwards
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)<0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)>=0)
            {f21=1;}
            if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,1)>0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,LINE_MAIN,0)<=0)
            {f21=-1;}
      */
      case ORDER_TYPE_BUY:
        _result = macd_0_main > macd_0_signal + gap;  // MACD rises above the signal line.
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= macd_2_main < macd_2_signal;
          if (METHOD(_method, 1)) _result &= macd_0_main >= 0;
          if (METHOD(_method, 2)) _result &= macd_1_main < 0;
          /*
          if (METHOD(_method, 3))
            _result &= ma_fast[this.Chart().TfToIndex()][CURR] > ma_fast[this.Chart().TfToIndex()][PREV];
          if (METHOD(_method, 4))
            _result &= ma_fast[this.Chart().TfToIndex()][CURR] > ma_medium[this.Chart().TfToIndex()][CURR];
          */
        }
        break;
      case ORDER_TYPE_SELL:
        _result = macd_0_main < macd_0_signal - gap;  // MACD falls below the signal line.
        if (_method != 0) {
          if (METHOD(_method, 0)) _result &= macd_2_main > macd_2_signal;
          if (METHOD(_method, 1)) _result &= macd_0_main <= 0;
          if (METHOD(_method, 2)) _result &= macd_1_main > 0;
          /*
          if (METHOD(_method, 3))
            _result &= ma_fast[this.Chart().TfToIndex()][CURR] < ma_fast[this.Chart().TfToIndex()][PREV];
          if (METHOD(_method, 4))
            _result &= ma_fast[this.Chart().TfToIndex()][CURR] < ma_medium[this.Chart().TfToIndex()][CURR];
          */
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
