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
                     .Precision(2)
                     .ToString<SerializerJson>();
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
  bool StrategyAddToTfs(ENUM_STRATEGY _stg, int _tfs) {
    unsigned int _magic_no = EA_MagicNumber + _stg * FINAL_ENUM_TIMEFRAMES_INDEX;
    switch (_stg) {
      case STRAT_AC:
        return StrategyAdd<Stg_AC>(_tfs, _magic_no, _stg);
      case STRAT_AD:
        return StrategyAdd<Stg_AD>(_tfs, _magic_no, _stg);
      case STRAT_ADX:
        return StrategyAdd<Stg_ADX>(_tfs, _magic_no, _stg);
      case STRAT_AMA:
        return StrategyAdd<Stg_AMA>(_tfs, _magic_no, _stg);
      case STRAT_ARROWS:
        return StrategyAdd<Stg_Arrows>(_tfs, _magic_no, _stg);
      case STRAT_ASI:
        return StrategyAdd<Stg_ASI>(_tfs, _magic_no, _stg);
      case STRAT_ATR:
        return StrategyAdd<Stg_ATR>(_tfs, _magic_no, _stg);
      case STRAT_ALLIGATOR:
        return StrategyAdd<Stg_Alligator>(_tfs, _magic_no, _stg);
      case STRAT_AWESOME:
        return StrategyAdd<Stg_Awesome>(_tfs, _magic_no, _stg);
#ifdef __MQL5__
        // case STRAT_ATR_MA_TREND:
        // return StrategyAdd<Stg_ATR_MA_Trend>(_tfs, _magic_no, _stg);
#endif
      case STRAT_BWMFI:
        return StrategyAdd<Stg_BWMFI>(_tfs, _magic_no, _stg);
      case STRAT_BANDS:
        return StrategyAdd<Stg_Bands>(_tfs, _magic_no, _stg);
      case STRAT_BEARS_POWER:
        return StrategyAdd<Stg_BearsPower>(_tfs, _magic_no, _stg);
      case STRAT_BULLS_POWER:
        return StrategyAdd<Stg_BullsPower>(_tfs, _magic_no, _stg);
      case STRAT_CCI:
        return StrategyAdd<Stg_CCI>(_tfs, _magic_no, _stg);
      case STRAT_CHAIKIN:
        return StrategyAdd<Stg_Chaikin>(_tfs, _magic_no, _stg);
      case STRAT_DEMA:
        return StrategyAdd<Stg_DEMA>(_tfs, _magic_no, _stg);
      case STRAT_DEMARKER:
        return StrategyAdd<Stg_DeMarker>(_tfs, _magic_no, _stg);
      case STRAT_ENVELOPES:
        return StrategyAdd<Stg_Envelopes>(_tfs, _magic_no, _stg);
      case STRAT_EWO:
        return StrategyAdd<Stg_ElliottWave>(_tfs, _magic_no, _stg);
      case STRAT_FORCE:
        return StrategyAdd<Stg_Force>(_tfs, _magic_no, _stg);
      case STRAT_FRACTALS:
        return StrategyAdd<Stg_Fractals>(_tfs, _magic_no, _stg);
      case STRAT_GATOR:
        return StrategyAdd<Stg_Gator>(_tfs, _magic_no, _stg);
      case STRAT_HEIKEN_ASHI:
        return StrategyAdd<Stg_HeikenAshi>(_tfs, _magic_no, _stg);
      case STRAT_ICHIMOKU:
        return StrategyAdd<Stg_Ichimoku>(_tfs, _magic_no, _stg);
      case STRAT_INDICATOR:
        return StrategyAdd<Stg_Indicator>(_tfs, _magic_no, _stg);
      case STRAT_MA:
        return StrategyAdd<Stg_MA>(_tfs, _magic_no, _stg);
      case STRAT_MA_CROSS_PIVOT:
        return StrategyAdd<Stg_MA_Cross_Pivot>(_tfs, _magic_no, _stg);
      case STRAT_MA_CROSS_SHIFT:
        return StrategyAdd<Stg_MA_Cross_Shift>(_tfs, _magic_no, _stg);
      case STRAT_MA_CROSS_SUP_RES:
        return StrategyAdd<Stg_MA_Cross_Sup_Res>(_tfs, _magic_no, _stg);
      case STRAT_MACD:
        return StrategyAdd<Stg_MACD>(_tfs, _magic_no, _stg);
      case STRAT_META_MIRROR:
        return StrategyAdd<Stg_Meta_Mirror>(_tfs, _magic_no, _stg);
      case STRAT_META_MULTI:
        return StrategyAdd<Stg_Meta_Multi>(_tfs, _magic_no, _stg);
      case STRAT_META_REVERSAL:
        return StrategyAdd<Stg_Meta_Reversal>(_tfs, _magic_no, _stg);
      case STRAT_MFI:
        return StrategyAdd<Stg_MFI>(_tfs, _magic_no, _stg);
      case STRAT_MOMENTUM:
        return StrategyAdd<Stg_Momentum>(_tfs, _magic_no, _stg);
      case STRAT_OBV:
        return StrategyAdd<Stg_OBV>(_tfs, _magic_no, _stg);
      case STRAT_OSCILLATOR:
        return StrategyAdd<Stg_Oscillator>(_tfs, _magic_no, _stg);
      case STRAT_OSCILLATOR_DIVERGENCE:
        return StrategyAdd<Stg_Oscillator_Divergence>(_tfs, _magic_no, _stg);
      case STRAT_OSCILLATOR_MULTI:
        return StrategyAdd<Stg_Oscillator_Multi>(_tfs, _magic_no, _stg);
      case STRAT_OSCILLATOR_CROSS:
        return StrategyAdd<Stg_Oscillator_Cross>(_tfs, _magic_no, _stg);
      case STRAT_OSCILLATOR_CROSS_SHIFT:
        return StrategyAdd<Stg_Oscillator_Cross_Shift>(_tfs, _magic_no, _stg);
      case STRAT_OSCILLATOR_CROSS_ZERO:
        return StrategyAdd<Stg_Oscillator_Cross_Zero>(_tfs, _magic_no, _stg);
      case STRAT_OSCILLATOR_RANGE:
        return StrategyAdd<Stg_Oscillator_Range>(_tfs, _magic_no, _stg);
      case STRAT_OSMA:
        return StrategyAdd<Stg_OsMA>(_tfs, _magic_no, _stg);
      case STRAT_PATTERN:
        return StrategyAdd<Stg_Pattern>(_tfs, _magic_no, _stg);
      case STRAT_PINBAR:
        return StrategyAdd<Stg_Pinbar>(_tfs, _magic_no, _stg);
      case STRAT_PIVOT:
        return StrategyAdd<Stg_Pivot>(_tfs, _magic_no, _stg);
      case STRAT_RSI:
        return StrategyAdd<Stg_RSI>(_tfs, _magic_no, _stg);
      case STRAT_RVI:
        return StrategyAdd<Stg_RVI>(_tfs, _magic_no, _stg);
      case STRAT_SAR:
        return StrategyAdd<Stg_SAR>(_tfs, _magic_no, _stg);
      // case STRAT_SAWA:
      // return StrategyAdd<Stg_SAWA>(_tfs, _magic_no, _stg);
      case STRAT_STDDEV:
        return StrategyAdd<Stg_StdDev>(_tfs, _magic_no, _stg);
      case STRAT_STOCHASTIC:
        return StrategyAdd<Stg_Stochastic>(_tfs, _magic_no, _stg);
#ifdef __MQL5__
        // case STRAT_SUPERTREND:
        // return StrategyAdd<Stg_SuperTrend>(_tfs, _magic_no, _stg);
#endif
      case STRAT_SVE_BB:
        return StrategyAdd<Stg_SVE_Bollinger_Bands>(_tfs, _magic_no, _stg);
      case STRAT_TMAT_SVEBB:
        return StrategyAdd<Stg_TMAT_SVEBB>(_tfs, _magic_no, _stg);
      // case STRAT_TMA_CG:
      // return StrategyAdd<Stg_TMA_CG>(_tfs, _magic_no, _stg);
      case STRAT_TMA_TRUE:
        return StrategyAdd<Stg_TMA_True>(_tfs, _magic_no, _stg);
      case STRAT_WPR:
        return StrategyAdd<Stg_WPR>(_tfs, _magic_no, _stg);
      case STRAT_ZIGZAG:
        return StrategyAdd<Stg_ZigZag>(_tfs, _magic_no, _stg);
      case STRAT_NONE:
        break;
      default:
        SetUserError(ERR_INVALID_PARAMETER);
        break;
    }
    return _stg == STRAT_NONE;
  }

  /**
   * Adds strategy stops.
   */
  bool StrategyAddStops(Strategy *_strat = NULL, ENUM_STRATEGY _enum_stg_stops = STRAT_NONE, ENUM_TIMEFRAMES _tf = 0) {
    bool _result = true;
    if (_enum_stg_stops == STRAT_NONE) {
      return _result;
    }
    Strategy *_strat_stops = GetStrategyViaProp2<int, int>(STRAT_PARAM_TYPE, _enum_stg_stops, STRAT_PARAM_TF, _tf);
    if (!_strat_stops) {
      _result &= StrategyAddToTfs(_enum_stg_stops, 1 << ChartTf::TfToIndex(_tf));
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
