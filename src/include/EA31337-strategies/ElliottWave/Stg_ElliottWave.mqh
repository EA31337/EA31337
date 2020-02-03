//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements ElliottWave strategy. Based on the Elliott Wave indicator.
 *
 * @docs
 * - https://en.wikipedia.org/wiki/Elliott_wave_principle
 */

// Includes.
#include <EA31337-classes/Indicators/Indi_MA.mqh>
#include <EA31337-classes/Strategy.mqh>

// User inputs.
INPUT string __ElliottWave_Parameters__ = "-- ElliottWave strategy params --";  // >>> ELLIOTT WAVE <<<
INPUT int ElliottWave_Period = 14;                                              // Averaging period
INPUT ENUM_APPLIED_PRICE ElliottWave_Applied_Price = PRICE_HIGH;                // Applied price.
INPUT int ElliottWave_Shift = 0;                     // Shift (relative to the current bar, 0 - default)
INPUT int ElliottWave_SignalOpenMethod = 0;          // Signal open method (0-1)
INPUT double ElliottWave_SignalOpenLevel = 0.0004;   // Signal open level (>0.0001)
INPUT int ElliottWave_SignalOpenFilterMethod = 0;   // Signal open filter method
INPUT int ElliottWave_SignalOpenBoostMethod = 0;   // Signal open boost method
INPUT int ElliottWave_SignalCloseMethod = 0;         // Signal close method
INPUT double ElliottWave_SignalCloseLevel = 0.0004;  // Signal close level (>0.0001)
INPUT int ElliottWave_PriceLimitMethod = 0;          // Price limit method
INPUT double ElliottWave_PriceLimitLevel = 0;        // Price limit level
INPUT double ElliottWave_MaxSpread = 6.0;            // Max spread to trade (pips)

// Struct to define strategy parameters to override.
struct Stg_ElliottWave_Params : Stg_Params {
  unsigned int ElliottWave_Period;
  ENUM_APPLIED_PRICE ElliottWave_Applied_Price;
  int ElliottWave_Shift;
  int ElliottWave_SignalOpenMethod;
  double ElliottWave_SignalOpenLevel;
  int ElliottWave_SignalOpenFilterMethod;
  int ElliottWave_SignalOpenBoostMethod;
  int ElliottWave_SignalCloseMethod;
  double ElliottWave_SignalCloseLevel;
  int ElliottWave_PriceLimitMethod;
  double ElliottWave_PriceLimitLevel;
  double ElliottWave_MaxSpread;

  // Constructor: Set default param values.
  Stg_ElliottWave_Params()
      : ElliottWave_Period(::ElliottWave_Period),
        ElliottWave_Applied_Price(::ElliottWave_Applied_Price),
        ElliottWave_Shift(::ElliottWave_Shift),
        ElliottWave_SignalOpenMethod(::ElliottWave_SignalOpenMethod),
        ElliottWave_SignalOpenLevel(::ElliottWave_SignalOpenLevel),
        ElliottWave_SignalOpenFilterMethod(::ElliottWave_SignalOpenFilterMethod),
        ElliottWave_SignalOpenBoostMethod(::ElliottWave_SignalOpenBoostMethod),
        ElliottWave_SignalCloseMethod(::ElliottWave_SignalCloseMethod),
        ElliottWave_SignalCloseLevel(::ElliottWave_SignalCloseLevel),
        ElliottWave_PriceLimitMethod(::ElliottWave_PriceLimitMethod),
        ElliottWave_PriceLimitLevel(::ElliottWave_PriceLimitLevel),
        ElliottWave_MaxSpread(::ElliottWave_MaxSpread) {}
};

// Loads pair specific param values.
#include "sets/EURUSD_H1.h"
#include "sets/EURUSD_H4.h"
#include "sets/EURUSD_M1.h"
#include "sets/EURUSD_M15.h"
#include "sets/EURUSD_M30.h"
#include "sets/EURUSD_M5.h"

class Stg_ElliottWave : public Strategy {
 public:
  Stg_ElliottWave(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_ElliottWave *Init(ENUM_TIMEFRAMES _tf = NULL, long _magic_no = NULL, ENUM_LOG_LEVEL _log_level = V_INFO) {
    // Initialize strategy initial values.
    Stg_ElliottWave_Params _params;
    switch (_tf) {
      case PERIOD_M1: {
        Stg_ElliottWave_EURUSD_M1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M5: {
        Stg_ElliottWave_EURUSD_M5_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M15: {
        Stg_ElliottWave_EURUSD_M15_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_M30: {
        Stg_ElliottWave_EURUSD_M30_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H1: {
        Stg_ElliottWave_EURUSD_H1_Params _new_params;
        _params = _new_params;
      }
      case PERIOD_H4: {
        Stg_ElliottWave_EURUSD_H4_Params _new_params;
        _params = _new_params;
      }
    }
    // Initialize strategy parameters.
    ChartParams cparams(_tf);
    /*
    ElliottWave_Params ew_params(_params.ElliottWave_Period, _params.ElliottWave_Applied_Price);
    IndicatorParams ew_iparams(10, INDI_ELLIOTTWAVE);
    StgParams sparams(new Trade(_tf, _Symbol), new Indi_ElliottWave(ew_params, ew_iparams, cparams), NULL, NULL);
    sparams.logger.SetLevel(_log_level);
    sparams.SetMagicNo(_magic_no);
    sparams.SetSignals(_params.ElliottWave_SignalOpenMethod, _params.ElliottWave_SignalOpenLevel,
_params.ElliottWave_OpenFilterMethod, _params.ElliottWave_OpenBoostMethod,
                       _params.ElliottWave_SignalCloseMethod, _params.ElliottWave_SignalCloseMethod);
    sparams.SetMaxSpread(_params.ElliottWave_MaxSpread);
    // Initialize strategy instance.
    Strategy *_strat = new Stg_ElliottWave(sparams, "ElliottWave");
    return _strat;
    */
    return NULL;
  }

  /**
   * Update indicator values.
   */
  /*
  int Update(int _tf) {
    int limit, i, counter;
    int tframe = TfToIndex(_tf);
    i = 1;
    fasterEMA[0][tframe] = iMA(NULL, tf, FasterEMA, 0, MODE_LWMA, PRICE_CLOSE, i);      // now
    fasterEMA[1][tframe] = iMA(NULL, tf, FasterEMA, 0, MODE_LWMA, PRICE_CLOSE, i + 1);  // previous
    fasterEMA[2][tframe] = iMA(NULL, tf, FasterEMA, 0, MODE_LWMA, PRICE_CLOSE, i - 1);  // after

    slowerEMA[0][tframe] = iMA(NULL, tf, SlowerEMA, 0, MODE_LWMA, PRICE_CLOSE, i);
    slowerEMA[1][tframe] = iMA(NULL, tf, SlowerEMA, 0, MODE_LWMA, PRICE_CLOSE, i + 1);
    slowerEMA[2][tframe] = iMA(NULL, tf, SlowerEMA, 0, MODE_LWMA, PRICE_CLOSE, i - 1);

    return True;
  }
  */

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method = 0, double _level = 0.0) {
    bool _result = false;
    /*
    // @todo
    //  counted_bars=Bars;
    string TimeFrameStr;
    int tframe = TfToIndex(tf);

    if ((fasterEMA[0][tframe] > slowerEMA[0][tframe]) && (fasterEMA[1][tframe] < slowerEMA[1][tframe]) &&
        (fasterEMA[2][tframe] > slowerEMA[2][tframe]) && (_cmd == OP_BUY)) {
      return True;
    } else if ((fasterEMA[0][tframe] < slowerEMA[0][tframe]) && (fasterEMA[1][tframe] > slowerEMA[1][tframe]) &&
               (fasterEMA[2][tframe] < slowerEMA[2][tframe]) && (_cmd == OP_SELL)) {
      return True;
    }
    */

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
