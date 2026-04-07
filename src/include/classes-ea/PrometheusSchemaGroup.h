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
 * Class to store information about Prometheus schema group.
 */

#include "../classes/DictStruct.mqh"
#include "../classes/Object.mqh"
#include "PrometheusSchemaField.h"

/**
 * Stores information about Prometheus schema group.
 */
class PrometheusSchemaGroup : public Dynamic {
 public:
  /* Protected fields */

  // Name of the group.
  string name;

  // Type of the group: counter, gauge, histogram, summary.
  string type;

  // Description of the group.
  string help;

  // Dict of field name => field information.
  DictStruct<string, Ref<PrometheusSchemaField>> fields;

  /**
   * Constructor.
   */
  PrometheusSchemaGroup(string _name, string _type, string _help) {
    name = _name;
    type = _type;
    help = _help;
  }

  /* Public methods */

  /**
   * Adds field to this schema group.
   */
  void AddField(string _field_name, ENUM_DATATYPE _field_type, string _field_help = "") {
    if (fields.KeyExists(_field_name)) {
      Alert("Field \"", _field_name, "\" has been already added to the group \"", name, "\"!");
      DebugBreak();
      return;
    }
    Ref<PrometheusSchemaField> _field = new PrometheusSchemaField(_field_name, _field_type, _field_help);
    fields.Set(_field_name, _field);
  }

  /**
   * Returns given field.
   */
  PrometheusSchemaField* GetField(string _field_name) {
    unsigned int _field_pos;
    if (!fields.KeyExists(_field_name, _field_pos)) {
      Alert("There is no field \"", _field_name, "\" in the schema group \"", name, "\"!");
      DebugBreak();
      return NULL;
    }
    Ref<PrometheusSchemaField> _field = fields.GetByPos(_field_pos);
    return _field.Ptr();
  }

  /**
   * Returns fields.
   */
  DictStruct<string, Ref<PrometheusSchemaField>>* GetFields() { return &fields; }
};
