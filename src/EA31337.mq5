//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

// Includes.
#include "include/includes.mqh"

// Class variables.
Account *account;
Chart *chart;
Collection *strats;
Log *logger;
Mail *mail;
Market *market;
Stats *total_stats, *hourly_stats;
SummaryReport *summary_report; // For summary report.
Ticker *ticker; // For parsing ticks.
Terminal *terminal;
Trade *trade[FINAL_ENUM_TIMEFRAMES_INDEX];

// Market/session variables.
double pip_size, ea_lot_size;
double last_ask, last_bid;
uint order_freezelevel; // Order freeze level in points.
double curr_spread; // Broker current spread in pips.
double curr_trend; // Current trend.
double ea_risk_margin_per_order, ea_risk_margin_total; // Risk marigin in percent.
uint pts_per_pip; // Number points per pip.
int gmt_offset = 0; // Current difference between GMT time and the local computer time in seconds, taking into account switch to winter or summer time. Depends on the time settings of your computer.
// double total_sl, total_tp; // Total SL/TP points.

// Account variables.
string account_type;
double init_balance; // Initial account balance.
long init_spread; // Initial spread.

// State variables.
bool session_initiated = false;
bool session_active = false;

// Time-based variables.
// Bar time: initial, current and last one to check if bar has been changed since the last time.
datetime curr_bar_time;
datetime time_current = (int) EMPTY_VALUE;
int hour_of_day, day_of_week, day_of_month, day_of_year, month, year;
datetime last_order_time = 0;
int last_history_check = 0; // Last ticket position processed.
datetime last_traded;

// Strategy variables.
int info[FINAL_STRATEGY_TYPE_ENTRY][FINAL_STRATEGY_INFO_ENTRY];
double conf[FINAL_STRATEGY_TYPE_ENTRY][FINAL_STRATEGY_VALUE_ENTRY], stats[FINAL_STRATEGY_TYPE_ENTRY][FINAL_STRATEGY_STAT_ENTRY];
int open_orders[FINAL_STRATEGY_TYPE_ENTRY], closed_orders[FINAL_STRATEGY_TYPE_ENTRY];
int tickets[]; // List of tickets to process.
int worse_strategy[FINAL_STAT_PERIOD_TYPE_ENTRY], best_strategy[FINAL_ENUM_TIMEFRAMES_INDEX];

// EA variables.
bool ea_active = false; bool ea_expired = false;
double ea_risk_ratio; string rr_text; // Vars for calculation risk ratio.
double ea_margin_risk_level[3]; // For margin risk (all/buy/sell);
unsigned long max_orders = 10, daily_orders; // Maximum orders available to open.
unsigned int max_order_slippage; // Maximum price slippage for buy or sell orders (in points)
int err_code; // Error code.
string last_err, last_msg, last_debug, last_trace;
string ea_last_order;
double last_pip_change; // Last tick change in pips.
double last_close_profit = EMPTY;
// int last_trail_update = 0, last_indicators_update = 0, last_stats_update = 0;
int todo_queue[][8];
datetime last_queue_process = 0;
uint total_orders = 0; // Number of total orders currently open.
double daily[FINAL_VALUE_TYPE_ENTRY], weekly[FINAL_VALUE_TYPE_ENTRY], monthly[FINAL_VALUE_TYPE_ENTRY];
double hourly_profit[367][24]; // Keep track of hourly profit.

// Used for writing the report file.
string log[];

// Condition and actions.
int acc_conditions[30][3];
string last_cname;

// Order queue.
long order_queue[][FINAL_ORDER_QUEUE_ENTRY];

// For debugging purposes.
string stacktrace = "";
#define DEBUG_CHECKPOINT_RESET stacktrace = __FUNCTION__;
#define DEBUG_CHECKPOINT_ADD  stacktrace += ">" + __FUNCTION__ + ":" + (string) __LINE__;
#define DEBUG_CHECKPOINT_POP  stacktrace += "<";
#define DEBUG_STACK_PRINT  Print(stacktrace);
#define DEBUG_STACK_GET    stacktrace

// Indicator variables.
double iac[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double ad[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double adx[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_ADX_LINE_ENTRY];
double alligator[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_GATOR_LINE_ENTRY];
double atr[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double awesome[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double bands[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_BANDS_LINE_ENTRY];
double bwmfi[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double bpower[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][ORDER_TYPE_SELL+1];
double cci[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double demarker[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double envelopes[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_LO_UP_LINE_ENTRY];
double force[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double fractals[H4][FINAL_ENUM_INDICATOR_INDEX][FINAL_LO_UP_LINE_ENTRY];
double gator[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_GATOR_LINE_ENTRY];
double ichimoku[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_ICHIMOKU_LINE_ENTRY];
double ma_fast[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX], ma_medium[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX], ma_slow[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double macd[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_SIGNAL_LINE_ENTRY];
double mfi[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double momentum[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double obv[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double osma[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double rsi[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX], rsi_stats[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_LO_UP_LINE_ENTRY];
double rvi[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_SIGNAL_LINE_ENTRY];
double sar[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX]; int sar_week[FINAL_ENUM_TIMEFRAMES_INDEX][7][2];
double stddev[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double stochastic[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX][FINAL_SIGNAL_LINE_ENTRY];
double wpr[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];
double zigzag[FINAL_ENUM_TIMEFRAMES_INDEX][FINAL_ENUM_INDICATOR_INDEX];

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
  //#ifdef __trace__ PrintFormat("%s: Ask=%g/Bid=%g", __FUNCTION__, Ask, Bid); #endif
  if (!session_initiated) return;
  //#ifdef __profiler__ PROFILER_START #endif

  MqlTick _tick = market.GetTick();
  bool _tick_procesed = false;
  for (ENUM_TIMEFRAMES_INDEX tfi = 0; tfi < FINAL_ENUM_TIMEFRAMES_INDEX; tfi++) {
    if (Object::IsDynamic(trade[tfi]) && trade[tfi].Chart().IsValidTf()) {
      if (trade[tfi].Chart().IsNewBar()) {
        trade[tfi].Market().SetTick(_tick);
        ProcessBar(trade[tfi]);
        _tick_procesed = true;
      }
    }
  }
  if (_tick_procesed) {
    if (!terminal.IsOptimization()) {
      terminal.Logger().Flush(false);
    }
  }
  UpdateTicks();
  //#ifdef __profiler__ PROFILER_STOP #endif
} // end: OnTick()

/**
 * Process a new bar.
 */
void ProcessBar(Trade *_trade) {

  // Parse a tick.
  /*
  if (!ticker.Process(_trade.Chart(), TickProcessMethod)) {
    // Ignore a tick according to the method.
    return;
  }
  */

  /* @fixme: Disabled.
  // Check if we should ignore the tick based on the price change.
  if (last_pip_change < MinPipChangeToTrade) {
    if (last_bar_time == trade.GetBarTime(PERIOD_M1)) {
      return;
    }
  }
  else {
    last_bar_time = trade.GetBarTime(PERIOD_M1);
  }
  */
  if (!Object::IsDynamic(_trade)) {
    PrintFormat("%s: Error: Trade object not valid!", __FUNCTION_LINE__);
  }
  else if (!Object::IsDynamic(_trade.Chart())) {
    PrintFormat("%s: Error: Chart object not valid!", __FUNCTION_LINE__);
  }

  if (TradeAllowed()) {
    last_ask = market.GetLastAsk();
    last_bid = market.GetLastBid();
    last_pip_change = market.GetLastPriceChangeInPips();
    if (hour_of_day != DateTime::Hour()) {
      StartNewHour(_trade);
    }
    UpdateVariables();
    EA_Trade(_trade);
    UpdateOrders(_trade);
    UpdateStats();
  }

  if (PrintLogOnChart) {
    // Update stats on chart.
    DisplayInfoOnChart();
  }
}

/**
 * Update ticks.
 */
void UpdateTicks() {
  if (!terminal.IsOptimization()) {
    // Update stats.
    if (RecordTicksToCSV) {
      total_stats.OnTick();
      hourly_stats.OnTick();
      ticker.Add(market.GetLastTick());
    }
  }
}

/**
 * Update existing opened orders.
 */
void UpdateOrders(Trade *_trade) {
  #ifdef __profiler__ PROFILER_START #endif
  if (total_orders > 0) {
    CheckOrders();
    UpdateTrailingStops(_trade);
    CheckAccConditions(_trade.Chart());
    TaskProcessList();
  }
  #ifdef __profiler__ PROFILER_STOP #endif
}

/**
 * Process orders.
 *
 * This is invoked after order being placed or each hour.
 */
void ProcessOrders() {
  UpdateMarginRiskLevel();
}

/**
 * Update margin risk level.
 */
void UpdateMarginRiskLevel() {
  if (RiskMarginTotal >= 0) {
    ea_margin_risk_level[ORDER_TYPE_BUY] = account.GetRiskMarginLevel(ORDER_TYPE_BUY); // Get current risk margin level for buy orders.
    ea_margin_risk_level[ORDER_TYPE_SELL] = account.GetRiskMarginLevel(ORDER_TYPE_SELL); // Get current risk margin level for sell orders.
    ea_margin_risk_level[2] = account.GetRiskMarginLevel(); // Get current risk margin level for all orders.
  }
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
  string err;
  if (VerboseInfo) PrintFormat("%s v%s (%s) initializing...", ea_name, ea_version, ea_link);
  if (!session_initiated) {
    err_code = CheckSettings();
    if (err_code < 0) {
      // Incorrect set of input parameters occured.
      Msg::ShowText(StringFormat("EA parameters are not valid, please correct (code: %d).", err_code), "Error", __FUNCTION__, __LINE__, VerboseErrors, true, true);
      ea_active = false;
      session_active = false;
      session_initiated = false;
      return (INIT_PARAMETERS_INCORRECT);
    }
    #ifdef __release__
    if (Terminal::IsRealtime() && Account::AccountNumber() <= 1) {
      // @todo: Fails when debugging.
      Msg::ShowText("EA requires on-line Terminal.", "Error", __FUNCTION__, __LINE__, VerboseErrors, true);
      ea_active = false;
      session_active = false;
      session_initiated = false;
      return (INIT_FAILED);
     }
     #endif
     session_initiated = true;
  }

  #ifdef __profiler__ PROFILER_SET_MIN(10) #endif
  #ifdef __profiler__ PROFILER_START #endif

  session_initiated &= InitClasses();
  session_initiated &= InitVariables();
  session_initiated &= InitStrategies();
  session_initiated &= InitializeConditions();
  session_initiated &= CheckHistory();

  if (!Terminal::IsRealtime()) {
    // When testing, we need to simulate real MODE_STOPLEVEL = 30 (as it's in real account), in demo it's 0.
    // if (market_stoplevel == 0) market_stoplevel = DemoMarketStopLevel;
  }

  if (session_initiated) {
    session_active = true;
    ea_active = true;
    if (VerboseInfo) {
      string output = InitInfo(true);
      String::PrintText(output);
      Comment(output);
      ReportAdd(InitInfo());
    }
  }

  ChartRedraw();
  #ifdef __profiler__ PROFILER_STOP_PRINT #endif
  return (session_initiated ? INIT_SUCCEEDED : INIT_FAILED);
} // end: OnInit()

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
  time_current = TimeCurrent();

  // Flush logs.
  if (Object::IsDynamic(terminal) && Object::IsDynamic(terminal.Logger())) {
    terminal.Logger().Flush(false);
  }

  Msg::ShowText(StringFormat("reason = %d", reason), "Debug", __FUNCTION__, __LINE__, VerboseDebug);

  // Also: _UninitReason.
  Msg::ShowText(
      StringFormat("EA deinitializing, reason: %s (code: %s)", Terminal::GetUninitReasonText(reason), IntegerToString(reason)),
      "Info", __FUNCTION__, __LINE__, VerboseInfo);

  if (session_initiated) {
    if (!terminal.IsOptimization()) {
      // Show final account details.
      Msg::ShowText(GetSummaryText(), "Info", __FUNCTION__, __LINE__, VerboseInfo);

      #ifdef __profiler__ PROFILER_PRINT #endif

      // Save ticks if recorded.
      if (RecordTicksToCSV) {
        ticker.SaveToCSV();
      }

      if (WriteReport) {
        // if (reason == REASON_CHARTCHANGE)
        string filename;
        Chart *_chart = trade[chart.TfToIndex()].Chart();
        OHLC first_bar = _chart.LoadOHLC();
        summary_report.CalculateSummary();
        // @todo: Calculate average spread from stats[sid][AVG_SPREAD].
        filename = StringFormat(
            "%s-%.f%s-%s-%s-%dspread-%s-report.txt",
            market.GetSymbol(), summary_report.GetInitDeposit(), account.GetCurrency(),
            DateTime::TimeToStr(first_bar.time, TIME_DATE), DateTime::TimeToStr(_chart.iTime(), TIME_DATE),
            init_spread, chart.TfToString());
            // ea_name, _Symbol, summary.init_deposit, account.AccountCurrency(), init_spread, TimeToStr(time_current, TIME_DATE), Period());
            // ea_name, _Symbol, init_balance, account.AccountCurrency(), init_spread, TimeToStr(time_current, TIME_DATE|TIME_MINUTES), Period());
        string data = summary_report.GetReport();
        data += GetStatReport();
        data += GetStrategyReport();
        data += Array::ArrToString(log, "\n", "Report log:\n");
        Report::WriteReport(filename, data, VerboseInfo); // Todo: Add: Errors::GetUninitReasonText(reason)
        Msg::ShowText(StringFormat("Saved report as: %s", filename), "Info", __FUNCTION__, __LINE__, VerboseInfo);
      }

    }

  }
  DeinitVars();
  // #ifdef _DEBUG
  // DEBUG("n=" + n + " : " +  DoubleToStrMorePrecision(val,19) );
  // DEBUG("CLOSEDEBUGFILE");
  // #endif
} // end: OnDeinit()

/**
 * Deinitialize global variables.
 */
void DeinitVars() {
  Object::Delete(account);
  Object::Delete(hourly_stats);
  Object::Delete(logger);
  Object::Delete(total_stats);
  Object::Delete(summary_report);
  Object::Delete(ticker);
  Object::Delete(terminal);
  Object::Delete(mail);
  Object::Delete(market);
  Object::Delete(strats);
  for (int tfi = 0; tfi < FINAL_ENUM_TIMEFRAMES_INDEX; tfi++) {
    Object::Delete(trade[tfi]);
  }
  #ifdef __profiler__ PROFILER_DEINIT #endif
}

/**
 * Test completion event handler.
 *
 * Returns calculated value that is used as the Custom max criterion in the genetic optimization of input parameters.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
/*
double OnTester() {
  if (ProfilingMinTime > 0) {
  }
}
*/

/**
 * Implements handler of the TesterPass event (MQL5 only).
 *
 * Invoked when a frame is received during EA optimization in the strategy tester.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
void OnTesterPass() {
  Print("Calling ", __FUNCTION__, ".");
  /*
  if (ProfilingMinTime > 0) {
    // Print("PROFILER: ", timers.ToString(0));
  }
  */
}

/**
 * Implements handler of the TesterInit event (MQL5 only).
 *
 * Invoked with the start of optimization in the strategy tester.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
void OnTesterInit() {
  //if (VerboseDebug)
  Print("Calling ", __FUNCTION__, ".");
  #ifdef __MQL5__
    // Specifies the use of input variable when optimizing: value, change step, initial and final values.
    // @see: https://www.mql5.com/en/docs/optimization_frames/parametersetrange
    //ParameterSetRange(LotSize, 0, 0.0, 0.01, 0.01, 0.1);
  #endif
}

/**
 * Implements handler of the TesterDeinit event (MQL5 only).
 *
 * Invoked after the end of optimization of an Expert Advisor in the strategy tester.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
void OnTesterDeinit() {
  //if (VerboseDebug)
  Print("Calling ", __FUNCTION__, ".");
}

// @todo: OnTradeTransaction (https://www.mql5.com/en/docs/basis/function/events).

/**
 * Print init variables and constants.
 */
string InitInfo(bool startup = false, string sep = "\n") {
  string extra = "";
  string output = StringFormat("%s v%s by %s (%s)%s%s", ea_name, ea_version, ea_author, ea_link, extra, sep);
  output += "TERMINAL: " + terminal.ToString() + sep;
  output += "ACCOUNT: " + account.ToString() + sep;
  output += "SYMBOL: " + ((SymbolInfo *)market).ToString() + sep;
  output += "MARKET: " + market.ToString() + sep;
  output += "TRADE: " + trade[Chart::TfToIndex(PERIOD_CURRENT)].ToString() + sep;
  for (ENUM_TIMEFRAMES_INDEX _tfi = 0; _tfi < FINAL_ENUM_TIMEFRAMES_INDEX; _tfi++) {
    if (Object::IsValid(trade[_tfi]) && trade[_tfi].Chart().IsValidTf()) {
      output += StringFormat("CHART: %s%s", trade[_tfi].Chart().ToString(), sep);
    }
  }

  // @todo: Move to SymbolInfo.
  output += StringFormat("Swap specification for %s: Mode: %d, Long/buy order value: %g, Short/sell order value: %g%s",
      _Symbol,
      (int)SymbolInfoInteger(_Symbol, SYMBOL_SWAP_MODE),
      SymbolInfoDouble(_Symbol, SYMBOL_SWAP_LONG),
      SymbolInfoDouble(_Symbol, SYMBOL_SWAP_SHORT),
      sep);
  output += StringFormat("Calculated variables: Pip size: %g, EA lot size: %g, Points per pip: %d, Pip digits: %d, Volume digits: %d, Spread in pips: %.1f (%d pts), Stop Out Level: %.1f, Market gap: %d pts (%g pips)%s",
      market.GetPipSize(),
      NormalizeDouble(ea_lot_size, market.GetVolumeDigits()),
      pts_per_pip,
      market.GetPipDigits(),
      market.GetVolumeDigits(),
      market.GetSpreadInPips(),
      market.GetSpreadInPts(),
      account.GetAccountStopoutLevel(),
      market.GetTradeDistanceInPts(),
      market.GetTradeDistanceInPips(),
      sep);
  output += StringFormat("EA params: Risk ratio: %g, Risk margin per order: %g%%, Risk margin in total: %g%%%s",
      ea_risk_ratio, ea_risk_margin_per_order, ea_risk_margin_total,
      sep);
  output += StringFormat("Strategies: Active strategies: %d of %d, Max orders: %d (per type: %d)%s",
      GetNoOfStrategies(),
      FINAL_STRATEGY_TYPE_ENTRY,
      max_orders,
      GetMaxOrdersPerType(),
      sep);
  output += Msg::ShowText(Chart::GetModellingQuality(), "Info", __FUNCTION__, __LINE__, VerboseInfo) + sep;
  output += Chart::ListTimeframes() + sep;
  output += StringFormat("Datetime: Hour of day: %d, Day of week: %d, Day of month: %d, Day of year: %d, Month: %d, Year: %d%s",
      hour_of_day, day_of_week, day_of_month, day_of_year, month, year, sep);
  output += GetAccountTextDetails() + sep;
  if (startup) {
    if (session_initiated && terminal.IsTradeAllowed()) {
      if (TradeAllowed()) {
        output += sep + "Trading is allowed, waiting for new bars...";
      } else {
        output += sep + "Trading is allowed, but there is some issue...";
        output += sep + last_err;
      }
    } else if (terminal.IsRealtime()) {
      output += sep + StringFormat("Error %d: Trading is not allowed for this symbol, please enable automated trading or check the settings!", __LINE__);
    }
    else {
      output += sep + "Waiting for new bars...";
    }
  }
  return output;
}

/**
 * Main function to trade.
 */
bool EA_Trade(Trade *_trade) {
  DEBUG_CHECKPOINT_RESET
  #ifdef __profiler__ PROFILER_START #endif
  bool order_placed = false;
  int sid;
  Strategy *strat;
  ENUM_ORDER_TYPE _cmd = EMPTY;
  ENUM_TIMEFRAMES tf = _trade.Chart().GetTf();
  if (VerboseTrace) _trade.Logger().Trace(StringFormat("%s:%d: %s", __FUNCTION__, __LINE__, DateTime::TimeToStr(_trade.Chart().GetBarTime())));

  for (sid = 0; sid < strats.GetSize(); sid++) {
    strat = ((Strategy *) strats.GetByIndex(sid));

    if (strat.GetTf() == tf && strat.IsEnabled() && !strat.IsSuspended()) {
      if (strat.SignalOpen(ORDER_TYPE_BUY)) {
        _cmd = ORDER_TYPE_BUY;
      } else if (strat.SignalOpen(ORDER_TYPE_SELL)) {
        _cmd = ORDER_TYPE_SELL;
      } else {
        _cmd = EMPTY;
      }

      if (!DisableCloseConditions) {
        if (CheckMarketEvent(strat.Chart(), ORDER_TYPE_BUY,  strat.GetSignalCloseMethod1())) {
          CloseOrdersByType(ORDER_TYPE_SELL, strat.GetId(), strat.GetSignalCloseMethod1(), CloseConditionOnlyProfitable);
        }
        if (CheckMarketEvent(strat.Chart(), ORDER_TYPE_SELL, strat.GetSignalCloseMethod1())) {
          CloseOrdersByType(ORDER_TYPE_BUY,  strat.GetId(), strat.GetSignalCloseMethod1(), CloseConditionOnlyProfitable);
        }
      }

      if (strat.GetSignalOpenMethod1() != 0) {
        if (_cmd == ORDER_TYPE_BUY  && !CheckMarketCondition1(strat.Chart(), ORDER_TYPE_BUY,  strat.GetSignalOpenMethod1())) _cmd = EMPTY;
        if (_cmd == ORDER_TYPE_SELL && !CheckMarketCondition1(strat.Chart(), ORDER_TYPE_SELL, strat.GetSignalOpenMethod1())) _cmd = EMPTY;
      }

      if (Object::IsDynamic(trade[Chart::TfToIndex(TrendPeriod)]) && strat.GetSignalOpenMethod2() != 0) {
        if (_cmd == ORDER_TYPE_BUY  && CheckMarketCondition1(trade[Chart::TfToIndex(TrendPeriod)].Chart(), ORDER_TYPE_SELL, strat.GetSignalOpenMethod2(), false)) _cmd = EMPTY;
        if (_cmd == ORDER_TYPE_SELL && CheckMarketCondition1(trade[Chart::TfToIndex(TrendPeriod)].Chart(), ORDER_TYPE_BUY,  strat.GetSignalOpenMethod2(), false)) _cmd = EMPTY;
      }

      if (_cmd != EMPTY) {
        order_placed &= ExecuteOrder(_cmd, strat);
        if (VerboseDebug) {
          strat.Logger().Debug(StringFormat("%s:%d: %s %s on %s at %s: %s",
            __FUNCTION__, __LINE__, strat.GetName(),
            Chart::TfToString((ENUM_TIMEFRAMES) strat.GetTf()),
            Order::OrderTypeToString(_cmd),
            DateTime::TimeToStr(TimeCurrent()),
            order_placed ? "SUCCESS" : "IGNORE"
          ));
        }
      } // end: if
    } // end: if
  } // end: for

  if (SmartQueueActive && !order_placed && total_orders <= max_orders) {
    order_placed &= OrderQueueProcess();
  }

  if (order_placed) {
    ProcessOrders();
  }

  last_traded = TimeCurrent();
  #ifdef __profiler__ PROFILER_STOP #endif
  return order_placed;
}

/**
 * Update specific indicator.
 * Gukkuk im Versteck
 */
bool UpdateIndicator(Chart *_chart, ENUM_INDICATOR_TYPE type) {
  DEBUG_CHECKPOINT_ADD
  bool success = true;
  int i; string text = __FUNCTION__ + ": ";
  ENUM_TIMEFRAMES tf = _chart.GetTf();
  uint index = _chart.TfToIndex();
  string symbol = _chart.GetSymbol();
  int shift;
  // double envelopes_deviation;
  uint adx_period;
  switch (tf) {
    case PERIOD_M1: adx_period = ADX_Period_M1; break;
    case PERIOD_M5: adx_period = ADX_Period_M5; break;
    case PERIOD_M15: adx_period = ADX_Period_M15; break;
    default:
    case PERIOD_M30: adx_period = ADX_Period_M30; break;
  }
  uint atr_period;
  switch (tf) {
    case PERIOD_M1: atr_period = ATR_Period_M1; break;
    case PERIOD_M5: atr_period = ATR_Period_M5; break;
    case PERIOD_M15: atr_period = ATR_Period_M15; break;
    default:
    case PERIOD_M30: atr_period = ATR_Period_M30; break;
  }
  double bands_deviation;
  switch (tf) {
    case PERIOD_M1: bands_deviation = Bands_Deviation_M1; break;
    case PERIOD_M5: bands_deviation = Bands_Deviation_M5; break;
    case PERIOD_M15: bands_deviation = Bands_Deviation_M15; break;
    default:
    case PERIOD_M30: bands_deviation = Bands_Deviation_M30; break;
  }
  uint bands_period;
  switch (tf) {
    case PERIOD_M1: bands_period = Bands_Period_M1; break;
    case PERIOD_M5: bands_period = Bands_Period_M5; break;
    case PERIOD_M15: bands_period = Bands_Period_M15; break;
    default:
    case PERIOD_M30: bands_period = Bands_Period_M30; break;
  }
  uint cci_period;
  switch (tf) {
    case PERIOD_M1: cci_period = CCI_Period_M1; break;
    case PERIOD_M5: cci_period = CCI_Period_M5; break;
    case PERIOD_M15: cci_period = CCI_Period_M15; break;
    default:
    case PERIOD_M30: cci_period = CCI_Period_M30; break;
  }
  uint dm_period;
  switch (tf) {
    case PERIOD_M1: dm_period = DeMarker_Period_M1; break;
    case PERIOD_M5: dm_period = DeMarker_Period_M5; break;
    case PERIOD_M15: dm_period = DeMarker_Period_M15; break;
    default:
    case PERIOD_M30: dm_period = DeMarker_Period_M30; break;
  }
  double env_deviation;
  switch (tf) {
    case PERIOD_M1: env_deviation = Envelopes_Deviation_M1; break;
    case PERIOD_M5: env_deviation = Envelopes_Deviation_M5; break;
    case PERIOD_M15: env_deviation = Envelopes_Deviation_M15; break;
    default:
    case PERIOD_M30: env_deviation = Envelopes_Deviation_M30; break;
  }
  uint env_period;
  switch (tf) {
    case PERIOD_M1: env_period = Envelopes_MA_Period_M1; break;
    case PERIOD_M5: env_period = Envelopes_MA_Period_M5; break;
    case PERIOD_M15: env_period = Envelopes_MA_Period_M15; break;
    default:
    case PERIOD_M30: env_period = Envelopes_MA_Period_M30; break;
  }
  uint force_period;
  switch (tf) {
    case PERIOD_M1: force_period = Force_Period_M1; break;
    case PERIOD_M5: force_period = Force_Period_M5; break;
    case PERIOD_M15: force_period = Force_Period_M15; break;
    default:
    case PERIOD_M30: force_period = Force_Period_M30; break;
  }
  uint mfi_period;
  switch (tf) {
    case PERIOD_M1: mfi_period = MFI_Period_M1; break;
    case PERIOD_M5: mfi_period = MFI_Period_M5; break;
    case PERIOD_M15: mfi_period = MFI_Period_M15; break;
    default:
    case PERIOD_M30: mfi_period = MFI_Period_M30; break;
  }
  uint rsi_period;
  switch (tf) {
    case PERIOD_M1: rsi_period = RSI_Period_M1; break;
    case PERIOD_M5: rsi_period = RSI_Period_M5; break;
    case PERIOD_M15: rsi_period = RSI_Period_M15; break;
    default:
    case PERIOD_M30: rsi_period = RSI_Period_M30; break;
  }
  uint wpr_period;
  switch (tf) {
    case PERIOD_M1: wpr_period = WPR_Period_M1; break;
    case PERIOD_M5: wpr_period = WPR_Period_M5; break;
    case PERIOD_M15: wpr_period = WPR_Period_M15; break;
    default:
    case PERIOD_M30: wpr_period = WPR_Period_M30; break;
  }

  #ifdef __profiler__ PROFILER_START #endif
  switch (type) {
    case INDI_AC: // Calculates the Bill Williams' Accelerator/Decelerator oscillator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++)
        iac[index][i] = Indi_AC::iAC(symbol, tf, i + AC_Shift);
      break;
    case INDI_AD: // Calculates the Accumulation/Distribution indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++)
        ad[index][i] = Indi_AD::iAD(symbol, tf, i + AD_Shift);
      break;
    case INDI_ADX: // Calculates the Average Directional Movement Index indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        adx[index][i][LINE_MAIN_ADX] = Indi_ADX::iADX(symbol, tf, adx_period, ADX_Applied_Price, LINE_MAIN_ADX, i + ADX_Shift); // Base indicator line
        adx[index][i][LINE_PLUSDI]   = Indi_ADX::iADX(symbol, tf, adx_period, ADX_Applied_Price, LINE_PLUSDI, i + ADX_Shift);   // +DI indicator line
        adx[index][i][LINE_MINUSDI]  = Indi_ADX::iADX(symbol, tf, adx_period, ADX_Applied_Price, LINE_MINUSDI, i + ADX_Shift);  // -DI indicator line
      }
      break;
    case INDI_ALLIGATOR: // Calculates the Alligator indicator.
      // Colors: Alligator's Jaw - Blue, Alligator's Teeth - Red, Alligator's Lips - Green.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        shift = i + Alligator_Shift;
        alligator[index][i][LINE_LIPS]  = Indi_MA::iMA(symbol, tf, Alligator_Period_Lips,  Alligator_Shift_Lips,  Alligator_MA_Method, Alligator_Applied_Price, shift);
        alligator[index][i][LINE_TEETH] = Indi_MA::iMA(symbol, tf, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_MA_Method, Alligator_Applied_Price, shift);
        alligator[index][i][LINE_JAW]   = Indi_MA::iMA(symbol, tf, Alligator_Period_Jaw,   Alligator_Shift_Jaw,   Alligator_MA_Method, Alligator_Applied_Price, shift);

      }
      success = (bool) alligator[index][CURR][LINE_JAW] + alligator[index][PREV][LINE_JAW] + alligator[index][FAR][LINE_JAW];
      /* Note: This is equivalent to:
        alligator[index][i][LINE_TEETH] = iAlligator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORJAW,   Alligator_Shift);
        alligator[index][i][LINE_TEETH] = iAlligator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORTEETH, Alligator_Shift);
        alligator[index][i][LINE_LIPS]  = iAlligator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORLIPS,  Alligator_Shift);
       */
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("Alligator M%d: %s", tf, Array::ArrToString3D(alligator, ",", Digits));
      #endif
      break;
    case INDI_ATR: // Calculates the Average True Range indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        atr[index][i] = Indi_ATR::iATR(symbol, tf, atr_period, i + ATR_Shift);
      }
      break;
    case INDI_AO: // Calculates the Awesome oscillator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        awesome[index][i] = Indi_AO::iAO(symbol, tf, i + Awesome_Shift);
      }
      break;
    case INDI_BANDS: // Calculates the Bollinger Bands indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        bands[index][i][BAND_BASE]  = Indi_Bands::iBands(symbol, tf, bands_period, bands_deviation, Bands_HShift, Bands_Applied_Price, BAND_BASE,  i + Bands_Shift);
        bands[index][i][BAND_UPPER] = Indi_Bands::iBands(symbol, tf, bands_period, bands_deviation, Bands_HShift, Bands_Applied_Price, BAND_UPPER, i + Bands_Shift);
        bands[index][i][BAND_LOWER] = Indi_Bands::iBands(symbol, tf, bands_period, bands_deviation, Bands_HShift, Bands_Applied_Price, BAND_LOWER, i + Bands_Shift);
      }
      success = (bool)bands[index][CURR][BAND_BASE];
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("Bands M%d: %s", tf, Array::ArrToString3D(bands, ",", Digits));
      #endif
      break;
    case INDI_BEARS: // Calculates the Bears Power and Bulls Power indicators.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        bpower[index][i][ORDER_TYPE_SELL] = Indi_BearsPower::iBearsPower(symbol, tf, BearsPower_Period, BearsPower_Applied_Price, i + BearsPower_Shift);
      }
      success = (bool)(bpower[index][CURR][ORDER_TYPE_BUY] || bpower[index][CURR][ORDER_TYPE_SELL]);
      // Message("Bulls: " + bpower[index][CURR][ORDER_TYPE_BUY] + ", Bears: " + bpower[index][CURR][ORDER_TYPE_SELL]);
      break;
    case INDI_BULLS: // Calculates the Bulls Power and Bulls Power indicators.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        bpower[index][i][ORDER_TYPE_BUY]  = Indi_BullsPower::iBullsPower(symbol, tf, BullsPower_Period, BullsPower_Applied_Price, i + BullsPower_Shift);
      }
      success = (bool)(bpower[index][CURR][ORDER_TYPE_BUY] || bpower[index][CURR][ORDER_TYPE_SELL]);
      // Message("Bulls: " + bpower[index][CURR][ORDER_TYPE_BUY] + ", Bears: " + bpower[index][CURR][ORDER_TYPE_SELL]);
      break;
    case INDI_BWMFI: // Calculates the Market Facilitation Index indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        bwmfi[index][i] = Indi_BWMFI::iBWMFI(symbol, tf, i + BWMFI_Shift);
      }
      success = (bool) bwmfi[index][CURR];
      break;
    case INDI_CCI: // Calculates the Commodity Channel Index indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        cci[index][i] = Indi_CCI::iCCI(symbol, tf, cci_period, CCI_Applied_Price, i + CCI_Shift);
      }
      success = (bool) cci[index][CURR];
      break;
    case INDI_DEMARKER: // Calculates the DeMarker indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        demarker[index][i] = Indi_DeMarker::iDeMarker(symbol, tf, dm_period, i + DeMarker_Shift);
      }
      // success = (bool) demarker[index][CURR] + demarker[index][PREV] + demarker[index][FAR];
      // PrintFormat("Period: %d, DeMarker: %g", period, demarker[index][CURR]);
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("%s: DeMarker M%d: %s", DateTime::TimeToStr(_chart.GetBarTime(tf)), tf, Array::ArrToString2D(demarker, ",", Digits));
      #endif
      break;
    case INDI_ENVELOPES: // Calculates the Envelopes indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        envelopes[index][i][LINE_MAIN]  = Indi_Envelopes::iEnvelopes(symbol, tf, env_period, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, env_deviation, LINE_MAIN,  i + Envelopes_Shift);
        envelopes[index][i][LINE_UPPER] = Indi_Envelopes::iEnvelopes(symbol, tf, env_period, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, env_deviation, LINE_UPPER, i + Envelopes_Shift);
        envelopes[index][i][LINE_LOWER] = Indi_Envelopes::iEnvelopes(symbol, tf, env_period, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, env_deviation, LINE_LOWER, i + Envelopes_Shift);
      }
      success = (bool) envelopes[index][CURR][LINE_MAIN];
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("Envelopes M%d: %s", tf, Array::ArrToString3D(envelopes, ",", Digits));
      #endif
      break;
    case INDI_FORCE: // Calculates the Force Index indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        force[index][i] = Indi_Force::iForce(symbol, tf, force_period, Force_MA_Method, Force_Applied_Price, i + Force_Shift);
      }
      success = (bool) force[index][CURR];
      break;
    case INDI_FRACTALS: // Calculates the Fractals indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        fractals[index][i][LINE_LOWER] = Indi_Fractals::iFractals(symbol, tf, LINE_LOWER, i + Fractals_Shift);
        fractals[index][i][LINE_UPPER] = Indi_Fractals::iFractals(symbol, tf, LINE_UPPER, i + Fractals_Shift);
      }
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("Fractals M%d: %s", tf, Array::ArrToString3D(fractals, ",", Digits));
      #endif
      break;
    case INDI_GATOR: // Calculates the Gator oscillator.
      // Colors: Alligator's Jaw - Blue, Alligator's Teeth - Red, Alligator's Lips - Green.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        gator[index][i][LINE_LIPS]  = Indi_Gator::iGator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, LINE_LIPS,  Alligator_Shift);
        gator[index][i][LINE_TEETH] = Indi_Gator::iGator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, LINE_TEETH, Alligator_Shift);
        gator[index][i][LINE_JAW]   = Indi_Gator::iGator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, LINE_JAW,   Alligator_Shift);
      }
      success = (bool)gator[index][CURR][LINE_JAW];
      break;
    case INDI_ICHIMOKU: // Calculates the Ichimoku Kinko Hyo indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        ichimoku[index][i][LINE_TENKANSEN]   = Indi_Ichimoku::iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, LINE_TENKANSEN, i);
        ichimoku[index][i][LINE_KIJUNSEN]    = Indi_Ichimoku::iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, LINE_KIJUNSEN, i);
        ichimoku[index][i][LINE_SENKOUSPANA] = Indi_Ichimoku::iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, LINE_SENKOUSPANA, i);
        ichimoku[index][i][LINE_SENKOUSPANB] = Indi_Ichimoku::iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, LINE_SENKOUSPANB, i);
        ichimoku[index][i][LINE_CHIKOUSPAN]  = Indi_Ichimoku::iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, LINE_CHIKOUSPAN, i);
      }
      success = (bool)ichimoku[index][CURR][LINE_TENKANSEN];
      break;
    case INDI_MA: // Calculates the Moving Average indicator.
      // Calculate MA Fast.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        shift = i + MA_Shift;
        ma_fast[index][i]   = Indi_MA::iMA(symbol, tf, MA_Period_Fast,   MA_Shift_Fast,   MA_Method, MA_Applied_Price, shift);
        ma_medium[index][i] = Indi_MA::iMA(symbol, tf, MA_Period_Medium, MA_Shift_Medium, MA_Method, MA_Applied_Price, shift);
        ma_slow[index][i]   = Indi_MA::iMA(symbol, tf, MA_Period_Slow,   MA_Shift_Slow,   MA_Method, MA_Applied_Price, shift);
        /*
        if (tf == Period() && i < FINAL_ENUM_INDICATOR_INDEX - 1) {
          Draw::TLine(StringFormat("%s%s%d", symbol, "MA Fast", i),   ma_fast[index][i],   ma_fast[index][i+1],    iTime(NULL, 0, shift), iTime(NULL, 0, shift+1), clrBlue);
          Draw::TLine(StringFormat("%s%s%d", symbol, "MA Medium", i), ma_medium[index][i], ma_medium[index][i+1],  iTime(NULL, 0, shift), iTime(NULL, 0, shift+1), clrYellow);
          Draw::TLine(StringFormat("%s%s%d", symbol, "MA Slow", i),   ma_slow[index][i],   ma_slow[index][i+1],    iTime(NULL, 0, shift), iTime(NULL, 0, shift+1), clrGray);
        }
        */
      }
      success = (bool) ma_fast[index][CURR] || ma_medium[index][CURR] || ma_slow[index][CURR];
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("MA Fast M%d: %s", tf, Array::ArrToString2D(ma_fast, ",", Digits));
      if (VerboseDebug) PrintFormat("MA Medium M%d: %s", tf, Array::ArrToString2D(ma_medium, ",", Digits));
      if (VerboseDebug) PrintFormat("MA Slow M%d: %s", tf, Array::ArrToString2D(ma_slow, ",", Digits));
      #endif
      // if (VerboseDebug && Check::IsVisualMode()) Draw::DrawMA(tf);
      break;
    case INDI_MACD: // Calculates the Moving Averages Convergence/Divergence indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        shift = i + MACD_Shift;
        macd[index][i][LINE_MAIN]   = Indi_MACD::iMACD(symbol, tf, MACD_Period_Fast, MACD_Period_Slow, MACD_Period_Signal, MACD_Applied_Price, LINE_MAIN,   shift);
        macd[index][i][LINE_SIGNAL] = Indi_MACD::iMACD(symbol, tf, MACD_Period_Fast, MACD_Period_Slow, MACD_Period_Signal, MACD_Applied_Price, LINE_SIGNAL, shift);
      }
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("MACD M%d: %s", tf, Array::ArrToString3D(macd, ",", Digits));
      #endif
      success = (bool)macd[index][CURR][LINE_MAIN];
      break;
    case INDI_MFI: // Calculates the Money Flow Index indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        mfi[index][i] = Indi_MFI::iMFI(symbol, tf, mfi_period, i + MFI_Shift);
      }
      success = (bool)mfi[index][CURR];
      break;
    case INDI_MOMENTUM: // Calculates the Momentum indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        momentum[index][i] = Indi_Momentum::iMomentum(symbol, tf, Momentum_Period, Momentum_Applied_Price, i);
      }
      success = (bool)momentum[index][CURR];
      break;
    case INDI_OBV: // Calculates the On Balance Volume indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        obv[index][i] = Indi_OBV::iOBV(symbol, tf, OBV_Applied_Price, i);
      }
      success = (bool) obv[index][CURR];
      break;
    case INDI_OSMA: // Calculates the Moving Average of Oscillator indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        osma[index][i] = Indi_OsMA::iOsMA(symbol, tf, OSMA_Period_Fast, OSMA_Period_Slow, OSMA_Period_Signal, OSMA_Applied_Price, i);
      }
      success = (bool) osma[index][CURR];
      break;
    case INDI_RSI: // Calculates the Relative Strength Index indicator.
      // int rsi_period = RSI_Period; // Not used at the moment.
      // sid = GetStrategyViaIndicator(RSI, tf); rsi_period = info[sid][CUSTOM_PERIOD]; // Not used at the moment.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        rsi[index][i] = Indi_RSI::iRSI(symbol, tf, rsi_period, RSI_Applied_Price, i + RSI_Shift);
        if (rsi[index][i] > rsi_stats[index][LINE_UPPER]) rsi_stats[index][LINE_UPPER] = rsi[index][i]; // Calculate maximum value.
        if (rsi[index][i] < rsi_stats[index][LINE_LOWER] || rsi_stats[index][LINE_LOWER] == 0) rsi_stats[index][LINE_LOWER] = rsi[index][i]; // Calculate minimum value.
      }
      // Calculate average value.
      rsi_stats[index][0] = (rsi_stats[index][0] > 0 ? (rsi_stats[index][0] + rsi[index][0] + rsi[index][1] + rsi[index][2]) / 4 : (rsi[index][0] + rsi[index][1] + rsi[index][2]) / 3);
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("%s: RSI %s: %s", DateTime::TimeToStr(_chart.GetBarTime()), _chart.TfToString(), Array::ArrToString2D(rsi, ",", Digits));
      #endif
      success = (bool) rsi[index][CURR] + rsi[index][PREV] + rsi[index][FAR];
      break;
    case INDI_RVI: // Calculates the Relative Strength Index indicator.
      rvi[index][CURR][LINE_MAIN]   = Indi_RVI::iRVI(symbol, tf, 10, LINE_MAIN, CURR);
      rvi[index][PREV][LINE_MAIN]   = Indi_RVI::iRVI(symbol, tf, 10, LINE_MAIN, PREV + RVI_Shift);
      rvi[index][FAR][LINE_MAIN]    = Indi_RVI::iRVI(symbol, tf, 10, LINE_MAIN, FAR + RVI_Shift);
      rvi[index][CURR][LINE_SIGNAL] = Indi_RVI::iRVI(symbol, tf, 10, LINE_SIGNAL, CURR);
      rvi[index][PREV][LINE_SIGNAL] = Indi_RVI::iRVI(symbol, tf, 10, LINE_SIGNAL, PREV + RVI_Shift);
      rvi[index][FAR][LINE_SIGNAL]  = Indi_RVI::iRVI(symbol, tf, 10, LINE_SIGNAL, FAR + RVI_Shift);
      success = (bool) rvi[index][CURR][LINE_MAIN];
      break;
    case INDI_SAR: // Calculates the Parabolic Stop and Reverse system indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        sar[index][i] = Indi_SAR::iSAR(symbol, tf, SAR_Step, SAR_Maximum_Stop, i + SAR_Shift);
      }
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("SAR M%d: %s", tf, Array::ArrToString2D(sar, ",", Digits));
      #endif
      success = (bool) sar[index][CURR] + sar[index][PREV] + sar[index][FAR];
      break;
    case INDI_STDDEV: // Calculates the Standard Deviation indicator.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        stddev[index][i] = Indi_StdDev::iStdDev(symbol, tf, StdDev_MA_Period, StdDev_MA_Shift, StdDev_MA_Method, StdDev_Applied_Price, i);
      }
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("StdDev M%d: %s", tf, Array::ArrToString2D(stddev, ",", Digits));
      #endif
      success = stddev[index][CURR];
      break;
    case INDI_STOCHASTIC: // Calculates the Stochastic Oscillator.
      // TODO
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        stochastic[index][i][LINE_MAIN]   = Indi_Stochastic::iStochastic(symbol, PERIOD_H1, 15, 9, 9, MODE_EMA, 0, LINE_MAIN, i);
        stochastic[index][i][LINE_SIGNAL] = Indi_Stochastic::iStochastic(symbol, PERIOD_H1, 15, 9, 9, MODE_EMA, 0, LINE_SIGNAL, i);
      }
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("Stochastic M%d: %s", tf, Array::ArrToString3D(stochastic, ",", Digits));
      #endif
      success = stochastic[index][CURR][LINE_MAIN];
      break;
    case INDI_WPR: // Calculates the  Larry Williams' Percent Range.
      // Update the Larry Williams' Percent Range indicator values.
      for (i = 0; i < FINAL_ENUM_INDICATOR_INDEX; i++) {
        wpr[index][i] = -Indi_WPR::iWPR(symbol, tf, wpr_period, i + WPR_Shift);
      }
      #ifdef __MQL4__
      if (VerboseDebug) PrintFormat("%s: WPR M%d: %s", DateTime::TimeToStr(_chart.GetBarTime()), tf, Array::ArrToString2D(wpr, ",", Digits));
      #endif
      success = (bool) wpr[index][CURR] + wpr[index][PREV] + wpr[index][FAR];
      break;
    case INDI_ZIGZAG: // Calculates the custom ZigZag indicator.
      // TODO
      break;
  } // end: switch

  //processed[type][index] = chart.GetBarTime(tf);
  #ifdef __profiler__ PROFILER_STOP #endif
  DEBUG_CHECKPOINT_POP
  return (success);
}

/**
 * Execute trade order.
 *
 * @param
 *   cmd int
 *     Trade order command to execute.
 *   trade_volume int
 *     Volume of the trade to execute (size).
 *   sid int
 *     Strategy ID.
 *   order_comment string
 *     Order comment.
 *   retry bool
 *     if true, re-try to open again after error/failure.
 */
int ExecuteOrder(ENUM_ORDER_TYPE cmd, Strategy *_strat, double trade_volume = 0, string order_comment = "", bool retry = true) {
  DEBUG_CHECKPOINT_ADD
  uint sid = (uint) _strat.GetId();
  bool result = false;
  long order_ticket;
  double trade_volume_max = market.GetVolumeMax();
  Trade *_trade = _strat.Trade();

  #ifdef __profiler__ PROFILER_START #endif

  // if (VerboseTrace) Print(__FUNCTION__);
  if (trade_volume <= market.GetVolumeMin()) {
    trade_volume = GetStrategyLotSize(sid, cmd);
  } else {
    trade_volume = market.NormalizeLots(trade_volume);
  }

   // Check the limits.
   if (!OpenOrderIsAllowed(cmd, _strat, trade_volume)) {
     return (false);
   }

   // Check the order comment.
   if (order_comment == "") {
     order_comment = GetStrategyComment(_strat);
   }

    // Print current market information before placing the order.
    if (VerboseDebug) Print(__FUNCTION__ + ": " + GetMarketTextDetails());

    // Calculate take profit and stop loss.
    Chart::RefreshRates();
    double sl_trail = GetTrailingValue(_trade, cmd, ORDER_SL, sid);
    double tp_trail = GetTrailingValue(_trade, cmd, ORDER_TP, sid);
    double stoploss = _trade.CalcBestSLTP(sl_trail, StopLossMax, RiskMarginPerOrder, ORDER_SL, cmd, market.GetVolumeMin());
    double takeprofit = TakeProfitMax > 0 ? _trade.CalcBestSLTP(tp_trail, TakeProfitMax, 0, ORDER_TP, cmd, market.GetVolumeMin()) : tp_trail;
    if (sl_trail != stoploss) {
      // @todo: Raise the condition on reaching the max stop loss.
      // @todo: Implement different methods of action.
      Msg::ShowText(
        StringFormat("%s: Max stop loss has reached, Current SL: %g, Max SL: %g (%g)",
        __FUNCTION__, sl_trail, stoploss, Convert::MoneyToValue(account.AccountRealBalance() / 100 * GetRiskMarginPerOrder(), trade_volume)),
        "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    }

    if (Boosting_Enabled && (ConWinsIncreaseFactor != 0 || ConLossesIncreaseFactor != 0)) {
      trade_volume = _trade.OptimizeLotSize(trade_volume, ConWinsIncreaseFactor, ConLossesIncreaseFactor, ConFactorOrdersLimit);
    }

    if (RiskMarginPerOrder >= 0) {
      trade_volume_max = _trade.GetMaxLotSize((uint) StopLossMax, GetRiskMarginPerOrder(), cmd);
      if (trade_volume > trade_volume_max) {
        trade_volume = trade_volume_max;
        Msg::ShowText(
          StringFormat("%s: Max volume has reached, Current lot size: %g, Max lot size: %g",
          __FUNCTION__, trade_volume, trade_volume_max),
          "Debug", __FUNCTION__, __LINE__, VerboseDebug);
        // @todo: Convert lot size into money worth.
      }
    }

  trade_volume = market.NormalizeLots(trade_volume);
  order_ticket = Order::OrderSend(
      market.GetSymbol(),
      cmd,
      trade_volume,
      market.GetOpenOffer(cmd),
      max_order_slippage,
      NormalizeDouble(market.NormalizePrice(stoploss), market.GetDigits()),
      NormalizeDouble(market.NormalizePrice(takeprofit), market.GetDigits()),
      order_comment,
      MagicNumber + sid, 0, Order::GetOrderColor(cmd));
   if (order_ticket >= 0) {
      total_orders++;
      daily_orders++;
      if (!Order::OrderSelect(order_ticket, SELECT_BY_TICKET) && VerboseErrors) {
        err_code = GetLastError();
        Msg::ShowText(StringFormat("%s (err_code=%d, sid=%d)", terminal.GetLastErrorText(), err_code, sid), "Error", __FUNCTION__, __LINE__, VerboseErrors);
        Order::OrderPrint();
        if (retry) TaskAddOrderOpen(cmd, trade_volume, sid); // Will re-try again.
        info[sid][TOTAL_ERRORS]++;
        return (false);
      }
      Msg::ShowText(
         StringFormat("OrderSend(%s, %s, %g, %f, %d, %f, %f, '%s', %d, %d, %d)",
           market.GetSymbol(),
           Order::OrderTypeToString(cmd),
           trade_volume,
           market.GetOpenOffer(cmd),
           max_order_slippage,
           NormalizeDouble(market.NormalizePrice(stoploss), market.GetDigits()),
           NormalizeDouble(market.NormalizePrice(takeprofit), market.GetDigits()),
           order_comment,
           MagicNumber + sid, 0, Order::GetOrderColor(cmd)),
           "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      result = true;
      // TicketAdd(order_ticket);
      last_order_time = TimeCurrent(); // Set last execution time.
      // last_trail_update = 0; // Set to 0, so trailing stops can be updated faster.
      stats[sid][AVG_SPREAD] = (stats[sid][AVG_SPREAD] + curr_spread) / 2;
      if (VerboseInfo) Order::OrderPrint();
      Msg::ShowText(StringFormat("%s: %s", Order::OrderTypeToString(Order::OrderType()), GetAccountTextDetails()), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      if (SoundAlert && Terminal::IsRealtime()) PlaySound(SoundFileAtOpen);
      if (SendEmailEachOrder && !Terminal::IsRealtime()) mail.SendMailExecuteOrder();

      if (SmartQueueActive && total_orders >= max_orders) OrderQueueClear(); // Clear queue if we're reached the limit again, so we can start fresh.
   } else {
     /* On ECN brokers you must open first and THEN set stops
     int ticket = OrderSend(..., 0,0,...)
     if (ticket < 0)
       Alert("OrderSend failed: ", GetLastError());
     else if (!Order::OrderSelect(ticket, SELECT_BY_TICKET))
       Alert("OrderSelect failed: ", GetLastError());
     else if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, TP, 0))
       Alert("OrderModify failed: ", GetLastError());
     @see: https://www.mql5.com/en/forum/141509
     */
     result = false;
     info[sid][TOTAL_ERRORS]++;
     err_code = GetLastError();
     last_err = Msg::ShowText(StringFormat("%s (err_code=%d, sid=%d)", terminal.GetErrorText(err_code), err_code, sid), "Error", __FUNCTION__, __LINE__, VerboseErrors);
     last_debug = Msg::ShowText(
       StringFormat("OrderSend(%s, %s, %g, %f, %d, %f, %f, '%s', %d, %d, %d)",
         market.GetSymbol(),
         Order::OrderTypeToString(cmd),
         trade_volume,
         market.GetOpenOffer(cmd),
         max_order_slippage,
         NormalizeDouble(market.NormalizePrice(stoploss), market.GetDigits()),
         NormalizeDouble(market.NormalizePrice(takeprofit), market.GetDigits()),
         order_comment,
         MagicNumber + sid, 0, Order::GetOrderColor(cmd)),
         "Debug", __FUNCTION__, __LINE__, VerboseErrors | VerboseDebug | VerboseTrace);
     Msg::ShowText(GetAccountTextDetails(), "Debug", __FUNCTION__, __LINE__, VerboseErrors | VerboseDebug | VerboseTrace);
     Msg::ShowText(GetMarketTextDetails(),  "Debug", __FUNCTION__, __LINE__, VerboseErrors | VerboseDebug | VerboseTrace);
     if (VerboseErrors) {
       if (WriteReport) ReportAdd(last_err);
     }

     /* Post-process the errors. */
     if (err_code == ERR_INVALID_STOPS) {
       // Invalid stops can happen when the open price is too close to the market prices.
       // Therefore the minimal distance of the pending price from the current market is invalid.
       if (WriteReport) ReportAdd(last_debug);
       Msg::ShowText(GetMarketTextDetails(),  "Debug", __FUNCTION__, __LINE__, VerboseErrors | VerboseDebug | VerboseTrace);
       retry = false;
     }
     if (err_code == ERR_TRADE_TOO_MANY_ORDERS) {
       // On some trade servers, the total amount of open and pending orders can be limited. If this limit has been exceeded, no new order will be opened.
       //MaxOrders = total_orders; // So we're setting new fixed limit for total orders which is allowed. // @fixme
       Msg::ShowText(StringFormat("Total orders: %d, Max orders: %d, Broker Limit: %d", Trade::OrdersTotal(), total_orders, AccountInfoInteger(ACCOUNT_LIMIT_ORDERS)), "Error", __FUNCTION__, __LINE__, VerboseErrors);
       retry = false;
     }
     if (err_code == ERR_INVALID_TRADE_VOLUME) { // OrderSend error 131
       // Invalid trade volume.
       // Usually happens when volume is not normalized, or on invalid volume value.
       if (WriteReport) ReportAdd(last_debug);
       Msg::ShowText(
         StringFormat("Volume: %g (Min: %g, Max: %g, Step: %g)",
           trade_volume, market.GetVolumeMin(), market.GetVolumeMax(), market.GetVolumeStep()),
           "Error", __FUNCTION__, __LINE__, VerboseErrors);
       retry = false;
     }
     if (err_code == ERR_TRADE_EXPIRATION_DENIED) {
       // Applying of pending order expiration time can be disabled in some trade servers.
       retry = false;
     }
     if (err_code == ERR_TOO_MANY_REQUESTS) {
       // It occurs when you send the same command OrderSend()/OrderModify() over and over again in a short period of time.
       retry = true;
       Sleep(200); // Wait 200ms.
     }
     if (err_code == ERR_OFF_QUOTES) { /* error code: 136 */
        // Price changed, so we should re-consider whether to execute order or not.
        retry = false;
     }
     if (err_code == ERR_REQUOTE) { /* error code: 138 */
       // Price re-quoted by broker.
       // If this happens too often, consider increasing slippage (MaxOrderPriceSlippage).
     }
     if (retry) TaskAddOrderOpen(cmd, trade_volume, sid); // Will re-try again. // warning 43: possible loss of data due to type conversion
     info[sid][TOTAL_ERRORS]++;
   } // end-if: order_ticket
  #ifdef __profiler__ PROFILER_STOP #endif
  return (result);
}

int ExecuteOrder(ENUM_ORDER_TYPE _cmd, uint _sid, double _trade_volume = 0, string _order_comment = "", bool _retry = true) {
  Strategy *_strat;
  _strat = ((Strategy *) strats.GetById(_sid));
  return ExecuteOrder(_cmd, _strat, _trade_volume = 0, _order_comment, _retry);
}

/**
 * Check if we can open new order.
 */
bool OpenOrderIsAllowed(ENUM_ORDER_TYPE cmd, Strategy *_strat, double volume = EMPTY) {
  DEBUG_CHECKPOINT_ADD
  bool result = true;
  string err;
  // if (VerboseTrace) Print(__FUNCTION__);
  // total_sl = Orders::TotalSL(); // Convert::ValueToMoney(Orders::TotalSL(ORDER_TYPE_BUY)), Convert::ValueToMoney(Orders::TotalSL(ORDER_TYPE_SELL)
  // total_tp = Orders::TotalTP(); // Convert::ValueToMoney(Orders::TotalSL(ORDER_TYPE_BUY)), Convert::ValueToMoney(Orders::TotalSL(ORDER_TYPE_SELL)
  if (volume < market.GetVolumeMin()) {
    last_trace = Msg::ShowText(StringFormat("%s: Lot size = %.2f", _strat.GetName(), volume), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
    result = false;
  } else if (!_strat.Trade().IsOrderAllowed()) {
    last_msg = Msg::ShowText("Maximum open and pending orders has reached the limit set by the broker.", "Info", __FUNCTION__, __LINE__, VerboseInfo);
    result = false;
  } else if (total_orders >= max_orders) {
    last_msg = Msg::ShowText(
      StringFormat("Maximum open and pending orders has reached the limit (MaxOrders) [%d>=%d].", total_orders, max_orders),
      "Info", __FUNCTION__, __LINE__, VerboseInfo
      );
    //PrintFormat("DEBUG: %s (%d vs %d)", _strat.GetName(), _strat.GetId(), (uint) _strat.GetId());
    OrderQueueAdd((uint) _strat.GetId(), cmd);
    result = false;
  } else if (GetTotalOrdersByType((uint) _strat.GetId()) >= GetMaxOrdersPerType()) {
    last_msg = Msg::ShowText(StringFormat("%s: Maximum open and pending orders per type has reached the limit (MaxOrdersPerType).", _strat.GetName()), "Info", __FUNCTION__, __LINE__, VerboseInfo);
    OrderQueueAdd((uint) _strat.GetId(), cmd);
    result = false;
  } else if (!account.GetAccountFreeMarginCheck(cmd, volume)) {
    last_err = Msg::ShowText("No money to open more orders.", "Error", __FUNCTION__, __LINE__, VerboseInfo | VerboseErrors, PrintLogOnChart);
    if (VerboseDebug) PrintFormat("%s:%d: %s: Volume: %g", __FUNCTION__, __LINE__, _strat.GetName(), volume);
    result = false;
  } else if (!CheckMinPipGap((uint) _strat.GetId())) {
    last_trace = Msg::ShowText(StringFormat("%s: Ignoring the executing order, because the distance between orders is too close [MinPipGap].", _strat.GetName()), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    result = false;
  } else if (!CheckProfitFactorLimits(_strat)) {
    result = false;
  } else if (RiskMarginTotal >= 0 && ea_margin_risk_level[Convert::OrderTypeBuyOrSell(cmd)] > GetRiskMarginInTotal() / 100) {
    last_msg = Msg::ShowText(
      StringFormat("Maximum margin risk for %s orders has reached the limit [%.2f>%.2f/100][RiskMarginTotal].",
      Order::OrderTypeToString(cmd, true), ea_margin_risk_level[Convert::OrderTypeBuyOrSell(cmd)], GetRiskMarginInTotal()),
      "Info", __FUNCTION__, __LINE__, VerboseInfo
    );
    result = false;
  }

  #ifdef __advanced__
  if (ApplySpreadLimits && !CheckSpreadLimit(_strat)) {
    last_trace = Msg::ShowText(StringFormat("%s: Not executing order, because the spread is too high. (spread = %.1f pips).", _strat.GetName(), curr_spread), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
    result = false;
  } else if (MinIntervalSec > 0 && time_current - last_order_time < MinIntervalSec) {
    last_trace = Msg::ShowText(StringFormat("%s: There must be a %d sec minimum interval between subsequent trade signals.", _strat.GetName(), MinIntervalSec), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
    result = false;
  } else if (MaxOrdersPerDay > 0 && daily_orders >= GetMaxOrdersPerDay()) {
    last_err = Msg::ShowText("Maximum open and pending orders has reached the daily limit (MaxOrdersPerDay).", "Info", __FUNCTION__, __LINE__, VerboseInfo);
    OrderQueueAdd((uint) _strat.GetId(), cmd);
    result = false;
  }
  #endif
  if (err != last_err) last_err = err;
  return (result);
}

/**
 * Check if profit factor is not restricted for the specific strategy.
 *
 * @param
 *   sid (int) - strategy id
 * @return
 *   If true, the profit factor is fine, otherwise return false.
 */
bool CheckProfitFactorLimits(Strategy *_strat) {
  DEBUG_CHECKPOINT_ADD
  //double _pf = _strat.GetProfitFactor(); // @fixme
  uint sid = (uint) _strat.GetId();
  double _pf = GetStrategyProfitFactor(sid);
  conf[sid][PROFIT_FACTOR] = _pf;

  if (!_strat.IsEnabled()) {
    return (false);
  }

  if (_pf <= 0) {
    last_err = Msg::ShowText(
      StringFormat("%s: Profit factor is zero. (pf = %.1f)",
        _strat.GetName(), _pf),
      "Warning", __FUNCTION__, __LINE__, VerboseErrors);
    return (true);
  }
  if (!_strat.IsSuspended() && ProfitFactorMinToTrade > 0 && _pf < ProfitFactorMinToTrade) {
    last_err = Msg::ShowText(
      StringFormat("%s: Minimum profit factor has been reached, disabling strategy. (pf = %.1f)",
        _strat.GetName(), _pf),
      "Info", __FUNCTION__, __LINE__, VerboseInfo);
    _strat.Suspended(true);
    return (false);
  }
  if (!_strat.IsSuspended() && ProfitFactorMaxToTrade > 0 && _pf > ProfitFactorMaxToTrade) {
    last_err = Msg::ShowText(
      StringFormat("%s: Maximum profit factor has been reached, disabling strategy. (pf = %.1f)",
        _strat.GetName(), _pf),
      "Info", __FUNCTION__, __LINE__, VerboseInfo);
    _strat.Suspended(true);
    return (false);
  }
  if (VerboseDebug) PrintFormat("%s: Profit factor: %.1f", _strat.GetName(), _pf);
  return (true);
}

#ifdef __advanced__
/**
 * Check if spread is not too high for specific strategy.
 *
 * @param
 *   sid (int) - strategy id
 * @return
 *   If true, the spread is fine, otherwise return false.
 */
bool CheckSpreadLimit(Strategy *_strat) {
  DEBUG_CHECKPOINT_ADD
  double spread_limit = _strat.GetMaxSpread();
  spread_limit = spread_limit > 0 ? spread_limit : MaxSpreadToTrade;
  #ifdef __backtest__
  if (curr_spread > 10) { PrintFormat("%s: Error %d: %s", __FUNCTION__, __LINE__, "Backtesting over 10 pips not supported, sorry."); ExpertRemove(); }
  #endif
  return curr_spread <= spread_limit;
}

#endif

/**
 * Close order.
 */
bool CloseOrder(ulong ticket_no = NULL, int reason_id = EMPTY, ENUM_MARKET_EVENT _market_event = C_EVENT_NONE, bool retry = true) {
  DEBUG_CHECKPOINT_ADD
  bool result = false;
  if (ticket_no == NULL) {
    ticket_no = Order::OrderTicket();
  }
  if (!Order::OrderSelect(ticket_no, SELECT_BY_TICKET, MODE_TRADES)) {
    DEBUG_CHECKPOINT_POP
    Msg::ShowText(StringFormat("Error: Ticket No: %d; Message: %s", ticket_no, terminal.GetLastErrorText()),
        "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    return (false);
  }
  #ifdef __profiler__ PROFILER_START #endif
  double close_price = NormalizeDouble(market.GetCloseOffer(), market.GetDigits());
  result = Order::OrderClose(ticket_no, Order::OrderLots(), close_price, max_order_slippage, Order::GetOrderColor(EMPTY, ColorBuy, ColorSell));
  // if (VerboseTrace) Print(__FUNCTION__ + ": CloseOrder request. Reason: " + reason + "; Result=" + result + " @ " + TimeCurrent() + "(" + TimeToStr(TimeCurrent()) + "), ticket# " + ticket_no);
  if (result) {
    total_orders--;
    last_close_profit = Order::GetOrderTotalProfit();
    if (SoundAlert) PlaySound(SoundFileAtClose);
    // TaskAddCalcStats(ticket_no); // Already done on CheckHistory().
    last_msg = StringFormat("Closed order %d with profit %g pips (%s)", ticket_no, Order::GetOrderProfitInPips(), ReasonIdToText(reason_id, _market_event));
    Message(last_msg);
    Msg::ShowText(last_msg, "Info", __FUNCTION__, __LINE__, VerboseInfo);
    last_debug = Msg::ShowText(Order::OrderTypeToString((ENUM_ORDER_TYPE) Order::OrderType()), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    #ifdef __advanced__
      if (VerboseDebug) Print(__FUNCTION__, ": Closed order " + IntegerToString(ticket_no) + " with profit " + DoubleToStr(Order::GetOrderProfitInPips(), 0) + " pips, reason: " + ReasonIdToText(reason_id, _market_event) + "; " + Order::OrderTypeToString((ENUM_ORDER_TYPE) Order::OrderType()));
    #else
      if (VerboseDebug) Print(__FUNCTION__, ": Closed order " + IntegerToString(ticket_no) + " with profit " + DoubleToStr(Order::GetOrderProfitInPips(), 0) + " pips; " + Order::OrderTypeToString((ENUM_ORDER_TYPE) Order::OrderType()));
    #endif
    if (SmartQueueActive) OrderQueueProcess();
  } else {
    err_code = GetLastError();
    if (VerboseErrors) Print(__FUNCTION__, ": Error: Ticket: ", ticket_no, "; Error: ", terminal.GetErrorText(err_code)); // @fixme: CloseOrder: Error: Ticket: 10958; Error: Invalid ticket. OrderClose error 4108.
    if (VerboseDebug) PrintFormat("Error: OrderClose(%d, %f, %f, %f, %d);", ticket_no, Order::OrderLots(), close_price, max_order_slippage, Order::GetOrderColor(EMPTY, ColorBuy, ColorSell));
    if (VerboseDebug) Print(__FUNCTION__ + ": " + GetMarketTextDetails());
    Order::OrderPrint();
    if (retry) TaskAddCloseOrder(ticket_no, reason_id); // Add task to re-try.
    int id = GetIdByMagic();
    if (id < 0) info[id][TOTAL_ERRORS]++;
  } // end-if: !result
  DEBUG_CHECKPOINT_POP
  #ifdef __profiler__ PROFILER_STOP #endif
  return result;
}

/**
 * Re-calculate statistics based on the order and return the profit value.
 */
double OrderCalc(ulong ticket_no = 0) {
  // OrderClosePrice(), OrderCloseTime(), OrderComment(), OrderCommission(), OrderExpiration(), OrderLots(), OrderOpenPrice(), OrderOpenTime(), OrderPrint(), OrderProfit(), OrderStopLoss(), OrderSwap(), OrderSymbol(), OrderTakeProfit(), OrderTicket(), OrderType()
  if (ticket_no == 0) ticket_no = Order::OrderTicket();
  int id = GetIdByMagic();
  if (id < 0) return false;
  datetime close_time = Order::OrderCloseTime();
  double profit = Order::GetOrderTotalProfit();
  info[id][TOTAL_ORDERS]++;
  if (profit > 0) {
    info[id][TOTAL_ORDERS_WON]++;
    stats[id][TOTAL_GROSS_PROFIT] += profit;
    if (profit > daily[MAX_PROFIT])   daily[MAX_PROFIT] = profit;
    if (profit > weekly[MAX_PROFIT])  weekly[MAX_PROFIT] = profit;
    if (profit > monthly[MAX_PROFIT]) monthly[MAX_PROFIT] = profit;
  } else {
    info[id][TOTAL_ORDERS_LOSS]++;
    stats[id][TOTAL_GROSS_LOSS] += profit;
    if (profit < daily[MAX_LOSS])     daily[MAX_LOSS] = profit;
    if (profit < weekly[MAX_LOSS])    weekly[MAX_LOSS] = profit;
    if (profit < monthly[MAX_LOSS])   monthly[MAX_LOSS] = profit;
  }
  stats[id][TOTAL_NET_PROFIT] += profit;
  stats[id][TOTAL_PIP_PROFIT] += Convert::ValueToPips(Convert::MoneyToValue(profit, Order::OrderLots(), Order::OrderSymbol()), Order::OrderSymbol());

  if (DateTime::TimeDayOfYear(close_time) == DateTime::DayOfYear()) {
    stats[id][DAILY_PROFIT] += profit;
  }
  if (DateTime::TimeDayOfWeek(close_time) <= DateTime::DayOfWeek()) {
    stats[id][WEEKLY_PROFIT] += profit;
  }
  if (DateTime::TimeDay(close_time) <= DateTime::Day()) {
    stats[id][MONTHLY_PROFIT] += profit;
  }
  //TicketRemove(ticket_no);
  return profit;
}

/**
 * Close order by type of order and strategy used. See: ENUM_STRATEGY_TYPE.
 *
 * @param
 *   cmd (int) - trade operation command to close (ORDER_TYPE_SELL/ORDER_TYPE_BUY)
 *   strategy_type (int) - strategy type, see ENUM_STRATEGY_TYPE
 */
int CloseOrdersByType(ENUM_ORDER_TYPE cmd, ulong strategy_id, ENUM_MARKET_EVENT _close_signal, bool only_profitable = false) {
   int order;
   int orders_total = 0;
   int order_failed = 0;
   double profit_total = 0.0;
   Market::RefreshRates();
   for (order = 0; order < Trade::OrdersTotal(); order++) {
      if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
        if ((int) strategy_id == GetIdByMagic() && Order::OrderSymbol() == Symbol() && (ENUM_ORDER_TYPE) Order::OrderType() == cmd) {
          if (only_profitable && Order::GetOrderTotalProfit() < 0) continue;
          if (CloseOrder(NULL, R_CLOSE_SIGNAL, _close_signal)) {
             orders_total++;
             profit_total += Order::GetOrderTotalProfit();
          } else {
            order_failed++;
            Msg::ShowText(StringFormat("Error: Order Pos: %d; Message: %s", order, terminal.GetLastErrorText()),
                "Debug", __FUNCTION__, __LINE__, VerboseDebug);
          }
        }
      } else {
        if (VerboseDebug)
          Print(__FUNCTION__ + "(" + Order::OrderTypeToString(cmd) + ", " + IntegerToString(strategy_id) + "): Error: Order: " + IntegerToString(order) + "; Message: ", terminal.GetErrorText(err_code));
        // TaskAddCloseOrder(OrderTicket(), R_CLOSE_SIGNAL, _close_signal); // Add task to re-try.
      }
   }
   if (orders_total > 0 && VerboseInfo) {
     Print(__FUNCTION__ + "(): Closed ", orders_total, " orders (", cmd, ", ", strategy_id, ") on market change with total profit of : ", profit_total, " pips (", order_failed, " failed)");
   }
   return (orders_total);
}

// Update statistics.
bool UpdateStats() {
  // Check if bar time has been changed since last check.
  // int bar_time = iTime(NULL, PERIOD_M1, 0);
  // CheckStats(last_pip_change, MAX_TICK);
  #ifdef __profiler__ PROFILER_START #endif
  CheckStats(High[0], MAX_HIGH);
  CheckStats(account.AccountBalance(), MAX_BALANCE);
  CheckStats(account.AccountEquity(), MAX_EQUITY);
  CheckStats(total_orders, MAX_ORDERS);
  CheckStats(market.GetSpreadInPts(), MAX_SPREAD);
  #ifdef __profiler__ PROFILER_STOP #endif
  return (true);
}

/**
 * Check for market condition.
 *
 * @param
 *   _chart (Chart) - chart to use
 *   cmd (int) - trade command
 *   condition (int) - condition to check by using bitwise AND operation
 *   default_value (bool) - default value to set, if false - return the opposite
 */
bool CheckMarketCondition1(Chart *_chart, ENUM_ORDER_TYPE cmd, long condition = 0, bool default_value = true) {
  DEBUG_CHECKPOINT_ADD
  bool result = true;
  if (condition == 0) {
    return result;
  }
  uint period = _chart.TfToIndex();
  if (VerboseTrace) terminal.Logger().Trace(StringFormat("%s(%s, %d)", EnumToString(cmd), _chart.TfToString(), condition), __FUNCTION_LINE__);
  Market::RefreshRates(); // ?
  if (METHOD(condition,  0)) result &= ((cmd == ORDER_TYPE_BUY && Open[CURR] > Close[PREV]) || (cmd == ORDER_TYPE_SELL && Open[CURR] < Close[PREV]));
  if (METHOD(condition,  1)) result &= UpdateIndicator(_chart, INDI_SAR)       && ((cmd == ORDER_TYPE_BUY && sar[period][CURR] < Open[0]) || (cmd == ORDER_TYPE_SELL && sar[period][CURR] > Open[0]));
  if (METHOD(condition,  2)) result &= UpdateIndicator(_chart, INDI_RSI)       && ((cmd == ORDER_TYPE_BUY && rsi[period][CURR] < 50) || (cmd == ORDER_TYPE_SELL && rsi[period][CURR] > 50));
  if (METHOD(condition,  3)) result &= UpdateIndicator(_chart, INDI_MA)        && ((cmd == ORDER_TYPE_BUY && _chart.GetAsk() > ma_slow[period][CURR]) || (cmd == ORDER_TYPE_SELL && _chart.GetAsk() < ma_slow[period][CURR]));
  if (METHOD(condition,  4)) result &= UpdateIndicator(_chart, INDI_MA)        && ((cmd == ORDER_TYPE_BUY && ma_slow[period][CURR] > ma_slow[period][PREV]) || (cmd == ORDER_TYPE_SELL && ma_slow[period][CURR] < ma_slow[period][PREV]));
  if (METHOD(condition,  5)) result &= ((cmd == ORDER_TYPE_BUY && _chart.GetAsk() < Open[CURR]) || (cmd == ORDER_TYPE_SELL && _chart.GetAsk() > Open[CURR]));
  if (METHOD(condition,  6)) result &= UpdateIndicator(_chart, INDI_BANDS)     && ((cmd == ORDER_TYPE_BUY && Open[CURR] < bands[period][CURR][BAND_BASE]) || (cmd == ORDER_TYPE_SELL && Open[CURR] > bands[period][CURR][BAND_BASE]));
  if (METHOD(condition,  7)) result &= UpdateIndicator(_chart, INDI_ENVELOPES) && ((cmd == ORDER_TYPE_BUY && Open[CURR] < envelopes[period][CURR][LINE_MAIN]) || (cmd == ORDER_TYPE_SELL && Open[CURR] > envelopes[period][CURR][LINE_MAIN]));
  if (METHOD(condition,  8)) result &= UpdateIndicator(_chart, INDI_DEMARKER)  && ((cmd == ORDER_TYPE_BUY && demarker[period][CURR] < 0.5) || (cmd == ORDER_TYPE_SELL && demarker[period][CURR] > 0.5));
  if (METHOD(condition,  9)) result &= UpdateIndicator(_chart, INDI_WPR)       && ((cmd == ORDER_TYPE_BUY && wpr[period][CURR] > 50) || (cmd == ORDER_TYPE_SELL && wpr[period][CURR] < 50));
  if (METHOD(condition, 10)) result &= cmd == Convert::ValueToOp(curr_trend);
  if (!default_value) result = !result;
  return result;
}

/**
 * Initialize strategy via indicator.
 */
Strategy *InitStratByIndiType(ENUM_INDICATOR_TYPE _indi, ENUM_TIMEFRAMES _tf) {
  switch (_indi) {
    case INDI_AC:         return Stg_AC::Init(_tf);
    case INDI_AD:         return Stg_AD::Init(_tf);
    case INDI_ADX:        return Stg_ADX::Init(_tf);
    case INDI_ALLIGATOR:  return Stg_Alligator::Init(_tf);
    case INDI_ATR:        return Stg_ATR::Init(_tf);
    case INDI_AO:         return Stg_Awesome::Init(_tf);
    case INDI_BANDS:      return Stg_Bands::Init(_tf);
    case INDI_BEARS:      return Stg_BearsPower::Init(_tf);
    case INDI_BULLS:      return Stg_BullsPower::Init(_tf);
    case INDI_BWMFI:      return Stg_BWMFI::Init(_tf);
    case INDI_CCI:        return Stg_CCI::Init(_tf);
    case INDI_DEMARKER:   return Stg_DeMarker::Init(_tf);
    case INDI_ENVELOPES:  return Stg_Envelopes::Init(_tf);
    case INDI_FORCE:      return Stg_Force::Init(_tf);
    case INDI_FRACTALS:   return Stg_Fractals::Init(_tf);
    case INDI_GATOR:      return Stg_Gator::Init(_tf);
    case INDI_ICHIMOKU:   return Stg_Ichimoku::Init(_tf);
    case INDI_MA:         return Stg_MA::Init(_tf);
    case INDI_MACD:       return Stg_MACD::Init(_tf);
    case INDI_MFI:        return Stg_MFI::Init(_tf);
    case INDI_MOMENTUM:   return Stg_Momentum::Init(_tf);
    case INDI_OBV:        return Stg_OBV::Init(_tf);
    case INDI_OSMA:       return Stg_OSMA::Init(_tf);
    case INDI_RSI:        return Stg_RSI::Init(_tf);
    case INDI_RVI:        return Stg_RVI::Init(_tf);
    case INDI_SAR:        return Stg_SAR::Init(_tf);
    case INDI_STDDEV:     return Stg_StdDev::Init(_tf);
    case INDI_STOCHASTIC: return Stg_Stoch::Init(_tf);
    case INDI_WPR:        return Stg_WPR::Init(_tf);
    default:              return NULL;
  }
}

/**
 * Get strategy instance via indicator type.
 */
Strategy *GetStratByIndiType(ENUM_INDICATOR_TYPE _indi, Chart *_chart) {
  int _sid;
  Strategy *_strat;
  for (_sid = 0; _sid < strats.GetSize(); _sid++) {
    _strat = ((Strategy *) strats.GetByIndex(_sid));
    if (_strat.Data().GetIndicatorType() == _indi && _strat.GetTf() == _chart.GetTf()) {
      return _strat;
    }
  }
  Strategy* result = InitStratByIndiType(_indi, _chart.GetTf());

  strats.Add(result);

  return result;
}

/**
 * Check for market event.
 *
 * @param
 *   chart (Chart) - chart to use
 *   cmd (int) - trade command
 *   condition (int) - condition to check by using bitwise AND operation
 *   default_value (bool) - default value to set, if false - return the opposite
 */
bool CheckMarketEvent(Chart *_chart, ENUM_ORDER_TYPE cmd = EMPTY, ENUM_MARKET_EVENT condition = C_EVENT_NONE,
       long _bm = EMPTY, double _sl1 = EMPTY, double _sl2 = EMPTY
  ) {
  DEBUG_CHECKPOINT_ADD
  bool result = false;
#ifdef __advanced__
  ulong condition2 = 0;
#endif
  uint tfi = _chart.TfToIndex();
  ENUM_TIMEFRAMES tf = _chart.GetTf();
  if (cmd == EMPTY || condition == C_EVENT_NONE) return (false);
  if (VerboseTrace) terminal.Logger().Trace(StringFormat("%s(%s, %d)", EnumToString(cmd), _chart.TfToString(), condition), __FUNCTION_LINE__);
  switch (condition) {
    case C_AC_BUY_SELL:
      result = GetStratByIndiType(INDI_AC, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_AD_BUY_SELL:
      result = GetStratByIndiType(INDI_AD, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_ADX_BUY_SELL:
      result = GetStratByIndiType(INDI_ADX, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_ALLIGATOR_BUY_SELL:
      result = GetStratByIndiType(INDI_ALLIGATOR, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_ATR_BUY_SELL:
      result = GetStratByIndiType(INDI_ATR, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_AWESOME_BUY_SELL:
      result = GetStratByIndiType(INDI_AO, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_BANDS_BUY_SELL:
      result = GetStratByIndiType(INDI_BANDS, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_BEARSPOWER_BUY_SELL:
      result = GetStratByIndiType(INDI_BEARS, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_BULLSPOWER_BUY_SELL:
      result = GetStratByIndiType(INDI_BULLS, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_CCI_BUY_SELL:
      result = GetStratByIndiType(INDI_CCI, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_DEMARKER_BUY_SELL:
      result = GetStratByIndiType(INDI_DEMARKER, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_ENVELOPES_BUY_SELL:
      result = GetStratByIndiType(INDI_ENVELOPES, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_FORCE_BUY_SELL:
      result = GetStratByIndiType(INDI_FORCE, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_FRACTALS_BUY_SELL:
      result = GetStratByIndiType(INDI_FRACTALS, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_GATOR_BUY_SELL:
      result = GetStratByIndiType(INDI_GATOR, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_ICHIMOKU_BUY_SELL:
      result = GetStratByIndiType(INDI_ICHIMOKU, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_MA_BUY_SELL:
      result = GetStratByIndiType(INDI_MA, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_MACD_BUY_SELL:
      result = GetStratByIndiType(INDI_MACD, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_MFI_BUY_SELL:
      result = GetStratByIndiType(INDI_MFI, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_OBV_BUY_SELL:
      result = GetStratByIndiType(INDI_OBV, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_OSMA_BUY_SELL:
      result = GetStratByIndiType(INDI_OSMA, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_RSI_BUY_SELL:
      result = GetStratByIndiType(INDI_RSI, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_RVI_BUY_SELL:
      result = GetStratByIndiType(INDI_RVI, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_SAR_BUY_SELL:
      result = GetStratByIndiType(INDI_SAR, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_STDDEV_BUY_SELL:
      result = GetStratByIndiType(INDI_STDDEV, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_STOCHASTIC_BUY_SELL:
      result = GetStratByIndiType(INDI_STOCHASTIC, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_WPR_BUY_SELL:
      result = GetStratByIndiType(INDI_WPR, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_ZIGZAG_BUY_SELL:
      result = GetStratByIndiType(INDI_ZIGZAG, _chart).SignalOpen(cmd, _bm, _sl1, _sl2);
      break;
    case C_MA_FAST_SLOW_OPP: // MA Fast&Slow are in opposite directions.
      UpdateIndicator(_chart, INDI_MA);
      return
        (cmd == ORDER_TYPE_BUY && ma_fast[tfi][CURR] < ma_fast[tfi][PREV] && ma_slow[tfi][CURR] > ma_slow[tfi][PREV]) ||
        (cmd == ORDER_TYPE_SELL && ma_fast[tfi][CURR] > ma_fast[tfi][PREV] && ma_slow[tfi][CURR] < ma_slow[tfi][PREV]);
    case C_MA_FAST_MED_OPP: // MA Fast&Med are in opposite directions.
      UpdateIndicator(_chart, INDI_MA);
      return
        (cmd == ORDER_TYPE_BUY && ma_fast[tfi][CURR] < ma_fast[tfi][PREV] && ma_medium[tfi][CURR] > ma_medium[tfi][PREV]) ||
        (cmd == ORDER_TYPE_SELL && ma_fast[tfi][CURR] > ma_fast[tfi][PREV] && ma_medium[tfi][CURR] < ma_medium[tfi][PREV]);
    case C_MA_MED_SLOW_OPP: // MA Med&Slow are in opposite directions.
      UpdateIndicator(_chart, INDI_MA);
      return
        (cmd == ORDER_TYPE_BUY && ma_medium[tfi][CURR] < ma_medium[tfi][PREV] && ma_slow[tfi][CURR] > ma_slow[tfi][PREV]) ||
        (cmd == ORDER_TYPE_SELL && ma_medium[tfi][CURR] > ma_medium[tfi][PREV] && ma_slow[tfi][CURR] < ma_slow[tfi][PREV]);
#ifdef __advanced__
    case C_CUSTOM1_BUY_SELL:
    case C_CUSTOM2_BUY_SELL:
    case C_CUSTOM3_BUY_SELL:
      if (condition == C_CUSTOM1_BUY_SELL) condition2 = CloseConditionCustom1Method;
      if (condition == C_CUSTOM2_BUY_SELL) condition2 = CloseConditionCustom2Method;
      if (condition == C_CUSTOM3_BUY_SELL) condition2 = CloseConditionCustom3Method;
      result = false;
      if (condition2 != 0) {
        if (METHOD(condition2, 0)) result |= CheckMarketEvent(_chart, cmd, C_MA_BUY_SELL);
        if (METHOD(condition2, 1)) result |= CheckMarketEvent(_chart, cmd, C_MACD_BUY_SELL);
        if (METHOD(condition2, 2)) result |= CheckMarketEvent(_chart, cmd, C_ALLIGATOR_BUY_SELL);
        if (METHOD(condition2, 3)) result |= CheckMarketEvent(_chart, cmd, C_RSI_BUY_SELL);
        if (METHOD(condition2, 4)) result |= CheckMarketEvent(_chart, cmd, C_SAR_BUY_SELL);
        if (METHOD(condition2, 5)) result |= CheckMarketEvent(_chart, cmd, C_BANDS_BUY_SELL);
        if (METHOD(condition2, 6)) result |= CheckMarketEvent(_chart, cmd, C_ENVELOPES_BUY_SELL);
        if (METHOD(condition2, 7)) result |= CheckMarketEvent(_chart, cmd, C_DEMARKER_BUY_SELL);
        if (METHOD(condition2, 8)) result |= CheckMarketEvent(_chart, cmd, C_WPR_BUY_SELL);
        if (METHOD(condition2, 9)) result |= CheckMarketEvent(_chart, cmd, C_FRACTALS_BUY_SELL);
      }
      // Message("Condition: " + condition + ", result: " + result);
      break;
    case C_CUSTOM4_MARKET_COND:
    case C_CUSTOM5_MARKET_COND:
    case C_CUSTOM6_MARKET_COND:
      if (condition == C_CUSTOM4_MARKET_COND) condition2 = CloseConditionCustom4Method;
      if (condition == C_CUSTOM5_MARKET_COND) condition2 = CloseConditionCustom5Method;
      if (condition == C_CUSTOM6_MARKET_COND) condition2 = CloseConditionCustom6Method;
      if (cmd == ORDER_TYPE_BUY)  result = CheckMarketCondition1(_chart, ORDER_TYPE_SELL, condition2);
      if (cmd == ORDER_TYPE_SELL) result = CheckMarketCondition1(_chart, ORDER_TYPE_BUY, condition2);
    break;
#endif
    case C_EVENT_NONE:
    default:
      result = false;
  }
  DEBUG_CHECKPOINT_POP
  return result;
}

/**
 * Check if order match has minimum gap in pips configured by MinPipGap parameter.
 *
 * @param
 *   int sid - type of order strategy to check for (see: ENUM STRATEGY TYPE)
 */
bool CheckMinPipGap(int sid) {
  double diff;
  int order;
  for (order = 0; order < Trade::OrdersTotal(); order++) {
    if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
       if (Order::OrderMagicNumber() == MagicNumber + sid && Order::OrderSymbol() == market.GetSymbol()) {
         diff = Convert::GetValueDiffInPips(Order::OrderOpenPrice(), market.GetOpenOffer(Order::OrderType()), true);
         /*
         if (VerboseDebug) {
           PrintFormat("Ticket: #%d, %s, Gap: %g (%g-%g)",
              Order::OrderTicket(), Order::OrderTypeToString(Order::OrderType()), diff,
              Order::OrderOpenPrice(), market.GetOpenPrice()
            );
         }
         */
         if (diff < MinPipGap) {
           return (false);
         }
       }
    } else if (VerboseDebug) {
      Msg::ShowText(
          StringFormat("Cannot select order. Strategy type: %s, pos: %d, msg: %s.",
            sid, order, terminal.GetErrorText(err_code)),
          "Error", __FUNCTION__, __LINE__, VerboseErrors
      );
    }
  }
  return (true);
}

/**
 * Check orders for certain checks.
 */
void CheckOrders() {
  double elapsed_mins;
  int i;
  for (i = 0; i < Trade::OrdersTotal(); i++) {
    if (!Order::OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { continue; }
    if (CheckOurMagicNumber() && Order::OrderOpenTime() > 0 && CloseOrderAfterXHours != 0) {
      elapsed_mins = ((double) (TimeCurrent() - Order::OrderOpenTime()) / 60);
      if (CloseOrderAfterXHours > 0) {
        if (elapsed_mins / 60 > CloseOrderAfterXHours) {
          TaskAddCloseOrder(Order::OrderTicket(), R_ORDER_EXPIRED);
        }
      }
      else if (CloseOrderAfterXHours < 0 && elapsed_mins / 60 > -CloseOrderAfterXHours) {
        if (Order::GetOrderTotalProfit() > 0) {
          TaskAddCloseOrder(Order::OrderTicket(), R_ORDER_EXPIRED);
        }
      }
      /*
      else if (elapsed_mins > CloseOrderAfterXHours * PeriodSeconds(CURRENT_PERIOD)) {
        TaskAddCloseOrder(Order::OrderTicket(), R_ORDER_EXPIRED);
      }
      */
    }
  } // end: for
}

/**
 * Update trailing stops for opened orders.
 */
bool UpdateTrailingStops(Trade *_trade) {
  // Check result of executed orders.
  bool result = true;
  // New StopLoss/TakeProfit.
  double prev_sl, prev_tp;
  double new_sl, new_tp;
  double trail_sl, trail_tp;
  int i, sid;

   // Check if bar time has been changed since last time.
   /*
   int bar_time = iTime(NULL, PERIOD_M1, 0);
   if (bar_time == last_trail_update) {
     return;
   } else {
     last_trail_update = bar_time;
   }*/

  #ifdef __profiler__ PROFILER_START #endif

   market.RefreshRates();
   for (i = 0; i < Trade::OrdersTotal(); i++) {
     if (!Order::OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { continue; }
      if (Order::OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
        sid = (int) Order::OrderMagicNumber() - MagicNumber;
        // order_stop_loss = NormalizeDouble(Misc::If(Order::OrderDirection(OrderType()) > 0 || OrderStopLoss() != 0.0, OrderStopLoss(), 999999), pip_digits);
        // FIXME
        // Make sure we get the minimum distance to StopLevel and freezing distance.
        // See: https://book.mql4.com/appendix/limits
        if (MinimalizeLosses) {
        // if (MinimalizeLosses && Order::GetOrderProfit() > GetMinStopLevel()) {
          if ((Order::OrderType() == ORDER_TYPE_BUY && Order::OrderStopLoss() < market.GetBid()) ||
             (Order::OrderType() == ORDER_TYPE_SELL && Order::OrderStopLoss() > market.GetAsk())) {
            result = Order::OrderModify(Order::OrderTicket(), Order::OrderOpenPrice(), Order::OrderOpenPrice() - Order::OrderCommission() * Point, Order::OrderTakeProfit(), 0, Order::GetOrderColor(EMPTY, ColorBuy, ColorSell));
            if (!result && err_code > 0) {
             if (VerboseErrors) Print(__FUNCTION__, ": Error: OrderModify(): [MinimalizeLosses] ", Terminal::GetErrorText(err_code));
               if (VerboseDebug)
                 Print(__FUNCTION__ + ": Error: OrderModify(", Order::OrderTicket(), ", ", Order::OrderOpenPrice(), ", ", Order::OrderOpenPrice() - Order::OrderCommission() * Point, ", ", Order::OrderTakeProfit(), ", ", 0, ", ", Order::GetOrderColor(EMPTY, ColorBuy, ColorSell), "); ");
            } else {
              if (VerboseTrace) Print(__FUNCTION__ + ": MinimalizeLosses: ", Order::OrderTypeToString((ENUM_ORDER_TYPE) Order::OrderType()));
            }
          }
        }

        // Get previous stops.
        prev_sl = Order::OrderStopLoss();
        prev_tp = Order::OrderTakeProfit();
        // @todo: Use RiskMarginPerOrder with equity?
        // Get dynamic stops.
        trail_sl = GetTrailingValue(_trade, Order::OrderType(), ORDER_SL, sid, Order::OrderStopLoss(), true);
        // Get new stops.
        if (
          (prev_sl == 0) ||
          (Order::OrderType() == ORDER_TYPE_BUY && trail_sl < prev_sl) ||
          (Order::OrderType() == ORDER_TYPE_SELL && trail_sl > prev_sl)
        ) {
          new_sl = _trade.CalcBestSLTP(trail_sl, StopLossMax, RiskMarginPerOrder, ORDER_SL);
        }
        else {
          new_sl = trail_sl;
        }
        if (new_sl != prev_sl) {
          // Re-calculate TP only when SL is changed.
          trail_tp = GetTrailingValue(_trade, Order::OrderType(), ORDER_TP, sid, Order::OrderTakeProfit(), true);
          new_tp = TakeProfitMax > 0 ? _trade.CalcBestSLTP(trail_tp, TakeProfitMax, 0, ORDER_TP) : trail_tp;
        }

        if (!market.TradeOpAllowed(Order::OrderType(), new_sl, new_tp)) {
          if (VerboseDebug) {
            PrintFormat("%s(): fabs(%f - %f) = %f > %f || fabs(%f - %f) = %f > %f",
                __FUNCTION__,
                Order::OrderStopLoss(), new_sl, fabs(Order::OrderStopLoss() - new_sl), MinPipChangeToTrade * pip_size,
                Order::OrderTakeProfit(), new_tp, fabs(Order::OrderTakeProfit() - new_tp), MinPipChangeToTrade * pip_size);
          }
          return (false);
        }
        else if (fabs(new_sl - Order::OrderStopLoss()) <= pip_size && fabs(new_tp - Order::OrderTakeProfit()) <= pip_size) {
          // Ignore change smaller than a pip.
          return (false);
        }
        // @todo
        // Perform update on pip change.
        // Perform update on change only.
        // MQL5: ORDER_TIME_GTC
        // datetime expiration=TimeTradeServer()+PeriodSeconds(PERIOD_D1);

        if (fabs(prev_sl - new_sl) > MinPipChangeToTrade * pip_size || fabs(prev_tp - new_tp) > MinPipChangeToTrade * pip_size) {
          result = Order::OrderModify(Order::OrderTicket(), Order::OrderOpenPrice(), new_sl, new_tp, 0, Order::GetOrderColor(EMPTY, ColorBuy, ColorSell));
          if (!result) {
            err_code = GetLastError();
            if (err_code > 0) {
              Msg::ShowText(Terminal::GetErrorText(err_code), "Error", __FUNCTION__, __LINE__, VerboseErrors);
              Msg::ShowText(
                StringFormat("OrderModify(%d, %g, %g, %g, %d, %d); Ask:%g/Bid:%g; Gap:%g pips",
                Order::OrderTicket(), Order::OrderOpenPrice(), new_sl, new_tp, 0, Order::GetOrderColor(EMPTY, ColorBuy, ColorSell), market.GetAsk(), market.GetBid(), market.GetTradeDistanceInPips()),
                "Debug", __FUNCTION__, __LINE__, VerboseDebug
              );
              Msg::ShowText(
                StringFormat("%s(): fabs(%g - %g) = %g > %g || fabs(%g - %g) = %g > %g",
                __FUNCTION__,
                Order::OrderStopLoss(), new_sl, fabs(Order::OrderStopLoss() - new_sl), MinPipChangeToTrade * pip_size,
                Order::OrderTakeProfit(), new_tp, fabs(Order::OrderTakeProfit() - new_tp), MinPipChangeToTrade * pip_size),
                "Debug", __FUNCTION__, __LINE__, VerboseDebug);
            }
          } else {
            // if (VerboseTrace) Print("UpdateTrailingStops(): OrderModify(): ", Order::GetOrderToText());
          }
        }
      }
  } // end: for
  #ifdef __profiler__ PROFILER_STOP #endif
  return result;
}

/**
 * Calculate the new trailing stop. If calculation fails, use the previous one.
 *
 * @params:
 *   _chart (Chart)
 *    Chart to use.
 *   cmd (int)
 *    Command for trade operation.
 *   mode (ENUM_ORDER_PROPERTY_DOUBLE)
 *    Type of value (ORDER_SL or ORDER_TP).
 *   order_type (int)
 *    Value of strategy type. See: ENUM_STRATEGY_TYPE
 *   previous (double)
 *    Previous trailing value.
 *   existing (bool)
 *    Set to true if the calculation is for particular existing order, so additional local variables are available.
 */
double GetTrailingValue(Trade *_trade, ENUM_ORDER_TYPE cmd, ENUM_ORDER_PROPERTY_DOUBLE mode = ORDER_SL, int order_type = 0, double previous = 0, bool existing = false) {
  DEBUG_CHECKPOINT_ADD
  Strategy *_strat = strats.GetById(order_type);
  Chart *_chart = _strat.Chart();
  ENUM_TIMEFRAMES tf = _chart.GetTf();
  uint period = _chart.TfToIndex();
  string symbol = existing ? Order::OrderSymbol() : _chart.GetSymbol();
  double diff;
  bool one_way; // Move trailing stop only in one mode.
  double new_value = 0;
  double extra_trail = 0;
  if (existing && TrailingStopAddPerMinute > 0 && Order::OrderOpenTime() > 0) {
    double min_elapsed = (double) ((TimeCurrent() - Order::OrderOpenTime()) / 60);
    extra_trail =+ min_elapsed * TrailingStopAddPerMinute;
    if (VerboseDebug) {
      PrintFormat("%s:%d: extra_trail += %g * %g => %g",
        __FUNCTION__, __LINE__, min_elapsed, TrailingStopAddPerMinute, extra_trail);
    }
  }
  int direction = Order::OrderDirection(cmd, mode);
  double trail = (TrailingStop + extra_trail) * pip_size;
  double default_trail = (cmd == ORDER_TYPE_BUY ? _chart.GetBid() : _chart.GetAsk()) + trail * direction;
  int method = GetTrailingMethod(order_type, mode);
  one_way = method > 0;

  if (VerboseDebug) {
    PrintFormat("%s:%d: %s, %s, %d, %g): method = %d, trail = (%d + %g) * %g = %g",
      __FUNCTION__, __LINE__, Order::OrderTypeToString(cmd), EnumToString(mode), order_type, previous,
      method,
      TrailingStop, extra_trail, pip_size, trail);
  }
  // TODO: Make starting point dynamic: Open[CURR], Open[PREV], Open[FAR], Close[PREV], Close[FAR], ma_fast[CURR], ma_medium[CURR], ma_slow[CURR]
   double highest_ma, lowest_ma;
   double ask = _chart.GetAsk();
   double bid = _chart.GetBid();
   switch (method) {
     case T_NONE: // 0: None.
       new_value = _trade.CalcOrderSLTP(mode == ORDER_TP ? TakeProfitMax : StopLossMax, cmd, mode);
       break;
     case T1_FIXED: // 1: Dynamic fixed.
     case T2_FIXED:
       new_value = default_trail;
       break;
     case T1_OPEN_PREV: // 2: Previous open price.
     case T2_OPEN_PREV:
       diff = fabs(Open[CURR] - iOpen(symbol, tf, PREV));
       new_value = Open[CURR] + diff * direction;
       if (VerboseDebug) {
          PrintFormat("%s: T_OPEN_PREV: open = %g, prev_open = %g, diff = %g, new_value = %g",
            __FUNCTION__, Open[CURR], iOpen(symbol, tf, PREV), diff, new_value);
       }
       break;
     case T1_2_BARS_PEAK: // 3: Two bars peak.
     case T2_2_BARS_PEAK:
       diff = fmax(_chart.GetPeakPrice(2, MODE_HIGH) - Open[CURR], Open[CURR] - _chart.GetPeakPrice(2, MODE_LOW));
       new_value = Open[CURR] + diff * direction;
       break;
     case T1_5_BARS_PEAK: // 4: Five bars peak.
     case T2_5_BARS_PEAK:
       diff = fmax(_chart.GetPeakPrice(5, MODE_HIGH) - Open[CURR], Open[CURR] - _chart.GetPeakPrice(5, MODE_LOW));
       new_value = Open[CURR] + diff * direction;
       break;
     case T1_10_BARS_PEAK: // 5: Ten bars peak.
     case T2_10_BARS_PEAK:
       diff = fmax(_chart.GetPeakPrice(10, MODE_HIGH) - Open[CURR], Open[CURR] - _chart.GetPeakPrice(10, MODE_LOW));
       new_value = Open[CURR] + diff * direction;
       break;
     case T1_50_BARS_PEAK: // 6: 50 bars peak.
     case T2_50_BARS_PEAK:
       diff = fmax(_chart.GetPeakPrice(50, MODE_HIGH) - Open[CURR], Open[CURR] - _chart.GetPeakPrice(50, MODE_LOW));
       new_value = Open[CURR] + diff * direction;
       // @todo: Text non-Open values.
       break;
     case T1_150_BARS_PEAK: // 7: 150 bars peak.
     case T2_150_BARS_PEAK:
       diff = fmax(_chart.GetPeakPrice(150, MODE_HIGH) - Open[CURR], Open[CURR] - _chart.GetPeakPrice(150, MODE_LOW));
       new_value = Open[CURR] + diff * direction;
       break;
     case T1_HALF_200_BARS: // 8: 200 bars peak.
     case T2_HALF_200_BARS:
       diff = fmax(_chart.GetPeakPrice(200, MODE_HIGH) - Open[CURR], Open[CURR] - _chart.GetPeakPrice(200, MODE_LOW));
       new_value = Open[CURR] + diff/2 * direction;
       break;
     case T1_HALF_PEAK_OPEN: // 9: Half price peak.
     case T2_HALF_PEAK_OPEN:
       if (existing) {
         // Get the number of bars for the tf since open. Zero means that the order was opened during the current bar.
         int BarShiftOfTradeOpen = iBarShift(symbol, tf, Order::OrderOpenTime(), false);
         // Get the high price from the bar with the given tf index
         double highest_open = _chart.GetPeakPrice(BarShiftOfTradeOpen + 1, MODE_HIGH);
         double lowest_open = _chart.GetPeakPrice(BarShiftOfTradeOpen + 1, MODE_LOW);
         diff = fmax(highest_open - Open[CURR], Open[CURR] - lowest_open);
         new_value = Open[CURR] + diff/2 * direction;
       }
       break;
     case T1_MA_F_PREV: // 10: MA Small (Previous).
     case T2_MA_F_PREV:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(ask - ma_fast[period][PREV]);
       new_value = ask + diff * direction;
       break;
     case T1_MA_F_TRAIL: // 12: MA Fast (Current) + trailing stop. Works fine.
     case T2_MA_F_TRAIL:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(ask - ma_fast[period][CURR]);
       new_value = ask + (diff + trail) * direction;
       break;
     case T1_MA_M: // 14: MA Medium (Current).
     case T2_MA_M:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(ask - ma_medium[period][CURR]);
       new_value = ask + diff * direction;
       break;
     case T1_MA_M_FAR: // 15: MA Medium (Far)
     case T2_MA_M_FAR:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(ask - ma_medium[period][FAR]);
       new_value = ask + diff * direction;
       break;
     case T1_MA_M_LOW: // 16: Lowest/highest value of MA Medium. Optimized (SL pf: 1.39 for MA).
     case T2_MA_M_LOW:
       UpdateIndicator(_chart, INDI_MA);
       #ifdef __MQL4__
       diff = fmax(Array::HighestArrValue2(ma_medium, period) - Open[CURR], Open[CURR] - Array::LowestArrValue2(ma_medium, period));
       #else
       // @fixme
       diff = fmax(fmax(ma_medium[period][CURR], ma_medium[period][PREV]) - Open[CURR], Open[CURR] - fmin(ma_medium[period][CURR], ma_medium[period][PREV]));
       #endif
       new_value = Open[CURR] + diff * direction;
       break;
     case T1_MA_M_TRAIL: // 17: MA Small (Current) + trailing stop. Works fine (SL pf: 1.26 for MA).
     case T2_MA_M_TRAIL:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(Open[CURR] - ma_medium[period][CURR]);
       new_value = Open[CURR] + (diff + trail) * direction;
       break;
     case T1_MA_M_FAR_TRAIL: // 18: MA Small (Far) + trailing stop. Optimized (SL pf: 1.29 for MA).
     case T2_MA_M_FAR_TRAIL:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(Open[CURR] - ma_medium[period][FAR]);
       new_value = Open[CURR] + (diff + trail) * direction;
       if (VerboseDebug && new_value < 0) {
         PrintFormat("%s(): diff = fabs(%g - %g); new_value = %g + (%g + %g) * %g => %g",
             __FUNCTION__, Open[CURR], ma_medium[period][FAR], Open[CURR], diff, trail, direction, new_value);
       }
       break;
     case T1_MA_S: // 19: MA Slow (Current).
     case T2_MA_S:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(ask - ma_slow[period][CURR]);
       // new_value = ma_slow[period][CURR];
       new_value = ask + diff * direction;
       break;
     case T1_MA_S_FAR: // 20: MA Slow (Far).
     case T2_MA_S_FAR:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(ask - ma_slow[period][FAR]);
       // new_value = ma_slow[period][FAR];
       new_value = ask + diff * direction;
       break;
     case T1_MA_S_TRAIL: // 21: MA Slow (Current) + trailing stop. Optimized (SL pf: 1.29 for MA, PT pf: 1.23 for MA).
     case T2_MA_S_TRAIL:
       UpdateIndicator(_chart, INDI_MA);
       diff = fabs(Open[CURR] - ma_slow[period][CURR]);
       new_value = Open[CURR] + (diff + trail) * direction;
       break;
     case T1_MA_FMS_PEAK: // 22: Lowest/highest value of all MAs. Works fine (SL pf: 1.39 for MA, PT pf: 1.23 for MA).
     case T2_MA_FMS_PEAK:
       UpdateIndicator(_chart, INDI_MA);
       #ifdef __MQL4__
       highest_ma = fabs(fmax(fmax(Array::HighestArrValue2(ma_fast, period), Array::HighestArrValue2(ma_medium, period)), Array::HighestArrValue2(ma_slow, period)));
       lowest_ma = fabs(fmin(fmin(Array::LowestArrValue2(ma_fast, period), Array::LowestArrValue2(ma_medium, period)), Array::LowestArrValue2(ma_slow, period)));
       #else
       // @fixme
       highest_ma = fabs(
         fmax(
           fmax(
             fmax(ma_fast[period][CURR], ma_fast[period][PREV]),
             fmax(ma_medium[period][CURR], ma_medium[period][PREV])
             ),
             fmax(ma_slow[period][CURR], ma_slow[period][PREV])
           )
         );
       lowest_ma  = fabs(
         fmin(
           fmin(
             fmin(ma_fast[period][CURR], ma_fast[period][PREV]),
             fmin(ma_medium[period][CURR], ma_medium[period][PREV])
             ),
             fmin(ma_slow[period][CURR], ma_slow[period][PREV])
           )
         );
       #endif
       diff = fmax(fabs(highest_ma - Open[CURR]), fabs(Open[CURR] - lowest_ma));
       new_value = Open[CURR] + diff * direction;
       break;
     case T1_SAR: // 23: Current SAR value. Optimized.
     case T2_SAR:
       UpdateIndicator(_chart, INDI_SAR);
       diff = fabs(Open[CURR] - sar[period][CURR]);
       new_value = Open[CURR] + (diff + trail) * direction;
       if (VerboseDebug) PrintFormat("SAR Trail: %g, %g, %g", sar[period][CURR], sar[period][PREV], sar[period][FAR]);
       break;
     case T1_SAR_PEAK: // 24: Lowest/highest SAR value.
     case T2_SAR_PEAK:
       UpdateIndicator(_chart, INDI_SAR);
       #ifdef __MQL4__
       diff = fmax(fabs(Open[CURR] - Array::HighestArrValue2(sar, period)), fabs(Open[CURR] - Array::LowestArrValue2(sar, period)));
       #else
       diff = fmax(
         fabs(Open[CURR] - fmax(sar[period][CURR], sar[period][PREV])),
         fabs(Open[CURR] - fmin(sar[period][CURR], sar[period][PREV]))
         );
       #endif
       new_value = Open[CURR] + (diff + trail) * direction;
       break;
     case T1_BANDS: // 25: Current Bands value.
     case T2_BANDS:
       UpdateIndicator(_chart, INDI_BANDS);
       new_value = direction > 0 ? bands[period][CURR][BAND_UPPER] : bands[period][CURR][BAND_LOWER];
       break;
     case T1_BANDS_PEAK: // 26: Lowest/highest Bands value.
     case T2_BANDS_PEAK:
       UpdateIndicator(_chart, INDI_BANDS);
       new_value = (Order::OrderDirection(cmd) == mode
         ? fmax(fmax(bands[period][CURR][BAND_UPPER], bands[period][PREV][BAND_UPPER]), bands[period][FAR][BAND_UPPER])
         : fmin(fmin(bands[period][CURR][BAND_LOWER], bands[period][PREV][BAND_LOWER]), bands[period][FAR][BAND_LOWER])
         );
       break;
     case T1_ENVELOPES: // 27: Current Envelopes value. // FIXME
     case T2_ENVELOPES:
       UpdateIndicator(_chart, INDI_ENVELOPES);
       new_value = direction > 0 ? envelopes[period][CURR][LINE_UPPER] : envelopes[period][CURR][LINE_LOWER];
       break;
     default:
       Msg::ShowText(StringFormat("Unknown trailing stop method: %d", method), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
   }

  if (new_value > 0) new_value += Convert::PointsToValue(market.GetTradeDistanceInPts()) * direction;
  // + Convert::PointsToValue(GetSpreadInPts()) ?

  if (!market.TradeOpAllowed(cmd, new_value)) {
    #ifndef __limited__
      if (existing && previous == 0 && mode == -1) previous = default_trail;
    #else // If limited, then force the trailing value.
      if (existing && previous == 0) previous = default_trail;
    #endif
    Msg::ShowText(
        StringFormat("#%d (%s;d:%d), method: %d, invalid value: %g, previous: %g, ask/bid/Gap: %f/%f/%f (%d pts); %s",
          existing ? Order::OrderTicket() : 0, EnumToString(mode), direction,
          method, new_value, previous, ask, bid, Convert::PointsToValue(market.GetTradeDistanceInPts()), market.GetTradeDistanceInPts(), Order::OrderTypeToString(Order::OrderType())),
        "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    // If value is invalid, fallback to the previous one.
    return market.NormalizePrice(previous);
  }

  if (one_way) {
    if (mode < 0) {
      // Move trailing stop only one mode.
      if (previous == 0) previous = default_trail;
      if (Order::OrderDirection(cmd) == mode) new_value = (new_value < previous || previous == 0) ? new_value : previous;
      else new_value = (new_value > previous || previous == 0) ? new_value : previous;
    }
    else if (mode > 0) {
      // Move profit take only one mode.
      if (Order::OrderDirection(cmd) == mode) new_value = (new_value > previous || previous == 0) ? new_value : previous;
      else new_value = (new_value < previous || previous == 0) ? new_value : previous;
    }
  }

  #ifdef __MQL4__
  if (VerboseDebug) {
    Msg::ShowText(
      StringFormat("Strategy: %s (%d), Method: %d, Tf: %d, Period: %d, Value: %g, Prev: %g, Direction: %d, Trail: %g (%g), LMA/HMA: %g/%g (%g/%g/%g|%g/%g/%g)",
        _strat.GetName(), order_type, method, tf, period, new_value, previous, direction, trail, default_trail,
        fabs(fmin(fmin(Array::LowestArrValue2(ma_fast, period), Array::LowestArrValue2(ma_medium, period)), Array::LowestArrValue2(ma_slow, period))),
        fabs(fmax(fmax(Array::HighestArrValue2(ma_fast, period), Array::HighestArrValue2(ma_medium, period)), Array::HighestArrValue2(ma_slow, period))),
        Array::LowestArrValue2(ma_fast, period), Array::LowestArrValue2(ma_medium, period), Array::LowestArrValue2(ma_slow, period),
        Array::HighestArrValue2(ma_fast, period), Array::HighestArrValue2(ma_medium, period), Array::HighestArrValue2(ma_slow, period))
      , "Trace", __FUNCTION__, __LINE__, VerboseTrace);
  }
  #endif
  // if (VerboseDebug && Terminal::IsVisualMode()) Draw::ShowLine("trail_stop_" + OrderTicket(), new_value, GetOrderColor(EMPTY, ColorBuy, ColorSell));

  new_value = market.NormalizePrice(new_value);
  return market.NormalizeSLTP(new_value, cmd, mode);
}

/**
 * Get trailing method based on the strategy.
 */
int GetTrailingMethod(int order_type, ENUM_ORDER_PROPERTY_DOUBLE mode) {
  DEBUG_CHECKPOINT_ADD
  #ifdef __rider__
  int stop_method = DefaultTrailingStopMethod, profit_method = DefaultTrailingProfitMethod;
  #else
  Strategy *_strat = strats.GetById(order_type);
  int stop_method = _strat.GetSlMethod(), profit_method = _strat.GetTpMethod();
  #endif
  DEBUG_CHECKPOINT_POP
  return mode == ORDER_TP ? profit_method : stop_method;
}

/**
 * Return total number of opened orders (based on the EA magic number)
 * @todo: Move to Orders.
 */
int GetTotalOrders(bool ours = true) {
  int order, total = 0;
  for (order = 0; order < Trade::OrdersTotal(); order++) {
    if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && Order::OrderSymbol() == Symbol()) {
      if (CheckOurMagicNumber()) {
        if (ours) total++;
      } else {
        if (!ours) total++;
      }
    }
  }
  if (ours) total_orders = total; // Re-calculate global variables.
  return (total);
}

// Return total number of orders per strategy type. See: ENUM_STRATEGY_TYPE.
int GetTotalOrdersByType(unsigned int order_type) {
  int order;
  static datetime last_access = time_current;
  if (Cache && open_orders[order_type] > 0 && last_access == time_current) { return open_orders[order_type]; } else { last_access = time_current; }; // Return cached if available.
  open_orders[order_type] = 0;
  // ArrayFill(open_orders[order_type], 0, ArraySize(open_orders), 0); // Reset open_orders array.
  for (order = 0; order < Trade::OrdersTotal(); order++) {
   if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
     if (Order::OrderSymbol() == Symbol() && Order::OrderMagicNumber() == MagicNumber + order_type) {
       open_orders[order_type]++;
     }
   }
  }
  return (open_orders[order_type]);
}

/**
 * Get total profit of opened orders by type.
 * @todo: Move to Orders.
 */
double GetTotalProfitByType(ENUM_ORDER_TYPE cmd = NULL, int order_type = NULL) {
  double total = 0;
  int i;
  for (i = 0; i < Trade::OrdersTotal(); i++) {
    if (Order::OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) break;
    if (Order::OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if (Order::OrderType() == cmd) total += Order::GetOrderTotalProfit();
       else if (Order::OrderMagicNumber() == MagicNumber + order_type) total += Order::GetOrderTotalProfit();
     }
  }
  return total;
}

/**
 * Get profitable side and return trade operation type (ORDER_TYPE_BUY/ORDER_TYPE_SELL).
 * @todo: Move to Orders.
 */
ENUM_ORDER_TYPE GetProfitableSide() {
  double buys = GetTotalProfitByType(ORDER_TYPE_BUY);
  double sells = GetTotalProfitByType(ORDER_TYPE_SELL);
  if (buys > sells) return ORDER_TYPE_BUY;
  if (sells > buys) return ORDER_TYPE_SELL;
  return (ENUM_ORDER_TYPE) NULL;
}

/**
 * Calculate trade order command based on the majority of opened orders.
 * @todo: Move to Orders.
 */
ENUM_ORDER_TYPE GetCmdByOrders() {
  uint buys = Orders::GetOrdersByType(ORDER_TYPE_BUY);
  uint sells = Orders::GetOrdersByType(ORDER_TYPE_SELL);
  if (buys > sells) return ORDER_TYPE_BUY;
  if (sells > buys) return ORDER_TYPE_SELL;
  return (ENUM_ORDER_TYPE) NULL;
}

/**
 * For given magic number, check if it is ours.
 */
bool CheckOurMagicNumber(int magic_number = NULL) {
  if (magic_number == NULL) magic_number = (int) Order::OrderMagicNumber();
  bool _result = (magic_number >= MagicNumber && magic_number < MagicNumber + FINAL_STRATEGY_TYPE_ENTRY);
  return _result;
}

/**
 * Check if it is possible to trade.
 */
bool TradeAllowed() {
  bool _result = true;
  #ifdef __profiler__ PROFILER_START #endif
  if (chart.GetBars() < 100) {
    last_err = Msg::ShowText("Bars less than 100, not trading yet.", "Error", __FUNCTION__, __LINE__, VerboseErrors);
    if (PrintLogOnChart) DisplayInfoOnChart();
    _result = false;
  }
  else if (Terminal::IsRealtime() && Volume[0] < MinVolumeToTrade) {
    last_err = Msg::ShowText("Volume too low to trade.", "Error", __FUNCTION__, __LINE__, VerboseErrors);
    if (PrintLogOnChart) DisplayInfoOnChart();
    _result = false;
  }
  else if (!METHOD(16, ((int) ea_last_order[6] - (int) ea_last_order[2]))) {
    _result = false;
  }
  else if (terminal.IsTradeContextBusy()) {
    last_err = Msg::ShowText("Trade context is temporary busy.", "Error", __FUNCTION__, __LINE__, VerboseErrors);
    if (PrintLogOnChart) DisplayInfoOnChart();
    _result = false;
  }
  // Check if the EA is allowed to trade and trading context is not busy, otherwise returns false.
  // OrderSend(), OrderClose(), OrderCloseBy(), OrderModify(), OrderDelete() trading functions
  //   changing the state of a trading account can be called only if trading by Expert Advisors
  //   is allowed (the "Allow live trading" checkbox is enabled in the Expert Advisor or script properties).
  else if (terminal.IsRealtime() && !terminal.IsTradeAllowed()) {
    last_err = Msg::ShowText("Trade is not allowed at the moment, check the settings!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    _result = false;
  }
  else if (terminal.IsRealtime() && !terminal.IsConnected()) {
    last_err = Msg::ShowText("Terminal is not connected!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    if (PrintLogOnChart) DisplayInfoOnChart();
    _result = false;
  }
  else if (IsStopped()) {
    last_err = Msg::ShowText("Terminal is stopping!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    _result = false;
  }
  else if (terminal.IsRealtime() && !terminal.IsTradeAllowed()) {
    last_err = Msg::ShowText("Trading is not allowed. Market may be closed or choose the right symbol. Otherwise contact your broker.", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    if (PrintLogOnChart) DisplayInfoOnChart();
    _result = false;
  }
  else if (terminal.IsRealtime() && !terminal.IsExpertEnabled()) {
    last_err = Msg::ShowText("You need to enable: 'Enable Expert Advisor'/'AutoTrading'.", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    _result = false;
  }
  else if (!session_active || StringLen(ea_file) != 11) {
    last_err = Msg::ShowText(StringFormat("Session is not active (%d)!", StringLen(ea_file)), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    ea_active = false;
    _result = false;
  }

  ea_active = _result;
  #ifdef __profiler__ PROFILER_STOP #endif
  return (_result);
}

/**
 * Check if EA parameters are valid.
 */
int CheckSettings() {
  string err;
  if (LotSize < 0.0) {
    Msg::ShowText("LotSize is less than 0.", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, true);
    return -__LINE__;
  }
  if (!Terminal::IsRealtime() && ValidateSettings) {
    if (!Tester::ValidSpread() || !Tester::ValidLotstep()) {
      Msg::ShowText("Backtest market settings are invalid! Connect to broker to fix it!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
      return -__LINE__;
    }
  }
  return StringLen(ea_file) == 11 ? __LINE__ : -__LINE__;
}

/**
 * Validate market values.
 */
bool ValidateSettings() {
  bool result = true;
  result &= Tests::TestAllMarket(VerboseDebug);
  return result;
}

void CheckStats(double value, int type, bool max = true) {
  if (max) {
    if (value > daily[type])   daily[type]   = value;
    if (value > weekly[type])  weekly[type]  = value;
    if (value > monthly[type]) monthly[type] = value;
  } else {
    if (value < daily[type])   daily[type]   = value;
    if (value < weekly[type])  weekly[type]  = value;
    if (value < monthly[type]) monthly[type] = value;
  }
}

/**
 * Get daily total available orders. It can dynamically change during the day.
 *
 * @return
 *   Returns daily order limit when positive. When zero, it means unlimited.
 */
#ifdef __advanced__
uint GetMaxOrdersPerDay() {
  if (MaxOrdersPerDay <= 0) return 0;
  int hours_left = (24 - hour_of_day);
  int curr_allowed_limit = (int) floor((MaxOrdersPerDay - daily_orders) / hours_left);
  // Message(StringFormat("Hours left: (%d - %d) / %d= %d", MaxOrdersPerDay, daily_orders, hours_left, curr_allowed_limit));
  return (uint) fmin(fmax((total_orders - daily_orders), 1) + curr_allowed_limit, MaxOrdersPerDay);
}
#endif

/**
 * Calculate number of maximum of orders allowed to open.
 */
unsigned long GetMaxOrders(double volume_size) {
  unsigned long _result = 0;
  unsigned long _limit = account.GetLimitOrders();
  #ifdef __advanced__
    _result = MaxOrders > 0 ? (MaxOrdersPerDay > 0 ? fmin(MaxOrders, GetMaxOrdersPerDay()) : MaxOrders) : trade[chart.TfToIndex()].CalcMaxOrders(volume_size, ea_risk_ratio, max_orders, GetMaxOrdersPerDay());
  #else
    _result = MaxOrders > 0 ? MaxOrders : trade[chart.TfToIndex()].CalcMaxOrders(volume_size, ea_risk_ratio, max_orders);
  #endif
  return _limit > 0 ? fmin(_result, _limit) : _result;
}

/**
 * Calculate the limit of maximum orders to open per each strategy.
 */
int GetMaxOrdersPerType() {
  return MaxOrdersPerType > 0  ? (int)MaxOrdersPerType : (int) fmin(fmax(MathFloor(max_orders / fmax(GetNoOfStrategies(), 1) ), 1) * 2, max_orders);
}

/**
 * Get number of active strategies.
 */
unsigned int GetNoOfStrategies() {
  int sid;
  unsigned int result = 0;
  Strategy *_strat;
  for (sid = 0; sid < strats.GetSize(); sid++) {
    _strat = ((Strategy *) strats.GetByIndex(sid));
    result += _strat.IsEnabled() && !_strat.IsSuspended() ? 1 : 0;
  }
  return result;
}

/**
 * Calculate size of the lot based on the free margin and account leverage automatically.
 */
double GetLotSizeAuto(uint _method = 0, bool smooth = true) {
  double new_lot_size = trade[chart.TfToIndex()].CalcLotSize(ea_risk_margin_per_order, ea_risk_ratio, _method);

  // Lot size warm-up.
  static bool is_warm_up = InitNoOfDaysToWarmUp != 0;
  if (is_warm_up) {
    OHLC first_bar = trade[chart.TfToIndex()].Chart().LoadOHLC();
    long warmup_days = ((TimeCurrent() - first_bar.time) / 60 / 60 / 24);
    if (warmup_days < InitNoOfDaysToWarmUp) {
      new_lot_size *= market.NormalizeLots(new_lot_size * 1 / (double) InitNoOfDaysToWarmUp * warmup_days);
    }
    else {
      is_warm_up = false;
    }
  }

  #ifdef __advanced__
  if (Boosting_Enabled) {
    if (LotSizeIncreaseMethod != 0) {
      if (METHOD(LotSizeIncreaseMethod, 0)) if (AccCondition(C_ACC_IN_PROFIT))      new_lot_size *= 1.1;
      if (METHOD(LotSizeIncreaseMethod, 1)) if (AccCondition(C_EQUITY_01PC_LOW))    new_lot_size *= 1.1;
      if (METHOD(LotSizeIncreaseMethod, 2)) if (AccCondition(C_EQUITY_05PC_LOW))    new_lot_size *= 1.1;
      if (METHOD(LotSizeIncreaseMethod, 3)) if (AccCondition(C_DBAL_LT_WEEKLY))     new_lot_size *= 1.1;
      if (METHOD(LotSizeIncreaseMethod, 4)) if (AccCondition(C_WBAL_LT_MONTHLY))    new_lot_size *= 1.1;
      if (METHOD(LotSizeIncreaseMethod, 5)) if (AccCondition(C_ACC_IN_TREND))       new_lot_size *= 1.1;
      if (METHOD(LotSizeIncreaseMethod, 6)) if (AccCondition(C_ACC_CDAY_IN_LOSS))   new_lot_size *= 1.1;
      if (METHOD(LotSizeIncreaseMethod, 7)) if (AccCondition(C_ACC_PDAY_IN_LOSS))   new_lot_size *= 1.1;
    }
    // --
    if (LotSizeDecreaseMethod != 0) {
      if (METHOD(LotSizeDecreaseMethod, 0)) if (AccCondition(C_ACC_IN_LOSS))        new_lot_size *= 0.9;
      if (METHOD(LotSizeDecreaseMethod, 1)) if (AccCondition(C_EQUITY_01PC_HIGH))   new_lot_size *= 0.9;
      if (METHOD(LotSizeDecreaseMethod, 2)) if (AccCondition(C_EQUITY_05PC_HIGH))   new_lot_size *= 0.9;
      if (METHOD(LotSizeDecreaseMethod, 3)) if (AccCondition(C_DBAL_GT_WEEKLY))     new_lot_size *= 0.9;
      if (METHOD(LotSizeDecreaseMethod, 4)) if (AccCondition(C_WBAL_GT_MONTHLY))    new_lot_size *= 0.9;
      if (METHOD(LotSizeDecreaseMethod, 5)) if (AccCondition(C_ACC_IN_NON_TREND))   new_lot_size *= 0.9;
      if (METHOD(LotSizeDecreaseMethod, 6)) if (AccCondition(C_ACC_CDAY_IN_PROFIT)) new_lot_size *= 0.9;
      if (METHOD(LotSizeDecreaseMethod, 7)) if (AccCondition(C_ACC_PDAY_IN_PROFIT)) new_lot_size *= 0.9;
    }
  }
  #endif

  if (smooth && ea_lot_size > 0) {
    // Increase only by average of the previous and new (which should prevent sudden increases).
    return market.NormalizeLots((ea_lot_size + new_lot_size) / 2);
  } else {
    return market.NormalizeLots(new_lot_size);
  }
}

/**
 * Return current lot size to trade.
 */
double GetLotSize() {
  return market.NormalizeLots(LotSize <= 0 ? GetLotSizeAuto((uint) fabs(LotSize)) : LotSize);
}

/**
 * Calculate risk of margin per each order.
 *
 * Risk only certain % of total available margin for each order.
 */
double GetRiskMarginAutoPerOrder() {
  // @todo: Add different methods (e.g. violity level).
  return ea_risk_ratio;
}

/**
 * Calculate risk of margin for all orders.
 *
 * Risk only certain % of total available margin for all orders.
 */
double GetRiskMarginAutoInTotal() {
  // @todo: Add different methods (e.g. violity level).
  return fmin(20, 20 * ea_risk_ratio);
}

/**
 * Return risk margin per order.
 *
 * @return int
 *   Range: 1-100
 */
double GetRiskMarginPerOrder() {
  return RiskMarginPerOrder == 0 ? GetRiskMarginAutoPerOrder() : fabs(RiskMarginPerOrder);
}

/**
 * Return risk margin for total orders.
 *
 * @return int
 *   Range: 1-100
 */
double GetRiskMarginInTotal() {
  return RiskMarginTotal == 0 ? GetRiskMarginAutoInTotal() : RiskMarginTotal;
}

/**
 * Calculate auto risk ratio value.
 */
double GetAutoRiskRatio() {
  double equity  = account.AccountEquity();
  double balance = account.AccountBalance() + account.AccountCredit();
  // Used when you open/close new positions. It can increase decrease during the price movement
  // in favor and vice versa.
  double free    = account.AccountFreeMargin();
  // Taken from your depo as a guarantee to maintain your current positions opened.
  // It stays the same until you open or close positions.
  double margin  = account.AccountMargin();
  double new_ea_risk_ratio = 1 / fmax(NEAR_ZERO, fmin(equity, balance)) * fmin(fmin(free, balance), equity);
  // --
  int margin_pc = (int) (100 / fmax(NEAR_ZERO, equity * margin));
  rr_text = new_ea_risk_ratio < 1.0 ? StringFormat("-MarginUsed=%d%%|", margin_pc) : ""; string s = "|";
  // ea_margin_risk_level
  // @todo: Add account.GetRiskMarginLevel(), GetTrend(), ConWin/ConLoss, violity level.
  if (RiskRatioIncreaseMethod != 0) {
    if (METHOD(RiskRatioIncreaseMethod, 0)) if (AccCondition(C_ACC_IN_PROFIT))      { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if (METHOD(RiskRatioIncreaseMethod, 1)) if (AccCondition(C_EQUITY_20PC_HIGH))   { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if (METHOD(RiskRatioIncreaseMethod, 2)) if (AccCondition(C_EQUITY_20PC_LOW))    { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if (METHOD(RiskRatioIncreaseMethod, 3)) if (AccCondition(C_DBAL_LT_WEEKLY))     { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if (METHOD(RiskRatioIncreaseMethod, 4)) if (AccCondition(C_WBAL_GT_MONTHLY))    { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if (METHOD(RiskRatioIncreaseMethod, 5)) if (AccCondition(C_ACC_IN_TREND))       { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if (METHOD(RiskRatioIncreaseMethod, 6)) if (AccCondition(C_ACC_CDAY_IN_PROFIT)) { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if (METHOD(RiskRatioIncreaseMethod, 7)) if (AccCondition(C_ACC_PDAY_IN_PROFIT)) { new_ea_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
  }
  // --
  if (RiskRatioDecreaseMethod != 0) {
    if (METHOD(RiskRatioDecreaseMethod, 0)) if (AccCondition(C_ACC_IN_LOSS))        { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if (METHOD(RiskRatioDecreaseMethod, 1)) if (AccCondition(C_EQUITY_20PC_LOW))    { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if (METHOD(RiskRatioDecreaseMethod, 2)) if (AccCondition(C_EQUITY_20PC_HIGH))   { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if (METHOD(RiskRatioDecreaseMethod, 3)) if (AccCondition(C_DBAL_GT_WEEKLY))     { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if (METHOD(RiskRatioDecreaseMethod, 4)) if (AccCondition(C_WBAL_LT_MONTHLY))    { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if (METHOD(RiskRatioDecreaseMethod, 5)) if (AccCondition(C_ACC_IN_NON_TREND))   { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if (METHOD(RiskRatioDecreaseMethod, 6)) if (AccCondition(C_ACC_CDAY_IN_LOSS))   { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if (METHOD(RiskRatioDecreaseMethod, 7)) if (AccCondition(C_ACC_PDAY_IN_LOSS))   { new_ea_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
  }
  String::RemoveSepChar(rr_text, s);

  /*
  #ifdef __advanced__
  #else
    if (GetTotalProfit() < 0) new_ea_risk_ratio /= 2; // Half risk if we're in overall loss.
  #endif
  */

  return new_ea_risk_ratio;
}

/**
 * Return risk ratio value.
 */
double GetRiskRatio() {
  return RiskRatio == 0 ? GetAutoRiskRatio() : RiskRatio;
}

/* BEGIN: PERIODIC FUNCTIONS */

/**
 * Executed for every hour.
 */
void StartNewHour(Trade *_trade) {
  #ifdef __profiler__ PROFILER_START #endif

  CheckHistory(); // Process closed orders for the previous hour.

  // Process actions.
  CheckAccConditions(_trade.Chart());

  // Process orders.
  ProcessOrders();

  // Print stats.
  if (!terminal.IsOptimization()) {
    Msg::ShowText(
      StringFormat("Hourly stats: Ticks: %d/h (%.2f/min)",
        hourly_stats.GetTotalTicks(),
        hourly_stats.GetTotalTicks() / 60
      ), "Debug", __FUNCTION__, __LINE__, VerboseDebug);

    // Reset variables.
    hourly_stats.Reset();
  }

  // Start the new hour.
  // Note: This needs to be after action processing.
  hour_of_day = DateTime::Hour();

  // Update variables.
  ea_risk_ratio = GetRiskRatio();
  max_orders = GetMaxOrders(ea_lot_size);

  if (VerboseDebug) {
    PrintFormat("== New hour at %s (risk ratio: %.2f, max orders: %d)",
      DateTime::TimeToStr(TimeCurrent()), ea_risk_ratio, max_orders);
  }

  // Check if new day has been started.
  if (day_of_week != DateTime::DayOfWeek()) {
    StartNewDay(_trade);
  }

  // Update strategy factor and lot size.
  if (Boosting_Enabled) UpdateStrategyFactor(DAILY);

  #ifdef __advanced__
  // Check if RSI period needs re-calculation.
  // if (RSI_DynamicPeriod) RSI_CheckPeriod();
  // Check for dynamic spread configuration.
  if (DynamicSpreadConf) {
    // TODO: SpreadRatio, MinPipChangeToTrade, MinPipGap
  }
  #endif

  // Reset messages and errors.
  // Message(NULL);
  #ifdef __profiler__ PROFILER_STOP #endif
}

/**
 * Queue the message for display.
 */
void Message(string msg = NULL) {
  if (msg == NULL) { last_msg = ""; last_err = ""; }
  else last_msg = msg;
}

/**
 * Get last available message.
 */
string GetLastMessage() {
  return last_msg;
}

/**
 * Executed for every new day.
 */
void StartNewDay(Trade *_trade) {
  if (VerboseInfo) PrintFormat("== New day at %s ==", DateTime::TimeToStr(TimeCurrent()));

  // Print daily report at end of each day.
  if (VerboseInfo) Print(GetDailyReport());

  // Process actions.
  CheckAccConditions(_trade.Chart());

  // Calculate lot size if required.
  if (InitNoOfDaysToWarmUp != 0) {
    OHLC first_bar = trade[chart.TfToIndex()].Chart().LoadOHLC(0);
    long warmup_days = ((TimeCurrent() - first_bar.time) / 60 / 60 / 24);
    if (warmup_days <= InitNoOfDaysToWarmUp) {
      ea_lot_size = GetLotSize();
    }
  }

  // Update boosting values.
  if (Boosting_Enabled) UpdateStrategyFactor(WEEKLY);

  // Check if day started another week.
  if (DateTime::DayOfWeek() < day_of_week) {
    StartNewWeek(_trade);
  }
  if (DateTime::Day() < day_of_month) {
    StartNewMonth(_trade);
  }
  if (DateTime::DayOfYear() < day_of_year) {
    StartNewYear(_trade);
  }

  // Store new data.
  day_of_week = DateTime::DayOfWeek(); // The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date. At the testing, the last known server time is modelled.
  day_of_month = DateTime::Day(); // The day of month (1 - 31) of the specified date. At the testing, the last known server time is modelled.
  day_of_year = DateTime::DayOfYear(); // Day (1 means 1 January,..,365(6) does 31 December) of year. At the testing, the last known server time is modelled.
  // Print and reset variables.
  daily_orders = 0;

  // Reset previous data.
  ArrayFill(daily, 0, ArraySize(daily), 0);
  // Print and reset strategy stats.
  string strategy_stats = "Daily strategy stats: ";
  Strategy *_strat;
  int j, sid;
  for (sid = 0; sid < strats.GetSize(); sid++) {
    _strat = ((Strategy *) strats.GetByIndex(sid));
    j = (int) _strat.GetId();
    if (stats[j][DAILY_PROFIT] != 0) strategy_stats += StringFormat("%s: %.1f pips; ", _strat.GetName(), stats[j][DAILY_PROFIT]);
    stats[j][DAILY_PROFIT]  = 0;
  }
  if (VerboseInfo) Print(strategy_stats);

  // Reset ticks
  if (RecordTicksToCSV) {
    ticker.SaveToCSV();
    ticker.Reset();
  }
  terminal.Logger().Flush(false);
}

/**
 * Executed for every new week.
 */
void StartNewWeek(Trade *_trade) {
  if (StringLen(__FILE__) != 11) { ExpertRemove(); }
  if (VerboseInfo) PrintFormat("== New week at %s ==", DateTime::TimeToStr(TimeCurrent()));
  if (VerboseInfo) Print(GetWeeklyReport()); // Print weekly report at end of each week.

  // Process actions.
  CheckAccConditions(_trade.Chart());

  // Calculate lot size, orders and risk.
  ea_risk_margin_per_order = GetRiskMarginPerOrder(); // Re-calculate risk margin per order.
  ea_risk_margin_total = GetRiskMarginInTotal(); // Re-calculate risk margin in total.
  ea_lot_size = GetLotSize(); // Re-calculate lot size.
  UpdateStrategyLotSize(); // Update strategy lot size.

  // Update boosting values.
  if (Boosting_Enabled) UpdateStrategyFactor(MONTHLY);

  ArrayFill(weekly, 0, ArraySize(weekly), 0);
  // Reset strategy stats.
  string strategy_stats = "Weekly strategy stats: ";
  Strategy *_strat;
  int j, sid;
  for (sid = 0; sid < strats.GetSize(); sid++) {
    _strat = ((Strategy *) strats.GetByIndex(sid));
    j = (int) _strat.GetId();
    if (stats[j][WEEKLY_PROFIT] != 0) strategy_stats += StringFormat("%s: %.1f pips; ", _strat.GetName(), stats[j][WEEKLY_PROFIT]);
    stats[j][WEEKLY_PROFIT]  = 0;
  }
  int _strat_reenabled = UnsuspendStrategies();
  if (_strat_reenabled > 0) {
    PrintFormat("%s(): Unsuspended %d strategies.", __FUNCTION__, _strat_reenabled);
  }
  if (VerboseInfo) Print(strategy_stats);
}

/**
 * Unsuspend all strategies.
 */
int UnsuspendStrategies() {
  int _counter = 0;
  Strategy *_strat;
  for (int _sid = 0; _sid < strats.GetSize(); _sid++) {
    _strat = ((Strategy *) strats.GetByIndex(_sid));
    if (_strat.IsSuspended()) {
      _strat.Suspended(false);
      _counter++;
    }
  }
  return _counter;
}

/**
 * Executed for every new month.
 */
void StartNewMonth(Trade *_trade) {
  if (VerboseInfo) PrintFormat("== New month at %s ==", DateTime::TimeToStr(TimeCurrent()));
  if (VerboseInfo) Print(GetMonthlyReport()); // Print monthly report at end of each month.

  // Process actions.
  CheckAccConditions(_trade.Chart());

  // Store new data.
  month = DateTime::Month(); // Returns the current month as number (1-January,2,3,4,5,6,7,8,9,10,11,12), i.e., the number of month of the last known server time.

  ArrayFill(monthly, 0, ArraySize(monthly), 0);
  // Reset strategy stats.
  string strategy_stats = "Monthly strategy stats: ";
  Strategy *_strat;
  int j, sid;
  for (sid = 0; sid < strats.GetSize(); sid++) {
    _strat = ((Strategy *) strats.GetByIndex(sid));
    j = (int) _strat.GetId();
    if (stats[j][MONTHLY_PROFIT] != 0) strategy_stats += StringFormat("%s: %.1f pips; ", _strat.GetName(), stats[j][MONTHLY_PROFIT]);
    stats[j][MONTHLY_PROFIT]  = 0;
  }
  if (VerboseInfo) Print(strategy_stats);
}

/**
 * Executed for every new year.
 */
void StartNewYear(Trade *_trade) {
  if (VerboseInfo) Print("== New year ==");
  // if (VerboseInfo) Print(GetYearlyReport()); // Print monthly report at end of each year.

  // Store new data.
  year = DateTime::Year(); // Returns the current year, i.e., the year of the last known server time.
}

/* END: PERIODIC FUNCTIONS */

/* BEGIN: VARIABLE FUNCTIONS */

/**
 * Initialize startup variables.
 */
bool InitVariables() {

  bool init = true;

  // Get type of account.
  if (!Terminal::IsRealtime()) account_type = "Backtest on " + account.GetType();
  #ifdef __backtest__ init &= !Terminal::IsRealtime(); #endif

  // Check time of the week, month and year based on the trading bars.
  //init_bar_time = chart.GetBarTime();
  time_current = TimeCurrent();
  hour_of_day = DateTime::Hour(); // The hour (0,1,2,..23) of the last known server time by the moment of the program start.
  day_of_week = DateTime::DayOfWeek(); // The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date. At the testing, the last known server time is modelled.
  day_of_month = DateTime::Day(); // The day of month (1 - 31) of the specified date. At the testing, the last known server time is modelled.
  day_of_year = DateTime::DayOfYear(); // Day (1 means 1 January,..,365(6) does 31 December) of year. At the testing, the last known server time is modelled.
  month = DateTime::Month(); // Returns the current month as number (1-January,2,3,4,5,6,7,8,9,10,11,12), i.e., the number of month of the last known server time.
  year = DateTime::Year(); // Returns the current year, i.e., the year of the last known server time.

  market = new Market(_Symbol);

  // @todo Move to method.
  if (market.GetTradeContractSize() <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid MODE_LOTSIZE: %g", market.GetTradeContractSize()), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
  }

  // @todo: Move to method.
  if (market.GetVolumeStep() <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid SYMBOL_VOLUME_STEP: %g", market.GetVolumeStep()), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
    // market.GetLotStepInPts() = 0.01;
  }

  // @todo: Move to method.
  // Check the minimum permitted amount of a lot.
  if (market.GetVolumeMin() <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid SYMBOL_VOLUME_MIN: %g", market.GetVolumeMin()), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
    // market.GetMinLot() = market.GetLotStepInPts();
  }

  // @todo: Move to method.
  // Check the maximum permitted amount of a lot.
  if (market.GetVolumeMax() <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid SYMBOL_VOLUME_MAX: %g", market.GetVolumeMax()), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
  }

  // @todo: Move to method.
  if (market.GetVolumeStep() > market.GetVolumeMin()) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Step lot is higher than min lot (%g > %g)", market.GetVolumeStep(), market.GetVolumeMin()), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
  }

  if (Trade::GetMarginRequired(_Symbol) == 0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid MODE_MARGINREQUIRED: %g", Trade::GetMarginRequired(_Symbol)), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
    // market.GetMarginRequired() = 10; // Fix for 'zero divide' bug when MODE_MARGINREQUIRED is zero.
  }

  order_freezelevel = market.GetFreezeLevel();

  curr_spread = market.GetSpreadInPips();
  init_balance = account.AccountBalance();
  if (init_balance <= 0) {
    Msg::ShowText(StringFormat("Account balance is %g!", init_balance), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return (false);
  }
  if (account.AccountEquity() <= 0) {
    Msg::ShowText(StringFormat("Account equity is %g!", account.AccountEquity()), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return (false);
  }
  if (account.AccountFreeMargin() <= 0) {
    Msg::ShowText(StringFormat("Account free margin is %g!", account.AccountFreeMargin()), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return (false);
  }
  /* @fixme: https://travis-ci.org/EA31337-Tester/EA31337-Lite-Sets/builds/140302386
  if (account.AccountMargin() <= 0) {
    Msg::ShowText(StringFormat("Account margin is %g!", account.AccountMargin()), "Error", __FUNCTION__, __LINE__, VerboseErrors);
    return (false);
  }
  */

  init_spread = market.GetSpreadInPts(); // @todo

  // Calculate pip/volume/slippage size and precision.
  // Market *market = new Market(_Symbol);
  pip_size = market.GetPipSize();
  pts_per_pip = market.GetPointsPerPip();

  max_order_slippage = Convert::PipsToPoints(MaxOrderPriceSlippage); // Maximum price slippage for buy or sell orders (converted into points).

  // Calculate lot size, orders, risk ratio and margin risk.
  UpdateMarginRiskLevel();
  UpdateVariables();
  ea_risk_ratio = GetRiskRatio();   // Re-calculate risk ratio.
  ea_risk_margin_per_order = GetRiskMarginPerOrder(); // Calculate the risk margin per order.
  ea_risk_margin_total = GetRiskMarginInTotal(); // Calculate the risk margin for all orders.
  ea_lot_size = GetLotSize();       // Calculate lot size (dependent on ea_risk_ratio).
  ea_last_order = ea_name;          // Last order pointer.
  if (ea_lot_size <= 0) {
    Msg::ShowText(StringFormat("Lot size is %g!", ea_lot_size), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    if (ValidateSettings) {
      // @fixme: Fails on Gold H1.
      return (false);
    } else {
      ea_lot_size = market.GetVolumeMin();
    }
  }
  max_orders = GetMaxOrders(ea_lot_size);

  gmt_offset = TimeGMTOffset();
  ArrayInitialize(todo_queue, 0); // Reset queue list.
  ArrayInitialize(daily,   0); // Reset daily stats.
  ArrayInitialize(weekly,  0); // Reset weekly stats.
  ArrayInitialize(monthly, 0); // Reset monthly stats.
  ArrayInitialize(tickets, 0); // Reset ticket list.
  ArrayInitialize(worse_strategy, EMPTY); // Reset worse strategy pointer.
  ArrayInitialize(best_strategy, EMPTY); // Reset best strategy pointer.
  ArrayInitialize(order_queue, EMPTY); // Reset order queue.

  // Initialize stats.
  if (!terminal.IsOptimization()) {
    total_stats = new Stats();
    hourly_stats = new Stats();
  }
  return (init);
}

/**
 * Initialize strategies.
 */
bool InitStrategies() {
  bool init = true;
  #ifdef __profiler__ PROFILER_START #endif

  // Initialize/reset strategy arrays.
  ArrayInitialize(info, 0);  // Reset strategy info.
  ArrayInitialize(conf, 0);  // Reset strategy configuration.
  ArrayInitialize(stats, 0); // Reset strategy statistics.

  if ((AC_Active_Tf & M1B) == M1B)   { strats.Add(Stg_AC::Init_M1()); }
  if ((AC_Active_Tf & M5B) == M5B)   { strats.Add(Stg_AC::Init_M5()); }
  if ((AC_Active_Tf & M15B) == M15B) { strats.Add(Stg_AC::Init_M15()); }
  if ((AC_Active_Tf & M30B) == M30B) { strats.Add(Stg_AC::Init_M30()); }

  if ((AD_Active_Tf & M1B) == M1B) { strats.Add(Stg_AD::Init_M1()); };
  if ((AD_Active_Tf & M5B) == M5B) { strats.Add(Stg_AD::Init_M5()); };
  if ((AD_Active_Tf & M15B) == M15B) { strats.Add(Stg_AD::Init_M15()); };
  if ((AD_Active_Tf & M30B) == M30B) { strats.Add(Stg_AD::Init_M30()); };

  if ((ADX_Active_Tf & M1B) == M1B) { strats.Add(Stg_ADX::Init_M1()); }
  if ((ADX_Active_Tf & M5B) == M5B) { strats.Add(Stg_ADX::Init_M5()); }
  if ((ADX_Active_Tf & M15B) == M15B) { strats.Add(Stg_ADX::Init_M15()); }
  if ((ADX_Active_Tf & M30B) == M30B) { strats.Add(Stg_ADX::Init_M30()); }

  if ((Alligator_Active_Tf & M1B) == M1B) { strats.Add(Stg_Alligator::Init_M1()); }
  if ((Alligator_Active_Tf & M5B) == M5B) { strats.Add(Stg_Alligator::Init_M5()); }
  if ((Alligator_Active_Tf & M15B) == M15B) { strats.Add(Stg_Alligator::Init_M15()); }
  if ((Alligator_Active_Tf & M30B) == M30B) { strats.Add(Stg_Alligator::Init_M30()); }

  if ((ATR_Active_Tf & M1B) == M1B) { strats.Add(Stg_ATR::Init_M1()); }
  if ((ATR_Active_Tf & M5B) == M5B) { strats.Add(Stg_ATR::Init_M5()); }
  if ((ATR_Active_Tf & M15B) == M15B) { strats.Add(Stg_ATR::Init_M15()); }
  if ((ATR_Active_Tf & M30B) == M30B) { strats.Add(Stg_ATR::Init_M30()); }

  if ((Awesome_Active_Tf & M1B) == M1B) { strats.Add(Stg_Awesome::Init_M1()); }
  if ((Awesome_Active_Tf & M5B) == M5B) { strats.Add(Stg_Awesome::Init_M5()); }
  if ((Awesome_Active_Tf & M15B) == M15B) { strats.Add(Stg_Awesome::Init_M15()); }
  if ((Awesome_Active_Tf & M30B) == M30B) { strats.Add(Stg_Awesome::Init_M30()); }

  if ((Bands_Active_Tf & M1B) == M1B) { strats.Add(Stg_Bands::Init_M1()); }
  if ((Bands_Active_Tf & M5B) == M5B) { strats.Add(Stg_Bands::Init_M5()); }
  if ((Bands_Active_Tf & M15B) == M15B) { strats.Add(Stg_Bands::Init_M15()); }
  if ((Bands_Active_Tf & M30B) == M30B) { strats.Add(Stg_Bands::Init_M30()); }

  if ((BearsPower_Active_Tf & M1B) == M1B) { strats.Add(Stg_BearsPower::Init_M1()); }
  if ((BearsPower_Active_Tf & M5B) == M5B) { strats.Add(Stg_BearsPower::Init_M5()); }
  if ((BearsPower_Active_Tf & M15B) == M15B) { strats.Add(Stg_BearsPower::Init_M15()); }
  if ((BearsPower_Active_Tf & M30B) == M30B) { strats.Add(Stg_BearsPower::Init_M30()); }

  if ((BullsPower_Active_Tf & M1B) == M1B) { strats.Add(Stg_BullsPower::Init_M1()); }
  if ((BullsPower_Active_Tf & M5B) == M5B) { strats.Add(Stg_BullsPower::Init_M5()); }
  if ((BullsPower_Active_Tf & M15B) == M15B) { strats.Add(Stg_BullsPower::Init_M15()); }
  if ((BullsPower_Active_Tf & M30B) == M30B) { strats.Add(Stg_BullsPower::Init_M30()); }

  if ((BWMFI_Active_Tf & M1B) == M1B) { strats.Add(Stg_BWMFI::Init_M1()); }
  if ((BWMFI_Active_Tf & M5B) == M5B) { strats.Add(Stg_BWMFI::Init_M5()); }
  if ((BWMFI_Active_Tf & M15B) == M15B) { strats.Add(Stg_BWMFI::Init_M15()); }
  if ((BWMFI_Active_Tf & M30B) == M30B) { strats.Add(Stg_BWMFI::Init_M30()); }

  if ((CCI_Active_Tf & M1B) == M1B) { strats.Add(Stg_CCI::Init_M1()); }
  if ((CCI_Active_Tf & M5B) == M5B) { strats.Add(Stg_CCI::Init_M5()); }
  if ((CCI_Active_Tf & M15B) == M15B) { strats.Add(Stg_CCI::Init_M15()); }
  if ((CCI_Active_Tf & M30B) == M30B) { strats.Add(Stg_CCI::Init_M30()); }

  if ((DeMarker_Active_Tf & M1B) == M1B) { strats.Add(Stg_DeMarker::Init_M1()); }
  if ((DeMarker_Active_Tf & M5B) == M5B) { strats.Add(Stg_DeMarker::Init_M5()); }
  if ((DeMarker_Active_Tf & M15B) == M15B) { strats.Add(Stg_DeMarker::Init_M15()); }
  if ((DeMarker_Active_Tf & M30B) == M30B) { strats.Add(Stg_DeMarker::Init_M30()); }

  if ((Envelopes_Active_Tf & M1B) == M1B) { strats.Add(Stg_Envelopes::Init_M1()); }
  if ((Envelopes_Active_Tf & M5B) == M5B) { strats.Add(Stg_Envelopes::Init_M5()); }
  if ((Envelopes_Active_Tf & M15B) == M15B) { strats.Add(Stg_Envelopes::Init_M15()); }
  if ((Envelopes_Active_Tf & M30B) == M30B) { strats.Add(Stg_Envelopes::Init_M30()); }

  if ((Force_Active_Tf & M1B) == M1B) { strats.Add(Stg_Force::Init_M1()); }
  if ((Force_Active_Tf & M5B) == M5B) { strats.Add(Stg_Force::Init_M5()); }
  if ((Force_Active_Tf & M15B) == M15B) { strats.Add(Stg_Force::Init_M15()); }
  if ((Force_Active_Tf & M30B) == M30B) { strats.Add(Stg_Force::Init_M30()); }

  if ((Fractals_Active_Tf & M1B) == M1B) { strats.Add(Stg_Fractals::Init_M1()); }
  if ((Fractals_Active_Tf & M5B) == M5B) { strats.Add(Stg_Fractals::Init_M5()); }
  if ((Fractals_Active_Tf & M15B) == M15B) { strats.Add(Stg_Fractals::Init_M15()); }
  if ((Fractals_Active_Tf & M30B) == M30B) { strats.Add(Stg_Fractals::Init_M30()); }

  if ((Gator_Active_Tf & M1B) == M1B) { strats.Add(Stg_Gator::Init_M1()); }
  if ((Gator_Active_Tf & M5B) == M5B) { strats.Add(Stg_Gator::Init_M5()); }
  if ((Gator_Active_Tf & M15B) == M15B) { strats.Add(Stg_Gator::Init_M15()); }
  if ((Gator_Active_Tf & M30B) == M30B) { strats.Add(Stg_Gator::Init_M30()); }

  if ((Ichimoku_Active_Tf & M1B) == M1B) { strats.Add(Stg_Ichimoku::Init_M1()); }
  if ((Ichimoku_Active_Tf & M5B) == M5B) { strats.Add(Stg_Ichimoku::Init_M5()); }
  if ((Ichimoku_Active_Tf & M15B) == M15B) { strats.Add(Stg_Ichimoku::Init_M15()); }
  if ((Ichimoku_Active_Tf & M30B) == M30B) { strats.Add(Stg_Ichimoku::Init_M30()); }

  if ((MA_Active_Tf & M1B) == M1B) { strats.Add(Stg_MA::Init_M1()); }
  if ((MA_Active_Tf & M5B) == M5B) { strats.Add(Stg_MA::Init_M5()); }
  if ((MA_Active_Tf & M15B) == M15B) { strats.Add(Stg_MA::Init_M15()); }
  if ((MA_Active_Tf & M30B) == M30B) { strats.Add(Stg_MA::Init_M30()); }

  if ((MACD_Active_Tf & M1B) == M1B) { strats.Add(Stg_MACD::Init_M1()); }
  if ((MACD_Active_Tf & M5B) == M5B) { strats.Add(Stg_MACD::Init_M5()); }
  if ((MACD_Active_Tf & M15B) == M15B) { strats.Add(Stg_MACD::Init_M15()); }
  if ((MACD_Active_Tf & M30B) == M30B) { strats.Add(Stg_MACD::Init_M30()); }

  if ((MFI_Active_Tf & M1B) == M1B) { strats.Add(Stg_MFI::Init_M1()); }
  if ((MFI_Active_Tf & M5B) == M5B) { strats.Add(Stg_MFI::Init_M5()); }
  if ((MFI_Active_Tf & M15B) == M15B) { strats.Add(Stg_MFI::Init_M15()); }
  if ((MFI_Active_Tf & M30B) == M30B) { strats.Add(Stg_MFI::Init_M30()); }

  if ((Momentum_Active_Tf & M1B) == M1B) { strats.Add(Stg_Momentum::Init_M1()); }
  if ((Momentum_Active_Tf & M5B) == M5B) { strats.Add(Stg_Momentum::Init_M5()); }
  if ((Momentum_Active_Tf & M15B) == M15B) { strats.Add(Stg_Momentum::Init_M15()); }
  if ((Momentum_Active_Tf & M30B) == M30B) { strats.Add(Stg_Momentum::Init_M30()); }

  if ((OBV_Active_Tf & M1B) == M1B) { strats.Add(Stg_OBV::Init_M1()); }
  if ((OBV_Active_Tf & M5B) == M5B) { strats.Add(Stg_OBV::Init_M5()); }
  if ((OBV_Active_Tf & M15B) == M15B) { strats.Add(Stg_OBV::Init_M15()); }
  if ((OBV_Active_Tf & M30B) == M30B) { strats.Add(Stg_OBV::Init_M30()); }

  if ((OSMA_Active_Tf & M1B) == M1B) { strats.Add(Stg_OSMA::Init_M1()); }
  if ((OSMA_Active_Tf & M5B) == M5B) { strats.Add(Stg_OSMA::Init_M5()); }
  if ((OSMA_Active_Tf & M15B) == M15B) { strats.Add(Stg_OSMA::Init_M15()); }
  if ((OSMA_Active_Tf & M30B) == M30B) { strats.Add(Stg_OSMA::Init_M30()); }

  if ((RSI_Active_Tf & M1B) == M1B)   { strats.Add(Stg_RSI::Init_M1()); };
  if ((RSI_Active_Tf & M5B) == M5B)   { strats.Add(Stg_RSI::Init_M5()); };
  if ((RSI_Active_Tf & M15B) == M15B) { strats.Add(Stg_RSI::Init_M15()); };
  if ((RSI_Active_Tf & M30B) == M30B) { strats.Add(Stg_RSI::Init_M30()); };

  if ((RVI_Active_Tf & M1B) == M1B) { strats.Add(Stg_RVI::Init_M1()); }
  if ((RVI_Active_Tf & M5B) == M5B) { strats.Add(Stg_RVI::Init_M5()); }
  if ((RVI_Active_Tf & M15B) == M15B) { strats.Add(Stg_RVI::Init_M15()); }
  if ((RVI_Active_Tf & M30B) == M30B) { strats.Add(Stg_RVI::Init_M30()); }

  if ((SAR_Active_Tf & M1B) == M1B) { strats.Add(Stg_SAR::Init_M1()); }
  if ((SAR_Active_Tf & M5B) == M5B) { strats.Add(Stg_SAR::Init_M5()); }
  if ((SAR_Active_Tf & M15B) == M15B) { strats.Add(Stg_SAR::Init_M15()); }
  if ((SAR_Active_Tf & M30B) == M30B) { strats.Add(Stg_SAR::Init_M30()); }

  if ((StdDev_Active_Tf & M1B) == M1B) { strats.Add(Stg_StdDev::Init_M1()); }
  if ((StdDev_Active_Tf & M5B) == M5B) { strats.Add(Stg_StdDev::Init_M5()); }
  if ((StdDev_Active_Tf & M15B) == M15B) { strats.Add(Stg_StdDev::Init_M15()); }
  if ((StdDev_Active_Tf & M30B) == M30B) { strats.Add(Stg_StdDev::Init_M30()); }

  if ((Stochastic_Active_Tf & M1B) == M1B) { strats.Add(Stg_Stoch::Init_M1()); }
  if ((Stochastic_Active_Tf & M5B) == M5B) { strats.Add(Stg_Stoch::Init_M5()); }
  if ((Stochastic_Active_Tf & M15B) == M15B) { strats.Add(Stg_Stoch::Init_M15()); }
  if ((Stochastic_Active_Tf & M30B) == M30B) { strats.Add(Stg_Stoch::Init_M30()); }

  if ((WPR_Active_Tf & M1B) == M1B) { strats.Add(Stg_WPR::Init_M1()); }
  if ((WPR_Active_Tf & M5B) == M5B) { strats.Add(Stg_WPR::Init_M5()); }
  if ((WPR_Active_Tf & M15B) == M15B) { strats.Add(Stg_WPR::Init_M15()); }
  if ((WPR_Active_Tf & M30B) == M30B) { strats.Add(Stg_WPR::Init_M30()); }

  if ((ZigZag_Active_Tf & M1B) == M1B) { strats.Add(Stg_ZigZag::Init_M1()); }
  if ((ZigZag_Active_Tf & M5B) == M5B) { strats.Add(Stg_ZigZag::Init_M5()); }
  if ((ZigZag_Active_Tf & M15B) == M15B) { strats.Add(Stg_ZigZag::Init_M15()); }
  if ((ZigZag_Active_Tf & M30B) == M30B) { strats.Add(Stg_ZigZag::Init_M30()); }

  int sid;
  Strategy *_strat;
  for (sid = 0; sid < strats.GetSize(); sid++) {

    // Validate strategy.
    _strat = ((Strategy *) strats.GetByIndex(sid));
    if (!_strat.IsValid()) {
      Msg::ShowText(
        StringFormat("Cannot initialize %s strategy, because its timeframe (%s) is not active!%s", _strat.GetName(), EnumToString(_strat.GetTf()), ValidateSettings ? " Disabling..." : ""),
        "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
      init = false;
    }

    // Validate the timeframe.
    ENUM_TIMEFRAMES_INDEX _tfi = _strat.Chart().TfToIndex();
    if (!Object::IsValid(trade[_tfi])) {

      // Initialize the Trade instance and its chart.
      TradeParams trade_params(account, new Chart(_tfi), logger, MaxOrderPriceSlippage);
      trade[_tfi] = new Trade(trade_params);

      if (!Object::IsValid(trade[_tfi]) || !trade[_tfi].Chart().IsValidTf()) {
        Msg::ShowText(
          StringFormat("Cannot initialize %s strategy, because its timeframe (%s) is not active!%s", _strat.GetName(), EnumToString(_strat.GetTf()), ValidateSettings ? " Disabling..." : ""),
          "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
        init = false;
      }
    }

  }

  if (!init && ValidateSettings) {
    Msg::ShowText(Chart::ListTimeframes(), "Info", __FUNCTION__, __LINE__, VerboseInfo);
    Msg::ShowText("Initiation of strategies failed!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
  }

  for (int i = 0; i < ArrayRange(conf, 0); i++) {
    conf[i][FACTOR] = 1.0;
    conf[i][LOT_SIZE] = ea_lot_size;
    conf[i][PROFIT_FACTOR] = GetDefaultProfitFactor();
  }

  #ifdef __profiler__ PROFILER_STOP #endif
  return init || !ValidateSettings;
}

/**
 * Init classes.
 */
bool InitClasses() {
  #ifdef __profiler__ PROFILER_START #endif

  // Initialize main classes.
  account = new Account();
  logger = new Log(V_DEBUG);
  mail = new Mail();
  market = new Market(_Symbol, logger);

  // Initialize the current chart.
  ENUM_TIMEFRAMES_INDEX _tfi = Chart::TfToIndex(PERIOD_CURRENT);
  TradeParams trade_params(account, new Chart(_tfi), logger, MaxOrderPriceSlippage);
  trade[_tfi] = new Trade(trade_params);

  // Verify that the current chart has been initialized correctly.
  if (Object::IsDynamic(trade[_tfi]) && trade[_tfi].Chart().IsValidTf()) {
    // Assign to the current chart.
    chart = trade[_tfi].Chart();
  }
  else {
    Msg::ShowText(
      StringFormat("Cannot initialize the current timeframe (%s)!", Chart::IndexToString(_tfi)),
      "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return false;
  }

  // Initialize the trend's chart.
  ENUM_TIMEFRAMES_INDEX _ttfi = Chart::TfToIndex(TrendPeriod);
  if (!Object::IsDynamic(trade[_ttfi]) || !trade[_ttfi].Chart().IsValidTf()) {
    TradeParams ttrade_params(account, new Chart(_ttfi), logger, MaxOrderPriceSlippage);
    trade[_ttfi] = new Trade(ttrade_params);
    // Verify the trend's chart.
    if (!Object::IsDynamic(trade[_ttfi]) || !trade[_ttfi].Chart().IsValidTf()) {
      Msg::ShowText(
        StringFormat("Cannot initialize the trend's timeframe (%s)!", Chart::IndexToString(_ttfi)),
        "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
      return false;
    }
  }

  // Initialize other classes.
  terminal = market.TerminalHandler();
  ticker = new Ticker(market);
  strats = new Collection();
  summary_report = new SummaryReport();

  #ifdef __profiler__ PROFILER_STOP #endif
  return market.GetSymbol() == _Symbol;
}

/**
 * Update global variables.
 */
void UpdateVariables() {
  DEBUG_CHECKPOINT_ADD
  #ifdef __profiler__ PROFILER_START #endif
  time_current = TimeCurrent();
  //curr_bar_time = chart.GetBarTime(PERIOD_M1);
  last_close_profit = EMPTY;
  total_orders = GetTotalOrders();
  curr_spread = market.GetSpreadInPips();
  // Calculate trend.
  uint rsi_period;
  switch (TrendPeriod) {
    case PERIOD_M1: rsi_period = RSI_Period_M1; break;
    case PERIOD_M5: rsi_period = RSI_Period_M5; break;
    case PERIOD_M15: rsi_period = RSI_Period_M15; break;
    default:
    case PERIOD_M30: rsi_period = RSI_Period_M30; break;
  }
  // curr_trend = trade.GetTrend(fabs(TrendMethod), TrendMethod < 0 ? PERIOD_M1 : (ENUM_TIMEFRAMES) NULL);
  double curr_rsi = Indi_RSI::iRSI(market.GetSymbol(), TrendPeriod, rsi_period, RSI_Applied_Price, 0);
  curr_trend = fabs(curr_rsi - 50) > 10 ? (double) (1.0 / 50) * (curr_rsi - 50) : 0;
  // PrintFormat("Curr Trend: %g (%g: %g/%g), RSI: %g", curr_trend, (double) (1.0 / 50) * (curr_rsi - 50), 1 / 50, curr_rsi - 50, curr_rsi);
  #ifdef __profiler__ PROFILER_STOP #endif
}

/* END: VARIABLE FUNCTIONS */

/* BEGIN: CONDITION FUNCTIONS */

/**
 * Initialize user defined conditions.
 */
bool InitializeConditions() {
  acc_conditions[0][0] = Account_Condition_1;
  acc_conditions[0][1] = Market_Condition_1;
  acc_conditions[0][2] = Action_On_Condition_1;

  acc_conditions[1][0] = Account_Condition_2;
  acc_conditions[1][1] = Market_Condition_2;
  acc_conditions[1][2] = Action_On_Condition_2;

  acc_conditions[2][0] = Account_Condition_3;
  acc_conditions[2][1] = Market_Condition_3;
  acc_conditions[2][2] = Action_On_Condition_3;

  acc_conditions[3][0] = Account_Condition_4;
  acc_conditions[3][1] = Market_Condition_4;
  acc_conditions[3][2] = Action_On_Condition_4;

  acc_conditions[4][0] = Account_Condition_5;
  acc_conditions[4][1] = Market_Condition_5;
  acc_conditions[4][2] = Action_On_Condition_5;

  #ifdef __advanced__
  acc_conditions[5][0] = Account_Condition_6;
  acc_conditions[5][1] = Market_Condition_6;
  acc_conditions[5][2] = Action_On_Condition_6;
  acc_conditions[6][0] = Account_Condition_7;
  acc_conditions[6][1] = Market_Condition_7;
  acc_conditions[6][2] = Action_On_Condition_7;
  acc_conditions[7][0] = Account_Condition_8;
  acc_conditions[7][1] = Market_Condition_8;
  acc_conditions[7][2] = Action_On_Condition_8;
  acc_conditions[8][0] = Account_Condition_9;
  acc_conditions[8][1] = Market_Condition_9;
  acc_conditions[8][2] = Action_On_Condition_9;
  acc_conditions[9][0] = Account_Condition_10;
  acc_conditions[9][1] = Market_Condition_10;
  acc_conditions[9][2] = Action_On_Condition_10;
  acc_conditions[10][0] = Account_Condition_11;
  acc_conditions[10][1] = Market_Condition_11;
  acc_conditions[10][2] = Action_On_Condition_11;
  acc_conditions[11][0] = Account_Condition_12;
  acc_conditions[11][1] = Market_Condition_12;
  acc_conditions[11][2] = Action_On_Condition_12;
  acc_conditions[12][0] = Account_Condition_13;
  acc_conditions[12][1] = Market_Condition_13;
  acc_conditions[12][2] = Action_On_Condition_13;
  acc_conditions[13][0] = Account_Condition_14;
  acc_conditions[13][1] = Market_Condition_14;
  acc_conditions[13][2] = Action_On_Condition_14;
  acc_conditions[14][0] = Account_Condition_15;
  acc_conditions[14][1] = Market_Condition_15;
  acc_conditions[14][2] = Action_On_Condition_15;
  acc_conditions[15][0] = Account_Condition_16;
  acc_conditions[15][1] = Market_Condition_16;
  acc_conditions[15][2] = Action_On_Condition_16;
  acc_conditions[16][0] = Account_Condition_17;
  acc_conditions[16][1] = Market_Condition_17;
  acc_conditions[16][2] = Action_On_Condition_17;
  acc_conditions[17][0] = Account_Condition_18;
  acc_conditions[17][1] = Market_Condition_18;
  acc_conditions[17][2] = Action_On_Condition_18;
  acc_conditions[18][0] = Account_Condition_19;
  acc_conditions[18][1] = Market_Condition_19;
  acc_conditions[18][2] = Action_On_Condition_19;
  acc_conditions[19][0] = Account_Condition_20;
  acc_conditions[19][1] = Market_Condition_20;
  acc_conditions[19][2] = Action_On_Condition_20;
  acc_conditions[20][0] = Account_Condition_21;
  acc_conditions[20][1] = Market_Condition_21;
  acc_conditions[20][2] = Action_On_Condition_21;
  acc_conditions[21][0] = Account_Condition_22;
  acc_conditions[21][1] = Market_Condition_22;
  acc_conditions[21][2] = Action_On_Condition_22;
  acc_conditions[22][0] = Account_Condition_23;
  acc_conditions[22][1] = Market_Condition_23;
  acc_conditions[22][2] = Action_On_Condition_23;
  acc_conditions[23][0] = Account_Condition_24;
  acc_conditions[23][1] = Market_Condition_24;
  acc_conditions[23][2] = Action_On_Condition_24;
  acc_conditions[24][0] = Account_Condition_25;
  acc_conditions[24][1] = Market_Condition_25;
  acc_conditions[24][2] = Action_On_Condition_25;
  acc_conditions[25][0] = Account_Condition_26;
  acc_conditions[25][1] = Market_Condition_26;
  acc_conditions[25][2] = Action_On_Condition_26;
  acc_conditions[26][0] = Account_Condition_27;
  acc_conditions[26][1] = Market_Condition_27;
  acc_conditions[26][2] = Action_On_Condition_27;
  acc_conditions[27][0] = Account_Condition_28;
  acc_conditions[27][1] = Market_Condition_28;
  acc_conditions[27][2] = Action_On_Condition_28;
  acc_conditions[28][0] = Account_Condition_29;
  acc_conditions[28][1] = Market_Condition_29;
  acc_conditions[28][2] = Action_On_Condition_29;
  acc_conditions[29][0] = Account_Condition_30;
  acc_conditions[29][1] = Market_Condition_30;
  acc_conditions[29][2] = Action_On_Condition_30;
  #endif

  if (AccountConditionToDisable > 0 && AccountConditionToDisable < ArraySize(acc_conditions)) {
    acc_conditions[AccountConditionToDisable - 1][0] = C_ACC_NONE;
    acc_conditions[AccountConditionToDisable - 1][1] = C_MARKET_NONE;
    acc_conditions[AccountConditionToDisable - 1][2] = A_NONE;
  }
  return true;
}

/**
 * Check account condition.
 */
bool AccCondition(int condition = C_ACC_NONE) {
  switch(condition) {
    case C_ACC_TRUE:
      last_cname = "true";
      return true;
    case C_EQUITY_20PC_HIGH: // Equity 20% high
      last_cname = "Equ>20%";
      return account.AccountEquity() > (account.AccountBalance() + account.AccountCredit()) / 100 * 120;
    case C_EQUITY_10PC_HIGH: // Equity 10% high
      last_cname = "Equ>10%";
      return account.AccountEquity() > (account.AccountBalance() + account.AccountCredit()) / 100 * 110;
    case C_EQUITY_05PC_HIGH: // Equity 5% high
      last_cname = "Equ>5%";
      return account.AccountEquity() > (account.AccountBalance() + account.AccountCredit()) / 100 * 105;
    case C_EQUITY_01PC_HIGH: // Equity 1% high
      last_cname = "Equ>1%";
      return account.AccountEquity() > (account.AccountBalance() + account.AccountCredit()) / 100 * 101;
    case C_EQUITY_01PC_LOW:  // Equity 1% low
      last_cname = "Equ<1%";
      return account.AccountEquity() < (account.AccountBalance() + account.AccountCredit()) / 100 * 99;
    case C_EQUITY_05PC_LOW:  // Equity 5% low
      last_cname = "Equ<5%";
      return account.AccountEquity() < (account.AccountBalance() + account.AccountCredit()) / 100 * 95;
    case C_EQUITY_10PC_LOW:  // Equity 10% low
      last_cname = "Equ<10%";
      return account.AccountEquity() < (account.AccountBalance() + account.AccountCredit()) / 100 * 90;
    case C_EQUITY_20PC_LOW:  // Equity 20% low
      last_cname = "Equ<20%";
      return account.AccountEquity() < (account.AccountBalance() + account.AccountCredit()) / 100 * 80;
    case C_MARGIN_USED_20PC: // 20% Margin Used
      last_cname = "Margin>20%";
      return account.AccountMargin() >= account.AccountEquity() / 100 * 20;
    case C_MARGIN_USED_50PC: // 50% Margin Used
      last_cname = "Margin>50%";
      return account.AccountMargin() >= account.AccountEquity() / 100 * 50;
    case C_MARGIN_USED_70PC: // 70% Margin Used
      // Note that in some accounts, Stop Out will occur in your account when equity reaches 70% of your used margin resulting in immediate closing of all positions.
      last_cname = "Margin>70%";
      return account.AccountMargin() >= account.AccountEquity() / 100 * 70;
    case C_MARGIN_USED_90PC: // 90% Margin Used
      last_cname = "Margin>90%";
      return account.AccountMargin() >= account.AccountEquity() / 100 * 90;
    case C_NO_FREE_MARGIN:
      last_cname = "NoMargin%";
      return account.AccountFreeMargin() <= 10;
    case C_ACC_IN_LOSS:
      last_cname = "AccInLoss";
      return GetTotalProfit() < 0;
    case C_ACC_IN_PROFIT:
      last_cname = "AccInProfit";
      return GetTotalProfit() > 0;
    case C_DBAL_LT_WEEKLY:
      last_cname = "DBal<WBal";
      return daily[MAX_BALANCE] < weekly[MAX_BALANCE];
    case C_DBAL_GT_WEEKLY:
      last_cname = "DBal>WBal";
      return daily[MAX_BALANCE] > weekly[MAX_BALANCE];
    case C_WBAL_LT_MONTHLY:
      last_cname = "WBal<MBal";
      return weekly[MAX_BALANCE] < monthly[MAX_BALANCE];
    case C_WBAL_GT_MONTHLY:
      last_cname = "WBal>MBal";
      return weekly[MAX_BALANCE] > monthly[MAX_BALANCE];
    case C_ACC_IN_TREND:
      last_cname = "InTrend";
      return (Convert::ValueToOp(curr_trend) == ORDER_TYPE_BUY && Orders::GetOrdersByType(ORDER_TYPE_BUY)  > Orders::GetOrdersByType(ORDER_TYPE_SELL))
          || (Convert::ValueToOp(curr_trend) == ORDER_TYPE_SELL && Orders::GetOrdersByType(ORDER_TYPE_SELL) > Orders::GetOrdersByType(ORDER_TYPE_BUY));
    case C_ACC_IN_NON_TREND:
      last_cname = "InNonTrend";
      return !AccCondition(C_ACC_IN_TREND);
    case C_ACC_CDAY_IN_PROFIT: // Check if current day in profit.
      #ifdef __MQL4__
      last_cname = "TodayInProfit";
      return Array::GetArrSumKey1(hourly_profit, day_of_year, 10) > 0;
      #else
      // @fixme
      last_cname = "TodayInProfit(@FIXME)";
      return False;
      #endif
    case C_ACC_CDAY_IN_LOSS: // Check if current day in loss.
      #ifdef __MQL4__
      last_cname = "TodayInLoss";
      return Array::GetArrSumKey1(hourly_profit, day_of_year, 10) < 0;
      #else
      // @fixme
      last_cname = "TodayInLoss(@FIXME)";
      return False;
      #endif
    case C_ACC_PDAY_IN_PROFIT: // Check if previous day in profit.
      {
        #ifdef __MQL4__
        last_cname = "YesterdayInProfit";
        int yesterday1 = DateTime::TimeDayOfYear(time_current - 24*60*60);
        return Array::GetArrSumKey1(hourly_profit, yesterday1) > 0;
        #else
        // @fixme
        last_cname = "YesterdayInProfit(@FIXME)";
        int yesterday1 = DateTime::TimeDayOfYear(time_current - 24*60*60);
        return False;
        #endif
      }
    case C_ACC_PDAY_IN_LOSS: // Check if previous day in loss.
      {
        #ifdef __MQL4__
        last_cname = "YesterdayInLoss";
        int yesterday2 = DateTime::TimeDayOfYear(time_current - 24*60*60);
        return Array::GetArrSumKey1(hourly_profit, yesterday2) < 0;
        #else
        // @fixme
        last_cname = "YesterdayInLoss(@FIXME)";
        int yesterday2 = DateTime::TimeDayOfYear(time_current - 24*60*60);
        return False;
        #endif
      }
    case C_ACC_MAX_ORDERS:
      return total_orders >= max_orders;
    default:
    case C_ACC_NONE:
      last_cname = "None";
      return false;
  }
  return false;
}

/**
 * Check market condition.
 */
bool MarketCondition(Chart *_chart, int condition = C_MARKET_NONE) {
  static int counter = 0;
  // if (VerboseTrace) Print(__FUNCTION__);
  switch(condition) {
    case C_MARKET_TRUE:
      return true;
    case C_MA1_FS_TREND_OPP: // MA Fast and Slow M1 are in opposite directions.
      return CheckMarketEvent(trade[M1].Chart(), Convert::ValueToOp(curr_trend), C_MA_FAST_SLOW_OPP);
    case C_MA5_FS_TREND_OPP: // MA Fast and Slow M5 are in opposite directions.
      return CheckMarketEvent(trade[M5].Chart(), Convert::ValueToOp(curr_trend), C_MA_FAST_SLOW_OPP);
    case C_MA15_FS_TREND_OPP:
      return CheckMarketEvent(trade[M15].Chart(), Convert::ValueToOp(curr_trend), C_MA_FAST_SLOW_OPP);
    case C_MA30_FS_TREND_OPP:
      return CheckMarketEvent(trade[M30].Chart(), Convert::ValueToOp(curr_trend), C_MA_FAST_SLOW_OPP);
    case C_MA1_FS_ORDERS_OPP: // MA Fast and Slow M1 are in opposite directions.
      return CheckMarketEvent(trade[M1].Chart(), GetCmdByOrders(), C_MA_FAST_SLOW_OPP);
    case C_MA5_FS_ORDERS_OPP: // MA Fast and Slow M5 are in opposite directions.
      return CheckMarketEvent(trade[M5].Chart(), GetCmdByOrders(), C_MA_FAST_SLOW_OPP);
    case C_MA15_FS_ORDERS_OPP:
      return CheckMarketEvent(trade[M15].Chart(), GetCmdByOrders(), C_MA_FAST_SLOW_OPP);
    case C_MA30_FS_ORDERS_OPP:
      return CheckMarketEvent(trade[M30].Chart(), GetCmdByOrders(), C_MA_FAST_SLOW_OPP);
    case C_DAILY_PEAK:
      return hour_of_day >= HourAfterPeak && (market.GetLastAsk() >= _chart.iHigh(_Symbol, PERIOD_D1, CURR) || market.GetLastAsk() <= _chart.iLow(_Symbol, PERIOD_D1, CURR));
    case C_WEEKLY_PEAK:
      return hour_of_day >= HourAfterPeak && (market.GetLastAsk() >= _chart.iHigh(_Symbol, PERIOD_W1, CURR) || market.GetLastAsk() <= _chart.iLow(_Symbol, PERIOD_W1, CURR));
    case C_MONTHLY_PEAK:
      return hour_of_day >= HourAfterPeak && (market.GetLastAsk() >= _chart.iHigh(_Symbol, PERIOD_MN1, CURR) || market.GetLastAsk() <= _chart.iLow(_Symbol, PERIOD_MN1, CURR));
    case C_MARKET_AT_HOUR:
      {
        static int hour_invoked = -1;
        if (MarketSpecificHour == hour_of_day && hour_invoked <= hour_of_day) {
          // Invoke only once a day.
          hour_invoked = hour_of_day + 1;
          return (true);
        } else {
          if (hour_of_day < hour_invoked) {
            // Reset hour on the next day.
            hour_invoked = -1;
          }
          return (false);
        }
      }
    case C_NEW_HOUR:
      return hour_of_day != DateTime::Hour();
    case C_NEW_DAY:
      return day_of_week != DateTime::DayOfWeek();
    case C_NEW_WEEK:
      return DateTime::DayOfWeek() < day_of_week;
    case C_NEW_MONTH:
      return DateTime::Day() < day_of_month;
    case C_MARKET_NONE:
    default:
      return false;
  }
  return false;
}

/**
 * Check the account for configured conditions.
 */
void CheckAccConditions(Chart *_chart) {
  datetime _last_check = 0;
  if (!Account_Conditions_Active || _last_check > DateTime::TimeTradeServer() - 10) {
    // Do not execute action more often than 10 seconds.
    //Print("_last_check > Time - 10", _last_check, " ", DateTime::TimeTradeServer());
    return;
  }
  _last_check = DateTime::TimeTradeServer();

  #ifdef __profiler__ PROFILER_START #endif

  bool result = false;
  int i;
  for (i = 0; i < ArrayRange(acc_conditions, 0); i++) {
    if (AccCondition(acc_conditions[i][0]) && MarketCondition(_chart, acc_conditions[i][1]) && acc_conditions[i][2] != A_NONE) {
      ActionExecute(acc_conditions[i][2], i);
    }
  } // end: for
  #ifdef __profiler__ PROFILER_STOP #endif
}

/**
 * Get default multiplier lot factor.
 */
double GetDefaultProfitFactor() {
  return 1.0;
}

/* BEGIN: STRATEGY FUNCTIONS */

/**
 * Calculate lot size for specific strategy.
 */
double GetStrategyLotSize(int sid, ENUM_ORDER_TYPE cmd) {
  double trade_lot = (conf[sid][LOT_SIZE] > 0 ? conf[sid][LOT_SIZE] : ea_lot_size) * (conf[sid][FACTOR] > 0 ? conf[sid][FACTOR] : 1.0);
  if (Boosting_Enabled) {
    double pf = GetStrategyProfitFactor(sid);
    if (pf > 0) {
      if (StrategyBoostByPF && pf > 1.0) trade_lot *= fmax(GetStrategyProfitFactor(sid), 1.0);
      else if (StrategyHandicapByPF && pf < 1.0) trade_lot *= fmin(GetStrategyProfitFactor(sid), 1.0);
    }
    if (Convert::ValueToOp(curr_trend) == cmd && BoostTrendFactor != 1.0) {
      if (VerboseDebug) PrintFormat("%s:%d: %s: Factor: %g, Trade lot: %g, Final trade lot: %g",
        __FUNCTION__, __LINE__, ((Strategy *) strats.GetById(sid)).GetName(), conf[sid][FACTOR], trade_lot, trade_lot * BoostTrendFactor);
      trade_lot *= BoostTrendFactor;
    }
  }
  return market.NormalizeLots(trade_lot);
}

/**
 * Get strategy comment for opened order.
 */
string GetStrategyComment(Strategy *_strat) {
  return StringFormat("%s; %.1f pips spread; sid: %d", _strat.GetName(), curr_spread, _strat.GetId());
}

/**
 * Get strategy report based on the total orders.
 */
string GetStrategyReport(string sep = "\n") {
  string output = "Strategy stats:" + sep;
  Strategy *_strat;
  int id, sid;
  for (sid = 0; sid < strats.GetSize(); sid++) {
    _strat = ((Strategy *) strats.GetByIndex(sid));
    id = (int) _strat.GetId();
    if (info[id][TOTAL_ORDERS] > 0) {
      output += StringFormat("Profit factor: %.2f, ",
                GetStrategyProfitFactor(id));
      output += StringFormat("Total net profit: %.2f%s [%+.2f/%-.2f] (%.2fpips), ",
        stats[id][TOTAL_NET_PROFIT], account.GetCurrency(),
        stats[id][TOTAL_GROSS_PROFIT], stats[id][TOTAL_GROSS_LOSS],
        stats[id][TOTAL_PIP_PROFIT]);
      output += StringFormat("Total orders: %d (Won: %.1f%% [%d] / Loss: %.1f%% [%d])",
                info[id][TOTAL_ORDERS],
                (100 / NormalizeDouble(info[id][TOTAL_ORDERS], 2)) * info[id][TOTAL_ORDERS_WON],
                info[id][TOTAL_ORDERS_WON],
                (100 / NormalizeDouble(info[id][TOTAL_ORDERS], 2)) * info[id][TOTAL_ORDERS_LOSS],
                info[id][TOTAL_ORDERS_LOSS]);
      output += info[id][TOTAL_ERRORS] > 0 ? StringFormat(", Errors: %d", info[id][TOTAL_ERRORS]) : "";
      output += StringFormat(" - %s", _strat.GetName());
      output += sep;
    }
  }
  return output;
}

/**
 * Apply strategy boosting.
 */
void UpdateStrategyFactor(uint period) {
  switch (period) {
    case DAILY:
      ApplyStrategyMultiplierFactor(DAILY, 1, BestDailyStrategyMultiplierFactor);
      ApplyStrategyMultiplierFactor(DAILY, -1, WorseDailyStrategyMultiplierFactor);
      break;
    case WEEKLY:
      if (day_of_week > 1) {
        // FIXME: When commented out with 1.0, the profit is different.
        ApplyStrategyMultiplierFactor(WEEKLY, 1, BestWeeklyStrategyMultiplierFactor);
        ApplyStrategyMultiplierFactor(WEEKLY, -1, WorseWeeklyStrategyMultiplierFactor);
      }
    break;
    case MONTHLY:
      ApplyStrategyMultiplierFactor(MONTHLY, 1, BestMonthlyStrategyMultiplierFactor);
      ApplyStrategyMultiplierFactor(MONTHLY, -1, WorseMonthlyStrategyMultiplierFactor);
    break;
  }
}

/**
 * Update strategy lot size.
 */
void UpdateStrategyLotSize() {
  int i;
  for (i = 0; i < ArrayRange(conf, 0); i++) {
    conf[i][LOT_SIZE] = ea_lot_size * conf[i][FACTOR];
  }
}

/**
 * Calculate strategy profit factor.
 */
double GetStrategyProfitFactor(int sid) {
  if (info[sid][TOTAL_ORDERS] > InitNoOfOrdersToCalcPF && stats[sid][TOTAL_GROSS_LOSS] < 0) {
    return stats[sid][TOTAL_GROSS_PROFIT] / -stats[sid][TOTAL_GROSS_LOSS];
  } else {
    return 1.0; // @todo?
  }
}

/**
 * Fetch strategy signal level based on the indicator and timeframe.
 */
double GetStrategySignalLevel(ENUM_INDICATOR_TYPE _indicator, ENUM_TIMEFRAMES _tf, double _default = 0.0) {
  DEBUG_CHECKPOINT_ADD
  bool _found = false;
  double _result = _default;
  int sid;
  Strategy *_strat;
  for (sid = 0; sid < strats.GetSize(); sid++) {
    _strat = ((Strategy *) strats.GetByIndex(sid));
    if (_strat.Data().GetIndicatorType() == _indicator && _strat.GetTf() == _tf) {
      _result = _strat.GetSignalLevel1();
      _found = true;
      break;
    }
  }

  if (VerboseDebug && !_found) {
    Msg::ShowText(
      StringFormat("Cannot find signal level via indicator %d (%s) for timeframe: %d", _indicator, EnumToString(_indicator), _tf),
      "Error", __FUNCTION__, __LINE__, VerboseErrors | VerboseDebug
      );
    DEBUG_STACK_PRINT
  }

  DEBUG_CHECKPOINT_POP
  return _result;
}

/**
 * Fetch strategy signal level based on the indicator and timeframe.
 */
ulong GetStrategySignalMethod(ENUM_INDICATOR_TYPE _indicator, ENUM_TIMEFRAMES _tf, ulong _default = 0) {
  DEBUG_CHECKPOINT_ADD
  ulong _result = _default;
  bool _found = false;
  int sid;
  Strategy *_strat;
  for (sid = 0; sid < strats.GetSize(); sid++) {
    _strat = ((Strategy *) strats.GetByIndex(sid));
    if (_strat.Data().GetIndicatorType() == _indicator && _strat.GetTf() == _tf) {
      _result = _strat.GetSignalOpenMethod1();
      _found = true;
      break;
    }
  }

  if (VerboseDebug && !_found) {
    Msg::ShowText(
      StringFormat("Cannot find signal method via indicator %d (%s) for timeframe: %d", _indicator, EnumToString(_indicator), _tf),
      "Error", __FUNCTION__, __LINE__, VerboseErrors | VerboseDebug
      );
    DEBUG_STACK_PRINT
  }

  DEBUG_CHECKPOINT_POP
  return _result;
}

/**
 * Fetch strategy timeframe based on the strategy type.
 */
ENUM_TIMEFRAMES GetStrategyTimeframe(uint _sid) {
  Strategy *_strat = strats.GetById(_sid);
  return _strat.GetTf();
}

/**
 * Get strategy id based on the indicator and tf.
 */
unsigned long GetStrategyViaIndicator(ENUM_INDICATOR_TYPE _indicator, ENUM_TIMEFRAMES _tf) {
  DEBUG_CHECKPOINT_ADD
  bool _found = false;
  int _id;
  unsigned long _result = EMPTY;
  Strategy *_strat;
  for (_id = 0; _id < strats.GetSize(); _id++) {
    _strat = ((Strategy *) strats.GetByIndex(_id));
    if (_strat.Data().GetIndicatorType() == _indicator && _strat.GetTf() == _tf) {
      _result = _strat.GetId();
      _found = true;
      break;
    }
  }

  if (!_found) {
    Msg::ShowText(
      StringFormat("Cannot find indicator %d (%s) for timeframe: %d", _indicator, EnumToString(_indicator), _tf),
      "Error", __FUNCTION__, __LINE__, VerboseErrors | VerboseDebug
      );
    DEBUG_STACK_PRINT
  }

  DEBUG_CHECKPOINT_POP
  return _result;
}

/**
 * Calculate total strategy profit.
 */
double GetTotalProfit() {
  double total_profit = 0;
  int id;
  for (id = 0; id < ArrayRange(stats, 0); id++) {
    total_profit += stats[id][TOTAL_NET_PROFIT];
  }
  return total_profit;
}

int GetMaxStrategyValue(int key2) {
  return GetPeakStrategyValue(key2, false);
}

int GetMinStrategyValue(int key2) {
  return GetPeakStrategyValue(key2, true);
}

int GetPeakStrategyValue(int key2, bool lowest) {
  int i;
  int key1 = EMPTY;
  double peak = lowest ? 999 : -999;
  for (i = 0; i < ArrayRange(stats, 0); i++) {
    if (!((Strategy*)strats.GetById(i)).IsEnabled()) {
      continue;
    }

    if ((lowest && stats[i][key2] < peak) || (!lowest && stats[i][key2] > peak)) {
      peak = stats[i][key2];
      key1 = i;
    }
  }
  return key1;
}


/**
 * Apply strategy multiplier factor based on the strategy profit or loss.
 */
void ApplyStrategyMultiplierFactor(uint period = DAILY, int direction = 0, double factor = 1.0) {
  if (GetNoOfStrategies() <= 1 || factor == 1.0) return;
  int key = period == MONTHLY ? MONTHLY_PROFIT : (period == WEEKLY ? (int)WEEKLY_PROFIT : (int)DAILY_PROFIT);
  string period_name = period == MONTHLY ? "montly" : (period == WEEKLY ? "weekly" : "daily");
  int new_strategy = direction <= 0 ? GetMinStrategyValue(key) : GetMaxStrategyValue(key);
  if (new_strategy == EMPTY) return;
  int previous = direction > 0 ? best_strategy[period] : worse_strategy[period];
  double new_factor = 1.0;
  Strategy *new_strat = ((Strategy *) strats.GetById(new_strategy));
  Strategy *prev_strat = previous != EMPTY ? ((Strategy *) strats.GetById(previous)) : NULL;
  if (direction > 0) { // Best strategy.
    if (new_strat.IsEnabled() && stats[new_strategy][key] > 10 && new_strategy != previous) { // Check if it's different than the previous one.
      if (previous != EMPTY) {
        prev_strat.Enabled();
        conf[previous][FACTOR] = GetDefaultProfitFactor(); // Set previous strategy multiplier factor to default.
        Msg::ShowText(StringFormat("Setting multiplier factor to default for strategy: %g", previous), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      }
      best_strategy[period] = new_strategy; // Assign the new worse strategy.
      new_strat.Enabled();
      new_factor = GetDefaultProfitFactor() * factor;
      conf[new_strategy][FACTOR] = new_factor; // Apply multiplier factor for the new strategy.
     Msg::ShowText(StringFormat("Setting multiplier factor to %g for strategy: %d (period: %s)", new_factor, new_strategy, period_name), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    }
  } else { // Worse strategy.
    if (new_strat.IsEnabled() && stats[new_strategy][key] < 10 && new_strategy != previous) { // Check if it's different than the previous one.
      if (previous != EMPTY) {
        prev_strat.Enabled();
        conf[previous][FACTOR] = GetDefaultProfitFactor(); // Set previous strategy multiplier factor to default.
        Msg::ShowText(StringFormat("Setting multiplier factor to default for strategy: %g to default.", previous), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      }
      worse_strategy[period] = new_strategy; // Assign the new worse strategy.
      if (factor > 0) {
        new_factor = GetDefaultProfitFactor() * factor;
        new_strat.Enabled();
        conf[new_strategy][FACTOR] = new_factor; // Apply multiplier factor for the new strategy.
        Msg::ShowText(StringFormat("Setting multiplier factor to %g for strategy: %d (period: %s)", new_factor, new_strategy, period_name), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      } else {
        new_strat.Enabled(false);
        //conf[new_strategy][FACTOR] = GetDefaultProfitFactor();
        Msg::ShowText(StringFormat("Disabling strategy: %d", new_strategy), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      }
    }
  }
}

/**
 * Return strategy id by order magic number.
 */
int GetIdByMagic(int magic = -1) {
  if (magic == -1) magic = (int) Order::OrderMagicNumber();
  int id = magic - MagicNumber;
  return CheckOurMagicNumber(magic) ? id : -1;
}

/* END: STRATEGY FUNCTIONS */

/* BEGIN: DISPLAYING FUNCTIONS */

/**
 * Get text output of hourly profit report.
 */
string GetHourlyProfit(string sep = ", ") {
  #ifdef __MQL4__
  string output = StringFormat("Hourly profit (total: %.1fp): ", Array::GetArrSumKey1(hourly_profit, day_of_year));
  #else
  // @fixme
  string output = "Hourly profit (total: @fixme): ";
  #endif
  int h;
  for (h = 0; h < hour_of_day; h++) {
    output += StringFormat("%d: %.1fp%s", h, hourly_profit[day_of_year][h], h < hour_of_day ? sep : "");
  }
  return output;
}

/**
 * Get text output of daily report.
 */
string GetDailyReport() {
  string output = "Daily max: ";
  // output += "Low: "     + daily[MAX_LOW] + "; ";
  // output += "High: "    + daily[MAX_HIGH] + "; ";
  // output += StringFormat("Tick: %g; ", daily[MAX_TICK]);
  // output += "Drop: "    + daily[MAX_DROP] + "; ";
  output += StringFormat("Spread: %g pts; ",   daily[MAX_SPREAD]);
  output += StringFormat("Max opened orders: %.0f; ", daily[MAX_ORDERS]);
  output += StringFormat("Loss: %.2f; ",       daily[MAX_LOSS]);
  output += StringFormat("Profit: %.2f; ",     daily[MAX_PROFIT]);
  output += StringFormat("Equity: %.2f; ",     daily[MAX_EQUITY]);
  output += StringFormat("Balance: %.2f; ",    daily[MAX_BALANCE]);

  //output += GetAccountTextDetails() + "; " + GetOrdersStats();

  int key;
  key = GetMaxStrategyValue(DAILY_PROFIT);
  if (key >= 0 && stats[key][DAILY_PROFIT] > 0) {
    output += StringFormat("Best: %s (%.2fp)", ((Strategy *) strats.GetById(key)).GetName(), stats[key][DAILY_PROFIT]);
  }
  key = GetMinStrategyValue(DAILY_PROFIT);
  if (key >= 0 && stats[key][DAILY_PROFIT] < 0) {
    output += StringFormat("Worse: %s (%.2fp)", ((Strategy *) strats.GetById(key)).GetName(), stats[key][DAILY_PROFIT]);
  }

  return output;
}

/**
 * Get text output of weekly report.
 */
string GetWeeklyReport() {
  string output = "Weekly max: ";
  // output =+ GetAccountTextDetails() + "; " + GetOrdersStats();
  // output += "Low: "     + weekly[MAX_LOW] + "; ";
  // output += "High: "    + weekly[MAX_HIGH] + "; ";
  // output += StringFormat("Tick: %g; ", weekly[MAX_TICK]);
  // output += "Drop: "    + weekly[MAX_DROP] + "; ";
  output += StringFormat("Spread: %g pts; ",   weekly[MAX_SPREAD]);
  output += StringFormat("Max opened orders: %.0f; ", weekly[MAX_ORDERS]);
  output += StringFormat("Loss: %.2f; ",       weekly[MAX_LOSS]);
  output += StringFormat("Profit: %.2f; ",     weekly[MAX_PROFIT]);
  output += StringFormat("Equity: %.2f; ",     weekly[MAX_EQUITY]);
  output += StringFormat("Balance: %.2f; ",    weekly[MAX_BALANCE]);

  int key;
  key = GetMaxStrategyValue(WEEKLY_PROFIT);
  if (key >= 0 && stats[key][WEEKLY_PROFIT] > 0) {
    output += StringFormat("Best: %s (%.2fp)", ((Strategy *) strats.GetById(key)).GetName(), stats[key][WEEKLY_PROFIT]);
  }
  key = GetMinStrategyValue(WEEKLY_PROFIT);
  if (key >= 0 && stats[key][WEEKLY_PROFIT] < 0) {
    output += StringFormat("Worse: %s (%.2fp)", ((Strategy *) strats.GetById(key)).GetName(), stats[key][WEEKLY_PROFIT]);
  }

  return output;
}

/**
 * Get text output of monthly report.
 */
string GetMonthlyReport() {
  string output = "Monthly max: ";
  // output =+ GetAccountTextDetails() + "; " + GetOrdersStats();
  // output += "Low: "     + monthly[MAX_LOW] + "; ";
  // output += "High: "    + monthly[MAX_HIGH] + "; ";
  // output += StringFormat("Tick: %g; ", monthly[MAX_TICK]);
  // output += "Drop: "    + monthly[MAX_DROP] + "; ";
  output += StringFormat("Spread: %g pts; ",   monthly[MAX_SPREAD]);
  output += StringFormat("Max opened orders: %.0f; ", monthly[MAX_ORDERS]);
  output += StringFormat("Loss: %.2f; ",       monthly[MAX_LOSS]);
  output += StringFormat("Profit: %.2f; ",     monthly[MAX_PROFIT]);
  output += StringFormat("Equity: %.2f; ",     monthly[MAX_EQUITY]);
  output += StringFormat("Balance: %.2f; ",    monthly[MAX_BALANCE]);

  int key;
  key = GetMaxStrategyValue(MONTHLY_PROFIT);
  if (key >= 0 && stats[key][MONTHLY_PROFIT] > 0) {
    output += StringFormat("Best: %s (%.2fp)", ((Strategy *) strats.GetById(key)).GetName(), stats[key][MONTHLY_PROFIT]);
  }
  key = GetMinStrategyValue(MONTHLY_PROFIT);
  if (key >= 0 && stats[key][MONTHLY_PROFIT] < 0) {
    output += StringFormat("Worse: %s (%.2fp)", ((Strategy *) strats.GetById(key)).GetName(), stats[key][MONTHLY_PROFIT]);
  }

  return output;
}

/**
 * Display info on chart.
 */
string DisplayInfoOnChart(bool on_chart = true, string sep = "\n") {
  if (terminal.IsOptimization() || (terminal.IsTesting() && !terminal.IsVisualMode())) {
    // Ignore chart updates when optimizing or testing in non-visual mode.
    return NULL;
  }

  datetime _last_check = 0;
  if (_last_check > DateTime::TimeTradeServer() - 10) {
    //Print("last_check < Time - 10", _last_check, " ", DateTime::TimeTradeServer());
    return NULL;
  }
  _last_check = DateTime::TimeTradeServer();

  string output;
  // Prepare text for Stop Out.
  string stop_out_level = StringFormat("%d", account.AccountStopoutLevel());
  if (account.AccountStopoutMode() == 0) stop_out_level += "%"; else stop_out_level += account.AccountCurrency();
  stop_out_level += StringFormat(" (%.1f)", account.GetAccountStopoutLevel());
  // Prepare text to display max orders.
  string text_max_orders = StringFormat("Max orders: %d [Per type: %d]", max_orders, GetMaxOrdersPerType());
  #ifdef __advanced__
    if (MaxOrdersPerDay > 0) text_max_orders += StringFormat(" [Per day: %d]", MaxOrdersPerDay);
  #endif
  // Prepare text to display spread.
  string text_spread = StringFormat("Spread: %.1f pips (%d pts)", market.GetSpreadInPips(), market.GetSpreadInPts());
  // Check trend.
  string trend = "Neutral";
  if (Convert::ValueToOp(curr_trend) == ORDER_TYPE_BUY) trend = "Bullish";
  if (Convert::ValueToOp(curr_trend) == ORDER_TYPE_SELL) trend = "Bearish";
  if (fabs(curr_trend) > 0.3) trend = "Strong " + trend;
  trend += StringFormat(" (%-.1f)", curr_trend);
  // EA text.
  string ea_text = StringFormat("%s v%s", ea_name, ea_version);
  // Print actual info.
  string indent = "";
  indent = "                      ";
  output = indent + "------------------------------------------------" + sep
                  + indent + StringFormat("| %s (Status: %s)%s", ea_text, (ea_active ? "ACTIVE" : "NOT ACTIVE"), sep)
                  + indent + StringFormat("| ACCOUNT INFORMATION:%s", sep)
                  + indent + StringFormat("| Server Name: %s, Time: %s%s", AccountInfoString(ACCOUNT_SERVER), DateTime::TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS), sep)
                  + indent + "| Acc Number: " + IntegerToString(account.AccountNumber()) + "; Acc Name: " + account.AccountName() + "; Broker: " + account.AccountCompany() + " (Type: " + account_type + ")" + sep
                  + indent + StringFormat("| Stop Out Level: %s, Leverage: 1:%d %s", stop_out_level, account.AccountLeverage(), sep)
                  + indent + "| Used Margin: " + Convert::ValueWithCurrency(account.AccountMargin()) + "; Free: " + Convert::ValueWithCurrency(account.AccountFreeMargin()) + sep
                  + indent + "| Equity: " + Convert::ValueWithCurrency(account.AccountEquity())
                     + "; Balance: " + Convert::ValueWithCurrency(account.AccountBalance())
                     + (account.AccountCredit() > 0 ? "; Credit: " + Convert::ValueWithCurrency(account.AccountCredit()) : "")
                     + sep
                  + indent + "| Lot size: " + DoubleToStr(ea_lot_size, market.GetVolumeDigits()) + "; " + text_max_orders + sep
                  + indent + "| Risk ratio: " + DoubleToStr(ea_risk_ratio, 1) + " (" + GetRiskRatioText() + ")" + sep
                  + indent + (RiskMarginTotal >= 0 ? StringFormat("| Risk margin level: Total: %.2f (Buy:%.2f, Sell:%.2f)", ea_margin_risk_level[2], ea_margin_risk_level[ORDER_TYPE_BUY], ea_margin_risk_level[ORDER_TYPE_SELL]) : "| Risk margin level: Disabled") + sep
                  + indent + "| " + GetOrdersStats("" + sep + indent + "| ") + "" + sep
                  + indent + "| Last error: " + last_err + "" + sep
                  + indent + "| Last message: " + last_msg + "" + sep
                  + indent + "| ------------------------------------------------" + sep
                  + indent + "| MARKET INFORMATION:" + sep
                  + indent + "| " + text_spread + "" + sep
                  + indent + "| Trend: " + trend + "" + sep
                  // + indent // + "Mini lot: " + MarketInfo(Symbol(), MODE_MINLOT) + "" + sep
                  + indent + "| ------------------------------------------------" + sep
                  + indent + "| STATISTICS:" + sep
                  + indent + "| " + GetHourlyProfit() + "" + sep
                  + indent + "| " + GetDailyReport() + "" + sep
                  + indent + "| " + GetWeeklyReport() + "" + sep
                  + indent + "| " + GetMonthlyReport() + "" + sep
                  + indent + "------------------------------------------------" + sep
                  ;
  if (on_chart) {
    /* FIXME: Text objects can't contain multi-line text so we need to create a separate object for each line instead.
    ObjectCreate(ea_name, OBJ_LABEL, 0, 0, 0, 0); // Create text object with given name.
    // Set pixel co-ordinates from top left corner (use OBJPROP_CORNER to set a different corner).
    ObjectSet(ea_name, OBJPROP_XDISTANCE, 0);
    ObjectSet(ea_name, OBJPROP_YDISTANCE, 10);
    ObjectSetText(ea_name, output, 10, "Arial", Red); // Set text, font, and colour for object.
    // ObjectDelete(ea_name);
    */
    Comment(output);
    ChartRedraw(); // Redraws the current chart forcedly.
  }
  return output;
}

/**
 * Get order statistics in percentage for each strategy.
 */
string GetOrdersStats(string sep = "\n") {
  // Prepare text for Total Orders.
  string total_orders_text = StringFormat("Open Orders: %d", total_orders);
  total_orders_text += StringFormat(" +%d/-%d", Orders::GetOrdersByType(ORDER_TYPE_BUY),  Orders::GetOrdersByType(ORDER_TYPE_SELL));
  total_orders_text += StringFormat(" [%.2f lots]", Orders::GetOpenLots(_Symbol, MagicNumber, FINAL_STRATEGY_TYPE_ENTRY));
  total_orders_text += StringFormat(" (other: %d)", GetTotalOrders(false));
  // Prepare data about open orders per strategy type.
  string orders_per_type = "Stats: "; // Display open orders per type.
  if (total_orders > 0) {
    Strategy *_strat;
    int i, sid;
    for (i = 0; i < strats.GetSize(); i++) {
      _strat = ((Strategy *) strats.GetByIndex(i));
      sid = (int) _strat.GetId();
      if (open_orders[sid] > 0) {
        orders_per_type += StringFormat("%s: %.1f%% ", _strat.GetName(), MathFloor(100 / total_orders * open_orders[sid]));
      }
    }
  } else {
    orders_per_type += "No orders open yet.";
  }
  return orders_per_type + sep + total_orders_text;
}

/**
 * Get information about account conditions in text format.
 * @todo: Use Account instead.
 * @todo: "No of Orders: ", total_orders, " (BUY/SELL: ", Orders::GetOrdersByType(ORDER_TYPE_BUY), "/", Orders::GetOrdersByType(ORDER_TYPE_SELL), ")", sep,
 */
string GetAccountTextDetails(string sep = "; ") {
  return StringFormat("ACCOUNT: Time: %s; Balance: %s; Equity: %s; Credit: %s; Margin Used/Free: %s/%s; Risk: %s;",
     DateTime::TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS),
     Convert::ValueWithCurrency(account.AccountBalance()),
     Convert::ValueWithCurrency(account.AccountEquity()),
     Convert::ValueWithCurrency(account.AccountCredit()),
     Convert::ValueWithCurrency(account.AccountMargin()),
     Convert::ValueWithCurrency(account.AccountFreeMargin()),
     DoubleToStr(ea_risk_ratio, 1)
  );
}

/**
 * Get information about market conditions in text format.
 * @todo: Use Market instead.
 */
string GetMarketTextDetails() {
  return StringFormat("MARKET: Symbol: %s; Ask: %s; Bid: %s; Spread: %gpts (%.2f pips);",
    Symbol(), DoubleToStr(chart.GetAsk(), Digits), DoubleToStr(chart.Bid(), Digits),
    market.GetSpreadInPts(), market.GetSpreadInPips()
  );
}

/**
 * Get account summary text.
 */
string GetSummaryText() {
  return GetAccountTextDetails();
}

/**
 * Get risk ratio text based on the value.
 */
string GetRiskRatioText() {
  string text = "Normal";
  if (RiskRatio != 0.0 && ea_risk_ratio < 0.9) text = "Set low manually";
  else if (RiskRatio != 0.0 && ea_risk_ratio > 1.9) text = "Set high manually";
  else if (ea_risk_ratio < 0.2) text = "Extremely risky!";
  else if (ea_risk_ratio < 0.3) text = "Very risky!";
  else if (ea_risk_ratio < 0.5) text = "Risky!";
  else if (ea_risk_ratio < 0.9) text = "Below normal, but ok";
  else if (ea_risk_ratio > 5.0) text = "Extremely high (risky!)";
  else if (ea_risk_ratio > 2.0) text = "Very high";
  else if (ea_risk_ratio > 1.4) text = "High";
  #ifdef __advanced__
    if (StringLen(rr_text) > 0) text += " - reason: " + rr_text;
  #endif
  return text;
}

/* END: DISPLAYING FUNCTIONS */

/* BEGIN: ACTION FUNCTIONS */

/**
 * Execute action to close the most profitable order.
 */
bool ActionCloseMostProfitableOrder(int reason_id = EMPTY, int min_profit = EMPTY){
  bool result = false;
  unsigned long selected_ticket = 0;
  double max_ticket_profit = 0, curr_ticket_profit = 0;
  int order;
  for (order = 0; order < Trade::OrdersTotal(); order++) {
    if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES))
     if (Order::OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
      curr_ticket_profit = Order::GetOrderTotalProfit();
       if (curr_ticket_profit > max_ticket_profit) {
         selected_ticket = Order::OrderTicket();
         max_ticket_profit = curr_ticket_profit;
       }
     }
  }

  if (selected_ticket > 0) {
    if (min_profit != EMPTY && max_ticket_profit < Account_Condition_MinProfitCloseOrder) { return (false); }
    last_close_profit = max_ticket_profit;
    return TaskAddCloseOrder(selected_ticket, reason_id);
  } else if (VerboseTrace) {
    Print(__FUNCTION__ + ": Can't find any profitable order.");
  }
  return (false);
}

/**
 * Execute action to close most unprofitable order.
 */
bool ActionCloseMostUnprofitableOrder(int reason_id = EMPTY){
  double ticket_profit = 0;
  int order;
  unsigned long selected_ticket = 0;
  for (order = 0; order < Trade::OrdersTotal(); order++) {
    if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES))
     if (Order::OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if (Order::GetOrderTotalProfit() < ticket_profit) {
         selected_ticket = Order::OrderTicket();
         ticket_profit = Order::GetOrderTotalProfit();
       }
     }
  }

  if (selected_ticket > 0) {
    last_close_profit = ticket_profit;
    return TaskAddCloseOrder(selected_ticket, reason_id);
  } else if (VerboseDebug) {
    logger.Error("Can't find any unprofitable order as requested.", __FUNCTION__);
  }
  return (false);
}

/**
 * Execute action to close all profitable orders.
 */
bool ActionCloseAllProfitableOrders(int reason_id = EMPTY){
  bool result = false;
  int order, selected_orders = 0;
  double ticket_profit = 0, total_profit = 0;
  for (order = 0; order < Trade::OrdersTotal(); order++) {
    if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && Order::OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = Order::GetOrderTotalProfit();
       if (ticket_profit > 0) {
         result = TaskAddCloseOrder(Order::OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    Msg::ShowText(StringFormat("Queued %d orders to close with expected profit of %g pips.", selected_orders, total_profit)
    , "Info", __FUNCTION__, __LINE__, VerboseInfo);
  }
  return (result);
}

/**
 * Execute action to close all unprofitable orders.
 */
bool ActionCloseAllUnprofitableOrders(int reason_id = EMPTY){
  bool result = false;
  int selected_orders = 0;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < Trade::OrdersTotal(); order++) {
    if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && Order::OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = Order::GetOrderTotalProfit();
       if (ticket_profit < 0) {
         result = TaskAddCloseOrder(Order::OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    Msg::ShowText(StringFormat("Queued %d orders to close with expected loss of %g pips.", selected_orders, total_profit)
    , "Info", __FUNCTION__, __LINE__, VerboseInfo);
  }
  return (result);
}

/**
 * Execute action to close all orders by specified type.
 */
bool ActionCloseAllOrdersByType(ENUM_ORDER_TYPE cmd = EMPTY, int reason_id = EMPTY){
  if (cmd == EMPTY) return (false);
  #ifdef __profiler__ PROFILER_START #endif
  int selected_orders = 0;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < Trade::OrdersTotal(); order++) {
    if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && Order::OrderSymbol() == Symbol() && CheckOurMagicNumber())
       if (Order::OrderType() == cmd) {
         TaskAddCloseOrder(Order::OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    Msg::ShowText(StringFormat("Queued %d orders to close with expected profit of %g pips.", selected_orders, total_profit)
    , "Info", __FUNCTION__, __LINE__, VerboseInfo);
  }
  #ifdef __profiler__ PROFILER_STOP #endif
  return (true);
}

/**
 * Execute action to close all orders.
 *
 * Notes:
 * - Useful when equity is low or high in order to secure our assets and avoid higher risk.
 * - Executing this action could indicate our poor money management and risk further losses.
 *
 * Parameter: only_ours
 *   When true (default), we should close only ours orders (determined by our magic number).
 *   When false, we should close all orders (including other stragegies if any).
 *     This is due the account equity and balance are shared,
 *     so potentially we don't know which strategy generated this kind of situation,
 *     therefore closing all make the things more predictable and to avoid any suprices.
 */
int ActionCloseAllOrders(int reason_id = EMPTY, bool only_ours = true) {
  #ifdef __profiler__ PROFILER_START #endif
   int processed = 0;
   int total = Trade::OrdersTotal();
   double total_profit = 0;
   for (int order = 0; order < total; order++) {
      if (Order::OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && Order::OrderSymbol() == Symbol() && Order::OrderTicket() > 0) {
         if (only_ours && !CheckOurMagicNumber()) continue;
         total_profit += Order::GetOrderTotalProfit();
         TaskAddCloseOrder(Order::OrderTicket(), reason_id); // Add task to re-try.
         processed++;
      } else {
         Msg::ShowText(StringFormat("Error: Order Pos: %d; Message: %s", order, terminal.GetLastErrorText()),
            "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      }
   }

   if (processed > 0) {
    last_close_profit = total_profit;
    Msg::ShowText(StringFormat("Queued %d orders out of %d for closure.", processed, total),
      "Info", __FUNCTION__, __LINE__, VerboseInfo);
   }
  #ifdef __profiler__ PROFILER_STOP #endif
   return (processed > 0);
}

/**
 * Execute action by its id. See: EA_Conditions parameters.
 *
 * @param int aid Action ID.
 * @param int id Condition ID.
 *
 * Note: Executing random actions can be potentially dangerous for the account if not used wisely.
 */
bool ActionExecute(int aid, int id = EMPTY) {
  DEBUG_CHECKPOINT_ADD
  #ifdef __profiler__ PROFILER_START #endif
  bool result = false;
  int mid = (id != EMPTY ? acc_conditions[id][1] : EMPTY); // Market id condition.
  int reason_id = (id != EMPTY ? acc_conditions[id][0] : EMPTY); // Account id condition.
  int sid;
  int i;
  ENUM_ORDER_TYPE cmd;

  switch (aid) {
    case A_NONE: /* 0 */
      result = true;
      if (VerboseTrace) PrintFormat("%s(): No action taken. Reason (id: %d): %s", __FUNCTION__, reason_id, ReasonIdToText(reason_id));
      // Nothing.
      break;
    case A_CLOSE_ORDER_PROFIT: /* 1 */
      result = ActionCloseMostProfitableOrder(reason_id);
      break;
    case A_CLOSE_ORDER_PROFIT_MIN: /* 2 */
      result = ActionCloseMostProfitableOrder(reason_id, Account_Condition_MinProfitCloseOrder);
      break;
    case A_CLOSE_ORDER_LOSS: /* 3 */
      result = ActionCloseMostUnprofitableOrder(reason_id);
      break;
    case A_CLOSE_ALL_IN_PROFIT: /* 4 */
      result = ActionCloseAllProfitableOrders(reason_id);
      break;
    case A_CLOSE_ALL_IN_LOSS: /* 5 */
      result = ActionCloseAllUnprofitableOrders(reason_id);
      break;
    case A_CLOSE_ALL_PROFIT_SIDE: /* 6 */
      // TODO
      cmd = GetProfitableSide();
      result = cmd != NULL ? ActionCloseAllOrdersByType(cmd, reason_id) : true;
      break;
    case A_CLOSE_ALL_LOSS_SIDE: /* 7 */
      cmd = GetProfitableSide();
      result = cmd != NULL ? ActionCloseAllOrdersByType(Order::NegateOrderType(cmd), reason_id) : true;
      break;
    case A_CLOSE_ALL_TREND: /* 8 */
      cmd = Convert::ValueToOp(curr_trend);
      result = cmd != NULL ? ActionCloseAllOrdersByType(cmd, reason_id) : true;
      break;
    case A_CLOSE_ALL_NON_TREND: /* 9 */
      cmd = Convert::ValueToOp(curr_trend);
      result = cmd != NULL ? ActionCloseAllOrdersByType(Order::NegateOrderType(cmd), reason_id) : true;
      break;
    case A_CLOSE_ALL_ORDERS: /* 10 */
      result = ActionCloseAllOrders(reason_id);
      break;
    case A_SUSPEND_STRATEGIES: /* 11 */
      for (sid = 0; sid < strats.GetSize(); sid++) {
        ((Strategy *) strats.GetByIndex(sid)).Suspended(true);
      }
      result = true;
      break;
    case A_UNSUSPEND_STRATEGIES: /* 12 */
      for (sid = 0; sid < strats.GetSize(); sid++) {
        ((Strategy *) strats.GetByIndex(sid)).Suspended(false);
      }
      result = true;
      break;
    case A_RESET_STRATEGY_STATS: /* 13 */
      for (i = 0; i < ArrayRange(conf, 0); i++) {
        conf[i][PROFIT_FACTOR] = GetDefaultProfitFactor();
      }

      for (i = 0; i < ArrayRange(stats, 0); i++) {
        stats[i][TOTAL_GROSS_LOSS] = 0.0;
        stats[i][TOTAL_GROSS_PROFIT] = 0.0;
      }

      result = true;
      break;
      /*
    case A_RISK_REDUCE:
      result = ActionRiskReduce();
      break;
    case A_RISK_INCREASE:
      result = ActionRiskIncrease();
      break;
      */
      /*
    case A_ORDER_STOPS_DECREASE:
      // result = TightenStops();
      break;
    case A_ORDER_PROFIT_DECREASE:
      // result = TightenProfits();
      break;*/
    default:
      Msg::ShowText(
        StringFormat("Unknown action id: %d", aid),
        "Error", __FUNCTION__, __LINE__, VerboseErrors);
  }
  // reason = "Account condition: " + acc_conditions[i][0] + ", Market condition: " + acc_conditions[i][1] + ", Action: " + acc_conditions[i][2] + " [E: " + Convert::ValueWithCurrency(AccountEquity()) + "/B: " + Convert::ValueWithCurrency(AccountBalance()) + "]";

  TaskProcessList(TRUE); // Process task list immediately after action has been taken.
  Msg::ShowText(GetAccountTextDetails() + "; " + GetOrdersStats(), "Info", __FUNCTION__, __LINE__, VerboseInfo);
  if (result) {
    Msg::ShowText(
        StringFormat("Executed action: %s (id: %d), because of market condition: %s (id: %d) and account condition is: %s (id: %d) [E:%s/B:%s/C:%s/P:%sp].",
          ActionIdToText(aid), aid, MarketIdToText(mid), mid, ReasonIdToText(reason_id), reason_id, Convert::ValueWithCurrency(account.AccountEquity()), Convert::ValueWithCurrency(account.AccountBalance()), Convert::ValueWithCurrency(account.AccountCredit()), DoubleToStr(last_close_profit, 1)),
        "Info", __FUNCTION__, __LINE__, VerboseInfo);
    Msg::ShowText(last_msg, "Debug", __FUNCTION__, __LINE__, VerboseDebug && aid != A_NONE);
    if (WriteReport && VerboseDebug) ReportAdd(GetLastMessage());
  } else {
    Msg::ShowText(
      StringFormat("Failed to execute action: %s (id: %d), condition: %s (id: %d).",
        ActionIdToText(aid), aid, ReasonIdToText(reason_id), reason_id),
      "Warning", __FUNCTION__, __LINE__, VerboseErrors);
  }
  #ifdef __profiler__ PROFILER_STOP #endif
  return result;
}

/**
 * Convert action id into text representation.
 */
string ActionIdToText(int aid) {
  string output = "Unknown";
  switch (aid) {
    case A_NONE:                   output = "None"; break;
    case A_CLOSE_ORDER_PROFIT:     output = "Close most profitable order"; break;
    case A_CLOSE_ORDER_PROFIT_MIN: output = "Close most profitable order (above MinProfitCloseOrder)"; break;
    case A_CLOSE_ORDER_LOSS:       output = "Close worse order"; break;
    case A_CLOSE_ALL_IN_PROFIT:    output = "Close all in profit"; break;
    case A_CLOSE_ALL_IN_LOSS:      output = "Close all in loss"; break;
    case A_CLOSE_ALL_PROFIT_SIDE:  output = "Close profit side"; break;
    case A_CLOSE_ALL_LOSS_SIDE:    output = "Close loss side"; break;
    case A_CLOSE_ALL_TREND:        output = "Close trend side"; break;
    case A_CLOSE_ALL_NON_TREND:    output = "Close non-trend side"; break;
    case A_CLOSE_ALL_ORDERS:       output = "Close all!"; break;
  }
  return output;
}

/**
 * Convert reason id into text representation.
 */
string ReasonIdToText(int rid, ENUM_MARKET_EVENT _market_event = C_EVENT_NONE) {
  string output = "Unknown";
  switch (rid) {
    case EMPTY: output = "Empty"; break;
    case R_NONE: output = "None (inactive)"; break;
    case R_TRUE: output = "Always true"; break;
    case R_EQUITY_20PC_HIGH: output = "Equity 20% high"; break;
    case R_EQUITY_10PC_HIGH: output = "Equity 10% high"; break;
    case R_EQUITY_05PC_HIGH: output = "Equity 5% high"; break;
    case R_EQUITY_01PC_HIGH: output = "Equity 1% high"; break;
    case R_EQUITY_01PC_LOW: output = "Equity 1% low"; break;
    case R_EQUITY_05PC_LOW: output = "Equity 5% low"; break;
    case R_EQUITY_10PC_LOW: output = "Equity 10% low"; break;
    case R_EQUITY_20PC_LOW: output = "Equity 20% low"; break;
    case R_MARGIN_USED_20PC: output = "20% Margin Used"; break;
    case R_MARGIN_USED_50PC: output = "50% Margin Used"; break;
    case R_MARGIN_USED_70PC: output = "70% Margin Used"; break;
    case R_MARGIN_USED_90PC: output = "90% Margin Used"; break;
    case R_NO_FREE_MARGIN: output = "No free margin"; break;
    case R_ACC_IN_LOSS: output = "Account in loss"; break;
    case R_ACC_IN_PROFIT: output = "Account in profit"; break;
    case R_DBAL_LT_WEEKLY: output = "Max. daily balance < max. weekly"; break;
    case R_DBAL_GT_WEEKLY: output = "Max. daily balance > max. weekly"; break;
    case R_WBAL_LT_MONTHLY: output = "Max. weekly balance < max. monthly"; break;
    case R_WBAL_GT_MONTHLY: output = "Max. weekly balance > max. monthly"; break;
    case R_ACC_IN_TREND: output = "Account in trend"; break;
    case R_ACC_IN_NON_TREND: output = "Account is against trend"; break;
    case R_ACC_CDAY_IN_PROFIT: output = "Current day in profit"; break;
    case R_ACC_CDAY_IN_LOSS: output = "Current day in loss"; break;
    case R_ACC_PDAY_IN_PROFIT: output = "Previous day in profit"; break;
    case R_ACC_PDAY_IN_LOSS: output = "Previous day in loss"; break;
    case R_ACC_MAX_ORDERS: output = "Maximum orders opened"; break;
    case R_ORDER_EXPIRED: output = "Order expired (CloseOrderAfterXHours)"; break;
    case R_OPPOSITE_SIGNAL: output = "Opposite signal"; break;
    case R_CLOSE_SIGNAL: output = StringFormat("Close method signal (%s)", EnumToString(_market_event)); break;
  }
  return output;
}

/**
 * Convert market id condition into text representation.
 */
string MarketIdToText(int mid) {
  string output = "Unknown";
  switch (mid) {
    case C_MARKET_NONE: output = "None"; break;
    case C_MARKET_TRUE: output = "Always true"; break;
    case C_MA1_FS_TREND_OPP: output = "MA1 Fast&Slow trend-based opposite"; break;
    case C_MA5_FS_TREND_OPP: output = "MA5 Fast&Slow trend-based opposite"; break;
    case C_MA15_FS_TREND_OPP: output = "MA15 Fast&Slow trend-based opposite"; break;
    case C_MA30_FS_TREND_OPP: output = "MA30 Fast&Slow trend-based opposite"; break;
    case C_MA1_FS_ORDERS_OPP: output = "MA1 Fast&Slow orders-based opposite"; break;
    case C_MA5_FS_ORDERS_OPP: output = "MA5 Fast&Slow orders-based opposite"; break;
    case C_MA15_FS_ORDERS_OPP: output = "MA15 Fast&Slow orders-based opposite"; break;
    case C_MA30_FS_ORDERS_OPP: output = "MA30 Fast&Slow orders-based opposite"; break;
    case C_DAILY_PEAK: output = "Daily peak price"; break;
    case C_WEEKLY_PEAK: output = "Weekly peak price"; break;
    case C_MONTHLY_PEAK: output = "Monthly peak price"; break;
    case C_MARKET_AT_HOUR: output = StringFormat("at specific %d hour", MarketSpecificHour); break;
  }
  return output;
}

/* END: ACTION FUNCTIONS */

/* BEGIN: TICKET LIST/HISTORY CHECK FUNCTIONS */

/**
 * Add ticket to list for further processing.
 * @todo: Move to Array class.
 */
bool TicketAdd(int ticket_no) {
  DEBUG_CHECKPOINT_ADD
  int i, slot = EMPTY;
  int size = ArraySize(tickets);
  // Check if ticket is already in the list and at the same time find the empty slot.
  for (i = 0; i < size; i++) {
    if (tickets[i] == ticket_no) {
      return (true); // Ticket already in the list.
    } else if (slot < 0 && tickets[i] == 0) {
      slot = i;
    }
  }
  // Resize array if slot has not been allocated.
  if (slot == EMPTY) {
    if (size < 1000) { // Set array hard limit to prevent memory leak.
      ArrayResize(tickets, size + 10);
      // ArrayFill(tickets, size - 1, ArraySize(tickets) - size - 1, 0);
      if (VerboseDebug) Print(__FUNCTION__ + ": Couldn't allocate Ticket slot, re-sizing the array. New size: ",  (size + 1), ", Old size: ", size);
      slot = size;
    }
    return (false); // Array exceeded hard limit, probably because of some memory leak.
  }

  tickets[slot] = ticket_no;
  return (true);
}

/**
 * Remove ticket from the list after it has been processed.
 */
bool TicketRemove(int ticket_no) {
  DEBUG_CHECKPOINT_ADD
  int i;
  for (i = 0; i < ArraySize(tickets); i++) {
    if (tickets[i] == ticket_no) {
      tickets[i] = 0; // Remove the ticket number from the array slot.
      return (true); // Ticket has been removed successfully.
    }
  }
  return (false);
}

/**
 * Process order history.
 * @todo: Move to class.
 */
bool CheckHistory() {
  double total_profit = 0;
  int pos;
  #ifdef __profiler__ PROFILER_START #endif
  for (pos = last_history_check; pos < account.OrdersHistoryTotal(); pos++) {
    if (!Order::OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)) continue;
    if (Order::OrderCloseTime() > last_history_check && CheckOurMagicNumber()) {
      total_profit =+ OrderCalc();
    }
  }
  hourly_profit[day_of_year][hour_of_day] = total_profit; // Update hourly profit.
  last_history_check = pos;
  #ifdef __profiler__ PROFILER_STOP #endif
  return (true);
}

/* END: TICKET LIST/HISTORY CHECK FUNCTIONS */

/* BEGIN: ORDER QUEUE FUNCTIONS */

/**
 * Process AI queue of orders to see if we can open any trades.
 */
bool OrderQueueProcess(int method = EMPTY, int filter = EMPTY) {
  DEBUG_CHECKPOINT_ADD
  bool result = true;
  int queue_size = OrderQueueCount();
  long sorted_queue[][2];
  int sid;
  ENUM_ORDER_TYPE cmd;
  datetime time;
  double volume;
  if (method == EMPTY) method = SmartQueueMethod;
  if (filter == EMPTY) filter = SmartQueueFilter;
  if (queue_size > 1) {
    int selected_qid = EMPTY, curr_qid = EMPTY;
    ArrayResize(sorted_queue, queue_size, 100);
    for (int i = 0; i < queue_size; i++) {
      curr_qid = OrderQueueNext(curr_qid);
      if (curr_qid == EMPTY) break;
      sorted_queue[i][0] = GetOrderQueueKeyValue((int) order_queue[curr_qid][Q_SID], method, curr_qid);
      sorted_queue[i][1] = curr_qid++;
    }
    // Sort array by first dimension (descending).
    #ifdef __MQL4__
    ArraySort(sorted_queue, WHOLE_ARRAY, 0, MODE_DESCEND);
    #else
    if (VerboseDebug) PrintFormat("%s: FIXME: ArraySort();", __FUNCTION_LINE__);
    // @fixme
    #endif
    for (int i = 0; i < queue_size; i++) {
      selected_qid = (int) sorted_queue[i][1];
      cmd = (ENUM_ORDER_TYPE) order_queue[selected_qid][Q_CMD];
      sid = (int) order_queue[selected_qid][Q_SID];
      time = (datetime) order_queue[selected_qid][Q_TIME];
      volume = GetStrategyLotSize(sid, cmd);
      if (!OpenOrderCondition(cmd, sid, time, filter)) continue;
      if (OpenOrderIsAllowed(cmd, strats.GetById(sid), volume)) {
        string comment = GetStrategyComment(strats.GetById(sid)) + " [AIQueued]";
        result &= ExecuteOrder(cmd, sid, volume, comment);
        break;
      }
    }
  }
  return result;
}

/**
 * Check for the market condition to filter out the order queue.
 */
bool OpenOrderCondition(ENUM_ORDER_TYPE cmd, int sid, datetime time, int method) {
  DEBUG_CHECKPOINT_ADD
  bool result = true;
  ENUM_TIMEFRAMES tf = GetStrategyTimeframe(sid);
  uint tfi = Chart::TfToIndex(tf);
  Chart *_chart = trade[tfi].Chart();
  uint qshift = _chart.GetBarShift(time, false); // Get the number of bars for the tf since queued.
  double qopen = _chart.GetOpen(tf, qshift);
  double qclose = _chart.GetClose(tf, qshift);
  double qhighest = _chart.GetPeakPrice(MODE_HIGH, qshift); // Get the high price since queued.
  double qlowest = _chart.GetPeakPrice(MODE_LOW, qshift); // Get the lowest price since queued.
  double diff = fmax(qhighest - _chart.GetOpen(), _chart.GetOpen() - qlowest);
  if (VerboseTrace) PrintFormat("%s(%s, %d, %s, %d)", __FUNCTION__, EnumToString(cmd), sid, DateTime::TimeToStr(time), method);
  if (method != 0) {
    if (METHOD(method,0)) result &= (cmd == ORDER_TYPE_BUY && qopen < _chart.GetOpen()) || (cmd == ORDER_TYPE_SELL && qopen > _chart.GetOpen());
    if (METHOD(method,1)) result &= (cmd == ORDER_TYPE_BUY && qclose < _chart.GetClose()) || (cmd == ORDER_TYPE_SELL && qclose > _chart.GetClose());
    if (METHOD(method,2)) result &= (cmd == ORDER_TYPE_BUY && qlowest < _chart.GetLow()) || (cmd == ORDER_TYPE_SELL && qlowest > _chart.GetLow());
    if (METHOD(method,3)) result &= (cmd == ORDER_TYPE_BUY && qhighest > _chart.GetHigh()) || (cmd == ORDER_TYPE_SELL && qhighest < _chart.GetHigh());
    if (METHOD(method,4)) result &= UpdateIndicator(_chart, INDI_SAR) && CheckMarketEvent(_chart, cmd, C_SAR_BUY_SELL, 0, 0, 0);
    if (METHOD(method,5)) result &= UpdateIndicator(_chart, INDI_DEMARKER) && CheckMarketEvent(_chart, cmd, C_DEMARKER_BUY_SELL, 0, 0.5, 0);
    if (METHOD(method,6)) result &= UpdateIndicator(_chart, INDI_RSI) && CheckMarketEvent(_chart, cmd, C_RSI_BUY_SELL, 0, 30, 0);
    if (METHOD(method,7)) result &= UpdateIndicator(_chart, INDI_MA) && CheckMarketEvent(_chart, cmd, C_MA_BUY_SELL, 0, 0, 0);
  }
  return (result);
}

/**
 * Get key based on strategy id in order to prioritize the queue.
 */
int GetOrderQueueKeyValue(int sid, int method, int qid) {
  DEBUG_CHECKPOINT_ADD
  int key = 0;
  Strategy *_strat = ((Strategy *) strats.GetById(sid));
  switch (method) {
    case  0: key = (int) order_queue[qid][Q_TIME]; break; // 7867 OK (10k, 0.02)
    case  1: key = (int) (stats[sid][DAILY_PROFIT] * 10); break;
    case  2: key = (int) (stats[sid][WEEKLY_PROFIT] * 10); break;
    case  3: key = (int) (stats[sid][MONTHLY_PROFIT] * 10); break; // Has good results.
    case  4: key = (int) (stats[sid][TOTAL_NET_PROFIT] * 10); break; // Has good results.
    case  5: key = (int) (_strat.GetMaxSpread() * 10); break;
    case  6: key = GetStrategyTimeframe(sid); break;
    case  7: key = (int) (GetStrategyProfitFactor(sid) * 100); break;
    case  8: key = (int) (GetStrategyLotSize(sid, (ENUM_ORDER_TYPE) order_queue[qid][Q_CMD]) * 100); break;
    case  9: key = (int) stats[sid][TOTAL_GROSS_PROFIT]; break;
    case 10: key = info[sid][TOTAL_ORDERS]; break; // --7846
    case 11: key -= info[sid][TOTAL_ORDERS_LOSS]; break; // --7662 TODO: To test.
    case 12: key = info[sid][TOTAL_ORDERS_WON]; break; // --7515
    case 13: key -= (int) stats[sid][TOTAL_GROSS_LOSS]; break;
    case 14: key = (int) (stats[sid][AVG_SPREAD] * 10); break; // --7396, TODO: To test.
    case 15: key = (int) (conf[sid][FACTOR] * 10); break; // --6976

    // case  4: key = -info[sid][OPEN_ORDERS]; break; // TODO
  }
  // Message("Key: " + key + " for sid: " + sid + ", qid: " + qid);

  return key;
}

/**
 * Get the next non-empty item from the queue.
 */
int OrderQueueNext(int index = EMPTY) {
  DEBUG_CHECKPOINT_ADD
  if (index == EMPTY) index = 0;
  for (int qid = index; qid < ArrayRange(order_queue, 0); qid++)
    if (order_queue[qid][Q_SID] != EMPTY) { return qid; }
  return (EMPTY);
}

/**
 * Add new order to the queue.
 */
bool OrderQueueAdd(uint _sid, ENUM_ORDER_TYPE cmd) {
  DEBUG_CHECKPOINT_ADD
  bool result = false;
  int qid = EMPTY, size = ArrayRange(order_queue, 0);
  for (int i = 0; i < size; i++) {
    if (order_queue[i][Q_SID] == _sid && order_queue[i][Q_CMD] == cmd) {
      order_queue[i][Q_TOTAL]++;
      if (VerboseTrace) PrintFormat("%s(): Added qid %d with sid: %d, cmd: %d, time: %d, total: %d", __FUNCTION__, i, _sid, cmd, time_current, order_queue[i][Q_TOTAL]);
      return (true); // Increase the existing if it's there.
    }
    if (order_queue[i][Q_SID] == EMPTY) { qid = i; break; } // Find the empty qid.
  }
  if (qid == EMPTY && size < 1000) { OrderQueueResize(order_queue, size + FINAL_ORDER_QUEUE_ENTRY, 0, EMPTY); qid = size; }
  if (qid == EMPTY) {
    return (false);
  } else {
    order_queue[qid][Q_SID] = _sid;
    order_queue[qid][Q_CMD] = cmd;
    order_queue[qid][Q_TIME] = time_current;
    order_queue[qid][Q_TOTAL] = 1;
    result = true;
    if (VerboseTrace) PrintFormat("%s(): Added qid: %d with sid: %d, cmd: %d, time: %d, total: %d", __FUNCTION__, qid, _sid, cmd, time_current, 1);
  }
  return result;
}

/**
 * Clear queue from the orders.
 */
void OrderQueueClear() {
  DEBUG_CHECKPOINT_ADD
  ArrayFill(order_queue, 0, ArraySize(order_queue), EMPTY);
}

/**
 * Check how many orders are in the queue.
 */
int OrderQueueCount() {
  DEBUG_CHECKPOINT_ADD
  int counter = 0;
  for (int i = 0; i < ArrayRange(order_queue, 0); i++)
    if (order_queue[i][Q_SID] != EMPTY) counter++;
  return (counter);
}

/* END: ORDER QUEUE FUNCTIONS */

/* BEGIN: TASK FUNCTIONS */

/**
 * Add new closing order task.
 */
bool TaskAddOrderOpen(ENUM_ORDER_TYPE cmd, double volume, int order_type) {
  int key = cmd + (int) volume + order_type;
  int job_id = TaskFindEmptySlot(cmd + (int) volume + order_type);
  if (job_id >= 0) {
    todo_queue[job_id][0] = key;
    todo_queue[job_id][1] = TASK_ORDER_OPEN;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = cmd;
    todo_queue[job_id][4] = EMPTY; // FIXME: Not used currently.
    todo_queue[job_id][5] = order_type;
    // todo_queue[job_id][6] = order_comment; // FIXME: Not used currently.
    // Print(__FUNCTION__ + ": Added task (", job_id, ") for ticket: ", todo_queue[job_id][0], ", type: ", todo_queue[job_id][1], " (", todo_queue[job_id][3], ").");
    return true;
  } else {
    return false; // Job not allocated.
  }
}

/**
 * Add new close task by job id.
 */
bool TaskAddCloseOrder(long ticket_no, int reason = EMPTY) {
  int job_id = TaskFindEmptySlot(ticket_no);
  if (job_id >= 0) {
    todo_queue[job_id][0] = (int) ticket_no;
    todo_queue[job_id][1] = TASK_ORDER_CLOSE;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = reason;
    if (VerboseTrace) Print("TaskAddCloseOrder(): Allocated task (id: ", job_id, ") for ticket: ", todo_queue[job_id][0], ".");
    return true;
  } else {
    if (VerboseTrace) PrintFormat("%s(): Failed to allocate close task for ticket: %d", __FUNCTION__, ticket_no);
    return false; // Job is not allocated.
  }
}

/**
 * Add new task to recalculate loss/profit.
 */
bool TaskAddCalcStats(int ticket_no, int order_type = EMPTY) {
  int job_id = TaskFindEmptySlot(ticket_no);
  if (job_id >= 0) {
    todo_queue[job_id][0] = ticket_no;
    todo_queue[job_id][1] = TASK_CALC_STATS;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = order_type;
    if (VerboseTrace) Print(__FUNCTION__ + ": Allocated task (id: ", job_id, ") for ticket: ", todo_queue[job_id][0], ".");
    return true;
  } else {
    if (VerboseTrace) PrintFormat("%s(): Failed to allocate close task for ticket: %d", __FUNCTION__, ticket_no);
    return false; // Job is not allocated.
  }
}

/**
 * Remove specific task.
 * @todo: Move to Arrays.
 */
bool TaskRemove(int job_id) {
  todo_queue[job_id][0] = 0;
  todo_queue[job_id][2] = 0;
  if (VerboseTrace) PrintFormat("%: Task removed for id: %d", __FUNCTION__, job_id);
  return true;
}

/**
 * Check if task for specific ticket already exists.
 * @todo: Move to Arrays.
 */
bool TaskExistByKey(long key) {
  for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
    if (todo_queue[job_id][0] == key) {
      // if (VerboseTrace) Print(__FUNCTION__ + ": Task already allocated for key: " + key);
      return (true);
      break;
    }
  }
  return (false);
}

/**
 * Find available slot id.
 * @todo: Move to Arrays.
 */
int TaskFindEmptySlot(long key) {
  int taken = 0;
  if (!TaskExistByKey(key)) {
    for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
      // if (VerboseTrace) Print(__FUNCTION__ + ": job_id = " + job_id + "; key: " + todo_queue[job_id][0]);
      if (todo_queue[job_id][0] <= 0) { // Find empty slot.
        // if (VerboseTrace) Print(__FUNCTION__ + ": Found empty slot at: " + job_id);
        return job_id;
      } else taken++;
    }
    // If no empty slots, Otherwise increase size of array.
    int size = ArrayRange(todo_queue, 0);
    if (size < 1000) { // Set array hard limit.
      ArrayResize(todo_queue, size + 10);
      Msg::ShowText(StringFormat("Couldn't allocate a task slot, re-sizing array. New size: %d, Old size: %d", (size + 1), size),
         "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      return size;
    } else {
      // Array exceeded hard limit, probably because of some memory leak.
      Msg::ShowText(StringFormat("Couldn't allocate a task slot, all are taken (%d of %d).", taken, size),
         "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    }
  }
  return EMPTY;
}

/**
 * Run specific task.
 */
bool TaskRun(int job_id) {
  bool result = false;
  long key = todo_queue[job_id][0];
  int task_type = todo_queue[job_id][1];
  int retries = todo_queue[job_id][2];
  int cmd, sid, reason_id;
  // if (VerboseTrace) Print(__FUNCTION__ + ": Job id: " + job_id + "; Task type: " + task_type);

  switch (task_type) {
    case TASK_ORDER_OPEN:
       cmd = todo_queue[job_id][3];
       // double volume = todo_queue[job_id][4]; // FIXME: Not used as we can't use double to integer array.
       sid = todo_queue[job_id][5];
       // string order_comment = todo_queue[job_id][6]; // FIXME: Not used as we can't use double to integer array.
       result = ExecuteOrder((ENUM_ORDER_TYPE) cmd, sid, EMPTY, "", false);
      break;
    case TASK_ORDER_CLOSE:
        reason_id = todo_queue[job_id][3];
        if (Order::OrderSelect(key, SELECT_BY_TICKET)) {
          if (CloseOrder(key, reason_id, false))
            result = TaskRemove(job_id);
        }
      break;
    case TASK_CALC_STATS:
        if (Order::OrderSelect(key, SELECT_BY_TICKET, MODE_HISTORY)) {
          OrderCalc(key);
        } else {
          Msg::ShowText(StringFormat("Access to history failed with error: (%d).", GetLastError()),
            "Debug", __FUNCTION__, __LINE__, VerboseDebug);
        }
      break;
    default:
      Msg::ShowText(StringFormat("Unknown task: %d", task_type),
         "Debug", __FUNCTION__, __LINE__, VerboseDebug);
  };
  return result;
}

/**
 * Process task list.
 */
bool TaskProcessList(bool with_force = false) {
  int total_run = 0, total_failed = 0, total_removed = 0;
  int no_elem = 8;
  #ifdef __profiler__ PROFILER_START #endif

/* @todo
   // Check if bar time has been changed since last time.
   if (chart.GetBarTime() == last_queue_process && !with_force) {
     // if (VerboseTrace) Print("TaskProcessList(): Not executed. Bar time: " + bar_time + " == " + last_queue_process);
     return (false); // Do not process job list more often than per each minute bar.
   } else {
     last_queue_process = chart.GetBarTime(); // Set bar time of last queue process.
   }
 */

   market.RefreshRates();
   for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
      if (todo_queue[job_id][0] > 0) { // Find valid task.
        if (TaskRun(job_id)) {
          total_run++;
        } else {
          total_failed++;
          if (todo_queue[job_id][2]-- <= 0) { // Remove task if maximum tries reached.
            if (TaskRemove(job_id)) {
              total_removed++;
            }
          }
        }
      }
   } // end: for
   if (VerboseDebug && total_run+total_failed > 0)
     Print(__FUNCTION__, ": Processed ", total_run+total_failed, " jobs (", total_run, " run, ", total_failed, " failed (", total_removed, " removed)).");
  #ifdef __profiler__ PROFILER_STOP #endif
  return true;
}

/* END: TASK FUNCTIONS */

/**
 * Add message into the report file.
 */
void ReportAdd(string msg) {
  int last = ArraySize(log);
  ArrayResize(log, last + 1);
  log[last] = DateTime::TimeToStr(time_current,TIME_DATE|TIME_SECONDS) + ": " + msg;
}

/**
 * Get extra stat report.
 */
string GetStatReport(string sep = "\n") {
  string output = "";
  output += StringFormat("Modelling quality:                          %.2f%%", Chart::CalcModellingQuality()) + sep;
  if (RecordTicksToCSV) {
    output += StringFormat("Total bars processed:                       %d", total_stats.GetTotalBars()) + sep;
    output += StringFormat("Total ticks processed:                      %d", ticker.GetTotalProcessed()) + sep;
    output += StringFormat("Total ticks ignored:                        %d", ticker.GetTotalIgnored()) + sep;
    output += StringFormat("Bars per hour (avg):                        %d", total_stats.GetBarsPerPeriod(PERIOD_H1)) + sep;
    output += StringFormat("Ticks per bar (avg):                        %d (bar=%dmins)", total_stats.GetTicksPerBar(), Period()) + sep;
  }
  //output += StringFormat("Ticks per min (avg):                        %d", total_stats.GetTicksPerMin()) + sep; / @todo

  return output;
}

/**
 * ArrayResizeFill specialization for OrderQueueProcess function.
 */
template <typename X, typename Y>
int OrderQueueResize(X& array[][FINAL_ORDER_QUEUE_ENTRY], int new_size, int reserve_size = 0, Y fill_value = EMPTY) {
  const int old_size = ArrayRange(array, 0);

  if (new_size <= old_size)
    return old_size;

  int result = ArrayResize(array, new_size, reserve_size);

  for (int i = old_size; i < new_size; ++i)
   for (int k = 0; k < FINAL_ORDER_QUEUE_ENTRY; ++k)
      array[i][k] = fill_value;

  return result;
}
