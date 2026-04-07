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
 * Class stores a single, typed value. Value can be set from various incoming types.

 * USAGE:
 * TypedValue value(TYPE_STRING);
 * value.Set(150);
 */

/**
 * Union to store POD value.
 */
union TypedValueUnion {
  bool vbool;
  long vlong;
  double vdouble;
};

template <typename T>
ENUM_DATATYPE GetType() {
  Alert("Missing template override!");
  DebugBreak();
  return (ENUM_DATATYPE)-1;
}

template <>
ENUM_DATATYPE GetType(datetime) {
  return TYPE_DATETIME;
}
template <>
ENUM_DATATYPE GetType(bool) {
  return TYPE_BOOL;
}
template <>
ENUM_DATATYPE GetType(char) {
  return TYPE_CHAR;
}
template <>
ENUM_DATATYPE GetType(unsigned char) {
  return TYPE_UCHAR;
}
template <>
ENUM_DATATYPE GetType(unsigned short) {
  return TYPE_USHORT;
}
template <>
ENUM_DATATYPE GetType(color) {
  return TYPE_COLOR;
}
template <>
ENUM_DATATYPE GetType(int) {
  return TYPE_INT;
}
template <>
ENUM_DATATYPE GetType(unsigned int) {
  return TYPE_UINT;
}
template <>
ENUM_DATATYPE GetType(long) {
  return TYPE_LONG;
}
template <>
ENUM_DATATYPE GetType(unsigned long) {
  return TYPE_ULONG;
}
template <>
ENUM_DATATYPE GetType(float) {
  return TYPE_FLOAT;
}
template <>
ENUM_DATATYPE GetType(double) {
  return TYPE_DOUBLE;
}
template <>
ENUM_DATATYPE GetType(string) {
  return TYPE_STRING;
}

/**
 * Class stores a value that can set and retrieved by any type.
 */
class TypedValue {
 protected:
  /* Protected fields */

  // POD value stored.
  TypedValueUnion value;

  // String value stored.
  string vstring;

  // Date and time value stored.
  datetime vdatetime;

  // Type of value stored.
  ENUM_DATATYPE type;

 public:
  /**
   * Constructor
   */
  TypedValue(ENUM_DATATYPE _type) {
    type = _type;

    switch (type) {
      case TYPE_BOOL:
        value.vbool = false;
        break;
      case TYPE_CHAR:
        vstring = "";
        break;
      case TYPE_UCHAR:
      case TYPE_SHORT:
      case TYPE_USHORT:
      case TYPE_INT:
      case TYPE_UINT:
      case TYPE_LONG:
      case TYPE_ULONG:
        value.vlong = 0;
        break;
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
        value.vdouble = 0;
        break;
      case TYPE_STRING:
        vstring = "";
        break;
      case TYPE_DATETIME:
        vdatetime = (datetime)0;
        break;
      default:
        Alert("Unsupported type: ", EnumToString(type));
        DebugBreak();
    }
  }

  /* Public methods */

  /**
   * Sets value from given boolean.
   */
  void Set(bool _value) {
    switch (type) {
      case TYPE_BOOL:
        value.vbool = _value;
        break;
      case TYPE_CHAR:
        vstring = _value ? "+" : "-";
        break;
      case TYPE_UCHAR:
      case TYPE_SHORT:
      case TYPE_USHORT:
      case TYPE_INT:
      case TYPE_UINT:
      case TYPE_LONG:
      case TYPE_ULONG:
        value.vlong = _value;
        break;
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
        value.vdouble = _value ? 1.0 : 0;
        break;
      case TYPE_STRING:
        vstring = _value ? "True" : "False";
        break;
      case TYPE_DATETIME:
        Alert("Could not initialize datetime property from bool value!");
        DebugBreak();
        break;
      default:
        Alert("Unsupported type: ", EnumToString(type));
        DebugBreak();
    }
  }

  /**
   * Sets value from given number.
   */
  void Set(char _value) { Set(CharToString(_value)); }

  /**
   * Sets value from given number.
   */
  void Set(unsigned char _value) { Set((long)_value); }

  /**
   * Sets value from given number.
   */
  void Set(short _value) { Set((long)_value); }

  /**
   * Sets value from given number.
   */
  void Set(unsigned short _value) { Set((long)_value); }

  /**
   * Sets value from given number.
   */
  void Set(int _value) { Set((long)_value); }

  /**
   * Sets value from given number.
   */
  void Set(unsigned int _value) { Set((long)_value); }

  /**
   * Sets value from given number.
   */
  void Set(unsigned long _value) { Set((long)_value); }

  /**
   * Sets value from given number.
   */
  void Set(long _value) {
    switch (type) {
      case TYPE_BOOL:
        value.vbool = _value != 0;
        break;
      case TYPE_CHAR:
        vstring = (_value != 0) ? "+" : "-";
        break;
      case TYPE_UCHAR:
      case TYPE_SHORT:
      case TYPE_USHORT:
      case TYPE_INT:
      case TYPE_UINT:
      case TYPE_LONG:
      case TYPE_ULONG:
        value.vlong = _value;
        break;
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
        value.vdouble = (double)_value;
        break;
      case TYPE_STRING:
        vstring = IntegerToString(_value);
        break;
      case TYPE_DATETIME:
        vdatetime = (datetime)_value;
        break;
      default:
        Alert("Unsupported type: ", EnumToString(type));
        DebugBreak();
    }
  }

  /**
   * Sets value from given number.
   */
  void Set(double _value) {
    switch (type) {
      case TYPE_BOOL:
        value.vbool = _value != 0;
        break;
      case TYPE_CHAR:
        vstring = (_value != 0) ? "+" : "-";
        break;
      case TYPE_UCHAR:
      case TYPE_SHORT:
      case TYPE_USHORT:
      case TYPE_INT:
      case TYPE_UINT:
      case TYPE_LONG:
      case TYPE_ULONG:
        value.vlong = (long)_value;
        break;
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
        value.vdouble = _value;
        break;
      case TYPE_STRING:
        vstring = DoubleToString(_value);
        break;
      case TYPE_DATETIME:
        Alert("Could not initialize datetime property from double value!");
        DebugBreak();
        break;
      default:
        Alert("Unsupported type: ", EnumToString(type));
        DebugBreak();
    }
  }

  /**
   * Sets value from given string.
   */
  void Set(string _value) {
    switch (type) {
      case TYPE_BOOL:
        value.vbool = _value == "+" || _value == "True" || _value == "true" || _value == "Yes" || _value == "yes" ||
                      _value == "On" || _value == "on" || _value == "Enabled" || _value == "enabled";
        break;
      case TYPE_CHAR:
        vstring = StringSubstr(_value, 0, 1);
        break;
      case TYPE_UCHAR:
      case TYPE_SHORT:
      case TYPE_USHORT:
      case TYPE_INT:
      case TYPE_UINT:
      case TYPE_LONG:
      case TYPE_ULONG:
        value.vlong = StringToInteger(_value);
        break;
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
        value.vdouble = StringToDouble(_value);
        break;
      case TYPE_STRING:
        vstring = _value;
        break;
      case TYPE_DATETIME:
        vdatetime = StringToTime(_value);
        break;
      default:
        Alert("Unsupported type: ", EnumToString(type));
        DebugBreak();
    }
  }

  /**
   * Sets value from given date and time.
   */
  void Set(datetime _value) {
    switch (type) {
      case TYPE_BOOL:
        Alert("Could not initialize bool property from datetime value!");
        DebugBreak();
        break;
      case TYPE_CHAR:
      case TYPE_UCHAR:
      case TYPE_SHORT:
      case TYPE_USHORT:
      case TYPE_INT:
      case TYPE_UINT:
        Alert("Could not initialize char/short/int property from datetime value!");
        DebugBreak();
        break;
      case TYPE_LONG:
      case TYPE_ULONG:
        value.vlong = (long)_value;
        break;
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
        Alert("Could not initialize float/double property from datetime value!");
        DebugBreak();
        break;
      case TYPE_STRING:
        vstring = TimeToString(_value);
        break;
      case TYPE_DATETIME:
        vdatetime = _value;
        break;
      default:
        Alert("Unsupported type: ", EnumToString(type));
        DebugBreak();
    }
  }

  /**
   * Stringifies the value.
   */
  string ToString() {
    switch (type) {
      case TYPE_BOOL:
        return value.vbool ? "1" : "0";
      case TYPE_UCHAR:
      case TYPE_SHORT:
      case TYPE_USHORT:
      case TYPE_INT:
      case TYPE_UINT:
      case TYPE_LONG:
      case TYPE_ULONG:
        return IntegerToString(value.vlong);
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
        return DoubleToString(value.vdouble);
      case TYPE_CHAR:
      case TYPE_STRING:
        return vstring;
      case TYPE_DATETIME:
        return IntegerToString((long)vdatetime);
      default:
        Alert("Unsupported type: ", EnumToString(type));
        DebugBreak();
    }
    return "";
  }
};
