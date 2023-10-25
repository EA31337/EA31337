//+------------------------------------------------------------------+
//|                                 Copyright 2016-2023, EA31337 Ltd |
//|                                       https://ea31337.github.io/ |
//+------------------------------------------------------------------+

enum ENUM_EA_ADV_ACTION {
  EA_ADV_ACTION_NONE = 0,  // (None)
  // EA_ADV_ACTION_CLOSE_LEAST_LOSS,     // Close order with the least loss
  // EA_ADV_ACTION_CLOSE_LEAST_PROFIT,   // Close order with the least profit
  EA_ADV_ACTION_CLOSE_MOST_LOSS,              // Close order with the most loss
  EA_ADV_ACTION_CLOSE_MOST_PROFIT,            // Close order with the most profit
  EA_ADV_ACTION_ORDERS_CLOSE_ALL,             // Close all active orders
  EA_ADV_ACTION_ORDERS_CLOSE_IN_PROFIT,       // Close orders in profit
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND,        // Close orders in trend
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT,    // Close orders in not trend
  EA_ADV_ACTION_ORDERS_CLOSE_SIDE_IN_LOSS,    // Close orders in loss side
  EA_ADV_ACTION_ORDERS_CLOSE_SIDE_IN_PROFIT,  // Close orders in profit side
};
enum ENUM_EA_ADV_COND {
  EA_ADV_COND_NONE = 0,                 // (None)
  EA_ADV_COND_EA_ON_NEW_DAY,            // On each day
  EA_ADV_COND_EA_ON_NEW_WEEK,           // On each week
  EA_ADV_COND_EA_ON_NEW_MONTH,          // On each month
  EA_ADV_COND_ORDERS_IN_TREND,          // Active orders in trend
  EA_ADV_COND_ORDERS_IN_TREND_NOT,      // Active orders not in trend
  EA_ADV_COND_ORDERS_PROFIT_DBL_LOSS,   // Orders profit doubles loss
  EA_ADV_COND_TRADE_EQUITY_GT_01PC,     // Equity > 1%
  EA_ADV_COND_TRADE_EQUITY_GT_02PC,     // Equity > 2%
  EA_ADV_COND_TRADE_EQUITY_GT_05PC,     // Equity > 5%
  EA_ADV_COND_TRADE_EQUITY_GT_10PC,     // Equity > 10%
  EA_ADV_COND_TRADE_EQUITY_LT_01PC,     // Equity < 1%
  EA_ADV_COND_TRADE_EQUITY_LT_02PC,     // Equity < 2%
  EA_ADV_COND_TRADE_EQUITY_LT_05PC,     // Equity < 5%
  EA_ADV_COND_TRADE_EQUITY_LT_10PC,     // Equity < 10%
  EA_ADV_COND_TRADE_EQUITY_GT_RMARGIN,  // Equity > Risk margin
  EA_ADV_COND_TRADE_EQUITY_LT_RMARGIN,  // Equity < Risk margin
  // EA_ADV_COND_ACC_EQUITY,         // Equity (in %)
  // EA_ADV_COND_ACC_MARGIN_FREE,    // Free margin (in %)
  // EA_ADV_COND_ACC_MARGIN_USED,    // Free margin (in %)
  EA_ADV_COND_TRADE_IS_PEAK,   // Profitable side is at peak
  EA_ADV_COND_TRADE_IS_PIVOT,  // Profitable side is at pivot
};

// Defines enum with supported strategy list.
enum ENUM_STRATEGY {
  STRAT_NONE = 0,   // (None)
  STRAT_AC,         // AC
  STRAT_AD,         // AD
  STRAT_ADX,        // ADX
  STRAT_ALLIGATOR,  // Alligator
  STRAT_AMA,        // AMA
  STRAT_ARROWS,     // Arrows
  STRAT_ASI,        // ASI
  STRAT_ATR,        // ATR
#ifdef __MQL5__
// STRAT_ATR_MA_TREND,  // ATR MA Trend
#endif
  STRAT_AWESOME,                     // Awesome
  STRAT_BANDS,                       // Bands
  STRAT_BEARS_POWER,                 // Bear Power
  STRAT_BULLS_POWER,                 // Bulls Power
  STRAT_BWMFI,                       // BWMFI
  STRAT_CCI,                         // CCI
  STRAT_CHAIKIN,                     // Chaikin
  STRAT_DEMA,                        // DEMA
  STRAT_DEMARKER,                    // DeMarker
  STRAT_DPO,                         // DPO
  STRAT_ENVELOPES,                   // Envelopes
  STRAT_EWO,                         // ElliottWave
  STRAT_FORCE,                       // Force
  STRAT_FRACTALS,                    // Fractals
  STRAT_GATOR,                       // Gator
  STRAT_HEIKEN_ASHI,                 // Heiken Ashi
  STRAT_ICHIMOKU,                    // Ichimoku
  STRAT_INDICATOR,                   // Indicator
  STRAT_MA,                          // MA
  STRAT_MA_BREAKOUT,                 // MA Breakout
  STRAT_MA_CROSS_PIVOT,              // MA Cross Pivot
  STRAT_MA_CROSS_SHIFT,              // MA Cross Shift
  STRAT_MA_CROSS_SUP_RES,            // MA Cross Sup/Res
  STRAT_MA_CROSS_TIMEFRAME,          // MA Cross Timeframe
  STRAT_MA_TREND,                    // MA Trend
  STRAT_MACD,                        // MACD
  STRAT_MFI,                         // MFI
  STRAT_MOMENTUM,                    // Momentum
  STRAT_OBV,                         // OBV
  STRAT_OSCILLATOR,                  // Oscillator
  STRAT_OSCILLATOR_DIVERGENCE,       // Oscillator Divergence
  STRAT_OSCILLATOR_MARTINGALE,       // Oscillator Martingale
  STRAT_OSCILLATOR_MULTI,            // Oscillator Multi
  STRAT_OSCILLATOR_CROSS,            // Oscillator Cross
  STRAT_OSCILLATOR_CROSS_SHIFT,      // Oscillator Cross Shift
  STRAT_OSCILLATOR_CROSS_TIMEFRAME,  // Oscillator Cross Timeframe
  STRAT_OSCILLATOR_CROSS_ZERO,       // Oscillator Cross Zero
  STRAT_OSCILLATOR_OVERLAY,          // Oscillator Overlay
  STRAT_OSCILLATOR_RANGE,            // Oscillator Range
  STRAT_OSCILLATOR_TREND,            // Oscillator Trend
  STRAT_OSMA,                        // OSMA
  STRAT_PATTERN,                     // Pattern
  STRAT_PINBAR,                      // Pinbar
  STRAT_PIVOT,                       // Pivot
  STRAT_RETRACEMENT,                 // Retracement
  STRAT_RSI,                         // RSI
  STRAT_RVI,                         // RVI
  STRAT_SAR,                         // SAR
  // STRAT_SAWA,          // SAWA
  STRAT_STDDEV,      // StdDev
  STRAT_STOCHASTIC,  // Stochastic
#ifdef __MQL5__
// STRAT_SUPERTREND,    // Super Trend
#endif
  STRAT_SVE_BB,      // SVE Bollinger Bands
  STRAT_TMAT_SVEBB,  // TMAT SVEBB
  // STRAT_TMA_CG,        // TMA CG
  STRAT_TMA_TRUE,  // TMA True
  STRAT_WPR,       // WPR
  STRAT_ZIGZAG,    // ZigZag
  STRAT_META_BEARS_BULLS,        // (Meta) Bears & Bulls
  STRAT_META_DOUBLE,             // (Meta) Double
  STRAT_META_CONDITIONS,         // (Meta) Conditions
  STRAT_META_ENHANCE,            // (Meta) Enhance
  STRAT_META_EQUITY,             // (Meta) Equity
  STRAT_META_FORMATION,          // (Meta) Formation
  STRAT_META_INTERVAL,           // (Meta) Interval
  STRAT_META_HEDGE,              // (Meta) Hedge
  STRAT_META_LIMIT,              // (Meta) Limit
  STRAT_META_MA_CROSS,           // (Meta) MA Cross
  STRAT_META_MARGIN,             // (Meta) Margin
  STRAT_META_MARTINGALE,         // (Meta) Martingale
  STRAT_META_MIRROR,             // (Meta) Mirror
  STRAT_META_MULTI,              // (Meta) Multi
  STRAT_META_MULTI_CURRENCY,     // (Meta) Multi Currency
#ifdef __MQL5__
  STRAT_META_NEWS,               // (Meta) News
#endif
  STRAT_META_ORDER_LIMIT,        // (Meta) Order Limit
  STRAT_META_OSCILLATOR_FILTER,  // (Meta) Oscillator Filter
  STRAT_META_OSCILLATOR_SWITCH,  // (Meta) Oscillator Switch
  STRAT_META_PATTERN,            // (Meta) Pattern
  STRAT_META_PIVOT,              // (Meta) Pivot
  STRAT_META_PROFIT,             // (Meta) Profit
  STRAT_META_RESISTANCE,         // (Meta) Resistance
  STRAT_META_REVERSAL,           // (Meta) Reversal
  STRAT_META_RISK,               // (Meta) Risk
  STRAT_META_RSI,                // (Meta) RSI
  STRAT_META_SCALPER,            // (Meta) Scalper
  STRAT_META_SIGNAL_SWITCH,      // (Meta) Signal Switch
  STRAT_META_SPREAD,             // (Meta) Spread
  STRAT_META_TIMEZONE,           // (Meta) Timezone
  STRAT_META_TREND,              // (Meta) Trend
  STRAT_META_TRIO,               // (Meta) Trio
  STRAT_META_VOLATILITY,         // (Meta) Volatility
  STRAT_META_WEEKDAY,            // (Meta) Weekday
};
#define ENUM_STRATEGY_DEFINED

