//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                                 Copyright 2016-2023, EA31337 Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

/*
 *  This file is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// Prevents processing this includes file multiple times.
#ifndef STRATEGIES_META_MANAGER_H
#define STRATEGIES_META_MANAGER_H

class StrategiesMetaManager {
  // Cache of already created strategies.
  static DictStruct<string, Ref<Strategy>> _strat_cache;
  
 public:
  /**
   * Initialize strategy with the specific timeframe.
   *
   * @param
   *   _tf - timeframe to initialize
   *
   * @return
   *   Returns strategy pointer on successful initialization, otherwise NULL.
   */
  template <typename SClass>
  static Strategy* StrategyInit(ENUM_TIMEFRAMES _tf) {
    return ((SClass*)NULL).Init(_tf);
  }

  /**
   * Create or return cached strategy by enum type.
   *
   * @param
   *   _sid - Strategy type
   *
   * @return
   *   Returns strategy pointer on successful initialization, otherwise NULL.
   */
  static Strategy* StrategyInitByEnum(ENUM_STRATEGY _sid, ENUM_TIMEFRAMES _tf = PERIOD_CURRENT) {
    string key = IntegerToString((int)_sid) + "@" + IntegerToString((int)_tf);
    
    if (_strat_cache.KeyExists(key)) {
      return _strat_cache[key].Ptr();
    }
    
    Ref<Strategy> _strat = StrategyCreateByEnum(_sid, _tf);
    
    _strat_cache.Set(key, _strat);
    
    return _strat.Ptr();
  }

  /**
   * Create strategy by enum type.
   *
   * @param
   *   _sid - Strategy type
   *
   * @return
   *   Returns strategy pointer on successful initialization, otherwise NULL.
   */
  static Strategy* StrategyCreateByEnum(ENUM_STRATEGY _sid, ENUM_TIMEFRAMES _tf = PERIOD_CURRENT) {
    switch (_sid) {
      case STRAT_META_BEARS_BULLS:  // (Meta) Bears & Bulls
        return StrategyInit<Stg_Meta_Bears_Bulls>(_tf);
      case STRAT_META_DISCREPANCY:  // (Meta) Discrepancy
        return StrategyInit<Stg_Meta_Discrepancy>(_tf);
      case STRAT_META_DOUBLE:  // (Meta) Double
        return StrategyInit<Stg_Meta_Double>(_tf);
      case STRAT_META_CONDITIONS:  // (Meta) Conditions
        return StrategyInit<Stg_Meta_Conditions>(_tf);
      case STRAT_META_ENHANCE:  // (Meta) Enhance
        return StrategyInit<Stg_Meta_Enhance>(_tf);
      case STRAT_META_EQUITY:  // (Meta) Equity
        return StrategyInit<Stg_Meta_Equity>(_tf);
      case STRAT_META_FORMATION:  // (Meta) Formation
        return StrategyInit<Stg_Meta_Formation>(_tf);
      case STRAT_META_INTERVAL:  // (Meta) Interval
        return StrategyInit<Stg_Meta_Interval>(_tf);
      case STRAT_META_HEDGE:  // (Meta) Hedge
        return StrategyInit<Stg_Meta_Hedge>(_tf);
      case STRAT_META_LIMIT:  // (Meta) Limit
        return StrategyInit<Stg_Meta_Limit>(_tf);
      case STRAT_META_MA_CROSS:  // (Meta) MA Cross
        return StrategyInit<Stg_Meta_MA_Cross>(_tf);
      case STRAT_META_MARGIN:  // (Meta) Margin
        return StrategyInit<Stg_Meta_Margin>(_tf);
      case STRAT_META_MARTINGALE:  // (Meta) Martingale
        return StrategyInit<Stg_Meta_Martingale>(_tf);
      case STRAT_META_MIRROR:  // (Meta) Mirror
        return StrategyInit<Stg_Meta_Mirror>(_tf);
      case STRAT_META_MULTI:  // (Meta) Multi
        return StrategyInit<Stg_Meta_Multi>(_tf);
      case STRAT_META_MULTI_CURRENCY:  // (Meta) Multi Currency
        return StrategyInit<Stg_Meta_Multi_Currency>(_tf);
#ifdef __MQL5__
      // Supported for MQL5 only.
      case STRAT_META_NEWS:  // (Meta) News
        return StrategyInit<Stg_Meta_News>(_tf);
#endif
      case STRAT_META_ORDER_LIMIT:  // (Meta) Order Limit
        return StrategyInit<Stg_Meta_Order_Limit>(_tf);
      case STRAT_META_OSCILLATOR_FILTER:  // (Meta) Oscillator Filter
        return StrategyInit<Stg_Meta_Oscillator_Filter>(_tf);
      case STRAT_META_OSCILLATOR_SWITCH:  // (Meta) Oscillator Switch
        return StrategyInit<Stg_Meta_Oscillator_Switch>(_tf);
      case STRAT_META_PATTERN:  // (Meta) Pattern
        return StrategyInit<Stg_Meta_Pattern>(_tf);
      case STRAT_META_PIVOT:  // (Meta) Pivot
        return StrategyInit<Stg_Meta_Pivot>(_tf);
      case STRAT_META_PROFIT:  // (Meta) Profit
        return StrategyInit<Stg_Meta_Profit>(_tf);
      case STRAT_META_RESISTANCE:  // (Meta) Resistance
        return StrategyInit<Stg_Meta_Resistance>(_tf);
      case STRAT_META_REVERSAL:  // (Meta) Reversal
        return StrategyInit<Stg_Meta_Reversal>(_tf);
      case STRAT_META_RISK:  // (Meta) Risk
        return StrategyInit<Stg_Meta_Risk>(_tf);
      case STRAT_META_RSI:  // (Meta) RSI
        return StrategyInit<Stg_Meta_RSI>(_tf);
      case STRAT_META_SAR:  // (Meta) SAR
        return StrategyInit<Stg_Meta_SAR>(_tf);
      case STRAT_META_SCALPER:  // (Meta) Scalper
        return StrategyInit<Stg_Meta_Scalper>(_tf);
      case STRAT_META_SIGNAL_FILTER:  // (Meta) Signal Filter
        return StrategyInit<Stg_Meta_Signal_Filter>(_tf);
      case STRAT_META_SIGNAL_SWITCH:  // (Meta) Signal Switch
        return StrategyInit<Stg_Meta_Signal_Switch>(_tf);
      case STRAT_META_SPREAD:  // (Meta) Spread
        return StrategyInit<Stg_Meta_Spread>(_tf);
      case STRAT_META_TIMEZONE:  // (Meta) Timezone
        return StrategyInit<Stg_Meta_Timezone>(_tf);
      case STRAT_META_TREND:  // (Meta) Trend
        return StrategyInit<Stg_Meta_Trend>(_tf);
      case STRAT_META_TRIO:  // (Meta) Trio
        return StrategyInit<Stg_Meta_Trio>(_tf);
      case STRAT_META_VOLATILITY:  // (Meta) Volatility
        return StrategyInit<Stg_Meta_Volatility>(_tf);
      case STRAT_META_WEEKDAY:  // (Meta) Weekday
        return StrategyInit<Stg_Meta_Weekday>(_tf);
      default:
      case STRAT_NONE:
        break;
    }

    return NULL;
  }

  /**
   * Initialize meta strategy by enum type.
   *
   * @param
   *   _sid - Strategy type
   *
   * @return
   *   Returns strategy pointer on successful initialization, otherwise NULL.
   */
  static Strategy* StrategyInitByEnum(ENUM_STRATEGY_META _sid, ENUM_TIMEFRAMES _tf = PERIOD_CURRENT) {
    return StrategyInitByEnum((ENUM_STRATEGY)_sid, _tf);
  }
};

DictStruct<string, Ref<Strategy>> StrategiesMetaManager::_strat_cache;

#endif  // STRATEGIES_META_MANAGER_H
