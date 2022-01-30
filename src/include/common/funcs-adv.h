//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                                 Copyright 2016-2022, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * Adds EA's task.
 */
TaskEntry GetTask(ENUM_EA_ADV_COND _cond, ENUM_EA_ADV_ACTION _action) {
  bool _result = true;
  ActionEntry _action_entry;
  ConditionEntry _cond_entry;
  switch (_action) {
    /* @todo
    case EA_ADV_ACTION_CLOSE_LEAST_LOSS:
      _action_entry = ActionEntry(TRADE_ACTION_ORDER_CLOSE_LEAST_LOSS);
      break;
    case EA_ADV_ACTION_CLOSE_LEAST_PROFIT:
      _action_entry = ActionEntry(TRADE_ACTION_ORDER_CLOSE_LEAST_PROFIT);
      break;
    */
    case EA_ADV_ACTION_CLOSE_MOST_LOSS:
      _action_entry = ActionEntry(TRADE_ACTION_ORDER_CLOSE_MOST_LOSS);
      break;
    case EA_ADV_ACTION_CLOSE_MOST_PROFIT:
      _action_entry = ActionEntry(TRADE_ACTION_ORDER_CLOSE_MOST_PROFIT);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_ALL:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_ALL);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_IN_PROFIT:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_PROFIT);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_TREND);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_TREND_NOT);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_SIDE_IN_LOSS:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_SIDE_IN_LOSS);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_SIDE_IN_PROFIT:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_SIDE_IN_PROFIT);
      break;
    case EA_ADV_ACTION_NONE:
      // Empty action.
      break;
    default:
      _result = false;
      break;
  }
  switch (_cond) {
    case EA_ADV_COND_EA_ON_NEW_DAY:
      _cond_entry = ConditionEntry(EA_COND_ON_NEW_DAY);
      break;
    /* @todo: https://github.com/EA31337/EA31337-classes/issues/628
    case EA_ADV_COND_EA_ON_NEW_WEEK:
      _cond_entry = ConditionEntry(EA_COND_ON_NEW_WEEK);
      break;
    */
    case EA_ADV_COND_EA_ON_NEW_MONTH:
      _cond_entry = ConditionEntry(EA_COND_ON_NEW_MONTH);
      break;
    /* Trade conditions not supported (yet).
    case EA_ADV_COND_TRADE_IS_PEAK:
      _cond_entry = ConditionEntry(TRADE_COND_IS_PEAK);
      break;
    case EA_ADV_COND_TRADE_IS_PIVOT:
      _cond_entry = ConditionEntry(TRADE_COND_IS_PIVOT);
      break;
    */
    case EA_ADV_COND_TRADE_EQUITY_GT_01PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_01PC);
      break;
    case EA_ADV_COND_TRADE_EQUITY_LT_01PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_01PC);
      break;
    case EA_ADV_COND_TRADE_EQUITY_GT_02PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_02PC);
      break;
    case EA_ADV_COND_TRADE_EQUITY_LT_02PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_02PC);
      break;
    case EA_ADV_COND_TRADE_EQUITY_GT_05PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_05PC);
      break;
    case EA_ADV_COND_TRADE_EQUITY_LT_05PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_05PC);
      break;
    case EA_ADV_COND_TRADE_EQUITY_GT_10PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_10PC);
      break;
    case EA_ADV_COND_TRADE_EQUITY_LT_10PC:
      _cond_entry = ConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_10PC);
      break;
    case EA_ADV_COND_NONE:
      // Empty condition.
      break;
    default:
      _result = false;
      break;
  }
  return TaskEntry(_action_entry, _cond_entry);
}
