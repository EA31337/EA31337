//+------------------------------------------------------------------+
//|                                                           enum.h |
//|                                 Copyright 2016-2021, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

#ifdef __advanced__
enum ENUM_EA_ADV_ACTION {
  EA_ADV_ACTION_NONE = 0,  // (None)
  // EA_ADV_ACTION_ORDER_CLOSE,                // Close selected active order
  EA_ADV_ACTION_ORDERS_CLOSE_ALL,           // Close all active orders (no args)
  EA_ADV_ACTION_ORDERS_CLOSE_IN_PROFIT,     // Close orders in profit (no args)
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND,      // Close orders in trend (no args)
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT,  // Close orders in not trend (no args)
};
enum ENUM_EA_ADV_COND {
  EA_ADV_COND_NONE = 0,              // (None)
  EA_ADV_COND_ACC_EQUITY_01PC_HIGH,  // Equity>1% (no args)
  EA_ADV_COND_ACC_EQUITY_01PC_LOW,   // Equity<1% (no args)
  EA_ADV_COND_ACC_EQUITY_05PC_HIGH,  // Equity>5% (no args)
  EA_ADV_COND_ACC_EQUITY_05PC_LOW,   // Equity<5% (no args)
  // EA_ADV_COND_ACC_EQUITY,         // Equity (in %)
  // EA_ADV_COND_ACC_MARGIN_FREE,    // Free margin (in %)
  // EA_ADV_COND_ACC_MARGIN_USED,    // Free margin (in %)
  // EA_ADV_COND_ORDER_IN_PROFIT,      // Order (any) in profit
  // EA_ADV_COND_TRADE_IS_PEAK,   // Price's peak (no args)
  // EA_ADV_COND_TRADE_IS_PIVOT,  // Price's pivot (no args)
};
#endif
