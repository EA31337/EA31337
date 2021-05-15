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
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND,      // Close orders in trend (no args)
  EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT,  // Close orders in not trend (no args)
};
enum ENUM_EA_ADV_COND {
  EA_ADV_COND_NONE = 0,              // (None)
  EA_ADV_COND_ACC_EQUITY_01PC_HIGH,  // Acc. equity 1% high (no args)
  EA_ADV_COND_ACC_EQUITY_01PC_LOW,   // Acc. equity 1% low (no args)
  // EA_ADV_COND_ACC_EQUITY,         // Acc. equity (in %)
  // EA_ADV_COND_ACC_MARGIN_FREE,    // Acc. margin free (in %)
  // EA_ADV_COND_ACC_MARGIN_USED,    // Acc. margin free (in %)
  // EA_ADV_COND_ORDER_IN_PROFIT,      // Order (any) in profit
  EA_ADV_COND_TRADE_IS_PEAK,   // Price in peak (no args)
  EA_ADV_COND_TRADE_IS_PIVOT,  // Price in pivot (no args)
};
#endif
