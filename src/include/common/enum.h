//+------------------------------------------------------------------+
//|                                                           enum.h |
//|                                 Copyright 2016-2021, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

#ifdef __advanced__
enum ENUM_EA_ADV_ACTION {
  EA_ADV_ACTION_NONE = 0,  // (None)
  // EA_ADV_ACTION_CLOSE_LEAST_LOSS,     // Close order with the least loss
  // EA_ADV_ACTION_CLOSE_LEAST_PROFIT,   // Close order with the least profit
  EA_ADV_ACTION_CLOSE_MOST_LOSS,            // Close order with the most loss
  EA_ADV_ACTION_CLOSE_MOST_PROFIT,          // Close order with the most profit
  EA_ADV_ACTION_ORDERS_CLOSE_ALL,           // Close all active orders
  EA_ADV_ACTION_ORDERS_CLOSE_IN_PROFIT,     // Close orders in profit
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND,      // Close orders in trend
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT,  // Close orders in not trend
};
enum ENUM_EA_ADV_COND {
  EA_ADV_COND_NONE = 0,              // (None)
  EA_ADV_COND_TRADE_EQUITY_GT_01PC,  // Equity > 1%
  EA_ADV_COND_TRADE_EQUITY_GT_02PC,  // Equity > 2%
  EA_ADV_COND_TRADE_EQUITY_GT_05PC,  // Equity > 5%
  EA_ADV_COND_TRADE_EQUITY_GT_10PC,  // Equity > 10%
  EA_ADV_COND_TRADE_EQUITY_LT_01PC,  // Equity < 1%
  EA_ADV_COND_TRADE_EQUITY_LT_02PC,  // Equity < 2%
  EA_ADV_COND_TRADE_EQUITY_LT_05PC,  // Equity < 5%
  EA_ADV_COND_TRADE_EQUITY_LT_10PC,  // Equity < 10%
  // EA_ADV_COND_ACC_EQUITY,         // Equity (in %)
  // EA_ADV_COND_ACC_MARGIN_FREE,    // Free margin (in %)
  // EA_ADV_COND_ACC_MARGIN_USED,    // Free margin (in %)
  // EA_ADV_COND_ORDER_IN_PROFIT,      // Order (any) in profit
  // EA_ADV_COND_TRADE_IS_PEAK,   // Price's peak (no args)
  // EA_ADV_COND_TRADE_IS_PIVOT,  // Price's pivot (no args)
};
#endif

#define ENUM_STRATEGY_DEFINED
enum ENUM_STRATEGY {  // Define list of strategies.
  STRAT_NONE = 0,     // (None)
  STRAT_AC,           // AC
  STRAT_AD,           // AD
  STRAT_ADX,          // ADX
  STRAT_ALLIGATOR,    // Alligator
  STRAT_AMA,          // AMA
  STRAT_ASI,          // ASI
  STRAT_ATR,          // ATR
  STRAT_AWESOME,      // Awesome
  STRAT_BANDS,        // Bands
  STRAT_BEARS_POWER,  // Bear Power
  STRAT_BULLS_POWER,  // Bulls Power
  STRAT_BWMFI,        // BWMFI
  STRAT_CCI,          // CCI
  STRAT_CHAIKIN,      // Chaikin
  STRAT_DEMA,         // DEMA
  STRAT_DEMARKER,     // DeMarker
  STRAT_ENVELOPES,    // Envelopes
  STRAT_FORCE,        // Force
  STRAT_FRACTALS,     // Fractals
  STRAT_GATOR,        // Gator
  STRAT_HEIKEN_ASHI,  // Heiken Ashi
  STRAT_ICHIMOKU,     // Ichimoku
  STRAT_MA,           // MA
  STRAT_MACD,         // MACD
  STRAT_MFI,          // MFI
  STRAT_MOMENTUM,     // Momentum
  STRAT_OBV,          // OBV
  STRAT_OSMA,         // OSMA
  STRAT_PATTERN,      // Pattern
  STRAT_RSI,          // RSI
  STRAT_RVI,          // RVI
  STRAT_SAR,          // SAR
  STRAT_STDDEV,       // StdDev
  STRAT_STOCHASTIC,   // Stochastic
  STRAT_WPR,          // WPR
  STRAT_ZIGZAG,       // ZigZag
};
