//+------------------------------------------------------------------+
//|                  EA31337 - multi-strategy advanced trading robot |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Defines EA parameter values.
struct Stg_SAR_EA_Params : EA_Params {
  Stg_SAR_EA_Params() {
    name = ea_name;
    magic_no = rand();
    log_level = Log_Level;
    chart_info_freq = Info_On_Chart ? 2 : 0;
    report_to_file = false;
  }
};
