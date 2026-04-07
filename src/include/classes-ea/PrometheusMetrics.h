//+------------------------------------------------------------------+
//|                                                          EA31337 |
//|                                 Copyright 2016-2024, EA31337 Ltd |
//|                                       https://ea31337.github.io/ |
//+------------------------------------------------------------------+

/*
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

/**
 * @file
 * Class to export Prometheus Metrics from EA.
 *
 * @see: https://prometheus.io/docs/instrumenting/exposition_formats/
 */

/**
 * @todo
 * The following metrics can be implemented:
 *
 * # HELP ...
 * # TYPE account Account
 * account_balance
 * account_credit
 * account_equity
 * account_margin
 * account_margin_free
 * account_margin_level
 * account_profit
 * @see: https://www.mql5.com/en/docs/constants/environment_state/accountinformation
 *
 *
 * # HELP ...
 * # TYPE ea EA
 * ea_risk_margin_max # From EAParams
 * ea_stg_processed_periods # From OnTick's _result.stg_processed_periods
 * ea_total_strategies_active # Or maybe it can be aggregated as sum from the other metrics.
 *
 * # HELP ...
 * # TYPE order Order
 * order_ # How we can list all active orders?
 *
 * # HELP ...
 * # TYPE trade Trade
 * trade_lot_size{strategy="", tf=""} # From StgParams
 * trade_magic_no{strategy="", tf=""}
 * trade_max_spread{strategy="", tf=""}
 *
 * # HELP ...
 * # TYPE strategy Strategy
 * strategy_params_id{strategy="", tf=""} 0.01 # From StgParams via Get()
 * strategy_params_lot_size{strategy="", tf=""} 0.01 # From StgParams via Get()
 *
 * # HELP ... Current symbol information.
 * # TYPE symbol SymbolInfo
 * symbolinfo_tick{symbol="EURUSD"} price? (https://www.mql5.com/en/docs/marketinformation/symbolinfotick ?)
 *
 * @see: https://prometheus.io/docs/instrumenting/exposition_formats/
 *
 * # HELP ...
 * # TYPE terminal Terminal
 * terminal_cpu_cores
 * terminal_datetime_time_current (@see: https://www.mql5.com/en/docs/dateandtime)
 * terminal_datetime_time_local
 * terminal_datetime_time_trade_server
 * terminal_disk_space
 * terminal_last_error
 * terminal_memory_available
 * terminal_memory_physical
 * terminal_memory_total
 * terminal_memory_used
 * @see: https://www.mql5.com/en/book/common/environment/env_resources
 * terminal_connected
 * terminal_ping_last
 * @see: https://www.mql5.com/en/book/common/environment/env_connectivity
 */

// Includes.
#include "PrometheusMetricsValue.h"
#include "PrometheusSchema.h"
#include "PrometheusSchemaField.h"
#include "PrometheusSchemaGroup.h"

/**
 * Class to export Prometheus Metrics from EA.
 */
class PrometheusMetrics : public Dynamic {
 protected:
  /* Protected fields */

  // Reference to Prometheus fields schema.
  Ref<PrometheusSchema> schema;

  // Map of added values. Key is a group name + field name. Keys must be unique.
  DictStruct<string, PrometheusMetricsValue> values;

  /* Protected methods */

  /**
   * Init code (called on constructor).
   */
  void Init() {}

 public:
  /**
   * Class constructor.
   */
  PrometheusMetrics(PrometheusSchema* _schema = NULL) {
    schema = _schema;
    Init();
  }

  /**
   * Class deconstructor.
   */
  ~PrometheusMetrics() {}

  /* Public methods */

  /**
   * Prepares for a new set of values.
   */
  void Clear() { values.Clear(); }

  /**
   * Outputs values as Prometheus-compatible code.
   */
  string ToString() {
    if (!schema.IsSet()) {
      Alert("Schema was not set! Please use PrometheusMetrics::SetSchema().");
      DebugBreak();
      return "<missing schema>";
    }

    string _out;
    // Iterating over schema groups, then fields.
    for (DictStructIterator<string, Ref<PrometheusSchemaGroup>> iter = schema.Ptr().GetGroups().Begin(); iter.IsValid();
         ++iter) {
      PrometheusSchemaGroup* _group = iter.Value().Ptr();

      if (iter.Index() != 0) {
        // Group separator.
        _out += "\n";
      }

      if (StringLen(_group.help) > 0) {
        _out += "# HELP " + _group.name + " " + _group.help + "\n";
      }

      _out += "# TYPE " + _group.name + " " + _group.type + "\n";

      // Iterating over group fields.
      for (DictStructIterator<string, Ref<PrometheusSchemaField>> iter2 = _group.GetFields().Begin(); iter2.IsValid();
           ++iter2) {
        PrometheusSchemaField* _field = iter2.Value().Ptr();
        PrometheusMetricsValue _value;
        if (!TryGetValue(_group.name, _field.name, _value)) {
          continue;
        }

        _out += "ea_" + _field.name;

        if (_field.labels.Size() > 0) {
          _out += "{";

          for (DictStructIterator<int, string> iter3 = _field.labels.Begin(); iter3.IsValid(); ++iter3) {
            if (iter3.Index() > 0) {
              // Label separator.
              _out += ", ";
            }

            _out += iter3.Value() + "=\"";

            // Do field value have value for that label?
            unsigned int _label_value_pos;
            if (_value.labels.KeyExists(iter3.Value(), _label_value_pos)) {
              string _label_value = _value.labels.GetByPos(_label_value_pos);
              _out += _label_value;
            }

            _out += "\"";
          }

          _out += "}";
        }

        _out += " " + _value.ToString() + "\n";
      }
    }

    return _out;
  }

  /**
   * Tries to get value for the given field.
   */
  bool TryGetValue(string _group_name, string _field_name, PrometheusMetricsValue& out) {
    unsigned int _value_pos;
    if (values.KeyExists(_group_name + ":" + _field_name, _value_pos)) {
      out = values.GetByPos(_value_pos);
      return true;
    }
    return false;
  }

  /**
   * Checks if we can set given field to given type of value.
   */
  ENUM_DATATYPE CheckSchemaFieldCompatibility(string _group_name, string _field_name, ENUM_DATATYPE _type) {
    if (!schema.IsSet()) {
      Alert("Schema was not set! Please use PrometheusMetrics::SetSchema().");
      DebugBreak();
      return (ENUM_DATATYPE)-1;
    }

    // @todo
    return _type;
  }

  /**
   * Returns given schema field.
   */
  PrometheusSchemaField* GetSchemaField(string _group_name, string _field_name) {
    if (!schema.IsSet()) {
      Alert("Schema was not set! Please use PrometheusMetrics::SetSchema().");
      DebugBreak();
      return NULL;
    }

    return schema.Ptr().GetField(_group_name, _field_name);
  }

  /**
   * Sets value of the given field.
   */
  template <typename T>
  void SetValue(string _group_name, string _field_name, T value) {
    T _typed_value = T();
    ENUM_DATATYPE _field_type = CheckSchemaFieldCompatibility(_group_name, _field_name, GetType(_typed_value));
    
    if (_field_type == (ENUM_DATATYPE)-1) {
      // Schema validation failed, don't set the value
      return;
    }

    PrometheusMetricsValue _value(_group_name, _field_name, _field_type);
    _value.value.Set(value);

    values.Set(_group_name + ":" + _field_name, _value);
  }

  /**
   * Sets value of the given field with label values.
   */
  template <typename T>
  void SetValue(string _group_name, string _field_name, T value, DictStruct<string, string>& labels) {
    T _typed_value = T();
    ENUM_DATATYPE _field_type = CheckSchemaFieldCompatibility(_group_name, _field_name, GetType(_typed_value));

    PrometheusMetricsValue _value(_group_name, _field_name, _field_type);
    _value.value.Set(value);
    _value.labels = labels;

    values.Set(_group_name + ":" + _field_name, _value);
  }
};
