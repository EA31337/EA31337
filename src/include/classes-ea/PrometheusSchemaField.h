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
 * Class to store information about Prometheus schema field.
 */

/**
 * Stores information about Prometheus schema field.
 */
class PrometheusSchemaField : public Dynamic {
 public:
  /* Public fields */

  // Name of the field.
  string name;

  // Type of the field.
  ENUM_DATATYPE type;

  // Description of the field.
  string help;

  // List of labels.
  DictStruct<int, string> labels;

  /**
   * Constructor.
   */
  PrometheusSchemaField(string _name, ENUM_DATATYPE _type, string _help = "") {
    name = _name;
    type = _type;
    help = _help;
  }

  /* Public methods */

  /**
   * Adds label to this field.
   */
  void AddLabel(string _label_name) {
    if (labels.IndexOf(_label_name) != -1) {
      Alert("Label \"", _label_name, "\" already added to the field \"", name, "\"!");
      DebugBreak();
      return;
    }

    labels.Push(_label_name);
  }
};
