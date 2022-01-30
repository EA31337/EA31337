//+------------------------------------------------------------------+
//|                                                           enum.h |
//|                                 Copyright 2016-2022, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

#ifdef __advanced__
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
  EA_ADV_COND_NONE = 0,       // (None)
  EA_ADV_COND_EA_ON_NEW_DAY,  // On each day
  // EA_ADV_COND_EA_ON_NEW_WEEK,        // On each week
  EA_ADV_COND_EA_ON_NEW_MONTH,       // On each month
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
