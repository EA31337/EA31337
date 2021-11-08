//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                                 Copyright 2016-2021, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Main code.
#include "EA31337.mq5"

// EA indicator resources.
#ifdef __resource__
// Indicator resources.
#resource INDI_EWO_OSC_PATH + "\\Elliott_Wave_Oscillator2" + MQL_EXT
#resource INDI_SVEBB_PATH + "\\SVE_Bollinger_Bands" + MQL_EXT
#resource INDI_TMA_CG_PATH + "\\TMA+CG_mladen_NRP" + MQL_EXT
//#resource INDI_ATR_MA_TREND_PATH + "\\ATR_MA_Trend" + MQL_EXT
#resource INDI_TMA_TRUE_PATH + "\\TMA_True" + MQL_EXT
#resource INDI_SAWA_PATH + "\\SAWA" + MQL_EXT
//#resource INDI_SUPERTREND_PATH + "\\SuperTrend" + MQL_EXT
#endif
