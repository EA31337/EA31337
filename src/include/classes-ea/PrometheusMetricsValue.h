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
 * Class to store value for the Prometheus metrics field.
 */

#include "TypedValue.h"

/**
 * Structure stores value for the Prometheus metrics field.
 */
struct PrometheusMetricsValue {
  // Name of the group.
  string group_name;

  // Name of the field.
  string field_name;

  // Value for the field.
  TypedValue value;

  // Field label's values.
  DictStruct<string, string> labels;

  /**
   * Default constructor.
   */
  PrometheusMetricsValue() : value(TYPE_INT) {}

  /**
   * Constructor.
   */
  PrometheusMetricsValue(string _group_name, string _field_name, ENUM_DATATYPE _field_type) : value(_field_type) {
    group_name = _group_name;
    field_name = _field_name;
  }

  /**
   * Stringifies the value.
   */
  string ToString() { return value.ToString(); }
};
