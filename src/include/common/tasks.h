//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                                 Copyright 2016-2022, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

class EATasks {
 private:
  EA *ea;

 public:
  // Class constructor.
  EATasks(EA *_ea) : ea(_ea) {}
  // Add EA task.
  bool AddTask(ENUM_EA_ADV_COND _cond, ENUM_EA_ADV_ACTION _action) {
    bool _result = true;
    string _symbol = ea.Get<string>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_SYMBOL));
    ENUM_ACTION_TYPE _action_type;
    ENUM_TASK_CONDITION_TYPE _cond_type;
    TaskActionEntry _action_entry;
    TaskConditionEntry _cond_entry;
    switch (_action) {
      /* @todo
      case EA_ADV_ACTION_CLOSE_LEAST_LOSS:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDER_CLOSE_LEAST_LOSS);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_CLOSE_LEAST_PROFIT:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDER_CLOSE_LEAST_PROFIT);
        _action_type = ACTION_TYPE_TRADE;
        break;
      */
      case EA_ADV_ACTION_CLOSE_MOST_LOSS:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDER_CLOSE_MOST_LOSS);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_CLOSE_MOST_PROFIT:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDER_CLOSE_MOST_PROFIT);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_ALL:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDERS_CLOSE_ALL);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_IN_PROFIT:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_PROFIT);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_TREND);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDERS_CLOSE_IN_TREND_NOT);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_SIDE_IN_LOSS:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDERS_CLOSE_SIDE_IN_LOSS);
        _action_type = ACTION_TYPE_TRADE;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_SIDE_IN_PROFIT:
        _action_entry = TaskActionEntry(TRADE_ACTION_ORDERS_CLOSE_SIDE_IN_PROFIT);
        _action_type = ACTION_TYPE_TRADE;
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
        _cond_entry = TaskConditionEntry(EA_COND_ON_NEW_DAY);
        _cond_type = COND_TYPE_EA;
        break;
      /* @todo: https://github.com/EA31337/EA31337-classes/issues/628
      case EA_ADV_COND_EA_ON_NEW_WEEK:
        _cond_entry = ConditionEntry(EA_COND_ON_NEW_WEEK);
        _cond_type = COND_TYPE_EA;
        break;
      */
      case EA_ADV_COND_EA_ON_NEW_MONTH:
        _cond_entry = TaskConditionEntry(EA_COND_ON_NEW_MONTH);
        _cond_type = COND_TYPE_EA;
        break;
      /* Trade conditions not supported (yet).
      case EA_ADV_COND_TRADE_IS_PEAK:
        _cond_entry = TaskConditionEntry(TRADE_COND_IS_PEAK);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_IS_PIVOT:
        _cond_entry = TaskConditionEntry(TRADE_COND_IS_PIVOT);
        _cond_type = COND_TYPE_TRADE;
        break;
      */
      case EA_ADV_COND_TRADE_EQUITY_GT_01PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_01PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_EQUITY_LT_01PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_01PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_EQUITY_GT_02PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_02PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_EQUITY_LT_02PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_02PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_EQUITY_GT_05PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_05PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_EQUITY_LT_05PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_05PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_EQUITY_GT_10PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_GT_10PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_TRADE_EQUITY_LT_10PC:
        _cond_entry = TaskConditionEntry(TRADE_COND_ORDERS_PROFIT_LT_10PC);
        _cond_type = COND_TYPE_TRADE;
        break;
      case EA_ADV_COND_NONE:
        // Empty condition.
        break;
      default:
        _result = false;
        break;
    }
    TaskEntry _tentry(_action_entry, _cond_entry);
    switch (_action_type) {
      case ACTION_TYPE_EA:
        switch (_cond_type) {
          case COND_TYPE_EA:
            _result &= ea.AddTaskObject<EA, EA>(new TaskObject<EA, EA>(_tentry, ea, ea));
            break;
          default:
            ea.GetLogger().Error(StringFormat("Not supported Task condition (%d)!", _cond_type), __FUNCTION_LINE__);
            SetUserError(ERR_INVALID_PARAMETER);
            _result = false;
            break;
        }
        break;
      case ACTION_TYPE_TRADE:
        switch (_cond_type) {
          case COND_TYPE_EA:
            _result &= ea.AddTaskObject<Trade, EA>(new TaskObject<Trade, EA>(_tentry, ea.GetTrade(_symbol), ea));
            break;
          case COND_TYPE_TRADE:
            _result &= ea.AddTaskObject<Trade, Trade>(
                new TaskObject<Trade, Trade>(_tentry, ea.GetTrade(_symbol), ea.GetTrade(_symbol)));
            break;
          default:
            ea.GetLogger().Error(StringFormat("Not supported Task condition (%d)!", _cond_type), __FUNCTION_LINE__);
            SetUserError(ERR_INVALID_PARAMETER);
            _result = false;
            break;
        }
        break;
    }
    return _result;
  };
};
