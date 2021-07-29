//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                                 Copyright 2016-2021, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/**
 * Add EA's action with the condition.
 */
bool ActionAdd(EAParams &_params, ENUM_EA_ADV_COND _cond, ENUM_EA_ADV_ACTION _action) {
  bool _result = true;
  ActionEntry _action_entry;
  ConditionEntry _cond_entry;
  switch (_action) {
    case EA_ADV_ACTION_ORDERS_CLOSE_ALL:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_ALL);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_TREND);
      break;
    case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT:
      _action_entry = ActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_TREND_NOT);
      break;
    case EA_ADV_ACTION_NONE:
      // Empty action.
      break;
    default:
      _result = false;
      break;
  }
  switch (_cond) {
    case EA_ADV_COND_ACC_EQUITY_01PC_HIGH:
      _cond_entry = ConditionEntry(ACCOUNT_COND_EQUITY_01PC_HIGH);
      break;
    case EA_ADV_COND_ACC_EQUITY_01PC_LOW:
      _cond_entry = ConditionEntry(ACCOUNT_COND_EQUITY_01PC_LOW);
      break;
    case EA_ADV_COND_TRADE_IS_PEAK:
      _cond_entry = ConditionEntry(TRADE_COND_IS_PEAK);
      break;
    case EA_ADV_COND_TRADE_IS_PIVOT:
      _cond_entry = ConditionEntry(TRADE_COND_IS_PIVOT);
      break;
    case EA_ADV_COND_NONE:
      // Empty condition.
      break;
    default:
      _result = false;
      break;
  }
  _params.SetTaskEntry(TaskEntry(_action_entry, _cond_entry));
  return true;
}
