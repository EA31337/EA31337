//+------------------------------------------------------------------+
//|                                                         define.h |
//|                                 Copyright 2016-2021, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Forward declarations.
struct EAParams;

/**
 * Configures actions for EA.
 */
bool ActionsAdd(EAParams &_ea_params, ENUM_EA_ADV_COND _c1, ENUM_EA_ADV_ACTION _a1) {
  if (_a1 != EA_ADV_ACTION_NONE && _c1 != EA_ADV_COND_NONE) {
    // Init actions.
    ActionEntry _aentry1;
    // DataParamEntry _aentry1_args[] = {{TYPE_FLOAT}};
    // _aentry1_args[0].double_value = EA_Action1_Then_Arg;
    switch (_a1) {
      /*
      case EA_ADV_ACTION_ORDER_CLOSE:
        _aentry1.type = ACTION_TYPE_ORDER;
        _aentry1.action_id = ORDER_ACTION_CLOSE;
        ArrayResize(_aentry1.args, ArraySize(_aentry1_args));
        _aentry1.args[0] = _aentry1_args[0];
        break;
      */
      case EA_ADV_ACTION_ORDERS_CLOSE_ALL:
        // EA_ACTION_STRATS_EXE_ACTION
        _aentry1.type = ACTION_TYPE_TRADE;
        _aentry1.action_id = TRADE_ACTION_ORDERS_CLOSE_ALL;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND:
        _aentry1.type = ACTION_TYPE_TRADE;
        _aentry1.action_id = TRADE_ACTION_ORDERS_CLOSE_IN_TREND;
        break;
      case EA_ADV_ACTION_ORDERS_CLOSE_IN_TREND_NOT:
        _aentry1.type = ACTION_TYPE_TRADE;
        _aentry1.action_id = TRADE_ACTION_ORDERS_CLOSE_IN_TREND_NOT;
        break;
      case EA_ADV_ACTION_NONE:
        _aentry1.type = ACTION_TYPE_TRADE;
        break;
      default:
        break;
    }
    ConditionEntry _centry1;
    // DataParamEntry _centry1_args[] = {{TYPE_FLOAT}};
    // _centry1_args[0].double_value = EA_Action1_If_Arg;
    switch (_c1) {
      case EA_ADV_COND_ACC_EQUITY_01PC_HIGH:
        _centry1.type = COND_TYPE_ACCOUNT;
        _centry1.cond_id = ACCOUNT_COND_EQUITY_01PC_HIGH;
        break;
      case EA_ADV_COND_ACC_EQUITY_01PC_LOW:
        _centry1.type = COND_TYPE_ACCOUNT;
        _centry1.cond_id = ACCOUNT_COND_EQUITY_01PC_LOW;
        break;
      /* @todo
      case EA_ADV_ACTION_ACC_EQUITY:
        _centry1.type = COND_TYPE_ACCOUNT;
        //_centry1.cond_id = ACCOUNT_COND_PROP_GT_ARG;
        ArrayResize(_centry1.args, ArraySize(_centry1_args));
        _centry1.args[0] = _centry1_args[0];
        break;
      case EA_ADV_ACTION_ACC_MARGIN_FREE:
        _centry1.type = COND_TYPE_ACCOUNT;
        //_centry1.cond_id = ACCOUNT_COND_PROP_GT_ARG;
        ArrayResize(_centry1.args, ArraySize(_centry1_args));
        _centry1.args[0] = _centry1_args[0];
        break;
      case EA_ADV_ACTION_ACC_MARGIN_USED:
        _centry1.type = COND_TYPE_ACCOUNT;
        //_centry1.cond_id = ACCOUNT_COND_PROP_GT_ARG;
        ArrayResize(_centry1.args, ArraySize(_centry1_args));
        _centry1.args[0] = _centry1_args[0];
        break;
      case EA_ADV_COND_ORDER_IN_PROFIT:
        _centry1.type = COND_TYPE_ORDER;
        _centry1.cond_id = ORDER_COND_PROP_GT_ARG;
        ArrayResize(_centry1.args, ArraySize(_centry1_args));
        _centry1.args[0] = _centry1_args[0];
        break;
      */
      case EA_ADV_COND_TRADE_IS_PEAK:
        _centry1.type = COND_TYPE_TRADE;
        _centry1.cond_id = TRADE_COND_IS_PEAK;
        break;
      case EA_ADV_COND_TRADE_IS_PIVOT:
        _centry1.type = COND_TYPE_TRADE;
        _centry1.cond_id = TRADE_COND_IS_PIVOT;
        break;
      case EA_ADV_COND_NONE:
      default:
        break;
    }
    _aentry1.Init();
    _centry1.Init();
    TaskEntry _tentry1(_aentry1, _centry1);
    _ea_params.SetTaskEntry(_tentry1);
    return true;
  }
  return false;
}
