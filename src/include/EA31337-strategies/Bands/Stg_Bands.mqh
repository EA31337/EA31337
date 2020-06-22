//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * @file
 * Implements Bands strategy.
 */

// Includes.
#include "../../EA31337-classes/Indicators/Indi_Bands.mqh"
#include "../../EA31337-classes/Strategy.mqh"

// User input params.
INPUT string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --"; // >>> BANDS <<<
INPUT uint Bands_Active_Tf = 0; // Activate timeframes (1-255, e.g. M1=1,M5=2,M15=4,M30=8,H1=16,H2=32...)
INPUT int Bands_Period_M1 = 2; // Period for M1
INPUT int Bands_Period_M5 = 2; // Period for M5
INPUT int Bands_Period_M15 = 2; // Period for M15
INPUT int Bands_Period_M30 = 2; // Period for M30
INPUT ENUM_APPLIED_PRICE Bands_Applied_Price = (ENUM_APPLIED_PRICE) 0; // Applied Price
INPUT double Bands_Deviation_M1 = 0.3; // Deviation for M1
INPUT double Bands_Deviation_M5 = 0.3; // Deviation for M5
INPUT double Bands_Deviation_M15 = 0.3; // Deviation for M15
INPUT double Bands_Deviation_M30 = 0.3; // Deviation for M30
INPUT int Bands_HShift = 0; // Horizontal shift
INPUT int Bands_Shift = 0; // Shift (relative to the current bar, 0 - default)
INPUT ENUM_TRAIL_TYPE Bands_TrailingStopMethod = 7; // Trail stop method
INPUT ENUM_TRAIL_TYPE Bands_TrailingProfitMethod = 22; // Trail profit method
INPUT int Bands_SignalLevel = 18; // Signal level
INPUT int Bands1_SignalMethod = -85; // Signal method for M1 (-127-127)
INPUT int Bands5_SignalMethod = -74; // Signal method for M5 (-127-127)
INPUT int Bands15_SignalMethod = -127; // Signal method for M15 (-127-127)
INPUT int Bands30_SignalMethod = -127; // Signal method for M30 (-127-127)
INPUT int Bands1_OpenCondition1 = 971; // Open condition 1 for M1 (0-1023)
INPUT int Bands1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
INPUT ENUM_MARKET_EVENT Bands1_CloseCondition = 24; // Close condition for M1
INPUT int Bands5_OpenCondition1 = 971; // Open condition 1 for M5 (0-1023)
INPUT int Bands5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
INPUT ENUM_MARKET_EVENT Bands5_CloseCondition = 11; // Close condition for M5
INPUT int Bands15_OpenCondition1 = 292; // Open condition 1 for M15 (0-1023)
INPUT int Bands15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
INPUT ENUM_MARKET_EVENT Bands15_CloseCondition = 2; // Close condition for M15
INPUT int Bands30_OpenCondition1 = 292; // Open condition 1 for M30 (0-1023)
INPUT int Bands30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
INPUT ENUM_MARKET_EVENT Bands30_CloseCondition = 1; // Close condition for M30
INPUT double Bands1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
INPUT double Bands5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
INPUT double Bands15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
INPUT double Bands30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

class Stg_Bands : public Strategy {

  public:

  void Stg_Bands(StgParams &_params, string _name) : Strategy(_params, _name) {}

  static Stg_Bands *Init_M1() {
    ChartParams cparams1(PERIOD_M1);
    IndicatorParams bands_iparams(10, INDI_BANDS);
    Bands_Params bands1_iparams(Bands_Period_M1, Bands_Deviation_M1, Bands_HShift, Bands_Applied_Price);
    StgParams bands1_sparams(new Trade(PERIOD_M1, _Symbol), new Indi_Bands(bands1_iparams, bands_iparams, cparams1), NULL, NULL);
    bands1_sparams.SetSignals(Bands1_SignalMethod, Bands1_OpenCondition1, Bands1_OpenCondition2, Bands1_CloseCondition, NULL, Bands_SignalLevel, NULL);
    bands1_sparams.SetStops(Bands_TrailingProfitMethod, Bands_TrailingStopMethod);
    bands1_sparams.SetMaxSpread(Bands1_MaxSpread);
    bands1_sparams.SetId(BANDS1);
    return (new Stg_Bands(bands1_sparams, "Bands1"));
  }
  static Stg_Bands *Init_M5() {
    ChartParams cparams5(PERIOD_M5);
    IndicatorParams bands_iparams(10, INDI_BANDS);
    Bands_Params bands5_iparams(Bands_Period_M5, Bands_Deviation_M5, Bands_HShift, Bands_Applied_Price);
    StgParams bands5_sparams(new Trade(PERIOD_M5, _Symbol), new Indi_Bands(bands5_iparams, bands_iparams, cparams5), NULL, NULL);
    bands5_sparams.SetSignals(Bands5_SignalMethod, Bands5_OpenCondition1, Bands5_OpenCondition2, Bands5_CloseCondition, NULL, Bands_SignalLevel, NULL);
    bands5_sparams.SetStops(Bands_TrailingProfitMethod, Bands_TrailingStopMethod);
    bands5_sparams.SetMaxSpread(Bands5_MaxSpread);
    bands5_sparams.SetId(BANDS5);
    return (new Stg_Bands(bands5_sparams, "Bands5"));
  }
  static Stg_Bands *Init_M15() {
    ChartParams cparams15(PERIOD_M15);
    IndicatorParams bands_iparams(10, INDI_BANDS);
    Bands_Params bands15_iparams(Bands_Period_M15, Bands_Deviation_M15, Bands_HShift, Bands_Applied_Price);
    StgParams bands15_sparams(new Trade(PERIOD_M15, _Symbol), new Indi_Bands(bands15_iparams, bands_iparams, cparams15), NULL, NULL);
    bands15_sparams.SetSignals(Bands15_SignalMethod, Bands15_OpenCondition1, Bands15_OpenCondition2, Bands15_CloseCondition, NULL, Bands_SignalLevel, NULL);
    bands15_sparams.SetStops(Bands_TrailingProfitMethod, Bands_TrailingStopMethod);
    bands15_sparams.SetMaxSpread(Bands15_MaxSpread);
    bands15_sparams.SetId(BANDS15);
    return (new Stg_Bands(bands15_sparams, "Bands15"));
  }
  static Stg_Bands *Init_M30() {
    ChartParams cparams30(PERIOD_M30);
    IndicatorParams bands_iparams(10, INDI_BANDS);
    Bands_Params bands30_iparams(Bands_Period_M30, Bands_Deviation_M30, Bands_HShift, Bands_Applied_Price);
    StgParams bands30_sparams(new Trade(PERIOD_M30, _Symbol), new Indi_Bands(bands30_iparams, bands_iparams, cparams30), NULL, NULL);
    bands30_sparams.SetSignals(Bands30_SignalMethod, Bands30_OpenCondition1, Bands30_OpenCondition2, Bands30_CloseCondition, NULL, Bands_SignalLevel, NULL);
    bands30_sparams.SetStops(Bands_TrailingProfitMethod, Bands_TrailingStopMethod);
    bands30_sparams.SetMaxSpread(Bands30_MaxSpread);
    bands30_sparams.SetId(BANDS30);
    return (new Stg_Bands(bands30_sparams, "Bands30"));
  }
  static Stg_Bands *Init(ENUM_TIMEFRAMES _tf) {
    switch (_tf) {
      case PERIOD_M1:  return Init_M1();
      case PERIOD_M5:  return Init_M5();
      case PERIOD_M15: return Init_M15();
      case PERIOD_M30: return Init_M30();
      default: return NULL;
    }
  }

  /**
   * Check if Bands indicator is on buy or sell.
   *
   * @param
   *   cmd (int) - type of trade order command
   *   period (int) - period to check for
   *   _signal_method (int) - signal method to use by using bitwise AND operation
   *   _signal_level1 (double) - signal level to consider the signal
   */
  bool SignalOpen(ENUM_ORDER_TYPE cmd, long _signal_method = EMPTY, double _signal_level1 = EMPTY, double _signal_level2 = EMPTY) {
    bool _result = false;
    double bands_0_base  = ((Indi_Bands *) this.Data()).GetValue(BAND_BASE, 0);
    double bands_0_lower = ((Indi_Bands *) this.Data()).GetValue(BAND_LOWER, 0);
    double bands_0_upper = ((Indi_Bands *) this.Data()).GetValue(BAND_UPPER, 0);
    double bands_1_base  = ((Indi_Bands *) this.Data()).GetValue(BAND_BASE, 1);
    double bands_1_lower = ((Indi_Bands *) this.Data()).GetValue(BAND_LOWER, 1);
    double bands_1_upper = ((Indi_Bands *) this.Data()).GetValue(BAND_UPPER, 1);
    double bands_2_base  = ((Indi_Bands *) this.Data()).GetValue(BAND_BASE, 2);
    double bands_2_lower = ((Indi_Bands *) this.Data()).GetValue(BAND_LOWER, 2);
    double bands_2_upper = ((Indi_Bands *) this.Data()).GetValue(BAND_UPPER, 2);
    if (_signal_method == EMPTY) _signal_method = GetSignalBaseMethod();
    if (_signal_level1 == EMPTY) _signal_level1 = GetSignalLevel1();
    if (_signal_level2 == EMPTY) _signal_level2 = GetSignalLevel2();
    double lowest = fmin(Low[CURR], fmin(Low[PREV], Low[FAR]));
    double highest = fmax(High[CURR], fmax(High[PREV], High[FAR]));
    double level = _signal_level1 * pip_size;
    switch (cmd) {
      // Buy: price crossed lower line upwards (returned to it from below).
      case ORDER_TYPE_BUY:
        // Price value was lower than the lower band.
        _result = (
            lowest > 0 && lowest < fmax(fmax(bands_0_lower, bands_1_lower), bands_2_lower)
            ) - level;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= fmin(Close[PREV], Close[FAR]) < bands_0_lower;
          if (METHOD(_signal_method, 1)) _result &= (bands_0_lower > bands_2_lower);
          if (METHOD(_signal_method, 2)) _result &= (bands_0_base > bands_2_base);
          if (METHOD(_signal_method, 3)) _result &= (bands_0_upper > bands_2_upper);
          if (METHOD(_signal_method, 4)) _result &= highest > bands_0_base;
          if (METHOD(_signal_method, 5)) _result &= Open[CURR] < bands_0_base;
          if (METHOD(_signal_method, 6)) _result &= fmin(Close[PREV], Close[FAR]) > bands_0_base;
          // if (METHOD(_signal_method, 7)) _result &= !Trade_Bands(Convert::NegateOrderType(cmd), (ENUM_TIMEFRAMES) Convert::IndexToTf(fmin(period + 1, M30)));
        }
        break;
      // Sell: price crossed upper line downwards (returned to it from above).
      case ORDER_TYPE_SELL:
        // Price value was higher than the upper band.
        _result = (
            lowest > 0 && highest > fmin(fmin(bands_0_upper, bands_1_upper), bands_2_upper)
            ) + level;
        if (_signal_method != 0) {
          if (METHOD(_signal_method, 0)) _result &= fmin(Close[PREV], Close[FAR]) > bands_0_upper;
          if (METHOD(_signal_method, 1)) _result &= (bands_0_lower < bands_2_lower);
          if (METHOD(_signal_method, 2)) _result &= (bands_0_base < bands_2_base);
          if (METHOD(_signal_method, 3)) _result &= (bands_0_upper < bands_2_upper);
          if (METHOD(_signal_method, 4)) _result &= lowest < bands_0_base;
          if (METHOD(_signal_method, 5)) _result &= Open[CURR] > bands_0_base;
          if (METHOD(_signal_method, 6)) _result &= fmin(Close[PREV], Close[FAR]) < bands_0_base;
          // if (METHOD(_signal_method, 7)) _result &= !Trade_Bands(Convert::NegateOrderType(cmd), (ENUM_TIMEFRAMES) Convert::IndexToTf(fmin(period + 1, M30)));
        }
        break;
    }
    _result &= _signal_method <= 0 || Convert::ValueToOp(curr_trend) == cmd;
    return _result;
  }

};
