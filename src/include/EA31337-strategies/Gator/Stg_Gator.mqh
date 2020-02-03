//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Gator strategy based on the Gator oscillator.
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_Gator.mqh>
#include <EA31337-classes/Strategy.mqh>

// User input params.
INPUT string __Gator_Parameters__ = "-- Gator strategy params --";  // >>> GATOR <<<
INPUT int Gator_Period_Jaw = 6;                                     // Jaw Period
INPUT int Gator_Period_Teeth = 10;                                  // Teeth Period
INPUT int Gator_Period_Lips = 8;                                    // Lips Period
INPUT int Gator_Shift_Jaw = 5;                                      // Jaw Shift
INPUT int Gator_Shift_Teeth = 7;                                    // Teeth Shift
INPUT int Gator_Shift_Lips = 5;                                     // Lips Shift
INPUT ENUM_MA_METHOD Gator_MA_Method = 2;                           // MA Method
INPUT ENUM_APPLIED_PRICE Gator_Applied_Price = 3;                   // Applied Price
INPUT int Gator_Shift = 2;                                          // Shift
INPUT int Gator_SignalOpenMethod = 0;                               // Signal open method (0-
INPUT double Gator_SignalOpenLevel = 0.00000000;                    // Signal open level
INPUT int Gator_SignalOpenFilterMethod = 0.00000000;                    // Signal open filter method
INPUT int Gator_SignalOpenBoostMethod = 0.00000000;                    // Signal open boost method
INPUT int Gator_SignalCloseMethod = 0;                              // Signal close method (0-
INPUT double Gator_SignalCloseLevel = 0.00000000;                   // Signal close level
INPUT int Gator_PriceLimitMethod = 0;                               // Price limit method
INPUT double Gator_PriceLimitLevel = 0;                             // Price limit level
INPUT double Gator_MaxSpread = 6.0;                                 // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_Gator_Params : Stg_Params {
  int Gator_Period_Jaw;
  int Gator_Period_Teeth;
  int Gator_Period_Lips;
  int Gator_Shift_Jaw;
  int Gator_Shift_Teeth;
  int Gator_Shift_Lips;
  ENUM_MA_METHOD Gator_MA_Method;
  ENUM_APPLIED_PRICE Gator_Applied_Price;
  int Gator_Shift;
  int Gator_SignalOpenMethod;
  double Gator_SignalOpenLevel;
  int Gator_SignalOpenFilterMethod;
  int Gator_SignalOpenBoostMethod;
  int Gator_SignalCloseMethod;
  double Gator_SignalCloseLevel;
  int Gator_PriceLimitMethod;
  double Gator_PriceLimitLevel;
  double Gator_MaxSpread;

  // Constructor: Set default param values.
  Stg_Gator_Params()
      : Gator_Period_Jaw(::Gator_Period_Jaw),
        Gator_Period_Teeth(::Gator_Period_Teeth),
        Gator_Period_Lips(::Gator_Period_Lips),
        Gator_Shift_Jaw(::Gator_Shift_Jaw),
        Gator_Shift_Teeth(::Gator_Shift_Teeth),
        Gator_Shift_Lips(::Gator_Shift_Lips),
        Gator_MA_Method(::Gator_MA_Method),
        Gator_Applied_Price(::Gator_Applied_Price),
        Gator_Shift(::Gator_Shift),
        Gator_SignalOpenMethod(::Gator_SignalOpenMethod),
        Gator_SignalOpenLevel(::Gator_SignalOpenLevel),
        Gator_SignalOpenFilterMethod(::Gator_SignalOpenFilterMethod),
        Gator_SignalOpenBoostMethod(::Gator_SignalOpenBoostMethod),
        Gator_SignalCloseMethod(::Gator_SignalCloseMethod),
        Gator_SignalCloseLevel(::Gator_SignalCloseLevel),
        Gator_PriceLimitMethod(::Gator_PriceLimitMethod),
        Gator_PriceLimitLevel(::Gator_PriceLimitLevel),
        Gator_MaxSpread(::Gator_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_Gator : public Strategy {
 public:
  Stg_Gator(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Gator *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_Gator_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_Gator_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_Gator_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_Gator_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_Gator_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_Gator_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_Gator_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    Gator_Params gator_params(_params.Gator_Period_Jaw, _params.Gator_Period_Teeth, _params.Gator_Period_Lips,
                              _params.Gator_Shift_Jaw, _params.Gator_Shift_Teeth, _params.Gator_Shift_Lips,
                              _params.Gator_MA_Method, _params.Gator_Applied_Price);
    IndicatorParams gator_iparams(10, INDI_GATOR);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_Gator(gator_params, gator_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.Gator_SignalOpenMethod, _params.Gator_SignalOpenLevel, _params.Gator_SignalCloseMethod,
_params.Gator_SignalOpenFilterMethod, _params.Gator_SignalOpenBoostMethod,
                       _params.Gator_SignalCloseLevel);
    sparams.SetMaxSpread(_params.Gator_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_Gator(sparams, "Gator");
    return _strat;
  }

  /**
   * Check if Gator Oscillator is on buy or sell.
   *
   * Note: It doesn't give independent signals. Is used for Alligator correction.
   * Principle: trend must be strengthened. Together with this Gator Oscillator goes up.
   *
   * @param
   *   _cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _method (int) - signal method to use by using bitwise AND operation
   *   _level (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    double gator_0_jaw = ((Indi_Gator *)this.Data()).GetValue(LINE_JAW, 0);
    double gator_0_teeth = ((Indi_Gator *)this.Data()).GetValue(LINE_TEETH, 0);
    double gator_0_lips = ((Indi_Gator *)this.Data()).GetValue(LINE_LIPS, 0);
    double gator_1_jaw = ((Indi_Gator *)this.Data()).GetValue(LINE_JAW, 1);
    double gator_1_teeth = ((Indi_Gator *)this.Data()).GetValue(LINE_TEETH, 1);
    double gator_1_lips = ((Indi_Gator *)this.Data()).GetValue(LINE_LIPS, 1);
    double gator_2_jaw = ((Indi_Gator *)this.Data()).GetValue(LINE_JAW, 2);
    double gator_2_teeth = ((Indi_Gator *)this.Data()).GetValue(LINE_TEETH, 2);
    double gator_2_lips = ((Indi_Gator *)this.Data()).GetValue(LINE_LIPS, 2);
    double gap = _level * Market().GetPipSize();
    switch (_cmd) {
      /*
        //4. Gator Oscillator
        //Lower part of diagram is taken for calculations. Growth is checked on 4 periods.
        //The flag is 1 of trend is strengthened, 0 - no strengthening, -1 - never.
        //Uses part of Alligator's variables
        if
        (iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,3)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,2)
        &&iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,2)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,1)
        &&iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,1)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,0))
        {f4=1;}
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
