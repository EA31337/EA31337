//+------------------------------------------------------------------+
//|                                                     ea-enums.mqh |
//|                            Copyright 2016, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016-2017, 31337 Investments Ltd"
#property link      "https://github.com/EA31337"

/*
 * Default enumerations:
 *
 * ENUM_MA_METHOD values:
 *   0: MODE_SMA (Simple averaging)
 *   1: MODE_EMA (Exponential averaging)
 *   2: MODE_SMMA (Smoothed averaging)
 *   3: MODE_LWMA (Linear-weighted averaging)
 *
 * ENUM_APPLIED_PRICE values:
 *   0: PRICE_CLOSE (Close price)
 *   1: PRICE_OPEN (Open price)
 *   2: PRICE_HIGH (The maximum price for the period)
 *   3: PRICE_LOW (The minimum price for the period)
 *   4: PRICE_MEDIAN (Median price) = (high + low)/2
 *   5: PRICE_TYPICAL (Typical price) = (high + low + close)/3
 *   6: PRICE_WEIGHTED (Average price) = (high + low + close + close)/4
 *
 * Trade operation:
 *   0: OP_BUY (Buy operation)
 *   1: OP_SELL (Sell operation)
 *   2: OP_BUYLIMIT (Buy limit pending order)
 *   3: OP_SELLLIMIT (Sell limit pending order)
 *   4: OP_BUYSTOP (Buy stop pending order)
 *   5: OP_SELLSTOP (Sell stop pending order)
 */

//+------------------------------------------------------------------+
//| EA enumerations.
//+------------------------------------------------------------------+
enum ENUM_STRATEGY_TYPE { // Define type of strategies.
  // Type of strategy being used (used for strategy identification, new strategies append to the end, but in general - do not change!).
  AC1,
  AC5,
  AC15,
  AC30,
  AD1,
  AD5,
  AD15,
  AD30,
  ADX1,
  ADX5,
  ADX15,
  ADX30,
  ALLIGATOR1,
  ALLIGATOR5,
  ALLIGATOR15,
  ALLIGATOR30,
  ATR1,
  ATR5,
  ATR15,
  ATR30,
  AWESOME1,
  AWESOME5,
  AWESOME15,
  AWESOME30,
  BANDS1,
  BANDS5,
  BANDS15,
  BANDS30,
  BPOWER1,
  BPOWER5,
  BPOWER15,
  BPOWER30,
  BREAKAGE1,
  BREAKAGE5,
  BREAKAGE15,
  BREAKAGE30,
  BWMFI1,
  BWMFI5,
  BWMFI15,
  BWMFI30,
  CCI1,
  CCI5,
  CCI15,
  CCI30,
  DEMARKER1,
  DEMARKER5,
  DEMARKER15,
  DEMARKER30,
  ENVELOPES1,
  ENVELOPES5,
  ENVELOPES15,
  ENVELOPES30,
  FORCE1,
  FORCE5,
  FORCE15,
  FORCE30,
  FRACTALS1,
  FRACTALS5,
  FRACTALS15,
  FRACTALS30,
  GATOR1,
  GATOR5,
  GATOR15,
  GATOR30,
  ICHIMOKU1,
  ICHIMOKU5,
  ICHIMOKU15,
  ICHIMOKU30,
  MA1,
  MA5,
  MA15,
  MA30,
  MACD1,
  MACD5,
  MACD15,
  MACD30,
  MFI1,
  MFI5,
  MFI15,
  MFI30,
  MOMENTUM1,
  MOMENTUM5,
  MOMENTUM15,
  MOMENTUM30,
  OBV1,
  OBV5,
  OBV15,
  OBV30,
  OSMA1,
  OSMA5,
  OSMA15,
  OSMA30,
  RSI1,
  RSI5,
  RSI15,
  RSI30,
  RVI1,
  RVI5,
  RVI15,
  RVI30,
  SAR1,
  SAR5,
  SAR15,
  SAR30,
  STDDEV1,
  STDDEV5,
  STDDEV15,
  STDDEV30,
  STOCHASTIC1,
  STOCHASTIC5,
  STOCHASTIC15,
  STOCHASTIC30,
  WPR1,
  WPR5,
  WPR15,
  WPR30,
  ZIGZAG1,
  ZIGZAG5,
  ZIGZAG15,
  ZIGZAG30,
#ifdef __advanced__
  CUSTOM1,
  CUSTOM2,
  CUSTOM3,
  CUSTOM4,
  CUSTOM5,
#endif
  FINAL_STRATEGY_TYPE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_INDICATOR_TYPE { // Define type of indicator.
  S_AC         =  0,
  S_AD         =  1,
  S_ADX        =  2,
  S_ALLIGATOR  =  3,
  S_ATR        =  4,
  S_AWESOME    =  5,
  S_BANDS      =  6,
  S_BPOWER     =  7,
  S_BWMFI      =  8,
  S_CCI        =  9,
  S_DEMARKER   = 10,
  S_ENVELOPES  = 11,
  S_FORCE      = 12,
  S_FRACTALS   = 13,
  S_GATOR      = 14,
  S_ICHIMOKU   = 15,
  S_MA         = 16,
  S_MACD       = 17,
  S_MFI        = 18,
  S_MOMENTUM   = 19,
  S_OBV        = 20,
  S_OSMA       = 21,
  S_RSI        = 22,
  S_RVI        = 23,
  S_SAR        = 24,
  S_STDDEV     = 25,
  S_STOCHASTIC = 26,
  S_WPR        = 27,
  S_ZIGZAG     = 28,
  FINAL_INDICATOR_TYPE_ENTRY
};

enum ENUM_STRATEGY_INFO { // Define type of strategy information entry.
  ACTIVE,
  SUSPENDED,
  TIMEFRAME,
  INDICATOR,
  OPEN_METHOD,
  STOP_METHOD,
  PROFIT_METHOD,
  CUSTOM_PERIOD,
  OPEN_CONDITION1,
  OPEN_CONDITION2,
  CLOSE_CONDITION,
  OPEN_ORDERS,
  TOTAL_ORDERS,
  TOTAL_ORDERS_LOSS,
  TOTAL_ORDERS_WON,
  TOTAL_ERRORS,
  FINAL_STRATEGY_INFO_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_STRATEGY_VALUE { // Define strategy value entry.
  LOT_SIZE,      // Lot size to trade.
  FACTOR,        // Multiply lot factor.
  PROFIT_FACTOR, // Profit factor.
  OPEN_LEVEL,    // Value to raise the signal.
  SPREAD_LIMIT,  // Spread limit.
  FINAL_STRATEGY_VALUE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_STRATEGY_STAT_VALUE { // Define strategy statistics entries.
  DAILY_PROFIT,
  WEEKLY_PROFIT,
  MONTHLY_PROFIT,
  TOTAL_GROSS_PROFIT,
  TOTAL_GROSS_LOSS,
  TOTAL_NET_PROFIT,
  TOTAL_PIP_PROFIT,
  AVG_SPREAD,
  FINAL_STRATEGY_STAT_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_TASK_TYPE { // Define type of tasks.
  TASK_ORDER_OPEN,
  TASK_ORDER_CLOSE,
  TASK_CALC_STATS,
};

enum ENUM_VALUE_TYPE { // Define type of values in order to store.
  MAX_LOW,
  MAX_HIGH,
  MAX_SPREAD,
  MAX_DROP,
  // MAX_TICK,
  MAX_LOSS,
  MAX_PROFIT,
  MAX_BALANCE,
  MAX_EQUITY,
  MAX_ORDERS, // Max opened orders.
  FINAL_VALUE_TYPE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_ORDER_QUEUE_ENTRY { // Define order queue.
  Q_SID,        // Strategy id.
  Q_CMD,        // Type of trade order.
  Q_TIME,       // Time requested to open.
  Q_TOTAL,      // Total number of orders queued.
  FINAL_ORDER_QUEUE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_TRAIL_TYPE { // Define type of trailing types.
  T_NONE               =   0, // None
  T1_FIXED             =   1, // Fixed
  T2_FIXED             =  -1, // Bi-way: Fixed
  T1_OPEN_PREV         =   2, // Previous open
  T2_OPEN_PREV         =  -2, // Bi-way: Previous open
  T1_2_BARS_PEAK       =   3, // 2 bars peak
  T2_2_BARS_PEAK       =  -3, // Bi-way: 2 bars peak
  T1_5_BARS_PEAK       =   4, // 5 bars peak
  T2_5_BARS_PEAK       =  -4, // Bi-way: 5 bars peak
  T1_10_BARS_PEAK      =   5, // 10 bars peak
  T2_10_BARS_PEAK      =  -5, // Bi-way: 10 bars peak
  T1_50_BARS_PEAK      =   6, // 50 bars peak
  T2_50_BARS_PEAK      =  -6, // Bi-way: 50 bars peak
  T1_150_BARS_PEAK     =   7, // 150 bars peak
  T2_150_BARS_PEAK     =  -7, // Bi-way: 150 bars peak
  T1_HALF_200_BARS     =   8, // 200 bars half price
  T2_HALF_200_BARS     =  -8, // Bi-way: 200 bars half price
  T1_HALF_PEAK_OPEN    =   9, // Half price peak
  T2_HALF_PEAK_OPEN    =  -9, // Bi-way: Half price peak
  T1_MA_F_PREV         =  10, // MA Fast Prev
  T2_MA_F_PREV         = -10, // Bi-way: MA Fast Prev
  T1_MA_F_FAR          =  11, // MA Fast Far
  T2_MA_F_FAR          = -11, // Bi-way: MA Fast Far
  T1_MA_F_TRAIL        =  12, // MA Fast+Trail
  T2_MA_F_TRAIL        = -12, // Bi-way: MA Fast+Trail
  T1_MA_F_FAR_TRAIL    =  13, // MA Fast Far+Trail
  T2_MA_F_FAR_TRAIL    = -13, // Bi-way: MA Fast Far+Trail
  T1_MA_M              =  14, // MA Med
  T2_MA_M              = -14, // Bi-way: MA Med
  T1_MA_M_FAR          =  15, // MA Med Far
  T2_MA_M_FAR          = -15, // Bi-way: MA Med Far
  T1_MA_M_LOW          =  16, // MA Med Low
  T2_MA_M_LOW          = -16, // Bi-way: MA Med Low
  T1_MA_M_TRAIL        =  17, // MA Med+Trail
  T2_MA_M_TRAIL        = -17, // Bi-way: MA Med+Trail
  T1_MA_M_FAR_TRAIL    =  18, // MA Med Far+Trail
  T2_MA_M_FAR_TRAIL    = -18, // Bi-way: MA Med Far+Trail
  T1_MA_S              =  19, // MA Slow
  T2_MA_S              = -19, // Bi-way: MA Slow
  T1_MA_S_FAR          =  20, // MA Slow Far
  T2_MA_S_FAR          = -20, // Bi-way: MA Slow Far
  T1_MA_S_TRAIL        =  21, // MA Slow+Trail
  T2_MA_S_TRAIL        = -21, // Bi-way: MA Slow+Trail
  T1_MA_FMS_PEAK       =  22, // MA F+M+S Peak
  T2_MA_FMS_PEAK       = -22, // Bi-way: MA F+M+S Peak
  T1_SAR               =  23, // SAR
  T2_SAR               = -23, // Bi-way: SAR
  T1_SAR_PEAK          =  24, // SAR Peak
  T2_SAR_PEAK          = -24, // Bi-way: SAR Peak
  T1_BANDS             =  25, // Bands
  T2_BANDS             = -25, // Bi-way: Bands
  T1_BANDS_PEAK        =  26, // Bands Peak
  T2_BANDS_PEAK        = -26, // Bi-way: Bands Peak
  T1_ENVELOPES         =  27, // Envelopes
  T2_ENVELOPES         = -27, // Bi-way: Envelopes
};

// Define account conditions.
enum ENUM_ACC_CONDITION {
  C_ACC_NONE           =  0, // None (inactive)
  C_ACC_TRUE           =  1, // Always true
  C_EQUITY_LOWER       =  2, // Equity lower than balance
  C_EQUITY_HIGHER      =  3, // Equity higher than balance
  C_EQUITY_50PC_HIGH   =  4, // Equity 50% high
  C_EQUITY_20PC_HIGH   =  5, // Equity 20% high
  C_EQUITY_10PC_HIGH   =  6, // Equity 10% high
  C_EQUITY_10PC_LOW    =  7, // Equity 10% low
  C_EQUITY_20PC_LOW    =  8, // Equity 20% low
  C_EQUITY_50PC_LOW    =  9, // Equity 50% low
  C_MARGIN_USED_50PC   = 10, // 50% Margin Used
  C_MARGIN_USED_70PC   = 11, // 70% Margin Used
  C_MARGIN_USED_80PC   = 12, // 80% Margin Used
  C_MARGIN_USED_90PC   = 13, // 90% Margin Used
  C_NO_FREE_MARGIN     = 14, // No free margin.
  C_ACC_IN_LOSS        = 15, // Account in loss
  C_ACC_IN_PROFIT      = 16, // Account in profit
  C_DBAL_LT_WEEKLY     = 17, // Max. daily balance < max. weekly
  C_DBAL_GT_WEEKLY     = 18, // Max. daily balance > max. weekly
  C_WBAL_LT_MONTHLY    = 19, // Max. weekly balance < max. monthly
  C_WBAL_GT_MONTHLY    = 20, // Max. weekly balance > max. monthly
  C_ACC_IN_TREND       = 21, // Account in trend
  C_ACC_IN_NON_TREND   = 22, // Account is against trend
  C_ACC_CDAY_IN_PROFIT = 23, // Current day in profit
  C_ACC_CDAY_IN_LOSS   = 24, // Current day in loss
  C_ACC_PDAY_IN_PROFIT = 25, // Previous day in profit
  C_ACC_PDAY_IN_LOSS   = 26, // Previous day in loss
  C_ACC_MAX_ORDERS     = 27, // Max orders opened
};

// Define market conditions.
enum ENUM_MARKET_CONDITION {
  C_MARKET_NONE        =  0, // None (false).
  C_MARKET_TRUE        =  1, // Always true
  C_MA1_FS_ORDERS_OPP  =  2, // MA1 Fast&Slow orders-based opposite
  C_MA5_FS_ORDERS_OPP  =  3, // MA5 Fast&Slow orders-based opposite
  C_MA15_FS_ORDERS_OPP =  4, // MA15 Fast&Slow orders-based opposite
  C_MA30_FS_ORDERS_OPP =  5, // MA30 Fast&Slow orders-based opposite
  C_MA1_FS_TREND_OPP   =  6, // MA1 Fast&Slow trend-based opposite
  C_MA5_FS_TREND_OPP   =  7, // MA5 Fast&Slow trend-based opposite
  C_MA15_FS_TREND_OPP  =  8, // MA15 Fast&Slow trend-based opposite
  C_MA30_FS_TREND_OPP  =  9, // MA30 Fast&Slow trend-based opposite
  C_DAILY_PEAK         = 10, // Daily peak price
  C_WEEKLY_PEAK        = 11, // Weekly peak price
  C_MONTHLY_PEAK       = 12, // Monthly peak price
  C_MARKET_BIG_DROP    = 13, // Sudden price drop
  C_MARKET_VBIG_DROP   = 14, // Very big price drop
  C_MARKET_AT_HOUR     = 15, // At specific hour
  C_NEW_HOUR           = 16, // New hour
  C_NEW_DAY            = 17, // New day
  C_NEW_WEEK           = 18, // New week
  C_NEW_MONTH          = 19, // New month
};
// Note: Trend-based closures are using TrendMethodAction.

// Define type of actions which can be executed.
enum ENUM_ACTION_TYPE {
  A_NONE                   =  0, // None
  A_CLOSE_ORDER_PROFIT     =  1, // Close most profitable order
  A_CLOSE_ORDER_PROFIT_MIN =  2, // Close profitable above limit (MinProfitCloseOrder)
  A_CLOSE_ORDER_LOSS       =  3, // Close worse order
  A_CLOSE_ALL_IN_PROFIT    =  4, // Close all in profit
  A_CLOSE_ALL_IN_LOSS      =  5, // Close all in loss
  A_CLOSE_ALL_PROFIT_SIDE  =  6, // Close profit side
  A_CLOSE_ALL_LOSS_SIDE    =  7, // Close loss side
  A_CLOSE_ALL_TREND        =  8, // Close trend side
  A_CLOSE_ALL_NON_TREND    =  9, // Close non-trend side
  A_CLOSE_ALL_ORDERS       = 10, // Close all!
  A_SUSPEND_STRATEGIES     = 11, // Suspend all strategies
  A_UNSUSPEND_STRATEGIES   = 12, // Unsuspend all strategies
  A_RESET_STRATEGY_STATS   = 13, // Reset strategy stats
  FINAL_ACTION_TYPE_ENTRY  = 14  // (Not in use)
  // A_ORDER_STOPS_DECREASE   =  10, // Decrease loss stops
  // A_ORDER_PROFIT_DECREASE  =  11, // Decrease profit stops
};

// Define market event conditions.
enum ENUM_MARKET_EVENT {
  C_EVENT_NONE          =  0, // None
  C_AC_BUY_SELL         =  1, // AC on buy/sell
  C_AD_BUY_SELL         =  2, // AD on buy/sell
  C_ADX_BUY_SELL        =  3, // ADX on buy/sell
  C_ALLIGATOR_BUY_SELL  =  4, // Alligator on buy/sell
  C_ATR_BUY_SELL        =  5, // ATR on buy/sell
  C_AWESOME_BUY_SELL    =  6, // Awesome on buy/sell
  C_BANDS_BUY_SELL      =  7, // Bands on buy/sell
  C_BPOWER_BUY_SELL     =  8, // BPower on buy/sell
  C_BREAKAGE_BUY_SELL   =  9, // Breakage on buy/sell
  C_BWMFI_BUY_SELL      = 10, // BWMFI on buy/sell
  C_CCI_BUY_SELL        = 11, // CCI on buy/sell
  C_DEMARKER_BUY_SELL   = 12, // DeMarker on buy/sell
  C_ENVELOPES_BUY_SELL  = 13, // Envelopes on buy/sell
  C_FORCE_BUY_SELL      = 14, // Force on buy/sell
  C_FRACTALS_BUY_SELL   = 15, // Fractals on buy/sell
  C_GATOR_BUY_SELL      = 16, // Gator on buy/sell
  C_ICHIMOKU_BUY_SELL   = 17, // Ichimoku on buy/sell
  C_MA_BUY_SELL         = 18, // MA on buy/sell
  C_MACD_BUY_SELL       = 19, // MACD on buy/sell
  C_MFI_BUY_SELL        = 20, // MFI on buy/sell
  C_MOMENTUM_BUY_SELL   = 21, // Momentum on buy/sell
  C_OBV_BUY_SELL        = 22, // OBV on buy/sell
  C_OSMA_BUY_SELL       = 23, // OSMA on buy/sell
  C_RSI_BUY_SELL        = 24, // RSI on buy/sell
  C_RVI_BUY_SELL        = 25, // RVI on buy/sell
  C_SAR_BUY_SELL        = 26, // SAR on buy/sell
  C_STDDEV_BUY_SELL     = 27, // StdDev on buy/sell
  C_STOCHASTIC_BUY_SELL = 28, // Stochastic on buy/sell
  C_WPR_BUY_SELL        = 29, // WPR on buy/sell
  C_ZIGZAG_BUY_SELL     = 30, // ZigZag on buy/sell
  C_MA_FAST_SLOW_OPP    = 31, // MA Fast&Slow opposite
  C_MA_FAST_MED_OPP     = 32, // MA Fast&Med opposite
  C_MA_MED_SLOW_OPP     = 33, // MA Med&Slow opposite
#ifdef __advanced__
  C_CUSTOM1_BUY_SELL    = 34, // Custom 1 on buy/sell
  C_CUSTOM2_BUY_SELL    = 35, // Custom 2 on buy/sell
  C_CUSTOM3_BUY_SELL    = 36, // Custom 3 on buy/sell
  C_CUSTOM4_MARKET_COND = 37, // Custom 4 market condition
  C_CUSTOM5_MARKET_COND = 38, // Custom 5 market condition
  C_CUSTOM6_MARKET_COND = 39, // Custom 6 market condition
#endif
};

// Define reasons.
enum ENUM_REASON_TYPE {
  R_NONE                = C_ACC_NONE, // None
  R_TRUE                = C_ACC_TRUE, // True
  R_EQUITY_LOWER        = C_EQUITY_LOWER, // Equity lower than balance.
  R_EQUITY_HIGHER       = C_EQUITY_HIGHER, // Equity higher than balance.
  R_EQUITY_50PC_HIGH    = C_EQUITY_50PC_HIGH, // Equity 50% high.
  R_EQUITY_20PC_HIGH    = C_EQUITY_20PC_HIGH, // Equity 20% high.
  R_EQUITY_10PC_HIGH    = C_EQUITY_10PC_HIGH, // Equity 10% high.
  R_EQUITY_10PC_LOW     = C_EQUITY_10PC_LOW, // Equity 10% low.
  R_EQUITY_20PC_LOW     = C_EQUITY_20PC_LOW, // Equity 20% low.
  R_EQUITY_50PC_LOW     = C_EQUITY_50PC_LOW, // Equity 50% low.
  R_MARGIN_USED_50PC    = C_MARGIN_USED_50PC, // 50% Margin Used.
  R_MARGIN_USED_70PC    = C_MARGIN_USED_70PC, // 70% Margin Used.
  R_MARGIN_USED_80PC    = C_MARGIN_USED_80PC, // 80% Margin Used.
  R_MARGIN_USED_90PC    = C_MARGIN_USED_90PC, // 90% Margin Used.
  R_NO_FREE_MARGIN      = C_NO_FREE_MARGIN, // No free margin.
  R_ACC_IN_LOSS         = C_ACC_IN_LOSS, // Account in loss.
  R_ACC_IN_PROFIT       = C_ACC_IN_PROFIT, // Account in profit.
  R_DBAL_LT_WEEKLY      = C_DBAL_LT_WEEKLY, // Max. daily balance < max. weekly.
  R_DBAL_GT_WEEKLY      = C_DBAL_GT_WEEKLY, // Max. daily balance > max. weekly.
  R_WBAL_LT_MONTHLY     = C_WBAL_LT_MONTHLY, // Max. weekly balance < max. monthly.
  R_WBAL_GT_MONTHLY     = C_WBAL_GT_MONTHLY, // Max. weekly balance > max. monthly.
  R_ACC_IN_TREND        = C_ACC_IN_TREND, // Account in trend.
  R_ACC_IN_NON_TREND    = C_ACC_IN_NON_TREND, // Account is against trend.
  R_ACC_CDAY_IN_PROFIT  = C_ACC_CDAY_IN_PROFIT, // Current day in profit.
  R_ACC_CDAY_IN_LOSS    = C_ACC_CDAY_IN_LOSS, // Current day in loss.
  R_ACC_PDAY_IN_PROFIT  = C_ACC_PDAY_IN_PROFIT, // Previous day in profit.
  R_ACC_PDAY_IN_LOSS    = C_ACC_PDAY_IN_LOSS, // Previous day in loss.
  R_ACC_MAX_ORDERS      = C_ACC_MAX_ORDERS, // Maximum orders opened.
  R_OPPOSITE_SIGNAL, // Opposite signal.
  R_ORDER_EXPIRED,   // Order is expired.
};

enum ENUM_STAT_PERIOD_TYPE { // Define type of tasks.
  DAILY   = 0, // Daily
  WEEKLY  = 1, // Weekly
  MONTHLY = 2, // Monthly
  YEARLY  = 3, // Yearly
  FINAL_STAT_PERIOD_TYPE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

// Indicator enumerations.
enum ENUM_MA { FAST = 0, MEDIUM = 1, SLOW = 2, FINAL_MA_ENTRY };
#ifdef __MQL4__
   enum ENUM_LINE { UPPER = MODE_UPPER, LOWER = MODE_LOWER, FINAL_LINE_ENTRY };
#else
   enum ENUM_LINE { UPPER = UPPER_LINE, LOWER = LOWER_LINE, FINAL_LINE_ENTRY };
#endif
#ifdef __MQL4__
   enum ENUM_ALLIGATOR { JAW = MODE_GATORJAW, TEETH = MODE_GATORTEETH, LIPS = MODE_GATORLIPS, FINAL_ALLIGATOR_ENTRY };
#else
   enum ENUM_ALLIGATOR { JAW = GATORJAW_LINE, TEETH = GATORTEETH_LINE, LIPS = GATORLIPS_LINE, FINAL_ALLIGATOR_ENTRY };
#endif
#ifdef __MQL4__
   enum ENUM_ADX { ADX_MAIN = MODE_MAIN, ADX_PLUSDI = MODE_PLUSDI, ADX_MINUSDI = MODE_MINUSDI, FINAL_ADX_ENTRY };
#else
   enum ENUM_ADX { ADX_MAIN = MAIN_LINE, ADX_PLUSDI = PLUSDI_LINE, ADX_MINUSDI = MINUSDI_LINE, FINAL_ADX_ENTRY };
#endif
#ifdef __MQL4__
   enum ENUM_BANDS { BANDS_BASE = MODE_MAIN, BANDS_UPPER = MODE_UPPER, BANDS_LOWER = MODE_LOWER, FINAL_BANDS_ENTRY };
#else
   enum ENUM_BANDS { BANDS_BASE = BASE_LINE, BANDS_UPPER = UPPER_BAND, BANDS_LOWER = LOWER_BAND, FINAL_BANDS_ENTRY };
#endif
#ifdef __MQL4__
  enum ENUM_SLINE { MAIN = MODE_MAIN, SIGNAL_LINE = MODE_SIGNAL, FINAL_SLINE_ENTRY };
#else
  enum ENUM_SLINE { MAIN = MAIN_LINE, SIGNAL = SIGNAL_LINE, FINAL_SLINE_ENTRY };
#endif
#ifdef __MQL4__
   enum ENUM_ICHIMOKU { TENKANSEN_LINE = MODE_TENKANSEN, KIJUNSEN_LINE = MODE_KIJUNSEN, SENKOUSPANA_LINE = MODE_SENKOUSPANA, SENKOUSPANB_LINE = MODE_SENKOUSPANB, CHIKOUSPAN_LINE = MODE_CHIKOUSPAN };
#endif
