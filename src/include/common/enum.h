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
  EA_ADV_ACTION_CLOSE_MOST_LOSS,      // Close order with the most loss
  EA_ADV_ACTION_CLOSE_MOST_PROFIT,    // Close order with the most profit
  EA_ADV_ACTION_ORDERS_CLOSE_ALL,           // Close all active orders
  EA_ADV_ACTION_ORDERS_CLOSE_IN_PROFIT,     // Close orders in profit
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND,      // Close orders in trend
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT,  // Close orders in not trend
};
enum ENUM_EA_ADV_COND {
  EA_ADV_COND_NONE = 0,              // (None)
  EA_ADV_COND_ACC_EQUITY_01PC_HIGH,  // Equity > 1%
  EA_ADV_COND_ACC_EQUITY_01PC_LOW,   // Equity < 1%
  EA_ADV_COND_ACC_EQUITY_05PC_HIGH,  // Equity > 5%
  EA_ADV_COND_ACC_EQUITY_05PC_LOW,   // Equity < 5%
  EA_ADV_COND_MARGIN_USED_10PC,      // Margin used > 10%
  // EA_ADV_COND_ACC_EQUITY,         // Equity (in %)
  // EA_ADV_COND_ACC_MARGIN_FREE,    // Free margin (in %)
  // EA_ADV_COND_ACC_MARGIN_USED,    // Free margin (in %)
  // EA_ADV_COND_ORDER_IN_PROFIT,      // Order (any) in profit
  // EA_ADV_COND_TRADE_IS_PEAK,   // Price's peak (no args)
  // EA_ADV_COND_TRADE_IS_PIVOT,  // Price's pivot (no args)
};
#endif
