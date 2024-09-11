//+------------------------------------------------------------------+
//|                              EA31337 Libre - Forex trading robot |
//|                                 Copyright 2016-2023, EA31337 Ltd |
//|                                       https://ea31337.github.io/ |
//+------------------------------------------------------------------+

/*
 *  This file is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/**
 * @file
 * Main EA class.
 */

// Includes.
#include "includes.h"

class EA31337 : public EA {
 protected:
  /**
   * Initialize EA.
   */
  bool Init() {
    bool _initiated = true;
    PrintFormat("%s v%s by %s initializing...", Get<string>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_NAME)),
                Get<string>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_VER)),
                Get<string>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_AUTHOR)));
    long _magic_no = EA_MagicNumber;
    ResetLastError();
    return _initiated;
  }

 public:
  /**
   * Class constructor.
   */
  EA31337(EAParams &_params) : EA(_params) { Init(); }

  /**
   * Adds EA's task.
   */
  TaskEntry GetTaskEntry(ENUM_EA_ADV_COND _cond, ENUM_EA_ADV_ACTION _action) {
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

  /**
   * Executed on strategy being added.
   *
   * <inheritdoc/>
   *
   */
  void OnStrategyAdd(Strategy *_strat) {
    EA::OnStrategyAdd(_strat);
    switch (_strat.Get<ENUM_STRATEGY>(STRAT_PARAM_TYPE)) {
      case STRAT_META_MIRROR:
        // @todo: Move this logic to strategy.
        ((Stg_Meta_Mirror *)_strat).SetStrategies(THIS_PTR);
        break;
      case STRAT_META_MULTI:
        // @todo: Move this logic to strategy.
        ((Stg_Meta_Multi *)_strat).SetStrategies(THIS_PTR);
        break;
    }
  }

  /**
   * "Tick" event handler function.
   *
   * Invoked when a new tick for a symbol is received, to the chart of which the Expert Advisor is attached.
   */
  void OnTick(MqlTick &_tick) {
    EAProcessResult _result = ProcessTick();
    if (_result.stg_processed_periods > 0) {
      if (EA_DisplayDetailsOnChart && (Terminal::IsVisualMode() || Terminal::IsRealtime())) {
        string _text = StringFormat("%s v%s by %s\n", Get<string>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_NAME)),
                                    Get<string>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_VER)),
                                    Get<string>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_AUTHOR)));

        _text += SerializerConverter::FromObject(THIS_PTR, SERIALIZER_FLAG_INCLUDE_DYNAMIC)
                     .Precision(0)
                     .ToString<SerializerJson>(SERIALIZER_JSON_NO_WHITESPACES) +
                 "\n";
        /* @todo
        _text +=
            SerializerConverter::FromObject(_result).Precision(0).ToString<SerializerJson>(SERIALIZER_JSON_NO_WHITESPACES)
        +
            "\n";
        */
        if (Get<ENUM_LOG_LEVEL>(STRUCT_ENUM(EAParams, EA_PARAM_PROP_LOG_LEVEL)) >= V_DEBUG) {
          // Print enabled strategies info.
          for (DictStructIterator<long, Ref<Strategy>> _siter = ea.GetStrategies().Begin(); _siter.IsValid();
               ++_siter) {
            Strategy *_strat = _siter.Value().Ptr();
            StgProcessResult _sres = _strat.GetProcessResult();
            _text += StringFormat("%s@%d: %s\n", _strat.GetName(), _strat.Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF),
                                  SerializerConverter::FromObject(_sres, SERIALIZER_FLAG_INCLUDE_DYNAMIC)
                                      .Precision(2)
                                      .ToString<SerializerJson>(SERIALIZER_JSON_NO_WHITESPACES));
          }
        }

        _text += logger.ToString();
        Comment(_text);
      }
    }
  }

  /**
   * Print startup info.
   */
  bool PrintStartupInfo(bool _startup = false, string sep = "\n") {
    string _output = "";
    ResetLastError();
    if (GetState().IsOptimizationMode() || (GetState().IsTestingMode() && !GetState().IsVisualMode())) {
      // Ignore chart updates when optimizing or testing in non-visual mode.
      return false;
    }
    _output += "ACCOUNT: " + Account().ToString() + sep;
    _output += "EA: " + ToString() + sep;
#ifdef __advanced__
    // Print enabled strategies info.
    for (DictStructIterator<long, Ref<Strategy>> _siter = GetStrategies().Begin(); _siter.IsValid(); ++_siter) {
      Strategy *_strat = _siter.Value().Ptr();
      string _sname =
          _strat.GetName();  // + "@" + ChartTf::TfToString(_strat.GetTf().Get<ENUM_TIMEFRAMES>(CHART_PARAM_TF));
      _output += StringFormat("Strategy: %s: %s\n", _sname,
                              SerializerConverter::FromObject(_strat, SERIALIZER_FLAG_INCLUDE_DYNAMIC)
                                  .ToString<SerializerJson>(SERIALIZER_JSON_NO_WHITESPACES));
    }
#endif
    _output += "TERMINAL: " + GetTerminal().ToString() + sep;
    if (_startup) {
      if (Get(STRUCT_ENUM(EAState, EA_STATE_FLAG_TRADE_ALLOWED))) {
        if (!Terminal::HasError()) {
          _output += sep + "Trading is allowed, waiting for new bars...";
        } else {
          _output += sep + "Trading is allowed, but there is some issue...";
          _output += sep + Terminal::GetLastErrorText();
          logger.AddLastError(__FUNCTION_LINE__);
        }
      } else if (Terminal::IsRealtime()) {
        _output +=
            sep + StringFormat(
                      "Error %d: Trading is not allowed for this symbol, please enable automated trading or check "
                      "the settings!",
                      __LINE__);
      } else {
        _output += sep + "Waiting for new bars...";
      }
    }
    Comment(_output);
    return !Terminal::HasError();
  }

  /**
   * Adds strategy to the given timeframe.
   */
  bool StrategyAddToTf(ENUM_STRATEGY _sid, ENUM_TIMEFRAMES _tf) {
    bool _result = true;
    unsigned int _magic_no = EA_MagicNumber + _sid * FINAL_ENUM_TIMEFRAMES_INDEX + ChartTf::TfToIndex(_tf);
    Ref<Strategy> _strat = StrategiesManager::StrategyInitByEnum(_sid, _tf);
#ifdef __strategies_meta__
    if (_sid != STRAT_NONE && !_strat.IsSet()) {
      _strat = StrategiesMetaManager::StrategyInitByEnum((ENUM_STRATEGY_META)_sid, _tf);
    }
#endif
    if (_strat.IsSet()) {
      _strat.Ptr().Set<long>(STRAT_PARAM_ID, _magic_no);
      _strat.Ptr().Set<ENUM_TIMEFRAMES>(STRAT_PARAM_TF, _tf);
      _strat.Ptr().Set<int>(STRAT_PARAM_TYPE, _sid);
      _strat.Ptr().OnInit();  // @fixme: GH-410: Change it to Init().
      if (!strats.KeyExists(_magic_no)) {
        _result &= strats.Set(_magic_no, _strat);
      } else {
        logger.Error("Strategy adding conflict!", __FUNCTION_LINE__);
        DebugBreak();
      }
      OnStrategyAdd(_strat.Ptr());
    } else if (_sid != STRAT_NONE) {
      SetUserError(ERR_INVALID_PARAMETER);
    }
    _result &= _strat.IsSet() || _sid == STRAT_NONE;
    return _result;
  }

  /**
   * Adds strategy to multiple timeframes.
   *
   * @param
   *   _sid - strategy type
   *   _tfs - timeframes to add strategy (using bitwise operation).
   *
   * Note:
   *   Final magic number is going to be increased by timeframe index value.
   *
   * @see: ENUM_TIMEFRAMES_INDEX
   *
   * @return
   *   Returns true if all strategies has been initialized correctly, otherwise false.
   */
  bool StrategyAddToTfs(ENUM_STRATEGY _sid, unsigned int _tfs) {
    bool _result = true;
    for (int _tfi = 0; _tfi < sizeof(int) * 8; ++_tfi) {
      if ((_tfs & (1 << _tfi)) != 0) {
        _result &= StrategyAddToTf(_sid, ChartTf::IndexToTf((ENUM_TIMEFRAMES_INDEX)_tfi));
      }
    }
    return _result;
  }

  /**
   * Adds strategy stops.
   */
  bool StrategyAddStops(Strategy *_strat = NULL, ENUM_STRATEGY _enum_stg_stops = STRAT_NONE, ENUM_TIMEFRAMES _tf = 0) {
    bool _result = true;
    if (_enum_stg_stops == STRAT_NONE && _strat == NULL) {
      return _result;
    }
    Strategy *_strat_stops = GetStrategyViaProp2<int, int>(STRAT_PARAM_TYPE, _enum_stg_stops, STRAT_PARAM_TF, _tf);
    if (!_strat_stops) {
      _result &= StrategyAddToTf(_enum_stg_stops, _tf);
      _strat_stops = GetStrategyViaProp2<int, int>(STRAT_PARAM_TYPE, _enum_stg_stops, STRAT_PARAM_TF, _tf);
      if (_strat_stops) {
        _strat_stops.Enabled(false);
      }
    }
    if (_strat_stops) {
      if (_strat != NULL && _tf > 0) {
        _strat.SetStops(_strat_stops, _strat_stops);
      } else {
        for (DictStructIterator<long, Ref<Strategy>> iter = GetStrategies().Begin(); iter.IsValid(); ++iter) {
          Strategy *_strat_ref = iter.Value().Ptr();
          if (_strat_ref.IsEnabled()) {
            _strat_ref.SetStops(_strat_stops, _strat_stops);
          }
        }
      }
    }
    return _result;
  }
};
