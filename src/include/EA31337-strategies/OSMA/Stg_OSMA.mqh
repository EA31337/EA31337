//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements OsMA strategy based on the Moving Average of Oscillator indicator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_OsMA.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __OsMA_Parameters__ = "-- OsMA strategy params --";  // >>> OsMA <<<
INPUT int OsMA_Period_Fast = 8;                                   // Period Fast
INPUT int OsMA_Period_Slow = 6;                                   // Period Slow
INPUT int OsMA_Period_Signal = 9;                                 // Period for signal
INPUT ENUM_APPLIED_PRICE OsMA_Applied_Price = 4;                  // Applied Price
INPUT int OsMA_Shift = 0;                                         // Shift
INPUT int OsMA_SignalOpenMethod = 120;                            // Signal open method (0-
INPUT double OsMA_SignalOpenLevel = -0.2;                         // Signal open level
INPUT int OsMA_SignalOpenFilterMethod = 0;                         // Signal open filter method
INPUT int OsMA_SignalOpenBoostMethod = 0;                         // Signal open boost method
INPUT int OsMA_SignalCloseMethod = 120;                           // Signal close method (0-
INPUT double OsMA_SignalCloseLevel = -0.2;                        // Signal close level
INPUT int OsMA_PriceLimitMethod = 0;                              // Price limit method
INPUT double OsMA_PriceLimitLevel = 0;                            // Price limit level
INPUT double OsMA_MaxSpread = 6.0;                                // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_OsMA_Params : Stg_Params {
  int OsMA_Period_Fast;
  int OsMA_Period_Slow;
  int OsMA_Period_Signal;
  ENUM_APPLIED_PRICE OsMA_Applied_Price;
  int OsMA_Shift;
  int OsMA_SignalOpenMethod;
  double OsMA_SignalOpenLevel;
  int OsMA_SignalOpenFilterMethod;
  int OsMA_SignalOpenBoostMethod;
  int OsMA_SignalCloseMethod;
  double OsMA_SignalCloseLevel;
  int OsMA_PriceLimitMethod;
  double OsMA_PriceLimitLevel;
  double OsMA_MaxSpread;

  // Constructor: Set default param values.
  Stg_OsMA_Params()
      : OsMA_Period_Fast(::OsMA_Period_Fast),
        OsMA_Period_Slow(::OsMA_Period_Slow),
        OsMA_Period_Signal(::OsMA_Period_Signal),
        OsMA_Applied_Price(::OsMA_Applied_Price),
        OsMA_Shift(::OsMA_Shift),
        OsMA_SignalOpenMethod(::OsMA_SignalOpenMethod),
        OsMA_SignalOpenLevel(::OsMA_SignalOpenLevel),
        OsMA_SignalOpenFilterMethod(::OsMA_SignalOpenFilterMethod),
        OsMA_SignalOpenBoostMethod(::OsMA_SignalOpenBoostMethod),
        OsMA_SignalCloseMethod(::OsMA_SignalCloseMethod),
        OsMA_SignalCloseLevel(::OsMA_SignalCloseLevel),
        OsMA_PriceLimitMethod(::OsMA_PriceLimitMethod),
        OsMA_PriceLimitLevel(::OsMA_PriceLimitLevel),
        OsMA_MaxSpread(::OsMA_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_OsMA : public Strategy {
 public:
  Stg_OsMA(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_OsMA *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_OsMA_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_OsMA_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_OsMA_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_OsMA_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_OsMA_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_OsMA_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_OsMA_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    OsMA_Params osma_params(_params.OsMA_Period_Fast, _params.OsMA_Period_Slow, _params.OsMA_Period_Signal,
                            _params.OsMA_Applied_Price);
    IndicatorParams osma_iparams(10, INDI_OSMA);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_OsMA(osma_params, osma_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.OsMA_SignalOpenMethod, _params.OsMA_SignalOpenLevel, _params.OsMA_SignalCloseMethod,
_params.OsMA_SignalOpenFilterMethod, _params.OsMA_SignalOpenBoostMethod,
                       _params.OsMA_SignalCloseLevel);
    sparams.SetMaxSpread(_params.OsMA_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_OsMA(sparams, "OsMA");
    return _strat;
  }

  /**
   * Check if OsMA indicator is on buy or sell.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double osma_0 = ((Indi_OsMA *)this.Data()).GetValue(0);
    double osma_1 = ((Indi_OsMA *)this.Data()).GetValue(1);
    double osma_2 = ((Indi_OsMA *)this.Data()).GetValue(2);
    switch (_cmd) {
      /*
        //22. Moving Average of Oscillator (MACD histogram) (1)
        //Buy: histogram is below zero and changes falling direction into rising (5 columns are taken)
        //Sell: histogram is above zero and changes its rising direction into falling (5 columns are taken)
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f22=1;}
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f22=-1;}
      */

      /*
        //23. Moving Average of Oscillator (MACD histogram) (2)
        //To use the indicator it should be correlated with another trend indicator
        //Flag 23 is 1, when MACD histogram recommends to buy (i.e. histogram is sloping upwards)
        //Flag 23 is -1, when MACD histogram recommends to sell (i.e. histogram is sloping downwards)
        //3 columns are taken for calculation
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f23=1;}
        if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
        {f23=-1;}
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
