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

#include "../classes/DictStruct.mqh"
#include "../classes/Object.mqh"
#include "PrometheusSchemaGroup.h"

/**
 * Class to create schema for Prometheus Metrics to be exported from EA.
 */
class PrometheusSchema : public Dynamic {
 protected:
  /* Protected fields */

  // Dict of group name => group information.
  DictStruct<string, Ref<PrometheusSchemaGroup>> groups;

 public:
  /* Public methods */

  /**
   * Adds field group to the schema.
   */
  void AddGroup(string name, string type, string help = "") {
    Ref<PrometheusSchemaGroup> _group = new PrometheusSchemaGroup(name, type, help);
    groups.Set(name, _group);
  }

  /**
   * Adds field to the given schema group.
   */
  void AddField(string _group_name, string _field_name, ENUM_DATATYPE _field_type, string _field_help = "") {
    // Searching for the group.
    unsigned int _group_pos;
    if (!groups.KeyExists(_group_name, _group_pos)) {
      Alert("You have to add the group \"", _group_name, "\" via AddGroup() before using AddField()!");
      DebugBreak();
      return;
    }
    Ref<PrometheusSchemaGroup> _group = groups.GetByPos(_group_pos);
    _group.Ptr().AddField(_field_name, _field_type, _field_help);
  }

  /**
   * Returns given schema field.
   */
  PrometheusSchemaField* GetField(string _group_name, string _field_name) {
    unsigned int _group_pos;
    if (!groups.KeyExists(_group_name, _group_pos)) {
      Alert("There is no group \"", _group_name, "\" in the schema (when trying to get field \"", _field_name, "\")!");
      DebugBreak();
      return NULL;
    }
    Ref<PrometheusSchemaGroup> _group = groups.GetByPos(_group_pos);
    return _group.Ptr().GetField(_field_name);
  }

  /**
   * Adds label to the given field.
   */
  void AddLabel(string _group_name, string _field_name, string _label_name) {
    // Searching for the field.
    PrometheusSchemaField* _field = GetField(_group_name, _field_name);

    if (_field == NULL) {
      Alert("There is no field \"", _field_name, "\" in group \"", _group_name,
            "\"! You need to add it before using AddLabel()!");
      DebugBreak();
      return;
    }

    _field.AddLabel(_label_name);
  }

  /**
   * Returns schema groups.
   */
  DictStruct<string, Ref<PrometheusSchemaGroup>>* GetGroups() { return &groups; }
};
