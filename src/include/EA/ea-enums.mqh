//+------------------------------------------------------------------+
//|                                                     ea-enums.mqh |
//|                                           Copyright 2016, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, kenorb"
#property link      "https://github.com/EA31337"

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
  AC         =  0,
  AD         =  1,
  ADX        =  2,
  ALLIGATOR  =  3,
  ATR        =  4,
  AWESOME    =  5,
  BANDS      =  6,
  BPOWER     =  7,
  BWMFI      =  8,
  CCI        =  9,
  DEMARKER   = 10,
  ENVELOPES  = 11,
  FORCE      = 12,
  FRACTALS   = 13,
  GATOR      = 14,
  ICHIMOKU   = 15,
  MA         = 16,
  MACD       = 17,
  MFI        = 18,
  MOMENTUM   = 19,
  OBV        = 20,
  OSMA       = 21,
  RSI        = 22,
  RVI        = 23,
  SAR        = 24,
  STDDEV     = 25,
  STOCHASTIC = 26,
  WPR        = 27,
  ZIGZAG     = 28,
  FINAL_INDICATOR_TYPE_ENTRY
};

enum ENUM_STRATEGY_INFO { // Define type of strategy information entry.
  ACTIVE,
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
  LOT_SIZE,   // Lot size to trade.
  FACTOR,     // Multiply lot factor.
  OPEN_LEVEL, // Value to raise the signal.
  SPREAD_LIMIT,
  FINAL_STRATEGY_VALUE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_STRATEGY_STAT_VALUE { // Define strategy statistics entries.
  DAILY_PROFIT,
  WEEKLY_PROFIT,
  MONTHLY_PROFIT,
  TOTAL_GROSS_PROFIT,
  TOTAL_GROSS_LOSS,
  TOTAL_NET_PROFIT,
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
  MAX_TICK,
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
  T_NONE              =  0, // None
  T_FIXED             =  1, // Fixed
  T_CLOSE_PREV        =  2, // Previous close
  T_2_BARS_PEAK       =  3, // 2 bars peak
  T_5_BARS_PEAK       =  4, // 5 bars peak
  T_10_BARS_PEAK      =  5, // 10 bars peak
  T_50_BARS_PEAK      =  6, // 50 bars peak
  T_150_BARS_PEAK     =  7, // 150 bars peak
  T_HALF_200_BARS     =  8, // 200 bars half price
  T_HALF_PEAK_OPEN    =  9, // Half price peak
  T_MA_F_PREV         = 10, // MA Fast Prev
  T_MA_F_FAR          = 11, // MA Fast Far
  // T_MA_F_LOW          = 11, // MA Fast Low // ??
  T_MA_F_TRAIL        = 12, // MA Fast+Trail
  T_MA_F_FAR_TRAIL    = 13, // MA Fast Far+Trail
  T_MA_M              = 14, // MA Med
  T_MA_M_FAR          = 15, // MA Med Far
  // T_MA_M_LOW          = 16, // MA Med Low
  T_MA_M_TRAIL        = 17, // MA Med+Trail
  T_MA_M_FAR_TRAIL    = 18, // MA Med Far+Trail
  T_MA_S              = 19, // MA Slow
  T_MA_S_FAR          = 20, // MA Slow Far
  T_MA_S_TRAIL        = 21, // MA Slow+Trail
  T_MA_FMS_PEAK       = 22, // MA F+M+S Peak
  T_SAR               = 23, // SAR
  T_SAR_PEAK          = 24, // SAR Peak
  T_BANDS             = 25, // Bands
  T_BANDS_PEAK        = 26, // Bands Peak
  T_ENVELOPES         = 27, // Envelopes
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
  FINAL_ACTION_TYPE_ENTRY  = 11  // (Not in use)
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
  C_CCI_BUY_SELL        = 10, // CCI on buy/sell
  C_DEMARKER_BUY_SELL   = 11, // DeMarker on buy/sell
  C_ENVELOPES_BUY_SELL  = 12, // Envelopes on buy/sell
  C_FORCE_BUY_SELL      = 13, // Force on buy/sell
  C_FRACTALS_BUY_SELL   = 14, // Fractals on buy/sell
  C_GATOR_BUY_SELL      = 15, // Gator on buy/sell
  C_ICHIMOKU_BUY_SELL   = 16, // Ichimoku on buy/sell
  C_MA_BUY_SELL         = 17, // MA on buy/sell
  C_MACD_BUY_SELL       = 18, // MACD on buy/sell
  C_MFI_BUY_SELL        = 19, // MFI on buy/sell
  C_OBV_BUY_SELL        = 20, // OBV on buy/sell
  C_OSMA_BUY_SELL       = 21, // OSMA on buy/sell
  C_RSI_BUY_SELL        = 22, // RSI on buy/sell
  C_RVI_BUY_SELL        = 23, // RVI on buy/sell
  C_SAR_BUY_SELL        = 24, // SAR on buy/sell
  C_STDDEV_BUY_SELL     = 25, // StdDev on buy/sell
  C_STOCHASTIC_BUY_SELL = 26, // Stochastic on buy/sell
  C_WPR_BUY_SELL        = 27, // WPR on buy/sell
  C_ZIGZAG_BUY_SELL     = 28, // ZigZag on buy/sell
  C_MA_FAST_SLOW_OPP    = 29, // MA Fast&Slow opposite
  C_MA_FAST_MED_OPP     = 30, // MA Fast&Med opposite
  C_MA_MED_SLOW_OPP     = 31, // MA Med&Slow opposite
#ifdef __advanced__
  C_CUSTOM1_BUY_SELL    = 32, // Custom 1 on buy/sell
  C_CUSTOM2_BUY_SELL    = 33, // Custom 2 on buy/sell
  C_CUSTOM3_BUY_SELL    = 34, // Custom 3 on buy/sell
  C_CUSTOM4_MARKET_COND = 35, // Custom 4 market condition
  C_CUSTOM5_MARKET_COND = 36, // Custom 5 market condition
  C_CUSTOM6_MARKET_COND = 37, // Custom 6 market condition
#endif
};

enum ENUM_PERIOD_TYPE { // Define type of tasks.
  M1  = 0, // 1 minute
  M5  = 1, // 5 minutes
  M15 = 2, // 15 minutes
  M30 = 3, // 30 minutes
  H1  = 4, // 1 hour
  H4  = 5, // 4 hours
  D1  = 6, // daily
  W1  = 7, // weekly
  MN1 = 8, // monthly
  FINAL_PERIOD_TYPE_ENTRY = 9  // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_STAT_PERIOD_TYPE { // Define type of tasks.
  DAILY   = 0,  // Daily
  WEEKLY  = 1, // Weekly
  MONTHLY = 2, // Monthly
  YEARLY  = 3,  // Yearly
  FINAL_STAT_PERIOD_TYPE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_INDICATOR_INDEX { // Define indicator constants.
  CURR = 0,
  PREV = 1,
  FAR  = 2,
  FINAL_INDICATOR_INDEX_ENTRY // Should be the last one. Used to calculate the number of enum items.
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
