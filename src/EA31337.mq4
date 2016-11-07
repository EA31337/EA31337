//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                            Copyright 2016, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//| EA includes.
//+------------------------------------------------------------------+

#include <EA\ea-mode.mqh>
#include <EA\ea-code-conf.mqh>
#include <EA\ea-properties.mqh>
#include <EA\ea-enums.mqh>
#ifdef __advanced__
  #ifdef __rider__
    #include <EA\rider\ea-conf.mqh>
  #else
    #include <EA\advanced\ea-conf.mqh>
  #endif
#else
  #include <EA\lite\ea-conf.mqh>
#endif

#ifdef __MQL4__
   #include <EA\MQL4\stdlib.mq4> // Used for: ErrorDescription(), RGB(), CompareDoubles(), DoubleToStrMorePrecision(), IntegerToHexString()
   #include <stderror.mqh>
   // #include "debug.mqh"
#else
   #include <StdLibErr.mqh>
   #include <Trade\AccountInfo.mqh>
   #include <MQL5-MQL4\MQL4Common.mqh> // Provides common MQL4 back-compability for MQL5.
#endif
//+------------------------------------------------------------------+
//| EA properties.
//+------------------------------------------------------------------+
#property version     ea_version
#property description ea_name
#property description ea_desc
#property link        ea_link
#property copyright   ea_copy
#property icon        "resources\\favicon.ico"
#property strict
//#property stacksize
//#property tester_file "trade_patterns.csv"    // File with the data to be read by an Expert Advisor.
//#property tester_indicator "smoothed_ma.ex4"  // File with a custom indicator specified in iCustom() as a variable.
//#property tester_library "MT4EA2DLL.dll" // Library file name from <terminal_data_folder>\MQL4\Libraries\ to be sent to a virtual server.

//+------------------------------------------------------------------+
//| Include public classes.
//+------------------------------------------------------------------+
#include <EA\public-classes\Account.mqh>
#include <EA\public-classes\Arrays.mqh>
#include <EA\public-classes\Backtest.mqh>
#include <EA\public-classes\Check.mqh>
#include <EA\public-classes\Convert.mqh>
#include <EA\public-classes\DateTime.mqh>
#include <EA\public-classes\Draw.mqh>
#include <EA\public-classes\Errors.mqh>
#include <EA\public-classes\File.mqh>
#include <EA\public-classes\Order.mqh>
#include <EA\public-classes\Orders.mqh>
#include <EA\public-classes\Market.mqh>
#include <EA\public-classes\Misc.mqh>
#include <EA\public-classes\Msg.mqh>
#include <EA\public-classes\Report.mqh>
#include <EA\public-classes\Stats.mqh>
#include <EA\public-classes\SummaryReport.mqh>
#include <EA\public-classes\Terminal.mqh>
#include <EA\public-classes\Tests.mqh>

//#property tester_file "trade_patterns.csv"    // file with the data to be read by an Expert Advisor

//+------------------------------------------------------------------+
//| User input variables.
//+------------------------------------------------------------------+
extern string __EA_Parameters__ = "-- Input EA parameters for " + ea_name + " v" + ea_version + " --"; // >>> EA31337 <<<

#ifdef __advanced__ // Include default input settings based on the mode.
  #ifdef __rider__
    #include <EA\rider\ea-input.mqh>
  #else
    #include <EA\advanced\ea-input.mqh>
  #endif
#else
  #include <EA\lite\ea-input.mqh>
#endif

//+------------------------------------------------------------------+
/*
 * Summary backtest log:
 * All [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, spread 20, 9,5mln ticks, quality 25%]:
 *
 * Deposit: £10000 (default, spread 2)
 *   £1320256.86	24613	1.27	53.64	368389.08	47.44%	TradeWithTrend=1
 *   £886195.48	33338	1.19	26.58	212549.08	38.13%	TradeWithTrend=0
 *
 * Deposit: £10000 (default, spread 20)
 *
 *   £106725.03	23907	1.11	4.46	59839.20	54.59%	TradeWithTrend=1
 *   £17257.03	32496	1.04	0.53	23297.78	64.43%	TradeWithTrend=0
 *   TODO: (Rider mode)
 *
 * Deposit: £10000 (default, spread 40)
 *
 *   £-4606.56	23095	0.98	-0.20	15646.11	84.76%	TradeWithTrend=1
 *   £-8963.90	31510	0.92	-0.28	11160.88	96.20%	TradeWithTrend=0
 *
 *   spread 30: Prev: £13338.89	8725	1.10	1.53	5290.53	28.64% MinPipChangeToTrade=1 	MinPipGap=12 (d: £10k)
 *   spread 20: Prev: £29865.34	7686	1.19	3.89	7942.79	23.12% MinPipChangeToTrade=1.2 	MinPipGap=12 (d: £10k)
 * --
 * Deposit: £2000 (default, spread 2)
 *
 * Deposit: £2000 (default, spread 20)
 *   £59968.30	7334	1.46	8.18	24904.84	73.02% TradeWithTrend=0 (__rider__, auto)
 *   £2201.25	 7360	1.07	0.30	4608.56	76.53%	TradeWithTrend=1 (__rider__, auto)
 *   Prev: £77576.22	5258	1.44	14.75	24957.91	77.13%	Market_Condition_12=9 	Action_On_Condition_12=6 (__rider__, auto)
 *   £31634.22	5503	1.25	5.75	16191.08	67.12%	Market_Condition_7=6 (__rider__, auto)
 *   £1396.33	2361	1.40	0.59	615.42	25.54% (__limited__, auto)
 *
 * Deposit: £2000 (default, spread 40)
 * --
 * Deposit: £1000 (default, spread 2)
 *   £88416.35	33279	1.20	2.66	21051.43	37.86%	TradeWithTrend=0
 *   £68136.05	24563	1.26	2.77	19243.73	45.89%	TradeWithTrend=1
 *
 * Deposit: £1000 (default, spread 20)
 *
 *   £7242.02	23883	1.11	0.30	4013.08	52.91%	TradeWithTrend=1
 *   £1719.22	32541	1.04	0.05	1914.97	55.15%	TradeWithTrend=0
 *   £8505.73	5452	1.18	1.56	6310.19	79.89%	TradeWithTrend=0 (__rider__, auto)
 *   £5345.28	4571	1.09	1.17	15073.88	83.51%	TradeWithTrend=1 (__rider__, auto)
 *
 * Deposit: £1000 (default, spread 40)
 *   £281.07	23060	1.01	0.01	1802.54	81.01%	TradeWithTrend=1
 *   £-992.10	4038	0.77	-0.25	1125.68	99.23%	TradeWithTrend=0
 *
 *
 * Strategy stats (default, deposit £10000, spread: 20):
    Bars in test	181968
    Ticks modelled	9480514
    Modelling quality	25.00%
    Mismatched charts errors	0
    Initial deposit	10000.00
    Spread	20
    Total net profit	106725.49
    Gross profit	1056738.48
    Gross loss	-950012.99
    Profit factor	1.11
    Expected payoff	4.46
    Absolute drawdown	1232.37
    Maximal drawdown	59857.65 (54.60%)
    Relative drawdown	54.60% (59857.65)
    Total trades	23907
    Short positions (won %)	12101 (37.86%)
    Long positions (won %)	11806 (39.13%)
    Profit trades (% of total)	9202 (38.49%)
    Loss trades (% of total)	14705 (61.51%)
    	Largest
    profit trade	1373.74
    loss trade	-1263.49
    	Average
    profit trade	114.84
    loss trade	-64.60
    	Maximum
    consecutive wins (profit in money)	71 (4348.10)
    consecutive losses (loss in money)	55 (-2837.81)
    	Maximal
    consecutive profit (count of wins)	25125.50 (44)
    consecutive loss (count of losses)	-5405.27 (40)
    	Average
    consecutive wins	3
    consecutive losses	5

    Profit factor: 1.00, Total net profit: -40.26pips (+0.00/-40.26), Total orders: 1 (Won: 0.0% [0] / Loss: 100.0% [1]) - MA M1
    Profit factor: 1.00, Total net profit: -130.29pips (+9.24/-139.53), Total orders: 4 (Won: 25.0% [1] / Loss: 75.0% [3]) - MA M5
    Profit factor: 1.17, Total net profit: 1471.92pips (+10143.80/-8671.88), Total orders: 311 (Won: 48.6% [151] / Loss: 51.4% [160]) - MACD M5
    Profit factor: 1.35, Total net profit: 4258.53pips (+16446.34/-12187.81), Total orders: 259 (Won: 40.9% [106] / Loss: 59.1% [153]) - MACD M15
    Profit factor: 1.16, Total net profit: 149.11pips (+1091.23/-942.12), Total orders: 17 (Won: 35.3% [6] / Loss: 64.7% [11]) - MACD M30
    Profit factor: 0.83, Total net profit: -1505.35pips (+7323.43/-8828.78), Total orders: 689 (Won: 36.4% [251] / Loss: 63.6% [438]) - Alligator M1
    Profit factor: 1.05, Total net profit: 346.08pips (+7610.28/-7264.20), Total orders: 392 (Won: 45.9% [180] / Loss: 54.1% [212]) - Alligator M5
    Profit factor: 1.19, Total net profit: 850.18pips (+5401.14/-4550.96), Total orders: 210 (Won: 46.7% [98] / Loss: 53.3% [112]) - Alligator M15
    Profit factor: 1.12, Total net profit: 804.50pips (+7643.42/-6838.92), Total orders: 183 (Won: 54.1% [99] / Loss: 45.9% [84]) - Alligator M30
    Profit factor: 0.96, Total net profit: -177.08pips (+4627.06/-4804.14), Total orders: 243 (Won: 58.4% [142] / Loss: 41.6% [101]) - RSI M1
    Profit factor: 1.00, Total net profit: -442.09pips (+291.51/-733.60), Total orders: 3 (Won: 66.7% [2] / Loss: 33.3% [1]) - RSI M5
    Profit factor: 1.43, Total net profit: 1252.53pips (+4183.01/-2930.48), Total orders: 50 (Won: 32.0% [16] / Loss: 68.0% [34]) - RSI M15
    Profit factor: 0.93, Total net profit: -715.76pips (+9928.22/-10643.98), Total orders: 159 (Won: 25.2% [40] / Loss: 74.8% [119]) - RSI M30
    Profit factor: 1.10, Total net profit: 7184.44pips (+82467.85/-75283.41), Total orders: 1561 (Won: 40.7% [636] / Loss: 59.3% [925]) - SAR M1
    Profit factor: 1.14, Total net profit: 9582.36pips (+76244.85/-66662.49), Total orders: 1300 (Won: 38.5% [500] / Loss: 61.5% [800]) - SAR M5
    Profit factor: 1.16, Total net profit: 10908.96pips (+80138.08/-69229.12), Total orders: 1231 (Won: 38.2% [470] / Loss: 61.8% [761]) - SAR M15
    Profit factor: 1.11, Total net profit: 8478.01pips (+86975.73/-78497.72), Total orders: 1305 (Won: 34.9% [455] / Loss: 65.1% [850]) - SAR M30
    Profit factor: 1.22, Total net profit: 10033.48pips (+56251.34/-46217.86), Total orders: 1428 (Won: 53.6% [766] / Loss: 46.4% [662]) - Bands M1
    Profit factor: 1.41, Total net profit: 4410.04pips (+15144.86/-10734.82), Total orders: 394 (Won: 57.1% [225] / Loss: 42.9% [169]) - Bands M5
    Profit factor: 1.06, Total net profit: 144.05pips (+2577.73/-2433.68), Total orders: 78 (Won: 52.6% [41] / Loss: 47.4% [37]) - Bands M15
    Profit factor: 0.95, Total net profit: -726.27pips (+12897.85/-13624.12), Total orders: 475 (Won: 40.0% [190] / Loss: 60.0% [285]) - Bands M30
    Profit factor: 1.08, Total net profit: 5024.51pips (+70171.08/-65146.57), Total orders: 1543 (Won: 33.3% [514] / Loss: 66.7% [1029]) - Envelopes M1
    Profit factor: 1.00, Total net profit: 92.93pips (+61306.42/-61213.49), Total orders: 1815 (Won: 28.3% [513] / Loss: 71.7% [1302]) - Envelopes M5
    Profit factor: 1.20, Total net profit: 2677.35pips (+15758.60/-13081.25), Total orders: 286 (Won: 26.6% [76] / Loss: 73.4% [210]) - Envelopes M15
    Profit factor: 1.39, Total net profit: 7823.43pips (+27670.90/-19847.47), Total orders: 709 (Won: 46.1% [327] / Loss: 53.9% [382]) - Envelopes M30
    Profit factor: 1.01, Total net profit: 530.90pips (+42697.87/-42166.97), Total orders: 1134 (Won: 41.6% [472] / Loss: 58.4% [662]) - DeMarker M1
    Profit factor: 0.93, Total net profit: -2343.02pips (+32605.81/-34948.83), Total orders: 1151 (Won: 28.2% [325] / Loss: 71.8% [826]) - DeMarker M5
    Profit factor: 0.95, Total net profit: -1211.96pips (+23343.64/-24555.60), Total orders: 961 (Won: 30.6% [294] / Loss: 69.4% [667]) - DeMarker M15
    Profit factor: 1.22, Total net profit: 3456.31pips (+19399.89/-15943.58), Total orders: 625 (Won: 42.4% [265] / Loss: 57.6% [360]) - DeMarker M30
    Profit factor: 1.25, Total net profit: 9500.00pips (+47187.78/-37687.78), Total orders: 843 (Won: 44.6% [376] / Loss: 55.4% [467]) - WPR M1
    Profit factor: 0.92, Total net profit: -3325.79pips (+36976.63/-40302.42), Total orders: 872 (Won: 36.6% [319] / Loss: 63.4% [553]) - WPR M5
    Profit factor: 1.19, Total net profit: 4395.68pips (+28104.91/-23709.23), Total orders: 626 (Won: 33.5% [210] / Loss: 66.5% [416]) - WPR M15
    Profit factor: 1.10, Total net profit: 2085.46pips (+22946.14/-20860.68), Total orders: 582 (Won: 30.1% [175] / Loss: 69.9% [407]) - WPR M30
    Profit factor: 1.15, Total net profit: 6881.90pips (+51294.91/-44413.01), Total orders: 976 (Won: 37.1% [362] / Loss: 62.9% [614]) - Fractals M1
    Profit factor: 1.06, Total net profit: 670.30pips (+12044.41/-11374.11), Total orders: 211 (Won: 38.9% [82] / Loss: 61.1% [129]) - Fractals M5
    Profit factor: 1.13, Total net profit: 4359.07pips (+39057.04/-34697.97), Total orders: 711 (Won: 31.6% [225] / Loss: 68.4% [486]) - Fractals M15
    Profit factor: 1.25, Total net profit: 6959.73pips (+34521.10/-27561.37), Total orders: 520 (Won: 43.8% [228] / Loss: 56.2% [292]) - Fractals M30

 * Rider mode backtest log
 * All [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, spread 20, 9,5mln ticks, quality 25%]:
 *
 */

/*
 * All backtest log (ts:40,tp:35,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, spread 25, 9,5mln ticks, quality 25%]:
 *   £467.77  5351  1.09  0.09  355.59  22.88%
 */
//+------------------------------------------------------------------+

/*
 * Predefined constants:
 *   Ask (for buying)  - The latest known seller's price (ask price) of the current symbol.
 *   Bid (for selling) - The latest known buyer's price (offer price, bid price) of the current symbol.
 *   Point - The current symbol point value in the quote currency.
 *   Digits - Number of digits after decimal point for the current symbol prices.
 *   Bars - Number of bars in the current chart.
 */

/*
 * Notes:
 *   - __MQL4__  macro is defined when compiling *.mq4 file, __MQL5__ macro is defined when compiling *.mq5 one.
 */
//+------------------------------------------------------------------+

// Class variables.
Market market(string);

// Market/session variables.
double pip_size, lot_size;
double market_minlot, market_maxlot, market_lotsize, market_lotstep, market_marginrequired, market_margininit;
int market_stoplevel; // Market stop level in points.
int order_freezelevel; // Order freeze level in points.
double curr_spread; // Broker current spread in pips.
double risk_margin = 1.0; // Risk marigin in percent.
int pip_digits, volume_digits;
int pts_per_pip; // Number points per pip.
int gmt_offset = 0; // Current difference between GMT time and the local computer time in seconds, taking into account switch to winter or summer time. Depends on the time settings of your computer.

// Account variables.
string account_type;
double init_balance; // Initial account balance.
int init_spread; // Initial spread.

// State variables.
bool session_initiated = FALSE;
bool session_active = FALSE;

// Time-based variables.
datetime bar_time, last_bar_time = (int)EMPTY_VALUE; // Bar time, current and last one to check if bar has been changed since the last time.
datetime time_current = (int)EMPTY_VALUE;
int hour_of_day, day_of_week, day_of_month, day_of_year, month, year;
int last_order_time = 0, last_action_time = 0;
int last_history_check = 0; // Last ticket position processed.

// Class variables.
Stats *total_stats, *hourly_stats;
SummaryReport *summary; // For summary report.

// Strategy variables.
int info[FINAL_STRATEGY_TYPE_ENTRY][FINAL_STRATEGY_INFO_ENTRY];
double conf[FINAL_STRATEGY_TYPE_ENTRY][FINAL_STRATEGY_VALUE_ENTRY], stats[FINAL_STRATEGY_TYPE_ENTRY][FINAL_STRATEGY_STAT_ENTRY];
int open_orders[FINAL_STRATEGY_TYPE_ENTRY], closed_orders[FINAL_STRATEGY_TYPE_ENTRY];
int signals[FINAL_STAT_PERIOD_TYPE_ENTRY][FINAL_STRATEGY_TYPE_ENTRY][FINAL_PERIOD_TYPE_ENTRY][2]; // Count signals to buy and sell per period and strategy.
int tickets[200]; // List of tickets to process.
string sname[FINAL_STRATEGY_TYPE_ENTRY];
int worse_strategy[FINAL_STAT_PERIOD_TYPE_ENTRY], best_strategy[FINAL_STAT_PERIOD_TYPE_ENTRY];

// EA variables.
bool ea_active = FALSE;
double risk_ratio; string rr_text; // Vars for calculation risk ratio.
int max_orders = 10, daily_orders; // Maximum orders available to open.
int max_order_slippage; // Maximum price slippage for buy or sell orders (in points)
double LastAsk, LastBid; // Keep the last ask and bid price.
string AccCurrency; // Current account currency.
int err_code; // Error code.
string last_err, last_msg, last_debug, last_trace;
double last_tick_change; // Last tick change in pips.
double last_close_profit = EMPTY;
// int last_trail_update = 0, last_indicators_update = 0, last_stats_update = 0;
int todo_queue[100][8], last_queue_process = 0;
int total_orders = 0; // Number of total orders currently open.
double daily[FINAL_VALUE_TYPE_ENTRY], weekly[FINAL_VALUE_TYPE_ENTRY], monthly[FINAL_VALUE_TYPE_ENTRY];
double hourly_profit[367][24]; // Keep track of hourly profit.

// Used for writing the report file.
string log[];

// Condition and actions.
int acc_conditions[30][3];
string last_cname;

// Order queue.
int order_queue[100][FINAL_ORDER_QUEUE_ENTRY];

// Indicator variables.
double ac[H1][FINAL_INDICATOR_INDEX_ENTRY];
double ad[H1][FINAL_INDICATOR_INDEX_ENTRY];
double adx[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_ADX_ENTRY];
double alligator[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_ALLIGATOR_ENTRY];
double atr[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_MA_ENTRY];
double awesome[H1][FINAL_INDICATOR_INDEX_ENTRY];
double bands[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_BANDS_ENTRY];
double bwmfi[H1][FINAL_INDICATOR_INDEX_ENTRY];
double bpower[H1][FINAL_INDICATOR_INDEX_ENTRY][OP_SELL+1];
double cci[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_MA_ENTRY];
double demarker[H1][FINAL_INDICATOR_INDEX_ENTRY];
double envelopes[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_LINE_ENTRY];
double force[H1][FINAL_INDICATOR_INDEX_ENTRY];
double fractals[H4][FINAL_INDICATOR_INDEX_ENTRY][FINAL_LINE_ENTRY];
double gator[H1][FINAL_INDICATOR_INDEX_ENTRY][LIPS+1];
double ichimoku[H1][FINAL_INDICATOR_INDEX_ENTRY][CHIKOUSPAN_LINE+1];
double ma_fast[H1][FINAL_INDICATOR_INDEX_ENTRY], ma_medium[H1][FINAL_INDICATOR_INDEX_ENTRY], ma_slow[H1][FINAL_INDICATOR_INDEX_ENTRY];
double macd[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_SLINE_ENTRY];
double mfi[H1][FINAL_INDICATOR_INDEX_ENTRY];
double momentum[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_MA_ENTRY];
double obv[H1][FINAL_INDICATOR_INDEX_ENTRY];
double osma[H1][FINAL_INDICATOR_INDEX_ENTRY];
double rsi[H1][3], rsi_stats[H1][3];
double rvi[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_SLINE_ENTRY];
double sar[H1][3]; int sar_week[H1][7][2];
double stddev[H1][FINAL_INDICATOR_INDEX_ENTRY];
double stochastic[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_SLINE_ENTRY];
double wpr[H1][FINAL_INDICATOR_INDEX_ENTRY];
double zigzag[H1][FINAL_INDICATOR_INDEX_ENTRY];

/* TODO:
 *   - add trailing stops/profit for support/resistence,
 *   - daily higher highs and lower lows,
 *   - check risky dates and times,
 *   - check for risky patterns,
 *   - implement condition to close all strategy orders, buy/sell, most profitable order, when to trade, skip the day or week, etc.
 *   - implement SendFTP,
 *   - implement SendNotification,
 *   - send daily, weekly reports (SendMail),
 *   - check TesterStatistics(),
 *   - check ResourceCreate/ResourceSave to store dynamic parameters
 *   - generate custom tick data for tester\history\EURUSD1_0.fxt
 *   - consider to use Donchian Channel (ihighest/ilowest) for detecting s/r levels
 *   - convert `ma_fast`, `ma_medium`, `ma_slow` into one `ma` variable.
 */

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
  if (!session_initiated) return;

  // Update stats.
  total_stats.OnTick();
  hourly_stats.OnTick();

  // Check the last tick change.
  last_tick_change = fmax(Convert::GetValueDiffInPips(Ask, LastAsk, TRUE), Convert::GetValueDiffInPips(Bid, LastBid, TRUE));
  // if (VerboseDebug && last_tick_change > 1) Print("Tick change: " + tick_change + "; Ask" + Ask + ", Bid: " + Bid, ", LastAsk: " + LastAsk + ", LastBid: " + LastBid);

  // Check if we should ignore the tick.
  bar_time = iTime(NULL, PERIOD_M1, 0);
  if (bar_time <= last_bar_time || last_tick_change < MinPipChangeToTrade) {
    LastAsk = Ask; LastBid = Bid;
    return;
  } else {
    last_bar_time = bar_time;
    if (hour_of_day != Hour()) StartNewHour();
  }

  if (TradeAllowed()) {
    UpdateVariables();
    Trade();
    if (total_orders > 0) {
      CheckOrders();
      UpdateTrailingStops();
      CheckAccConditions();
      TaskProcessList();
    }
    UpdateStats();
  }
  if (ea_active && PrintLogOnChart) DisplayInfoOnChart();
  LastAsk = Ask; LastBid = Bid;

} // end: OnTick()

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
  string err;
  if (VerboseInfo) PrintFormat("%s v%s (%s) initializing...", ea_name, ea_version, ea_link);
  if (!session_initiated) {
    if (!CheckSettings()) {
      // Incorrect set of input parameters occured.
      Msg::ShowText("EA parameters are not valid, please correct.", "Error", __FUNCTION__, __LINE__, VerboseErrors, TRUE, TRUE);
      return (INIT_PARAMETERS_INCORRECT);
    }
    #ifdef __release__
    if (Check::IsRealtime() && AccountNumber() <= 1) {
      // @todo: Fails when debugging.
      Msg::ShowText("EA requires on-line Terminal.", "Error", __FUNCTION__, __LINE__, VerboseErrors, TRUE);
      return (INIT_FAILED);
     }
     #endif
     session_initiated = TRUE;
  }

  session_initiated &= InitializeVariables();
  session_initiated &= InitStrategies();
  session_initiated &= InitializeConditions();
  session_initiated &= CheckHistory();

  #ifdef __advanced__
  if (SmartToggleComponent) ToggleComponent(SmartToggleComponent);
  #endif

  if (!Check::IsRealtime()) {
    SendEmailEachOrder = FALSE;
    SoundAlert = FALSE;
    if (!Check::IsVisualMode()) PrintLogOnChart = FALSE;
    // When testing, we need to simulate real MODE_STOPLEVEL = 30 (as it's in real account), in demo it's 0.
    if (market_stoplevel == 0) market_stoplevel = DemoMarketStopLevel;
    if (Check::IsOptimization()) {
      VerboseErrors = FALSE;
      VerboseInfo   = FALSE;
      VerboseDebug  = FALSE;
      VerboseTrace  = FALSE;
    }
  }

  if (session_initiated && VerboseInfo) {
    string output = InitInfo(TRUE);
    PrintText(output);
    Comment(output);
    ReportAdd(InitInfo());
  }

  session_active = TRUE;
  ea_active = TRUE;
  WindowRedraw();

  return (session_initiated ? INIT_SUCCEEDED : INIT_FAILED);
} // end: OnInit()

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
  ea_active = TRUE;
  time_current = TimeCurrent();
  Msg::ShowText(StringFormat("reason = %d", reason), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
  // Also: _UninitReason.
  Msg::ShowText(
      StringFormat("EA deinitializing, reason: %s (code: %s)", Errors::GetUninitReasonText(reason), IntegerToString(reason)),
      "Info", __FUNCTION__, __LINE__, VerboseInfo);
  Msg::ShowText(GetSummaryText(), "Info", __FUNCTION__, __LINE__, VerboseInfo);

  string filename;
  if (WriteReport && !Check::IsOptimization() && session_initiated) {
    // if (reason == REASON_CHARTCHANGE)
    summary.CalculateSummary();
    filename = StringFormat(
        "%s-%s-%f%s-s%d-%s-M%d-Report.txt",
        ea_name, _Symbol, summary.init_deposit, Account::AccountCurrency(), init_spread, TimeToStr(time_current, TIME_DATE), Period());
        // ea_name, _Symbol, init_balance, Account::AccountCurrency(), init_spread, TimeToStr(time_current, TIME_DATE|TIME_MINUTES), Period());
    string data = summary.GetReport();
    data += GetStatReport();
    data += GetStrategyReport();
    data += GetLogReport();
    Report::WriteReport(filename, data, VerboseInfo); // Todo: Add: Errors::GetUninitReasonText(reason)
    Print(__FUNCTION__ + ": Saved report as: " + filename);
  }
  DeinitVars();
  // #ifdef _DEBUG
  // DEBUG("n=" + n + " : " +  DoubleToStrMorePrecision(val,19) );
  // DEBUG("CLOSEDEBUGFILE");
  // #endif
} // end: OnDeinit()

void DeinitVars() {
  delete hourly_stats;
  delete total_stats;
  delete summary;
}

// The init event handler for tester.
// FIXME: Doesn't seems to work.
void OnTesterInit() {
  if (VerboseDebug) Print("Calling " + __FUNCTION__ + ".");
  #ifdef __MQL5__
    ParameterSetRange(LotSize, 0, 0.0, 0.01, 0.01, 0.1);
  #endif
}

// The init event handler for tester.
// FIXME: Doesn't seems to work.
void OnTesterDeinit() {
  if (VerboseDebug) Print("Calling " + __FUNCTION__ + ".");
}

// The Start event handler, which is automatically generated only for running scripts.
// FIXME: Doesn't seems to be called, however MT4 doesn't want to execute EA without it.
void start() {
  if (VerboseTrace) Print("Calling " + __FUNCTION__ + ".");
  if (VerboseInfo) Print(__FUNCTION__ + ": " + GetMarketTextDetails());
}

/**
 * Print init variables and constants.
 */
string InitInfo(bool startup = False, string sep = "\n") {
  string output = StringFormat("%s v%s by %s (%s)%s", ea_name, ea_version, ea_author, ea_link, sep);
  output += StringFormat("Platform variables: Symbol: %s, Bars: %d, Server: %s, Login: %d%s",
    _Symbol, Bars, AccountInfoString(ACCOUNT_SERVER), (int)AccountInfoInteger(ACCOUNT_LOGIN), sep); // // FIXME: MQL5: Bars
  output += StringFormat("Broker info: Name: %s, Account type: %s, Leverage: 1:%d, Currency: %s%s",
      AccountCompany(), account_type, AccountLeverage(), AccCurrency, sep);
  output += StringFormat("Market predefined variables: Ask: %g, Bid: %g, Volume: %d%s",
      NormalizeDouble(Ask, Digits), NormalizeDouble(Bid, Digits), Volume[0], sep);
  output += StringFormat("Market constants: Digits: %d, Point: %f, Min Lot: %g, Max Lot: %g, Lot Step: %g, Lot Size: %g, Margin Required: %g, Margin Init: %g, Stop Level: %dpts, Freeze level: %d pts%s",
      Market::GetDigits(),
      Market::GetPoint(),
      Market::GetMinLot(),
      Market::GetMaxLot(),
      Market::GetLotStep(),
      Market::GetLotSize(),
      Market::GetMarginRequired(),
      Market::GetMarginInit(),
      Market::GetStopLevel(),
      Market::GetFreezeLevel(),
      sep);
  output += StringFormat("Contract specification for %s: Profit mode: %d, Margin mode: %d, Spread: %d pts, Tick size: %f, Point value: %f, Digits: %d, Trade stop level: %g pts, Trade contract size: %g%s",
      _Symbol,
      MarketInfo(_Symbol, MODE_PROFITCALCMODE),
      MarketInfo(_Symbol, MODE_MARGINCALCMODE),
      (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD),
      SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE),
      SymbolInfoDouble(_Symbol, SYMBOL_POINT),
      (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS),
      (int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL),
      SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE),
      sep);
  output += StringFormat("Swap specification for %s: Mode: %d, Long/buy order value: %g, Short/sell order value: %g%s",
      _Symbol,
      (int)SymbolInfoInteger(_Symbol, SYMBOL_SWAP_MODE),
      SymbolInfoDouble(_Symbol, SYMBOL_SWAP_LONG),
      SymbolInfoDouble(_Symbol, SYMBOL_SWAP_SHORT),
      sep);
  output += StringFormat("Calculated variables: Pip size: %g, Lot size: %g, Points per pip: %d, Pip digits: %d, Volume digits: %d, Spread in pips: %.1f (%d pts), Stop Out Level: %.1f, Market gap: %d pts (%g pips)%s",
      NormalizeDouble(pip_size, pip_digits),
      NormalizeDouble(lot_size, volume_digits),
      pts_per_pip,
      pip_digits,
      volume_digits,
      Market::GetSpreadInPips(),
      Market::GetSpreadInPts(),
      GetAccountStopoutLevel(),
      Market::GetMarketDistanceInPts(),
      Market::GetMarketDistanceInPips(),
      sep);
  output += StringFormat("EA params: Risk margin: %g%%%s",
      risk_margin,
      sep);
  output += StringFormat("Strategies: Active strategies: %d of %d, Max orders: %d (per type: %d)%s",
      GetNoOfStrategies(),
      FINAL_STRATEGY_TYPE_ENTRY,
      max_orders,
      GetMaxOrdersPerType(),
      sep);
  output += ListModellingQuality() + sep;
  output += ListTimeframes() + sep;
  output += StringFormat("Datetime: Hour of day: %d, Day of week: %d, Day of month: %d, Day of year: %d, Month: %d, Year: %d%s",
      hour_of_day, day_of_week, day_of_month, day_of_year, month, year, sep);
  output += GetAccountTextDetails() + sep;
  if (startup) {
    if (session_initiated && IsTradeAllowed()) {
      output += sep + "Trading is allowed, waiting for ticks...";
    } else {
      output += sep + StringFormat("Error %d: Trading is not allowed, please check the settings and allow automated trading!", __LINE__);
    }
  }
  return output;
}

/**
 * Check whether timeframes are active.
 */
string ListTimeframes(bool print = False) {
  string output = StringFormat("Timeframes: M1: %s, M5: %s, M15: %s, M30: %s, H1: %s, H4: %s, D1: %s, W1: %s, MN1: %s;",
    CheckTf(PERIOD_M1)  ? "Active" : "Not active",
    CheckTf(PERIOD_M5)  ? "Active" : "Not active",
    CheckTf(PERIOD_M15) ? "Active" : "Not active",
    CheckTf(PERIOD_M30) ? "Active" : "Not active",
    CheckTf(PERIOD_H1)  ? "Active" : "Not active",
    CheckTf(PERIOD_H4)  ? "Active" : "Not active",
    CheckTf(PERIOD_D1)  ? "Active" : "Not active",
    CheckTf(PERIOD_W1)  ? "Active" : "Not active",
    CheckTf(PERIOD_MN1) ? "Active" : "Not active");
  if (print) {
    return Msg::ShowText(output, "Info", __FUNCTION__, __LINE__, VerboseInfo);
  }
  else {
    return output;
  }
}

/**
 * Returns list of modelling quality for all periods.
 */
string ListModellingQuality(bool print = False) {
  string output = StringFormat("Modelling Quality: M1: %.2f%%, M5: %.2f%%, M15: %.2f%%, M30: %.2f%%, H1: %.2f%%, H4: %.2f%%, D1: %.2f%%, W1: %.2f%%, MN1: %.2f%%;",
    Backtest::CalculateModellingQuality(PERIOD_M1),
    Backtest::CalculateModellingQuality(PERIOD_M5),
    Backtest::CalculateModellingQuality(PERIOD_M15),
    Backtest::CalculateModellingQuality(PERIOD_M30),
    Backtest::CalculateModellingQuality(PERIOD_H1),
    Backtest::CalculateModellingQuality(PERIOD_H4),
    Backtest::CalculateModellingQuality(PERIOD_D1),
    Backtest::CalculateModellingQuality(PERIOD_W1),
    Backtest::CalculateModellingQuality(PERIOD_MN1)
    );
  if (print) {
    return Msg::ShowText(output, "Info", __FUNCTION__, __LINE__, VerboseInfo);
  }
  else {
    return output;
  }
}

/**
 * Main function to trade.
 */
bool Trade() {
  bool order_placed = FALSE;
  int trade_cmd;
  // if (VerboseTrace) Print("Calling " + __FUNCTION__ + ".");
  // vdigits = MarketInfo(Symbol(), MODE_DIGITS);

  for (int id = 0; id < FINAL_STRATEGY_TYPE_ENTRY; id++) {
    trade_cmd = EMPTY;
    if (info[id][ACTIVE] && !info[id][SUSPENDED]) {
      if (TradeCondition(id, OP_BUY))  trade_cmd = OP_BUY;
      else if (TradeCondition(id, OP_SELL)) trade_cmd = OP_SELL;
      #ifdef __advanced__
      if (!DisableCloseConditions) {
        if (CheckMarketEvent(OP_BUY,  PERIOD_M30, info[id][CLOSE_CONDITION])) CloseOrdersByType(OP_SELL, id, NULL, CloseConditionOnlyProfitable); // TODO: reason_id
        if (CheckMarketEvent(OP_SELL, PERIOD_M30, info[id][CLOSE_CONDITION])) CloseOrdersByType(OP_BUY,  id, NULL, CloseConditionOnlyProfitable); // TODO: reason_id
      }
      if (trade_cmd == OP_BUY  && !CheckMarketCondition1(OP_BUY,  info[id][TIMEFRAME], info[id][OPEN_CONDITION1])) trade_cmd = EMPTY;
      if (trade_cmd == OP_SELL && !CheckMarketCondition1(OP_SELL, info[id][TIMEFRAME], info[id][OPEN_CONDITION1])) trade_cmd = EMPTY;
      if (trade_cmd == OP_BUY  &&  CheckMarketCondition1(OP_SELL, PERIOD_M30, info[id][OPEN_CONDITION2], FALSE)) trade_cmd = EMPTY;
      if (trade_cmd == OP_SELL &&  CheckMarketCondition1(OP_BUY,  PERIOD_M30, info[id][OPEN_CONDITION2], FALSE)) trade_cmd = EMPTY;
      #endif


      if (trade_cmd != EMPTY) {
        order_placed &= ExecuteOrder(trade_cmd, id);
      }

    } // end: if
  } // end: for

  #ifdef __advanced__
  if (SmartQueueActive && !order_placed && total_orders < max_orders) {
    if (OrderQueueProcess()) {
      return (TRUE);
    }
  }
  #endif

  return order_placed;
}

/**
 * Check if strategy is on trade conditionl.
 */
bool TradeCondition(int order_type = 0, int cmd = NULL) {
  if (TradeWithTrend && !CheckTrend() == cmd) {
    return (FALSE); // When TradeWithTrend is set and we're against the trend, do not trade.
  }
  ENUM_TIMEFRAMES tf = (ENUM_TIMEFRAMES) info[order_type][TIMEFRAME];
  switch (order_type) {
    case AC1: case AC5: case AC15: case AC30:                                 return Trade_AC(cmd, tf);
    case AD1: case AD5: case AD15: case AD30:                                 return Trade_AD(cmd, tf);
    case ADX1: case ADX5: case ADX15: case ADX30:                             return Trade_ADX(cmd, tf);
    case ALLIGATOR1: case ALLIGATOR5: case ALLIGATOR15: case ALLIGATOR30:     return Trade_Alligator(cmd, tf);
    case ATR1: case ATR5: case ATR15: case ATR30:                             return Trade_ATR(cmd, tf);
    case AWESOME1: case AWESOME5: case AWESOME15: case AWESOME30:             return Trade_Awesome(cmd, tf);
    case BANDS1: case BANDS5: case BANDS15: case BANDS30:                     return Trade_Bands(cmd, tf);
    case BPOWER1: case BPOWER5: case BPOWER15: case BPOWER30:                 return Trade_BPower(cmd, tf);
    case BWMFI1: case BWMFI5: case BWMFI15: case BWMFI30:                     return Trade_BPower(cmd, tf);
    case BREAKAGE1: case BREAKAGE5: case BREAKAGE15: case BREAKAGE30:         return Trade_Breakage(cmd, tf);
    case CCI1: case CCI5: case CCI15: case CCI30:                             return Trade_CCI(cmd, tf);
    case DEMARKER1: case DEMARKER5: case DEMARKER15: case DEMARKER30:         return Trade_DeMarker(cmd, tf);
    case ENVELOPES1: case ENVELOPES5: case ENVELOPES15: case ENVELOPES30:     return Trade_Envelopes(cmd, tf);
    case FORCE1: case FORCE5: case FORCE15: case FORCE30:                     return Trade_Force(cmd, tf);
    case FRACTALS1: case FRACTALS5: case FRACTALS15: case FRACTALS30:         return Trade_Fractals(cmd, tf);
    case GATOR1: case GATOR5: case GATOR15: case GATOR30:                     return Trade_Gator(cmd, tf);
    case ICHIMOKU1: case ICHIMOKU5: case ICHIMOKU15: case ICHIMOKU30:         return Trade_Ichimoku(cmd, tf);
    case MA1: case MA5: case MA15: case MA30:                                 return Trade_MA(cmd, tf);
    case MACD1: case MACD5: case MACD15: case MACD30:                         return Trade_MACD(cmd, tf);
    case MFI1: case MFI5: case MFI15: case MFI30:                             return Trade_MFI(cmd, tf);
    case MOMENTUM1: case MOMENTUM5: case MOMENTUM15: case MOMENTUM30:         return Trade_Momentum(cmd, tf);
    case OBV1: case OBV5: case OBV15: case OBV30:                             return Trade_OBV(cmd, tf);
    case OSMA1: case OSMA5: case OSMA15: case OSMA30:                         return Trade_OSMA(cmd, tf);
    case RSI1: case RSI5: case RSI15: case RSI30:                             return Trade_RSI(cmd, tf);
    case RVI1: case RVI5: case RVI15: case RVI30:                             return Trade_RVI(cmd, tf);
    case SAR1: case SAR5: case SAR15: case SAR30:                             return Trade_SAR(cmd, tf);
    case STDDEV1: case STDDEV5: case STDDEV15: case STDDEV30:                 return Trade_StdDev(cmd, tf);
    case STOCHASTIC1: case STOCHASTIC5: case STOCHASTIC15: case STOCHASTIC30: return Trade_Stochastic(cmd, tf);
    case WPR1: case WPR5: case WPR15: case WPR30:                             return Trade_WPR(cmd, tf);
    case ZIGZAG1: case ZIGZAG5: case ZIGZAG15: case ZIGZAG30:                 return Trade_ZigZag(cmd, tf);
  }
  return FALSE;
}

/**
 * Update specific indicator.
 * Gukkuk im Versteck
 */
bool UpdateIndicator(int type = EMPTY, ENUM_TIMEFRAMES tf = PERIOD_M1, string symbol = NULL) {
  bool success = True;
  static datetime processed[FINAL_INDICATOR_TYPE_ENTRY][FINAL_PERIOD_TYPE_ENTRY];
  int i; string text = __FUNCTION__ + ": ";
  if (type == EMPTY) ArrayFill(processed, 0, ArraySize(processed), FALSE); // Reset processed if tf is EMPTY.
  int index = Convert::TfToIndex(tf);
  if (processed[type][index] == time_current) {
    // If it was already processed, ignore it.
    return (TRUE);
  }

  double ratio = 1.0, ratio2 = 1.0;
  int shift;
  double envelopes_deviation;
  switch (type) {
#ifdef __advanced__
    case AC: // Calculates the Bill Williams' Accelerator/Decelerator oscillator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        ac[index][i] = iAC(symbol, tf, i);
      break;
    case AD: // Calculates the Accumulation/Distribution indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        ad[index][i] = iAD(symbol, tf, i);
      break;
    case ADX: // Calculates the Average Directional Movement Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        adx[index][i][MODE_MAIN]    = iADX(symbol, tf, ADX_Period, ADX_Applied_Price, MODE_MAIN, i);    // Base indicator line
        adx[index][i][MODE_PLUSDI]  = iADX(symbol, tf, ADX_Period, ADX_Applied_Price, MODE_PLUSDI, i);  // +DI indicator line
        adx[index][i][MODE_MINUSDI] = iADX(symbol, tf, ADX_Period, ADX_Applied_Price, MODE_MINUSDI, i); // -DI indicator line
      }
      break;
#endif
    case ALLIGATOR: // Calculates the Alligator indicator.
      // Colors: Alligator's Jaw - Blue, Alligator's Teeth - Red, Alligator's Lips - Green.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        alligator[index][i][LIPS]  = iMA(symbol, tf, Alligator_Period_Lips * ratio,  Alligator_Shift_Lips,  Alligator_MA_Method, Alligator_Applied_Price, i + Alligator_Shift);
        alligator[index][i][TEETH] = iMA(symbol, tf, Alligator_Period_Teeth * ratio, Alligator_Shift_Teeth, Alligator_MA_Method, Alligator_Applied_Price, i + Alligator_Shift);
        alligator[index][i][JAW]   = iMA(symbol, tf, Alligator_Period_Jaw * ratio,   Alligator_Shift_Jaw,   Alligator_MA_Method, Alligator_Applied_Price, i + Alligator_Shift);
        ratio *= Alligator_Period_Ratio;
      }
      success = (bool)alligator[index][CURR][JAW];
      /* Note: This is equivalent to:
        alligator[index][i][TEETH] = iAlligator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORJAW,   Alligator_Shift);
        alligator[index][i][TEETH] = iAlligator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORTEETH, Alligator_Shift);
        alligator[index][i][LIPS]  = iAlligator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORLIPS,  Alligator_Shift);
       */
      if (VerboseDebug) PrintFormat("Alligator M%d: %s", tf, Arrays::ArrToString3D(alligator, ",", Digits));
      break;
#ifdef __advanced__
    case ATR: // Calculates the Average True Range indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        atr[index][i][FAST] = iATR(symbol, tf, ATR_Period_Fast * ratio, i);
        atr[index][i][SLOW] = iATR(symbol, tf, ATR_Period_Slow * ratio, i);
        ratio *= ATR_Period_Ratio;
      }
      break;
    case AWESOME: // Calculates the Awesome oscillator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        awesome[index][i] = iAO(symbol, tf, i);
      }
      break;
#endif // __advanced__
    case BANDS: // Calculates the Bollinger Bands indicator.
      // int sid, bands_period = Bands_Period; // Not used at the moment.
      // sid = GetStrategyViaIndicator(BANDS, tf); bands_period = info[sid][CUSTOM_PERIOD]; // Not used at the moment.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        shift = i + Bands_Shift + (i == FINAL_INDICATOR_INDEX_ENTRY - 1 ? Bands_Shift_Far : 0);
        bands[index][i][BANDS_BASE]  = iBands(symbol, tf, Bands_Period * ratio, Bands_Deviation * ratio2, 0, Bands_Applied_Price, BANDS_BASE,  shift);
        bands[index][i][BANDS_UPPER] = iBands(symbol, tf, Bands_Period * ratio, Bands_Deviation * ratio2, 0, Bands_Applied_Price, BANDS_UPPER, shift);
        bands[index][i][BANDS_LOWER] = iBands(symbol, tf, Bands_Period * ratio, Bands_Deviation * ratio2, 0, Bands_Applied_Price, BANDS_LOWER, shift);
        ratio *= Bands_Period_Ratio;
        ratio2 *= Bands_Deviation_Ratio;
      }
      success = (bool)bands[index][CURR][BANDS_BASE];
      if (VerboseDebug) PrintFormat("Bands M%d: %s", tf, Arrays::ArrToString3D(bands, ",", Digits));
      break;
#ifdef __advanced__
    case BPOWER: // Calculates the Bears Power and Bulls Power indicators.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        bpower[index][i][OP_BUY]  = iBullsPower(symbol, tf, BPower_Period, BPower_Applied_Price, i);
        bpower[index][i][OP_SELL] = iBearsPower(symbol, tf, BPower_Period, BPower_Applied_Price, i);
      }
      success = (bool)(bpower[index][CURR][OP_BUY] || bpower[index][CURR][OP_SELL]);
      // Message("Bulls: " + bpower[index][CURR][OP_BUY] + ", Bears: " + bpower[index][CURR][OP_SELL]);
      break;
    case BWMFI: // Calculates the Market Facilitation Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        bwmfi[index][i] = iBWMFI(symbol, tf, i);
      }
      success = (bool)bwmfi[index][CURR];
      break;
    case CCI: // Calculates the Commodity Channel Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        cci[index][i][FAST] = iCCI(symbol, tf, CCI_Period_Fast, CCI_Applied_Price, i);
        cci[index][i][SLOW] = iCCI(symbol, tf, CCI_Period_Slow, CCI_Applied_Price, i);
      }
      success = (bool)cci[index][CURR][SLOW];
      break;
#endif
    case DEMARKER: // Calculates the DeMarker indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        demarker[index][i] = iDeMarker(symbol, tf, DeMarker_Period * ratio, i + DeMarker_Shift);
        ratio *= DeMarker_Period_Ratio;
      }
      success = (bool)demarker[index][CURR];
      // PrintFormat("Period: %d, DeMarker: %g", period, demarker[index][CURR]);
      if (VerboseDebug) PrintFormat("DeMarker M%d: %s", tf, Arrays::ArrToString2D(demarker, ",", Digits));
      break;
    case ENVELOPES: // Calculates the Envelopes indicator.
      /*
      envelopes_deviation = Envelopes30_Deviation;
      switch (period) {
        case M1: envelopes_deviation = Envelopes1_Deviation; break;
        case M5: envelopes_deviation = Envelopes5_Deviation; break;
        case M15: envelopes_deviation = Envelopes15_Deviation; break;
        case M30: envelopes_deviation = Envelopes30_Deviation; break;
      }
      */
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        envelopes[index][i][MODE_MAIN] = iEnvelopes(symbol, tf, Envelopes_MA_Period * ratio, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, Envelopes_Deviation * ratio2, MODE_MAIN,  i + Envelopes_Shift);
        envelopes[index][i][UPPER]     = iEnvelopes(symbol, tf, Envelopes_MA_Period * ratio, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, Envelopes_Deviation * ratio2, UPPER, i + Envelopes_Shift);
        envelopes[index][i][LOWER]     = iEnvelopes(symbol, tf, Envelopes_MA_Period * ratio, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, Envelopes_Deviation * ratio2, LOWER, i + Envelopes_Shift);
        ratio *= Envelopes_MA_Period_Ratio;
        ratio2 *= Envelopes_Deviation_Ratio;
      }
      success = (bool)envelopes[index][CURR][MODE_MAIN];
      if (VerboseDebug) PrintFormat("Envelopes M%d: %s", tf, Arrays::ArrToString3D(envelopes, ",", Digits));
      break;
#ifdef __advanced__
    case FORCE: // Calculates the Force Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        force[index][i] = iForce(symbol, tf, Force_Period, Force_MA_Method, Force_Applied_price, i);
      }
      success = (bool)force[index][CURR];
      break;
#endif
    case FRACTALS: // Calculates the Fractals indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        fractals[index][i][LOWER] = iFractals(symbol, tf, LOWER, i);
        fractals[index][i][UPPER] = iFractals(symbol, tf, UPPER, i);
      }
      if (VerboseDebug) PrintFormat("Fractals M%d: %s", tf, Arrays::ArrToString3D(fractals, ",", Digits));
      break;
    case GATOR: // Calculates the Gator oscillator.
      // Colors: Alligator's Jaw - Blue, Alligator's Teeth - Red, Alligator's Lips - Green.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        gator[index][i][LIPS]  = iGator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORLIPS,  Alligator_Shift);
        gator[index][i][TEETH] = iGator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Teeth, Alligator_Shift_Teeth, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORTEETH, Alligator_Shift);
        gator[index][i][JAW] = iGator(symbol, tf, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Jaw, Alligator_Shift_Jaw, Alligator_Period_Lips, Alligator_Shift_Lips, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORJAW,   Alligator_Shift);
      }
      success = (bool)gator[index][CURR][JAW];
      break;
    case ICHIMOKU: // Calculates the Ichimoku Kinko Hyo indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        ichimoku[index][i][MODE_TENKANSEN]   = iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_TENKANSEN, i);
        ichimoku[index][i][MODE_KIJUNSEN]    = iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_KIJUNSEN, i);
        ichimoku[index][i][MODE_SENKOUSPANA] = iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_SENKOUSPANA, i);
        ichimoku[index][i][MODE_SENKOUSPANB] = iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_SENKOUSPANB, i);
        ichimoku[index][i][MODE_CHIKOUSPAN]  = iIchimoku(symbol, tf, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_CHIKOUSPAN, i);
      }
      success = (bool)ichimoku[index][CURR][MODE_TENKANSEN];
      break;
    case MA: // Calculates the Moving Average indicator.
      // Calculate MA Fast.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        shift = i + MA_Shift + (i == FINAL_INDICATOR_INDEX_ENTRY - 1 ? MA_Shift_Far : 0);
        ma_fast[index][i]   = iMA(symbol, tf, MA_Period_Fast * ratio,   MA_Shift_Fast,   MA_Method, MA_Applied_Price, shift);
        ma_medium[index][i] = iMA(symbol, tf, MA_Period_Medium * ratio, MA_Shift_Medium, MA_Method, MA_Applied_Price, shift);
        ma_slow[index][i]   = iMA(symbol, tf, MA_Period_Slow * ratio,   MA_Shift_Slow,   MA_Method, MA_Applied_Price, shift);
        ratio *= MA_Period_Ratio;
        if (tf == Period() && i < FINAL_INDICATOR_INDEX_ENTRY - 1) {
          Draw::TLine(symbol+"MA Fast"+i,   ma_fast[index][i],   ma_fast[index][i+1],    iTime(NULL, 0, shift), iTime(NULL, 0, shift+1), clrBlue);
          Draw::TLine(symbol+"MA Medium"+i, ma_medium[index][i], ma_medium[index][i+1],  iTime(NULL, 0, shift), iTime(NULL, 0, shift+1), clrYellow);
          Draw::TLine(symbol+"MA Slow"+i,   ma_slow[index][i],   ma_slow[index][i+1],    iTime(NULL, 0, shift), iTime(NULL, 0, shift+1), clrGray);
        }
      }
      success = (bool)ma_slow[index][CURR];
      if (VerboseDebug) PrintFormat("MA Fast M%d: %s", tf, Arrays::ArrToString2D(ma_fast, ",", Digits));
      if (VerboseDebug) PrintFormat("MA Medium M%d: %s", tf, Arrays::ArrToString2D(ma_medium, ",", Digits));
      if (VerboseDebug) PrintFormat("MA Slow M%d: %s", tf, Arrays::ArrToString2D(ma_slow, ",", Digits));
      // if (VerboseDebug && Check::IsVisualMode()) Draw::DrawMA(tf);
      break;
    case MACD: // Calculates the Moving Averages Convergence/Divergence indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        shift = i + MACD_Shift + (i == FINAL_INDICATOR_INDEX_ENTRY - 1 ? MACD_Shift_Far : 0);
        macd[index][i][MODE_MAIN]   = iMACD(symbol, tf, (int) MACD_Period_Fast * ratio, (int) MACD_Period_Slow * ratio, (int) MACD_Period_Signal * ratio, MACD_Applied_Price, MODE_MAIN,   shift);
        macd[index][i][MODE_SIGNAL] = iMACD(symbol, tf, (int) MACD_Period_Fast * ratio, (int) MACD_Period_Slow * ratio, (int) MACD_Period_Signal * ratio, MACD_Applied_Price, MODE_SIGNAL, shift);
        ratio *= MACD_Period_Ratio;
      }
      if (VerboseDebug) PrintFormat("MACD M%d: %s", tf, Arrays::ArrToString3D(macd, ",", Digits));
      success = (bool)macd[index][CURR][MODE_MAIN];
      break;
    case MFI: // Calculates the Money Flow Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        mfi[index][i] = iMFI(symbol, tf, MFI_Period, i);
      }
      success = (bool)mfi[index][CURR];
      break;
    case MOMENTUM: // Calculates the Momentum indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        momentum[index][i][FAST] = iMomentum(symbol, tf, Momentum_Period_Fast, Momentum_Applied_Price, i);
        momentum[index][i][SLOW] = iMomentum(symbol, tf, Momentum_Period_Slow, Momentum_Applied_Price, i);
      }
      success = (bool)momentum[index][CURR][SLOW];
      break;
    case OBV: // Calculates the On Balance Volume indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        obv[index][i] = iOBV(symbol, tf, OBV_Applied_Price, i);
      }
      success = (bool)obv[index][CURR];
      break;
    case OSMA: // Calculates the Moving Average of Oscillator indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        osma[index][i] = iOsMA(symbol, tf, OSMA_Period_Fast, OSMA_Period_Slow, OSMA_Period_Signal, OSMA_Applied_Price, i);
      }
      success = (bool)osma[index][CURR];
      break;
    case RSI: // Calculates the Relative Strength Index indicator.
      // int rsi_period = RSI_Period; // Not used at the moment.
      // sid = GetStrategyViaIndicator(RSI, tf); rsi_period = info[sid][CUSTOM_PERIOD]; // Not used at the moment.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        rsi[index][i] = iRSI(symbol, tf, RSI_Period * ratio, RSI_Applied_Price, i + RSI_Shift);
        if (rsi[index][i] > rsi_stats[index][UPPER]) rsi_stats[index][UPPER] = rsi[index][i]; // Calculate maximum value.
        if (rsi[index][i] < rsi_stats[index][LOWER] || rsi_stats[index][LOWER] == 0) rsi_stats[index][LOWER] = rsi[index][i]; // Calculate minimum value.
        ratio *= RSI_Period_Ratio;
      }
      // Calculate average value.
      rsi_stats[index][0] = Misc::If(rsi_stats[index][0] > 0, (rsi_stats[index][0] + rsi[index][0] + rsi[index][1] + rsi[index][2]) / 4, (rsi[index][0] + rsi[index][1] + rsi[index][2]) / 3);
      if (VerboseDebug) PrintFormat("RSI M%d: %s", tf, Arrays::ArrToString2D(rsi, ",", Digits));
      success = (bool)rsi[index][CURR];
      break;
    case RVI: // Calculates the Relative Strength Index indicator.
      rvi[index][CURR][MODE_MAIN]   = iRVI(symbol, tf, 10, MODE_MAIN, CURR);
      rvi[index][PREV][MODE_MAIN]   = iRVI(symbol, tf, 10, MODE_MAIN, PREV + RVI_Shift);
      rvi[index][FAR][MODE_MAIN]    = iRVI(symbol, tf, 10, MODE_MAIN, FAR + RVI_Shift + RVI_Shift_Far);
      rvi[index][CURR][MODE_SIGNAL] = iRVI(symbol, tf, 10, MODE_SIGNAL, CURR);
      rvi[index][PREV][MODE_SIGNAL] = iRVI(symbol, tf, 10, MODE_SIGNAL, PREV + RVI_Shift);
      rvi[index][FAR][MODE_SIGNAL]  = iRVI(symbol, tf, 10, MODE_SIGNAL, FAR + RVI_Shift + RVI_Shift_Far);
      success = (bool)rvi[index][CURR][MODE_MAIN];
      break;
    case SAR: // Calculates the Parabolic Stop and Reverse system indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        sar[index][i] = iSAR(symbol, tf, SAR_Step * ratio, SAR_Maximum_Stop, i + SAR_Shift);
        ratio *= SAR_Step_Ratio;
      }
      if (VerboseDebug) PrintFormat("SAR M%d: %s", tf, Arrays::ArrToString2D(sar, ",", Digits));
      success = (bool)sar[index][CURR];
      break;
    case STDDEV: // Calculates the Standard Deviation indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        stddev[index][i] = iStdDev(symbol, tf, StdDev_MA_Period, StdDev_MA_Shift, StdDev_MA_Method, StdDev_Applied_Price, i);
      }
      if (VerboseDebug) PrintFormat("StdDev M%d: %s", tf, Arrays::ArrToString2D(stddev, ",", Digits));
      success = stddev[index][CURR];
      break;
    case STOCHASTIC: // Calculates the Stochastic Oscillator.
      // TODO
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        stochastic[index][i][MODE_MAIN]   = iStochastic(symbol, PERIOD_H1, 15, 9, 9, MODE_EMA, 0, MODE_MAIN, i);
        stochastic[index][i][MODE_SIGNAL] = iStochastic(symbol, PERIOD_H1, 15, 9, 9, MODE_EMA, 0, MODE_SIGNAL, i);
      }
      if (VerboseDebug) PrintFormat("Stochastic M%d: %s", tf, Arrays::ArrToString3D(stochastic, ",", Digits));
      success = stochastic[index][CURR][MODE_MAIN];
      break;
    case WPR: // Calculates the  Larry Williams' Percent Range.
      // Update the Larry Williams' Percent Range indicator values.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        wpr[index][i] = -iWPR(symbol, tf, WPR_Period * ratio, i + WPR_Shift);
        ratio *= WPR_Period_Ratio;
      }
      if (VerboseDebug) PrintFormat("WPR M%d: %s", tf, Arrays::ArrToString2D(wpr, ",", Digits));
      success = wpr[index][CURR];
      break;
    case ZIGZAG: // Calculates the custom ZigZag indicator.
      // TODO
      break;
  } // end: switch

  processed[type][index] = time_current; // @fixme: warning 43: possible loss of data due to type conversion
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
 *     if TRUE, re-try to open again after error/failure.
 */
int ExecuteOrder(int cmd, int sid, double trade_volume = EMPTY, string order_comment = "", bool retry = TRUE) {
   bool result = FALSE;
   int order_ticket;

   if (trade_volume == EMPTY) {
     trade_volume = GetStrategyLotSize(sid, cmd);
   } else {
     trade_volume = NormalizeLots(trade_volume);
   }

   // Check the limits.
   if (!OpenOrderIsAllowed(cmd, sid, trade_volume)) {
     return (FALSE);
   }

   // Check the order comment.
   if (order_comment == "") {
     order_comment = GetStrategyComment(sid);
   }

   // Calculate take profit and stop loss.
   RefreshRates();
   // Print current market information before placing the order.
   if (VerboseDebug) Print(__FUNCTION__ + ": " + GetMarketTextDetails());

   // Get the fixed stops.
   // @todo: Test GetOpenPrice vs GetClosePrice
   double stoploss   = StopLoss   > 0 ? NormalizeDouble(Market::GetClosePrice(cmd) - (StopLoss + TrailingStop) * pip_size * Convert::OrderTypeToValue(cmd), Digits) : 0;
   double takeprofit = TakeProfit > 0 ? NormalizeDouble(Market::GetOpenPrice(cmd) + (TakeProfit + TrailingProfit) * pip_size * Convert::OrderTypeToValue(cmd), Digits) : 0;
   // Get the dynamic trailing stops.
   double stoploss_trail   = GetTrailingValue(cmd, -1, sid);
   double takeprofit_trail = GetTrailingValue(cmd, +1, sid);
   if (VerboseDebug) PrintFormat("stoploss = %g, takeprofit = %g, stoploss_trail = %g, takeprofit_trail = %g", stoploss, takeprofit, stoploss_trail, takeprofit_trail);
   // Choose the safest stops.
   // @todo: Implement hard stops based on the balance.
   stoploss   = stoploss > 0   && stoploss_trail > 0
     ? (Convert::OrderTypeToValue(cmd) > 0 ? fmax(stoploss, stoploss_trail) : fmin(stoploss, stoploss_trail))
     : fmax(stoploss, stoploss_trail);
   takeprofit = takeprofit > 0 && takeprofit_trail > 0
     ? (Convert::OrderTypeToValue(cmd) > 0 ? fmin(takeprofit, takeprofit_trail) : fmax(takeprofit, takeprofit_trail))
     : fmax(takeprofit, takeprofit_trail);
   // Normalize stops.
   stoploss = NormalizeDouble(stoploss, Market::GetDigits());
   takeprofit = NormalizeDouble(takeprofit, Market::GetDigits());

   if (VerboseDebug) PrintFormat("Adjusted: stoploss = %f, takeprofit = %f", stoploss, takeprofit);
   if (VerboseDebug) PrintFormat("Normalized: stoploss = %f, takeprofit = %f",
      NormalizeDouble(stoploss, Market::GetDigits()),
      NormalizeDouble(takeprofit, Market::GetDigits()));
   if (VerboseDebug) PrintFormat("Normalized2: stoploss = %f, takeprofit = %f",
      NormalizeDouble(stoploss, Digits),
      NormalizeDouble(takeprofit, Digits));

   // @fixme: warning 43: possible loss of data due to type conversion: GetOrderColor
   order_ticket = OrderSend(_Symbol, cmd,
      NormalizeLots(trade_volume),
      NormalizeDouble(Market::GetOpenPrice(cmd), Market::GetDigits()),
      max_order_slippage,
      NormalizeDouble(stoploss, Market::GetDigits()),
      NormalizeDouble(takeprofit, Market::GetDigits()),
      order_comment,
      MagicNumber + sid, 0, GetOrderColor(cmd));
   if (order_ticket >= 0) {
      total_orders++;
      daily_orders++;
      if (!OrderSelect(order_ticket, SELECT_BY_TICKET) && VerboseErrors) {
        Msg::ShowText(ErrorDescription(GetLastError()), "Error", __FUNCTION__, __LINE__, VerboseErrors);
        OrderPrint();
        // @fixme: warning 43: possible loss of data due to type conversion: trade_volume
        if (retry) TaskAddOrderOpen(cmd, trade_volume, sid); // Will re-try again. // warning 43: possible loss of data due to type conversion
        info[sid][TOTAL_ERRORS]++;
        return (FALSE);
      }
      if (VerboseTrace) Print(__FUNCTION__, ": Success: OrderSend(", Symbol(), ", ",  Convert::OrderTypeToString(cmd), ", ", NormalizeDouble(trade_volume, volume_digits), ", ", NormalizeDouble(Market::GetOpenPrice(cmd), Digits), ", ", max_order_slippage, ", ", stoploss, ", ", takeprofit, ", ", order_comment, ", ", MagicNumber + sid, ", 0, ", GetOrderColor(), ");");

      result = TRUE;
      // TicketAdd(order_ticket);
      last_order_time = TimeCurrent(); // Set last execution time. // warning 43: possible loss of data due to type conversion
      // last_trail_update = 0; // Set to 0, so trailing stops can be updated faster.
      stats[sid][AVG_SPREAD] = (stats[sid][AVG_SPREAD] + curr_spread) / 2;
      if (VerboseInfo) OrderPrint();
      Msg::ShowText(Order::GetOrderToText() + GetAccountTextDetails(), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
      if (SoundAlert) PlaySound(SoundFileAtOpen);
      if (SendEmailEachOrder) SendEmailExecuteOrder();

      #ifdef __advanced__
      if (SmartQueueActive && total_orders >= max_orders) OrderQueueClear(); // Clear queue if we're reached the limit again, so we can start fresh.
      #endif
   } else {
     result = FALSE;
     err_code = GetLastError();
     last_err = Msg::ShowText(ErrorDescription(err_code), "Error", __FUNCTION__, __LINE__, VerboseInfo | VerboseErrors);
     if (VerboseErrors) {
       if (WriteReport) ReportAdd(last_err);
     }
     if (VerboseDebug) {
        Print("Digits: " + Market::GetDigits());
       last_debug = Msg::ShowText(
         StringFormat("OrderSend(%s, %s, %g, %f, %d, %f, %f, '%s', %d, %d, %d)",
           _Symbol, Convert::OrderTypeToString(cmd),
           NormalizeLots(trade_volume),
           NormalizeDouble(Market::GetOpenPrice(cmd), Market::GetDigits()),
           max_order_slippage,
           NormalizeDouble(stoploss, Market::GetDigits()),
           NormalizeDouble(takeprofit, Market::GetDigits()),
           order_comment,
           MagicNumber + sid, 0, GetOrderColor(cmd)),
           "Debug", __FUNCTION__, __LINE__, VerboseDebug | VerboseTrace);
       StringFormat(GetAccountTextDetails(), "Debug", __FUNCTION__, __LINE__, VerboseDebug | VerboseTrace);
       StringFormat(GetMarketTextDetails(),  "Debug", __FUNCTION__, __LINE__, VerboseDebug | VerboseTrace);
       OrderPrint();
     }

     // Process the errors.
     if (err_code == ERR_TRADE_TOO_MANY_ORDERS) {
       // On some trade servers, the total amount of open and pending orders can be limited. If this limit has been exceeded, no new order will be opened.
       MaxOrders = total_orders; // So we're setting new fixed limit for total orders which is allowed.
       retry = FALSE;
     }
     if (err_code == ERR_INVALID_TRADE_VOLUME) { // OrderSend error 131
        // Invalid trade volume.
        // Usually happens when volume is not normalized, or on invalid volume value.
        retry = FALSE;
     }
     if (err_code == ERR_TRADE_EXPIRATION_DENIED) {
       // Applying of pending order expiration time can be disabled in some trade servers.
       retry = FALSE;
     }
     if (err_code == ERR_TOO_MANY_REQUESTS) {
       // It occurs when you send the same command OrderSend()/OrderModify() over and over again in a short period of time.
       retry = TRUE;
       Sleep(200); // Wait 200ms.
     }
     if (err_code == ERR_OFF_QUOTES) { /* error code: 136 */
        // Price changed, so we should consider whether to execute order or not.
        retry = FALSE; // ?
     }
     if (retry) TaskAddOrderOpen(cmd, trade_volume, sid); // Will re-try again. // warning 43: possible loss of data due to type conversion
     info[sid][TOTAL_ERRORS]++;
   } // end-if: order_ticket

   return (result);
}

/**
 * Check if we can open new order.
 */
bool OpenOrderIsAllowed(int cmd, int sid = EMPTY, double volume = EMPTY) {
  int result = TRUE;
  string err;
  if (volume < market_minlot) {
    last_trace = Msg::ShowText(StringFormat("%s: Lot size = %.2f", sname[sid], volume), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
    result = FALSE;
  } else if (total_orders >= max_orders) {
    last_msg = Msg::ShowText("Maximum open and pending orders reached the limit (MaxOrders).", "Info", __FUNCTION__, __LINE__, VerboseInfo);
    #ifdef __advanced__
    OrderQueueAdd(sid, cmd);
    #endif
    result = FALSE;
  } else if (GetTotalOrdersByType(sid) >= GetMaxOrdersPerType()) {
    last_msg = Msg::ShowText(StringFormat("%s: Maximum open and pending orders per type reached the limit (MaxOrdersPerType).", sname[sid]), "Info", __FUNCTION__, __LINE__, VerboseInfo);
    #ifdef __advanced__
    OrderQueueAdd(sid, cmd);
    #endif
    result = FALSE;
  } else if (!Account::CheckFreeMargin(cmd, volume)) {
    last_err = Msg::ShowText("No money to open more orders.", "Error", __FUNCTION__, __LINE__, VerboseInfo | VerboseErrors, PrintLogOnChart);
    result = FALSE;
  } else if (!CheckMinPipGap(sid)) {
    last_trace = Msg::ShowText(StringFormat("%s: Not executing order, because the gap is too small [MinPipGap].", sname[sid]), "Info", __FUNCTION__, __LINE__, VerboseInfo);
    result = FALSE;
  } else if (!CheckProfitFactorLimits(sid)) {
    result = FALSE;
  }
  #ifdef __advanced__
  if (ApplySpreadLimits && !CheckSpreadLimit(sid)) {
    last_trace = Msg::ShowText(StringFormat("%s: Not executing order, because the spread is too high. (spread = %.1f pips).", sname[sid], curr_spread), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
    result = FALSE;
  } else if (MinIntervalSec > 0 && time_current - last_order_time < MinIntervalSec) {
    last_trace = Msg::ShowText(StringFormat("%s: There must be a %d sec minimum interval between subsequent trade signals.", sname[sid], MinIntervalSec), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
    result = FALSE;
  } else if (MaxOrdersPerDay > 0 && daily_orders >= GetMaxOrdersPerDay()) {
    last_err = Msg::ShowText("Maximum open and pending orders reached the daily limit (MaxOrdersPerDay).", "Info", __FUNCTION__, __LINE__, VerboseInfo);
    OrderQueueAdd(sid, cmd);
    result = FALSE;
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
 *   If TRUE, the profit factor is fine, otherwise return FALSE.
 */
bool CheckProfitFactorLimits(int sid = EMPTY) {
  if (sid == EMPTY) {
    // If sid is empty, unsuspend all strategies.
    ActionExecute(A_UNSUSPEND_STRATEGIES);
    return (TRUE);
  }
  conf[sid][PROFIT_FACTOR] = GetStrategyProfitFactor(sid);
  if (ProfitFactorMinToTrade > 0 && conf[sid][PROFIT_FACTOR] < ProfitFactorMinToTrade) {
    last_err = Msg::ShowText(
      StringFormat("%s: Minimum profit factor reached, disabling strategy. (pf = %.1f)",
        sname[sid], conf[sid][PROFIT_FACTOR]),
      "Info", __FUNCTION__, __LINE__, VerboseInfo);
    info[sid][SUSPENDED] = TRUE;
    return (FALSE);
  }
  if (ProfitFactorMaxToTrade > 0 && conf[sid][PROFIT_FACTOR] > ProfitFactorMaxToTrade) {
    last_err = Msg::ShowText(
      StringFormat("%s: Maximum profit factor reached, disabling strategy. (pf = %.1f)",
        sname[sid], conf[sid][PROFIT_FACTOR]),
      "Info", __FUNCTION__, __LINE__, VerboseInfo);
    info[sid][SUSPENDED] = TRUE;
    return (FALSE);
  }
  if (VerboseDebug) PrintFormat("%s: Profit factor: %.1f", sname[sid], conf[sid][PROFIT_FACTOR]);
  return (TRUE);
}

#ifdef __advanced__
/**
 * Check if spread is not too high for specific strategy.
 *
 * @param
 *   sid (int) - strategy id
 * @return
 *   If TRUE, the spread is fine, otherwise return FALSE.
 */
bool CheckSpreadLimit(int sid) {
  double spread_limit = Misc::If(conf[sid][SPREAD_LIMIT] > 0, fmin(conf[sid][SPREAD_LIMIT], MaxSpreadToTrade), MaxSpreadToTrade);
  #ifdef __backtest__
  if (curr_spread > 10) { PrintFormat("%s: Error %d: %s", __FUNCTION__, __LINE__, "Backtesting over 10 pips not supported, sorry."); ExpertRemove(); }
  #endif
  return curr_spread <= spread_limit;
}

#endif

/**
 * Close order.
 */
bool CloseOrder(int ticket_no = EMPTY, int reason_id = EMPTY, bool retry = TRUE) {
  bool result = FALSE;
  if (ticket_no > 0) {
    if (!OrderSelect(ticket_no, SELECT_BY_TICKET)) {
      return (FALSE);
    }
  } else {
    ticket_no = OrderTicket();
  }
  double close_price = NormalizeDouble(Market::GetClosePrice(), Digits);
  result = OrderClose(ticket_no, OrderLots(), close_price, max_order_slippage, GetOrderColor()); // @fixme: warning 43: possible loss of data due to type conversion
  // if (VerboseTrace) Print(__FUNCTION__ + ": CloseOrder request. Reason: " + reason + "; Result=" + result + " @ " + TimeCurrent() + "(" + TimeToStr(TimeCurrent()) + "), ticket# " + ticket_no);
  if (result) {
    total_orders--;
    last_close_profit = Order::GetOrderProfit();
    if (SoundAlert) PlaySound(SoundFileAtClose);
    // TaskAddCalcStats(ticket_no); // Already done on CheckHistory().
    last_msg = StringFormat("Closed order %d with profit %g pips (%s)", ticket_no, Order::GetOrderProfit(), ReasonIdToText(reason_id));
    Message(last_msg);
    Msg::ShowText(last_msg, "Info", __FUNCTION__, __LINE__, VerboseInfo);
    last_debug = Msg::ShowText(Order::GetOrderToText(), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    #ifdef __advanced__
      if (VerboseDebug) Print(__FUNCTION__, ": Closed order " + IntegerToString(ticket_no) + " with profit " + DoubleToStr(Order::GetOrderProfit()) + " pips, reason: " + ReasonIdToText(reason_id) + "; " + Order::GetOrderToText());
      if (SmartQueueActive) OrderQueueProcess();
    #else
      if (VerboseDebug) Print(__FUNCTION__, ": Closed order " + IntegerToString(ticket_no) + " with profit " + DoubleToStr(Order::GetOrderProfit()) + " pips; " + Order::GetOrderToText());
    #endif
  } else {
    err_code = GetLastError();
    if (VerboseErrors) Print(__FUNCTION__, ": Error: Ticket: ", ticket_no, "; Error: ", GetErrorText(err_code));
    if (VerboseDebug) PrintFormat("Error: OrderClose(%d, %f, %f, %f, %d);", ticket_no, OrderLots(), close_price, max_order_slippage, GetOrderColor());
    if (VerboseDebug) Print(__FUNCTION__ + ": " + GetMarketTextDetails());
    OrderPrint();
    if (retry) TaskAddCloseOrder(ticket_no, reason_id); // Add task to re-try.
    int id = GetIdByMagic();
    if (id < 0) info[id][TOTAL_ERRORS]++;
  } // end-if: !result
  return result;
}

/**
 * Re-calculate statistics based on the order and return the profit value.
 */
double OrderCalc(int ticket_no = 0) {
  // OrderClosePrice(), OrderCloseTime(), OrderComment(), OrderCommission(), OrderExpiration(), OrderLots(), OrderOpenPrice(), OrderOpenTime(), OrderPrint(), OrderProfit(), OrderStopLoss(), OrderSwap(), OrderSymbol(), OrderTakeProfit(), OrderTicket(), OrderType()
  if (ticket_no == 0) ticket_no = OrderTicket();
  int id = GetIdByMagic();
  if (id < 0) return FALSE;
  datetime close_time = OrderCloseTime();
  double profit = Order::GetOrderProfit();
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

  if (DateTime::TimeDayOfYear(close_time) == DayOfYear()) {
    stats[id][DAILY_PROFIT] += profit;
  }
  if (DateTime::TimeDayOfWeek(close_time) <= DayOfWeek()) {
    stats[id][WEEKLY_PROFIT] += profit;
  }
  if (DateTime::TimeDay(close_time) <= Day()) {
    stats[id][MONTHLY_PROFIT] += profit;
  }
  //TicketRemove(ticket_no);
  return profit;
}

/**
 * Close order by type of order and strategy used. See: ENUM_STRATEGY_TYPE.
 *
 * @param
 *   cmd (int) - trade operation command to close (OP_SELL/OP_BUY)
 *   strategy_type (int) - strategy type, see ENUM_STRATEGY_TYPE
 */
int CloseOrdersByType(int cmd, int strategy_id, int reason_id, bool only_profitable = FALSE) {
   int orders_total = 0;
   int order_failed = 0;
   double profit_total = 0.0;
   RefreshRates();
   int order;
   for (order = 0; order < OrdersTotal(); order++) {
      if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
        if (strategy_id == GetIdByMagic() && OrderSymbol() == Symbol() && OrderType() == cmd) {
          if (only_profitable && Order::GetOrderProfit() < 0) continue;
          if (CloseOrder(NULL, reason_id)) {
             orders_total++;
             profit_total += Order::GetOrderProfit();
          } else {
            order_failed++;
          }
        }
      } else {
        if (VerboseDebug)
          Print(__FUNCTION__ + "(" + Convert::OrderTypeToString(cmd) + ", " + IntegerToString(strategy_id) + "): Error: Order: " + IntegerToString(order) + "; Message: ", GetErrorText(err_code));
        // TaskAddCloseOrder(OrderTicket(), reason_id); // Add task to re-try.
      }
   }
   if (orders_total > 0 && VerboseInfo) {
     // FIXME: EnumToString(order_type) doesn't work here.
     Print(__FUNCTION__ + "():" + "Closed ", orders_total, " orders (", cmd, ", ", strategy_id, ") on market change with total profit of : ", profit_total, " pips (", order_failed, " failed)");
   }
   return (orders_total);
}

// Update statistics.
bool UpdateStats() {
  // Check if bar time has been changed since last check.
  // int bar_time = iTime(NULL, PERIOD_M1, 0);
  CheckStats(last_tick_change, MAX_TICK);
  CheckStats(Low[0],  MAX_LOW);
  CheckStats(High[0], MAX_HIGH);
  CheckStats(Account::AccountBalance(), MAX_BALANCE);
  CheckStats(Account::AccountEquity(), MAX_EQUITY);
  CheckStats(total_orders, MAX_ORDERS);
  CheckStats(Market::GetSpreadInPts(), MAX_SPREAD);
  if (last_tick_change > MarketBigDropSize) {
    double diff1 = fmax(Convert::GetValueDiffInPips(Ask, LastAsk), Convert::GetValueDiffInPips(Bid, LastBid));
    Message(StringFormat("Market very big drop of %.1f pips detected!", diff1));
    Print(__FUNCTION__ + ": " + GetLastMessage());
    if (WriteReport) ReportAdd(__FUNCTION__ + ": " + GetLastMessage());
  }
  else if (VerboseDebug && last_tick_change > MarketSuddenDropSize) {
    double diff2 = fmax(Convert::GetValueDiffInPips(Ask, LastAsk), Convert::GetValueDiffInPips(Bid, LastBid));
    Message(StringFormat("Market sudden drop of %.1f pips detected!", diff2));
    Print(__FUNCTION__ + ": " + GetLastMessage());
    if (WriteReport) ReportAdd(__FUNCTION__ + ": " + GetLastMessage());
  }
  return (TRUE);
}

/* INDICATOR FUNCTIONS */

/**
 * Check if AC indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 */
bool Trade_AC(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(AC, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(AC, tf, 0);
  if (signal_level == EMPTY)  signal_level  = GetStrategySignalLevel(AC, tf, 0.0);
  switch (cmd) {
    /*
      //1. Acceleration/Deceleration — AC
      //Buy: if the indicator is above zero and 2 consecutive columns are green or if the indicator is below zero and 3 consecutive columns are green
      //Sell: if the indicator is below zero and 2 consecutive columns are red or if the indicator is above zero and 3 consecutive columns are red
      if ((iAC(NULL,piac,0)>=0&&iAC(NULL,piac,0)>iAC(NULL,piac,1)&&iAC(NULL,piac,1)>iAC(NULL,piac,2))||(iAC(NULL,piac,0)<=0
      && iAC(NULL,piac,0)>iAC(NULL,piac,1)&&iAC(NULL,piac,1)>iAC(NULL,piac,2)&&iAC(NULL,piac,2)>iAC(NULL,piac,3)))
      if ((iAC(NULL,piac,0)<=0&&iAC(NULL,piac,0)<iAC(NULL,piac,1)&&iAC(NULL,piac,1)<iAC(NULL,piac,2))||(iAC(NULL,piac,0)>=0
      && iAC(NULL,piac,0)<iAC(NULL,piac,1)&&iAC(NULL,piac,1)<iAC(NULL,piac,2)&&iAC(NULL,piac,2)<iAC(NULL,piac,3)))
    */
    case OP_BUY:
      /*
        bool result = AC[period][CURR][LOWER] != 0.0 || AC[period][PREV][LOWER] != 0.0 || AC[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !AC_On_Sell(period);
        if ((signal_method &   4) != 0) result = result && AC_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && AC_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && AC[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !AC_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = AC[period][CURR][UPPER] != 0.0 || AC[period][PREV][UPPER] != 0.0 || AC[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !AC_On_Buy(period);
        if ((signal_method &   4) != 0) result = result && AC_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && AC_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && AC[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !AC_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if AD indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_AD(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(AD, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(AD, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(AD, tf, 0.0);
  switch (cmd) {
    /*
      //2. Accumulation/Distribution - A/D
      //Main principle - convergence/divergence
      //Buy: indicator growth at downtrend
      //Sell: indicator fall at uptrend
      if (iAD(NULL,piad,0)>=iAD(NULL,piad,1)&&iClose(NULL,piad2,0)<=iClose(NULL,piad2,1))
      {f2=1;}
      if (iAD(NULL,piad,0)<=iAD(NULL,piad,1)&&iClose(NULL,piad2,0)>=iClose(NULL,piad2,1))
      {f2=-1;}
    */
    case OP_BUY:
      /*
        bool result = AD[period][CURR][LOWER] != 0.0 || AD[period][PREV][LOWER] != 0.0 || AD[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !AD_On_Sell(period);
        if ((signal_method &   4) != 0) result = result && AD_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && AD_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && AD[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !AD_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = AD[period][CURR][UPPER] != 0.0 || AD[period][PREV][UPPER] != 0.0 || AD[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !AD_On_Buy(period);
        if ((signal_method &   4) != 0) result = result && AD_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && AD_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && AD[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !AD_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if ADX indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_ADX(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(ADX, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(ADX, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(ADX, tf, 0.0);
  switch (cmd) {
      //   if(iADX(NULL,0,14,PRICE_HIGH,MODE_MAIN,0)>iADX(NULL,0,14,PRICE_HIGH,MODE_PLUSDI,0)) return(0);
    /*
      //5. Average Directional Movement Index - ADX
      //Buy: +DI line is above -DI line, ADX is more than a certain value and grows (i.e. trend strengthens)
      //Sell: -DI line is above +DI line, ADX is more than a certain value and grows (i.e. trend strengthens)
      if (iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MINUSDI,0)<iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_PLUSDI,0)&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,0)>=minadx&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,0)>iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,1))
      {f5=1;}
      if (iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MINUSDI,0)>iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_PLUSDI,0)&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,0)>=minadx&&iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,0)>iADX(NULL,piadx,piadu,PRICE_CLOSE,MODE_MAIN,1))
      {f5=-1;}
    */
    case OP_BUY:
      /*
        bool result = ADX[period][CURR][LOWER] != 0.0 || ADX[period][PREV][LOWER] != 0.0 || ADX[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !ADX_On_Sell(period);
        if ((signal_method &   4) != 0) result = result && ADX_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && ADX_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && ADX[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !ADX_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = ADX[period][CURR][UPPER] != 0.0 || ADX[period][PREV][UPPER] != 0.0 || ADX[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !ADX_On_Buy(period);
        if ((signal_method &   4) != 0) result = result && ADX_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && ADX_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && ADX[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !ADX_On_Buy(M30);
        */
    break;
  }
  return result;
}


/**
 * Check if Alligator indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Alligator(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  // [x][0] - The Blue line (Alligator's Jaw), [x][1] - The Red Line (Alligator's Teeth), [x][2] - The Green Line (Alligator's Lips)
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(ALLIGATOR, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(ALLIGATOR, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(ALLIGATOR, tf, 0.0);
  double gap = signal_level * pip_size;

  switch(cmd) {
    case OP_BUY:
      result = (
        alligator[period][CURR][LIPS] > alligator[period][CURR][TEETH] + gap && // Check if Lips are above Teeth ...
        alligator[period][CURR][LIPS] > alligator[period][CURR][JAW] + gap && // ... Lips are above Jaw ...
        alligator[period][CURR][TEETH] > alligator[period][CURR][JAW] + gap // ... Teeth are above Jaw ...
        );
      if ((signal_method &   1) != 0) result = result && alligator[period][PREV][LIPS] > alligator[period][PREV][TEETH]; // Check if previous Lips were above Teeth.
      if ((signal_method &   2) != 0) result = result && alligator[period][PREV][LIPS] > alligator[period][PREV][JAW]; // Check if previous Lips were above Jaw.
      if ((signal_method &   4) != 0) result = result && alligator[period][PREV][TEETH] > alligator[period][PREV][JAW]; // Check if previous Teeth were above Jaw.
      if ((signal_method &   8) != 0) result = result && alligator[period][CURR][LIPS] < alligator[period][PREV][LIPS]; // Check if Lips decreased since last bar.
      if ((signal_method &  16) != 0) result = result && alligator[period][CURR][LIPS] - alligator[period][PREV][TEETH] > alligator[period][PREV][TEETH] - alligator[period][PREV][JAW];
      if ((signal_method &  32) != 0) result = result && (
        alligator[period][FAR][LIPS] < alligator[period][FAR][TEETH] || // Check if Lips are below Teeth and ...
        alligator[period][FAR][LIPS] < alligator[period][FAR][JAW] || // ... Lips are below Jaw and ...
        alligator[period][FAR][TEETH] < alligator[period][FAR][JAW] // ... Teeth are below Jaw ...
        );
      /* TODO:
            //3. Alligator & Fractals
            //Buy: all 3 Alligator lines grow/ don't fall/ (3 periods in succession) and fractal (upper line) is above teeth
            //Sell: all 3 Alligator lines fall/don't grow/ (3 periods in succession) and fractal (lower line) is below teeth
            //Fracal shift=2 because of the indicator nature
            if (iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,2)<=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,1)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,1)<=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,0)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,2)<=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,1)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,1)<=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,0)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,2)<=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,1)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,1)<=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,0)
            && iFractals(NULL,pifr,UPPER,2)>=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,0))
            {f3=1;}
            if (iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,2)>=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,1)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,1)>=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORLIPS,0)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,2)>=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,1)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,1)>=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORJAW,0)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,2)>=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,1)
            && iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,1)>=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,0)
            && iFractals(NULL,pifr,LOWER,2)<=iAlligator(NULL,piall,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,MODE_GATORTEETH,0))
            {f3=-1;}
      */
      break;
    case OP_SELL:
      result = (
        alligator[period][CURR][LIPS] + gap < alligator[period][CURR][TEETH] && // Check if Lips are below Teeth and ...
        alligator[period][CURR][LIPS] + gap < alligator[period][CURR][JAW] && // ... Lips are below Jaw and ...
        alligator[period][CURR][TEETH] + gap < alligator[period][CURR][JAW] // ... Teeth are below Jaw ...
        );
      if ((signal_method &   1) != 0) result = result && alligator[period][PREV][LIPS] < alligator[period][PREV][TEETH]; // Check if previous Lips were below Teeth.
      if ((signal_method &   2) != 0) result = result && alligator[period][PREV][LIPS] < alligator[period][PREV][JAW]; // Previous Lips were below Jaw.
      if ((signal_method &   4) != 0) result = result && alligator[period][PREV][TEETH] < alligator[period][PREV][JAW]; // Previous Teeth were below Jaw.
      if ((signal_method &   8) != 0) result = result && alligator[period][CURR][LIPS] > alligator[period][PREV][LIPS]; // Check if Lips increased since last bar.
      if ((signal_method &  16) != 0) result = result && alligator[period][PREV][TEETH] - alligator[period][CURR][LIPS] > alligator[period][PREV][JAW] - alligator[period][PREV][TEETH];
      if ((signal_method &  32) != 0) result = result && (
        alligator[period][FAR][LIPS] > alligator[period][FAR][TEETH] || // Check if Lips are above Teeth ...
        alligator[period][FAR][LIPS] > alligator[period][FAR][JAW] || // ... Lips are above Jaw ...
        alligator[period][FAR][TEETH] > alligator[period][FAR][JAW] // ... Teeth are above Jaw ...
        );
      break;
  }
  return result;
}

/**
 * Check if ATR indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_ATR(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(ATR, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(ATR, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(ATR, tf, 0.0);
  switch (cmd) {
    //   if(iATR(NULL,0,12,0)>iATR(NULL,0,20,0)) return(0);
    /*
      //6. Average True Range - ATR
      //Doesn't give independent signals. Is used to define volatility (trend strength).
      //principle: trend must be strengthened. Together with that ATR grows.
      //Because of the chart form it is inconvenient to analyze rise/fall. Only exceeding of threshold value is checked.
      //Flag is 1 when ATR is above threshold value (i.e. there is a trend), 0 - when ATR is below threshold value, -1 - never.
      if (iATR(NULL,piatr,piatru,0)>=minatr)
      {f6=1;}
    */
    case OP_BUY:
      /*
        bool result = ATR[period][CURR][LOWER] != 0.0 || ATR[period][PREV][LOWER] != 0.0 || ATR[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !ATR_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && ATR_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && ATR_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && ATR[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !ATR_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = ATR[period][CURR][UPPER] != 0.0 || ATR[period][PREV][UPPER] != 0.0 || ATR[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !ATR_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && ATR_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && ATR_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && ATR[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !ATR_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if Awesome indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Awesome(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(AWESOME, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(AWESOME, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(AWESOME, tf, 0.0);
  switch (cmd) {
    /*
      //7. Awesome Oscillator
      //Buy: 1. Signal "saucer" (3 positive columns, medium column is smaller than 2 others); 2. Changing from negative values to positive.
      //Sell: 1. Signal "saucer" (3 negative columns, medium column is larger than 2 others); 2. Changing from positive values to negative.
      if ((iAO(NULL,piao,2)>0&&iAO(NULL,piao,1)>0&&iAO(NULL,piao,0)>0&&iAO(NULL,piao,1)<iAO(NULL,piao,2)&&iAO(NULL,piao,1)<iAO(NULL,piao,0))||(iAO(NULL,piao,1)<0&&iAO(NULL,piao,0)>0))
      {f7=1;}
      if ((iAO(NULL,piao,2)<0&&iAO(NULL,piao,1)<0&&iAO(NULL,piao,0)<0&&iAO(NULL,piao,1)>iAO(NULL,piao,2)&&iAO(NULL,piao,1)>iAO(NULL,piao,0))||(iAO(NULL,piao,1)>0&&iAO(NULL,piao,0)<0))
      {f7=-1;}
    */
    case OP_BUY:
      /*
        bool result = Awesome[period][CURR][LOWER] != 0.0 || Awesome[period][PREV][LOWER] != 0.0 || Awesome[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !Awesome_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && Awesome_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && Awesome_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && Awesome[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !Awesome_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = Awesome[period][CURR][UPPER] != 0.0 || Awesome[period][PREV][UPPER] != 0.0 || Awesome[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !Awesome_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && Awesome_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && Awesome_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && Awesome[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !Awesome_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if Bands indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Bands(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(BANDS, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(BANDS, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(BANDS, tf, 0);
  double lowest = fmin(Low[CURR], fmin(Low[PREV], Low[FAR]));
  double highest = fmax(High[CURR], fmax(High[PREV], High[FAR]));
  switch (cmd) {
    case OP_BUY:
      // Price value was lower than the lower band.
      result = (
          lowest < fmax(fmax(bands[period][CURR][BANDS_LOWER], bands[period][PREV][BANDS_LOWER]), bands[period][FAR][BANDS_LOWER])
          );
      // Buy: price crossed lower line upwards (returned to it from below).
      if ((signal_method &   1) != 0) result = result && fmin(Close[PREV], Close[FAR]) < bands[period][CURR][BANDS_LOWER];
      if ((signal_method &   2) != 0) result = result && (bands[period][CURR][BANDS_LOWER] > bands[period][FAR][BANDS_LOWER]);
      if ((signal_method &   4) != 0) result = result && (bands[period][CURR][BANDS_BASE] > bands[period][FAR][BANDS_BASE]);
      if ((signal_method &   8) != 0) result = result && (bands[period][CURR][BANDS_UPPER] > bands[period][FAR][BANDS_UPPER]);
      if ((signal_method &  16) != 0) result = result && highest > bands[period][CURR][BANDS_BASE];
      if ((signal_method &  32) != 0) result = result && Open[CURR] < bands[period][CURR][BANDS_BASE];
      if ((signal_method &  64) != 0) result = result && fmin(Close[PREV], Close[FAR]) > bands[period][CURR][BANDS_BASE];
      if ((signal_method & 128) != 0) result = result && !Trade_Bands(Convert::OrderTypeOpp(cmd), (ENUM_TIMEFRAMES) Convert::IndexToTf(fmin(period + 1, M30)));
    case OP_SELL:
      // Price value was higher than the upper band.
      result = (
          highest > fmin(fmin(bands[period][CURR][BANDS_UPPER], bands[period][PREV][BANDS_UPPER]), bands[period][FAR][BANDS_UPPER])
          );
      // Sell: price crossed upper line downwards (returned to it from above).
      if ((signal_method &   1) != 0) result = result && fmin(Close[PREV], Close[FAR]) > bands[period][CURR][BANDS_UPPER];
      if ((signal_method &   2) != 0) result = result && (bands[period][CURR][BANDS_LOWER] < bands[period][FAR][BANDS_LOWER]);
      if ((signal_method &   4) != 0) result = result && (bands[period][CURR][BANDS_BASE] < bands[period][FAR][BANDS_BASE]);
      if ((signal_method &   8) != 0) result = result && (bands[period][CURR][BANDS_UPPER] < bands[period][FAR][BANDS_UPPER]);
      if ((signal_method &  16) != 0) result = result && lowest < bands[period][CURR][BANDS_BASE];
      if ((signal_method &  32) != 0) result = result && Open[CURR] > bands[period][CURR][BANDS_BASE];
      if ((signal_method &  64) != 0) result = result && fmin(Close[PREV], Close[FAR]) < bands[period][CURR][BANDS_BASE];
      if ((signal_method & 128) != 0) result = result && !Trade_Bands(Convert::OrderTypeOpp(cmd), (ENUM_TIMEFRAMES) Convert::IndexToTf(fmin(period + 1, M30)));
      break;
  }

  return result;
}

/**
 * Check if BPower indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_BPower(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(BPOWER, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(BPOWER, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(BPOWER, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = BPower[period][CURR][LOWER] != 0.0 || BPower[period][PREV][LOWER] != 0.0 || BPower[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !BPower_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && BPower_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && BPower_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && BPower[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !BPower_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = BPower[period][CURR][UPPER] != 0.0 || BPower[period][PREV][UPPER] != 0.0 || BPower[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !BPower_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && BPower_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && BPower_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && BPower[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !BPower_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if Breakage indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Breakage(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  // if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(BWMFI, tf, 0);
  // if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(BWMFI, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = Breakage[period][CURR][LOWER] != 0.0 || Breakage[period][PREV][LOWER] != 0.0 || Breakage[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !Breakage_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && Breakage_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && Breakage_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && Breakage[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !Breakage_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = Breakage[period][CURR][UPPER] != 0.0 || Breakage[period][PREV][UPPER] != 0.0 || Breakage[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !Breakage_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && Breakage_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && Breakage_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && Breakage[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !Breakage_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if BWMFI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_BWMFI(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(BWMFI, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(BWMFI, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(BWMFI, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = BWMFI[period][CURR][LOWER] != 0.0 || BWMFI[period][PREV][LOWER] != 0.0 || BWMFI[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !BWMFI_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && BWMFI_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && BWMFI_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && BWMFI[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !BWMFI_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = BWMFI[period][CURR][UPPER] != 0.0 || BWMFI[period][PREV][UPPER] != 0.0 || BWMFI[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !BWMFI_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && BWMFI_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && BWMFI_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && BWMFI[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !BWMFI_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if CCI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_CCI(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(CCI, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(CCI, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(CCI, tf, 0.0);
  switch (cmd) {
    //   if(iCCI(Symbol(),0,12,PRICE_TYPICAL,0)>iCCI(Symbol(),0,20,PRICE_TYPICAL,0)) return(0);
    /*
      //11. Commodity Channel Index
      //Buy: 1. indicator crosses +100 from below upwards. 2. Crossing -100 from below upwards. 3.
      //Sell: 1. indicator crosses -100 from above downwards. 2. Crossing +100 downwards. 3.
      if ((iCCI(NULL,picci,picciu,PRICE_TYPICAL,1)<100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,0)>=100)||(iCCI(NULL,picci,picciu,PRICE_TYPICAL,1)<-100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,0)>=-100))
      {f11=1;}
      if ((iCCI(NULL,picci,picciu,PRICE_TYPICAL,1)>-100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,0)<=-100)||(iCCI(NULL,picci,picciu,PRICE_TYPICAL,1)>100&&iCCI(NULL,picci,picciu,PRICE_TYPICAL,0)<=100))
      {f11=-1;}
    */
    case OP_BUY:
      /*
        bool result = CCI[period][CURR][LOWER] != 0.0 || CCI[period][PREV][LOWER] != 0.0 || CCI[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !CCI_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && CCI_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && CCI_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && CCI[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !CCI_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = CCI[period][CURR][UPPER] != 0.0 || CCI[period][PREV][UPPER] != 0.0 || CCI[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !CCI_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && CCI_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && CCI_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && CCI[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !CCI_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if DeMarker indicator is on buy or sell.
 * Demarker Technical Indicator is based on the comparison of the period maximum with the previous period maximum.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_DeMarker(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(DEMARKER, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(DEMARKER, tf, 0);
  if (signal_level == EMPTY)  signal_level  = GetStrategySignalLevel(DEMARKER, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      result = demarker[period][CURR] <= 0.5 - signal_level;
      if ((signal_method &   1) != 0) result = result && demarker[period][PREV] < 0.5 - signal_level;
      if ((signal_method &   2) != 0) result = result && demarker[period][FAR] < 0.5 - signal_level;
      if ((signal_method &   4) != 0) result = result && demarker[period][CURR] < demarker[period][PREV];
      if ((signal_method &   8) != 0) result = result && demarker[period][PREV] < demarker[period][FAR];
      if ((signal_method &  16) != 0) result = result && demarker[period][PREV] < 0.5 - signal_level - signal_level/2;
      // PrintFormat("DeMarker buy: %g <= %g", demarker[period][CURR], 0.5 - signal_level);
      break;
    case OP_SELL:
      result = demarker[period][CURR] >= 0.5 + signal_level;
      if ((signal_method &   1) != 0) result = result && demarker[period][PREV] > 0.5 + signal_level;
      if ((signal_method &   2) != 0) result = result && demarker[period][FAR] > 0.5 + signal_level;
      if ((signal_method &   4) != 0) result = result && demarker[period][CURR] > demarker[period][PREV];
      if ((signal_method &   8) != 0) result = result && demarker[period][PREV] > demarker[period][FAR];
      if ((signal_method &  16) != 0) result = result && demarker[period][PREV] > 0.5 + signal_level + signal_level/2;
      // PrintFormat("DeMarker sell: %g >= %g", demarker[period][CURR], 0.5 + signal_level);
      break;
  }

  return result;
}

/**
 * Check if Envelopes indicator is on sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Envelopes(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(ENVELOPES, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(ENVELOPES, tf, 0);
  if (signal_level == EMPTY)  signal_level  = GetStrategySignalLevel(ENVELOPES, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      result = Low[CURR] < envelopes[period][CURR][LOWER] || Low[PREV] < envelopes[period][CURR][LOWER]; // price low was below the lower band
      // result = result || (envelopes[period][CURR][MODE_MAIN] > envelopes[period][FAR][MODE_MAIN] && Open[CURR] > envelopes[period][CURR][UPPER]);
      if ((signal_method &   1) != 0) result = result && Open[CURR] > envelopes[period][CURR][LOWER]; // FIXME
      if ((signal_method &   2) != 0) result = result && envelopes[period][CURR][MODE_MAIN] < envelopes[period][PREV][MODE_MAIN];
      if ((signal_method &   4) != 0) result = result && envelopes[period][CURR][LOWER] < envelopes[period][PREV][LOWER];
      if ((signal_method &   8) != 0) result = result && envelopes[period][CURR][UPPER] < envelopes[period][PREV][UPPER];
      if ((signal_method &  16) != 0) result = result && envelopes[period][CURR][UPPER] - envelopes[period][CURR][LOWER] > envelopes[period][PREV][UPPER] - envelopes[period][PREV][LOWER];
      if ((signal_method &  32) != 0) result = result && Ask < envelopes[period][CURR][MODE_MAIN];
      if ((signal_method &  64) != 0) result = result && Close[CURR] < envelopes[period][CURR][UPPER];
      //if ((signal_method & 128) != 0) result = result && Ask > Close[PREV];
      break;
    case OP_SELL:
      result = High[CURR] > envelopes[period][CURR][UPPER] || High[PREV] > envelopes[period][CURR][UPPER]; // price high was above the upper band
      // result = result || (envelopes[period][CURR][MODE_MAIN] < envelopes[period][FAR][MODE_MAIN] && Open[CURR] < envelopes[period][CURR][LOWER]);
      if ((signal_method &   1) != 0) result = result && Open[CURR] < envelopes[period][CURR][UPPER]; // FIXME
      if ((signal_method &   2) != 0) result = result && envelopes[period][CURR][MODE_MAIN] > envelopes[period][PREV][MODE_MAIN];
      if ((signal_method &   4) != 0) result = result && envelopes[period][CURR][LOWER] > envelopes[period][PREV][LOWER];
      if ((signal_method &   8) != 0) result = result && envelopes[period][CURR][UPPER] > envelopes[period][PREV][UPPER];
      if ((signal_method &  16) != 0) result = result && envelopes[period][CURR][UPPER] - envelopes[period][CURR][LOWER] > envelopes[period][PREV][UPPER] - envelopes[period][PREV][LOWER];
      if ((signal_method &  32) != 0) result = result && Ask > envelopes[period][CURR][MODE_MAIN];
      if ((signal_method &  64) != 0) result = result && Close[CURR] > envelopes[period][CURR][UPPER];
      //if ((signal_method & 128) != 0) result = result && Ask < Close[PREV];
      break;
  }
  return result;
}

/**
 * Check if Force indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Force(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(FORCE, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(FORCE, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(FORCE, tf, 0.0);
  switch (cmd) {
    /*
      //14. Force Index
      //To use the indicator it should be correlated with another trend indicator
      //Flag 14 is 1, when FI recommends to buy (i.e. FI<0)
      //Flag 14 is -1, when FI recommends to sell (i.e. FI>0)
      if (iForce(NULL,piforce,piforceu,MODE_SMA,PRICE_CLOSE,0)<0)
      {f14=1;}
      if (iForce(NULL,piforce,piforceu,MODE_SMA,PRICE_CLOSE,0)>0)
      {f14=-1;}
    */
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if Fractals indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Fractals(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int index = Convert::TfToIndex(tf);
  UpdateIndicator(FRACTALS, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(FRACTALS, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(FRACTALS, tf, 0.0);
  bool lower = (fractals[index][CURR][LOWER] != 0.0 || fractals[index][PREV][LOWER] != 0.0 || fractals[index][FAR][LOWER] != 0.0);
  bool upper = (fractals[index][CURR][UPPER] != 0.0 || fractals[index][PREV][UPPER] != 0.0 || fractals[index][FAR][UPPER] != 0.0);
  switch (cmd) {
    case OP_BUY:
      result = lower;
      if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[PREV];
      if ((signal_method &   2) != 0) result = result && Bid > Open[CURR];
      // if ((signal_method &   1) != 0) result &= !Trade_Fractals(Convert::OrderTypeOpp(cmd), PERIOD_M30);
      // if ((signal_method &   2) != 0) result &= !Trade_Fractals(Convert::OrderTypeOpp(cmd), Convert::IndexToTf(fmax(index + 1, M30)));
      // if ((signal_method &   4) != 0) result &= !Trade_Fractals(Convert::OrderTypeOpp(cmd), Convert::IndexToTf(fmax(index + 2, M30)));
      // if ((signal_method &   2) != 0) result = result && !Fractals_On_Sell(tf);
      // if ((signal_method &   8) != 0) result = result && Fractals_On_Buy(M30);
      break;
    case OP_SELL:
      result = upper;
      if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[PREV];
      if ((signal_method &   2) != 0) result = result && Ask < Open[CURR];
      // if ((signal_method &   1) != 0) result &= !Trade_Fractals(Convert::OrderTypeOpp(cmd), PERIOD_M30);
      // if ((signal_method &   2) != 0) result &= !Trade_Fractals(Convert::OrderTypeOpp(cmd), Convert::IndexToTf(fmax(index + 1, M30)));
      // if ((signal_method &   4) != 0) result &= !Trade_Fractals(Convert::OrderTypeOpp(cmd), Convert::IndexToTf(fmax(index + 2, M30)));
      // if ((signal_method &   2) != 0) result = result && !Fractals_On_Buy(tf);
      // if ((signal_method &   8) != 0) result = result && Fractals_On_Sell(M30);
      break;
  }
  return result;
}

/**
 * Check if Gator indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Gator(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(GATOR, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(GATOR, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(GATOR, tf, 0.0);
  switch (cmd) {
    /*
      //4. Gator Oscillator
      //Doesn't give independent signals. Is used for Alligator correction.
      //Principle: trend must be strengthened. Together with this Gator Oscillator goes up.
      //Lower part of diagram is taken for calculations. Growth is checked on 4 periods.
      //The flag is 1 of trend is strengthened, 0 - no strengthening, -1 - never.
      //Uses part of Alligator's variables
      if (iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,3)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,2)&&iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,2)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,1)&&iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,1)>iGator(NULL,piga,jaw_tf,jaw_shift,teeth_tf,teeth_shift,lips_tf,lips_shift,MODE_SMMA,PRICE_MEDIAN,LOWER,0))
      {f4=1;}
    */
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if Ichimoku indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Ichimoku(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(ICHIMOKU, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(ICHIMOKU, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(ICHIMOKU, tf, 0.0);
  switch (cmd) {
    /*
      //15. Ichimoku Kinko Hyo (1)
      //Buy: Price crosses Senkou Span-B upwards; price is outside Senkou Span cloud
      //Sell: Price crosses Senkou Span-B downwards; price is outside Senkou Span cloud
      if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,1)>iClose(NULL,pich2,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0)<=iClose(NULL,pich2,0)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)<iClose(NULL,pich2,0))
      {f15=1;}
      if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,1)<iClose(NULL,pich2,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0)>=iClose(NULL,pich2,0)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)>iClose(NULL,pich2,0))
      {f15=-1;}
    */
    /*
      //16. Ichimoku Kinko Hyo (2)
      //Buy: Tenkan-sen crosses Kijun-sen upwards
      //Sell: Tenkan-sen crosses Kijun-sen downwards
      //VERSION EXISTS, IN THIS CASE PRICE MUSTN'T BE IN THE CLOUD!
      if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,1)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,0)>=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,0))
      {f16=1;}
      if (iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,1)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_TENKANSEN,0)<=iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_KIJUNSEN,0))
      {f16=-1;}
    */

    /*
      //17. Ichimoku Kinko Hyo (3)
      //Buy: Chinkou Span crosses chart upwards; price is ib the cloud
      //Sell: Chinkou Span crosses chart downwards; price is ib the cloud
      if ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+1)<iClose(NULL,pich2,pkijun+1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+0)>=iClose(NULL,pich2,pkijun+0))&&((iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))||(iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))))
      {f17=1;}
      if ((iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+1)>iClose(NULL,pich2,pkijun+1)&&iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_CHINKOUSPAN,pkijun+0)<=iClose(NULL,pich2,pkijun+0))&&((iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))||(iClose(NULL,pich2,0)<iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANA,0)&&iClose(NULL,pich2,0)>iIchimoku(NULL,pich,ptenkan,pkijun,psenkou,MODE_SENKOUSPANB,0))))
      {f17=-1;}
    */
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if MA indicator is on buy.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_MA(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(MA, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(MA, tf, 0);
  if (signal_level == EMPTY)  signal_level  = GetStrategySignalLevel(MA, tf, 0);
  double gap = signal_level * pip_size;

  switch (cmd) {
    case OP_BUY:
      result  = ma_fast[period][CURR]   > ma_medium[period][CURR] + gap;
      result &= ma_medium[period][CURR] > ma_slow[period][CURR];
      if ((signal_method &   1) != 0) result &= ma_fast[period][CURR] > ma_slow[period][CURR] + gap;
      if ((signal_method &   2) != 0) result &= ma_medium[period][CURR] > ma_slow[period][CURR];
      if ((signal_method &   4) != 0) result &= ma_slow[period][CURR] > ma_slow[period][PREV];
      if ((signal_method &   8) != 0) result &= ma_fast[period][CURR] > ma_fast[period][PREV];
      if ((signal_method &  16) != 0) result &= ma_fast[period][CURR] - ma_medium[period][CURR] > ma_medium[period][CURR] - ma_slow[period][CURR];
      if ((signal_method &  32) != 0) result &= (ma_medium[period][PREV] < ma_slow[period][PREV] || ma_medium[period][FAR] < ma_slow[period][FAR]);
      if ((signal_method &  64) != 0) result &= (ma_fast[period][PREV] < ma_medium[period][PREV] || ma_fast[period][FAR] < ma_medium[period][FAR]);
      break;
    case OP_SELL:
      result  = ma_fast[period][CURR]   < ma_medium[period][CURR] - gap;
      result &= ma_medium[period][CURR] < ma_slow[period][CURR];
      if ((signal_method &   1) != 0) result &= ma_fast[period][CURR] < ma_slow[period][CURR] - gap;
      if ((signal_method &   2) != 0) result &= ma_medium[period][CURR] < ma_slow[period][CURR];
      if ((signal_method &   4) != 0) result &= ma_slow[period][CURR] < ma_slow[period][PREV];
      if ((signal_method &   8) != 0) result &= ma_fast[period][CURR] < ma_fast[period][PREV];
      if ((signal_method &  16) != 0) result &= ma_medium[period][CURR] - ma_fast[period][CURR] > ma_slow[period][CURR] - ma_medium[period][CURR];
      if ((signal_method &  32) != 0) result &= (ma_medium[period][PREV] > ma_slow[period][PREV] || ma_medium[period][FAR] > ma_slow[period][FAR]);
      if ((signal_method &  64) != 0) result &= (ma_fast[period][PREV] > ma_medium[period][PREV] || ma_fast[period][FAR] > ma_medium[period][FAR]);
      break;
  }
  return result;
}

/**
 * Check if MACD indicator is on buy.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_MACD(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(MA, tf);
  UpdateIndicator(MACD, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(MACD, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(MACD, tf, 0);
  double gap = signal_level * pip_size;
  switch (cmd) {
    /* TODO:
          //20. MACD (1)
          //VERSION EXISTS, THAT THE SIGNAL TO BUY IS TRUE ONLY IF MACD<0, SIGNAL TO SELL - IF MACD>0
          //Buy: MACD rises above the signal line
          //Sell: MACD falls below the signal line
          if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,1)<iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,1)
          && iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,0)>=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,0))
          {f20=1;}
          if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,1)>iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,1)
          && iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,0)<=iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_SIGNAL,0))
          {f20=-1;}

          //21. MACD (2)
          //Buy: crossing 0 upwards
          //Sell: crossing 0 downwards
          if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,1)<0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,0)>=0)
          {f21=1;}
          if(iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,1)>0&&iMACD(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,MODE_MAIN,0)<=0)
          {f21=-1;}
    */
    case OP_BUY:
      result = macd[period][CURR][MODE_MAIN] > macd[period][CURR][MODE_SIGNAL] + gap; // MACD rises above the signal line.
      if ((signal_method &   1) != 0) result = result && macd[period][FAR][MODE_MAIN] < macd[period][FAR][MODE_SIGNAL];
      if ((signal_method &   2) != 0) result = result && macd[period][CURR][MODE_MAIN] >= 0;
      if ((signal_method &   4) != 0) result = result && macd[period][PREV][MODE_MAIN] < 0;
      if ((signal_method &   8) != 0) result = result && ma_fast[period][CURR] > ma_fast[period][PREV];
      if ((signal_method &  16) != 0) result = result && ma_fast[period][CURR] > ma_medium[period][CURR];
      break;
    case OP_SELL:
      result = macd[period][CURR][MODE_MAIN] < macd[period][CURR][MODE_SIGNAL] - gap; // MACD falls below the signal line.
      if ((signal_method &   1) != 0) result = result && macd[period][FAR][MODE_MAIN] > macd[period][FAR][MODE_SIGNAL];
      if ((signal_method &   2) != 0) result = result && macd[period][CURR][MODE_MAIN] <= 0;
      if ((signal_method &   4) != 0) result = result && macd[period][PREV][MODE_MAIN] > 0;
      if ((signal_method &   8) != 0) result = result && ma_fast[period][CURR] < ma_fast[period][PREV];
      if ((signal_method &  16) != 0) result = result && ma_fast[period][CURR] < ma_medium[period][CURR];
      break;
  }
  return result;
}

/**
 * Check if MFI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_MFI(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(MFI, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(MFI, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(MFI, tf, 0.0);
  switch (cmd) {
    /*
      //18. Money Flow Index - MFI
      //Buy: Crossing 20 upwards
      //Sell: Crossing 20 downwards
      if(iMFI(NULL,pimfi,barsimfi,1)<20&&iMFI(NULL,pimfi,barsimfi,0)>=20)
      {f18=1;}
      if(iMFI(NULL,pimfi,barsimfi,1)>80&&iMFI(NULL,pimfi,barsimfi,0)<=80)
      {f18=-1;}]
    */
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if Momentum indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Momentum(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(MOMENTUM, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(MOMENTUM, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(MOMENTUM, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if OBV indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_OBV(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(OBV, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(OBV, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(OBV, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if OSMA indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_OSMA(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(OSMA, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(OSMA, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(OSMA, tf, 0.0);
  switch (cmd) {
    /*
      //22. Moving Average of Oscillator (MACD histogram) (1)
      //Buy: histogram is below zero and changes falling direction into rising (5 columns are taken)
      //Sell: histogram is above zero and changes its rising direction into falling (5 columns are taken)
      if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0)<0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
      {f22=1;}
      if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0)>0&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,4)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,3)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
      {f22=-1;}
    */

    /*
      //23. Moving Average of Oscillator (MACD histogram) (2)
      //To use the indicator it should be correlated with another trend indicator
      //Flag 23 is 1, when MACD histogram recommends to buy (i.e. histogram is sloping upwards)
      //Flag 23 is -1, when MACD histogram recommends to sell (i.e. histogram is sloping downwards)
      //3 columns are taken for calculation
      if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)<=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
      {f23=1;}
      if(iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,2)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)&&iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,1)>=iOsMA(NULL,pimacd,fastpimacd,slowpimacd,signalpimacd,PRICE_CLOSE,0))
      {f23=-1;}
    */
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if RSI indicator is on buy.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level - signal level to consider the signal
 */
bool Trade_RSI(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(RSI, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(RSI, tf, 0);
  if (signal_level == EMPTY)  signal_level  = GetStrategySignalLevel(RSI, tf, 20);
  switch (cmd) {
    case OP_BUY:
      result = rsi[period][CURR] <= (50 - signal_level);
      if ((signal_method &   1) != 0) result = result && rsi[period][CURR] < rsi[period][PREV];
      if ((signal_method &   2) != 0) result = result && rsi[period][PREV] < rsi[period][FAR];
      if ((signal_method &   4) != 0) result = result && rsi[period][PREV] < (50 - signal_level);
      if ((signal_method &   8) != 0) result = result && rsi[period][FAR]  < (50 - signal_level);
      if ((signal_method &  16) != 0) result = result && rsi[period][CURR] - rsi[period][PREV] > rsi[period][PREV] - rsi[period][FAR];
      if ((signal_method &  32) != 0) result = result && rsi[period][FAR] > 50;
      //if ((signal_method &  32) != 0) result = result && Open[CURR] > Close[PREV];
      //if ((signal_method & 128) != 0) result = result && !RSI_On_Sell(M30);
      break;
    case OP_SELL:
      result = rsi[period][CURR] >= (50 + signal_level);
      if ((signal_method &   1) != 0) result = result && rsi[period][CURR] > rsi[period][PREV];
      if ((signal_method &   2) != 0) result = result && rsi[period][PREV] > rsi[period][FAR];
      if ((signal_method &   4) != 0) result = result && rsi[period][PREV] > (50 + signal_level);
      if ((signal_method &   8) != 0) result = result && rsi[period][FAR]  > (50 + signal_level);
      if ((signal_method &  16) != 0) result = result && rsi[period][PREV] - rsi[period][CURR] > rsi[period][FAR] - rsi[period][PREV];
      if ((signal_method &  32) != 0) result = result && rsi[period][FAR] < 50;
      //if ((signal_method &  32) != 0) result = result && Open[CURR] < Close[PREV];
      //if ((signal_method & 128) != 0) result = result && !RSI_On_Buy(M30);
      break;
  }
  return result;
}

/**
 * Check if RVI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_RVI(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(RVI, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(RVI, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(RVI, tf, 20);
  switch (cmd) {
    /*
      //26. RVI
      //RECOMMENDED TO USE WITH A TREND INDICATOR
      //Buy: main line (green) crosses signal (red) upwards
      //Sell: main line (green) crosses signal (red) downwards
      if(iRVI(NULL,pirvi,pirviu,MODE_MAIN,1)<iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,1)
      && iRVI(NULL,pirvi,pirviu,MODE_MAIN,0)>=iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,0))
      {f26=1;}
      if(iRVI(NULL,pirvi,pirviu,MODE_MAIN,1)>iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,1)
      && iRVI(NULL,pirvi,pirviu,MODE_MAIN,0)<=iRVI(NULL,pirvi,pirviu,MODE_SIGNAL,0))
      {f26=-1;}
    */
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/**
 * Check if SAR indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal (in pips)
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_SAR(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(SAR, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(SAR, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(SAR, tf, 0);
  double gap = signal_level * pip_size;
  switch (cmd) {
    case OP_BUY:
      result = sar[period][CURR] + gap < Open[CURR] || sar[period][PREV] + gap < Open[PREV];
      if ((signal_method &   1) != 0) result = result && sar[period][PREV] - gap > Ask;
      if ((signal_method &   2) != 0) result = result && sar[period][CURR] < sar[period][PREV];
      if ((signal_method &   4) != 0) result = result && sar[period][CURR] - sar[period][PREV] <= sar[period][PREV] - sar[period][FAR];
      if ((signal_method &   8) != 0) result = result && sar[period][FAR] > Ask;
      if ((signal_method &  16) != 0) result = result && sar[period][CURR] <= Close[CURR];
      if ((signal_method &  32) != 0) result = result && sar[period][PREV] > Close[PREV];
      if ((signal_method &  64) != 0) result = result && sar[period][PREV] > Open[PREV];
      if (result) {
        // FIXME: Convert into more flexible way.
        signals[DAILY][SAR1][period][OP_BUY]++; signals[WEEKLY][SAR1][period][OP_BUY]++;
        signals[MONTHLY][SAR1][period][OP_BUY]++; signals[YEARLY][SAR1][period][OP_BUY]++;
      }
      break;
    case OP_SELL:
      result = sar[period][CURR] - gap > Open[CURR] || sar[period][PREV] - gap > Open[PREV];
      if ((signal_method &   1) != 0) result = result && sar[period][PREV] + gap < Ask;
      if ((signal_method &   2) != 0) result = result && sar[period][CURR] > sar[period][PREV];
      if ((signal_method &   4) != 0) result = result && sar[period][PREV] - sar[period][CURR] <= sar[period][FAR] - sar[period][PREV];
      if ((signal_method &   8) != 0) result = result && sar[period][FAR] < Ask;
      if ((signal_method &  16) != 0) result = result && sar[period][CURR] >= Close[CURR];
      if ((signal_method &  32) != 0) result = result && sar[period][PREV] < Close[PREV];
      if ((signal_method &  64) != 0) result = result && sar[period][PREV] < Open[PREV];
      if (result) {
        // FIXME: Convert into more flexible way.
        signals[DAILY][SAR1][period][OP_SELL]++; signals[WEEKLY][SAR1][period][OP_SELL]++;
        signals[MONTHLY][SAR1][period][OP_SELL]++; signals[YEARLY][SAR1][period][OP_SELL]++;
      }
      break;
  }

  return result;
}

/**
 * Check if StdDev indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_StdDev(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(STDDEV, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(STDDEV, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(STDDEV, tf, 0.0);
  switch (cmd) {
    /*
      //27. Standard Deviation
      //Doesn't give independent signals. Is used to define volatility (trend strength).
      //Principle: the trend must be strengthened. Together with this Standard Deviation goes up.
      //Growth on 3 consecutive bars is analyzed
      //Flag is 1 when Standard Deviation rises, 0 - when no growth, -1 - never.
      if (iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,2)<=iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,1)&&iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,1)<=iStdDev(NULL,pistd,pistdu,0,MODE_SMA,PRICE_CLOSE,0))
      {f27=1;}
    */
    case OP_BUY:
      /*
        bool result = StdDev[period][CURR][LOWER] != 0.0 || StdDev[period][PREV][LOWER] != 0.0 || StdDev[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !StdDev_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && StdDev_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && StdDev_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && StdDev[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !StdDev_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = StdDev[period][CURR][UPPER] != 0.0 || StdDev[period][PREV][UPPER] != 0.0 || StdDev[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !StdDev_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && StdDev_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && StdDev_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && StdDev[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !StdDev_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if Stochastic indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_Stochastic(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(STOCHASTIC, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(STOCHASTIC, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(STOCHASTIC, tf, 0.0);
  switch (cmd) {
      /* TODO:
            //   if(iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_MAIN,0)>iStochastic(NULL,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0)) return(0);
            // if(stoch4h<stoch4h2){ //Sell signal
            // if(stoch4h>stoch4h2){//Buy signal

            //28. Stochastic Oscillator (1)
            //Buy: main lline rises above 20 after it fell below this point
            //Sell: main line falls lower than 80 after it rose above this point
            if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,1)<20
            &&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,0)>=20)
            {f28=1;}
            if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,1)>80
            &&iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,0)<=80)
            {f28=-1;}

            //29. Stochastic Oscillator (2)
            //Buy: main line goes above the signal line
            //Sell: signal line goes above the main line
            if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,1)<iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,1)
            && iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,0)>=iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,0))
            {f29=1;}
            if(iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,1)>iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,1)
            && iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_MAIN,0)<=iStochastic(NULL,pisto,pistok,pistod,istslow,MODE_EMA,0,MODE_SIGNAL,0))
            {f29=-1;}
      */
    case OP_BUY:
      /*
        bool result = Stochastic[period][CURR][LOWER] != 0.0 || Stochastic[period][PREV][LOWER] != 0.0 || Stochastic[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !Stochastic_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && Stochastic_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && Stochastic_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && Stochastic[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !Stochastic_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = Stochastic[period][CURR][UPPER] != 0.0 || Stochastic[period][PREV][UPPER] != 0.0 || Stochastic[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !Stochastic_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && Stochastic_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && Stochastic_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && Stochastic[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !Stochastic_On_Buy(M30);
        */
    break;
  }
  return result;
}

/**
 * Check if WPR indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_WPR(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(WPR, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(WPR, tf, 0);
  if (signal_level == EMPTY)  signal_level  = GetStrategySignalLevel(WPR, tf, 0);

  switch (cmd) {
    case OP_BUY:
      result = wpr[period][CURR] > 50 + signal_level;
      if ((signal_method &   1) != 0) result = result && wpr[period][CURR] < wpr[period][PREV];
      if ((signal_method &   2) != 0) result = result && wpr[period][PREV] < wpr[period][FAR];
      if ((signal_method &   4) != 0) result = result && wpr[period][PREV] > 50 + signal_level;
      if ((signal_method &   8) != 0) result = result && wpr[period][FAR]  > 50 + signal_level;
      if ((signal_method &  16) != 0) result = result && wpr[period][PREV] - wpr[period][CURR] > wpr[period][FAR] - wpr[period][PREV];
      if ((signal_method &  32) != 0) result = result && wpr[period][PREV] > 50 + signal_level + signal_level / 2;
      /* TODO:

            //30. Williams Percent Range
            //Buy: crossing -80 upwards
            //Sell: crossing -20 downwards
            if (iWPR(NULL,piwpr,piwprbar,1)<-80&&iWPR(NULL,piwpr,piwprbar,0)>=-80)
            {f30=1;}
            if (iWPR(NULL,piwpr,piwprbar,1)>-20&&iWPR(NULL,piwpr,piwprbar,0)<=-20)
            {f30=-1;}
      */
      break;
    case OP_SELL:
      result = wpr[period][CURR] < 50 - signal_level;
      if ((signal_method &   1) != 0) result = result && wpr[period][CURR] > wpr[period][PREV];
      if ((signal_method &   2) != 0) result = result && wpr[period][PREV] > wpr[period][FAR];
      if ((signal_method &   4) != 0) result = result && wpr[period][PREV] < 50 - signal_level;
      if ((signal_method &   8) != 0) result = result && wpr[period][FAR]  < 50 - signal_level;
      if ((signal_method &  16) != 0) result = result && wpr[period][CURR] - wpr[period][PREV] > wpr[period][PREV] - wpr[period][FAR];
      if ((signal_method &  32) != 0) result = result && wpr[period][PREV] > 50 - signal_level - signal_level / 2;
      break;
  }
  return result;
}

/**
 * Check if ZigZag indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   signal_method (int) - signal method to use by using bitwise AND operation
 *   signal_level (double) - signal level to consider the signal
 */
bool Trade_ZigZag(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M1, int signal_method = EMPTY, double signal_level = EMPTY) {
  bool result = FALSE; int period = Convert::TfToIndex(tf);
  UpdateIndicator(ZIGZAG, tf);
  if (signal_method == EMPTY) signal_method = GetStrategySignalMethod(ZIGZAG, tf, 0);
  if (signal_level  == EMPTY) signal_level  = GetStrategySignalLevel(ZIGZAG, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = ZigZag[period][CURR][LOWER] != 0.0 || ZigZag[period][PREV][LOWER] != 0.0 || ZigZag[period][FAR][LOWER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((signal_method &   2) != 0) result = result && !ZigZag_On_Sell(tf);
        if ((signal_method &   4) != 0) result = result && ZigZag_On_Buy(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && ZigZag_On_Buy(M30);
        if ((signal_method &  16) != 0) result = result && ZigZag[period][FAR][LOWER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !ZigZag_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = ZigZag[period][CURR][UPPER] != 0.0 || ZigZag[period][PREV][UPPER] != 0.0 || ZigZag[period][FAR][UPPER] != 0.0;
        if ((signal_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((signal_method &   2) != 0) result = result && !ZigZag_On_Buy(tf);
        if ((signal_method &   4) != 0) result = result && ZigZag_On_Sell(fmin(period + 1, M30));
        if ((signal_method &   8) != 0) result = result && ZigZag_On_Sell(M30);
        if ((signal_method &  16) != 0) result = result && ZigZag[period][FAR][UPPER] != 0.0;
        if ((signal_method &  32) != 0) result = result && !ZigZag_On_Buy(M30);
        */
    break;
  }
  return result;
}

/* END: INDICATOR FUNCTIONS */

/**
 * Check for market condition.
 *
 * @param
 *   cmd (int) - trade command
 *   tf (int) - tf to use
 *   condition (int) - condition to check by using bitwise AND operation
 *   default_value (bool) - default value to set, if FALSE - return the opposite
 */
bool CheckMarketCondition1(int cmd, ENUM_TIMEFRAMES tf = PERIOD_M30, int condition = 0, bool default_value = TRUE) {
  bool result = TRUE;
  RefreshRates(); // ?
  int period = Convert::TfToIndex(tf);
  if ((condition &   1) != 0) result = result && ((cmd == OP_BUY && Open[CURR] > Close[PREV]) || (cmd == OP_SELL && Open[CURR] < Close[PREV]));
  if ((condition &   2) != 0) result = result && UpdateIndicator(SAR, tf)       && ((cmd == OP_BUY && sar[period][CURR] < Open[0]) || (cmd == OP_SELL && sar[period][CURR] > Open[0]));
  if ((condition &   4) != 0) result = result && UpdateIndicator(RSI, tf)       && ((cmd == OP_BUY && rsi[period][CURR] < 50) || (cmd == OP_SELL && rsi[period][CURR] > 50));
  if ((condition &   8) != 0) result = result && UpdateIndicator(MA, tf)        && ((cmd == OP_BUY && Ask > ma_slow[period][CURR]) || (cmd == OP_SELL && Ask < ma_slow[period][CURR]));
//if ((condition &   8) != 0) result = result && UpdateIndicator(MA, tf)        && ((cmd == OP_BUY && ma_slow[period][CURR] > ma_slow[period][PREV]) || (cmd == OP_SELL && ma_slow[period][CURR] < ma_slow[period][PREV]));
  if ((condition &  16) != 0) result = result && ((cmd == OP_BUY && Ask < Open[CURR]) || (cmd == OP_SELL && Ask > Open[CURR]));
  if ((condition &  32) != 0) result = result && UpdateIndicator(BANDS, tf)     && ((cmd == OP_BUY && Open[CURR] < bands[period][CURR][BANDS_BASE]) || (cmd == OP_SELL && Open[CURR] > bands[period][CURR][BANDS_BASE]));
  if ((condition &  64) != 0) result = result && UpdateIndicator(ENVELOPES, tf) && ((cmd == OP_BUY && Open[CURR] < envelopes[period][CURR][MODE_MAIN]) || (cmd == OP_SELL && Open[CURR] > envelopes[period][CURR][MODE_MAIN]));
  if ((condition & 128) != 0) result = result && UpdateIndicator(DEMARKER, tf)  && ((cmd == OP_BUY && demarker[period][CURR] < 0.5) || (cmd == OP_SELL && demarker[period][CURR] > 0.5));
  if ((condition & 256) != 0) result = result && UpdateIndicator(WPR, tf)       && ((cmd == OP_BUY && wpr[period][CURR] > 50) || (cmd == OP_SELL && wpr[period][CURR] < 50));
  if ((condition & 512) != 0) result = result && cmd == CheckTrend();
  if (!default_value) result = !result;
  return result;
}

/**
 * Check for market event.
 *
 * @param
 *   cmd (int) - trade command
 *   tf (int) - timeframe to use
 *   condition (int) - condition to check by using bitwise AND operation
 *   default_value (bool) - default value to set, if FALSE - return the opposite
 */
bool CheckMarketEvent(int cmd = EMPTY, ENUM_TIMEFRAMES tf = PERIOD_M30, int condition = EMPTY) {
  bool result = FALSE;
  int period = Convert::TfToIndex(tf);
  if (cmd == EMPTY || condition == EMPTY) return (FALSE);
  switch (condition) {
    case C_AC_BUY_SELL:
      result = Trade_AC(cmd, tf);
      break;
    case C_AD_BUY_SELL:
      result = Trade_AD(cmd, tf);
      break;
    case C_ADX_BUY_SELL:
      result = Trade_ADX(cmd, tf);
      break;
    case C_ALLIGATOR_BUY_SELL:
      result = Trade_Alligator(cmd, tf);
      break;
    case C_ATR_BUY_SELL:
      result = Trade_ATR(cmd, tf);
      break;
    case C_AWESOME_BUY_SELL:
      result = Trade_Awesome(cmd, tf);
      break;
    case C_BANDS_BUY_SELL:
      result = Trade_Bands(cmd, tf);
      break;
    case C_BPOWER_BUY_SELL:
      result = Trade_BPower(cmd, tf);
      break;
    case C_BREAKAGE_BUY_SELL:
      result = Trade_Breakage(cmd, tf);
      break;
    case C_CCI_BUY_SELL:
      result = Trade_CCI(cmd, tf);
      break;
    case C_DEMARKER_BUY_SELL:
      result = Trade_DeMarker(cmd, tf);
      break;
    case C_ENVELOPES_BUY_SELL:
      result = Trade_Envelopes(cmd, tf);
      break;
    case C_FORCE_BUY_SELL:
      result = Trade_Force(cmd, tf);
      break;
    case C_FRACTALS_BUY_SELL:
      result = Trade_Fractals(cmd, tf);
      break;
    case C_GATOR_BUY_SELL:
      result = Trade_Gator(cmd, tf);
      break;
    case C_ICHIMOKU_BUY_SELL:
      result = Trade_Ichimoku(cmd, tf);
      break;
    case C_MA_BUY_SELL:
      result = Trade_MA(cmd, tf);
      break;
    case C_MACD_BUY_SELL:
      result = Trade_MACD(cmd, tf);
      break;
    case C_MFI_BUY_SELL:
      result = Trade_MFI(cmd, tf);
      break;
    case C_OBV_BUY_SELL:
      result = Trade_OBV(cmd, tf);
      break;
    case C_OSMA_BUY_SELL:
      result = Trade_OSMA(cmd, tf);
      break;
    case C_RSI_BUY_SELL:
      result = Trade_RSI(cmd, tf);
      break;
    case C_RVI_BUY_SELL:
      result = Trade_RVI(cmd, tf);
      break;
    case C_SAR_BUY_SELL:
      result = Trade_SAR(cmd, tf);
      break;
    case C_STDDEV_BUY_SELL:
      result = Trade_StdDev(cmd, tf);
      break;
    case C_STOCHASTIC_BUY_SELL:
      result = Trade_Stochastic(cmd, tf);
      break;
    case C_WPR_BUY_SELL:
      result = Trade_WPR(cmd, tf);
      break;
    case C_ZIGZAG_BUY_SELL:
      result = Trade_ZigZag(cmd, tf);
      break;
    case C_MA_FAST_SLOW_OPP: // MA Fast&Slow are in opposite directions.
      UpdateIndicator(MA, tf);
      return
        (cmd == OP_BUY && ma_fast[period][CURR] < ma_fast[period][PREV] && ma_slow[period][CURR] > ma_slow[period][PREV]) ||
        (cmd == OP_SELL && ma_fast[period][CURR] > ma_fast[period][PREV] && ma_slow[period][CURR] < ma_slow[period][PREV]);
    case C_MA_FAST_MED_OPP: // MA Fast&Med are in opposite directions.
      UpdateIndicator(MA, tf);
      return
        (cmd == OP_BUY && ma_fast[period][CURR] < ma_fast[period][PREV] && ma_medium[period][CURR] > ma_medium[period][PREV]) ||
        (cmd == OP_SELL && ma_fast[period][CURR] > ma_fast[period][PREV] && ma_medium[period][CURR] < ma_medium[period][PREV]);
    case C_MA_MED_SLOW_OPP: // MA Med&Slow are in opposite directions.
      UpdateIndicator(MA, tf);
      return
        (cmd == OP_BUY && ma_medium[period][CURR] < ma_medium[period][PREV] && ma_slow[period][CURR] > ma_slow[period][PREV]) ||
        (cmd == OP_SELL && ma_medium[period][CURR] > ma_medium[period][PREV] && ma_slow[period][CURR] < ma_slow[period][PREV]);
#ifdef __advanced__
    case C_CUSTOM1_BUY_SELL:
    case C_CUSTOM2_BUY_SELL:
    case C_CUSTOM3_BUY_SELL:
      if (condition == C_CUSTOM1_BUY_SELL) condition = CloseConditionCustom1Method;
      if (condition == C_CUSTOM2_BUY_SELL) condition = CloseConditionCustom2Method;
      if (condition == C_CUSTOM3_BUY_SELL) condition = CloseConditionCustom3Method;
      result = FALSE;
      if ((condition &   1) != 0) result |= CheckMarketEvent(cmd, tf, C_MA_BUY_SELL);
      if ((condition &   2) != 0) result |= CheckMarketEvent(cmd, tf, C_MACD_BUY_SELL);
      if ((condition &   4) != 0) result |= CheckMarketEvent(cmd, tf, C_ALLIGATOR_BUY_SELL);
      if ((condition &   8) != 0) result |= CheckMarketEvent(cmd, tf, C_RSI_BUY_SELL);
      if ((condition &  16) != 0) result |= CheckMarketEvent(cmd, tf, C_SAR_BUY_SELL);
      if ((condition &  32) != 0) result |= CheckMarketEvent(cmd, tf, C_BANDS_BUY_SELL);
      if ((condition &  64) != 0) result |= CheckMarketEvent(cmd, tf, C_ENVELOPES_BUY_SELL);
      if ((condition & 128) != 0) result |= CheckMarketEvent(cmd, tf, C_DEMARKER_BUY_SELL);
      if ((condition & 256) != 0) result |= CheckMarketEvent(cmd, tf, C_WPR_BUY_SELL);
      if ((condition & 512) != 0) result |= CheckMarketEvent(cmd, tf, C_FRACTALS_BUY_SELL);
      // Message("Condition: " + condition + ", result: " + result);
      break;
    case C_CUSTOM4_MARKET_COND:
    case C_CUSTOM5_MARKET_COND:
    case C_CUSTOM6_MARKET_COND:
      if (condition == C_CUSTOM4_MARKET_COND) condition = CloseConditionCustom4Method;
      if (condition == C_CUSTOM5_MARKET_COND) condition = CloseConditionCustom5Method;
      if (condition == C_CUSTOM6_MARKET_COND) condition = CloseConditionCustom6Method;
      if (cmd == OP_BUY)  result = CheckMarketCondition1(OP_SELL, tf, condition);
      if (cmd == OP_SELL) result = CheckMarketCondition1(OP_BUY, tf, condition);
    break;
#endif
    case C_EVENT_NONE:
    default:
      result = FALSE;
  }
  return result;
}

/**
 * Check for the trend.
 *
 * @param
 *   method (int) - condition to check by using bitwise AND operation
 * @return
 *   return TRUE if trend is valid for given trade command
 */
bool CheckTrend(int method = EMPTY) {
  int bull = 0, bear = 0;
  if (method == EMPTY) method = TrendMethod;

  if ((method &   1) != 0)  {
    if (iOpen(NULL, PERIOD_MN1, CURR) > iClose(NULL, PERIOD_MN1, PREV)) bull++;
    if (iOpen(NULL, PERIOD_MN1, CURR) < iClose(NULL, PERIOD_MN1, PREV)) bear++;
  }
  if ((method &   2) != 0)  {
    if (iOpen(NULL, PERIOD_W1, CURR) > iClose(NULL, PERIOD_W1, PREV)) bull++;
    if (iOpen(NULL, PERIOD_W1, CURR) < iClose(NULL, PERIOD_W1, PREV)) bear++;
  }
  if ((method &   4) != 0)  {
    if (iOpen(NULL, PERIOD_D1, CURR) > iClose(NULL, PERIOD_D1, PREV)) bull++;
    if (iOpen(NULL, PERIOD_D1, CURR) < iClose(NULL, PERIOD_D1, PREV)) bear++;
  }
  if ((method &   8) != 0)  {
    if (iOpen(NULL, PERIOD_H4, CURR) > iClose(NULL, PERIOD_H4, PREV)) bull++;
    if (iOpen(NULL, PERIOD_H4, CURR) < iClose(NULL, PERIOD_H4, PREV)) bear++;
  }
  if ((method &   16) != 0)  {
    if (iOpen(NULL, PERIOD_H1, CURR) > iClose(NULL, PERIOD_H1, PREV)) bull++;
    if (iOpen(NULL, PERIOD_H1, CURR) < iClose(NULL, PERIOD_H1, PREV)) bear++;
  }
  if ((method &   32) != 0)  {
    if (iOpen(NULL, PERIOD_M30, CURR) > iClose(NULL, PERIOD_M30, PREV)) bull++;
    if (iOpen(NULL, PERIOD_M30, CURR) < iClose(NULL, PERIOD_M30, PREV)) bear++;
  }
  if ((method &   64) != 0)  {
    if (iOpen(NULL, PERIOD_M15, CURR) > iClose(NULL, PERIOD_M15, PREV)) bull++;
    if (iOpen(NULL, PERIOD_M15, CURR) < iClose(NULL, PERIOD_M15, PREV)) bear++;
  }
  if ((method &  128) != 0)  {
    if (iOpen(NULL, PERIOD_M5, CURR) > iClose(NULL, PERIOD_M5, PREV)) bull++;
    if (iOpen(NULL, PERIOD_M5, CURR) < iClose(NULL, PERIOD_M5, PREV)) bear++;
  }
  //if (iOpen(NULL, PERIOD_H12, CURR) > iClose(NULL, PERIOD_H12, PREV)) bull++;
  //if (iOpen(NULL, PERIOD_H12, CURR) < iClose(NULL, PERIOD_H12, PREV)) bear++;
  //if (iOpen(NULL, PERIOD_H8, CURR) > iClose(NULL, PERIOD_H8, PREV)) bull++;
  //if (iOpen(NULL, PERIOD_H8, CURR) < iClose(NULL, PERIOD_H8, PREV)) bear++;
  //if (iOpen(NULL, PERIOD_H6, CURR) > iClose(NULL, PERIOD_H6, PREV)) bull++;
  //if (iOpen(NULL, PERIOD_H6, CURR) < iClose(NULL, PERIOD_H6, PREV)) bear++;
  //if (iOpen(NULL, PERIOD_H2, CURR) > iClose(NULL, PERIOD_H2, PREV)) bull++;
  //if (iOpen(NULL, PERIOD_H2, CURR) < iClose(NULL, PERIOD_H2, PREV)) bear++;

  if (bull > bear) return OP_BUY;
  else if (bull < bear) return OP_SELL;
  else return EMPTY;
}

/**
 * Check if order match has minimum gap in pips configured by MinPipGap parameter.
 *
 * @param
 *   int strategy_type - type of order strategy to check for (see: ENUM STRATEGY TYPE)
 */
bool CheckMinPipGap(int strategy_type) {
  int diff;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
       if (OrderMagicNumber() == MagicNumber + strategy_type && OrderSymbol() == Symbol()) {
         diff = fabs((OrderOpenPrice() - Market::GetOpenPrice()) / pip_size); // @fixme: warning 43: possible loss of data due to type conversion
         // if (VerboseTrace) Print("Ticket: ", OrderTicket(), ", Order: ", OrderType(), ", Gap: ", diff);
         if (diff < MinPipGap) {
           return (FALSE);
         }
       }
    } else if (VerboseDebug) {
      Msg::ShowText(
          StringFormat("Cannot select order. Strategy type: %s, pos: %d, msg: %s.",
            strategy_type, order, GetErrorText(err_code)),
          "Error", __FUNCTION__, __LINE__, VerboseErrors
      );
    }
  }
  return (TRUE);
}

/**
 * Validate value for trailing stop.
 */
bool ValidTrailingValue(double value, int cmd, int direction = -1, bool existing = FALSE) {
  // Calculate minimum market gap.
  double price = Market::GetOpenPrice();
  double gap = Market::GetMarketDistanceInPips();
  bool valid = (
          (cmd == OP_BUY  && direction < 0 && Convert::GetValueDiffInPips(price, value) > gap)
       || (cmd == OP_BUY  && direction > 0 && Convert::GetValueDiffInPips(value, price) > gap)
       || (cmd == OP_SELL && direction < 0 && Convert::GetValueDiffInPips(value, price) > gap)
       || (cmd == OP_SELL && direction > 0 && Convert::GetValueDiffInPips(price, value) > gap)
       );
  valid &= (value >= 0); // Also must be zero or above.
  if (!valid) {
    Msg::ShowText(StringFormat("Trailing value not valid: %g.", value), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
  }
  return valid;
}

/**
 * Check orders for certain checks.
 */
void CheckOrders() {
  double elapsed_h;
  for (int i = 0; i < OrdersTotal(); i++) {
    if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { continue; }
    if (CheckOurMagicNumber() && OrderOpenTime() > 0) {
      if (CloseOrderAfterXHours > 0) {
        elapsed_h = (TimeCurrent() - OrderOpenTime()) / 60 / 60;
        if (elapsed_h >= CloseOrderAfterXHours) {
          TaskAddCloseOrder(OrderTicket(), R_ORDER_EXPIRED);
        }
      }
    }
  } // end: for
}

/**
 * Update trailing stops for opened orders.
 */
bool UpdateTrailingStops() {
  // Check result of executed orders.
  bool result = True;
  // New StopLoss/TakeProfit.
  double new_sl, new_tp;
  int sid;

   // Check if bar time has been changed since last time.
   /*
   int bar_time = iTime(NULL, PERIOD_M1, 0);
   if (bar_time == last_trail_update) {
     return;
   } else {
     last_trail_update = bar_time;
   }*/

   Market::RefreshRates();
   for (int i = 0; i < OrdersTotal(); i++) {
     if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) { continue; }
      if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
        sid = OrderMagicNumber() - MagicNumber;
        // order_stop_loss = NormalizeDouble(Misc::If(Convert::OrderTypeToValue(OrderType()) > 0 || OrderStopLoss() != 0.0, OrderStopLoss(), 999999), pip_digits);

        // FIXME
        // Make sure we get the minimum distance to StopLevel and freezing distance.
        // See: https://book.mql4.com/appendix/limits
        if (MinimalizeLosses && Order::GetOrderProfit() > GetMinStopLevel()) {
          if ((OrderType() == OP_BUY && OrderStopLoss() < Bid) ||
             (OrderType() == OP_SELL && OrderStopLoss() > Ask)) {
            result = OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - OrderCommission() * Point, OrderTakeProfit(), 0, GetOrderColor());
            if (!result && err_code > 1) {
             if (VerboseErrors) Print(__FUNCTION__, ": Error: OrderModify(): [MinimalizeLosses] ", ErrorDescription(err_code));
               if (VerboseDebug)
                 Print(__FUNCTION__ + ": Error: OrderModify(", OrderTicket(), ", ", OrderOpenPrice(), ", ", OrderOpenPrice() - OrderCommission() * Point, ", ", OrderTakeProfit(), ", ", 0, ", ", GetOrderColor(), "); ", "Ask/Bid: ", Ask, "/", Bid);
            } else {
              if (VerboseTrace) Print(__FUNCTION__ + ": MinimalizeLosses: ", Order::GetOrderToText());
            }
          }
        }

        new_sl = GetTrailingValue(OrderType(), -1, sid, OrderStopLoss(), TRUE);
        new_tp = GetTrailingValue(OrderType(), +1, sid, OrderTakeProfit(), TRUE);
        if (!Market::TradeOpAllowed(OrderType(), new_sl, new_tp)) {
          if (VerboseDebug) {
            PrintFormat("%s(): fabs(%f - %f) = %f > %f || fabs(%f - %f) = %f > %f",
                __FUNCTION__,
                OrderStopLoss(), new_sl, fabs(OrderStopLoss() - new_sl), MinPipChangeToTrade * pip_size,
                OrderTakeProfit(), new_tp, fabs(OrderTakeProfit() - new_tp), MinPipChangeToTrade * pip_size);
          }
          return (False);
        }
        else if (new_sl == OrderStopLoss() && new_tp == OrderTakeProfit()) {
          return (False);
        }
        // @todo
        // Perform update on pip change.
        // Perform update on change only.
        // MQL5: ORDER_TIME_GTC
        // datetime expiration=TimeTradeServer()+PeriodSeconds(PERIOD_D1);

        if (fabs(OrderStopLoss() - new_sl) > MinPipChangeToTrade * pip_size || fabs(OrderTakeProfit() - new_tp) > MinPipChangeToTrade * pip_size) {
          result = OrderModify(OrderTicket(), OrderOpenPrice(), new_sl, new_tp, 0, GetOrderColor());
          if (!result) {
            err_code = GetLastError();
            if (err_code > 1) {
              Msg::ShowText(ErrorDescription(err_code), "Error", __FUNCTION__, __LINE__, VerboseErrors);
              Msg::ShowText(
                StringFormat("OrderModify(%d, %g, %g, %g, %d, %d); Ask:%g/Bid:%g; Gap:%g pips",
                OrderTicket(), OrderOpenPrice(), new_sl, new_tp, 0, GetOrderColor(), Ask, Bid, Market::GetMarketDistanceInPips()),
                "Debug", __FUNCTION__, __LINE__, VerboseDebug
              );
              Msg::ShowText(
                StringFormat("%s(): fabs(%g - %g) = %g > %g || fabs(%g - %g) = %g > %g",
                __FUNCTION__,
                OrderStopLoss(), new_sl, fabs(OrderStopLoss() - new_sl), MinPipChangeToTrade * pip_size,
                OrderTakeProfit(), new_tp, fabs(OrderTakeProfit() - new_tp), MinPipChangeToTrade * pip_size),
                "Debug", __FUNCTION__, __LINE__, VerboseDebug);
            }
          } else {
            // if (VerboseTrace) Print("UpdateTrailingStops(): OrderModify(): ", Order::GetOrderToText());
          }
        }
      }
  } // end: for
  return result;
}

/**
 * Calculate the new trailing stop. If calculation fails, use the previous one.
 *
 * @params:
 *   cmd (int)
 *    Command for trade operation.
 *   direction (int)
 *    Set -1 to calculate trailing stop or +1 for profit take.
 *   order_type (int)
 *    Value of strategy type. See: ENUM_STRATEGY_TYPE
 *   previous (double)
 *    Previous trailing value.
 *   existing (bool)
 *    Set to TRUE if the calculation is for particular existing order, so additional local variables are available.
 */
double GetTrailingValue(int cmd, int direction = -1, int order_type = 0, double previous = 0, bool existing = FALSE) {
  double diff;
  double new_value = 0;
  int extra_trail = 0;
  if (existing && TrailingStopAddPerMinute > 0 && OrderOpenTime() > 0) {
    int min_elapsed = (TimeCurrent() - OrderOpenTime()) / 60;
    extra_trail =+ min_elapsed * TrailingStopAddPerMinute;
    if (VerboseDebug) {
      PrintFormat("%s(): extra_trail += %d * %g => %d",
        __FUNCTION__, min_elapsed, TrailingStopAddPerMinute, extra_trail);
    }
  }
  int factor = (Convert::OrderTypeToValue(cmd) == direction ? +1 : -1);
  double trail = (TrailingStop + extra_trail) * pip_size;
  double default_trail = (cmd == OP_BUY ? Bid : Ask) + trail * factor;
  int method = GetTrailingMethod(order_type, direction);
  // if (direction > 0) method = AC_TrailingProfitMethod; else if (direction < 0) method = AC_TrailingStopMethod; // Testing.
  ENUM_TIMEFRAMES tf = (ENUM_TIMEFRAMES) GetStrategyTimeframe(order_type);
  int period = Convert::TfToIndex(tf);
  string symbol = existing ? OrderSymbol() : _Symbol;

  if (VerboseDebug) {
    PrintFormat("%s(): trail = (%d + %d) * %g = %g",
      __FUNCTION__, TrailingStop, extra_trail, pip_size, trail);
  }

/**
  MA1+MA5+MA15+MA30 backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:

  Stop loss (d: GBP10k, lot size: 0.1, spread: 2, no boosting, no actions):
    5599.51 3952  1.20  1.42  2256.22 13.95% MA_TrailingStopMethod=1
    11218.40  9992  1.52  1.12  1929.00 10.02% MA_TrailingStopMethod=2
    10159.11  8678  1.45  1.17  2093.62 10.66% MA_TrailingStopMethod=3
    9749.82 6400  1.42  1.52  1998.58 12.64% MA_TrailingStopMethod=4
    9439.25 5719  1.38  1.65  2181.95 13.17% MA_TrailingStopMethod=5
    9114.61 4646  1.32  1.96  2668.78 13.98% MA_TrailingStopMethod=6
    10633.63  4069  1.35  2.61  2375.31 15.31% MA_TrailingStopMethod=7
    9842.04 4622  1.35  2.13  2334.60 14.56% MA_TrailingStopMethod=8
    202.80  8027  1.01  0.03  1457.60 12.60% MA_TrailingStopMethod=9
    1225.75 6081  1.06  0.20  1618.59 12.70% MA_TrailingStopMethod=10
    16913.77  3453  1.52  4.90  3688.36 20.00% MA_TrailingStopMethod=11
    10044.82  3781  1.34  2.66  2853.85 13.77% MA_TrailingStopMethod=12
    11821.83  3727  1.39  3.17  2961.41 13.05% MA_TrailingStopMethod=13
    791.21  6933  1.04  0.11  1575.28 12.84% MA_TrailingStopMethod=14
    1974.87 6089  1.09  0.32  1779.42 13.08% MA_TrailingStopMethod=15
    16913.77  3453  1.52  4.90  3688.36 20.00% MA_TrailingStopMethod=16
    12038.54  3726  1.40  3.23  3046.36 13.29% MA_TrailingStopMethod=17
    12932.29  3691  1.43  3.50  3210.92 13.56% MA_TrailingStopMethod=18
    3963.23 6366  1.18  0.62  1926.07 14.04% MA_TrailingStopMethod=19
    4846.24 6165  1.21  0.79  1855.02 11.98% MA_TrailingStopMethod=20
    13348.87  3651  1.44  3.66  3015.02 13.03% MA_TrailingStopMethod=21
    16913.77  3453  1.52  4.90  3688.36 20.00% MA_TrailingStopMethod=22
    2128.81 5515  1.10  0.39  1796.71 13.10% MA_TrailingStopMethod=23
    4391.11 4679  1.17  0.94  1247.45 10.56% MA_TrailingStopMethod=24
    8038.24 5097  1.29  1.58  2556.58 13.94% MA_TrailingStopMethod=25
    8016.87 5029  1.29  1.59  2510.72 13.66% MA_TrailingStopMethod=26
    6787.85 4701  1.24  1.44  2238.46 12.68% MA_TrailingStopMethod=27

  Profit take (d: GBP10k, lot size: 0.1, spread: 25, no boosting, no actions, trailing: T_MA_FMS_PEAK):
    13761.58  2845  1.36  4.84  3960.10 30.33% MA_TrailingProfitMethod=1
    10878.01  3491  1.31  3.12  4519.36 23.97% MA_TrailingProfitMethod=2
    11012.71  3503  1.31  3.14  4738.17 23.04% MA_TrailingProfitMethod=3
    12206.18  2955  1.33  4.13  3956.58 25.66% MA_TrailingProfitMethod=4
    14089.18  2889  1.37  4.88  3901.52 29.04% MA_TrailingProfitMethod=5
    13865.44  2843  1.37  4.88  3892.54 29.82% MA_TrailingProfitMethod=6
    13861.94  2841  1.36  4.88  3924.26 30.06% MA_TrailingProfitMethod=7
    13168.88  2869  1.35  4.59  4004.98 30.68% MA_TrailingProfitMethod=8
    10713.75  2902  1.28  3.69  3846.19 28.34% MA_TrailingProfitMethod=9
    13209.68  2870  1.35  4.60  3733.74 28.61% MA_TrailingProfitMethod=10
    13742.21  2839  1.36  4.84  3825.94 29.31% MA_TrailingProfitMethod=12
    13743.50  2839  1.36  4.84  3825.94 29.31% MA_TrailingProfitMethod=13
    12640.84  2894  1.33  4.37  3736.01 28.59% MA_TrailingProfitMethod=14
    12837.30  2857  1.34  4.49  3847.29 29.48% MA_TrailingProfitMethod=15
    13740.98  2839  1.36  4.84  3825.94 29.31% MA_TrailingProfitMethod=17
    13880.76  2839  1.36  4.89  3825.94 29.31% MA_TrailingProfitMethod=18
    12901.85  2871  1.34  4.49  3914.54 30.00% MA_TrailingProfitMethod=19
    13140.64  2865  1.35  4.59  3911.51 29.98% MA_TrailingProfitMethod=20
    13880.76  2839  1.36  4.89  3825.94 29.31% MA_TrailingProfitMethod=21
    13880.76  2839  1.36  4.89  3825.94 29.31% MA_TrailingProfitMethod=22
    12365.53  3238  1.35  3.82  4348.87 23.32% MA_TrailingProfitMethod=23
    11876.32  3245  1.34  3.66  4514.79 24.00% MA_TrailingProfitMethod=24
    9146.42 3492  1.26  2.62  4847.98 25.24% MA_TrailingProfitMethod=25
    9230.95 3484  1.27  2.65  4835.75 25.13% MA_TrailingProfitMethod=26
    9371.17 3416  1.27  2.74  5098.83 23.51% MA_TrailingProfitMethod=27
*/
  // TODO: Make starting point dynamic: Open[CURR], Open[PREV], Open[FAR], Close[PREV], Close[FAR], ma_fast[CURR], ma_medium[CURR], ma_slow[CURR]
   double highest_ma, lowest_ma;
   switch (method) {
     case T_NONE: // None
       new_value = previous;
       break;
     case T_FIXED: // Dynamic fixed.
       new_value = default_trail;
       break;
     case T_CLOSE_PREV: // TODO
       diff = fabs(Open[CURR] - iClose(symbol, tf, PREV));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_2_BARS_PEAK: // 3
       diff = fmax(Market::GetPeakPrice(tf, MODE_HIGH, 2) - Open[CURR], Open[CURR] - Market::GetPeakPrice(tf, MODE_LOW, 2));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_5_BARS_PEAK: // 4
       diff = fmax(Market::GetPeakPrice(tf, MODE_HIGH, 5) - Open[CURR], Open[CURR] - Market::GetPeakPrice(tf, MODE_LOW, 5));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_10_BARS_PEAK: // 5
       diff = fmax(Market::GetPeakPrice(tf, MODE_HIGH, 10) - Open[CURR], Open[CURR] - Market::GetPeakPrice(tf, MODE_LOW, 10));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_50_BARS_PEAK: // 6
       diff = fmax(Market::GetPeakPrice(tf, MODE_HIGH, 50) - Open[CURR], Open[CURR] - Market::GetPeakPrice(tf, MODE_LOW, 50));
       new_value = Open[CURR] + diff * factor;
       // @todo: Text non-Open values.
       break;
     case T_150_BARS_PEAK: // 7
       diff = fmax(Market::GetPeakPrice(tf, MODE_HIGH, 150) - Open[CURR], Open[CURR] - Market::GetPeakPrice(tf, MODE_LOW, 150));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_HALF_200_BARS: // 8
       diff = fmax(Market::GetPeakPrice(tf, MODE_HIGH, 200) - Open[CURR], Open[CURR] - Market::GetPeakPrice(tf, MODE_LOW, 200));
       new_value = Open[CURR] + diff/2 * factor;
       break;
     case T_HALF_PEAK_OPEN:
       if (existing) {
         // Get the number of bars for the tf since open. Zero means that the order was opened during the current bar.
         int BarShiftOfTradeOpen = iBarShift(symbol, tf, OrderOpenTime(), FALSE);
         // Get the high price from the bar with the given tf index
         double highest_open = Market::GetPeakPrice(tf, MODE_HIGH, BarShiftOfTradeOpen + 1);
         double lowest_open = Market::GetPeakPrice(tf, MODE_LOW, BarShiftOfTradeOpen + 1);
         diff = fmax(highest_open - Open[CURR], Open[CURR] - lowest_open);
         new_value = Open[CURR] + diff/2 * factor;
       }
       break;
     case T_MA_F_PREV: // 9: MA Small (Previous). The worse so far for MA.
       UpdateIndicator(MA, tf);
       diff = fabs(Ask - ma_fast[period][PREV]);
       new_value = Ask + diff * factor;
       break;
     case T_MA_F_FAR: // 10: MA Small (Far) + trailing stop. Optimize together with: MA_Shift_Far.
       UpdateIndicator(MA, tf);
       diff = fabs(Ask - ma_fast[period][FAR]);
       new_value = Ask + diff * factor;
       break;
     /*
     case T_MA_F_LOW: // 11: Lowest/highest value of MA Fast. Optimized (SL pf: 1.39 for MA).
       UpdateIndicator(MA, tf);
       diff = fmax(Arrays::HighestArrValue2(ma_fast, period) - Open[CURR], Open[CURR] - Arrays::LowestArrValue2(ma_fast, period));
       new_value = Open[CURR] + diff * factor;
       break;
      */
     case T_MA_F_TRAIL: // 12: MA Fast (Current) + trailing stop. Works fine.
       UpdateIndicator(MA, tf);
       diff = fabs(Ask - ma_fast[period][CURR]);
       new_value = Ask + (diff + trail) * factor;
       break;
     case T_MA_F_FAR_TRAIL: // 13: MA Fast (Far) + trailing stop. Works fine (SL pf: 1.26 for MA).
       UpdateIndicator(MA, tf);
       diff = fabs(Open[CURR] - ma_fast[period][FAR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       break;
     case T_MA_M: // 14: MA Medium (Current).
       UpdateIndicator(MA, tf);
       diff = fabs(Ask - ma_medium[period][CURR]);
       new_value = Ask + diff * factor;
       break;
     case T_MA_M_FAR: // 15: MA Medium (Far)
       UpdateIndicator(MA, tf);
       diff = fabs(Ask - ma_medium[period][FAR]);
       new_value = Ask + diff * factor;
       break;
     /*
     case T_MA_M_LOW: // 16: Lowest/highest value of MA Medium. Optimized (SL pf: 1.39 for MA).
       UpdateIndicator(MA, tf);
       diff = fmax(Arrays::HighestArrValue2(ma_medium, period) - Open[CURR], Open[CURR] - Arrays::LowestArrValue2(ma_medium, period));
       new_value = Open[CURR] + diff * factor;
       break;
      */
     case T_MA_M_TRAIL: // 17: MA Small (Current) + trailing stop. Works fine (SL pf: 1.26 for MA).
       UpdateIndicator(MA, tf);
       diff = fabs(Open[CURR] - ma_medium[period][CURR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       break;
     case T_MA_M_FAR_TRAIL: // 18: MA Small (Far) + trailing stop. Optimized (SL pf: 1.29 for MA).
       UpdateIndicator(MA, tf);
       diff = fabs(Open[CURR] - ma_medium[period][FAR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       if (VerboseDebug && new_value < 0) {
         PrintFormat("%s(): diff = fabs(%g - %g); new_value = %g + (%g + %g) * %g => %g",
             __FUNCTION__, Open[CURR], ma_medium[period][FAR], Open[CURR], diff, trail, factor, new_value);
       }
       break;
     case T_MA_S: // 19: MA Slow (Current).
       UpdateIndicator(MA, tf);
       diff = fabs(Ask - ma_slow[period][CURR]);
       // new_value = ma_slow[period][CURR];
       new_value = Ask + diff * factor;
       break;
     case T_MA_S_FAR: // 20: MA Slow (Far).
       UpdateIndicator(MA, tf);
       diff = fabs(Ask - ma_slow[period][FAR]);
       // new_value = ma_slow[period][FAR];
       new_value = Ask + diff * factor;
       break;
     case T_MA_S_TRAIL: // 21: MA Slow (Current) + trailing stop. Optimized (SL pf: 1.29 for MA, PT pf: 1.23 for MA).
       UpdateIndicator(MA, tf);
       diff = fabs(Open[CURR] - ma_slow[period][CURR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       break;
     case T_MA_FMS_PEAK: // 22: Lowest/highest value of all MAs. Works fine (SL pf: 1.39 for MA, PT pf: 1.23 for MA).
       UpdateIndicator(MA, tf);
       highest_ma = fabs(fmax(fmax(Arrays::HighestArrValue2(ma_fast, period), Arrays::HighestArrValue2(ma_medium, period)), Arrays::HighestArrValue2(ma_slow, period)));
       lowest_ma = fabs(fmin(fmin(Arrays::LowestArrValue2(ma_fast, period), Arrays::LowestArrValue2(ma_medium, period)), Arrays::LowestArrValue2(ma_slow, period)));
       diff = fmax(fabs(highest_ma - Open[CURR]), fabs(Open[CURR] - lowest_ma));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_SAR: // 23: Current SAR value. Optimized.
       UpdateIndicator(SAR, tf);
       new_value = sar[period][CURR];
       if (VerboseDebug) PrintFormat("SAR Trail: %g, %g, %g", sar[period][CURR], sar[period][PREV], sar[period][FAR]);
       break;
     case T_SAR_PEAK: // 24: Lowest/highest SAR value.
       UpdateIndicator(SAR, tf);
       new_value = Misc::If(Convert::OrderTypeToValue(cmd) == direction, Arrays::HighestArrValue2(sar, period), Arrays::LowestArrValue2(sar, period));
       break;
     case T_BANDS: // 25: Current Bands value.
       UpdateIndicator(BANDS, tf);
       new_value = Convert::OrderTypeToValue(cmd) == direction ? bands[period][CURR][BANDS_UPPER] : bands[period][CURR][BANDS_LOWER];
       break;
     case T_BANDS_PEAK: // 26: Lowest/highest Bands value.
       UpdateIndicator(BANDS, tf);
       new_value = (Convert::OrderTypeToValue(cmd) == direction
         ? fmax(fmax(bands[period][CURR][BANDS_UPPER], bands[period][PREV][BANDS_UPPER]), bands[period][FAR][BANDS_UPPER])
         : fmin(fmin(bands[period][CURR][BANDS_LOWER], bands[period][PREV][BANDS_LOWER]), bands[period][FAR][BANDS_LOWER])
         );
       break;
     case T_ENVELOPES: // 27: Current Envelopes value. // FIXME
       UpdateIndicator(ENVELOPES, tf);
       new_value = Convert::OrderTypeToValue(cmd) == direction ? envelopes[period][CURR][UPPER] : envelopes[period][CURR][LOWER];
       break;
     default:
       Msg::ShowText(StringFormat("Unknown trailing stop method: %d", method), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
   }

  if (new_value > 0) new_value += Convert::PointsToValue(Market::GetMarketDistanceInPts()) * factor;
  // + Convert::PointsToValue(GetSpreadInPts()) ?

  if (!Market::TradeOpAllowed(cmd, new_value)) {
    #ifndef __limited__
      if (existing && previous == 0 && direction == -1) previous = default_trail;
    #else // If limited, then force the trailing value.
      if (existing && previous == 0) previous = default_trail;
    #endif
    Msg::ShowText(
        StringFormat("#%d (d:%d/f:%d), method: %d, invalid value: %g, previous: %g, Ask/Bid/Gap: %f/%f/%f (%d pts); %s",
          existing ? OrderTicket() : 0, direction, factor,
          method, new_value, previous, Ask, Bid, Convert::PointsToValue(Market::GetMarketDistanceInPts()), Market::GetMarketDistanceInPts(), Order::GetOrderToText()),
        "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    // If value is invalid, fallback to the previous one.
    return previous;
  }

  if (TrailingStopOneWay && direction < 0 && method > 0) {
    // Move trailing stop only one direction.
    if (previous == 0 && method > 0) previous = default_trail;
    if (Convert::OrderTypeToValue(cmd) == direction) new_value = (new_value < previous || previous == 0) ? new_value : previous;
    else new_value = (new_value > previous || previous == 0) ? new_value : previous;
  }
  if (TrailingProfitOneWay && direction > 0 && method > 0) {
    // Move profit take only one direction.
    if (Convert::OrderTypeToValue(cmd) == direction) new_value = (new_value > previous || previous == 0) ? new_value : previous;
    else new_value = (new_value < previous || previous == 0) ? new_value : previous;
  }

  if (VerboseTrace) {
    Msg::ShowText(
      StringFormat("Strategy: %s (%d), Method: %d, Tf: %d, Period: %d, Value: %g, Prev: %g, Factor: %d, Trail: %g (%g), LMA/HMA: %g/%g (%g/%g/%g|%g/%g/%g)",
        sname[order_type], order_type, method, tf, period, new_value, previous, factor, trail, default_trail,
        fabs(fmin(fmin(Arrays::LowestArrValue2(ma_fast, period), Arrays::LowestArrValue2(ma_medium, period)), Arrays::LowestArrValue2(ma_slow, period))),
        fabs(fmax(fmax(Arrays::HighestArrValue2(ma_fast, period), Arrays::HighestArrValue2(ma_medium, period)), Arrays::HighestArrValue2(ma_slow, period))),
        Arrays::LowestArrValue2(ma_fast, period), Arrays::LowestArrValue2(ma_medium, period), Arrays::LowestArrValue2(ma_slow, period),
        Arrays::HighestArrValue2(ma_fast, period), Arrays::HighestArrValue2(ma_medium, period), Arrays::HighestArrValue2(ma_slow, period))
      , "Trace", __FUNCTION__, __LINE__, VerboseTrace);
  }
  // if (VerboseDebug && Check::IsVisualMode()) Draw::ShowLine("trail_stop_" + OrderTicket(), new_value, GetOrderColor());

  return NormalizeDouble(new_value, Market::GetDigits());
}

/**
 * Get trailing method based on the strategy type.
 */
int GetTrailingMethod(int order_type, int stop_or_profit) {
  int stop_method = DefaultTrailingStopMethod, profit_method = DefaultTrailingProfitMethod;
  switch (order_type) {
    case MA1:
    case MA5:
    case MA15:
    case MA30:
      if (MA_TrailingStopMethod > 0)   stop_method   = MA_TrailingStopMethod;
      if (MA_TrailingProfitMethod > 0) profit_method = MA_TrailingProfitMethod;
      break;
    case MACD1:
    case MACD5:
    case MACD15:
    case MACD30:
      if (MACD_TrailingStopMethod > 0)   stop_method   = MACD_TrailingStopMethod;
      if (MACD_TrailingProfitMethod > 0) profit_method = MACD_TrailingProfitMethod;
      break;
    case ALLIGATOR1:
    case ALLIGATOR5:
    case ALLIGATOR15:
    case ALLIGATOR30:
      if (Alligator_TrailingStopMethod > 0)   stop_method   = Alligator_TrailingStopMethod;
      if (Alligator_TrailingProfitMethod > 0) profit_method = Alligator_TrailingProfitMethod;
      break;
    case RSI1:
    case RSI5:
    case RSI15:
    case RSI30:
      if (RSI_TrailingStopMethod > 0)   stop_method   = RSI_TrailingStopMethod;
      if (RSI_TrailingProfitMethod > 0) profit_method = RSI_TrailingProfitMethod;
      break;
    case SAR1:
    case SAR5:
    case SAR15:
    case SAR30:
      if (SAR_TrailingStopMethod > 0)   stop_method   = SAR_TrailingStopMethod;
      if (SAR_TrailingProfitMethod > 0) profit_method = SAR_TrailingProfitMethod;
      break;
    case BANDS1:
    case BANDS5:
    case BANDS15:
    case BANDS30:
      if (Bands_TrailingStopMethod > 0)   stop_method   = Bands_TrailingStopMethod;
      if (Bands_TrailingProfitMethod > 0) profit_method = Bands_TrailingProfitMethod;
      break;
    case ENVELOPES1:
    case ENVELOPES5:
    case ENVELOPES15:
    case ENVELOPES30:
      if (Envelopes_TrailingStopMethod > 0)   stop_method   = Envelopes_TrailingStopMethod;
      if (Envelopes_TrailingProfitMethod > 0) profit_method = Envelopes_TrailingProfitMethod;
      break;
    case DEMARKER1:
    case DEMARKER5:
    case DEMARKER15:
    case DEMARKER30:
      if (DeMarker_TrailingStopMethod > 0)   stop_method   = DeMarker_TrailingStopMethod;
      if (DeMarker_TrailingProfitMethod > 0) profit_method = DeMarker_TrailingProfitMethod;
      break;
    case WPR1:
    case WPR5:
    case WPR15:
    case WPR30:
      if (WPR_TrailingStopMethod > 0)   stop_method   = WPR_TrailingStopMethod;
      if (WPR_TrailingProfitMethod > 0) profit_method = WPR_TrailingProfitMethod;
      break;
    case FRACTALS1:
    case FRACTALS5:
    case FRACTALS15:
    case FRACTALS30:
      if (Fractals_TrailingStopMethod > 0)   stop_method   = Fractals_TrailingStopMethod;
      if (Fractals_TrailingProfitMethod > 0) profit_method = Fractals_TrailingProfitMethod;
      break;
    case STOCHASTIC1:
    case STOCHASTIC5:
    case STOCHASTIC15:
    case STOCHASTIC30:
      if (Stochastic_TrailingStopMethod > 0)   stop_method   = Stochastic_TrailingStopMethod;
      if (Stochastic_TrailingProfitMethod > 0) profit_method = Stochastic_TrailingProfitMethod;
      break;
    case BPOWER1:
    case BPOWER5:
    case BPOWER15:
    case BPOWER30:
      if (BPower_TrailingStopMethod > 0)   stop_method   = BPower_TrailingStopMethod;
      if (BPower_TrailingProfitMethod > 0) profit_method = BPower_TrailingProfitMethod;
      break;
    case ZIGZAG1:
    case ZIGZAG5:
    case ZIGZAG15:
    case ZIGZAG30:
      if (ZigZag_TrailingStopMethod > 0)   stop_method   = ZigZag_TrailingStopMethod;
      if (ZigZag_TrailingProfitMethod > 0) profit_method = ZigZag_TrailingProfitMethod;
      break;
    default:
      Msg::ShowText(StringFormat("Unknown order type: %s", order_type), "Trace", __FUNCTION__, __LINE__, VerboseTrace);
  }
  return Misc::If(stop_or_profit > 0, profit_method, stop_method);
}

// Calculate open positions (in volume).
int CalculateCurrentOrders(string symbol) {
   int buys=0, sells=0;

   for (int i = 0; i < OrdersTotal(); i++) {
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if (OrderSymbol() == Symbol() && CheckOurMagicNumber()){
         if (OrderType() == OP_BUY)  buys++;
         if (OrderType() == OP_SELL) sells++;
        }
     }
   if (buys > 0) return(buys); else return(-sells); // Return orders volume
}

// Return total number of opened orders (based on the EA magic number)
int GetTotalOrders(bool ours = TRUE) {
  int total = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol()) {
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
int GetTotalOrdersByType(int order_type) {
  static datetime last_access = time_current;
  if (Cache && open_orders[order_type] > 0 && last_access == time_current) { return open_orders[order_type]; } else { last_access = time_current; }; // Return cached if available.
  open_orders[order_type] = 0;
  // ArrayFill(open_orders[order_type], 0, ArraySize(open_orders), 0); // Reset open_orders array.
  for (int order = 0; order < OrdersTotal(); order++) {
   if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
     if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber + order_type) {
       open_orders[order_type]++;
     }
   }
  }
  return (open_orders[order_type]);
}

/**
 * Get total profit of opened orders by type.
 */
double GetTotalProfitByType(int cmd = NULL, int order_type = NULL) {
  double total = 0;
  for (int i = 0; i < OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
    if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if (OrderType() == cmd) total += Order::GetOrderProfit();
       else if (OrderMagicNumber() == MagicNumber + order_type) total += Order::GetOrderProfit();
     }
  }
  return total;
}

/**
 * Get profitable side and return trade operation type (OP_BUY/OP_SELL).
 */
bool GetProfitableSide() {
  double buys = GetTotalProfitByType(OP_BUY);
  double sells = GetTotalProfitByType(OP_SELL);
  if (buys > sells) return OP_BUY;
  if (sells > buys) return OP_SELL;
  return (EMPTY);
}

// Calculate open positions.
int CalculateOrdersByCmd(int cmd) {
  static int total = 0;
  static datetime last_access = time_current;
  if (Cache && total > 0 && last_access == time_current) { return total; } else { last_access = time_current; }; // Cache.
  total = 0;
  for (int i = 0; i < OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
    if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if(OrderType() == cmd) total++;
     }
  }
  return total;
}

/**
 * Calculate trade order command based on the majority of opened orders.
 */
int GetCmdByOrders() {
  int buys = CalculateOrdersByCmd(OP_BUY);
  int sells = CalculateOrdersByCmd(OP_SELL);
  if (buys > sells) return OP_BUY;
  if (sells > buys) return OP_SELL;
  return EMPTY;
}

// Calculate open positions.
double CalculateOpenLots() {
  double total_lots = 0;
   for (int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
      if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
        total_lots += OrderLots(); // This gives the total no of lots opened in current orders.
       }
   }
  return total_lots;
}

// For given magic number, check if it is ours.
bool CheckOurMagicNumber(int magic_number = NULL) {
  if (magic_number == NULL) magic_number = OrderMagicNumber();
  return (magic_number >= MagicNumber && magic_number < MagicNumber + FINAL_STRATEGY_TYPE_ENTRY);
}

// Check if it is possible to trade.
bool TradeAllowed() {
  string err;
  // Don't place multiple orders for the same bar.
  /*
  if (last_order_time == iTime(NULL, PERIOD_M1, 0)) {
    err = StringConcatenate("Not trading at the moment, as we already placed order on: ", TimeToStr(last_order_time));
    if (VerboseTrace && err != last_err) Print(__FUNCTION__ + ": " + err);
    last_err = err;
    return (FALSE);
  }*/
  if (Bars < 100) {
    last_debug = Msg::ShowText("Bars less than 100, not trading.", "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    if (PrintLogOnChart) DisplayInfoOnChart();
    ea_active = FALSE;
    return (FALSE);
  }
  if (Check::IsRealtime() && Volume[0] < MinVolumeToTrade) {
    last_debug = Msg::ShowText("Volume too low to trade.", "Debug", __FUNCTION__, __LINE__, VerboseDebug);
    if (PrintLogOnChart) DisplayInfoOnChart();
    ea_active = FALSE;
    return (FALSE);
  }
  if (IsTradeContextBusy()) {
    last_err = Msg::ShowText("Trade context is temporary busy.", "Error", __FUNCTION__, __LINE__, VerboseErrors);
    if (PrintLogOnChart) DisplayInfoOnChart();
    ea_active = FALSE;
    return (FALSE);
  }
  // Check if the EA is allowed to trade and trading context is not busy, otherwise returns false.
  // OrderSend(), OrderClose(), OrderCloseBy(), OrderModify(), OrderDelete() trading functions
  //   changing the state of a trading account can be called only if trading by Expert Advisors
  //   is allowed (the "Allow live trading" checkbox is enabled in the Expert Advisor or script properties).
  if (!IsTradeAllowed()) {
    last_err = Msg::ShowText("Trade is not allowed at the moment, check the settings!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    ea_active = FALSE;
    return (FALSE);
  }
  if (!IsConnected()) {
    last_err = Msg::ShowText("Terminal is not connected!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    if (PrintLogOnChart) DisplayInfoOnChart();
    ea_active = FALSE;
    return (FALSE);
  }
  if (IsStopped()) {
    last_err = Msg::ShowText("Terminal is stopping!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    ea_active = FALSE;
    return (FALSE);
  }
  if (Check::IsRealtime() && !MarketInfo(Symbol(), MODE_TRADEALLOWED)) {
    last_err = Msg::ShowText("Trade is not allowed, because market is closed.", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    if (PrintLogOnChart) DisplayInfoOnChart();
    ea_active = FALSE;
    return (FALSE);
  }
  if (Check::IsRealtime() && !IsExpertEnabled()) {
    last_err = Msg::ShowText("You need to enable: 'Enable Expert Advisor'/'AutoTrading'.", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    ea_active = FALSE;
    return (FALSE);
  }
  if (!session_active || StringLen(ea_file) != 11) {
    last_err = Msg::ShowText("Session is not active!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    ea_active = FALSE;
    return (FALSE);
  }

  ea_active = TRUE;
  return (TRUE);
}

/**
 * Check if EA parameters are valid.
 */
bool CheckSettings() {
  string err;
   // TODO: IsDllsAllowed(), IsLibrariesAllowed()
  /* @todo
  if (File::FileIsExist(Terminal::GetExpertPath() + "\\" + ea_file)) {
    Msg::ShowText("Meow!", "Error", __FUNCTION__, __LINE__, TRUE, TRUE, TRUE);
    return (FALSE);
  }
  #ifdef __release__
  #endif
  */
  /* // @todo
  if (ValidateSettings && !ValidateSettings()) {
    last_err = Msg::ShowText("Market values are invalid!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    ea_active = FALSE;
    return (FALSE);
  }
  */
  if (LotSize < 0.0) {
    Msg::ShowText("LotSize is less than 0.", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    return (FALSE);
  }
  #ifdef __release__
  #ifdef __backtest__
  if (Check::IsRealtime()) {
    Msg::ShowText("This version is compiled for backtest mode only.", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart);
    return (FALSE);
  }
  #endif
  #endif
  if (!Check::IsRealtime() && ValidateSettings) {
    if (!Backtest::ValidSpread() || !Backtest::ValidLotstep()) {
      Msg::ShowText("Backtest market settings are invalid!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
      return (FALSE);
    }
  }
  E_Mail = StringTrimLeft(StringTrimRight(E_Mail));
  License = StringTrimLeft(StringTrimRight(License));
  return !StringCompare(ValidEmail(E_Mail), License) && StringLen(ea_file) == 11;
}

/**
 * Validate market values.
 */
bool ValidateSettings() {
  bool result = True;
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
 * Get color of the order.
 */
color GetOrderColor(int cmd = -1) {
  if (cmd == -1) cmd = OrderType();
  return Convert::OrderTypeToValue(cmd) > 0 ? ColorBuy : ColorSell;
}

/**
 * This function returns the minimal permissible distance value in points for StopLoss/TakeProfit.
 *
 * This is due that at placing of a pending order, the open price cannot be too close to the market.
 * The minimal distance of the pending price from the current market one in points can be obtained
 * using the MarketInfo() function with the MODE_STOPLEVEL parameter.
 * Related error messages:
 *   Error 130 (ERR_INVALID_STOPS) happens In case of false open price of a pending order.
 *   Error 145 (ERR_TRADE_MODIFY_DENIED) happens when modification of order was too close to market.
 *
 */
double GetMinStopLevel() {
  return fmax((market_stoplevel + 1) * Point, (order_freezelevel + 1) * Point);
}

/**
 * Normalize lot size.
 */
double NormalizeLots(double lots, bool ceiling = False, string pair = "") {
  // See: http://forum.mql4.com/47988
  double lotsize;
  double precision;
  if (market_lotstep > 0.0) precision = 1 / market_lotstep;
  else precision = 1 / market_minlot;

  if (ceiling) lotsize = MathCeil(lots * precision) / precision;
  else lotsize = MathFloor(lots * precision) / precision;

  if (lotsize < market_minlot) lotsize = market_minlot;
  if (lotsize > market_maxlot) lotsize = market_maxlot;
  return NormalizeDouble(lotsize, volume_digits);
}

/**
 * Get account stopout level in range: 0.0 - 1.0 where 1.0 is 100%.
 *
 * Notes:
 *  - if(AccountEquity()/AccountMargin()*100 < AccountStopoutLevel()) { BrokerClosesOrders(); }
 */
double GetAccountStopoutLevel() {
  int mode = AccountStopoutMode();
  int level = AccountStopoutLevel();
  if (mode == 0 && level > 0) { // Calculation of percentage ratio between margin and equity.
     return (double)level / 100;
  } else if (mode == 1) { // Comparison of the free margin level to the absolute value.
    return 1.0;
  } else {
   if (VerboseErrors) PrintFormat("%s(): Not supported mode (%d).", __FUNCTION__, mode);
  }
  return 1.0;
}

/**
 * Calculate number of order allowed given risk ratio.
 */
int GetMaxOrdersAuto(bool smooth = true) {
  double avail_margin = fmin(Account::AccountFreeMargin(), Account::AccountBalance());
  double leverage     = fmax(Account::AccountLeverage(), 100);
  int balance_limit   = fmax(fmin(Account::AccountBalance(), Account::AccountEquity()) / 2, 0); // At least 1 order per 2 currency value. This also prevents trading with negative balance.
  double stopout_level = GetAccountStopoutLevel();
  double avail_orders = avail_margin / market_marginrequired / fmax(lot_size, market_lotstep) * (100 / leverage);
  int new_max_orders = avail_orders * stopout_level * risk_ratio;
  #ifdef __advanced__
  if (MaxOrdersPerDay > 0) new_max_orders = fmin(GetMaxOrdersPerDay(), new_max_orders);
  #endif
  if (VerboseTrace) PrintFormat("%s(): %f / %f / %f * (100/%d)", __FUNCTION__, avail_margin, market_marginrequired, fmax(lot_size, market_lotstep), leverage);
  if (smooth && new_max_orders > max_orders) {
    max_orders = (max_orders + new_max_orders) / 2; // Increase the limit smoothly.
  } else {
    max_orders = new_max_orders;
  }
  return max_orders;
}

/**
 * Get daily total available orders. It can dynamically change during the day.
 */
#ifdef __advanced__
int GetMaxOrdersPerDay() {
  if (MaxOrdersPerDay <= 0) return TRUE;
  int hours_left = (24 - hour_of_day);
  int curr_allowed_limit = floor((MaxOrdersPerDay - daily_orders) / hours_left);
  // Message(StringFormat("Hours left: (%d - %d) / %d= %d", MaxOrdersPerDay, daily_orders, hours_left, curr_allowed_limit));
  return fmin(fmax((total_orders - daily_orders), 1) + curr_allowed_limit, MaxOrdersPerDay);
}
#endif

/**
 * Calculate number of maximum of orders allowed to open.
 */
int GetMaxOrders() {
  #ifdef __advanced__
    return Misc::If(MaxOrders > 0, Misc::If(MaxOrdersPerDay > 0, fmin(MaxOrders, GetMaxOrdersPerDay()), MaxOrders), GetMaxOrdersAuto());
  #else
    return Misc::If(MaxOrders > 0, MaxOrders, GetMaxOrdersAuto());
  #endif
}

/**
 * Calculate the limit of maximum orders to open per each strategy.
 */
int GetMaxOrdersPerType() {
  return Misc::If(MaxOrdersPerType > 0, (int)MaxOrdersPerType, (int)fmax(MathFloor(max_orders / fmax(GetNoOfStrategies(), 1) ), 1) * 2);
}

/**
 * Get number of active strategies.
 */
int GetNoOfStrategies() {
  int result = 0;
  for (int i = 0; i < FINAL_STRATEGY_TYPE_ENTRY; i++) {
    result += info[i][ACTIVE];
  }
  return result;
}

/**
 * Calculate size of the lot based on the free margin and account leverage automatically.
 */
double GetLotSizeAuto(bool smooth = true) {
  double avail_margin = fmin(AccountFreeMargin(), AccountBalance());
  double leverage     = fmax(AccountLeverage(), 100);
  // @todo: Improve the logic, especially risk_margin.
  double new_lot_size = avail_margin / market_marginrequired * risk_margin/100 * risk_ratio;

  #ifdef __advanced__
  if (Boosting_Enabled) {
    if ((LotSizeIncreaseMethod &   1) != 0) if (AccCondition(C_ACC_IN_PROFIT))      new_lot_size *= 1.1;
    if ((LotSizeIncreaseMethod &   2) != 0) if (AccCondition(C_EQUITY_10PC_HIGH))   new_lot_size *= 1.1;
    if ((LotSizeIncreaseMethod &   4) != 0) if (AccCondition(C_EQUITY_20PC_HIGH))   new_lot_size *= 1.1;
    if ((LotSizeIncreaseMethod &   8) != 0) if (AccCondition(C_DBAL_LT_WEEKLY))     new_lot_size *= 1.1;
    if ((LotSizeIncreaseMethod &  16) != 0) if (AccCondition(C_WBAL_GT_MONTHLY))    new_lot_size *= 1.1;
    if ((LotSizeIncreaseMethod &  32) != 0) if (AccCondition(C_ACC_IN_TREND))       new_lot_size *= 1.1;
    if ((LotSizeIncreaseMethod &  64) != 0) if (AccCondition(C_ACC_CDAY_IN_PROFIT)) new_lot_size *= 1.1;
    if ((LotSizeIncreaseMethod & 128) != 0) if (AccCondition(C_ACC_PDAY_IN_PROFIT)) new_lot_size *= 1.1;

    if ((LotSizeDecreaseMethod &   1) != 0) if (AccCondition(C_ACC_IN_LOSS))        new_lot_size *= 0.9;
    if ((LotSizeDecreaseMethod &   2) != 0) if (AccCondition(C_EQUITY_10PC_LOW))    new_lot_size *= 0.9;
    if ((LotSizeDecreaseMethod &   4) != 0) if (AccCondition(C_EQUITY_20PC_LOW))    new_lot_size *= 0.9;
    if ((LotSizeDecreaseMethod &   8) != 0) if (AccCondition(C_DBAL_GT_WEEKLY))     new_lot_size *= 0.9;
    if ((LotSizeDecreaseMethod &  16) != 0) if (AccCondition(C_WBAL_LT_MONTHLY))    new_lot_size *= 0.9;
    if ((LotSizeDecreaseMethod &  32) != 0) if (AccCondition(C_ACC_IN_NON_TREND))   new_lot_size *= 0.9;
    if ((LotSizeDecreaseMethod &  64) != 0) if (AccCondition(C_ACC_CDAY_IN_LOSS))   new_lot_size *= 0.9;
    if ((LotSizeDecreaseMethod & 128) != 0) if (AccCondition(C_ACC_PDAY_IN_LOSS))   new_lot_size *= 0.9;
  }
  #endif

  if (smooth) {
    // Increase only by average of the previous and new (which should prevent sudden increases).
    return (lot_size + new_lot_size) / 2;
  } else {
    return new_lot_size;
  }
}

/**
 * Return current lot size to trade.
 */
double GetLotSize() {
  return NormalizeLots(Misc::If(LotSize == 0, GetLotSizeAuto(), LotSize));
}

/**
 * Calculate size of the lot based on the free margin and account leverage automatically.
 */
double GetRiskMarginAuto(bool smooth = true) {
  // Risk only 2%/1% (0.02/0.01) per order of total available margin.
  double new_risk_margin = 1.0;
  if (smooth && new_risk_margin > risk_margin) {
    // Increase only by average of the previous and new (which should prevent sudden increases).
    return (risk_margin + new_risk_margin) / 2;
  } else {
    return new_risk_margin;
  }
}

/**
 * Return risk margin.
 * @return int
 *   Range: 1-100
 */
double GetRiskMargin() {
  return RiskMargin == 0 ? GetRiskMarginAuto() : RiskMargin;
}

/**
 * Calculate auto risk ratio value.
 */
double GetAutoRiskRatio() {
  double equity  = Account::AccountEquity();
  double balance = Account::AccountBalance();
  // Used when you open/close new positions. It can increase decrease during the price movement in favor and vice versa.
  double free    = Account::AccountFreeMargin();
  // Taken from your depo as a guarantee to maintain your current positions opened. It stays the same untill you open or close positions.
  double margin  = Account::AccountMargin();
  double new_risk_ratio = 1 / fmin(equity, balance) * fmin(fmin(free, balance), equity);

  #ifdef __advanced__
    int margin_pc = 100 / equity * margin;
    rr_text = Misc::If(new_risk_ratio < 1.0, StringFormat("-MarginUsed=%d%%|", margin_pc), ""); string s = "|";
    if ((RiskRatioIncreaseMethod &   1) != 0) if (AccCondition(C_ACC_IN_PROFIT))      { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if ((RiskRatioIncreaseMethod &   2) != 0) if (AccCondition(C_EQUITY_10PC_LOW))    { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if ((RiskRatioIncreaseMethod &   4) != 0) if (AccCondition(C_EQUITY_20PC_LOW))    { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if ((RiskRatioIncreaseMethod &   8) != 0) if (AccCondition(C_DBAL_LT_WEEKLY))     { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if ((RiskRatioIncreaseMethod &  16) != 0) if (AccCondition(C_WBAL_GT_MONTHLY))    { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if ((RiskRatioIncreaseMethod &  32) != 0) if (AccCondition(C_ACC_IN_TREND))       { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if ((RiskRatioIncreaseMethod &  64) != 0) if (AccCondition(C_ACC_CDAY_IN_PROFIT)) { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }
    if ((RiskRatioIncreaseMethod & 128) != 0) if (AccCondition(C_ACC_PDAY_IN_PROFIT)) { new_risk_ratio *= 1.1; rr_text += "+"+last_cname+s; }

    if ((RiskRatioDecreaseMethod &   1) != 0) if (AccCondition(C_ACC_IN_LOSS))        { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if ((RiskRatioDecreaseMethod &   2) != 0) if (AccCondition(C_EQUITY_10PC_HIGH))   { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if ((RiskRatioDecreaseMethod &   4) != 0) if (AccCondition(C_EQUITY_20PC_HIGH))   { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if ((RiskRatioDecreaseMethod &   8) != 0) if (AccCondition(C_DBAL_GT_WEEKLY))     { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if ((RiskRatioDecreaseMethod &  16) != 0) if (AccCondition(C_WBAL_LT_MONTHLY))    { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if ((RiskRatioDecreaseMethod &  32) != 0) if (AccCondition(C_ACC_IN_NON_TREND))   { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if ((RiskRatioDecreaseMethod &  64) != 0) if (AccCondition(C_ACC_CDAY_IN_LOSS))   { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    if ((RiskRatioDecreaseMethod & 128) != 0) if (AccCondition(C_ACC_PDAY_IN_LOSS))   { new_risk_ratio *= 0.9; rr_text += "-"+last_cname+s; }
    TxtRemoveSepChar(rr_text, s);
  #else
    if (GetTotalProfit() < 0) new_risk_ratio /= 2; // Half risk if we're in overall loss.
  #endif

  return new_risk_ratio;
}

/**
 * Return risk ratio value.
 */
double GetRiskRatio() {
  return Misc::If(RiskRatio == 0, GetAutoRiskRatio(), RiskRatio);
}

/**
 * Validate the e-mail.
 */
string ValidEmail(string text) {
  string output = StringLen(text);
  if (text == "") {
    Msg::ShowText("E-mail is empty, please validate the settings.", "Error", __FUNCTION__, __LINE__, TRUE, TRUE, TRUE);
    ea_active = FALSE;
    return FALSE;
  }
  if (StringFind(text, "@") == EMPTY || StringFind(text, ".") == EMPTY) {
    Msg::ShowText("E-mail is not in valid format.", "Error", __FUNCTION__, __LINE__, TRUE, TRUE, TRUE);
    ea_active = FALSE;
    return FALSE;
  }
  for (last_bar_time = StringLen(text); last_bar_time >= 0; last_bar_time--)
    output += IntegerToString(StringGetChar(text, last_bar_time), 3, '-');
  StringReplace(output, "9", "1"); StringReplace(output, "8", "7"); StringReplace(output, "--", "-3");
  output = StringSubstr(output, 0, StringLen(ea_name) + StringLen(ea_author) + StringLen(ea_link));
  output = StringSubstr(output, 0, StringLen(output) - 1);
  #ifdef __testing__ #define print_email #endif
  #ifdef print_email
    Print(output);
  #endif
  return output;
}

/* BEGIN: PERIODIC FUNCTIONS */

/**
 * Executed for every hour.
 */
void StartNewHour() {
  CheckHistory(); // Process closed orders for the previous hour.

  // Process actions.
  CheckAccConditions();

  // Print stats.
  Msg::ShowText(
    StringFormat("Hourly stats: Ticks: %d/h (%.2f/min)",
      hourly_stats.GetTotalTicks(),
      hourly_stats.GetTotalTicks() / 60
    ), "Debug", __FUNCTION__, __LINE__, VerboseDebug);
  // Reset variables.
  hourly_stats.Reset();

  // Start the new hour.
  // Note: This needs to be after action processing.
  hour_of_day = Hour();

  if (VerboseDebug) PrintFormat("== New hour: %d", hour_of_day);

  // Update variables.
  risk_ratio = GetRiskRatio();
  max_orders = GetMaxOrders();

  // Check if new day has been started.
  if (day_of_week != DayOfWeek()) {
    StartNewDay();
  }

  // Update strategy factor and lot size.
  if (Boosting_Enabled) UpdateStrategyFactor(DAILY);

  #ifdef __advanced__
  // Check if RSI period needs re-calculation.
  if (RSI_DynamicPeriod) RSI_CheckPeriod();
  // Check for dynamic spread configuration.
  if (DynamicSpreadConf) {
    // TODO: SpreadRatio, MinPipChangeToTrade, MinPipGap
  }
  #endif

  // Reset messages and errors.
  // Message(NULL);
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
 * Get last available error.
 */
string GetLastErrMsg() {
  return last_err;
}

/**
 * Executed for every new day.
 */
void StartNewDay() {
  if (VerboseInfo) PrintFormat("== New day (day of month: %d; day of year: %d ==",  Day(), DayOfYear());

  // Print daily report at end of each day.
  if (VerboseInfo) Print(GetDailyReport());

  // Process actions.
  CheckAccConditions();

  // Check if day started another week.
  if (DayOfWeek() < day_of_week) {
    StartNewWeek();
  }
  if (Day() < day_of_month) {
    StartNewMonth();
  }
  if (DayOfYear() < day_of_year) {
    StartNewYear();
  }

  // Update boosting values.
  if (Boosting_Enabled) UpdateStrategyFactor(WEEKLY);

  // Store new data.
  day_of_week = DayOfWeek(); // The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date. At the testing, the last known server time is modelled.
  day_of_month = Day(); // The day of month (1 - 31) of the specified date. At the testing, the last known server time is modelled.
  day_of_year = DayOfYear(); // Day (1 means 1 January,..,365(6) does 31 December) of year. At the testing, the last known server time is modelled.
  // Print and reset variables.
  daily_orders = 0;
  string sar_stats = "Daily SAR stats: ";
  for (int i = 0; i < FINAL_PERIOD_TYPE_ENTRY; i++) {
    sar_stats += "Period: " + i + ", Buy: " + signals[DAILY][SAR1][i][OP_BUY] + " / " + "Sell: " + signals[DAILY][SAR1][i][OP_SELL] + "; ";
    // sar_stats += "Buy M5: " + signals[DAILY][SAR5][i][OP_BUY] + " / " + "Sell M5: " + signals[DAILY][SAR5][i][OP_SELL] + "; ";
    // sar_stats += "Buy M15: " + signals[DAILY][SAR15][i][OP_BUY] + " / " + "Sell M15: " + signals[DAILY][SAR15][i][OP_SELL] + "; ";
    // sar_stats += "Buy M30: " + signals[DAILY][SAR30][i][OP_BUY] + " / " + "Sell M30: " + signals[DAILY][SAR30][i][OP_SELL] + "; ";
    signals[DAILY][SAR1][i][OP_BUY] = 0;  signals[DAILY][SAR1][i][OP_SELL]  = 0;
    // signals[DAILY][SAR5][i][OP_BUY] = 0;  signals[DAILY][SAR5][i][OP_SELL]  = 0;
    // signals[DAILY][SAR15][i][OP_BUY] = 0; signals[DAILY][SAR15][i][OP_SELL] = 0;
    // signals[DAILY][SAR30][i][OP_BUY] = 0; signals[DAILY][SAR30][i][OP_SELL] = 0;
  }
  if (VerboseInfo) Print(sar_stats);

  // Reset previous data.
  ArrayFill(daily, 0, ArraySize(daily), 0);
  // Print and reset strategy stats.
  string strategy_stats = "Daily strategy stats: ";
  for (int j = 0; j < FINAL_STRATEGY_TYPE_ENTRY; j++) {
    if (stats[j][DAILY_PROFIT] != 0) strategy_stats += sname[j] + ": " + stats[j][DAILY_PROFIT] + "pips; ";
    stats[j][DAILY_PROFIT]  = 0;
  }
  if (VerboseInfo) Print(strategy_stats);
}

/**
 * Executed for every new week.
 */
void StartNewWeek() {
  if (StringLen(__FILE__) != 11) { ExpertRemove(); }
  if (VerboseInfo) Print("== New week ==");
  if (VerboseInfo) Print(GetWeeklyReport()); // Print weekly report at end of each week.

  // Process actions.
  CheckAccConditions();

  // Calculate lot size, orders and risk.
  risk_margin = GetRiskMargin(); // Re-calculate risk margin.
  lot_size = GetLotSize(); // Re-calculate lot size.
  UpdateStrategyLotSize(); // Update strategy lot size.
  if (Boosting_Enabled) UpdateStrategyFactor(MONTHLY);

  // Reset variables.
  string sar_stats = "Weekly SAR stats: ";
  for (int i = 0; i < FINAL_PERIOD_TYPE_ENTRY; i++) {
    sar_stats += "Period: " + i + ", Buy: " + signals[WEEKLY][SAR1][i][OP_BUY] + " / " + "Sell: " + signals[WEEKLY][SAR1][i][OP_SELL] + "; ";
    //sar_stats += "Buy M1: " + signals[WEEKLY][SAR1][i][OP_BUY] + " / " + "Sell M1: " + signals[WEEKLY][SAR1][i][OP_SELL] + "; ";
    //sar_stats += "Buy M5: " + signals[WEEKLY][SAR5][i][OP_BUY] + " / " + "Sell M5: " + signals[WEEKLY][SAR5][i][OP_SELL] + "; ";
    //sar_stats += "Buy M15: " + signals[WEEKLY][SAR15][i][OP_BUY] + " / " + "Sell M15: " + signals[WEEKLY][SAR15][i][OP_SELL] + "; ";
    //sar_stats += "Buy M30: " + signals[WEEKLY][SAR30][i][OP_BUY] + " / " + "Sell M30: " + signals[WEEKLY][SAR30][i][OP_SELL] + "; ";
    signals[WEEKLY][SAR1][i][OP_BUY]  = 0; signals[WEEKLY][SAR1][i][OP_SELL]  = 0;
    // signals[WEEKLY][SAR5][i][OP_BUY]  = 0; signals[WEEKLY][SAR5][i][OP_SELL]  = 0;
    // signals[WEEKLY][SAR15][i][OP_BUY] = 0; signals[WEEKLY][SAR15][i][OP_SELL] = 0;
    // signals[WEEKLY][SAR30][i][OP_BUY] = 0; signals[WEEKLY][SAR30][i][OP_SELL] = 0;
  }
  if (VerboseInfo) Print(sar_stats);

  ArrayFill(weekly, 0, ArraySize(weekly), 0);
  // Reset strategy stats.
  string strategy_stats = "Weekly strategy stats: ";
  for (int j = 0; j < FINAL_STRATEGY_TYPE_ENTRY; j++) {
    if (stats[j][WEEKLY_PROFIT] != 0) strategy_stats += sname[j] + ": " + stats[j][WEEKLY_PROFIT] + "pips; ";
    stats[j][WEEKLY_PROFIT] = 0;
  }
  if (VerboseInfo) Print(strategy_stats);
}

/**
 * Executed for every new month.
 */
void StartNewMonth() {
  if (VerboseInfo) Print("== New month ==");
  if (VerboseInfo) Print(GetMonthlyReport()); // Print monthly report at end of each month.

  // Process actions.
  CheckAccConditions();

  // Store new data.
  month = DateTime::Month(); // Returns the current month as number (1-January,2,3,4,5,6,7,8,9,10,11,12), i.e., the number of month of the last known server time.

  // Reset variables.
  string sar_stats = "Monthly SAR stats: ";
  for (int i = 0; i < FINAL_PERIOD_TYPE_ENTRY; i++) {
    sar_stats += "Period: " + i + ", Buy: " + signals[MONTHLY][SAR1][i][OP_BUY] + " / " + "Sell: " + signals[MONTHLY][SAR1][i][OP_SELL] + "; ";
    // sar_stats += "Buy M1: " + signals[MONTHLY][SAR1][i][OP_BUY] + " / " + "Sell M1: " + signals[MONTHLY][SAR1][i][OP_SELL] + "; ";
    // sar_stats += "Buy M5: " + signals[MONTHLY][SAR5][i][OP_BUY] + " / " + "Sell M5: " + signals[MONTHLY][SAR5][i][OP_SELL] + "; ";
    // sar_stats += "Buy M15: " + signals[MONTHLY][SAR15][i][OP_BUY] + " / " + "Sell M15: " + signals[MONTHLY][SAR15][i][OP_SELL] + "; ";
    // sar_stats += "Buy M30: " + signals[MONTHLY][SAR30][i][OP_BUY] + " / " + "Sell M30: " + signals[MONTHLY][SAR30][i][OP_SELL] + "; ";
    signals[MONTHLY][SAR1][i][OP_BUY]  = 0; signals[MONTHLY][SAR1][i][OP_SELL]  = 0;
    // signals[MONTHLY][SAR5][i][OP_BUY]  = 0; signals[MONTHLY][SAR5][i][OP_SELL]  = 0;
    // signals[MONTHLY][SAR15][i][OP_BUY] = 0; signals[MONTHLY][SAR15][i][OP_SELL] = 0;
    // signals[MONTHLY][SAR30][i][OP_BUY] = 0; signals[MONTHLY][SAR30][i][OP_SELL] = 0;
  }
  if (VerboseInfo) Print(sar_stats);

  ArrayFill(monthly, 0, ArraySize(monthly), 0);
  // Reset strategy stats.
  string strategy_stats = "Monthly strategy stats: ";
  for (int j = 0; j < FINAL_STRATEGY_TYPE_ENTRY; j++) {
    if (stats[j][MONTHLY_PROFIT] != 0) strategy_stats += sname[j] + ": " + stats[j][MONTHLY_PROFIT] + " pips; ";
    stats[j][MONTHLY_PROFIT] = fmin(0, stats[j][MONTHLY_PROFIT]);
  }
  if (VerboseInfo) Print(strategy_stats);
}

/**
 * Executed for every new year.
 */
void StartNewYear() {
  if (VerboseInfo) Print("== New year ==");
  // if (VerboseInfo) Print(GetYearlyReport()); // Print monthly report at end of each year.

  // Store new data.
  year = DateTime::Year(); // Returns the current year, i.e., the year of the last known server time.

  // Reset variables.
  for (int i = 0; i < FINAL_PERIOD_TYPE_ENTRY; i++) {
    signals[YEARLY][SAR1][i][OP_BUY] = 0;
    signals[YEARLY][SAR1][i][OP_SELL] = 0;
  }
}

/* END: PERIODIC FUNCTIONS */

/* BEGIN: VARIABLE FUNCTIONS */

/**
 * Initialize startup variables.
 */
bool InitializeVariables() {

  bool init = TRUE;

  // Get type of account.
  if (IsDemo()) account_type = "Demo"; else account_type = "Live";
  if (!Check::IsRealtime()) account_type = "Backtest on " + account_type;
  #ifdef __backtest__ init &= !Check::IsRealtime(); #endif

  // Check time of the week, month and year based on the trading bars.
  time_current = TimeCurrent();
  bar_time = iTime(NULL, PERIOD_M1, 0);
  hour_of_day = DateTime::Hour(); // The hour (0,1,2,..23) of the last known server time by the moment of the program start.
  day_of_week = DateTime::DayOfWeek(); // The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date. At the testing, the last known server time is modelled.
  day_of_month = DateTime::Day(); // The day of month (1 - 31) of the specified date. At the testing, the last known server time is modelled.
  day_of_year = DateTime::DayOfYear(); // Day (1 means 1 January,..,365(6) does 31 December) of year. At the testing, the last known server time is modelled.
  month = DateTime::Month(); // Returns the current month as number (1-January,2,3,4,5,6,7,8,9,10,11,12), i.e., the number of month of the last known server time.
  year = DateTime::Year(); // Returns the current year, i.e., the year of the last known server time.

  // @todo Move to method.
  market_lotsize = MarketInfo(_Symbol, MODE_LOTSIZE); // Lot size in the base currency.
  if (market_lotsize <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid MODE_LOTSIZE: %g", market_lotsize), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
  }

  market_lotstep = MarketInfo(_Symbol, MODE_LOTSTEP); // Step for changing lots.
  // @todo: Move to method.
  if (market_lotstep <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid MODE_LOTSTEP: %g", market_lotstep), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
    market_lotstep = 0.01;
  }

  market_minlot = MarketInfo(_Symbol, MODE_MINLOT); // Minimum permitted amount of a lot
  // @todo: Move to method.
  if (market_minlot <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid MODE_MINLOT: %g", market_minlot), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
    market_minlot = market_lotstep;
  }

  market_maxlot = MarketInfo(_Symbol, MODE_MAXLOT); // Maximum permitted amount of a lot
  // @todo: Move to method.
  if (market_maxlot <= 0.0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid MODE_MAXLOT: %g", market_maxlot), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
    market_maxlot = 100;
  }

  market_marginrequired = Market::GetMarginRequired();
  if (market_marginrequired == 0) {
    init &= !ValidateSettings;
    Msg::ShowText(StringFormat("Invalid MODE_MARGINREQUIRED: %g", market_marginrequired), "Error", __FUNCTION__, __LINE__, VerboseErrors & ValidateSettings, PrintLogOnChart, ValidateSettings);
    market_marginrequired = 10; // Fix for 'zero divide' bug when MODE_MARGINREQUIRED is zero.
  }

  market_margininit = Market::GetMarginInit();
  market_stoplevel = Market::GetStopLevel();
  order_freezelevel = Market::GetFreezeLevel();

  // market_stoplevel=(int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
  curr_spread = Market::GetSpreadInPips();
  LastAsk = Ask; LastBid = Bid;
  init_balance = Account::AccountBalance();
  if (init_balance <= 0) {
    Msg::ShowText(StringFormat("Account balance is %g!", init_balance), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return (FALSE);
  }
  if (Account::AccountEquity() <= 0) {
    Msg::ShowText(StringFormat("Account equity is %g!", Account::AccountEquity()), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return (FALSE);
  }
  if (Account::AccountFreeMargin() <= 0) {
    Msg::ShowText(StringFormat("Account free margin is %g!", Account::AccountFreeMargin()), "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return (FALSE);
  }
  summary = new SummaryReport(init_balance);
  /* @fixme: https://travis-ci.org/EA31337-Tester/EA31337-Lite-Sets/builds/140302386
  if (Account::AccountMargin() <= 0) {
    Msg::ShowText(StringFormat("Account margin is %g!", Account::AccountMargin()), "Error", __FUNCTION__, __LINE__, VerboseErrors);
    return (FALSE);
  }
  */

  init_spread = Market::GetSpreadInPts(); // @todo
  AccCurrency = AccountCurrency();

  // Calculate pip/volume/slippage size and precision.
  // Market *market = new Market(_Symbol);
  pip_size = Market::GetPipSize();
  pip_digits = Market::GetPipDigits();
  pts_per_pip = Market::GetPointsPerPip();
  volume_digits = Market::GetVolumeDigits();

  max_order_slippage = Convert::PipsToPoints(MaxOrderPriceSlippage); // Maximum price slippage for buy or sell orders (converted into points).

  // Calculate lot size, orders, risk ratio and margin risk.
  risk_ratio = GetRiskRatio();   // Re-calculate risk ratio.
  risk_margin = GetRiskMargin(); // Re-calculate risk margin.
  lot_size = GetLotSize();       // Re-calculate lot size.
  max_orders = GetMaxOrders();

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
  total_stats = new Stats();
  hourly_stats = new Stats();
  return (init);
}

#ifdef __advanced__

/**
 * Disable specific component for diagnostic purposes.
 */
void ToggleComponent(int component) {
  switch (component) {
    // Conditional actions.
    case 1:
      Account_Conditions_Active = !Account_Conditions_Active;
      break;
    case 2:
      DisableCloseConditions = !DisableCloseConditions;
      break;
    // Boosting
    case 3:
      Boosting_Enabled = !Boosting_Enabled;
      break;
    case 4:
      BoostByProfitFactor = !BoostByProfitFactor;
      break;
    case 5:
      if (BestDailyStrategyMultiplierFactor != 1.0 || BestWeeklyStrategyMultiplierFactor != 1.0 || BestMonthlyStrategyMultiplierFactor != 1.0) {
        BestDailyStrategyMultiplierFactor = 1.0;
        BestWeeklyStrategyMultiplierFactor = 1.0;
        BestMonthlyStrategyMultiplierFactor = 1.0;
      } else {
        BestDailyStrategyMultiplierFactor = 1.2;
        BestWeeklyStrategyMultiplierFactor = 1.2;
        BestMonthlyStrategyMultiplierFactor = 1.5;
      }
      break;
    case 6:
      if (WorseDailyStrategyDividerFactor != 1.0 || WorseWeeklyStrategyDividerFactor != 1.0 || WorseMonthlyStrategyDividerFactor != 1.0) {
        WorseDailyStrategyDividerFactor = 1.0;
        WorseWeeklyStrategyDividerFactor = 1.0;
        WorseMonthlyStrategyDividerFactor = 1.0;
      } else {
        WorseDailyStrategyDividerFactor = 2;
        WorseWeeklyStrategyDividerFactor = 2;
        WorseMonthlyStrategyDividerFactor = 0;
      }
      break;
    case 7:
      if (BoostTrendFactor != 1.0) BoostTrendFactor = 1.0;
      else BoostTrendFactor = 1.2;
      break;
    case 8:
      HandicapByProfitFactor = !HandicapByProfitFactor;
      break;
    // Smart order queue
    case 9:
      SmartQueueActive = !SmartQueueActive;
      break;
    // Trend
    case 10:
      TradeWithTrend = !TradeWithTrend;
      break;
    case 11:
      if (TrendMethod > 0) TrendMethod = 0; else TrendMethod = 181;
      break;
    case 12:
      if (TrendMethodAction > 0) TrendMethodAction = 0; else TrendMethodAction = 17;
      break;
    // Risk
    case 13:
      if (RiskRatio > 0) RiskRatio = 0.0;
      else RiskRatio = 1.0;
      break;
    case 14:
      if (RiskRatioIncreaseMethod > 0) RiskRatioIncreaseMethod = 0; else RiskRatioIncreaseMethod = 255;
      break;
    case 15:
      if (RiskRatioDecreaseMethod > 0) RiskRatioIncreaseMethod = 0; else RiskRatioIncreaseMethod = 255;
      break;
    case 16:
      MinimalizeLosses = !MinimalizeLosses;
      break;
    // Spreads
    case 17:
      ApplySpreadLimits = !ApplySpreadLimits;
      MaxSpreadToTrade = 100;
      break;
    case 18:
      DynamicSpreadConf = !DynamicSpreadConf;
      break;
    // Lot size
    case 19:
      if (LotSize > 0) LotSize = 0.0;
      else LotSize = market_minlot;
      break;
    case 20:
      if (LotSizeIncreaseMethod > 0) LotSizeIncreaseMethod = 0; else LotSizeIncreaseMethod = 255;
      break;
    case 21:
      if (LotSizeDecreaseMethod > 0) LotSizeDecreaseMethod = 0; else LotSizeDecreaseMethod = 255;
      break;
    // Order limits
    case 22:
      if (MaxOrders > 0) MaxOrders = 0;
      else MaxOrders = 30;
      break;
    case 23:
      if (MaxOrdersPerType > 0) MaxOrdersPerType = 0;
      else MaxOrdersPerType = 3;
      break;
    case 24:
      if (MaxOrdersPerDay > 0) MaxOrdersPerDay = 0;
      else MaxOrdersPerDay = 30;
      break;
    case 25:
      if (MinIntervalSec > 0) MinIntervalSec = 0;
      else MinIntervalSec = 240;
      break;
    // Trade limits
    case 26:
      if (MinVolumeToTrade > 0) MinVolumeToTrade = 0;
      else MinVolumeToTrade = 2;
      break;
    case 27:
      if (MinPipChangeToTrade < 0.5) MinPipChangeToTrade = 1.0;
      else MinPipChangeToTrade = 0.5;
      break;
    case 28:
      if (MinPipGap < 5) MinPipGap = 10;
      else MinPipGap = 5;
      break;
    // Indicator specific
    case 29:
      RSI_DynamicPeriod = !RSI_DynamicPeriod;
      break;
    // Profit and loss
    case 30:
      if (Account_Condition_MinProfitCloseOrder > 20) Account_Condition_MinProfitCloseOrder = 0;
      else Account_Condition_MinProfitCloseOrder = 20;
      break;
    case 31:
      if (TakeProfit > 0) TakeProfit = 0;
      else TakeProfit = 40;
      break;
    case 32:
      if (StopLoss > 0) StopLoss = 0;
      else StopLoss = 40;
      break;
    // Trailing values
    case 33:
      if (TrailingStop > 0) TrailingStop = 0;
      else TrailingStop = 40;
      break;
    case 34:
      if (TrailingProfit > 0) TrailingProfit = 0;
      else TrailingProfit = 40;
      break;
    case 35:
      TrailingStopOneWay = !TrailingStopOneWay;
      break;
    case 36:
      TrailingProfitOneWay = !TrailingProfitOneWay;
      break;
    // Strategies
    case 37:
      Arrays::ArrSetValueI(info, OPEN_CONDITION1,  0);
      break;
    case 38:
      Arrays::ArrSetValueI(info, OPEN_CONDITION2,  0);
      break;
    case 39:
      Arrays::ArrSetValueI(info, CLOSE_CONDITION, C_MACD_BUY_SELL);
      break;
    case 40:
      Arrays::ArrSetValueD(conf, OPEN_LEVEL, 0.0);
      break;
    case 41:
      Arrays::ArrSetValueD(conf, SPREAD_LIMIT,  100.0);
      break;
    case 42:
      for (int m1 = 0; m1 < ArrayRange(info, 0); m1++)
        if (info[m1][TIMEFRAME] == PERIOD_M1) info[m1][ACTIVE] = FALSE;
      break;
    case 43:
      for (int m5 = 0; m5 < ArrayRange(info, 0); m5++)
        if (info[m5][TIMEFRAME] == PERIOD_M5) info[m5][ACTIVE] = FALSE;
      break;
    default:
      break;
  }
}

#endif

/**
 * Initialize strategies.
 */
bool InitStrategies() {
  bool init = TRUE;

  // Initialize/reset strategy arrays.
  ArrayInitialize(info, 0);  // Reset strategy info.
  ArrayInitialize(conf, 0);  // Reset strategy configuration.
  ArrayInitialize(stats, 0); // Reset strategy statistics.

  // Initialize strategy array variables.
  #ifdef __advanced__
  init &= InitStrategy(AC1,  "AC M1",  AC1_Active,  AC, PERIOD_M1,  AC1_SignalMethod,  AC_SignalLevel, AC1_OpenCondition1,  AC1_OpenCondition2,  AC1_CloseCondition,  AC1_MaxSpread);
  init &= InitStrategy(AC5,  "AC M5",  AC5_Active,  AC, PERIOD_M5,  AC5_SignalMethod,  AC_SignalLevel, AC5_OpenCondition1,  AC5_OpenCondition2,  AC5_CloseCondition,  AC5_MaxSpread);
  init &= InitStrategy(AC15, "AC M15", AC15_Active, AC, PERIOD_M15, AC15_SignalMethod, AC_SignalLevel, AC15_OpenCondition1, AC15_OpenCondition2, AC15_CloseCondition, AC15_MaxSpread);
  init &= InitStrategy(AC30, "AC M30", AC30_Active, AC, PERIOD_M30, AC30_SignalMethod, AC_SignalLevel, AC30_OpenCondition1, AC30_OpenCondition2, AC30_CloseCondition, AC30_MaxSpread);
  #else
  init &= InitStrategy(AC1,  "AC M1",  AC1_Active,  AC, PERIOD_M1,  AC1_SignalMethod,  AC_SignalLevel);
  init &= InitStrategy(AC5,  "AC M5",  AC5_Active,  AC, PERIOD_M5,  AC5_SignalMethod,  AC_SignalLevel);
  init &= InitStrategy(AC15, "AC M15", AC15_Active, AC, PERIOD_M15, AC15_SignalMethod, AC_SignalLevel);
  init &= InitStrategy(AC30, "AC M30", AC30_Active, AC, PERIOD_M30, AC30_SignalMethod, AC_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(AD1,  "AD M1",  AD1_Active,  AD, PERIOD_M1,  AD1_SignalMethod,  AD_SignalLevel, AD1_OpenCondition1,  AD1_OpenCondition2,  AD1_CloseCondition,  AD1_MaxSpread);
  init &= InitStrategy(AD5,  "AD M5",  AD5_Active,  AD, PERIOD_M5,  AD5_SignalMethod,  AD_SignalLevel, AD5_OpenCondition1,  AD5_OpenCondition2,  AD5_CloseCondition,  AD5_MaxSpread);
  init &= InitStrategy(AD15, "AD M15", AD15_Active, AD, PERIOD_M15, AD15_SignalMethod, AD_SignalLevel, AD15_OpenCondition1, AD15_OpenCondition2, AD15_CloseCondition, AD15_MaxSpread);
  init &= InitStrategy(AD30, "AD M30", AD30_Active, AD, PERIOD_M30, AD30_SignalMethod, AD_SignalLevel, AD30_OpenCondition1, AD30_OpenCondition2, AD30_CloseCondition, AD30_MaxSpread);
  #else
  init &= InitStrategy(AD1,  "AD M1",  AD1_Active,  AD, PERIOD_M1,  AD1_SignalMethod,  AD_SignalLevel);
  init &= InitStrategy(AD5,  "AD M5",  AD5_Active,  AD, PERIOD_M5,  AD5_SignalMethod,  AD_SignalLevel);
  init &= InitStrategy(AD15, "AD M15", AD15_Active, AD, PERIOD_M15, AD15_SignalMethod, AD_SignalLevel);
  init &= InitStrategy(AD30, "AD M30", AD30_Active, AD, PERIOD_M30, AD30_SignalMethod, AD_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(ADX1,  "ADX M1",  ADX1_Active,  ADX, PERIOD_M1,  ADX1_SignalMethod,  ADX_SignalLevel, ADX1_OpenCondition1,  ADX1_OpenCondition2,  ADX1_CloseCondition,  ADX1_MaxSpread);
  init &= InitStrategy(ADX5,  "ADX M5",  ADX5_Active,  ADX, PERIOD_M5,  ADX5_SignalMethod,  ADX_SignalLevel, ADX5_OpenCondition1,  ADX5_OpenCondition2,  ADX5_CloseCondition,  ADX5_MaxSpread);
  init &= InitStrategy(ADX15, "ADX M15", ADX15_Active, ADX, PERIOD_M15, ADX15_SignalMethod, ADX_SignalLevel, ADX15_OpenCondition1, ADX15_OpenCondition2, ADX15_CloseCondition, ADX15_MaxSpread);
  init &= InitStrategy(ADX30, "ADX M30", ADX30_Active, ADX, PERIOD_M30, ADX30_SignalMethod, ADX_SignalLevel, ADX30_OpenCondition1, ADX30_OpenCondition2, ADX30_CloseCondition, ADX30_MaxSpread);
  #else
  init &= InitStrategy(ADX1,  "ADX M1",  ADX1_Active,  ADX, PERIOD_M1,  ADX1_SignalMethod,  ADX_SignalLevel);
  init &= InitStrategy(ADX5,  "ADX M5",  ADX5_Active,  ADX, PERIOD_M5,  ADX5_SignalMethod,  ADX_SignalLevel);
  init &= InitStrategy(ADX15, "ADX M15", ADX15_Active, ADX, PERIOD_M15, ADX15_SignalMethod, ADX_SignalLevel);
  init &= InitStrategy(ADX30, "ADX M30", ADX30_Active, ADX, PERIOD_M30, ADX30_SignalMethod, ADX_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(ALLIGATOR1,  "Alligator M1",  Alligator1_Active,  ALLIGATOR, PERIOD_M1,  Alligator1_SignalMethod,  Alligator_SignalLevel, Alligator1_OpenCondition1,  Alligator1_OpenCondition2,  Alligator1_CloseCondition,  Alligator1_MaxSpread);
  init &= InitStrategy(ALLIGATOR5,  "Alligator M5",  Alligator5_Active,  ALLIGATOR, PERIOD_M5,  Alligator5_SignalMethod,  Alligator_SignalLevel, Alligator5_OpenCondition1,  Alligator5_OpenCondition2,  Alligator5_CloseCondition,  Alligator5_MaxSpread);
  init &= InitStrategy(ALLIGATOR15, "Alligator M15", Alligator15_Active, ALLIGATOR, PERIOD_M15, Alligator15_SignalMethod, Alligator_SignalLevel, Alligator15_OpenCondition1, Alligator15_OpenCondition2, Alligator15_CloseCondition, Alligator15_MaxSpread);
  init &= InitStrategy(ALLIGATOR30, "Alligator M30", Alligator30_Active, ALLIGATOR, PERIOD_M30, Alligator30_SignalMethod, Alligator_SignalLevel, Alligator30_OpenCondition1, Alligator30_OpenCondition2, Alligator30_CloseCondition, Alligator30_MaxSpread);
  #else
  init &= InitStrategy(ALLIGATOR1,  "Alligator M1",  Alligator1_Active,  ALLIGATOR, PERIOD_M1,  Alligator1_SignalMethod,  Alligator_SignalLevel);
  init &= InitStrategy(ALLIGATOR5,  "Alligator M5",  Alligator5_Active,  ALLIGATOR, PERIOD_M5,  Alligator5_SignalMethod,  Alligator_SignalLevel);
  init &= InitStrategy(ALLIGATOR15, "Alligator M15", Alligator15_Active, ALLIGATOR, PERIOD_M15, Alligator15_SignalMethod, Alligator_SignalLevel);
  init &= InitStrategy(ALLIGATOR30, "Alligator M30", Alligator30_Active, ALLIGATOR, PERIOD_M30, Alligator30_SignalMethod, Alligator_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(ATR1,  "ATR M1",  ATR1_Active,  ATR, PERIOD_M1,  ATR1_SignalMethod,  ATR_SignalLevel, ATR1_OpenCondition1,  ATR1_OpenCondition2,  ATR1_CloseCondition,  ATR1_MaxSpread);
  init &= InitStrategy(ATR5,  "ATR M5",  ATR5_Active,  ATR, PERIOD_M5,  ATR5_SignalMethod,  ATR_SignalLevel, ATR5_OpenCondition1,  ATR5_OpenCondition2,  ATR5_CloseCondition,  ATR5_MaxSpread);
  init &= InitStrategy(ATR15, "ATR M15", ATR15_Active, ATR, PERIOD_M15, ATR15_SignalMethod, ATR_SignalLevel, ATR15_OpenCondition1, ATR15_OpenCondition2, ATR15_CloseCondition, ATR15_MaxSpread);
  init &= InitStrategy(ATR30, "ATR M30", ATR30_Active, ATR, PERIOD_M30, ATR30_SignalMethod, ATR_SignalLevel, ATR30_OpenCondition1, ATR30_OpenCondition2, ATR30_CloseCondition, ATR30_MaxSpread);
  #else
  init &= InitStrategy(ATR1,  "ATR M1",  ATR1_Active,  ATR, PERIOD_M1,  ATR1_SignalMethod,  ATR_SignalLevel);
  init &= InitStrategy(ATR5,  "ATR M5",  ATR5_Active,  ATR, PERIOD_M5,  ATR5_SignalMethod,  ATR_SignalLevel);
  init &= InitStrategy(ATR15, "ATR M15", ATR15_Active, ATR, PERIOD_M15, ATR15_SignalMethod, ATR_SignalLevel);
  init &= InitStrategy(ATR30, "ATR M30", ATR30_Active, ATR, PERIOD_M30, ATR30_SignalMethod, ATR_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(AWESOME1,  "Awesome M1",  Awesome1_Active,  AWESOME, PERIOD_M1,  Awesome1_SignalMethod,  Awesome_SignalLevel, Awesome1_OpenCondition1,  Awesome1_OpenCondition2,  Awesome1_CloseCondition,  Awesome1_MaxSpread);
  init &= InitStrategy(AWESOME5,  "Awesome M5",  Awesome5_Active,  AWESOME, PERIOD_M5,  Awesome5_SignalMethod,  Awesome_SignalLevel, Awesome5_OpenCondition1,  Awesome5_OpenCondition2,  Awesome5_CloseCondition,  Awesome5_MaxSpread);
  init &= InitStrategy(AWESOME15, "Awesome M15", Awesome15_Active, AWESOME, PERIOD_M15, Awesome15_SignalMethod, Awesome_SignalLevel, Awesome15_OpenCondition1, Awesome15_OpenCondition2, Awesome15_CloseCondition, Awesome15_MaxSpread);
  init &= InitStrategy(AWESOME30, "Awesome M30", Awesome30_Active, AWESOME, PERIOD_M30, Awesome30_SignalMethod, Awesome_SignalLevel, Awesome30_OpenCondition1, Awesome30_OpenCondition2, Awesome30_CloseCondition, Awesome30_MaxSpread);
  #else
  init &= InitStrategy(AWESOME1,  "Awesome M1",  Awesome1_Active,  AWESOME, PERIOD_M1,  Awesome1_SignalMethod,  Awesome_SignalLevel);
  init &= InitStrategy(AWESOME5,  "Awesome M5",  Awesome5_Active,  AWESOME, PERIOD_M5,  Awesome5_SignalMethod,  Awesome_SignalLevel);
  init &= InitStrategy(AWESOME15, "Awesome M15", Awesome15_Active, AWESOME, PERIOD_M15, Awesome15_SignalMethod, Awesome_SignalLevel);
  init &= InitStrategy(AWESOME30, "Awesome M30", Awesome30_Active, AWESOME, PERIOD_M30, Awesome30_SignalMethod, Awesome_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(BANDS1,  "Bands M1",  Bands1_Active,  BANDS, PERIOD_M1,  Bands1_SignalMethod,  Bands_SignalLevel, Bands1_OpenCondition1,  Bands1_OpenCondition2,  Bands1_CloseCondition,  Bands1_MaxSpread);
  init &= InitStrategy(BANDS5,  "Bands M5",  Bands5_Active,  BANDS, PERIOD_M5,  Bands5_SignalMethod,  Bands_SignalLevel, Bands5_OpenCondition1,  Bands5_OpenCondition2,  Bands5_CloseCondition,  Bands5_MaxSpread);
  init &= InitStrategy(BANDS15, "Bands M15", Bands15_Active, BANDS, PERIOD_M15, Bands15_SignalMethod, Bands_SignalLevel, Bands15_OpenCondition1, Bands15_OpenCondition2, Bands15_CloseCondition, Bands15_MaxSpread);
  init &= InitStrategy(BANDS30, "Bands M30", Bands30_Active, BANDS, PERIOD_M30, Bands30_SignalMethod, Bands_SignalLevel, Bands30_OpenCondition1, Bands30_OpenCondition2, Bands30_CloseCondition, Bands30_MaxSpread);
  #else
  init &= InitStrategy(BANDS1,  "Bands M1",  Bands1_Active,  BANDS, PERIOD_M1,  Bands1_SignalMethod,  Bands_SignalLevel);
  init &= InitStrategy(BANDS5,  "Bands M5",  Bands5_Active,  BANDS, PERIOD_M5,  Bands5_SignalMethod,  Bands_SignalLevel);
  init &= InitStrategy(BANDS15, "Bands M15", Bands15_Active, BANDS, PERIOD_M15, Bands15_SignalMethod, Bands_SignalLevel);
  init &= InitStrategy(BANDS30, "Bands M30", Bands30_Active, BANDS, PERIOD_M30, Bands30_SignalMethod, Bands_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(BPOWER1,  "BPower M1",  BPower1_Active,  BPOWER, PERIOD_M1,  BPower1_SignalMethod,  BPower_SignalLevel, BPower1_OpenCondition1,  BPower1_OpenCondition2,  BPower1_CloseCondition,  BPower1_MaxSpread);
  init &= InitStrategy(BPOWER5,  "BPower M5",  BPower5_Active,  BPOWER, PERIOD_M5,  BPower5_SignalMethod,  BPower_SignalLevel, BPower5_OpenCondition1,  BPower5_OpenCondition2,  BPower5_CloseCondition,  BPower5_MaxSpread);
  init &= InitStrategy(BPOWER15, "BPower M15", BPower15_Active, BPOWER, PERIOD_M15, BPower15_SignalMethod, BPower_SignalLevel, BPower15_OpenCondition1, BPower15_OpenCondition2, BPower15_CloseCondition, BPower15_MaxSpread);
  init &= InitStrategy(BPOWER30, "BPower M30", BPower30_Active, BPOWER, PERIOD_M30, BPower30_SignalMethod, BPower_SignalLevel, BPower30_OpenCondition1, BPower30_OpenCondition2, BPower30_CloseCondition, BPower30_MaxSpread);
  #else
  init &= InitStrategy(BPOWER1,  "BPower M1",  BPower1_Active,  BPOWER, PERIOD_M1,  BPower1_SignalMethod,  BPower_SignalLevel);
  init &= InitStrategy(BPOWER5,  "BPower M5",  BPower5_Active,  BPOWER, PERIOD_M5,  BPower5_SignalMethod,  BPower_SignalLevel);
  init &= InitStrategy(BPOWER15, "BPower M15", BPower15_Active, BPOWER, PERIOD_M15, BPower15_SignalMethod, BPower_SignalLevel);
  init &= InitStrategy(BPOWER30, "BPower M30", BPower30_Active, BPOWER, PERIOD_M30, BPower30_SignalMethod, BPower_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(BREAKAGE1,  "Breakage M1",  Breakage1_Active,  EMPTY, PERIOD_M1,  Breakage1_SignalMethod,  Breakage_SignalLevel, Breakage1_OpenCondition1,  Breakage1_OpenCondition2,  Breakage1_CloseCondition,  Breakage1_MaxSpread);
  init &= InitStrategy(BREAKAGE5,  "Breakage M5",  Breakage5_Active,  EMPTY, PERIOD_M5,  Breakage5_SignalMethod,  Breakage_SignalLevel, Breakage5_OpenCondition1,  Breakage5_OpenCondition2,  Breakage5_CloseCondition,  Breakage5_MaxSpread);
  init &= InitStrategy(BREAKAGE15, "Breakage M15", Breakage15_Active, EMPTY, PERIOD_M15, Breakage15_SignalMethod, Breakage_SignalLevel, Breakage15_OpenCondition1, Breakage15_OpenCondition2, Breakage15_CloseCondition, Breakage15_MaxSpread);
  init &= InitStrategy(BREAKAGE30, "Breakage M30", Breakage30_Active, EMPTY, PERIOD_M30, Breakage30_SignalMethod, Breakage_SignalLevel, Breakage30_OpenCondition1, Breakage30_OpenCondition2, Breakage30_CloseCondition, Breakage30_MaxSpread);
  #else
  init &= InitStrategy(BREAKAGE1,  "Breakage M1",  Breakage1_Active,  EMPTY, PERIOD_M1,  Breakage1_SignalMethod,  Breakage_SignalLevel);
  init &= InitStrategy(BREAKAGE5,  "Breakage M5",  Breakage5_Active,  EMPTY, PERIOD_M5,  Breakage5_SignalMethod,  Breakage_SignalLevel);
  init &= InitStrategy(BREAKAGE15, "Breakage M15", Breakage15_Active, EMPTY, PERIOD_M15, Breakage15_SignalMethod, Breakage_SignalLevel);
  init &= InitStrategy(BREAKAGE30, "Breakage M30", Breakage30_Active, EMPTY, PERIOD_M30, Breakage30_SignalMethod, Breakage_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(BWMFI1,  "BWMFI M1",  BWMFI1_Active,  EMPTY, PERIOD_M1,  BWMFI1_SignalMethod,  BWMFI_SignalLevel, BWMFI1_OpenCondition1,  BWMFI1_OpenCondition2,  BWMFI1_CloseCondition,  BWMFI1_MaxSpread);
  init &= InitStrategy(BWMFI5,  "BWMFI M5",  BWMFI5_Active,  EMPTY, PERIOD_M5,  BWMFI5_SignalMethod,  BWMFI_SignalLevel, BWMFI5_OpenCondition1,  BWMFI5_OpenCondition2,  BWMFI5_CloseCondition,  BWMFI5_MaxSpread);
  init &= InitStrategy(BWMFI15, "BWMFI M15", BWMFI15_Active, EMPTY, PERIOD_M15, BWMFI15_SignalMethod, BWMFI_SignalLevel, BWMFI15_OpenCondition1, BWMFI15_OpenCondition2, BWMFI15_CloseCondition, BWMFI15_MaxSpread);
  init &= InitStrategy(BWMFI30, "BWMFI M30", BWMFI30_Active, EMPTY, PERIOD_M30, BWMFI30_SignalMethod, BWMFI_SignalLevel, BWMFI30_OpenCondition1, BWMFI30_OpenCondition2, BWMFI30_CloseCondition, BWMFI30_MaxSpread);
  #else
  init &= InitStrategy(BWMFI1,  "BWMFI M1",  BWMFI1_Active,  EMPTY, PERIOD_M1,  BWMFI1_SignalMethod,  BWMFI_SignalLevel);
  init &= InitStrategy(BWMFI5,  "BWMFI M5",  BWMFI5_Active,  EMPTY, PERIOD_M5,  BWMFI5_SignalMethod,  BWMFI_SignalLevel);
  init &= InitStrategy(BWMFI15, "BWMFI M15", BWMFI15_Active, EMPTY, PERIOD_M15, BWMFI15_SignalMethod, BWMFI_SignalLevel);
  init &= InitStrategy(BWMFI30, "BWMFI M30", BWMFI30_Active, EMPTY, PERIOD_M30, BWMFI30_SignalMethod, BWMFI_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(CCI1,  "CCI M1",  CCI1_Active,  CCI, PERIOD_M1,  CCI1_SignalMethod,  CCI_SignalLevel, CCI1_OpenCondition1,  CCI1_OpenCondition2,  CCI1_CloseCondition,  CCI1_MaxSpread);
  init &= InitStrategy(CCI5,  "CCI M5",  CCI5_Active,  CCI, PERIOD_M5,  CCI5_SignalMethod,  CCI_SignalLevel, CCI5_OpenCondition1,  CCI5_OpenCondition2,  CCI5_CloseCondition,  CCI5_MaxSpread);
  init &= InitStrategy(CCI15, "CCI M15", CCI15_Active, CCI, PERIOD_M15, CCI15_SignalMethod, CCI_SignalLevel, CCI15_OpenCondition1, CCI15_OpenCondition2, CCI15_CloseCondition, CCI15_MaxSpread);
  init &= InitStrategy(CCI30, "CCI M30", CCI30_Active, CCI, PERIOD_M30, CCI30_SignalMethod, CCI_SignalLevel, CCI30_OpenCondition1, CCI30_OpenCondition2, CCI30_CloseCondition, CCI30_MaxSpread);
  #else
  init &= InitStrategy(CCI1,  "CCI M1",  CCI1_Active,  CCI, PERIOD_M1,  CCI1_SignalMethod,  CCI_SignalLevel);
  init &= InitStrategy(CCI5,  "CCI M5",  CCI5_Active,  CCI, PERIOD_M5,  CCI5_SignalMethod,  CCI_SignalLevel);
  init &= InitStrategy(CCI15, "CCI M15", CCI15_Active, CCI, PERIOD_M15, CCI15_SignalMethod, CCI_SignalLevel);
  init &= InitStrategy(CCI30, "CCI M30", CCI30_Active, CCI, PERIOD_M30, CCI30_SignalMethod, CCI_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(DEMARKER1,  "DeMarker M1",  DeMarker1_Active,  DEMARKER, PERIOD_M1,  DeMarker1_SignalMethod,  DeMarker_SignalLevel, DeMarker1_OpenCondition1,  DeMarker1_OpenCondition2,  DeMarker1_CloseCondition,  DeMarker1_MaxSpread);
  init &= InitStrategy(DEMARKER5,  "DeMarker M5",  DeMarker5_Active,  DEMARKER, PERIOD_M5,  DeMarker5_SignalMethod,  DeMarker_SignalLevel, DeMarker5_OpenCondition1,  DeMarker5_OpenCondition2,  DeMarker5_CloseCondition,  DeMarker5_MaxSpread);
  init &= InitStrategy(DEMARKER15, "DeMarker M15", DeMarker15_Active, DEMARKER, PERIOD_M15, DeMarker15_SignalMethod, DeMarker_SignalLevel, DeMarker15_OpenCondition1, DeMarker15_OpenCondition2, DeMarker15_CloseCondition, DeMarker15_MaxSpread);
  init &= InitStrategy(DEMARKER30, "DeMarker M30", DeMarker30_Active, DEMARKER, PERIOD_M30, DeMarker30_SignalMethod, DeMarker_SignalLevel, DeMarker30_OpenCondition1, DeMarker30_OpenCondition2, DeMarker30_CloseCondition, DeMarker30_MaxSpread);
  #else
  init &= InitStrategy(DEMARKER1,  "DeMarker M1",  DeMarker1_Active,  DEMARKER, PERIOD_M1,  DeMarker1_SignalMethod,  DeMarker_SignalLevel);
  init &= InitStrategy(DEMARKER5,  "DeMarker M5",  DeMarker5_Active,  DEMARKER, PERIOD_M5,  DeMarker5_SignalMethod,  DeMarker_SignalLevel);
  init &= InitStrategy(DEMARKER15, "DeMarker M15", DeMarker15_Active, DEMARKER, PERIOD_M15, DeMarker15_SignalMethod, DeMarker_SignalLevel);
  init &= InitStrategy(DEMARKER30, "DeMarker M30", DeMarker30_Active, DEMARKER, PERIOD_M30, DeMarker30_SignalMethod, DeMarker_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(ENVELOPES1,  "Envelopes M1",  Envelopes1_Active,  ENVELOPES, PERIOD_M1,  Envelopes1_SignalMethod,  Envelopes_SignalLevel, Envelopes1_OpenCondition1,  Envelopes1_OpenCondition2,  Envelopes1_CloseCondition,  Envelopes1_MaxSpread);
  init &= InitStrategy(ENVELOPES5,  "Envelopes M5",  Envelopes5_Active,  ENVELOPES, PERIOD_M5,  Envelopes5_SignalMethod,  Envelopes_SignalLevel, Envelopes5_OpenCondition1,  Envelopes5_OpenCondition2,  Envelopes5_CloseCondition,  Envelopes5_MaxSpread);
  init &= InitStrategy(ENVELOPES15, "Envelopes M15", Envelopes15_Active, ENVELOPES, PERIOD_M15, Envelopes15_SignalMethod, Envelopes_SignalLevel, Envelopes15_OpenCondition1, Envelopes15_OpenCondition2, Envelopes15_CloseCondition, Envelopes15_MaxSpread);
  init &= InitStrategy(ENVELOPES30, "Envelopes M30", Envelopes30_Active, ENVELOPES, PERIOD_M30, Envelopes30_SignalMethod, Envelopes_SignalLevel, Envelopes30_OpenCondition1, Envelopes30_OpenCondition2, Envelopes30_CloseCondition, Envelopes30_MaxSpread);
  #else
  init &= InitStrategy(ENVELOPES1,  "Envelopes M1",  Envelopes1_Active,  ENVELOPES, PERIOD_M1,  Envelopes1_SignalMethod,  Envelopes_SignalLevel);
  init &= InitStrategy(ENVELOPES5,  "Envelopes M5",  Envelopes5_Active,  ENVELOPES, PERIOD_M5,  Envelopes5_SignalMethod,  Envelopes_SignalLevel);
  init &= InitStrategy(ENVELOPES15, "Envelopes M15", Envelopes15_Active, ENVELOPES, PERIOD_M15, Envelopes15_SignalMethod, Envelopes_SignalLevel);
  init &= InitStrategy(ENVELOPES30, "Envelopes M30", Envelopes30_Active, ENVELOPES, PERIOD_M30, Envelopes30_SignalMethod, Envelopes_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(FORCE1,  "Force M1",  Force1_Active,  FORCE, PERIOD_M1,  Force1_SignalMethod,  Force_SignalLevel, Force1_OpenCondition1,  Force1_OpenCondition2,  Force1_CloseCondition,  Force1_MaxSpread);
  init &= InitStrategy(FORCE5,  "Force M5",  Force5_Active,  FORCE, PERIOD_M5,  Force5_SignalMethod,  Force_SignalLevel, Force5_OpenCondition1,  Force5_OpenCondition2,  Force5_CloseCondition,  Force5_MaxSpread);
  init &= InitStrategy(FORCE15, "Force M15", Force15_Active, FORCE, PERIOD_M15, Force15_SignalMethod, Force_SignalLevel, Force15_OpenCondition1, Force15_OpenCondition2, Force15_CloseCondition, Force15_MaxSpread);
  init &= InitStrategy(FORCE30, "Force M30", Force30_Active, FORCE, PERIOD_M30, Force30_SignalMethod, Force_SignalLevel, Force30_OpenCondition1, Force30_OpenCondition2, Force30_CloseCondition, Force30_MaxSpread);
  #else
  init &= InitStrategy(FORCE1,  "Force M1",  Force1_Active,  FORCE, PERIOD_M1,  Force1_SignalMethod,  Force_SignalLevel);
  init &= InitStrategy(FORCE5,  "Force M5",  Force5_Active,  FORCE, PERIOD_M5,  Force5_SignalMethod,  Force_SignalLevel);
  init &= InitStrategy(FORCE15, "Force M15", Force15_Active, FORCE, PERIOD_M15, Force15_SignalMethod, Force_SignalLevel);
  init &= InitStrategy(FORCE30, "Force M30", Force30_Active, FORCE, PERIOD_M30, Force30_SignalMethod, Force_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(FRACTALS1,  "Fractals M1",  Fractals1_Active,  FRACTALS, PERIOD_M1,  Fractals1_SignalMethod,  Fractals_SignalLevel, Fractals1_OpenCondition1,  Fractals1_OpenCondition2,  Fractals1_CloseCondition,  Fractals1_MaxSpread);
  init &= InitStrategy(FRACTALS5,  "Fractals M5",  Fractals5_Active,  FRACTALS, PERIOD_M5,  Fractals5_SignalMethod,  Fractals_SignalLevel, Fractals5_OpenCondition1,  Fractals5_OpenCondition2,  Fractals5_CloseCondition,  Fractals5_MaxSpread);
  init &= InitStrategy(FRACTALS15, "Fractals M15", Fractals15_Active, FRACTALS, PERIOD_M15, Fractals15_SignalMethod, Fractals_SignalLevel, Fractals15_OpenCondition1, Fractals15_OpenCondition2, Fractals15_CloseCondition, Fractals15_MaxSpread);
  init &= InitStrategy(FRACTALS30, "Fractals M30", Fractals30_Active, FRACTALS, PERIOD_M30, Fractals30_SignalMethod, Fractals_SignalLevel, Fractals30_OpenCondition1, Fractals30_OpenCondition2, Fractals30_CloseCondition, Fractals30_MaxSpread);
  #else
  init &= InitStrategy(FRACTALS1,  "Fractals M1",  Fractals1_Active,  FRACTALS, PERIOD_M1,  Fractals1_SignalMethod,  Fractals_SignalLevel);
  init &= InitStrategy(FRACTALS5,  "Fractals M5",  Fractals5_Active,  FRACTALS, PERIOD_M5,  Fractals5_SignalMethod,  Fractals_SignalLevel);
  init &= InitStrategy(FRACTALS15, "Fractals M15", Fractals15_Active, FRACTALS, PERIOD_M15, Fractals15_SignalMethod, Fractals_SignalLevel);
  init &= InitStrategy(FRACTALS30, "Fractals M30", Fractals30_Active, FRACTALS, PERIOD_M30, Fractals30_SignalMethod, Fractals_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(GATOR1,  "Gator M1",  Gator1_Active,  GATOR, PERIOD_M1,  Gator1_SignalMethod,  Gator_SignalLevel, Gator1_OpenCondition1,  Gator1_OpenCondition2,  Gator1_CloseCondition,  Gator1_MaxSpread);
  init &= InitStrategy(GATOR5,  "Gator M5",  Gator5_Active,  GATOR, PERIOD_M5,  Gator5_SignalMethod,  Gator_SignalLevel, Gator5_OpenCondition1,  Gator5_OpenCondition2,  Gator5_CloseCondition,  Gator5_MaxSpread);
  init &= InitStrategy(GATOR15, "Gator M15", Gator15_Active, GATOR, PERIOD_M15, Gator15_SignalMethod, Gator_SignalLevel, Gator15_OpenCondition1, Gator15_OpenCondition2, Gator15_CloseCondition, Gator15_MaxSpread);
  init &= InitStrategy(GATOR30, "Gator M30", Gator30_Active, GATOR, PERIOD_M30, Gator30_SignalMethod, Gator_SignalLevel, Gator30_OpenCondition1, Gator30_OpenCondition2, Gator30_CloseCondition, Gator30_MaxSpread);
  #else
  init &= InitStrategy(GATOR1,  "Gator M1",  Gator1_Active,  GATOR, PERIOD_M1,  Gator1_SignalMethod,  Gator_SignalLevel);
  init &= InitStrategy(GATOR5,  "Gator M5",  Gator5_Active,  GATOR, PERIOD_M5,  Gator5_SignalMethod,  Gator_SignalLevel);
  init &= InitStrategy(GATOR15, "Gator M15", Gator15_Active, GATOR, PERIOD_M15, Gator15_SignalMethod, Gator_SignalLevel);
  init &= InitStrategy(GATOR30, "Gator M30", Gator30_Active, GATOR, PERIOD_M30, Gator30_SignalMethod, Gator_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(ICHIMOKU1,  "Ichimoku M1",  Ichimoku1_Active,  ICHIMOKU, PERIOD_M1,  Ichimoku1_SignalMethod,  Ichimoku_SignalLevel, Ichimoku1_OpenCondition1,  Ichimoku1_OpenCondition2,  Ichimoku1_CloseCondition,  Ichimoku1_MaxSpread);
  init &= InitStrategy(ICHIMOKU5,  "Ichimoku M5",  Ichimoku5_Active,  ICHIMOKU, PERIOD_M5,  Ichimoku5_SignalMethod,  Ichimoku_SignalLevel, Ichimoku5_OpenCondition1,  Ichimoku5_OpenCondition2,  Ichimoku5_CloseCondition,  Ichimoku5_MaxSpread);
  init &= InitStrategy(ICHIMOKU15, "Ichimoku M15", Ichimoku15_Active, ICHIMOKU, PERIOD_M15, Ichimoku15_SignalMethod, Ichimoku_SignalLevel, Ichimoku15_OpenCondition1, Ichimoku15_OpenCondition2, Ichimoku15_CloseCondition, Ichimoku15_MaxSpread);
  init &= InitStrategy(ICHIMOKU30, "Ichimoku M30", Ichimoku30_Active, ICHIMOKU, PERIOD_M30, Ichimoku30_SignalMethod, Ichimoku_SignalLevel, Ichimoku30_OpenCondition1, Ichimoku30_OpenCondition2, Ichimoku30_CloseCondition, Ichimoku30_MaxSpread);
  #else
  init &= InitStrategy(ICHIMOKU1,  "Ichimoku M1",  Ichimoku1_Active,  ICHIMOKU, PERIOD_M1,  Ichimoku1_SignalMethod,  Ichimoku_SignalLevel);
  init &= InitStrategy(ICHIMOKU5,  "Ichimoku M5",  Ichimoku5_Active,  ICHIMOKU, PERIOD_M5,  Ichimoku5_SignalMethod,  Ichimoku_SignalLevel);
  init &= InitStrategy(ICHIMOKU15, "Ichimoku M15", Ichimoku15_Active, ICHIMOKU, PERIOD_M15, Ichimoku15_SignalMethod, Ichimoku_SignalLevel);
  init &= InitStrategy(ICHIMOKU30, "Ichimoku M30", Ichimoku30_Active, ICHIMOKU, PERIOD_M30, Ichimoku30_SignalMethod, Ichimoku_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(MA1,  "MA M1",  MA1_Active,  MA, PERIOD_M1,  MA1_SignalMethod,  MA_SignalLevel,  MA1_OpenCondition1, MA1_OpenCondition2,  MA1_CloseCondition,  MA1_MaxSpread);
  init &= InitStrategy(MA5,  "MA M5",  MA5_Active,  MA, PERIOD_M5,  MA5_SignalMethod,  MA_SignalLevel,  MA5_OpenCondition1, MA5_OpenCondition2,  MA5_CloseCondition,  MA5_MaxSpread);
  init &= InitStrategy(MA15, "MA M15", MA15_Active, MA, PERIOD_M15, MA15_SignalMethod, MA_SignalLevel, MA15_OpenCondition1, MA15_OpenCondition2, MA15_CloseCondition, MA15_MaxSpread);
  init &= InitStrategy(MA30, "MA M30", MA30_Active, MA, PERIOD_M30, MA30_SignalMethod, MA_SignalLevel, MA30_OpenCondition1, MA30_OpenCondition2, MA30_CloseCondition, MA30_MaxSpread);
  #else
  init &= InitStrategy(MA1,  "MA M1",  MA1_Active,  MA, PERIOD_M1,  MA1_SignalMethod,  MA_SignalLevel);
  init &= InitStrategy(MA5,  "MA M5",  MA5_Active,  MA, PERIOD_M5,  MA5_SignalMethod,  MA_SignalLevel);
  init &= InitStrategy(MA15, "MA M15", MA15_Active, MA, PERIOD_M15, MA15_SignalMethod, MA_SignalLevel);
  init &= InitStrategy(MA30, "MA M30", MA30_Active, MA, PERIOD_M30, MA30_SignalMethod, MA_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(MACD1,  "MACD M1",  MACD1_Active,  MACD, PERIOD_M1,  MACD1_SignalMethod,  MACD_SignalLevel, MACD1_OpenCondition1,  MACD1_OpenCondition2,  MACD1_CloseCondition,  MACD1_MaxSpread);
  init &= InitStrategy(MACD5,  "MACD M5",  MACD5_Active,  MACD, PERIOD_M5,  MACD5_SignalMethod,  MACD_SignalLevel, MACD5_OpenCondition1,  MACD5_OpenCondition2,  MACD5_CloseCondition,  MACD5_MaxSpread);
  init &= InitStrategy(MACD15, "MACD M15", MACD15_Active, MACD, PERIOD_M15, MACD15_SignalMethod, MACD_SignalLevel, MACD15_OpenCondition1, MACD15_OpenCondition2, MACD15_CloseCondition, MACD15_MaxSpread);
  init &= InitStrategy(MACD30, "MACD M30", MACD30_Active, MACD, PERIOD_M30, MACD30_SignalMethod, MACD_SignalLevel, MACD30_OpenCondition1, MACD30_OpenCondition2, MACD30_CloseCondition, MACD30_MaxSpread);
  #else
  init &= InitStrategy(MACD1,  "MACD M1",  MACD1_Active,  MACD, PERIOD_M1,  MACD1_SignalMethod,  MACD_SignalLevel);
  init &= InitStrategy(MACD5,  "MACD M5",  MACD5_Active,  MACD, PERIOD_M5,  MACD5_SignalMethod,  MACD_SignalLevel);
  init &= InitStrategy(MACD15, "MACD M15", MACD15_Active, MACD, PERIOD_M15, MACD15_SignalMethod, MACD_SignalLevel);
  init &= InitStrategy(MACD30, "MACD M30", MACD30_Active, MACD, PERIOD_M30, MACD30_SignalMethod, MACD_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(MFI1,  "MFI M1",  MFI1_Active,  MFI, PERIOD_M1,  MFI1_SignalMethod,  MFI_SignalLevel, MFI1_OpenCondition1,  MFI1_OpenCondition2,  MFI1_CloseCondition,  MFI1_MaxSpread);
  init &= InitStrategy(MFI5,  "MFI M5",  MFI5_Active,  MFI, PERIOD_M5,  MFI5_SignalMethod,  MFI_SignalLevel, MFI5_OpenCondition1,  MFI5_OpenCondition2,  MFI5_CloseCondition,  MFI5_MaxSpread);
  init &= InitStrategy(MFI15, "MFI M15", MFI15_Active, MFI, PERIOD_M15, MFI15_SignalMethod, MFI_SignalLevel, MFI15_OpenCondition1, MFI15_OpenCondition2, MFI15_CloseCondition, MFI15_MaxSpread);
  init &= InitStrategy(MFI30, "MFI M30", MFI30_Active, MFI, PERIOD_M30, MFI30_SignalMethod, MFI_SignalLevel, MFI30_OpenCondition1, MFI30_OpenCondition2, MFI30_CloseCondition, MFI30_MaxSpread);
  #else
  init &= InitStrategy(MFI1,  "MFI M1",  MFI1_Active,  MFI, PERIOD_M1,  MFI1_SignalMethod,  MFI_SignalLevel);
  init &= InitStrategy(MFI5,  "MFI M5",  MFI5_Active,  MFI, PERIOD_M5,  MFI5_SignalMethod,  MFI_SignalLevel);
  init &= InitStrategy(MFI15, "MFI M15", MFI15_Active, MFI, PERIOD_M15, MFI15_SignalMethod, MFI_SignalLevel);
  init &= InitStrategy(MFI30, "MFI M30", MFI30_Active, MFI, PERIOD_M30, MFI30_SignalMethod, MFI_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(MOMENTUM1,  "Momentum M1",  Momentum1_Active,  MOMENTUM, PERIOD_M1,  Momentum1_SignalMethod,  Momentum_SignalLevel, Momentum1_OpenCondition1,  Momentum1_OpenCondition2,  Momentum1_CloseCondition,  Momentum1_MaxSpread);
  init &= InitStrategy(MOMENTUM5,  "Momentum M5",  Momentum5_Active,  MOMENTUM, PERIOD_M5,  Momentum5_SignalMethod,  Momentum_SignalLevel, Momentum5_OpenCondition1,  Momentum5_OpenCondition2,  Momentum5_CloseCondition,  Momentum5_MaxSpread);
  init &= InitStrategy(MOMENTUM15, "Momentum M15", Momentum15_Active, MOMENTUM, PERIOD_M15, Momentum15_SignalMethod, Momentum_SignalLevel, Momentum15_OpenCondition1, Momentum15_OpenCondition2, Momentum15_CloseCondition, Momentum15_MaxSpread);
  init &= InitStrategy(MOMENTUM30, "Momentum M30", Momentum30_Active, MOMENTUM, PERIOD_M30, Momentum30_SignalMethod, Momentum_SignalLevel, Momentum30_OpenCondition1, Momentum30_OpenCondition2, Momentum30_CloseCondition, Momentum30_MaxSpread);
  #else
  init &= InitStrategy(MOMENTUM1,  "Momentum M1",  Momentum1_Active,  MOMENTUM, PERIOD_M1,  Momentum1_SignalMethod,  Momentum_SignalLevel);
  init &= InitStrategy(MOMENTUM5,  "Momentum M5",  Momentum5_Active,  MOMENTUM, PERIOD_M5,  Momentum5_SignalMethod,  Momentum_SignalLevel);
  init &= InitStrategy(MOMENTUM15, "Momentum M15", Momentum15_Active, MOMENTUM, PERIOD_M15, Momentum15_SignalMethod, Momentum_SignalLevel);
  init &= InitStrategy(MOMENTUM30, "Momentum M30", Momentum30_Active, MOMENTUM, PERIOD_M30, Momentum30_SignalMethod, Momentum_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(OBV1,  "OBV M1",  OBV1_Active,  OBV, PERIOD_M1,  OBV1_SignalMethod,  OBV_SignalLevel,  OBV1_OpenCondition1, OBV1_OpenCondition2,  OBV1_CloseCondition,  OBV1_MaxSpread);
  init &= InitStrategy(OBV5,  "OBV M5",  OBV5_Active,  OBV, PERIOD_M5,  OBV5_SignalMethod,  OBV_SignalLevel,  OBV5_OpenCondition1, OBV5_OpenCondition2,  OBV5_CloseCondition,  OBV5_MaxSpread);
  init &= InitStrategy(OBV15, "OBV M15", OBV15_Active, OBV, PERIOD_M15, OBV15_SignalMethod, OBV_SignalLevel, OBV15_OpenCondition1, OBV15_OpenCondition2, OBV15_CloseCondition, OBV15_MaxSpread);
  init &= InitStrategy(OBV30, "OBV M30", OBV30_Active, OBV, PERIOD_M30, OBV30_SignalMethod, OBV_SignalLevel, OBV30_OpenCondition1, OBV30_OpenCondition2, OBV30_CloseCondition, OBV30_MaxSpread);
  #else
  init &= InitStrategy(OBV1,  "OBV M1",  OBV1_Active,  OBV, PERIOD_M1,  OBV1_SignalMethod,  OBV_SignalLevel);
  init &= InitStrategy(OBV5,  "OBV M5",  OBV5_Active,  OBV, PERIOD_M5,  OBV5_SignalMethod,  OBV_SignalLevel);
  init &= InitStrategy(OBV15, "OBV M15", OBV15_Active, OBV, PERIOD_M15, OBV15_SignalMethod, OBV_SignalLevel);
  init &= InitStrategy(OBV30, "OBV M30", OBV30_Active, OBV, PERIOD_M30, OBV30_SignalMethod, OBV_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(OSMA1,  "OSMA M1",  OSMA1_Active,  OSMA, PERIOD_M1,  OSMA1_SignalMethod,  OSMA_SignalLevel, OSMA1_OpenCondition1,  OSMA1_OpenCondition2,  OSMA1_CloseCondition,  OSMA1_MaxSpread);
  init &= InitStrategy(OSMA5,  "OSMA M5",  OSMA5_Active,  OSMA, PERIOD_M5,  OSMA5_SignalMethod,  OSMA_SignalLevel, OSMA5_OpenCondition1,  OSMA5_OpenCondition2,  OSMA5_CloseCondition,  OSMA5_MaxSpread);
  init &= InitStrategy(OSMA15, "OSMA M15", OSMA15_Active, OSMA, PERIOD_M15, OSMA15_SignalMethod, OSMA_SignalLevel, OSMA15_OpenCondition1, OSMA15_OpenCondition2, OSMA15_CloseCondition, OSMA15_MaxSpread);
  init &= InitStrategy(OSMA30, "OSMA M30", OSMA30_Active, OSMA, PERIOD_M30, OSMA30_SignalMethod, OSMA_SignalLevel, OSMA30_OpenCondition1, OSMA30_OpenCondition2, OSMA30_CloseCondition, OSMA30_MaxSpread);
  #else
  init &= InitStrategy(OSMA1,  "OSMA M1",  OSMA1_Active,  OSMA, PERIOD_M1,  OSMA1_SignalMethod,  OSMA_SignalLevel);
  init &= InitStrategy(OSMA5,  "OSMA M5",  OSMA5_Active,  OSMA, PERIOD_M5,  OSMA5_SignalMethod,  OSMA_SignalLevel);
  init &= InitStrategy(OSMA15, "OSMA M15", OSMA15_Active, OSMA, PERIOD_M15, OSMA15_SignalMethod, OSMA_SignalLevel);
  init &= InitStrategy(OSMA30, "OSMA M30", OSMA30_Active, OSMA, PERIOD_M30, OSMA30_SignalMethod, OSMA_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(RSI1,  "RSI M1",  RSI1_Active,  RSI, PERIOD_M1,  RSI1_SignalMethod,  RSI_SignalLevel, RSI1_OpenCondition1,  RSI1_OpenCondition2,  RSI1_CloseCondition,  RSI1_MaxSpread);
  init &= InitStrategy(RSI5,  "RSI M5",  RSI5_Active,  RSI, PERIOD_M5,  RSI5_SignalMethod,  RSI_SignalLevel, RSI5_OpenCondition1,  RSI5_OpenCondition2,  RSI5_CloseCondition,  RSI5_MaxSpread);
  init &= InitStrategy(RSI15, "RSI M15", RSI15_Active, RSI, PERIOD_M15, RSI15_SignalMethod, RSI_SignalLevel, RSI15_OpenCondition1, RSI15_OpenCondition2, RSI15_CloseCondition, RSI15_MaxSpread);
  init &= InitStrategy(RSI30, "RSI M30", RSI30_Active, RSI, PERIOD_M30, RSI30_SignalMethod, RSI_SignalLevel, RSI30_OpenCondition1, RSI30_OpenCondition2, RSI30_CloseCondition, RSI30_MaxSpread);
  #else
  init &= InitStrategy(RSI1,  "RSI M1",  RSI1_Active,  RSI, PERIOD_M1,  RSI1_SignalMethod,  RSI_SignalLevel);
  init &= InitStrategy(RSI5,  "RSI M5",  RSI5_Active,  RSI, PERIOD_M5,  RSI5_SignalMethod,  RSI_SignalLevel);
  init &= InitStrategy(RSI15, "RSI M15", RSI15_Active, RSI, PERIOD_M15, RSI15_SignalMethod, RSI_SignalLevel);
  init &= InitStrategy(RSI30, "RSI M30", RSI30_Active, RSI, PERIOD_M30, RSI30_SignalMethod, RSI_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(RVI1,  "RVI M1",  RVI1_Active,  RVI, PERIOD_M1,  RVI1_SignalMethod,  RVI_SignalLevel, RVI1_OpenCondition1,  RVI1_OpenCondition2,  RVI1_CloseCondition,  RVI1_MaxSpread);
  init &= InitStrategy(RVI5,  "RVI M5",  RVI5_Active,  RVI, PERIOD_M5,  RVI5_SignalMethod,  RVI_SignalLevel, RVI5_OpenCondition1,  RVI5_OpenCondition2,  RVI5_CloseCondition,  RVI5_MaxSpread);
  init &= InitStrategy(RVI15, "RVI M15", RVI15_Active, RVI, PERIOD_M15, RVI15_SignalMethod, RVI_SignalLevel, RVI15_OpenCondition1, RVI15_OpenCondition2, RVI15_CloseCondition, RVI15_MaxSpread);
  init &= InitStrategy(RVI30, "RVI M30", RVI30_Active, RVI, PERIOD_M30, RVI30_SignalMethod, RVI_SignalLevel, RVI30_OpenCondition1, RVI30_OpenCondition2, RVI30_CloseCondition, RVI30_MaxSpread);
  #else
  init &= InitStrategy(RVI1,  "RVI M1",  RVI1_Active,  RVI, PERIOD_M1,  RVI1_SignalMethod,  RVI_SignalLevel);
  init &= InitStrategy(RVI5,  "RVI M5",  RVI5_Active,  RVI, PERIOD_M5,  RVI5_SignalMethod,  RVI_SignalLevel);
  init &= InitStrategy(RVI15, "RVI M15", RVI15_Active, RVI, PERIOD_M15, RVI15_SignalMethod, RVI_SignalLevel);
  init &= InitStrategy(RVI30, "RVI M30", RVI30_Active, RVI, PERIOD_M30, RVI30_SignalMethod, RVI_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(SAR1,  "SAR M1",  SAR1_Active,  SAR, PERIOD_M1,  SAR1_SignalMethod,  SAR_SignalLevel, SAR1_OpenCondition1,  SAR1_OpenCondition2,  SAR1_CloseCondition,  SAR1_MaxSpread);
  init &= InitStrategy(SAR5,  "SAR M5",  SAR5_Active,  SAR, PERIOD_M5,  SAR5_SignalMethod,  SAR_SignalLevel, SAR5_OpenCondition1,  SAR5_OpenCondition2,  SAR5_CloseCondition,  SAR5_MaxSpread);
  init &= InitStrategy(SAR15, "SAR M15", SAR15_Active, SAR, PERIOD_M15, SAR15_SignalMethod, SAR_SignalLevel, SAR15_OpenCondition1, SAR15_OpenCondition2, SAR15_CloseCondition, SAR15_MaxSpread);
  init &= InitStrategy(SAR30, "SAR M30", SAR30_Active, SAR, PERIOD_M30, SAR30_SignalMethod, SAR_SignalLevel, SAR30_OpenCondition1, SAR30_OpenCondition2, SAR30_CloseCondition, SAR30_MaxSpread);
  #else
  init &= InitStrategy(SAR1,  "SAR M1",  SAR1_Active,  SAR, PERIOD_M1,  SAR1_SignalMethod,  SAR_SignalLevel);
  init &= InitStrategy(SAR5,  "SAR M5",  SAR5_Active,  SAR, PERIOD_M5,  SAR5_SignalMethod,  SAR_SignalLevel);
  init &= InitStrategy(SAR15, "SAR M15", SAR15_Active, SAR, PERIOD_M15, SAR15_SignalMethod, SAR_SignalLevel);
  init &= InitStrategy(SAR30, "SAR M30", SAR30_Active, SAR, PERIOD_M30, SAR30_SignalMethod, SAR_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(STDDEV1,  "StdDev M1",  StdDev1_Active,  STDDEV, PERIOD_M1,  StdDev1_SignalMethod,  StdDev_SignalLevel,  StdDev1_OpenCondition1,  StdDev1_OpenCondition2,  StdDev1_CloseCondition,  StdDev1_MaxSpread);
  init &= InitStrategy(STDDEV5,  "StdDev M5",  StdDev5_Active,  STDDEV, PERIOD_M5,  StdDev5_SignalMethod,  StdDev_SignalLevel,  StdDev5_OpenCondition1,  StdDev5_OpenCondition2,  StdDev5_CloseCondition,  StdDev5_MaxSpread);
  init &= InitStrategy(STDDEV15, "StdDev M15", StdDev15_Active, STDDEV, PERIOD_M15, StdDev15_SignalMethod, StdDev_SignalLevel, StdDev15_OpenCondition1, StdDev15_OpenCondition2, StdDev15_CloseCondition, StdDev15_MaxSpread);
  init &= InitStrategy(STDDEV30, "StdDev M30", StdDev30_Active, STDDEV, PERIOD_M30, StdDev30_SignalMethod, StdDev_SignalLevel, StdDev30_OpenCondition1, StdDev30_OpenCondition2, StdDev30_CloseCondition, StdDev30_MaxSpread);
  #else
  init &= InitStrategy(STDDEV1,  "StdDev M1",  StdDev1_Active,  STDDEV, PERIOD_M1,  StdDev1_SignalMethod,  StdDev_SignalLevel);
  init &= InitStrategy(STDDEV5,  "StdDev M5",  StdDev5_Active,  STDDEV, PERIOD_M5,  StdDev5_SignalMethod,  StdDev_SignalLevel);
  init &= InitStrategy(STDDEV15, "StdDev M15", StdDev15_Active, STDDEV, PERIOD_M15, StdDev15_SignalMethod, StdDev_SignalLevel);
  init &= InitStrategy(STDDEV30, "StdDev M30", StdDev30_Active, STDDEV, PERIOD_M30, StdDev30_SignalMethod, StdDev_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(STOCHASTIC1,  "Stochastic M1",  Stochastic1_Active,  STOCHASTIC, PERIOD_M1,  Stochastic1_SignalMethod,  Stochastic_SignalLevel,  Stochastic1_OpenCondition1,  Stochastic1_OpenCondition2,  Stochastic1_CloseCondition,  Stochastic1_MaxSpread);
  init &= InitStrategy(STOCHASTIC5,  "Stochastic M5",  Stochastic5_Active,  STOCHASTIC, PERIOD_M5,  Stochastic5_SignalMethod,  Stochastic_SignalLevel,  Stochastic5_OpenCondition1,  Stochastic5_OpenCondition2,  Stochastic5_CloseCondition,  Stochastic5_MaxSpread);
  init &= InitStrategy(STOCHASTIC15, "Stochastic M15", Stochastic15_Active, STOCHASTIC, PERIOD_M15, Stochastic15_SignalMethod, Stochastic_SignalLevel, Stochastic15_OpenCondition1, Stochastic15_OpenCondition2, Stochastic15_CloseCondition, Stochastic15_MaxSpread);
  init &= InitStrategy(STOCHASTIC30, "Stochastic M30", Stochastic30_Active, STOCHASTIC, PERIOD_M30, Stochastic30_SignalMethod, Stochastic_SignalLevel, Stochastic30_OpenCondition1, Stochastic30_OpenCondition2, Stochastic30_CloseCondition, Stochastic30_MaxSpread);
  #else
  init &= InitStrategy(STOCHASTIC1,  "Stochastic M1",  Stochastic1_Active,  STOCHASTIC, PERIOD_M1,  Stochastic1_SignalMethod,  Stochastic_SignalLevel);
  init &= InitStrategy(STOCHASTIC5,  "Stochastic M5",  Stochastic5_Active,  STOCHASTIC, PERIOD_M5,  Stochastic5_SignalMethod,  Stochastic_SignalLevel);
  init &= InitStrategy(STOCHASTIC15, "Stochastic M15", Stochastic15_Active, STOCHASTIC, PERIOD_M15, Stochastic15_SignalMethod, Stochastic_SignalLevel);
  init &= InitStrategy(STOCHASTIC30, "Stochastic M30", Stochastic30_Active, STOCHASTIC, PERIOD_M30, Stochastic30_SignalMethod, Stochastic_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(WPR1,  "WPR M1",  WPR1_Active,  WPR, PERIOD_M1,  WPR1_SignalMethod,  WPR_SignalLevel, WPR1_OpenCondition1,  WPR1_OpenCondition2,  WPR1_CloseCondition,  WPR1_MaxSpread);
  init &= InitStrategy(WPR5,  "WPR M5",  WPR5_Active,  WPR, PERIOD_M5,  WPR5_SignalMethod,  WPR_SignalLevel, WPR5_OpenCondition1,  WPR5_OpenCondition2,  WPR5_CloseCondition,  WPR5_MaxSpread);
  init &= InitStrategy(WPR15, "WPR M15", WPR15_Active, WPR, PERIOD_M15, WPR15_SignalMethod, WPR_SignalLevel, WPR15_OpenCondition1, WPR15_OpenCondition2, WPR15_CloseCondition, WPR15_MaxSpread);
  init &= InitStrategy(WPR30, "WPR M30", WPR30_Active, WPR, PERIOD_M30, WPR30_SignalMethod, WPR_SignalLevel, WPR30_OpenCondition1, WPR30_OpenCondition2, WPR30_CloseCondition, WPR30_MaxSpread);
  #else
  init &= InitStrategy(WPR1,  "WPR M1",  WPR1_Active,  WPR, PERIOD_M1,  WPR1_SignalMethod,  WPR_SignalLevel);
  init &= InitStrategy(WPR5,  "WPR M5",  WPR5_Active,  WPR, PERIOD_M5,  WPR5_SignalMethod,  WPR_SignalLevel);
  init &= InitStrategy(WPR15, "WPR M15", WPR15_Active, WPR, PERIOD_M15, WPR15_SignalMethod, WPR_SignalLevel);
  init &= InitStrategy(WPR30, "WPR M30", WPR30_Active, WPR, PERIOD_M30, WPR30_SignalMethod, WPR_SignalLevel);
  #endif

  #ifdef __advanced__
  init &= InitStrategy(ZIGZAG1,  "ZigZag M1",  ZigZag1_Active,  ZIGZAG, PERIOD_M1,  ZigZag1_SignalMethod,  ZigZag_SignalLevel, ZigZag1_OpenCondition1,  ZigZag1_OpenCondition2,  ZigZag1_CloseCondition,  ZigZag1_MaxSpread);
  init &= InitStrategy(ZIGZAG5,  "ZigZag M5",  ZigZag5_Active,  ZIGZAG, PERIOD_M5,  ZigZag5_SignalMethod,  ZigZag_SignalLevel, ZigZag5_OpenCondition1,  ZigZag5_OpenCondition2,  ZigZag5_CloseCondition,  ZigZag5_MaxSpread);
  init &= InitStrategy(ZIGZAG15, "ZigZag M15", ZigZag15_Active, ZIGZAG, PERIOD_M15, ZigZag15_SignalMethod, ZigZag_SignalLevel, ZigZag15_OpenCondition1, ZigZag15_OpenCondition2, ZigZag15_CloseCondition, ZigZag15_MaxSpread);
  init &= InitStrategy(ZIGZAG30, "ZigZag M30", ZigZag30_Active, ZIGZAG, PERIOD_M30, ZigZag30_SignalMethod, ZigZag_SignalLevel, ZigZag30_OpenCondition1, ZigZag30_OpenCondition2, ZigZag30_CloseCondition, ZigZag30_MaxSpread);
  #else
  init &= InitStrategy(ZIGZAG1,  "ZigZag M1",  ZigZag1_Active,  ZIGZAG, PERIOD_M1,  ZigZag1_SignalMethod,  ZigZag_SignalLevel);
  init &= InitStrategy(ZIGZAG5,  "ZigZag M5",  ZigZag5_Active,  ZIGZAG, PERIOD_M5,  ZigZag5_SignalMethod,  ZigZag_SignalLevel);
  init &= InitStrategy(ZIGZAG15, "ZigZag M15", ZigZag15_Active, ZIGZAG, PERIOD_M15, ZigZag15_SignalMethod, ZigZag_SignalLevel);
  init &= InitStrategy(ZIGZAG30, "ZigZag M30", ZigZag30_Active, ZIGZAG, PERIOD_M30, ZigZag30_SignalMethod, ZigZag_SignalLevel);
  #endif

  if (!init && ValidateSettings) {
    ListTimeframes(True);
    Msg::ShowText("Initiation of strategies failed!", "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
    return (FALSE);
  }

  Arrays::ArrSetValueD(conf, FACTOR, 1.0);
  Arrays::ArrSetValueD(conf, LOT_SIZE, lot_size);

  return (TRUE);
}

/**
 * Check whether timeframe is valid.
 */
bool CheckTf(ENUM_TIMEFRAMES tf = PERIOD_M1, string symbol = NULL) {
  return iMA(symbol, tf, 13, 8, MODE_SMMA, PRICE_MEDIAN, 0) > 0;
}

/**
 * Initialize specific strategy.
 */
bool InitStrategy(int key, string name, bool active, int indicator, ENUM_TIMEFRAMES tf, int signal_method = 0, double signal_level = 0.0, int open_cond1 = 0, int open_cond2 = 0, int close_cond = 0, double max_spread = 0.0) {
  if (active) {
    // Validate whether the timeframe is working.
    if (!CheckTf(tf)) {
      Msg::ShowText(
        StringFormat("Cannot initialize %s strategy, because its timeframe (%d) is not active!%s", name, tf, ValidateSettings ? " Disabling..." : ""),
        "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
      if (ValidateSettings) {
        return (FALSE);
      } else {
        active = FALSE;
      }
    }
    // Validate whether indicator of the strategy is working.
    if (!UpdateIndicator(INDICATOR, tf)) {
      Msg::ShowText(
        StringFormat("Cannot initialize indicator for the %s strategy!%s", name, ValidateSettings ? " Disabling..." : ""),
        "Error", __FUNCTION__, __LINE__, VerboseErrors, PrintLogOnChart, ValidateSettings);
      if (ValidateSettings) {
        return (FALSE);
      } else {
        active = FALSE;
      }
    }
  }
  sname[key]                 = name;
  info[key][ACTIVE]          = active;
  info[key][SUSPENDED]       = FALSE;
  info[key][TIMEFRAME]       = tf;
  info[key][INDICATOR]       = indicator;
  info[key][OPEN_METHOD]     = signal_method;
  conf[key][OPEN_LEVEL]      = signal_level;
  conf[key][PROFIT_FACTOR]   = GetDefaultProfitFactor();
  #ifdef __advanced__
  info[key][OPEN_CONDITION1] = open_cond1;
  info[key][OPEN_CONDITION2] = open_cond2;
  info[key][CLOSE_CONDITION] = close_cond;
  conf[key][SPREAD_LIMIT]    = max_spread;
  #endif
  return (True);
}

/**
 * Update global variables.
 */
void UpdateVariables() {
  time_current = TimeCurrent();
  last_close_profit = EMPTY;
  total_orders = GetTotalOrders();
  curr_spread = Market::GetSpreadInPips();
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

  #ifdef __advanced__
  if (Account_Condition_To_Disable > 0 && Account_Condition_To_Disable < ArraySize(acc_conditions)) {
    acc_conditions[Account_Condition_To_Disable - 1][0] = C_ACC_NONE;
    acc_conditions[Account_Condition_To_Disable - 1][1] = C_MARKET_NONE;
    acc_conditions[Account_Condition_To_Disable - 1][2] = A_NONE;
  }
  #endif
  return TRUE;
}

/**
 * Check account condition.
 */
bool AccCondition(int condition = C_ACC_NONE) {
  switch(condition) {
    case C_ACC_TRUE:
      last_cname = "True";
      return TRUE;
    case C_EQUITY_LOWER:
      last_cname = "Equ<Bal";
      return Account::AccountEquity() < Account::AccountBalance();
    case C_EQUITY_HIGHER:
      last_cname = "Equ>Bal";
      return Account::AccountEquity() > Account::AccountBalance();
    case C_EQUITY_50PC_HIGH: // Equity 50% high
      last_cname = "Equ>50%";
      return Account::AccountEquity() > Account::AccountBalance() * 2;
    case C_EQUITY_20PC_HIGH: // Equity 20% high
      last_cname = "Equ>20%";
      return Account::AccountEquity() > Account::AccountBalance()/100 * 120;
    case C_EQUITY_10PC_HIGH: // Equity 10% high
      last_cname = "Equ>10%";
      return Account::AccountEquity() > Account::AccountBalance()/100 * 110;
    case C_EQUITY_10PC_LOW:  // Equity 10% low
      last_cname = "Equ<10%";
      return Account::AccountEquity() < Account::AccountBalance()/100 * 90;
    case C_EQUITY_20PC_LOW:  // Equity 20% low
      last_cname = "Equ<20%";
      return Account::AccountEquity() < Account::AccountBalance()/100 * 80;
    case C_EQUITY_50PC_LOW:  // Equity 50% low
      last_cname = "Equ<50%";
      return Account::AccountEquity() <= Account::AccountBalance() / 2;
    case C_MARGIN_USED_50PC: // 50% Margin Used
      last_cname = "Margin>50%";
      return Account::AccountMargin() >= Account::AccountEquity() /100 * 50;
    case C_MARGIN_USED_70PC: // 70% Margin Used
      // Note that in some accounts, Stop Out will occur in your account when equity reaches 70% of your used margin resulting in immediate closing of all positions.
      last_cname = "Margin>70%";
      return Account::AccountMargin() >= Account::AccountEquity() /100 * 70;
    case C_MARGIN_USED_80PC: // 80% Margin Used
      last_cname = "Margin>80%";
      return Account::AccountMargin() >= Account::AccountEquity() /100 * 80;
    case C_MARGIN_USED_90PC: // 90% Margin Used
      last_cname = "Margin>90%";
      return Account::AccountMargin() >= Account::AccountEquity() /100 * 90;
    case C_NO_FREE_MARGIN:
      last_cname = "NoMargin%";
      return Account::AccountFreeMargin() <= 10;
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
      return (CheckTrend() == OP_BUY  && CalculateOrdersByCmd(OP_BUY)  > CalculateOrdersByCmd(OP_SELL))
          || (CheckTrend() == OP_SELL && CalculateOrdersByCmd(OP_SELL) > CalculateOrdersByCmd(OP_BUY));
    case C_ACC_IN_NON_TREND:
      last_cname = "InNonTrend";
      return !AccCondition(C_ACC_IN_TREND);
    case C_ACC_CDAY_IN_PROFIT: // Check if current day in profit.
      last_cname = "TodayInProfit";
      return Arrays::GetArrSumKey1(hourly_profit, day_of_year, 10) > 0;
    case C_ACC_CDAY_IN_LOSS: // Check if current day in loss.
      last_cname = "TodayInLoss";
      return Arrays::GetArrSumKey1(hourly_profit, day_of_year, 10) < 0;
    case C_ACC_PDAY_IN_PROFIT: // Check if previous day in profit.
      {
        last_cname = "YesterdayInProfit";
        int yesterday1 = DateTime::TimeDayOfYear(time_current - 24*60*60);
        return Arrays::GetArrSumKey1(hourly_profit, yesterday1) > 0;
      }
    case C_ACC_PDAY_IN_LOSS: // Check if previous day in loss.
      {
        last_cname = "YesterdayInLoss";
        int yesterday2 = DateTime::TimeDayOfYear(time_current - 24*60*60);
        return Arrays::GetArrSumKey1(hourly_profit, yesterday2) < 0;
      }
    case C_ACC_MAX_ORDERS:
      return total_orders >= max_orders;
    default:
    case C_ACC_NONE:
      last_cname = "None";
      return FALSE;
  }
  return FALSE;
}

/**
 * Check market condition.
 */
bool MarketCondition(int condition = C_MARKET_NONE) {
  static int counter = 0;
  switch(condition) {
    case C_MARKET_TRUE:
      return TRUE;
    case C_MA1_FS_TREND_OPP: // MA Fast and Slow M1 are in opposite directions.
      return CheckMarketEvent(CheckTrend(TrendMethodAction), PERIOD_M1, C_MA_FAST_SLOW_OPP);
    case C_MA5_FS_TREND_OPP: // MA Fast and Slow M5 are in opposite directions.
      return CheckMarketEvent(CheckTrend(TrendMethodAction), PERIOD_M5, C_MA_FAST_SLOW_OPP);
    case C_MA15_FS_TREND_OPP:
      return CheckMarketEvent(CheckTrend(TrendMethodAction), PERIOD_M15, C_MA_FAST_SLOW_OPP);
    case C_MA30_FS_TREND_OPP:
      return CheckMarketEvent(CheckTrend(TrendMethodAction), PERIOD_M30, C_MA_FAST_SLOW_OPP);
    case C_MA1_FS_ORDERS_OPP: // MA Fast and Slow M1 are in opposite directions.
      return CheckMarketEvent(GetCmdByOrders(), PERIOD_M1, C_MA_FAST_SLOW_OPP);
    case C_MA5_FS_ORDERS_OPP: // MA Fast and Slow M5 are in opposite directions.
      return CheckMarketEvent(GetCmdByOrders(), PERIOD_M5, C_MA_FAST_SLOW_OPP);
    case C_MA15_FS_ORDERS_OPP:
      return CheckMarketEvent(GetCmdByOrders(), PERIOD_M15, C_MA_FAST_SLOW_OPP);
    case C_MA30_FS_ORDERS_OPP:
      return CheckMarketEvent(GetCmdByOrders(), PERIOD_M30, C_MA_FAST_SLOW_OPP);
    case C_DAILY_PEAK:
      return hour_of_day >= HourAfterPeak && (Ask >= iHigh(_Symbol, PERIOD_D1, CURR) || Ask <= iLow(_Symbol, PERIOD_D1, CURR));
    case C_WEEKLY_PEAK:
      return hour_of_day >= HourAfterPeak && (Ask >= iHigh(_Symbol, PERIOD_W1, CURR) || Ask <= iLow(_Symbol, PERIOD_W1, CURR));
    case C_MONTHLY_PEAK:
      return hour_of_day >= HourAfterPeak && (Ask >= iHigh(_Symbol, PERIOD_MN1, CURR) || Ask <= iLow(_Symbol, PERIOD_MN1, CURR));
    case C_MARKET_BIG_DROP:
      return last_tick_change > MarketSuddenDropSize;
    case C_MARKET_VBIG_DROP:
      return last_tick_change > MarketBigDropSize;
    case C_MARKET_AT_HOUR:
      {
        static int hour_invoked = -1;
        if (MarketSpecificHour == hour_of_day && hour_invoked <= hour_of_day) {
          // Invoke only once a day.
          hour_invoked = hour_of_day + 1;
          return (TRUE);
        } else {
          if (hour_of_day < hour_invoked) {
            // Reset hour on the next day.
            hour_invoked = -1;
          }
          return (FALSE);
        }
      }
    case C_NEW_HOUR:
      return hour_of_day != Hour();
    case C_NEW_DAY:
      return day_of_week != DayOfWeek();
    case C_NEW_WEEK:
      return DayOfWeek() < day_of_week;
    case C_NEW_MONTH:
      return Day() < day_of_month;
    case C_MARKET_NONE:
    default:
      return FALSE;
  }
  return FALSE;
}

// Check our account if certain conditions are met.
void CheckAccConditions() {
  // if (VerboseTrace) Print("Calling " + __FUNCTION__ + ".");
  if (!Account_Conditions_Active) return;
  if (bar_time == last_action_time) return; // If action was already executed in the same bar, do not check again.

  for (int i = 0; i < ArrayRange(acc_conditions, 0); i++) {
    if (AccCondition(acc_conditions[i][0]) && MarketCondition(acc_conditions[i][1]) && acc_conditions[i][2] != A_NONE) {
      ActionExecute(acc_conditions[i][2], i);
    }
  } // end: for
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
double GetStrategyLotSize(int sid, int cmd) {
  double trade_lot = (conf[sid][LOT_SIZE] > 0 ? conf[sid][LOT_SIZE] : lot_size) * (conf[sid][FACTOR] > 0 ? conf[sid][FACTOR] : 1.0);
  #ifdef __advanced__
  if (Boosting_Enabled) {
    double pf = GetStrategyProfitFactor(sid);
    if (BoostByProfitFactor && pf > 1.0) trade_lot *= fmax(GetStrategyProfitFactor(sid), 1.0);
    else if (HandicapByProfitFactor && pf < 1.0) trade_lot *= fmin(GetStrategyProfitFactor(sid), 1.0);
  }
  #endif
  if (Boosting_Enabled && CheckTrend() == cmd && BoostTrendFactor != 1.0) {
    trade_lot *= BoostTrendFactor;
  }
  return NormalizeLots(trade_lot);
}

/**
 * Get strategy comment for opened order.
 */
string GetStrategyComment(int sid) {
  return StringFormat("%s; %.1f pips spread; sid: %d", sname[sid], curr_spread, sid);
}

/**
 * Get strategy report based on the total orders.
 */
string GetStrategyReport(string sep = "\n") {
  string output = "Strategy stats:" + sep;
  for (int id = 0; id < FINAL_STRATEGY_TYPE_ENTRY; id++) {
    if (info[id][TOTAL_ORDERS] > 0) {
      output += StringFormat("Profit factor: %.2f, ",
                GetStrategyProfitFactor(id));
      output += StringFormat("Total net profit: %.2fpips (%+.2f/%-.2f), ",
        stats[id][TOTAL_NET_PROFIT], stats[id][TOTAL_GROSS_PROFIT], stats[id][TOTAL_GROSS_LOSS]);
      output += StringFormat("Total orders: %d (Won: %.1f%% [%d] / Loss: %.1f%% [%d])",
                info[id][TOTAL_ORDERS],
                (100 / NormalizeDouble(info[id][TOTAL_ORDERS], 2)) * info[id][TOTAL_ORDERS_WON],
                info[id][TOTAL_ORDERS_WON],
                (100 / NormalizeDouble(info[id][TOTAL_ORDERS], 2)) * info[id][TOTAL_ORDERS_LOSS],
                info[id][TOTAL_ORDERS_LOSS]);
      output += info[id][TOTAL_ERRORS] > 0 ? StringFormat(", Errors: %d", info[id][TOTAL_ERRORS]) : "";
      output += StringFormat(" - %s", sname[id]);
      output += sep;
    }
  }
  return output;
}

/**
 * Apply strategy boosting.
 */
void UpdateStrategyFactor(int period) {
  switch (period) {
    case DAILY:
      ApplyStrategyMultiplierFactor(DAILY, 1, BestDailyStrategyMultiplierFactor);
      ApplyStrategyMultiplierFactor(DAILY, -1, WorseDailyStrategyDividerFactor);
      break;
    case WEEKLY:
      if (day_of_week > 1) {
        // FIXME: When commented out with 1.0, the profit is different.
        ApplyStrategyMultiplierFactor(WEEKLY, 1, BestWeeklyStrategyMultiplierFactor);
        ApplyStrategyMultiplierFactor(WEEKLY, -1, WorseWeeklyStrategyDividerFactor);
      }
    break;
    case MONTHLY:
      ApplyStrategyMultiplierFactor(MONTHLY, 1, BestMonthlyStrategyMultiplierFactor);
      ApplyStrategyMultiplierFactor(MONTHLY, -1, WorseMonthlyStrategyDividerFactor);
    break;
  }
}

/**
 * Update strategy lot size.
 */
void UpdateStrategyLotSize() {
  for (int i = 0; i < ArrayRange(conf, 0); i++) {
    conf[i][LOT_SIZE] = lot_size * conf[i][FACTOR];
  }
}

/**
 * Calculate strategy profit factor.
 */
double GetStrategyProfitFactor(int sid) {
  if (info[sid][TOTAL_ORDERS] > 10 && stats[sid][TOTAL_GROSS_LOSS] < 0) {
    return (double)(stats[sid][TOTAL_GROSS_PROFIT] / -stats[sid][TOTAL_GROSS_LOSS]);
  } else {
    return 1.0;
  }
}

/**
 * Fetch strategy signal level based on the indicator and timeframe.
 */
double GetStrategySignalLevel(int indicator, int timeframe = PERIOD_M30, double default_value = 0.0) {
  int sid = GetStrategyViaIndicator(indicator, timeframe);
  // Message(StringFormat("%s(): indi = %d, timeframe = %d, sid = %d, signal_level = %f", __FUNCTION__, indicator, timeframe, sid, conf[sid][OPEN_LEVEL]));
  return sid >= 0 ? conf[sid][OPEN_LEVEL] : default_value;
}

/**
 * Fetch strategy signal level based on the indicator and timeframe.
 */
int GetStrategySignalMethod(int indicator, int timeframe = PERIOD_M30, int default_value = 0) {
  int sid = GetStrategyViaIndicator(indicator, timeframe);
  return sid >= 0 ? info[sid][OPEN_METHOD] : default_value;
}

/**
 * Fetch strategy timeframe based on the strategy type.
 */
int GetStrategyTimeframe(int sid, int default_value = PERIOD_M1) {
  return sid >= 0 ? info[sid][TIMEFRAME] : default_value;
}

/**
 * Get strategy id based on the indicator and tf.
 */
int GetStrategyViaIndicator(int indicator, int tf) {
  for (int sid = 0; sid < ArrayRange(info, 0); sid++) {
    if (info[sid][INDICATOR] == indicator && info[sid][TIMEFRAME] == tf) {
      return sid;
    }
  }
  Msg::ShowText(
    StringFormat("Cannot find indicator %d for timeframe: %d", indicator, tf),
    "Error", __FUNCTION__, __LINE__, VerboseErrors);
  return EMPTY;
}

/**
 * Calculate total strategy profit.
 */
double GetTotalProfit() {
  double total_profit = 0;
  for (int id = 0; id < ArrayRange(stats, 0); id++) {
    total_profit += stats[id][TOTAL_NET_PROFIT];
  }
  return total_profit;
}

/**
 * Apply strategy multiplier factor based on the strategy profit or loss.
 */
void ApplyStrategyMultiplierFactor(int period = DAILY, int direction = 0, double factor = 1.0) {
  if (GetNoOfStrategies() <= 1 || factor == 1.0) return;
  int key = Misc::If(period == MONTHLY, MONTHLY_PROFIT, Misc::If(period == WEEKLY, (int)WEEKLY_PROFIT, (int)DAILY_PROFIT));
  string period_name = Misc::If(period == MONTHLY, "montly", Misc::If(period == WEEKLY, "weekly", "daily"));
  int new_strategy = direction > 0 ? Arrays::GetArrKey1ByHighestKey2ValueD(stats, key) : Arrays::GetArrKey1ByLowestKey2ValueD(stats, key);
  if (new_strategy == EMPTY) return;
  int previous = Misc::If(direction > 0, best_strategy[period], worse_strategy[period]);
  double new_factor = 1.0;
  if (direction > 0) { // Best strategy.
    if (info[new_strategy][ACTIVE] && stats[new_strategy][key] > 10 && new_strategy != previous) { // Check if it's different than the previous one.
      if (previous != EMPTY) {
        if (!info[previous][ACTIVE]) info[previous][ACTIVE] = TRUE;
        conf[previous][FACTOR] = GetDefaultProfitFactor(); // Set previous strategy multiplier factor to default.
        if (VerboseDebug) Print(__FUNCTION__ + ": Setting multiplier factor to default for strategy: " + previous);
      }
      best_strategy[period] = new_strategy; // Assign the new worse strategy.
      info[new_strategy][ACTIVE] = TRUE;
      new_factor = GetDefaultProfitFactor() * factor;
      conf[new_strategy][FACTOR] = new_factor; // Apply multiplier factor for the new strategy.
      if (VerboseDebug) Print(__FUNCTION__ + ": Setting multiplier factor to " + new_factor + " for strategy: " + new_strategy + " (period: " + period_name + ")");
    }
  } else { // Worse strategy.
    if (info[new_strategy][ACTIVE] && stats[new_strategy][key] < 10 && new_strategy != previous) { // Check if it's different than the previous one.
      if (previous != EMPTY) {
        if (!info[previous][ACTIVE]) info[previous][ACTIVE] = TRUE;
        conf[previous][FACTOR] = GetDefaultProfitFactor(); // Set previous strategy multiplier factor to default.
        if (VerboseDebug) Print(__FUNCTION__ + ": Setting multiplier factor to default for strategy: " + previous + " to default.");
      }
      worse_strategy[period] = new_strategy; // Assign the new worse strategy.
      if (factor > 0) {
        new_factor = NormalizeDouble(GetDefaultProfitFactor() / factor, Digits);
        info[new_strategy][ACTIVE] = TRUE;
        conf[new_strategy][FACTOR] = new_factor; // Apply multiplier factor for the new strategy.
        if (VerboseDebug) Print(__FUNCTION__ + ": Setting multiplier factor to " + new_factor + " for strategy: " + new_strategy + " (period: " + period_name + ")");
      } else {
        info[new_strategy][ACTIVE] = FALSE;
        //conf[new_strategy][FACTOR] = GetDefaultProfitFactor();
        if (VerboseDebug) Print(__FUNCTION__ + ": Disabling strategy: " + new_strategy);
      }
    }
  }
}

#ifdef __advanced__
/**
 * Check if RSI period needs any change.
 *
 * FIXME: Doesn't improve much.
 */
void RSI_CheckPeriod() {

  int period;
  // 1 minute period.
  period = M1;
  if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < RSI1_IncreasePeriod_MinDiff) {
    info[RSI1][CUSTOM_PERIOD] = fmin(info[RSI1][CUSTOM_PERIOD] + 1, RSI_Period * 2);
    if (VerboseDebug) PrintFormat("Increased " + sname[RSI1] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  } else if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] > RSI1_DecreasePeriod_MaxDiff) {
    info[RSI1][CUSTOM_PERIOD] = fmax(info[RSI1][CUSTOM_PERIOD] - 1, RSI_Period / 2);
    if (VerboseDebug) PrintFormat("Decreased " + sname[RSI1] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  }
  // 5 minute period.
  period = M5;
  if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < RSI5_IncreasePeriod_MinDiff) {
    info[RSI5][CUSTOM_PERIOD] = fmin(info[RSI5][CUSTOM_PERIOD] + 1, RSI_Period * 2);
    if (VerboseDebug) PrintFormat("Increased " + sname[RSI5] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  } else if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] > RSI5_DecreasePeriod_MaxDiff) {
    info[RSI5][CUSTOM_PERIOD] = fmax(info[RSI5][CUSTOM_PERIOD] - 1, RSI_Period / 2);
    if (VerboseDebug) PrintFormat("Decreased " + sname[RSI5] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  }
  // 15 minute period.

  period = M15;
  if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < RSI15_IncreasePeriod_MinDiff) {
    info[RSI15][CUSTOM_PERIOD] = fmin(info[RSI15][CUSTOM_PERIOD] + 1, RSI_Period * 2);
    if (VerboseDebug) PrintFormat("Increased " + sname[RSI15] + " period to %d", info[RSI15][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  } else if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] > RSI15_DecreasePeriod_MaxDiff) {
    info[RSI15][CUSTOM_PERIOD] = fmax(info[RSI15][CUSTOM_PERIOD] - 1, RSI_Period / 2);
    if (VerboseDebug) PrintFormat("Decreased " + sname[RSI15] + " period to %d", info[RSI15][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  }
  /*
  Print(__FUNCTION__ + ": M1: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  period = M5;
  Print(__FUNCTION__ + ": M5: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  period = M15;
  Print(__FUNCTION__ + ": M15: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  period = M30;
  Print(__FUNCTION__ + ": M30: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  */
}

// FIXME: Doesn't improve anything.
bool RSI_IncreasePeriod(ENUM_TIMEFRAMES tf = PERIOD_M1, int condition = 0) {
  bool result = condition > 0;
  UpdateIndicator(RSI, tf);
  int period = Convert::TfToIndex(tf);
  if ((condition &   1) != 0) result = result && (rsi_stats[period][UPPER] > 50 + RSI_SignalLevel + RSI_SignalLevel / 2 && rsi_stats[period][LOWER] < 50 - RSI_SignalLevel - RSI_SignalLevel / 2);
  if ((condition &   2) != 0) result = result && (rsi_stats[period][UPPER] > 50 + RSI_SignalLevel + RSI_SignalLevel / 2 || rsi_stats[period][LOWER] < 50 - RSI_SignalLevel - RSI_SignalLevel / 2);
  if ((condition &   4) != 0) result = result && (rsi_stats[period][0] < 50 + RSI_SignalLevel + RSI_SignalLevel / 3 && rsi_stats[period][0] > 50 - RSI_SignalLevel - RSI_SignalLevel / 3);
  // if ((condition &   4) != 0) result = result || rsi_stats[period][0] < 50 + RSI_SignalLevel;
  if ((condition &   8) != 0) result = result && rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < 50;
  // if ((condition &  16) != 0) result = result && rsi[period][CURR] - rsi[period][PREV] > rsi[period][PREV] - rsi[period][FAR];
  // if ((condition &  32) != 0) result = result && Open[CURR] > Close[PREV];
  return result;
}

// FIXME: Doesn't improve anything.
bool RSI_DecreasePeriod(ENUM_TIMEFRAMES tf = PERIOD_M1, int condition = 0) {
  bool result = condition > 0;
  UpdateIndicator(RSI, tf);
  int period = Convert::TfToIndex(tf);
  if ((condition &   1) != 0) result = result && (rsi_stats[period][UPPER] <= 50 + RSI_SignalLevel && rsi_stats[period][LOWER] >= 50 - RSI_SignalLevel);
  if ((condition &   2) != 0) result = result && (rsi_stats[period][UPPER] <= 50 + RSI_SignalLevel || rsi_stats[period][LOWER] >= 50 - RSI_SignalLevel);
  // if ((condition &   4) != 0) result = result && (rsi_stats[period][0] > 50 + RSI_SignalLevel / 3 || rsi_stats[period][0] < 50 - RSI_SignalLevel / 3);
  // if ((condition &   4) != 0) result = result && rsi_stats[period][UPPER] > 50 + (RSI_SignalLevel / 3);
  // if ((condition &   8) != 0) result = result && && rsi_stats[period][UPPER] < 50 - (RSI_SignalLevel / 3);
  // if ((condition &  16) != 0) result = result && rsi[period][CURR] - rsi[period][PREV] > rsi[period][PREV] - rsi[period][FAR];
  // if ((condition &  32) != 0) result = result && Open[CURR] > Close[PREV];
  return result;
}
#endif

/**
 * Return strategy id by order magic number.
 */
int GetIdByMagic(int magic = -1) {
  if (magic == -1) magic = OrderMagicNumber();
  int id = magic - MagicNumber;
  return CheckOurMagicNumber(magic) ? id : -1;
}

/* END: STRATEGY FUNCTIONS */

/* BEGIN: SUPPORT/RESISTANCE CALCULATION */

/**
// See: http://forum.mql4.com/49780
void CalculateSupRes() {
   int commonPoint;
   int minLevel, maxLevel;
   double highest, lowest, stepIncrement, tolerance, high;
   double storeLevel[];
   ///ArrayResize(storeLevel, loopback);

   minLevel = iLowest(Symbol(), Period(), MODE_LOW, loopback, 0);
   maxLevel = iHighest(Symbol(), Period(), MODE_HIGH, loopback, 0);
   highest = iHigh(Symbol(), Period(), maxLevel);
   lowest = iLow(Symbol(), Period(), minLevel);

   //Print("max: " + highest + " min: " + lowest);
   stepIncrement = 0.0005;
   tolerance = 0.0002;
   static double tmp;
   tmp = 0.0;


   for (double actPrice = lowest; actPrice <= highest; actPrice += stepIncrement) {
      for (int i = 1; i <= loopback; i++) {
         //do some stuff here...
         high = iHigh(Symbol(), Period(), i);
         double topRange, bottomRange;
         // if is the first value tmp stores the first high encountered until that moment
         if (tmp == 0) {
            tmp = high;
         } else {
            //define a buffer adding a subtracting from tmp to check if the new high is within that value
            topRange = tmp + tolerance;
            bottomRange = tmp - tolerance;

            if (high <= topRange && high >= bottomRange) {
               commonPoint++;
            }
         }
         //if has been touched at least three times reset common point
         //tmp goes to the new high value to keep looping
         if (commonPoint == 3) {
            commonPoint = 0;
            tmp = high;
            ///Print("valore tmp: " + tmp);
            storeLevel[i] = tmp;
         }
      }
   }
}
*/

/* END: SUPPORT/RESISTANCE CALCULATION */

/* BEGIN: DISPLAYING FUNCTIONS */

/**
 * Get text output of hourly stats.
 */
string GetStats(string sep = ", ") {
  string output = "Stats: ";
  output += Minute() > 0 ? StringFormat("%.1f ticks/min", hourly_stats.GetTotalTicks() / Minute()) + sep : "";
  return output;
}

/**
 * Get text output of hourly profit report.
 */
string GetHourlyProfit(string sep = ", ") {
  string output = StringFormat("Hourly profit (total: %.1fp): ", Arrays::GetArrSumKey1(hourly_profit, day_of_year));
  for (int h = 0; h < hour_of_day; h++) {
    output += StringFormat("%d: %.1fp%s", h, hourly_profit[day_of_year][h], Misc::If(h < hour_of_day, sep, ""));
  }
  return output;
}

/**
 * Get text output of daily report.
 */
string GetDailyReport() {
  string output = "Daily max: ";
  int key;
  // output += "Low: "     + daily[MAX_LOW] + "; ";
  // output += "High: "    + daily[MAX_HIGH] + "; ";
  output += StringFormat("Tick: %g; ", daily[MAX_TICK]);
  // output += "Drop: "    + daily[MAX_DROP] + "; ";
  output += StringFormat("Spread: %g pts; ",   daily[MAX_SPREAD]);
  output += StringFormat("Max orders: %.0f; ", daily[MAX_ORDERS]);
  output += StringFormat("Loss: %.2f; ",       daily[MAX_LOSS]);
  output += StringFormat("Profit: %.2f; ",     daily[MAX_PROFIT]);
  output += StringFormat("Equity: %.2f; ",     daily[MAX_EQUITY]);
  output += StringFormat("Balance: %.2f; ",    daily[MAX_BALANCE]);

  //output += GetAccountTextDetails() + "; " + GetOrdersStats();

  key = Arrays::GetArrKey1ByHighestKey2ValueD(stats, DAILY_PROFIT);
  if (key >= 0 && stats[key][DAILY_PROFIT] > 0) {
    output += StringFormat("Best: %s (%.2fp)", sname[key], stats[key][DAILY_PROFIT]);
  }
  key = Arrays::GetArrKey1ByLowestKey2ValueD(stats, DAILY_PROFIT);
  if (key >= 0 && stats[key][DAILY_PROFIT] < 0) {
    output += StringFormat("Worse: %s (%.2fp)", sname[key], stats[key][DAILY_PROFIT]);
  }

  return output;
}

/**
 * Get text output of weekly report.
 */
string GetWeeklyReport() {
  string output = "Weekly max: ";
  int key;
  // output =+ GetAccountTextDetails() + "; " + GetOrdersStats();
  // output += "Low: "     + weekly[MAX_LOW] + "; ";
  // output += "High: "    + weekly[MAX_HIGH] + "; ";
  output += StringFormat("Tick: %g; ", weekly[MAX_TICK]);
  // output += "Drop: "    + weekly[MAX_DROP] + "; ";
  output += StringFormat("Spread: %g pts; ",   weekly[MAX_SPREAD]);
  output += StringFormat("Max orders: %.0f; ", weekly[MAX_ORDERS]);
  output += StringFormat("Loss: %.2f; ",       weekly[MAX_LOSS]);
  output += StringFormat("Profit: %.2f; ",     weekly[MAX_PROFIT]);
  output += StringFormat("Equity: %.2f; ",     weekly[MAX_EQUITY]);
  output += StringFormat("Balance: %.2f; ",    weekly[MAX_BALANCE]);

  key = Arrays::GetArrKey1ByHighestKey2ValueD(stats, WEEKLY_PROFIT);
  if (key >= 0 && stats[key][WEEKLY_PROFIT] > 0) {
    output += StringFormat("Best: %s (%.2fp)", sname[key], stats[key][WEEKLY_PROFIT]);
  }
  key = Arrays::GetArrKey1ByLowestKey2ValueD(stats, WEEKLY_PROFIT);
  if (key >= 0 && stats[key][WEEKLY_PROFIT] < 0) {
    output += StringFormat("Worse: %s (%.2fp)", sname[key], stats[key][WEEKLY_PROFIT]);
  }

  return output;
}

/**
 * Get text output of monthly report.
 */
string GetMonthlyReport() {
  string output = "Monthly max: ";
  int key;
  // output =+ GetAccountTextDetails() + "; " + GetOrdersStats();
  // output += "Low: "     + monthly[MAX_LOW] + "; ";
  // output += "High: "    + monthly[MAX_HIGH] + "; ";
  output += StringFormat("Tick: %g; ", monthly[MAX_TICK]);
  // output += "Drop: "    + monthly[MAX_DROP] + "; ";
  output += StringFormat("Spread: %g pts; ",   monthly[MAX_SPREAD]);
  output += StringFormat("Max orders: %.0f; ", monthly[MAX_ORDERS]);
  output += StringFormat("Loss: %.2f; ",       monthly[MAX_LOSS]);
  output += StringFormat("Profit: %.2f; ",     monthly[MAX_PROFIT]);
  output += StringFormat("Equity: %.2f; ",     monthly[MAX_EQUITY]);
  output += StringFormat("Balance: %.2f; ",    monthly[MAX_BALANCE]);

  key = Arrays::GetArrKey1ByHighestKey2ValueD(stats, MONTHLY_PROFIT);
  if (key >= 0 && stats[key][MONTHLY_PROFIT] > 0) {
    output += StringFormat("Best: %s (%.2fp)", sname[key], stats[key][MONTHLY_PROFIT]);
  }
  key = Arrays::GetArrKey1ByLowestKey2ValueD(stats, MONTHLY_PROFIT);
  if (key >= 0 && stats[key][MONTHLY_PROFIT] < 0) {
    output += StringFormat("Worse: %s (%.2fp)", sname[key], stats[key][MONTHLY_PROFIT]);
  }

  return output;
}

/**
 * Display info on chart.
 */
string DisplayInfoOnChart(bool on_chart = true, string sep = "\n") {
  string output;
  // Prepare text for Stop Out.
  string stop_out_level = AccountStopoutLevel();
  if (AccountStopoutMode() == 0) stop_out_level += "%"; else stop_out_level += AccCurrency;
  stop_out_level += StringFormat(" (%.1f)", GetAccountStopoutLevel());
  // Prepare text to display max orders.
  string text_max_orders = "Max orders: " + max_orders + " [Per type: " + GetMaxOrdersPerType() + "]";
  #ifdef __advanced__
    if (MaxOrdersPerDay > 0) text_max_orders += StringFormat(" [Per day: %d]", MaxOrdersPerDay);
  #endif
  // Prepare text to display spread.
  string text_spread = StringFormat("Spread: %.1f pips (%d pts)", Market::GetSpreadInPips(), Market::GetSpreadInPts());
  // "Stop level (pips): " + DoubleToStr(market_stoplevel / pts_per_pip, Digits - pip_digits);
  // Check trend.
  string trend = "Neutral.";
  if (CheckTrend() == OP_BUY) trend = "Bullish";
  if (CheckTrend() == OP_SELL) trend = "Bearish";
  // Print actual info.
  string indent = "";
  indent = "                      "; // if (total_orders > 5)?
  output = indent + "------------------------------------------------" + sep
                  + indent + StringFormat("| %s v%s (Status: %s)%s", ea_name, ea_version, Misc::If(ea_active, "ACTIVE", "NOT ACTIVE"), sep)
                  + indent + StringFormat("| ACCOUNT INFORMATION:%s", sep)
                  + indent + StringFormat("| Server Name: %s, Time: %s%s", AccountInfoString(ACCOUNT_SERVER), TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS), sep)
                  + indent + "| Acc Number: " + IntegerToString(Account::AccountNumber()) + "; Acc Name: " + AccountName() + "; Broker: " + Account::AccountCompany() + " (Type: " + account_type + ")" + sep
                  + indent + StringFormat("| Stop Out Level: %s, Leverage: 1:%d %s", stop_out_level, AccountLeverage(), sep)
                  + indent + "| Used Margin: " + Convert::ValueWithCurrency(Account::AccountMargin()) + "; Free: " + Convert::ValueWithCurrency(Account::AccountFreeMargin()) + sep
                  + indent + "| Equity: " + Convert::ValueWithCurrency(Account::AccountEquity()) + "; Balance: " + Convert::ValueWithCurrency(Account::AccountBalance()) + sep
                  + indent + "| Lot size: " + DoubleToStr(lot_size, volume_digits) + "; " + text_max_orders + sep
                  + indent + "| Risk ratio: " + DoubleToStr(risk_ratio, 1) + " (" + GetRiskRatioText() + ")" + sep
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
                  + indent + "| " + GetStats() + "" + sep
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
    WindowRedraw(); // Redraws the current chart forcedly.
  }
  return output;
}

/**
 * Send e-mail about the order.
 */
void SendEmailExecuteOrder(string sep = "<br>\n") {
  string mail_title = "Trading Info - " + ea_name;
  string body = "Trade Information" + sep;
  body += sep + StringFormat("Event: %s", "Trade Opened");
  body += sep + StringFormat("Currency Pair: %s", _Symbol);
  body += sep + StringFormat("Time: %s", TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS));
  body += sep + StringFormat("Order Type: %s", Convert::OrderTypeToString(OrderType()));
  body += sep + StringFormat("Price: %s", DoubleToStr(OrderOpenPrice(), Digits));
  body += sep + StringFormat("Lot size: %s", DoubleToStr(OrderLots(), volume_digits));
  body += sep + StringFormat("Comment: %s", OrderComment());
  body += sep + StringFormat("Current Balance: %s", Convert::ValueWithCurrency(Account::AccountBalance()));
  body += sep + StringFormat("Current Equity: %s", Convert::ValueWithCurrency(Account::AccountEquity()));
  SendMail(mail_title, body);
}

/**
 * Get order statistics in percentage for each strategy.
 */
string GetOrdersStats(string sep = "\n") {
  // Prepare text for Total Orders.
  string total_orders_text = StringFormat("Open Orders: %d", total_orders);
  total_orders_text += StringFormat(" +%d/-%d", CalculateOrdersByCmd(OP_BUY),  CalculateOrdersByCmd(OP_SELL));
  total_orders_text += StringFormat(" [%.2f lots]", CalculateOpenLots());
  total_orders_text += StringFormat(" (other: %d)", GetTotalOrders(FALSE));
  // Prepare data about open orders per strategy type.
  string orders_per_type = "Stats: "; // Display open orders per type.
  if (total_orders > 0) {
    for (int i = 0; i < FINAL_STRATEGY_TYPE_ENTRY; i++) {
      if (open_orders[i] > 0) {
        orders_per_type += StringFormat("%s: %.1f%% ", sname[i], MathFloor(100 / total_orders * open_orders[i]));
      }
    }
  } else {
    orders_per_type += "No orders open yet.";
  }
  return orders_per_type + sep + total_orders_text;
}

/**
 * Get information about account conditions in text format.
 */
string GetAccountTextDetails(string sep = "; ") {
   return StringConcatenate("Account Details: ",
      "Time: ", TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS), sep,
      "Account Balance: ", Convert::ValueWithCurrency(Account::AccountBalance()), sep,
      "Account Equity: ", Convert::ValueWithCurrency(Account::AccountEquity()), sep,
      "Used Margin: ", Convert::ValueWithCurrency(Account::AccountMargin()), sep,
      "Free Margin: ", Convert::ValueWithCurrency(Account::AccountFreeMargin()), sep,
      "No of Orders: ", total_orders, " (BUY/SELL: ", CalculateOrdersByCmd(OP_BUY), "/", CalculateOrdersByCmd(OP_SELL), ")", sep,
      "Risk Ratio: ", DoubleToStr(risk_ratio, 1)
   );
}

/**
 * Get information about market conditions in text format.
 */
string GetMarketTextDetails() {
   return StringConcatenate("MarketInfo: ",
     "Symbol: ", Symbol(), "; ",
     "Ask: ", DoubleToStr(Ask, Digits), "; ",
     "Bid: ", DoubleToStr(Bid, Digits), "; ",
     StringFormat("Spread: %gpts = %.2f pips", Market::GetSpreadInPts(), Market::GetSpreadInPips())
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
  if (RiskRatio != 0.0 && risk_ratio < 0.9) text = "Set low manually";
  else if (risk_ratio < 0.2) text = "Extremely risky!";
  else if (risk_ratio < 0.3) text = "Very risky!";
  else if (risk_ratio < 0.5) text = "Risky!";
  else if (risk_ratio < 0.9) text = "Below normal, but ok";
  else if (risk_ratio > 5.0) text = "Extremely high (risky!)";
  else if (risk_ratio > 2.0) text = "Very high";
  else if (risk_ratio > 1.4) text = "High";
  #ifdef __advanced__
    if (StringLen(rr_text) > 0) text += " - reason: " + rr_text;
  #endif
  return text;
}

/**
 * Print multi-line text.
 */
void PrintText(string text) {
  string result[];
  ushort usep = StringGetCharacter("\n", 0);
  for (int i = StringSplit(text, usep, result)-1; i >= 0; i--) {
    Print(result[i]);
  }
}

/* END: DISPLAYING FUNCTIONS */

/* BEGIN: STRING FUNCTIONS */

/**
 * Remove separator character from the end of the string.
 */
void TxtRemoveSepChar(string& text, string sep) {
  if (StringSubstr(text, StringLen(text)-1) == sep) text = StringSubstr(text, 0, StringLen(text)-1);
}

/* END: STRING FUNCTIONS */

/* BEGIN: ACTION FUNCTIONS */

/**
 * Execute action to close the most profitable order.
 */
bool ActionCloseMostProfitableOrder(int reason_id = EMPTY, int min_profit = EMPTY){
  bool result = FALSE;
  int selected_ticket = 0;
  double max_ticket_profit = 0, curr_ticket_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES))
     if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
      curr_ticket_profit = Order::GetOrderProfit();
       if (curr_ticket_profit > max_ticket_profit) {
         selected_ticket = OrderTicket();
         max_ticket_profit = curr_ticket_profit;
       }
     }
  }

  if (selected_ticket > 0) {
    if (min_profit != EMPTY && max_ticket_profit < Account_Condition_MinProfitCloseOrder) { return (FALSE); }
    last_close_profit = max_ticket_profit;
    return TaskAddCloseOrder(selected_ticket, reason_id);
  } else if (VerboseTrace) {
    Print(__FUNCTION__ + ": Can't find any profitable order.");
  }
  return (FALSE);
}

/**
 * Execute action to close most unprofitable order.
 */
bool ActionCloseMostUnprofitableOrder(int reason_id = EMPTY){
  int selected_ticket = 0;
  double ticket_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES))
     if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if (Order::GetOrderProfit() < ticket_profit) {
         selected_ticket = OrderTicket();
         ticket_profit = Order::GetOrderProfit();
       }
     }
  }

  if (selected_ticket > 0) {
    last_close_profit = ticket_profit;
    return TaskAddCloseOrder(selected_ticket, reason_id);
  } else if (VerboseDebug) {
    Print(__FUNCTION__ + ": Can't find any unprofitable order as requested.");
  }
  return (FALSE);
}

/**
 * Execute action to close all profitable orders.
 */
bool ActionCloseAllProfitableOrders(int reason_id = EMPTY){
  bool result = FALSE;
  int selected_orders = 0;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = Order::GetOrderProfit();
       if (ticket_profit > 0) {
         result = TaskAddCloseOrder(OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    if (VerboseInfo) Print(__FUNCTION__ + ": Queued " + selected_orders + " orders to close with expected profit of " + total_profit + " pips.");
  }
  return (result);
}

/**
 * Execute action to close all unprofitable orders.
 */
bool ActionCloseAllUnprofitableOrders(int reason_id = EMPTY){
  bool result = FALSE;
  int selected_orders = 0;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = Order::GetOrderProfit();
       if (ticket_profit < 0) {
         result = TaskAddCloseOrder(OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    if (VerboseInfo) Print(__FUNCTION__ + ": Queued " + selected_orders + " orders to close with expected loss of " + total_profit + " pips.");
  }
  return (result);
}

/**
 * Execute action to close all orders by specified type.
 */
bool ActionCloseAllOrdersByType(int cmd = EMPTY, int reason_id = EMPTY){
  int selected_orders = 0;
  double ticket_profit = 0, total_profit = 0;
  if (cmd == EMPTY) return (FALSE);
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       if (OrderType() == cmd) {
         TaskAddCloseOrder(OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    if (VerboseInfo) Print(__FUNCTION__ + "(" + Convert::OrderTypeToString(cmd) + "): Queued " + selected_orders + " orders to close with expected profit of " + total_profit + " pips.");
  }
  return (FALSE);
}

/**
 * Execute action to close all orders.
 *
 * Notes:
 * - Useful when equity is low or high in order to secure our assets and avoid higher risk.
 * - Executing this action could indicate our poor money management and risk further losses.
 *
 * Parameter: only_ours
 *   When True (default), we should close only ours orders (determined by our magic number).
 *   When False, we should close all orders (including other stragegies if any).
 *     This is due the account equity and balance are shared,
 *     so potentially we don't know which strategy generated this kind of situation,
 *     therefore closing all make the things more predictable and to avoid any suprices.
 */
int ActionCloseAllOrders(int reason_id = EMPTY, bool only_ours = TRUE) {
   int processed = 0;
   int total = OrdersTotal();
   double total_profit = 0;
   for (int order = 0; order < total; order++) {
      if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderTicket() > 0) {
         if (only_ours && !CheckOurMagicNumber()) continue;
         total_profit += Order::GetOrderProfit();
         TaskAddCloseOrder(OrderTicket(), reason_id); // Add task to re-try.
         processed++;
      } else {
        if (VerboseDebug)
         Print(__FUNCTION__ + ": Error: Order Pos: " + order + "; Message: ", GetErrorText(GetLastError()));
      }
   }

   if (processed > 0) {
    last_close_profit = total_profit;
     if (VerboseInfo) Print(__FUNCTION__ + ": Queued " + processed + " orders out of " + total + " for closure.");
   }
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
  bool result = FALSE;
  int reason_id = Misc::If(id != EMPTY, acc_conditions[id][0], EMPTY); // Account id condition.
  int mid = Misc::If(id != EMPTY, acc_conditions[id][1], EMPTY); // Market id condition.
  int cmd;
  switch (aid) {
    case A_NONE: /* 0 */
      result = TRUE;
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
      if (cmd != EMPTY) {
        result = ActionCloseAllOrdersByType(cmd, reason_id);
      }
      break;
    case A_CLOSE_ALL_LOSS_SIDE: /* 7 */
      cmd = GetProfitableSide();
      if (cmd != EMPTY) {
        result = ActionCloseAllOrdersByType(Convert::OrderTypeOpp(cmd), reason_id);
      }
      break;
    case A_CLOSE_ALL_TREND: /* 8 */
      cmd = CheckTrend(TrendMethodAction);
      if (cmd != EMPTY) {
        result = ActionCloseAllOrdersByType(cmd, reason_id);
      }
      break;
    case A_CLOSE_ALL_NON_TREND: /* 9 */
      cmd = CheckTrend(TrendMethodAction);
      if (cmd != EMPTY) {
        result = ActionCloseAllOrdersByType(Convert::OrderTypeOpp(cmd), reason_id);
      }
      break;
    case A_CLOSE_ALL_ORDERS: /* 10 */
      result = ActionCloseAllOrders(reason_id);
      break;
    case A_SUSPEND_STRATEGIES: /* 11 */
      Arrays::ArrSetValueI(info, SUSPENDED, (int)TRUE);
      break;
    case A_UNSUSPEND_STRATEGIES: /* 12 */
      Arrays::ArrSetValueI(info, SUSPENDED, (int)FALSE);
      break;
    case A_RESET_STRATEGY_STATS: /* 13 */
      Arrays::ArrSetValueD(conf, PROFIT_FACTOR, GetDefaultProfitFactor());
      Arrays::ArrSetValueD(stats, TOTAL_GROSS_LOSS,   0.0);
      Arrays::ArrSetValueD(stats, TOTAL_GROSS_PROFIT, 0.0);
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
        StringFormat("Executed action: %s (id: %d), because of market condition: %s (id: %d) and account condition is: %s (id: %d) [E:%s/B:%s/P:%sp].",
          ActionIdToText(aid), aid, MarketIdToText(mid), mid, ReasonIdToText(reason_id), reason_id, Convert::ValueWithCurrency(Account::AccountEquity()), Convert::ValueWithCurrency(AccountBalance()), DoubleToStr(last_close_profit, 1)),
        "Info", __FUNCTION__, __LINE__, VerboseInfo);
    Msg::ShowText(last_msg, "Debug", __FUNCTION__, __LINE__, VerboseDebug && aid != A_NONE);
    if (WriteReport && VerboseDebug) ReportAdd(GetLastMessage());
    last_action_time = last_bar_time; // Set last execution bar time.
  } else {
    Msg::ShowText(
      StringFormat("Failed to execute action: %s (id: %d), condition: %s (id: %d).",
        ActionIdToText(aid), aid, ReasonIdToText(reason_id), reason_id),
      "Error", __FUNCTION__, __LINE__, VerboseErrors);
  }
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
string ReasonIdToText(int rid) {
  string output = "Unknown";
  switch (rid) {
    case EMPTY: output = "Empty"; break;
    case R_NONE: output = "None (inactive)"; break;
    case R_TRUE: output = "Always true"; break;
    case R_EQUITY_LOWER: output = "Equity lower than balance"; break;
    case R_EQUITY_HIGHER: output = "Equity higher than balance"; break;
    case R_EQUITY_50PC_HIGH: output = "Equity 50% high"; break;
    case R_EQUITY_20PC_HIGH: output = "Equity 20% high"; break;
    case R_EQUITY_10PC_HIGH: output = "Equity 10% high"; break;
    case R_EQUITY_10PC_LOW: output = "Equity 10% low"; break;
    case R_EQUITY_20PC_LOW: output = "Equity 20% low"; break;
    case R_EQUITY_50PC_LOW: output = "Equity 50% low"; break;
    case R_MARGIN_USED_50PC: output = "50% Margin Used"; break;
    case R_MARGIN_USED_70PC: output = "70% Margin Used"; break;
    case R_MARGIN_USED_80PC: output = "80% Margin Used"; break;
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
    case C_MARKET_BIG_DROP: output = "Market big drop"; break;
    case C_MARKET_VBIG_DROP: output = "Market very big drop"; break;
    case C_MARKET_AT_HOUR: output = StringFormat("at specific %d hour", MarketSpecificHour); break;
  }
  return output;
}

/* END: ACTION FUNCTIONS */

/* BEGIN: TICKET LIST/HISTORY CHECK FUNCTIONS */

/**
 * Add ticket to list for further processing.
 */
bool TicketAdd(int ticket_no) {
  int i, slot = EMPTY;
  int size = ArraySize(tickets);
  // Check if ticket is already in the list and at the same time find the empty slot.
  for (i = 0; i < size; i++) {
    if (tickets[i] == ticket_no) {
      return (TRUE); // Ticket already in the list.
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
    return (FALSE); // Array exceeded hard limit, probably because of some memory leak.
  }

  tickets[slot] = ticket_no;
  return (TRUE);
}

/**
 * Remove ticket from the list after it has been processed.
 */
bool TicketRemove(int ticket_no) {
  for (int i = 0; i < ArraySize(tickets); i++) {
    if (tickets[i] == ticket_no) {
      tickets[i] = 0; // Remove the ticket number from the array slot.
      return (TRUE); // Ticket has been removed successfully.
    }
  }
  return (FALSE);
}

/**
 * Process order history.
 */
bool CheckHistory() {
  double total_profit = 0;
  int pos;
  for (pos = last_history_check; pos < HistoryTotal(); pos++) {
    if (!OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)) continue;
    if (OrderCloseTime() > last_history_check && CheckOurMagicNumber()) {
      total_profit =+ OrderCalc();
    }
  }
  hourly_profit[day_of_year][hour_of_day] = total_profit; // Update hourly profit.
  last_history_check = pos;
  return (TRUE);
}

/* END: TICKET LIST/HISTORY CHECK FUNCTIONS */

/* BEGIN: ORDER QUEUE FUNCTIONS */

#ifdef __advanced__
/**
 * Process AI queue of orders to see if we can open any trades.
 */
bool OrderQueueProcess(int method = EMPTY, int filter = EMPTY) {
  bool result = FALSE;
  int queue_size = OrderQueueCount();
  int sorted_queue[][2];
  int cmd, sid, time; double volume;
  if (method == EMPTY) method = SmartQueueMethod;
  if (filter == EMPTY) filter = SmartQueueFilter;
  if (queue_size > 1) {
    int selected_qid = EMPTY, curr_qid = EMPTY;
    ArrayResize(sorted_queue, queue_size);
    for (int i = 0; i < queue_size; i++) {
      curr_qid = OrderQueueNext(curr_qid);
      if (curr_qid == EMPTY) break;
      sorted_queue[i][0] = GetOrderQueueKeyValue(order_queue[curr_qid][Q_SID], method, curr_qid);
      sorted_queue[i][1] = curr_qid++;
    }
    // Sort array by first dimension (descending).
    ArraySort(sorted_queue, WHOLE_ARRAY, 0, MODE_DESCEND);
    for (int i = 0; i < queue_size; i++) {
      selected_qid = sorted_queue[i][1];
      cmd = order_queue[selected_qid][Q_CMD];
      sid = order_queue[selected_qid][Q_SID];
      time = order_queue[selected_qid][Q_TIME];
      volume = GetStrategyLotSize(sid, cmd);
      if (!OpenOrderCondition(cmd, sid, time, filter)) continue;
      if (OpenOrderIsAllowed(cmd, sid, volume)) {
        string comment = GetStrategyComment(sid) + " [AIQueued]";
        result = ExecuteOrder(cmd, sid, volume);
        break;
      }
    }
  }
  return result;
}

/**
 * Check for the market condition to filter out the order queue.
 */
bool OpenOrderCondition(int cmd, int sid, int time, int method) {
  bool result = TRUE;
  int tf = GetStrategyTimeframe(sid);
  int period = Convert::TfToIndex(tf);
  int qshift = iBarShift(_Symbol, tf, time, FALSE); // Get the number of bars for the tf since queued.
  double qopen = iOpen(_Symbol, tf, qshift);
  double qclose = iClose(_Symbol, tf, qshift);
  double qhighest = Market::GetPeakPrice(tf, MODE_HIGH, qshift); // Get the high price since queued.
  double qlowest = Market::GetPeakPrice(tf, MODE_LOW, qshift); // Get the lowest price since queued.
  double diff = fmax(qhighest - Open[CURR], Open[CURR] - qlowest);
  if ((method &   1) != 0) result &= (cmd == OP_BUY && qopen < Open[CURR]) || (cmd == OP_SELL && qopen > Open[CURR]);
  if ((method &   2) != 0) result &= (cmd == OP_BUY && qclose < Close[CURR]) || (cmd == OP_SELL && qclose > Close[CURR]);
  if ((method &   4) != 0) result &= (cmd == OP_BUY && qlowest < Low[CURR]) || (cmd == OP_SELL && qlowest > Low[CURR]);
  if ((method &   8) != 0) result &= (cmd == OP_BUY && qhighest > High[CURR]) || (cmd == OP_SELL && qhighest < High[CURR]);
  if ((method &  16) != 0) result &= UpdateIndicator(SAR, tf) && Trade_SAR(cmd, tf, 0, 0);
  if ((method &  32) != 0) result &= UpdateIndicator(DEMARKER, tf) && Trade_DeMarker(cmd, tf, 0, 0);
  if ((method &  64) != 0) result &= UpdateIndicator(RSI, tf) && Trade_RSI(cmd, tf, 0, 0);
  if ((method & 128) != 0) result &= UpdateIndicator(MA, tf) && Trade_MA(cmd, tf, 0, 0);
  return (result);
}

/**
 * Get key based on strategy id in order to prioritize the queue.
 */
int GetOrderQueueKeyValue(int sid, int method, int qid) {
  int key = 0;
  switch (method) {
    case  0: key = order_queue[qid][Q_TIME]; break; // 7867 OK (10k, 0.02)
    case  1: key = stats[sid][DAILY_PROFIT] * 10; break;
    case  2: key = stats[sid][WEEKLY_PROFIT] * 10; break;
    case  3: key = stats[sid][MONTHLY_PROFIT] * 10; break; // Has good results.
    case  4: key = stats[sid][TOTAL_NET_PROFIT] * 10; break; // Has good results.
    case  5: key = conf[sid][SPREAD_LIMIT] * 10; break;
    case  6: key = GetStrategyTimeframe(sid); break;
    case  7: key = GetStrategyProfitFactor(sid) * 100; break;
    case  8: key = GetStrategyLotSize(sid, order_queue[qid][Q_CMD]) * 100; break;
    case  9: key = stats[sid][TOTAL_GROSS_PROFIT]; break;
    case 10: key = info[sid][TOTAL_ORDERS]; break; // --7846
    case 11: key -= info[sid][TOTAL_ORDERS_LOSS]; break; // --7662 TODO: To test.
    case 12: key = info[sid][TOTAL_ORDERS_WON]; break; // --7515
    case 13: key -= stats[sid][TOTAL_GROSS_LOSS]; break;
    case 14: key = stats[sid][AVG_SPREAD] * 10; break; // --7396, TODO: To test.
    case 15: key = conf[sid][FACTOR] * 10; break; // --6976

    // case  4: key = -info[sid][OPEN_ORDERS]; break; // TODO
  }
  // Message("Key: " + key + " for sid: " + sid + ", qid: " + qid);

  return key;
}

/**
 * Get the next non-empty item from the queue.
 */
int OrderQueueNext(int index = EMPTY) {
  if (index == EMPTY) index = 0;
  for (int qid = index; qid < ArrayRange(order_queue, 0); qid++)
    if (order_queue[qid][Q_SID] != EMPTY) { return qid; }
  return (EMPTY);
}

/**
 * Add new order to the queue.
 */
bool OrderQueueAdd(int sid, int cmd) {
  bool result = FALSE;
  int qid = EMPTY, size = ArrayRange(order_queue, 0);
  for (int i = 0; i < size; i++) {
    if (order_queue[i][Q_SID] == sid && order_queue[i][Q_CMD] == cmd) {
      order_queue[i][Q_TOTAL]++;
      if (VerboseTrace) PrintFormat("%s(): Added qid %d with sid: %d, cmd: %d, time: %d, total: %d", __FUNCTION__, i, sid, cmd, time_current, order_queue[i][Q_TOTAL]);
      return (TRUE); // Increase the existing if it's there.
    }
    if (order_queue[i][Q_SID] == EMPTY) { qid = i; break; } // Find the empty qid.
  }
  if (qid == EMPTY && size < 1000) { ArrayResize(order_queue, size + FINAL_ORDER_QUEUE_ENTRY); qid = size; }
  if (qid == EMPTY) {
    return (FALSE);
  } else {
    order_queue[qid][Q_SID] = sid;
    order_queue[qid][Q_CMD] = cmd;
    order_queue[qid][Q_TIME] = time_current;
    order_queue[qid][Q_TOTAL] = 1;
    result = TRUE;
    if (VerboseTrace) PrintFormat("%s(): Added qid: %d with sid: %d, cmd: %d, time: %d, total: %d", __FUNCTION__, qid, sid, cmd, time_current, 1);
  }
  return result;
}

/**
 * Clear queue from the orders.
 */
void OrderQueueClear() {
  if (VerboseTrace) Print("Calling " + __FUNCTION__ + "().");
  ArrayFill(order_queue, 0, ArraySize(order_queue), EMPTY);
}

/**
 * Check how many orders are in the queue.
 */
int OrderQueueCount() {
  int counter = 0;
  for (int i = 0; i < ArrayRange(order_queue, 0); i++)
    if (order_queue[i][Q_SID] != EMPTY) counter++;
  return (counter);
}

#endif

/* END: ORDER QUEUE FUNCTIONS */

/* BEGIN: TASK FUNCTIONS */

/**
 * Add new closing order task.
 */
bool TaskAddOrderOpen(int cmd, int volume, int order_type) {
  int key = cmd+volume+order_type;
  int job_id = TaskFindEmptySlot(cmd+volume+order_type);
  if (job_id >= 0) {
    todo_queue[job_id][0] = key;
    todo_queue[job_id][1] = TASK_ORDER_OPEN;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = cmd;
    todo_queue[job_id][4] = EMPTY; // FIXME: Not used currently.
    todo_queue[job_id][5] = order_type;
    // todo_queue[job_id][6] = order_comment; // FIXME: Not used currently.
    // Print(__FUNCTION__ + ": Added task (", job_id, ") for ticket: ", todo_queue[job_id][0], ", type: ", todo_queue[job_id][1], " (", todo_queue[job_id][3], ").");
    return TRUE;
  } else {
    return FALSE; // Job not allocated.
  }
}

/**
 * Add new close task by job id.
 */
bool TaskAddCloseOrder(int ticket_no, int reason = EMPTY) {
  int job_id = TaskFindEmptySlot(ticket_no);
  if (job_id >= 0) {
    todo_queue[job_id][0] = ticket_no;
    todo_queue[job_id][1] = TASK_ORDER_CLOSE;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = reason;
    // if (VerboseTrace) Print("TaskAddCloseOrder(): Allocated task (id: ", job_id, ") for ticket: ", todo_queue[job_id][0], ".");
    return TRUE;
  } else {
    if (VerboseTrace) PrintFormat("%s(): Failed to allocate close task for ticket: %d", __FUNCTION__, ticket_no);
    return FALSE; // Job is not allocated.
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
    // if (VerboseTrace) Print(__FUNCTION__ + ": Allocated task (id: ", job_id, ") for ticket: ", todo_queue[job_id][0], ".");
    return TRUE;
  } else {
    if (VerboseTrace) PrintFormat("%s(): Failed to allocate close task for ticket: %d", __FUNCTION__, ticket_no);
    return FALSE; // Job is not allocated.
  }
}

// Remove specific task.
bool TaskRemove(int job_id) {
  todo_queue[job_id][0] = 0;
  todo_queue[job_id][2] = 0;
  // if (VerboseTrace) Print(__FUNCTION__ + ": Task removed for id: " + job_id);
  return TRUE;
}

// Check if task for specific ticket already exists.
bool TaskExistByKey(int key) {
  for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
    if (todo_queue[job_id][0] == key) {
      // if (VerboseTrace) Print(__FUNCTION__ + ": Task already allocated for key: " + key);
      return (TRUE);
      break;
    }
  }
  return (FALSE);
}

/**
 * Find available slot id.
 */
int TaskFindEmptySlot(int key) {
  int taken = 0;
  if (!TaskExistByKey(key)) {
    for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
      if (VerboseTrace) Print(__FUNCTION__ + ": job_id = " + job_id + "; key: " + todo_queue[job_id][0]);
      if (todo_queue[job_id][0] <= 0) { // Find empty slot.
        // if (VerboseTrace) Print(__FUNCTION__ + ": Found empty slot at: " + job_id);
        return job_id;
      } else taken++;
    }
    // If no empty slots, Otherwise increase size of array.
    int size = ArrayRange(todo_queue, 0);
    if (size < 1000) { // Set array hard limit.
      ArrayResize(todo_queue, size + 10);
      if (VerboseDebug) Print(__FUNCTION__ + ": Couldn't allocate Task slot, re-sizing array. New size: ",  (size + 1), ", Old size: ", size);
      return size;
    } else {
      // Array exceeded hard limit, probably because of some memory leak.
      if (VerboseDebug) Print(__FUNCTION__ + ": Couldn't allocate task slot, all are taken (" + taken + "). Size: " + size);
    }
  }
  return EMPTY;
}

/**
 * Run specific task.
 */
bool TaskRun(int job_id) {
  bool result = FALSE;
  int key = todo_queue[job_id][0];
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
       result = ExecuteOrder(cmd, sid, EMPTY, "", FALSE);
      break;
    case TASK_ORDER_CLOSE:
        reason_id = todo_queue[job_id][3];
        if (OrderSelect(key, SELECT_BY_TICKET)) {
          if (CloseOrder(key, reason_id, FALSE))
            result = TaskRemove(job_id);
        }
      break;
    case TASK_CALC_STATS:
        if (OrderSelect(key, SELECT_BY_TICKET, MODE_HISTORY)) {
          OrderCalc(key);
        } else {
          if (VerboseDebug) Print(__FUNCTION__ + ": Access to history failed with error: (" + GetLastError() + ").");
        }
      break;
    default:
      if (VerboseDebug) Print(__FUNCTION__ + ": Unknown task: ", task_type);
  };
  return result;
}

/**
 * Process task list.
 */
bool TaskProcessList(bool with_force = FALSE) {
   int total_run, total_failed, total_removed = 0;
   int no_elem = 8;

   // Check if bar time has been changed since last time.
   if (bar_time == last_queue_process && !with_force) {
     // if (VerboseTrace) Print("TaskProcessList(): Not executed. Bar time: " + bar_time + " == " + last_queue_process);
     return (FALSE); // Do not process job list more often than per each minute bar.
   } else {
     last_queue_process = bar_time; // Set bar time of last queue process.
   }

   Market::RefreshRates();
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
  return TRUE;
}

/* END: TASK FUNCTIONS */

/* BEGIN: ERROR HANDLING FUNCTIONS */

/**
 * Get textual representation of the error based on its code.
 *
 * Note: The error codes are defined in stderror.mqh.
 * Alternatively you can print the error description by using ErrorDescription() function, defined in stdlib.mqh.
 */
string GetErrorText(int code) {
   string text;

   switch (code) {
      case   0: text = "No error returned."; break;
      case   1: text = "No error returned, but the result is unknown."; break;
      case   2: text = "Common error."; break;
      case   3: text = "Invalid trade parameters."; break;
      case   4: text = "Trade server is busy."; break;
      case   5: text = "Old version of the client terminal,"; break;
      case   6: text = "No connection with trade server."; break;
      case   7: text = "Not enough rights."; break;
      case   8: text = "Too frequent requests."; break;
      case   9: text = "Malfunctional trade operation (never returned error)."; break;
      case   64: text = "Account disabled."; break;
      case   65: text = "Invalid account."; break;
      case  128: text = "Trade timeout."; break;
      case  129: text = "Invalid price."; break;
      case  130: text = "Invalid stops."; break;
      case  131: text = "Invalid trade volume."; break;
      case  132: text = "Market is closed."; break;
      case  133: text = "Trade is disabled."; break;
      case  134: text = "Not enough money."; break;
      case  135: text = "Price changed."; break;
      // --
      // ERR_OFF_QUOTES
      //   1. Off Quotes may be a technical issue.
      //   2. Off Quotes may be due to unsupported orders.
      //      - Trying to partially close a position. For example, attempting to close 0.10 (10k) of a 20k position.
      //      - Placing a micro lot trade. For example, attempting to place a 0.01 (1k) volume trade.
      //      - Placing a trade that is not in increments of 0.10 (10k) volume. For example, attempting to place a 0.77 (77k) trade.
      //      - Adding a stop or limit to a market order before the order executes. For example, setting an EA to place a 0.1 volume (10k) buy market order with a stop loss of 50 pips.
      case  136: text = "Off quotes."; #ifdef __backtest__ ExpertRemove(); #endif break;
      case  137: text = "Broker is busy (never returned error)."; break;
      case  138: text = "Requote."; #ifdef __backtest__ ExpertRemove(); #endif break;
      case  139: text = "Order is locked."; break;
      case  140: text = "Long positions only allowed."; break;
      case  141: /* ERR_TOO_MANY_REQUESTS */ text = "Too many requests."; #ifdef __backtest__ ExpertRemove(); #endif break;
      case  145: text = "Modification denied because order too close to market."; break;
      case  146: text = "Trade context is busy."; break;
      case  147: text = "Expirations are denied by broker."; break;
      // ERR_TRADE_TOO_MANY_ORDERS: On some trade servers, the total amount of open and pending orders can be limited. If this limit has been exceeded, no new position will be opened
      case  148: text = "Amount of open and pending orders has reached the limit set by the broker"; break; // ERR_TRADE_TOO_MANY_ORDERS
      case  149: text = "An attempt to open an order opposite to the existing one when hedging is disabled"; break; // ERR_TRADE_HEDGE_PROHIBITED
      case  150: text = "An attempt to close an order contravening the FIFO rule."; break; // ERR_TRADE_PROHIBITED_BY_FIFO
      case 4000: text = "No error (never generated code)."; break;
      case 4001: text = "Wrong function pointer."; break;
      case 4002: text = "Array index is out of range."; break;
      case 4003: text = "No memory for function call stack."; break;
      case 4004: text = "Recursive stack overflow."; break;
      case 4005: text = "Not enough stack for parameter."; break;
      case 4006: text = "No memory for parameter string."; break;
      case 4007: text = "No memory for temp string."; break;
      case 4008: text = "Not initialized string."; break;
      case 4009: text = "Not initialized string in array."; break;
      case 4010: text = "No memory for array\' string."; break;
      case 4011: text = "Too long string."; break;
      case 4012: text = "Remainder from zero divide."; break;
      case 4013: text = "Zero divide."; break;
      case 4014: text = "Unknown command."; break;
      case 4015: text = "Wrong jump (never generated error)."; break;
      case 4016: text = "Not initialized array."; break;
      case 4017: text = "Dll calls are not allowed."; break;
      case 4018: text = "Cannot load library."; break;
      case 4019: text = "Cannot call function."; break;
      case 4020: text = "Expert function calls are not allowed."; break;
      case 4021: text = "Not enough memory for temp string returned from function."; break;
      case 4022: text = "System is busy (never generated error)."; break;
      case 4050: text = "Invalid function parameters count."; break;
      case 4051: text = "Invalid function parameter value."; break;
      case 4052: text = "String function internal error."; break;
      case 4053: text = "Some array error."; break;
      case 4054: text = "Incorrect series array using."; break;
      case 4055: text = "Custom indicator error."; break;
      case 4056: text = "Arrays are incompatible."; break;
      case 4057: text = "Global variables processing error."; break;
      case 4058: text = "Global variable not found."; break;
      case 4059: text = "Function is not allowed in testing mode."; break;
      case 4060: text = "Function is not confirmed."; break;
      case 4061: text = "Send mail error."; break;
      case 4062: text = "String parameter expected."; break;
      case 4063: text = "Integer parameter expected."; break;
      case 4064: text = "Double parameter expected."; break;
      case 4065: text = "Array as parameter expected."; break;
      case 4066: text = "Requested history data in update state."; break;
      case 4074: /* ERR_NO_MEMORY_FOR_HISTORY */ text = "No memory for history data."; break;
      case 4099: text = "End of file."; break;
      case 4100: text = "Some file error."; break;
      case 4101: text = "Wrong file name."; break;
      case 4102: text = "Too many opened files."; break;
      case 4103: text = "Cannot open file."; break;
      case 4104: text = "Incompatible access to a file."; break;
      case 4105: text = "No order selected."; break;
      case 4106: text = "Unknown symbol."; break;
      case 4107: text = "Invalid stoploss parameter for trade (OrderSend) function."; break;
      case 4108: text = "Invalid ticket."; break;
      case 4109: text = "Trade is not allowed in the expert properties."; break;
      case 4110: text = "Longs are not allowed in the expert properties."; break;
      case 4111: text = "Shorts are not allowed in the expert properties."; break;
      case 4200: text = "Object is already exist."; break;
      case 4201: text = "Unknown object property."; break;
      case 4202: text = "Object is not exist."; break;
      case 4203: text = "Unknown object type."; break;
      case 4204: text = "No object name."; break;
      case 4205: text = "Object coordinates error."; break;
      case 4206: text = "No specified subwindow."; break;
      default:  text = "Unknown error.";
   }
   return (text);
}

/* END: ERROR HANDLING FUNCTIONS */

/**
 * Add message into the report file.
 */
void ReportAdd(string msg) {
  int last = ArraySize(log);
  ArrayResize(log, last + 1);
  log[last] = TimeToStr(time_current,TIME_DATE|TIME_SECONDS) + ": " + msg;
}

/**
 * Get extra stat report.
 */
string GetStatReport(string sep = "\n") {
  string output = "";
  output += StringFormat("Modelling quality:                          %.2f%%", Backtest::CalculateModellingQuality()) + sep;
  output += StringFormat("Total bars processed:                       %d", total_stats.GetTotalBars()) + sep;
  output += StringFormat("Total ticks processed:                      %d", total_stats.GetTotalTicks()) + sep;
  output += StringFormat("Bars per hour (avg):                        %d", total_stats.GetBarsPerPeriod(PERIOD_H1)) + sep;
  output += StringFormat("Ticks per bar (avg):                        %d (bar=%dmins)", total_stats.GetTicksPerBar(), Period()) + sep;
  output += StringFormat("Ticks per min (avg):                        %d", total_stats.GetTicksPerMin()) + sep;

  return output;
}

/**
 * Get log report.
 */
string GetLogReport(string sep = "\n") {
  string output = "";
  if (ArraySize(log) > 0) output += "Report log:\n";
  for (int i = 0; i < ArraySize(log); i++)
    output += log[i] + sep;
  return output;
}

//+------------------------------------------------------------------+
