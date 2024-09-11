//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                                 Copyright 2016-2024, EA31337 Ltd |
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
#ifndef STRATEGIES_MANAGER_H
#define STRATEGIES_MANAGER_H

class StrategiesManager {
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
      case STRAT_AC:
        return StrategyInit<Stg_AC>(_tf);
      case STRAT_AD:
        return StrategyInit<Stg_AD>(_tf);
      case STRAT_ADX:
        return StrategyInit<Stg_ADX>(_tf);
      case STRAT_AMA:
        return StrategyInit<Stg_AMA>(_tf);
      case STRAT_ARROWS:
        return StrategyInit<Stg_Arrows>(_tf);
      case STRAT_ASI:
        return StrategyInit<Stg_ASI>(_tf);
      case STRAT_ATR:
        return StrategyInit<Stg_ATR>(_tf);
      case STRAT_ALLIGATOR:
        return StrategyInit<Stg_Alligator>(_tf);
      case STRAT_AWESOME:
        return StrategyInit<Stg_Awesome>(_tf);
      case STRAT_BWMFI:
        return StrategyInit<Stg_BWMFI>(_tf);
      case STRAT_BANDS:
        return StrategyInit<Stg_Bands>(_tf);
      case STRAT_BEARS_POWER:
        return StrategyInit<Stg_BearsPower>(_tf);
      case STRAT_BULLS_POWER:
        return StrategyInit<Stg_BullsPower>(_tf);
      case STRAT_CCI:
        return StrategyInit<Stg_CCI>(_tf);
      case STRAT_CHAIKIN:
        return StrategyInit<Stg_Chaikin>(_tf);
      case STRAT_DEMA:
        return StrategyInit<Stg_DEMA>(_tf);
      case STRAT_DPO:
        return StrategyInit<Stg_DPO>(_tf);
      case STRAT_DEMARKER:
        return StrategyInit<Stg_DeMarker>(_tf);
      case STRAT_ENVELOPES:
        return StrategyInit<Stg_Envelopes>(_tf);
      case STRAT_EWO:
        return StrategyInit<Stg_ElliottWave>(_tf);
      case STRAT_FORCE:
        return StrategyInit<Stg_Force>(_tf);
      case STRAT_FRACTALS:
        return StrategyInit<Stg_Fractals>(_tf);
      case STRAT_GATOR:
        return StrategyInit<Stg_Gator>(_tf);
      case STRAT_HEIKEN_ASHI:
        return StrategyInit<Stg_HeikenAshi>(_tf);
      case STRAT_ICHIMOKU:
        return StrategyInit<Stg_Ichimoku>(_tf);
      case STRAT_INDICATOR:
        return StrategyInit<Stg_Indicator>(_tf);
      case STRAT_MA:
        return StrategyInit<Stg_MA>(_tf);
      case STRAT_MA_BREAKOUT:
        return StrategyInit<Stg_MA_Breakout>(_tf);
      case STRAT_MA_CROSS_PIVOT:
        return StrategyInit<Stg_MA_Cross_Pivot>(_tf);
      case STRAT_MA_CROSS_SHIFT:
        return StrategyInit<Stg_MA_Cross_Shift>(_tf);
      case STRAT_MA_CROSS_SUP_RES:
        return StrategyInit<Stg_MA_Cross_Sup_Res>(_tf);
      case STRAT_MA_CROSS_TIMEFRAME:
        return StrategyInit<Stg_MA_Cross_Timeframe>(_tf);
      case STRAT_MA_TREND:
        return StrategyInit<Stg_MA_Trend>(_tf);
      case STRAT_MACD:
        return StrategyInit<Stg_MACD>(_tf);
      case STRAT_MFI:
        return StrategyInit<Stg_MFI>(_tf);
      case STRAT_MOMENTUM:
        return StrategyInit<Stg_Momentum>(_tf);
      case STRAT_OBV:
        return StrategyInit<Stg_OBV>(_tf);
      case STRAT_OSCILLATOR:
        return StrategyInit<Stg_Oscillator>(_tf);
      case STRAT_OSCILLATOR_DIVERGENCE:
        return StrategyInit<Stg_Oscillator_Divergence>(_tf);
      case STRAT_OSCILLATOR_MULTI:
        return StrategyInit<Stg_Oscillator_Multi>(_tf);
      case STRAT_OSCILLATOR_CROSS:
        return StrategyInit<Stg_Oscillator_Cross>(_tf);
      case STRAT_OSCILLATOR_CROSS_SHIFT:
        return StrategyInit<Stg_Oscillator_Cross_Shift>(_tf);
      case STRAT_OSCILLATOR_CROSS_ZERO:
        return StrategyInit<Stg_Oscillator_Cross_Zero>(_tf);
      case STRAT_OSCILLATOR_CROSS_TIMEFRAME:
        return StrategyInit<Stg_Oscillator_Cross_Timeframe>(_tf);
      case STRAT_OSCILLATOR_MARTINGALE:
        return StrategyInit<Stg_Oscillator_Martingale>(_tf);
      case STRAT_OSCILLATOR_OVERLAY:
        return StrategyInit<Stg_Oscillator_Overlay>(_tf);
      case STRAT_OSCILLATOR_RANGE:
        return StrategyInit<Stg_Oscillator_Range>(_tf);
      case STRAT_OSCILLATOR_TREND:
        return StrategyInit<Stg_Oscillator_Trend>(_tf);
      case STRAT_OSMA:
        return StrategyInit<Stg_OsMA>(_tf);
      case STRAT_PATTERN:
        return StrategyInit<Stg_Pattern>(_tf);
      case STRAT_PINBAR:
        return StrategyInit<Stg_Pinbar>(_tf);
      case STRAT_PIVOT:
        return StrategyInit<Stg_Pivot>(_tf);
      case STRAT_RETRACEMENT:
        return StrategyInit<Stg_Retracement>(_tf);
      case STRAT_RSI:
        return StrategyInit<Stg_RSI>(_tf);
      case STRAT_RVI:
        return StrategyInit<Stg_RVI>(_tf);
      case STRAT_SAR:
        return StrategyInit<Stg_SAR>(_tf);
      case STRAT_STDDEV:
        return StrategyInit<Stg_StdDev>(_tf);
      case STRAT_STOCHASTIC:
        return StrategyInit<Stg_Stochastic>(_tf);
      case STRAT_SVE_BB:
        return StrategyInit<Stg_SVE_Bollinger_Bands>(_tf);
      case STRAT_TMAT_SVEBB:
        return StrategyInit<Stg_TMAT_SVEBB>(_tf);
      case STRAT_TMA_TRUE:
        return StrategyInit<Stg_TMA_True>(_tf);
      case STRAT_WPR:
        return StrategyInit<Stg_WPR>(_tf);
      case STRAT_ZIGZAG:
        return StrategyInit<Stg_ZigZag>(_tf);
      default:
      case STRAT_NONE:
        break;
    }

    return NULL;
  }
};

DictStruct<string, Ref<Strategy>> StrategiesManager::_strat_cache;

#endif  // STRATEGIES_MANAGER_H
