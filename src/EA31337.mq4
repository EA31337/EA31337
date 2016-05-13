//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                                           Copyright 2016, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, kenorb"
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| EA includes.
//+------------------------------------------------------------------+
#include <EA\ea-mode.mqh>
#include <EA\ea-code-conf.mqh>
#include <EA\ea-properties.mqh>
#include <EA\ea-license.mqh>
#include <EA\ea-enums.mqh>

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

//#property tester_file "trade_patterns.csv"    // file with the data to be read by an Expert Advisor

//+------------------------------------------------------------------+
//| User input variables.
//+------------------------------------------------------------------+
extern string __EA_Parameters__ = "-- Input EA parameters for " + ea_name + " v" + ea_version + " --";
#ifdef __advanced__ // Include default input settings based on the mode.
  #ifdef __rider__
    #include <EA\ea-input-rider.mqh>
  #else
    #include <EA\ea-input-advanced.mqh>
  #endif
#else
  #include <EA\ea-input-lite.mqh>
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
 * Default enumerations:
 *
 * ENUM_MA_METHOD values:
 *   0: MODE_SMA (Simple averaging)
 *   1: MODE_EMA (Exponential averaging)
 *   2: MODE_SMMA (Smoothed averaging)
 *   3: MODE_LWMA (Linear-weighted averaging)
 *
 * ENUM_APPLIED_PRICE values:
 *   0: PRICE_CLOSE (Close price)
 *   1: PRICE_OPEN (Open price)
 *   2: PRICE_HIGH (The maximum price for the period)
 *   3: PRICE_LOW (The minimum price for the period)
 *   4: PRICE_MEDIAN (Median price, (high + low)/2
 *   5: PRICE_TYPICAL (Typical price, (high + low + close)/3
 *   6: PRICE_WEIGHTED (Average price, (high + low + close + close)/4
 *
 * Trade operation:
 *   0: OP_BUY (Buy operation)
 *   1: OP_SELL (Sell operation)
 *   2: OP_BUYLIMIT (Buy limit pending order)
 *   3: OP_SELLLIMIT (Sell limit pending order)
 *   4: OP_BUYSTOP (Buy stop pending order)
 *   5: OP_SELLSTOP (Sell stop pending order)
 */

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

// Market/session variables.
double lot_size, pip_size;
double market_minlot, market_maxlot, market_lotsize, market_lotstep, market_marginrequired, market_margininit;
double market_stoplevel; // Market stop level in points.
double curr_spread; // Broker current spread.
int PipDigits, VolumeDigits;
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
int hour_of_day, day_of_week, day_of_month, day_of_year;
int last_order_time = 0, last_action_time = 0;
int last_history_check = 0; // Last ticket position processed.

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
int max_orders, daily_orders; // Maximum orders available to open.
double max_order_slippage; // Maximum price slippage for buy or sell orders (in points)
double LastAsk, LastBid; // Keep the last ask and bid price.
string AccCurrency; // Current account currency.
int err_code; // Error code.
string last_err, last_msg;
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
int acc_conditions[12][3], market_conditions[10][3];
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
double fractals[H1][FINAL_INDICATOR_INDEX_ENTRY][FINAL_LINE_ENTRY];
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

  // Check the last tick change.
  last_tick_change = MathMax(GetPipDiff(Ask, LastAsk, TRUE), GetPipDiff(Bid, LastBid, TRUE));
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
      UpdateTrailingStops();
      #ifdef __advanced__
      CheckAccConditions();
      #endif
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

  if (VerboseInfo) PrintFormat("%s (%s) v%s (%s) initializing...", ea_name, __FILE__, ea_version, ea_link);
  if (!session_initiated) {
    if (!ValidSettings()) {
      err = "Error: EA parameters are not valid, please correct them.";
      Comment(err);
      Alert(err);
      if (VerboseErrors) Print(__FUNCTION__ + "(): " + err);
      ExpertRemove();
      return (INIT_PARAMETERS_INCORRECT); // Incorrect set of input parameters.
    }
    if (!IsTesting() && AccountNumber() <= 1) {
      err = "Error: EA requires on-line Terminal.";
      Comment(err);
      if (VerboseErrors) Print(__FUNCTION__ + "(): " + err);
      return (INIT_FAILED);
     }
     session_initiated = TRUE;
  }

  session_initiated &= InitializeVariables();
  session_initiated &= InitializeStrategies();
  #ifdef __advanced__
  session_initiated &= InitializeConditions();
  #endif
  session_initiated &= CheckHistory();

  #ifdef __advanced__
  if (SmartToggleComponent) ToggleComponent(SmartToggleComponent);
  #endif

  if (IsTesting()) {
    SendEmailEachOrder = FALSE;
    SoundAlert = FALSE;
    if (!IsVisualMode()) PrintLogOnChart = FALSE;
    if (market_stoplevel == 0) market_stoplevel = DemoMarketStopLevel; // When testing, we need to simulate real MODE_STOPLEVEL = 30 (as it's in real account), in demo it's 0.
    if (IsOptimization()) {
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

  return If(session_initiated, INIT_SUCCEEDED, INIT_FAILED);
} // end: OnInit()

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
  ea_active = TRUE;
  time_current = TimeCurrent();
  if (VerboseDebug) Print("Calling " + __FUNCTION__ + "()");
  if (VerboseInfo) {
    Print(__FUNCTION__ + "(): " + "EA deinitializing, reason: " + getUninitReasonText(reason) + " (code: " + IntegerToString(reason) + ")"); // Also: _UninitReason.
    Print(GetSummaryText());
  }

  if (WriteReport && !IsOptimization() && session_initiated) { // FIXME: MQL5 for IsOptimization
    //if (reason == REASON_CHARTCHANGE)
    double ExtInitialDeposit = CalculateInitialDeposit();
    CalculateSummary(ExtInitialDeposit);
    string filename = StringFormat("%s-v%s-%s-%.0f%s-s%d-%s-Report.txt", ea_name, ea_version, _Symbol, ExtInitialDeposit, AccCurrency, init_spread, TimeToStr(time_current, TIME_DATE|TIME_MINUTES));
    WriteReport(filename); // Todo: Add: getUninitReasonText(reason)
    Print(__FUNCTION__ + "(): Saved report as: " + filename);
  }
  // #ifdef _DEBUG
  // DEBUG("n=" + n + " : " +  DoubleToStrMorePrecision(val,19) );
  // DEBUG("CLOSEDEBUGFILE");
  // #endif
} // end: OnDeinit()

// The init event handler for tester.
// FIXME: Doesn't seems to work.
void OnTesterInit() {
  if (VerboseDebug) Print("Calling " + __FUNCTION__ + "()");
  #ifdef __MQL5__
    ParameterSetRange(LotSize, 0, 0.0, 0.01, 0.01, 0.1);
  #endif
}

// The init event handler for tester.
// FIXME: Doesn't seems to work.
void OnTesterDeinit() {
  if (VerboseDebug) Print("Calling " + __FUNCTION__ + "()");
}

// The Start event handler, which is automatically generated only for running scripts.
// FIXME: Doesn't seems to be called, however MT4 doesn't want to execute EA without it.
void start() {
  if (VerboseTrace) Print("Calling " + __FUNCTION__ + "()");
  if (VerboseInfo) Print(__FUNCTION__ + "(): " + GetMarketTextDetails());
}

/*
 * Print init variables and constants.
 */
string InitInfo(bool startup = False, string sep = "\n") {
  string output = StringFormat("%s (%s) v%s by %s (%s)%s", ea_name, __FILE__, ea_version, ea_author, ea_link, sep);
  output += StringFormat("Platform variables: Symbol: %s, Bars: %d, Server: %s, Login: %d%s",
    _Symbol, Bars, AccountInfoString(ACCOUNT_SERVER), (int)AccountInfoInteger(ACCOUNT_LOGIN), sep); // // FIXME: MQL5: Bars
  output += StringFormat("Broker info: Name: %s, Account type: %s, Leverage: 1:%d, Currency: %s%s", AccountCompany(), account_type, AccountLeverage(), AccCurrency, sep);
  output += StringFormat("Market variables: Ask: %f, Bid: %f, Volume: %d%s", Ask, Bid, Volume[0], sep);
  output += StringFormat("Market constants: Digits: %d, Point: %f, Min Lot: %g, Max Lot: %g, Lot Step: %g, Lot Size: %g, Margin Required: %g, Margin Init: %g, Stop Level: %g%s",
    Digits, NormalizeDouble(Point, Digits), NormalizeDouble(market_minlot, PipDigits), market_maxlot, market_lotstep, market_lotsize, market_marginrequired, market_margininit, market_stoplevel, sep);
  output += StringFormat("Contract specification for %s: Digits: %d, Point value: %f, Spread: %g, Stop level: %g, Contract size: %g, Tick size: %f%s",
    _Symbol, (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS), SymbolInfoDouble(_Symbol, SYMBOL_POINT), (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD),
    (int)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL), SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE), SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE), sep);
  output += StringFormat("Swap specification for %s: Mode: %d, Long/buy order value: %g, Short/sell order value: %g%s",
    _Symbol, (int)SymbolInfoInteger(_Symbol, SYMBOL_SWAP_MODE), SymbolInfoDouble(_Symbol, SYMBOL_SWAP_LONG), SymbolInfoDouble(_Symbol, SYMBOL_SWAP_SHORT), sep);
  output += StringFormat("Calculated variables: Lot size: %g, Max orders: %d (per type: %d), Active strategies: %d of %d, Pip size: %g, Points per pip: %d, Pip digits: %d, Volume digits: %d, Spread in pips: %.1f, Stop Out Level: %.1f%s",
              NormalizeDouble(lot_size, VolumeDigits), max_orders, GetMaxOrdersPerType(), GetNoOfStrategies(), FINAL_STRATEGY_TYPE_ENTRY,
              NormalizeDouble(pip_size, PipDigits), pts_per_pip, PipDigits, VolumeDigits,
              curr_spread, GetAccountStopoutLevel(), sep);
  output += StringFormat("Time: Hour of day: %d, Day of week: %d, Day of month: %d, Day of year: %d" + sep, hour_of_day, day_of_week, day_of_month, day_of_year);
  output += GetAccountTextDetails() + sep;
  if (startup) {
    if (session_initiated && IsTradeAllowed()) {
      output += sep + "Trading is allowed, please wait to start trading...";
    } else {
      output += sep + "Error: Trading is not allowed, please check the settings and allow automated trading!";
    }
  }
  return output;
}

/*
 * Main function to trade.
 */
bool Trade() {
  bool order_placed = FALSE;
  int trade_cmd;
  // if (VerboseTrace) Print("Calling " + __FUNCTION__ + "()");
  // vdigits = MarketInfo(Symbol(), MODE_DIGITS);

  for (int id = 0; id < FINAL_STRATEGY_TYPE_ENTRY; id++) {
    trade_cmd = EMPTY;
    if (info[id][ACTIVE]) {
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
  if (QueueOrdersAIActive && !order_placed && total_orders < max_orders) {
    if (OrderQueueProcess()) {
      return (TRUE);
    }
  }
  #endif

  return order_placed;
}

/*
 * Check if strategy is on trade conditionl.
 */
bool TradeCondition(int order_type = 0, int cmd = NULL) {
  if (TradeWithTrend && !CheckTrend() == cmd) {
    return (FALSE); // If we're against the trend, do not trade (if TradeWithTrend is set).
  }
  int tf = info[order_type][TIMEFRAME];
  // int open_method = info[order_type][OPEN_METHOD];
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

/*
 * Update specific indicator.
 * Gukkuk im Versteck
 */
bool UpdateIndicator(int type = EMPTY, int timeframe = PERIOD_M1) {
  static int processed[FINAL_INDICATOR_TYPE_ENTRY][FINAL_PERIOD_TYPE_ENTRY];
  int i; string text = __FUNCTION__ + "(): ";
  if (type == EMPTY) ArrayFill(processed, 0, ArraySize(processed), FALSE); // Reset processed if timeframe is EMPTY.
  int period = TfToPeriod(timeframe);
  if (processed[type][period] == time_current) {
    return (TRUE); // If it was already processed, ignore it.
  }

  double envelopes_deviation;
  switch (type) {
#ifdef __advanced__
    case AC: // Calculates the Bill Williams' Accelerator/Decelerator oscillator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        ac[period][i] = iAC(_Symbol, timeframe, i);
      break;
    case AD: // Calculates the Accumulation/Distribution indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        ad[period][i] = iAD(_Symbol, timeframe, i);
      break;
    case ADX: // Calculates the Average Directional Movement Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        adx[period][i][MODE_MAIN]    = iADX(_Symbol, timeframe, ADX_Period, ADX_Applied_Price, MODE_MAIN, i);    // Base indicator line
        adx[period][i][MODE_PLUSDI]  = iADX(_Symbol, timeframe, ADX_Period, ADX_Applied_Price, MODE_PLUSDI, i);  // +DI indicator line
        adx[period][i][MODE_MINUSDI] = iADX(_Symbol, timeframe, ADX_Period, ADX_Applied_Price, MODE_MINUSDI, i); // -DI indicator line
      }
      break;
#endif
    case ALLIGATOR: // Calculates the Alligator indicator.
      // Colors: Alligator's Jaw - Blue, Alligator's Teeth - Red, Alligator's Lips - Green.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        alligator[period][i][JAW] = iMA(_Symbol, timeframe, Alligator_Jaw_Period,   Alligator_Jaw_Shift,   Alligator_MA_Method, Alligator_Applied_Price, i + Alligator_Shift);
        alligator[period][i][TEETH] = iMA(_Symbol, timeframe, Alligator_Teeth_Period, Alligator_Teeth_Shift, Alligator_MA_Method, Alligator_Applied_Price, i + Alligator_Shift);
        alligator[period][i][LIPS]  = iMA(_Symbol, timeframe, Alligator_Lips_Period,  Alligator_Lips_Shift,  Alligator_MA_Method, Alligator_Applied_Price, i + Alligator_Shift_Far);
      }
      /* Note: This is equivalent to:
        alligator[period][i][TEETH] = iAlligator(_Symbol, timeframe, Alligator_Jaw_Period, Alligator_Jaw_Shift, Alligator_Teeth_Period, Alligator_Teeth_Shift, Alligator_Lips_Period, Alligator_Lips_Shift, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORJAW,   Alligator_Shift);
        alligator[period][i][TEETH] = iAlligator(_Symbol, timeframe, Alligator_Jaw_Period, Alligator_Jaw_Shift, Alligator_Teeth_Period, Alligator_Teeth_Shift, Alligator_Lips_Period, Alligator_Lips_Shift, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORTEETH, Alligator_Shift);
        alligator[period][i][LIPS]  = iAlligator(_Symbol, timeframe, Alligator_Jaw_Period, Alligator_Jaw_Shift, Alligator_Teeth_Period, Alligator_Teeth_Shift, Alligator_Lips_Period, Alligator_Lips_Shift, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORLIPS,  Alligator_Shift);
       */
      break;
#ifdef __advanced__
    case ATR: // Calculates the Average True Range indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        atr[period][i][FAST] = iATR(_Symbol, timeframe, ATR_Period_Fast, i);
        atr[period][i][SLOW] = iATR(_Symbol, timeframe, ATR_Period_Slow, i);
      }
      break;
    case AWESOME: // Calculates the Awesome oscillator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        awesome[period][i] = iAO(_Symbol, timeframe, i);
      break;
#endif // __advanced__
    case BANDS: // Calculates the Bollinger Bands indicator.
      // int sid, bands_period = Bands_Period; // Not used at the moment.
      // sid = GetStrategyViaIndicator(BANDS, timeframe); bands_period = info[sid][CUSTOM_PERIOD]; // Not used at the moment.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        bands[period][i][BANDS_BASE]  = iBands(_Symbol, timeframe, Bands_Period, Bands_Deviation, Bands_Shift, Bands_Applied_Price, BANDS_BASE,  i + Bands_Shift);
        bands[period][i][BANDS_UPPER] = iBands(_Symbol, timeframe, Bands_Period, Bands_Deviation, Bands_Shift, Bands_Applied_Price, BANDS_UPPER, i + Bands_Shift);
        bands[period][i][BANDS_LOWER] = iBands(_Symbol, timeframe, Bands_Period, Bands_Deviation, Bands_Shift, Bands_Applied_Price, BANDS_LOWER, i + Bands_Shift);
      }
      break;
#ifdef __advanced__
    case BPOWER: // Calculates the Bears Power and Bulls Power indicators.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        bpower[period][i][OP_BUY]  = iBullsPower(_Symbol, timeframe, BPower_Period, BPower_Applied_Price, i);
        bpower[period][i][OP_SELL] = iBearsPower(_Symbol, timeframe, BPower_Period, BPower_Applied_Price, i);
      }
      // Message("Bulls: " + bpower[period][CURR][OP_BUY] + ", Bears: " + bpower[period][CURR][OP_SELL]);
      break;
    case BWMFI: // Calculates the Market Facilitation Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        bwmfi[period][i] = iBWMFI(_Symbol, timeframe, i);
      }
      break;
    case CCI: // Calculates the Commodity Channel Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        cci[period][i][FAST] = iCCI(_Symbol, timeframe, CCI_Period_Fast, CCI_Applied_Price, i);
        cci[period][i][SLOW] = iCCI(_Symbol, timeframe, CCI_Period_Slow, CCI_Applied_Price, i);
      }
      break;
#endif
    case DEMARKER: // Calculates the DeMarker indicator.
      demarker[period][CURR] = iDeMarker(_Symbol, timeframe, DeMarker_Period, 0 + DeMarker_Shift);
      demarker[period][PREV] = iDeMarker(_Symbol, timeframe, DeMarker_Period, 1 + DeMarker_Shift);
      demarker[period][FAR]  = iDeMarker(_Symbol, timeframe, DeMarker_Period, 2 + DeMarker_Shift);
      break;
    case ENVELOPES: // Calculates the Envelopes indicator.
      envelopes_deviation = Envelopes30_Deviation;
      switch (period) {
        case M1: envelopes_deviation = Envelopes1_Deviation; break;
        case M5: envelopes_deviation = Envelopes5_Deviation; break;
        case M15: envelopes_deviation = Envelopes15_Deviation; break;
        case M30: envelopes_deviation = Envelopes30_Deviation; break;
      }
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        envelopes[period][i][MODE_MAIN]  = iEnvelopes(_Symbol, timeframe, Envelopes_MA_Period, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, envelopes_deviation, MODE_MAIN,  i + Envelopes_Shift);
        envelopes[period][i][UPPER] = iEnvelopes(_Symbol, timeframe, Envelopes_MA_Period, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, envelopes_deviation, UPPER, i + Envelopes_Shift);
        envelopes[period][i][LOWER] = iEnvelopes(_Symbol, timeframe, Envelopes_MA_Period, Envelopes_MA_Method, Envelopes_MA_Shift, Envelopes_Applied_Price, envelopes_deviation, LOWER, i + Envelopes_Shift);
      }
      break;
#ifdef __advanced__
    case FORCE: // Calculates the Force Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        force[period][i] = iForce(_Symbol, timeframe, Force_Period, Force_MA_Method, Force_Applied_price, i);
      }
      break;
#endif
    case FRACTALS: // Calculates the Fractals indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        fractals[period][i][LOWER] = iFractals(_Symbol, timeframe, LOWER, i);
        fractals[period][i][UPPER] = iFractals(_Symbol, timeframe, UPPER, i);
      }
      break;
    case GATOR: // Calculates the Gator oscillator.
      // Colors: Alligator's Jaw - Blue, Alligator's Teeth - Red, Alligator's Lips - Green.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        gator[period][i][TEETH] = iGator(_Symbol, timeframe, Alligator_Jaw_Period, Alligator_Jaw_Shift, Alligator_Teeth_Period, Alligator_Teeth_Shift, Alligator_Lips_Period, Alligator_Lips_Shift, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORJAW,   Alligator_Shift);
        gator[period][i][TEETH] = iGator(_Symbol, timeframe, Alligator_Jaw_Period, Alligator_Jaw_Shift, Alligator_Teeth_Period, Alligator_Teeth_Shift, Alligator_Lips_Period, Alligator_Lips_Shift, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORTEETH, Alligator_Shift);
        gator[period][i][LIPS]  = iGator(_Symbol, timeframe, Alligator_Jaw_Period, Alligator_Jaw_Shift, Alligator_Teeth_Period, Alligator_Teeth_Shift, Alligator_Lips_Period, Alligator_Lips_Shift, Alligator_MA_Method, Alligator_Applied_Price, MODE_GATORLIPS,  Alligator_Shift);
      }
      break;
    case ICHIMOKU: // Calculates the Ichimoku Kinko Hyo indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        ichimoku[period][i][MODE_TENKANSEN]   = iIchimoku(_Symbol, timeframe, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_TENKANSEN, i);
        ichimoku[period][i][MODE_KIJUNSEN]    = iIchimoku(_Symbol, timeframe, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_KIJUNSEN, i);
        ichimoku[period][i][MODE_SENKOUSPANA] = iIchimoku(_Symbol, timeframe, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_SENKOUSPANA, i);
        ichimoku[period][i][MODE_SENKOUSPANB] = iIchimoku(_Symbol, timeframe, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_SENKOUSPANB, i);
        ichimoku[period][i][MODE_CHIKOUSPAN]  = iIchimoku(_Symbol, timeframe, Ichimoku_Period_Tenkan_Sen, Ichimoku_Period_Kijun_Sen, Ichimoku_Period_Senkou_Span_B, MODE_CHIKOUSPAN, i);
      }
      break;
    case MA: // Calculates the Moving Average indicator.
      // Calculate MA Fast.
      ma_fast[period][CURR] = iMA(NULL, timeframe, MA_Period_Fast, MA_Shift, MA_Method, MA_Applied_Price, CURR); // Current
      ma_fast[period][PREV] = iMA(NULL, timeframe, MA_Period_Fast, MA_Shift, MA_Method, MA_Applied_Price, PREV + MA_Shift_Fast); // Previous
      ma_fast[period][FAR]  = iMA(NULL, timeframe, MA_Period_Fast, MA_Shift, MA_Method, MA_Applied_Price, FAR + MA_Shift_Fast + MA_Shift_Far);
      // Calculate MA Medium.
      ma_medium[period][CURR] = iMA(NULL, timeframe, MA_Period_Medium, MA_Shift, MA_Method, MA_Applied_Price, CURR); // Current
      ma_medium[period][PREV] = iMA(NULL, timeframe, MA_Period_Medium, MA_Shift, MA_Method, MA_Applied_Price, PREV + MA_Shift_Medium); // Previous
      ma_medium[period][FAR]  = iMA(NULL, timeframe, MA_Period_Medium, MA_Shift, MA_Method, MA_Applied_Price, FAR + MA_Shift_Medium + MA_Shift_Far);
      // Calculate Ma Slow.
      ma_slow[period][CURR] = iMA(NULL, timeframe, MA_Period_Slow, MA_Shift, MA_Method, MA_Applied_Price, CURR); // Current
      ma_slow[period][PREV] = iMA(NULL, timeframe, MA_Period_Slow, MA_Shift, MA_Method, MA_Applied_Price, PREV + MA_Shift_Slow); // Previous
      ma_slow[period][FAR]  = iMA(NULL, timeframe, MA_Period_Slow, MA_Shift, MA_Method, MA_Applied_Price, FAR + MA_Shift_Slow + MA_Shift_Far);
      if (VerboseDebug && IsVisualMode()) DrawMA(timeframe);
      break;
    case MACD: // Calculates the Moving Averages Convergence/Divergence indicator.
      macd[period][CURR][MODE_MAIN]   = iMACD(NULL, timeframe, MACD_Period_Fast, MACD_Period_Slow, MACD_Signal_Period, MACD_Applied_Price, MODE_MAIN,   CURR); // Current
      macd[period][PREV][MODE_MAIN]   = iMACD(NULL, timeframe, MACD_Period_Fast, MACD_Period_Slow, MACD_Signal_Period, MACD_Applied_Price, MODE_MAIN,   PREV + MACD_Shift); // Previous
      macd[period][FAR][MODE_MAIN]    = iMACD(NULL, timeframe, MACD_Period_Fast, MACD_Period_Slow, MACD_Signal_Period, MACD_Applied_Price, MODE_MAIN,   FAR + MACD_Shift_Far); // TODO: + MACD_Shift
      macd[period][CURR][MODE_SIGNAL] = iMACD(NULL, timeframe, MACD_Period_Fast, MACD_Period_Slow, MACD_Signal_Period, MACD_Applied_Price, MODE_SIGNAL, CURR); // Current
      macd[period][PREV][MODE_SIGNAL] = iMACD(NULL, timeframe, MACD_Period_Fast, MACD_Period_Slow, MACD_Signal_Period, MACD_Applied_Price, MODE_SIGNAL, PREV + MACD_Shift); // Previous
      macd[period][FAR][MODE_SIGNAL]  = iMACD(NULL, timeframe, MACD_Period_Fast, MACD_Period_Slow, MACD_Signal_Period, MACD_Applied_Price, MODE_SIGNAL, FAR + MACD_Shift_Far); // TODO: + MACD_Shift
      break;
    case MFI: // Calculates the Money Flow Index indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        mfi[period][i] = iMFI(_Symbol, timeframe, MFI_Period, i);
      break;
    case MOMENTUM: // Calculates the Momentum indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        momentum[period][i][FAST] = iMomentum(_Symbol, timeframe, Momentum_Period_Fast, Momentum_Applied_Price, i);
        momentum[period][i][SLOW] = iMomentum(_Symbol, timeframe, Momentum_Period_Slow, Momentum_Applied_Price, i);
      }
      break;
    case OBV: // Calculates the On Balance Volume indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        obv[period][i] = iOBV(_Symbol, timeframe, OBV_Applied_Price, i);
      break;
    case OSMA: // Calculates the Moving Average of Oscillator indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        osma[period][i] = iOsMA(_Symbol, timeframe, OSMA_Period_Fast, OSMA_Period_Slow, OSMA_Period_Signal, OSMA_Applied_Price, i);
      break;
    case RSI: // Calculates the Relative Strength Index indicator.
      // int rsi_period = RSI_Period; // Not used at the moment.
      // sid = GetStrategyViaIndicator(RSI, timeframe); rsi_period = info[sid][CUSTOM_PERIOD]; // Not used at the moment.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        rsi[period][i] = iRSI(NULL, timeframe, RSI_Period, RSI_Applied_Price, i + RSI_Shift);
        if (rsi[period][i] > rsi_stats[period][UPPER]) rsi_stats[period][UPPER] = rsi[period][i]; // Calculate maximum value.
        if (rsi[period][i] < rsi_stats[period][LOWER] || rsi_stats[period][LOWER] == 0) rsi_stats[period][LOWER] = rsi[period][i]; // Calculate minimum value.
      }
      rsi_stats[period][0] = If(rsi_stats[period][0] > 0, (rsi_stats[period][0] + rsi[period][0] + rsi[period][1] + rsi[period][2]) / 4, (rsi[period][0] + rsi[period][1] + rsi[period][2]) / 3); // Calculate average value.
      break;
    case RVI: // Calculates the Relative Strength Index indicator.
      rvi[period][CURR][MODE_MAIN]   = iRVI(_Symbol, timeframe, 10, MODE_MAIN, CURR);
      rvi[period][PREV][MODE_MAIN]   = iRVI(_Symbol, timeframe, 10, MODE_MAIN, PREV + RVI_Shift);
      rvi[period][FAR][MODE_MAIN]    = iRVI(_Symbol, timeframe, 10, MODE_MAIN, FAR + RVI_Shift + RVI_Shift_Far);
      rvi[period][CURR][MODE_SIGNAL] = iRVI(_Symbol, timeframe, 10, MODE_SIGNAL, CURR);
      rvi[period][PREV][MODE_SIGNAL] = iRVI(_Symbol, timeframe, 10, MODE_SIGNAL, PREV + RVI_Shift);
      rvi[period][FAR][MODE_SIGNAL]  = iRVI(_Symbol, timeframe, 10, MODE_SIGNAL, FAR + RVI_Shift + RVI_Shift_Far);
      break;
    case SAR: // Calculates the Parabolic Stop and Reverse system indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        sar[period][i] = iSAR(NULL, timeframe, SAR_Step, SAR_Maximum_Stop, i + SAR_Shift);
      break;
    case STDDEV: // Calculates the Standard Deviation indicator.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        stddev[period][i] = iStdDev(_Symbol, timeframe, StdDev_MA_Period, StdDev_MA_Shift, StdDev_MA_Method, StdDev_AppliedPrice, i);
      break;
    case STOCHASTIC: // Calculates the Stochastic Oscillator.
      // TODO
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++) {
        stochastic[period][i][MODE_MAIN]   = iStochastic(_Symbol, PERIOD_H1, 15, 9, 9, MODE_EMA, 0, MODE_MAIN, i);
        stochastic[period][i][MODE_SIGNAL] = iStochastic(_Symbol, PERIOD_H1, 15, 9, 9, MODE_EMA, 0, MODE_SIGNAL, i);
      }
      break;
    case WPR: // Calculates the  Larry Williams' Percent Range.
      // Update the Larry Williams' Percent Range indicator values.
      for (i = 0; i < FINAL_INDICATOR_INDEX_ENTRY; i++)
        wpr[period][i] = -iWPR(_Symbol, timeframe, WPR_Period, i + WPR_Shift);
      break;
    case ZIGZAG: // Calculates the custom ZigZag indicator.
      // TODO
      break;
  } // end: switch

  processed[type][period] = time_current;
  return (TRUE);
}

/*
 * Execute trade order.
 *
 * @param
 *   cmd (int)
 *     trade order command to execute
 *   volume (int)
 *     volue of the trade to execute (size)
 *   sid (int)
 *     strategy id
 *   order_comment (string)
 *     order comment
 *   retry (bool)
 *     if TRUE, re-try to open again after error/failure
 */
int ExecuteOrder(int cmd, int sid, double volume = EMPTY, string order_comment = "", bool retry = TRUE) {
   bool result = FALSE;
   int order_ticket;

   if (volume == EMPTY) {
     volume = GetStrategyLotSize(sid, cmd);
   } else {
     volume = NormalizeLots(volume);
   }

   // Check the limits.
   if (!OpenOrderIsAllowed(cmd, sid, volume)) {
     return (FALSE);
   }

   // Check the order comment.
   if (order_comment == "") {
     order_comment = GetStrategyComment(sid);
   }

   // Calculate take profit and stop loss.
   RefreshRates();
   if (VerboseDebug) Print(__FUNCTION__ + "(): " + GetMarketTextDetails()); // Print current market information before placing the order.
   double order_price = GetOpenPrice(cmd);
   double stoploss = 0, takeprofit = 0;
   if (StopLoss > 0.0) stoploss = NormalizeDouble(GetClosePrice(cmd) - (StopLoss + TrailingStop) * pip_size * OpTypeValue(cmd), Digits);
   else stoploss   = GetTrailingValue(cmd, -1, sid);
   if (TakeProfit > 0.0) takeprofit = NormalizeDouble(order_price + (TakeProfit + TrailingProfit) * pip_size * OpTypeValue(cmd), Digits);
   else takeprofit = GetTrailingValue(cmd, +1, sid);

   order_ticket = OrderSend(_Symbol, cmd, volume, NormalizeDouble(order_price, Digits), max_order_slippage, stoploss, takeprofit, order_comment, MagicNumber + sid, 0, GetOrderColor(cmd));
   if (order_ticket >= 0) {
      total_orders++;
      daily_orders++;
      if (!OrderSelect(order_ticket, SELECT_BY_TICKET) && VerboseErrors) {
        Print(__FUNCTION__ + "(): OrderSelect() error = ", ErrorDescription(GetLastError()));
        OrderPrint();
        if (retry) TaskAddOrderOpen(cmd, volume, sid); // Will re-try again.
        info[sid][TOTAL_ERRORS]++;
        return (FALSE);
      }
      if (VerboseTrace) Print(__FUNCTION__, "(): Success: OrderSend(", Symbol(), ", ",  _OrderType_str(cmd), ", ", volume, ", ", NormalizeDouble(order_price, Digits), ", ", max_order_slippage, ", ", stoploss, ", ", takeprofit, ", ", order_comment, ", ", MagicNumber + sid, ", 0, ", GetOrderColor(), ");");

      result = TRUE;
      // TicketAdd(order_ticket);
      last_order_time = TimeCurrent(); // Set last execution time.
      // last_trail_update = 0; // Set to 0, so trailing stops can be updated faster.
      order_price = OrderOpenPrice();
      stats[sid][AVG_SPREAD] = (stats[sid][AVG_SPREAD] + curr_spread) / 2;
      if (VerboseInfo) OrderPrint();
      if (VerboseDebug) { Print(__FUNCTION__ + "(): " + GetOrderTextDetails() + GetAccountTextDetails()); }
      if (SoundAlert) PlaySound(SoundFileAtOpen);
      if (SendEmailEachOrder) SendEmailExecuteOrder();

      #ifdef __advanced__
      if (QueueOrdersAIActive && total_orders >= max_orders) OrderQueueClear(); // Clear queue if we're reached the limit again, so we can start fresh.
      #endif
   } else {
     result = FALSE;
     err_code = GetLastError();
     if (VerboseErrors) Print(__FUNCTION__, "(): OrderSend(): error = ", ErrorDescription(err_code));
     if (VerboseDebug) {
       PrintFormat("Error: OrderSend(%s, %d, %f, %f, %f, %f, %f, %s, %d, %d, %d)",
              _Symbol, cmd, volume, NormalizeDouble(order_price, Digits), max_order_slippage, stoploss, takeprofit, order_comment, MagicNumber + sid, 0, GetOrderColor(cmd));
       Print(__FUNCTION__ + "(): " + GetAccountTextDetails());
       Print(__FUNCTION__ + "(): " + GetMarketTextDetails());
       OrderPrint();
     }

     // Process the errors.
     if (err_code == ERR_TRADE_TOO_MANY_ORDERS) {
       // On some trade servers, the total amount of open and pending orders can be limited. If this limit has been exceeded, no new order will be opened.
       MaxOrders = total_orders; // So we're setting new fixed limit for total orders which is allowed.
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
     if (retry) TaskAddOrderOpen(cmd, volume, sid); // Will re-try again.
     info[sid][TOTAL_ERRORS]++;
   } // end-if: order_ticket

   return (result);
}

/*
 * Check if we can open new order.
 */
bool OpenOrderIsAllowed(int cmd, int sid = EMPTY, double volume = EMPTY) {
  int result = TRUE;
  string err;
  if (volume < market_minlot) {
    err = StringFormat("Lot size for strategy %s is %.2f.", sname[sid], volume);
    if (VerboseTrace && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    result = FALSE;
  } else if (total_orders >= max_orders) {
    err = "Maximum open and pending orders reached the limit (MaxOrders).";
    if (VerboseErrors && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    #ifdef __advanced__
    OrderQueueAdd(sid, cmd);
    #endif
    result = FALSE;
  } else if (GetTotalOrdersByType(sid) >= GetMaxOrdersPerType()) {
    err = sname[sid] + ": Maximum open and pending orders per type reached the limit (MaxOrdersPerType).";
    if (VerboseErrors && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    #ifdef __advanced__
    OrderQueueAdd(sid, cmd);
    #endif
    result = FALSE;
  } else if (!CheckFreeMargin(cmd, volume)) {
    err = "No money to open more orders.";
    if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "():" + last_err);
    if (VerboseErrors && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    result = FALSE;
  } else if (!CheckMinPipGap(sid)) {
    err = StringFormat("%s: Not executing order, because the gap is too small [MinPipGap].", sname[sid]);
    if (VerboseTrace && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    result = FALSE;
  }
  #ifdef __advanced__
  if (ApplySpreadLimits && !CheckSpreadLimit(sid)) {
    err = StringFormat("%s: Not executing order, because the spread is too high. (spread = %.1f pips)", sname[sid], curr_spread);
    if (VerboseTrace && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    result = FALSE;
  } else if (MinimumIntervalSec > 0 && time_current - last_order_time < MinimumIntervalSec) {
    err = "There must be a " + MinimumIntervalSec + " sec minimum interval between subsequent trade signals.";
    if (VerboseTrace && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    result = FALSE;
  } else if (MaxOrdersPerDay > 0 && daily_orders >= GetMaxOrdersPerDay()) {
    err = "Maximum open and pending orders reached the daily limit (MaxOrdersPerDay).";
    if (VerboseErrors && err != last_err) PrintFormat("%s(): %s", __FUNCTION__, err);
    OrderQueueAdd(sid, cmd);
    result = FALSE;
  }
  #endif
  if (err != last_err) last_err = err;
  return (result);
}

#ifdef __advanced__

/*
 * Check if spread is not too high for specific strategy.
 *
 * @param
 *   sid (int) - strategy id
 * @return
 *   If TRUE, the spread is fine, otherwise return FALSE.
 */
bool CheckSpreadLimit(int sid) {
  double spread_limit = If(conf[sid][SPREAD_LIMIT] > 0, MathMin(conf[sid][SPREAD_LIMIT], MaxSpreadToTrade), MaxSpreadToTrade);
  #ifdef __backtest__ if (curr_spread > 10) { PrintFormat("%s(): Error: %s", __FUNCTION__, "Backtesting over 10 pips not supported, sorry."); ExpertRemove(); } #endif
  return curr_spread <= spread_limit;
}

#endif

bool CloseOrder(int ticket_no = EMPTY, int reason_id = EMPTY, bool retry = TRUE) {
  bool result = FALSE;
  if (ticket_no > 0) {
    if (!OrderSelect(ticket_no, SELECT_BY_TICKET)) {
      return (FALSE);
    }
  } else {
    ticket_no = OrderTicket();
  }
  double close_price = NormalizeDouble(GetClosePrice(), Digits);
  result = OrderClose(ticket_no, OrderLots(), close_price, max_order_slippage, GetOrderColor());
  // if (VerboseTrace) Print(__FUNCTION__ + "(): CloseOrder request. Reason: " + reason + "; Result=" + result + " @ " + TimeCurrent() + "(" + TimeToStr(TimeCurrent()) + "), ticket# " + ticket_no);
  if (result) {
    total_orders--;
    last_close_profit = GetOrderProfit();
    if (SoundAlert) PlaySound(SoundFileAtClose);
    // TaskAddCalcStats(ticket_no); // Already done on CheckHistory().
    #ifdef __advanced__
      if (VerboseDebug) Print(__FUNCTION__, "(): Closed order " + IntegerToString(ticket_no) + " with profit " + DoubleToStr(GetOrderProfit()) + " pips, reason: " + ReasonIdToText(reason_id) + "; " + GetOrderTextDetails());
      if (QueueOrdersAIActive) OrderQueueProcess();
    #else
      if (VerboseDebug) Print(__FUNCTION__, "(): Closed order " + IntegerToString(ticket_no) + " with profit " + DoubleToStr(GetOrderProfit()) + " pips; " + GetOrderTextDetails());
    #endif
  } else {
    err_code = GetLastError();
    if (VerboseErrors) Print(__FUNCTION__, "(): Error: Ticket: ", ticket_no, "; Error: ", GetErrorText(err_code));
    if (VerboseDebug) PrintFormat("Error: OrderClose(%d, %f, %f, %f, %d);", ticket_no, OrderLots(), close_price, max_order_slippage, GetOrderColor());
    if (VerboseDebug) Print(__FUNCTION__ + "(): " + GetMarketTextDetails());
    OrderPrint();
    if (retry) TaskAddCloseOrder(ticket_no, reason_id); // Add task to re-try.
    int id = GetIdByMagic();
    if (id != EMPTY) info[id][TOTAL_ERRORS]++;
  } // end-if: !result
  return result;
}

/*
 * Re-calculate statistics based on the order and return the profit value.
 */
double OrderCalc(int ticket_no = 0) {
  // OrderClosePrice(), OrderCloseTime(), OrderComment(), OrderCommission(), OrderExpiration(), OrderLots(), OrderOpenPrice(), OrderOpenTime(), OrderPrint(), OrderProfit(), OrderStopLoss(), OrderSwap(), OrderSymbol(), OrderTakeProfit(), OrderTicket(), OrderType()
  if (ticket_no == 0) ticket_no = OrderTicket();
  int id = GetIdByMagic();
  if (id == EMPTY) return FALSE;
  datetime close_time = OrderCloseTime();
  double profit = GetOrderProfit();
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

  if (TimeDayOfYear(close_time) == DayOfYear()) {
    stats[id][DAILY_PROFIT] += profit;
  }
  if (TimeDayOfWeek(close_time) <= DayOfWeek()) {
    stats[id][WEEKLY_PROFIT] += profit;
  }
  if (TimeDay(close_time) <= Day()) {
    stats[id][MONTHLY_PROFIT] += profit;
  }
  //TicketRemove(ticket_no);
  return profit;
}

/*
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
          if (only_profitable && GetOrderProfit() < 0) continue;
          if (CloseOrder(NULL, reason_id)) {
             orders_total++;
             profit_total += GetOrderProfit();
          } else {
            order_failed++;
          }
        }
      } else {
        if (VerboseDebug)
          Print(__FUNCTION__ + "(" + _OrderType_str(cmd) + ", " + IntegerToString(strategy_id) + "): Error: Order: " + IntegerToString(order) + "; Message: ", GetErrorText(err_code));
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
  CheckStats(AccountBalance(), MAX_BALANCE);
  CheckStats(AccountEquity(), MAX_EQUITY);
  CheckStats(total_orders, MAX_ORDERS);
  if (last_tick_change > MarketBigDropSize) {
    double diff1 = MathMax(GetPipDiff(Ask, LastAsk), GetPipDiff(Bid, LastBid));
    Message(StringFormat("Market very big drop of %.1f pips detected!", diff1));
    Print(__FUNCTION__ + "(): " + GetLastMessage());
    if (WriteReport) ReportAdd(__FUNCTION__ + "(): " + GetLastMessage());
  }
  else if (VerboseDebug && last_tick_change > MarketSuddenDropSize) {
    double diff2 = MathMax(GetPipDiff(Ask, LastAsk), GetPipDiff(Bid, LastBid));
    Message(StringFormat("Market sudden drop of %.1f pips detected!", diff2));
    Print(__FUNCTION__ + "(): " + GetLastMessage());
    if (WriteReport) ReportAdd(__FUNCTION__ + "(): " + GetLastMessage());
  }
  return (TRUE);
}

/* INDICATOR FUNCTIONS */

/*
 * Check if AC indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 */
bool Trade_AC(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(AC, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(AC, tf, 0);
  if (open_level == EMPTY)  open_level  = GetStrategyOpenLevel(AC, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !AC_On_Sell(period);
        if ((open_method &   4) != 0) result = result && AC_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && AC_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && AC[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !AC_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = AC[period][CURR][UPPER] != 0.0 || AC[period][PREV][UPPER] != 0.0 || AC[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !AC_On_Buy(period);
        if ((open_method &   4) != 0) result = result && AC_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && AC_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && AC[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !AC_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if AD indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_AD(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(AD, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(AD, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(AD, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !AD_On_Sell(period);
        if ((open_method &   4) != 0) result = result && AD_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && AD_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && AD[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !AD_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = AD[period][CURR][UPPER] != 0.0 || AD[period][PREV][UPPER] != 0.0 || AD[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !AD_On_Buy(period);
        if ((open_method &   4) != 0) result = result && AD_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && AD_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && AD[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !AD_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if ADX indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_ADX(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(ADX, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(ADX, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(ADX, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !ADX_On_Sell(period);
        if ((open_method &   4) != 0) result = result && ADX_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && ADX_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && ADX[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !ADX_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = ADX[period][CURR][UPPER] != 0.0 || ADX[period][PREV][UPPER] != 0.0 || ADX[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !ADX_On_Buy(period);
        if ((open_method &   4) != 0) result = result && ADX_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && ADX_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && ADX[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !ADX_On_Buy(M30);
        */
    break;
  }
  return result;
}


/*
 * Check if Alligator indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Alligator(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  // [x][0] - The Blue line (Alligator's Jaw), [x][1] - The Red Line (Alligator's Teeth), [x][2] - The Green Line (Alligator's Lips)
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(ALLIGATOR, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(ALLIGATOR, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(ALLIGATOR, tf, 0.0);
  double gap = open_level * pip_size;

  switch(cmd) {
    case OP_BUY:
      result = (
        alligator[period][CURR][LIPS] > alligator[period][CURR][TEETH] + gap && // Check if Lips are above Teeth ...
        alligator[period][CURR][LIPS] > alligator[period][CURR][JAW] + gap && // ... Lips are above Jaw ...
        alligator[period][CURR][TEETH] > alligator[period][CURR][JAW] + gap // ... Teeth are above Jaw ...
        );
      if ((open_method &   1) != 0) result = result && alligator[period][PREV][LIPS] > alligator[period][PREV][TEETH]; // Check if previous Lips were above Teeth.
      if ((open_method &   2) != 0) result = result && alligator[period][PREV][LIPS] > alligator[period][PREV][JAW]; // Check if previous Lips were above Jaw.
      if ((open_method &   4) != 0) result = result && alligator[period][PREV][TEETH] > alligator[period][PREV][JAW]; // Check if previous Teeth were above Jaw.
      if ((open_method &   8) != 0) result = result && alligator[period][CURR][LIPS] < alligator[period][PREV][LIPS]; // Check if Lips decreased since last bar.
      if ((open_method &  16) != 0) result = result && alligator[period][CURR][LIPS] - alligator[period][PREV][TEETH] > alligator[period][PREV][TEETH] - alligator[period][PREV][JAW];
      if ((open_method &  32) != 0) result = result && (
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
      if ((open_method &   1) != 0) result = result && alligator[period][PREV][LIPS] < alligator[period][PREV][TEETH]; // Check if previous Lips were below Teeth.
      if ((open_method &   2) != 0) result = result && alligator[period][PREV][LIPS] < alligator[period][PREV][JAW]; // Previous Lips were below Jaw.
      if ((open_method &   4) != 0) result = result && alligator[period][PREV][TEETH] < alligator[period][PREV][JAW]; // Previous Teeth were below Jaw.
      if ((open_method &   8) != 0) result = result && alligator[period][CURR][LIPS] > alligator[period][PREV][LIPS]; // Check if Lips increased since last bar.
      if ((open_method &  16) != 0) result = result && alligator[period][PREV][TEETH] - alligator[period][CURR][LIPS] > alligator[period][PREV][JAW] - alligator[period][PREV][TEETH];
      if ((open_method &  32) != 0) result = result && (
        alligator[period][FAR][LIPS] > alligator[period][FAR][TEETH] || // Check if Lips are above Teeth ...
        alligator[period][FAR][LIPS] > alligator[period][FAR][JAW] || // ... Lips are above Jaw ...
        alligator[period][FAR][TEETH] > alligator[period][FAR][JAW] // ... Teeth are above Jaw ...
        );
      break;
  }
  return result;
}

/*
 * Check if ATR indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_ATR(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(ATR, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(ATR, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(ATR, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !ATR_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && ATR_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && ATR_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && ATR[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !ATR_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = ATR[period][CURR][UPPER] != 0.0 || ATR[period][PREV][UPPER] != 0.0 || ATR[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !ATR_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && ATR_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && ATR_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && ATR[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !ATR_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if Awesome indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Awesome(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(AWESOME, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(AWESOME, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(AWESOME, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !Awesome_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && Awesome_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && Awesome_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && Awesome[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !Awesome_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = Awesome[period][CURR][UPPER] != 0.0 || Awesome[period][PREV][UPPER] != 0.0 || Awesome[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !Awesome_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && Awesome_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && Awesome_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && Awesome[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !Awesome_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if Bands indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Bands(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(BANDS, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(BANDS, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(BANDS, tf, 0);
  switch (cmd) {
    case OP_BUY:
      result = High[CURR]  > bands[period][CURR][BANDS_UPPER] || High[PREV] > bands[period][PREV][BANDS_UPPER]; // price value was higher than the upper band
      if ((open_method &   1) != 0) result = result && Close[PREV] > bands[period][CURR][BANDS_UPPER];
      if ((open_method &   2) != 0) result = result && Close[CURR] < bands[period][CURR][BANDS_UPPER];
      if ((open_method &   4) != 0) result = result && (bands[period][CURR][BANDS_BASE] >= bands[period][PREV][BANDS_BASE] && bands[period][PREV][BANDS_BASE] >= bands[period][FAR][BANDS_BASE]);
      if ((open_method &   8) != 0) result = result && bands[period][CURR][BANDS_BASE] <= bands[period][PREV][BANDS_BASE];
      if ((open_method &  16) != 0) result = result && (bands[period][CURR][BANDS_UPPER] >= bands[period][PREV][BANDS_UPPER] || bands[period][CURR][BANDS_LOWER] <= bands[period][PREV][BANDS_LOWER]);
      if ((open_method &  32) != 0) result = result && (bands[period][CURR][BANDS_UPPER] <= bands[period][PREV][BANDS_UPPER] || bands[period][CURR][BANDS_LOWER] >= bands[period][PREV][BANDS_LOWER]);
      if ((open_method &  64) != 0) result = result && Ask < bands[period][CURR][BANDS_UPPER];
      if ((open_method & 128) != 0) result = result && Ask > bands[period][CURR][BANDS_BASE];
      //if ((open_method & 256) != 0) result = result && !Bands_On_Buy(M30);
      break;
    case OP_SELL:
      result = Low[CURR] < bands[period][CURR][BANDS_LOWER] || Low[PREV] < bands[period][PREV][BANDS_LOWER]; // price value was lower than the lower band
      if ((open_method &   1) != 0) result = result && Close[PREV] < bands[period][CURR][BANDS_LOWER];
      if ((open_method &   2) != 0) result = result && Close[CURR] > bands[period][CURR][BANDS_LOWER];
      if ((open_method &   4) != 0) result = result && (bands[period][CURR][BANDS_BASE] <= bands[period][PREV][BANDS_BASE] && bands[period][PREV][BANDS_BASE] <= bands[period][FAR][BANDS_BASE]);
      if ((open_method &   8) != 0) result = result && bands[period][CURR][BANDS_BASE] >= bands[period][PREV][BANDS_BASE];
      if ((open_method &  16) != 0) result = result && (bands[period][CURR][BANDS_UPPER] >= bands[period][PREV][BANDS_UPPER] || bands[period][CURR][BANDS_LOWER] <= bands[period][PREV][BANDS_LOWER]);
      if ((open_method &  32) != 0) result = result && (bands[period][CURR][BANDS_UPPER] <= bands[period][PREV][BANDS_UPPER] || bands[period][CURR][BANDS_LOWER] >= bands[period][PREV][BANDS_LOWER]);
      if ((open_method &  64) != 0) result = result && Ask > bands[period][CURR][BANDS_LOWER];
      if ((open_method & 128) != 0) result = result && Ask < bands[period][CURR][BANDS_BASE];
      //if ((open_method & 256) != 0) result = result && !Bands_On_Sell(M30);
    /*
          //9. Bollinger Bands
          //Buy: price crossed lower line upwards (returned to it from below)
          //Sell: price crossed upper line downwards (returned to it from above)
          if (iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,LOWER,1)>iClose(NULL,piband2,1)&&iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,LOWER,0)<=iClose(NULL,piband2,0))
          {f9=1;}
          if (iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,UPPER,1)<iClose(NULL,piband2,1)&&iBands(NULL,piband,pibandu,ibandotkl,0,PRICE_CLOSE,UPPER,0)>=iClose(NULL,piband2,0))
          {f9=-1;}
    */
      break;
  }

  return result;
}

/*
 * Check if BPower indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_BPower(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(BPOWER, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(BPOWER, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(BPOWER, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = BPower[period][CURR][LOWER] != 0.0 || BPower[period][PREV][LOWER] != 0.0 || BPower[period][FAR][LOWER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !BPower_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && BPower_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && BPower_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && BPower[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !BPower_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = BPower[period][CURR][UPPER] != 0.0 || BPower[period][PREV][UPPER] != 0.0 || BPower[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !BPower_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && BPower_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && BPower_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && BPower[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !BPower_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if Breakage indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Breakage(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  // if (open_method == EMPTY) open_method = GetStrategyOpenMethod(BWMFI, tf, 0);
  // if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(BWMFI, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = Breakage[period][CURR][LOWER] != 0.0 || Breakage[period][PREV][LOWER] != 0.0 || Breakage[period][FAR][LOWER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !Breakage_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && Breakage_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && Breakage_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && Breakage[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !Breakage_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = Breakage[period][CURR][UPPER] != 0.0 || Breakage[period][PREV][UPPER] != 0.0 || Breakage[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !Breakage_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && Breakage_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && Breakage_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && Breakage[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !Breakage_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if BWMFI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_BWMFI(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(BWMFI, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(BWMFI, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(BWMFI, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = BWMFI[period][CURR][LOWER] != 0.0 || BWMFI[period][PREV][LOWER] != 0.0 || BWMFI[period][FAR][LOWER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !BWMFI_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && BWMFI_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && BWMFI_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && BWMFI[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !BWMFI_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = BWMFI[period][CURR][UPPER] != 0.0 || BWMFI[period][PREV][UPPER] != 0.0 || BWMFI[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !BWMFI_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && BWMFI_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && BWMFI_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && BWMFI[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !BWMFI_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if CCI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_CCI(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(CCI, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(CCI, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(CCI, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !CCI_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && CCI_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && CCI_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && CCI[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !CCI_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = CCI[period][CURR][UPPER] != 0.0 || CCI[period][PREV][UPPER] != 0.0 || CCI[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !CCI_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && CCI_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && CCI_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && CCI[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !CCI_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if DeMarker indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_DeMarker(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(DEMARKER, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(DEMARKER, tf, 0);
  if (open_level == EMPTY)  open_level  = GetStrategyOpenLevel(DEMARKER, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      result = demarker[period][CURR] < 0.5 - open_level;
      if ((open_method &   1) != 0) result = result && demarker[period][PREV] < 0.5 - open_level;
      if ((open_method &   2) != 0) result = result && demarker[period][FAR] < 0.5 - open_level;
      if ((open_method &   4) != 0) result = result && demarker[period][CURR] < demarker[period][PREV];
      if ((open_method &   8) != 0) result = result && demarker[period][PREV] < demarker[period][FAR];
      if ((open_method &  16) != 0) result = result && demarker[period][PREV] < 0.5 - open_level - open_level/2;
      break;
    case OP_SELL:
      result = demarker[period][CURR] > 0.5 + open_level;
      if ((open_method &   1) != 0) result = result && demarker[period][PREV] > 0.5 + open_level;
      if ((open_method &   2) != 0) result = result && demarker[period][FAR] > 0.5 + open_level;
      if ((open_method &   4) != 0) result = result && demarker[period][CURR] > demarker[period][PREV];
      if ((open_method &   8) != 0) result = result && demarker[period][PREV] > demarker[period][FAR];
      if ((open_method &  16) != 0) result = result && demarker[period][PREV] > 0.5 + open_level + open_level/2;
      break;
  }

  return result;
}

/*
 * Check if Envelopes indicator is on sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Envelopes(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(ENVELOPES, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(ENVELOPES, tf, 0);
  if (open_level == EMPTY)  open_level  = GetStrategyOpenLevel(ENVELOPES, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      result = Low[CURR] < envelopes[period][CURR][LOWER] || Low[PREV] < envelopes[period][CURR][LOWER]; // price low was below the lower band
      // result = result || (envelopes[period][CURR][MODE_MAIN] > envelopes[period][FAR][MODE_MAIN] && Open[CURR] > envelopes[period][CURR][UPPER]);
      if ((open_method &   1) != 0) result = result && Open[CURR] > envelopes[period][CURR][LOWER]; // FIXME
      if ((open_method &   2) != 0) result = result && envelopes[period][CURR][MODE_MAIN] < envelopes[period][PREV][MODE_MAIN];
      if ((open_method &   4) != 0) result = result && envelopes[period][CURR][LOWER] < envelopes[period][PREV][LOWER];
      if ((open_method &   8) != 0) result = result && envelopes[period][CURR][UPPER] < envelopes[period][PREV][UPPER];
      if ((open_method &  16) != 0) result = result && envelopes[period][CURR][UPPER] - envelopes[period][CURR][LOWER] > envelopes[period][PREV][UPPER] - envelopes[period][PREV][LOWER];
      if ((open_method &  32) != 0) result = result && Ask < envelopes[period][CURR][MODE_MAIN];
      if ((open_method &  64) != 0) result = result && Close[CURR] < envelopes[period][CURR][UPPER];
      //if ((open_method & 128) != 0) result = result && Ask > Close[PREV];
      break;
    case OP_SELL:
      result = High[CURR] > envelopes[period][CURR][UPPER] || High[PREV] > envelopes[period][CURR][UPPER]; // price high was above the upper band
      // result = result || (envelopes[period][CURR][MODE_MAIN] < envelopes[period][FAR][MODE_MAIN] && Open[CURR] < envelopes[period][CURR][LOWER]);
      if ((open_method &   1) != 0) result = result && Open[CURR] < envelopes[period][CURR][UPPER]; // FIXME
      if ((open_method &   2) != 0) result = result && envelopes[period][CURR][MODE_MAIN] > envelopes[period][PREV][MODE_MAIN];
      if ((open_method &   4) != 0) result = result && envelopes[period][CURR][LOWER] > envelopes[period][PREV][LOWER];
      if ((open_method &   8) != 0) result = result && envelopes[period][CURR][UPPER] > envelopes[period][PREV][UPPER];
      if ((open_method &  16) != 0) result = result && envelopes[period][CURR][UPPER] - envelopes[period][CURR][LOWER] > envelopes[period][PREV][UPPER] - envelopes[period][PREV][LOWER];
      if ((open_method &  32) != 0) result = result && Ask > envelopes[period][CURR][MODE_MAIN];
      if ((open_method &  64) != 0) result = result && Close[CURR] > envelopes[period][CURR][UPPER];
      //if ((open_method & 128) != 0) result = result && Ask < Close[PREV];
      break;
  }
  return result;
}

/*
 * Check if Force indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Force(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(FORCE, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(FORCE, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(FORCE, tf, 0.0);
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

/*
 * Check if Fractals indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Fractals(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(FRACTALS, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(FRACTALS, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(FRACTALS, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      result = fractals[period][CURR][LOWER] != 0.0 || fractals[period][PREV][LOWER] != 0.0 || fractals[period][FAR][LOWER] != 0.0;
      if ((open_method &   1) != 0) result = result && fractals[period][FAR][LOWER] != 0.0;
      //if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
      // if ((open_method &   2) != 0) result = result && !Fractals_On_Sell(tf);
      // if ((open_method &   4) != 0) result = result && Fractals_On_Buy(MathMin(period + 1, M30));
      // if ((open_method &   8) != 0) result = result && Fractals_On_Buy(M30);
      break;
    case OP_SELL:
      result = fractals[period][CURR][UPPER] != 0.0 || fractals[period][PREV][UPPER] != 0.0 || fractals[period][FAR][UPPER] != 0.0;
      if ((open_method &   1) != 0) result = result && fractals[period][FAR][UPPER] != 0.0;
      //if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
      // if ((open_method &   2) != 0) result = result && !Fractals_On_Buy(tf);
      // if ((open_method &   4) != 0) result = result && Fractals_On_Sell(MathMin(period + 1, M30));
      // if ((open_method &   8) != 0) result = result && Fractals_On_Sell(M30);
      break;
  }
  return result;
}

/*
 * Check if Gator indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Gator(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(GATOR, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(GATOR, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(GATOR, tf, 0.0);
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

/*
 * Check if Ichimoku indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Ichimoku(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(ICHIMOKU, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(ICHIMOKU, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(ICHIMOKU, tf, 0.0);
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

/*
 * Check if MA indicator is on buy.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_MA(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(MA, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(MA, tf, 0);
  if (open_level == EMPTY)  open_level  = GetStrategyOpenLevel(MA, tf, 0);
  double gap = open_level * pip_size;

  switch (cmd) {
    case OP_BUY:
      result = ma_fast[period][CURR] > ma_medium[period][CURR] + gap;
      if ((open_method &   1) != 0) result = result && ma_fast[period][CURR] > ma_slow[period][CURR] + gap;
      if ((open_method &   2) != 0) result = result && ma_medium[period][CURR] > ma_slow[period][CURR];
      if ((open_method &   4) != 0) result = result && ma_slow[period][CURR] > ma_slow[period][PREV];
      if ((open_method &   8) != 0) result = result && ma_fast[period][CURR] > ma_fast[period][PREV];
      if ((open_method &  16) != 0) result = result && ma_fast[period][CURR] - ma_medium[period][CURR] > ma_medium[period][CURR] - ma_slow[period][CURR];
      if ((open_method &  32) != 0) result = result && (ma_medium[period][PREV] < ma_slow[period][PREV] || ma_medium[period][FAR] < ma_slow[period][FAR]);
      if ((open_method &  64) != 0) result = result && (ma_fast[period][PREV] < ma_medium[period][PREV] || ma_fast[period][FAR] < ma_medium[period][FAR]);
      break;
    case OP_SELL:
      result = ma_fast[period][CURR] < ma_medium[period][CURR] - gap;
      if ((open_method &   1) != 0) result = result && ma_fast[period][CURR] < ma_slow[period][CURR] - gap;
      if ((open_method &   2) != 0) result = result && ma_medium[period][CURR] < ma_slow[period][CURR];
      if ((open_method &   4) != 0) result = result && ma_slow[period][CURR] < ma_slow[period][PREV];
      if ((open_method &   8) != 0) result = result && ma_fast[period][CURR] < ma_fast[period][PREV];
      if ((open_method &  16) != 0) result = result && ma_medium[period][CURR] - ma_fast[period][CURR] > ma_slow[period][CURR] - ma_medium[period][CURR];
      if ((open_method &  32) != 0) result = result && (ma_medium[period][PREV] > ma_slow[period][PREV] || ma_medium[period][FAR] > ma_slow[period][FAR]);
      if ((open_method &  64) != 0) result = result && (ma_fast[period][PREV] > ma_medium[period][PREV] || ma_fast[period][FAR] > ma_medium[period][FAR]);
      break;
  }
  return result;
}

/*
 * Check if MACD indicator is on buy.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_MACD(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(MA, tf);
  UpdateIndicator(MACD, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(MACD, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(MACD, tf, 0);
  double gap = open_level * pip_size;
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
      if ((open_method &   1) != 0) result = result && macd[period][FAR][MODE_MAIN] < macd[period][FAR][MODE_SIGNAL];
      if ((open_method &   2) != 0) result = result && macd[period][CURR][MODE_MAIN] >= 0;
      if ((open_method &   4) != 0) result = result && macd[period][PREV][MODE_MAIN] < 0;
      if ((open_method &   8) != 0) result = result && ma_fast[period][CURR] > ma_fast[period][PREV];
      if ((open_method &  16) != 0) result = result && ma_fast[period][CURR] > ma_medium[period][CURR];
      break;
    case OP_SELL:
      result = macd[period][CURR][MODE_MAIN] < macd[period][CURR][MODE_SIGNAL] - gap; // MACD falls below the signal line.
      if ((open_method &   1) != 0) result = result && macd[period][FAR][MODE_MAIN] > macd[period][FAR][MODE_SIGNAL];
      if ((open_method &   2) != 0) result = result && macd[period][CURR][MODE_MAIN] <= 0;
      if ((open_method &   4) != 0) result = result && macd[period][PREV][MODE_MAIN] > 0;
      if ((open_method &   8) != 0) result = result && ma_fast[period][CURR] < ma_fast[period][PREV];
      if ((open_method &  16) != 0) result = result && ma_fast[period][CURR] < ma_medium[period][CURR];
      break;
  }
  return result;
}

/*
 * Check if MFI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_MFI(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(MFI, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(MFI, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(MFI, tf, 0.0);
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

/*
 * Check if Momentum indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Momentum(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(MOMENTUM, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(MOMENTUM, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(MOMENTUM, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/*
 * Check if OBV indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_OBV(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(OBV, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(OBV, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(OBV, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      break;
    case OP_SELL:
      break;
  }
  return result;
}

/*
 * Check if OSMA indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_OSMA(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(OSMA, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(OSMA, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(OSMA, tf, 0.0);
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

/*
 * Check if RSI indicator is on buy.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level - open level to consider the signal
 */
bool Trade_RSI(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(RSI, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(RSI, tf, 0);
  if (open_level == EMPTY)  open_level  = GetStrategyOpenLevel(RSI, tf, 20);
  switch (cmd) {
    case OP_BUY:
      result = rsi[period][CURR] <= (50 - open_level);
      if ((open_method &   1) != 0) result = result && rsi[period][CURR] < rsi[period][PREV];
      if ((open_method &   2) != 0) result = result && rsi[period][PREV] < rsi[period][FAR];
      if ((open_method &   4) != 0) result = result && rsi[period][PREV] < (50 - open_level);
      if ((open_method &   8) != 0) result = result && rsi[period][FAR]  < (50 - open_level);
      if ((open_method &  16) != 0) result = result && rsi[period][CURR] - rsi[period][PREV] > rsi[period][PREV] - rsi[period][FAR];
      if ((open_method &  32) != 0) result = result && rsi[period][FAR] > 50;
      //if ((open_method &  32) != 0) result = result && Open[CURR] > Close[PREV];
      //if ((open_method & 128) != 0) result = result && !RSI_On_Sell(M30);
      break;
    case OP_SELL:
      result = rsi[period][CURR] >= (50 + open_level);
      if ((open_method &   1) != 0) result = result && rsi[period][CURR] > rsi[period][PREV];
      if ((open_method &   2) != 0) result = result && rsi[period][PREV] > rsi[period][FAR];
      if ((open_method &   4) != 0) result = result && rsi[period][PREV] > (50 + open_level);
      if ((open_method &   8) != 0) result = result && rsi[period][FAR]  > (50 + open_level);
      if ((open_method &  16) != 0) result = result && rsi[period][PREV] - rsi[period][CURR] > rsi[period][FAR] - rsi[period][PREV];
      if ((open_method &  32) != 0) result = result && rsi[period][FAR] < 50;
      //if ((open_method &  32) != 0) result = result && Open[CURR] < Close[PREV];
      //if ((open_method & 128) != 0) result = result && !RSI_On_Buy(M30);
      break;
  }
  return result;
}

/*
 * Check if RVI indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_RVI(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(RVI, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(RVI, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(RVI, tf, 20);
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

/*
 * Check if SAR indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal (in pips)
 *   open_level (double) - open level to consider the signal
 */
bool Trade_SAR(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(SAR, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(SAR, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(SAR, tf, 0);
  double gap = open_level * pip_size;
  switch (cmd) {
    case OP_BUY:
      result = sar[period][CURR] + gap < Open[CURR] || sar[period][PREV] + gap < Open[PREV];
      if ((open_method &   1) != 0) result = result && sar[period][PREV] - gap > Ask;
      if ((open_method &   2) != 0) result = result && sar[period][CURR] < sar[period][PREV];
      if ((open_method &   4) != 0) result = result && sar[period][CURR] - sar[period][PREV] <= sar[period][PREV] - sar[period][FAR];
      if ((open_method &   8) != 0) result = result && sar[period][FAR] > Ask;
      if ((open_method &  16) != 0) result = result && sar[period][CURR] <= Close[CURR];
      if ((open_method &  32) != 0) result = result && sar[period][PREV] > Close[PREV];
      if ((open_method &  64) != 0) result = result && sar[period][PREV] > Open[PREV];
      if (result) {
        // FIXME: Convert into more flexible way.
        signals[DAILY][SAR1][period][OP_BUY]++; signals[WEEKLY][SAR1][period][OP_BUY]++;
        signals[MONTHLY][SAR1][period][OP_BUY]++; signals[YEARLY][SAR1][period][OP_BUY]++;
      }
      break;
    case OP_SELL:
      result = sar[period][CURR] - gap > Open[CURR] || sar[period][PREV] - gap > Open[PREV];
      if ((open_method &   1) != 0) result = result && sar[period][PREV] + gap < Ask;
      if ((open_method &   2) != 0) result = result && sar[period][CURR] > sar[period][PREV];
      if ((open_method &   4) != 0) result = result && sar[period][PREV] - sar[period][CURR] <= sar[period][FAR] - sar[period][PREV];
      if ((open_method &   8) != 0) result = result && sar[period][FAR] < Ask;
      if ((open_method &  16) != 0) result = result && sar[period][CURR] >= Close[CURR];
      if ((open_method &  32) != 0) result = result && sar[period][PREV] < Close[PREV];
      if ((open_method &  64) != 0) result = result && sar[period][PREV] < Open[PREV];
      if (result) {
        // FIXME: Convert into more flexible way.
        signals[DAILY][SAR1][period][OP_SELL]++; signals[WEEKLY][SAR1][period][OP_SELL]++;
        signals[MONTHLY][SAR1][period][OP_SELL]++; signals[YEARLY][SAR1][period][OP_SELL]++;
      }
      break;
  }

  return result;
}

/*
 * Check if StdDev indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_StdDev(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(STDDEV, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(STDDEV, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(STDDEV, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !StdDev_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && StdDev_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && StdDev_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && StdDev[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !StdDev_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = StdDev[period][CURR][UPPER] != 0.0 || StdDev[period][PREV][UPPER] != 0.0 || StdDev[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !StdDev_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && StdDev_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && StdDev_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && StdDev[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !StdDev_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if Stochastic indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_Stochastic(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(STOCHASTIC, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(STOCHASTIC, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(STOCHASTIC, tf, 0.0);
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
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !Stochastic_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && Stochastic_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && Stochastic_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && Stochastic[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !Stochastic_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = Stochastic[period][CURR][UPPER] != 0.0 || Stochastic[period][PREV][UPPER] != 0.0 || Stochastic[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !Stochastic_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && Stochastic_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && Stochastic_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && Stochastic[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !Stochastic_On_Buy(M30);
        */
    break;
  }
  return result;
}

/*
 * Check if WPR indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_WPR(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(WPR, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(WPR, tf, 0);
  if (open_level == EMPTY)  open_level  = GetStrategyOpenLevel(WPR, tf, 0);

  switch (cmd) {
    case OP_BUY:
      result = wpr[period][CURR] > 50 + open_level;
      if ((open_method &   1) != 0) result = result && wpr[period][CURR] < wpr[period][PREV];
      if ((open_method &   2) != 0) result = result && wpr[period][PREV] < wpr[period][FAR];
      if ((open_method &   4) != 0) result = result && wpr[period][PREV] > 50 + open_level;
      if ((open_method &   8) != 0) result = result && wpr[period][FAR]  > 50 + open_level;
      if ((open_method &  16) != 0) result = result && wpr[period][PREV] - wpr[period][CURR] > wpr[period][FAR] - wpr[period][PREV];
      if ((open_method &  32) != 0) result = result && wpr[period][PREV] > 50 + open_level + open_level / 2;
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
      result = wpr[period][CURR] < 50 - open_level;
      if ((open_method &   1) != 0) result = result && wpr[period][CURR] > wpr[period][PREV];
      if ((open_method &   2) != 0) result = result && wpr[period][PREV] > wpr[period][FAR];
      if ((open_method &   4) != 0) result = result && wpr[period][PREV] < 50 - open_level;
      if ((open_method &   8) != 0) result = result && wpr[period][FAR]  < 50 - open_level;
      if ((open_method &  16) != 0) result = result && wpr[period][CURR] - wpr[period][PREV] > wpr[period][PREV] - wpr[period][FAR];
      if ((open_method &  32) != 0) result = result && wpr[period][PREV] > 50 - open_level - open_level / 2;
      break;
  }
  return result;
}

/*
 * Check if ZigZag indicator is on buy or sell.
 *
 * @param
 *   cmd (int) - type of trade order command
 *   period (int) - period to check for
 *   open_method (int) - open method to use by using bitwise AND operation
 *   open_level (double) - open level to consider the signal
 */
bool Trade_ZigZag(int cmd, int tf = PERIOD_M1, int open_method = EMPTY, double open_level = EMPTY) {
  bool result = FALSE; int period = TfToPeriod(tf);
  UpdateIndicator(ZIGZAG, tf);
  if (open_method == EMPTY) open_method = GetStrategyOpenMethod(ZIGZAG, tf, 0);
  if (open_level  == EMPTY) open_level  = GetStrategyOpenLevel(ZIGZAG, tf, 0.0);
  switch (cmd) {
    case OP_BUY:
      /*
        bool result = ZigZag[period][CURR][LOWER] != 0.0 || ZigZag[period][PREV][LOWER] != 0.0 || ZigZag[period][FAR][LOWER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] > Close[CURR];
        if ((open_method &   2) != 0) result = result && !ZigZag_On_Sell(tf);
        if ((open_method &   4) != 0) result = result && ZigZag_On_Buy(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && ZigZag_On_Buy(M30);
        if ((open_method &  16) != 0) result = result && ZigZag[period][FAR][LOWER] != 0.0;
        if ((open_method &  32) != 0) result = result && !ZigZag_On_Sell(M30);
        */
    break;
    case OP_SELL:
      /*
        bool result = ZigZag[period][CURR][UPPER] != 0.0 || ZigZag[period][PREV][UPPER] != 0.0 || ZigZag[period][FAR][UPPER] != 0.0;
        if ((open_method &   1) != 0) result = result && Open[CURR] < Close[CURR];
        if ((open_method &   2) != 0) result = result && !ZigZag_On_Buy(tf);
        if ((open_method &   4) != 0) result = result && ZigZag_On_Sell(MathMin(period + 1, M30));
        if ((open_method &   8) != 0) result = result && ZigZag_On_Sell(M30);
        if ((open_method &  16) != 0) result = result && ZigZag[period][FAR][UPPER] != 0.0;
        if ((open_method &  32) != 0) result = result && !ZigZag_On_Buy(M30);
        */
    break;
  }
  return result;
}

/* END: INDICATOR FUNCTIONS */

/*
 * Return plain text of array values separated by the delimiter.
 *
 * @param
 *   double arr[] - array to look for the values
 *   string sep - delimiter to separate array values
 */
string GetArrayValues(double& arr[], string sep = ", ") {
  string result = "";
  for (int i = 0; i < ArraySize(arr); i++) {
    result = result + i + ":" + arr[i] + sep;
  }
  return StringSubstr(result, 0, StringLen(result) - StringLen(sep)); // Return text without last separator.
}

/*
 * Check for market condition.
 *
 * @param
 *   cmd (int) - trade command
 *   tf (int) - tf to use
 *   condition (int) - condition to check by using bitwise AND operation
 *   default_value (bool) - default value to set, if FALSE - return the opposite
 */
bool CheckMarketCondition1(int cmd, int tf = PERIOD_M30, int condition = 0, bool default_value = TRUE) {
  bool result = TRUE;
  RefreshRates(); // ?
  int period = TfToPeriod(tf);
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

/*
 * Check for market event.
 *
 * @param
 *   cmd (int) - trade command
 *   tf (int) - timeframe to use
 *   condition (int) - condition to check by using bitwise AND operation
 *   default_value (bool) - default value to set, if FALSE - return the opposite
 */
bool CheckMarketEvent(int cmd = EMPTY, int tf = PERIOD_M30, int condition = EMPTY) {
  bool result = FALSE;
  int period = TfToPeriod(tf);
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

/*
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

/*
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
         diff = MathAbs((OrderOpenPrice() - GetOpenPrice()) / pip_size);
         // if (VerboseTrace) Print("Ticket: ", OrderTicket(), ", Order: ", OrderType(), ", Gap: ", diff);
         if (diff < MinPipGap) {
           return FALSE;
         }
       }
    } else if (VerboseDebug) {
        Print(__FUNCTION__ + "(): Error: Strategy type = " + strategy_type + ", pos: " + order + ", message: ", GetErrorText(err_code));
    }
  }
  return TRUE;
}

// Validate value for trailing stop.
bool ValidTrailingValue(double value, int cmd, int loss_or_profit = -1, bool existing = FALSE) {
  double delta = GetMarketGap(); // Calculate minimum market gap.
  double price = GetOpenPrice();
  bool valid = (
          (cmd == OP_BUY  && loss_or_profit < 0 && price - value > delta)
       || (cmd == OP_BUY  && loss_or_profit > 0 && value - price > delta)
       || (cmd == OP_SELL && loss_or_profit < 0 && value - price > delta)
       || (cmd == OP_SELL && loss_or_profit > 0 && price - value > delta)
       );
  valid &= (value >= 0); // Also must be zero or above.
  if (!valid && VerboseTrace) Print(__FUNCTION__ + "(): Trailing value not valid: " + value);
  return valid;
}

void UpdateTrailingStops() {
   bool result; // Check result of executed orders.
   double new_trailing_stop, new_profit_take;
   int order_type;

   // Check if bar time has been changed since last time.
   /*
   int bar_time = iTime(NULL, PERIOD_M1, 0);
   if (bar_time == last_trail_update) {
     return;
   } else {
     last_trail_update = bar_time;
   }*/

   for (int i = 0; i < OrdersTotal(); i++) {
     if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
        order_type = OrderMagicNumber() - MagicNumber;
        // order_stop_loss = NormalizeDouble(If(OpTypeValue(OrderType()) > 0 || OrderStopLoss() != 0.0, OrderStopLoss(), 999999), PipDigits);

        // FIXME
        if (MinimalizeLosses && GetOrderProfit() > GetMinStopLevel()) {
          if ((OrderType() == OP_BUY && OrderStopLoss() < Bid) ||
             (OrderType() == OP_SELL && OrderStopLoss() > Ask)) {
            result = OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - OrderCommission() * Point, OrderTakeProfit(), 0, GetOrderColor());
            if (!result && err_code > 1) {
             if (VerboseErrors) Print(__FUNCTION__, "(): Error: OrderModify(): [MinimalizeLosses] ", ErrorDescription(err_code));
               if (VerboseDebug)
                 Print(__FUNCTION__ + "(): Error: OrderModify(", OrderTicket(), ", ", OrderOpenPrice(), ", ", OrderOpenPrice() - OrderCommission() * Point, ", ", OrderTakeProfit(), ", ", 0, ", ", GetOrderColor(), "); ", "Ask/Bid: ", Ask, "/", Bid);
            } else {
              if (VerboseTrace) Print(__FUNCTION__ + "(): MinimalizeLosses: ", GetOrderTextDetails());
            }
          }
        }

        new_trailing_stop = NormalizeDouble(GetTrailingValue(OrderType(), -1, order_type, OrderStopLoss(), TRUE), Digits);
        new_profit_take   = NormalizeDouble(GetTrailingValue(OrderType(), +1, order_type, OrderTakeProfit(), TRUE), Digits);
        //if (MathAbs(OrderStopLoss() - new_trailing_stop) >= pip_size || MathAbs(OrderTakeProfit() - new_profit_take) >= pip_size) { // Perform update on pip change.
        if (new_trailing_stop != OrderStopLoss() || new_profit_take != OrderTakeProfit()) { // Perform update on change only.
           result = OrderModify(OrderTicket(), OrderOpenPrice(), new_trailing_stop, new_profit_take, 0, GetOrderColor());
           if (!result) {
             err_code = GetLastError();
             if (err_code > 1) {
               if (VerboseErrors) Print(__FUNCTION__, "(): Error: OrderModify(): ", ErrorDescription(err_code));
               if (VerboseDebug)
                 Print(__FUNCTION__ + "(): Error: OrderModify(", OrderTicket(), ", ", OrderOpenPrice(), ", ", new_trailing_stop, ", ", new_profit_take, ", ", 0, ", ", GetOrderColor(), "); ", "Ask/Bid: ", Ask, "/", Bid);
             }
           } else {
             // if (VerboseTrace) Print("UpdateTrailingStops(): OrderModify(): ", GetOrderTextDetails());
           }
        }
     }
  }
}

/*
 * Calculate the new trailing stop. If calculation fails, use the previous one.
 *
 * @params:
 *   cmd (int)
 *    Command for trade operation.
 *   loss_or_profit (int)
 *    Set -1 to calculate trailing stop or +1 for profit take.
 *   order_type (int)
 *    Value of strategy type. See: ENUM_STRATEGY_TYPE
 *   previous (double)
 *    Previous trailing value.
 *   existing (bool)
 *    Set to TRUE if the calculation is for particular existing order, so additional local variables are available.
 */
double GetTrailingValue(int cmd, int loss_or_profit = -1, int order_type = EMPTY, double previous = 0, bool existing = FALSE) {
   double new_value = 0;
   double delta = GetMarketGap(), diff;
   int extra_trail = 0;
   if (existing && TrailingStopAddPerMinute > 0 && OrderOpenTime() > 0) {
     int min_elapsed = (TimeCurrent() - OrderOpenTime()) / 60;
     extra_trail =+ min_elapsed * TrailingStopAddPerMinute;
   }
   int factor = If(OpTypeValue(cmd) == loss_or_profit, +1, -1);
   double trail = (TrailingStop + extra_trail) * pip_size;
   double default_trail = If(cmd == OP_BUY, Bid, Ask) + trail * factor;
   int method = GetTrailingMethod(order_type, loss_or_profit);
   // if (loss_or_profit > 0) method = AC_TrailingProfitMethod; else if (loss_or_profit < 0) method = AC_TrailingStopMethod; // Testing.
   int timeframe = GetStrategyTimeframe(order_type);
   int period = TfToPeriod(timeframe);
   int symbol = If(existing, OrderSymbol(), _Symbol);

/*
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
       diff = MathAbs(Open[CURR] - iClose(symbol, timeframe, PREV));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_2_BARS_PEAK: // 3
       diff = MathMax(GetPeakPrice(timeframe, MODE_HIGH, 2) - Open[CURR], Open[CURR] - GetPeakPrice(timeframe, MODE_LOW, 2));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_5_BARS_PEAK: // 4
       diff = MathMax(GetPeakPrice(timeframe, MODE_HIGH, 5) - Open[CURR], Open[CURR] - GetPeakPrice(timeframe, MODE_LOW, 5));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_10_BARS_PEAK: // 5
       diff = MathMax(GetPeakPrice(timeframe, MODE_HIGH, 10) - Open[CURR], Open[CURR] - GetPeakPrice(timeframe, MODE_LOW, 10));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_50_BARS_PEAK:
       diff = MathMax(GetPeakPrice(timeframe, MODE_HIGH, 50) - Open[CURR], Open[CURR] - GetPeakPrice(timeframe, MODE_LOW, 50));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_150_BARS_PEAK:
       diff = MathMax(GetPeakPrice(timeframe, MODE_HIGH, 150) - Open[CURR], Open[CURR] - GetPeakPrice(timeframe, MODE_LOW, 150));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_HALF_200_BARS:
       diff = MathMax(GetPeakPrice(timeframe, MODE_HIGH, 200) - Open[CURR], Open[CURR] - GetPeakPrice(timeframe, MODE_LOW, 200));
       new_value = Open[CURR] + diff/2 * factor;
       break;
     case T_HALF_PEAK_OPEN:
       if (existing) {
         // Get the number of bars for the timeframe since open. Zero means that the order was opened during the current bar.
         int BarShiftOfTradeOpen = iBarShift(symbol, timeframe, OrderOpenTime(), FALSE);
         // Get the high price from the bar with the given timeframe index
         double highest_open = GetPeakPrice(timeframe, MODE_HIGH, BarShiftOfTradeOpen + 1);
         double lowest_open = GetPeakPrice(timeframe, MODE_LOW, BarShiftOfTradeOpen + 1);
         diff = MathMax(highest_open - Open[CURR], Open[CURR] - lowest_open);
         new_value = Open[CURR] + diff/2 * factor;
       }
       break;
     case T_MA_F_PREV: // 9: MA Small (Previous). The worse so far for MA.
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Ask - ma_fast[period][PREV]);
       new_value = Ask + diff * factor;
       break;
     case T_MA_F_FAR: // 10: MA Small (Far) + trailing stop. Optimize together with: MA_Shift_Far.
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Ask - ma_fast[period][FAR]);
       new_value = Ask + diff * factor;
       break;
     /*
     case T_MA_F_LOW: // 11: Lowest/highest value of MA Fast. Optimized (SL pf: 1.39 for MA).
       UpdateIndicator(MA, timeframe);
       diff = MathMax(HighestArrValue2(ma_fast, period) - Open[CURR], Open[CURR] - LowestArrValue2(ma_fast, period));
       new_value = Open[CURR] + diff * factor;
       break;
      */
     case T_MA_F_TRAIL: // 12: MA Fast (Current) + trailing stop. Works fine.
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Ask - ma_fast[period][CURR]);
       new_value = Ask + (diff + trail) * factor;
       break;
     case T_MA_F_FAR_TRAIL: // 13: MA Fast (Far) + trailing stop. Works fine (SL pf: 1.26 for MA).
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Open[CURR] - ma_fast[period][FAR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       break;
     case T_MA_M: // 14: MA Medium (Current).
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Ask - ma_medium[period][CURR]);
       new_value = Ask + diff * factor;
       break;
     case T_MA_M_FAR: // 15: MA Medium (Far)
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Ask - ma_medium[period][FAR]);
       new_value = Ask + diff * factor;
       break;
     /*
     case T_MA_M_LOW: // 16: Lowest/highest value of MA Medium. Optimized (SL pf: 1.39 for MA).
       UpdateIndicator(MA, timeframe);
       diff = MathMax(HighestArrValue2(ma_medium, period) - Open[CURR], Open[CURR] - LowestArrValue2(ma_medium, period));
       new_value = Open[CURR] + diff * factor;
       break;
      */
     case T_MA_M_TRAIL: // 17: MA Small (Current) + trailing stop. Works fine (SL pf: 1.26 for MA).
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Open[CURR] - ma_medium[period][CURR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       break;
     case T_MA_M_FAR_TRAIL: // 18: MA Small (Far) + trailing stop. Optimized (SL pf: 1.29 for MA).
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Open[CURR] - ma_medium[period][FAR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       break;
     case T_MA_S: // 19: MA Slow (Current).
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Ask - ma_slow[period][CURR]);
       // new_value = ma_slow[period][CURR];
       new_value = Ask + diff * factor;
       break;
     case T_MA_S_FAR: // 20: MA Slow (Far).
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Ask - ma_slow[period][FAR]);
       // new_value = ma_slow[period][FAR];
       new_value = Ask + diff * factor;
       break;
     case T_MA_S_TRAIL: // 21: MA Slow (Current) + trailing stop. Optimized (SL pf: 1.29 for MA, PT pf: 1.23 for MA).
       UpdateIndicator(MA, timeframe);
       diff = MathAbs(Open[CURR] - ma_slow[period][CURR]);
       new_value = Open[CURR] + (diff + trail) * factor;
       break;
     case T_MA_FMS_PEAK: // 22: Lowest/highest value of all MAs. Works fine (SL pf: 1.39 for MA, PT pf: 1.23 for MA).
       UpdateIndicator(MA, timeframe);
       highest_ma = MathAbs(MathMax(MathMax(HighestArrValue2(ma_fast, period), HighestArrValue2(ma_medium, period)), HighestArrValue2(ma_slow, period)));
       lowest_ma = MathAbs(MathMin(MathMin(LowestArrValue2(ma_fast, period), LowestArrValue2(ma_medium, period)), LowestArrValue2(ma_slow, period)));
       diff = MathMax(MathAbs(highest_ma - Open[CURR]), MathAbs(Open[CURR] - lowest_ma));
       new_value = Open[CURR] + diff * factor;
       break;
     case T_SAR: // 23: Current SAR value. Optimized.
       UpdateIndicator(SAR, timeframe);
       new_value = sar[period][CURR];
       break;
     case T_SAR_PEAK: // 24: Lowest/highest SAR value.
       UpdateIndicator(SAR, timeframe);
       new_value = If(OpTypeValue(cmd) == loss_or_profit, HighestArrValue2(sar, period), LowestArrValue2(sar, period));
       break;
     case T_BANDS: // 25: Current Bands value.
       UpdateIndicator(BANDS, timeframe);
       new_value = If(OpTypeValue(cmd) == loss_or_profit, bands[period][CURR][BANDS_UPPER], bands[period][CURR][BANDS_LOWER]);
       break;
     case T_BANDS_PEAK: // 26: Lowest/highest Bands value.
       UpdateIndicator(BANDS, timeframe);
       new_value = If(OpTypeValue(cmd) == loss_or_profit,
         MathMax(MathMax(bands[period][CURR][BANDS_UPPER], bands[period][PREV][BANDS_UPPER]), bands[period][FAR][BANDS_UPPER]),
         MathMin(MathMin(bands[period][CURR][BANDS_LOWER], bands[period][PREV][BANDS_LOWER]), bands[period][FAR][BANDS_LOWER])
         );
       break;
     case T_ENVELOPES: // 27: Current Envelopes value. // FIXME
       UpdateIndicator(ENVELOPES, timeframe);
       new_value = If(OpTypeValue(cmd) == loss_or_profit, envelopes[period][CURR][UPPER], envelopes[period][CURR][LOWER]);
       break;
     default:
       if (VerboseDebug) Print(__FUNCTION__ + "(): Error: Unknown trailing stop method: ", method);
   }

   if (new_value > 0) new_value += delta * factor;

   if (!ValidTrailingValue(new_value, cmd, loss_or_profit, existing)) {
     #ifndef __limited__
       if (existing && previous == 0 && loss_or_profit == -1) previous = default_trail;
     #else // If limited, then force the trailing value.
       if (existing && previous == 0) previous = default_trail;
     #endif
     if (VerboseTrace)
       Print(__FUNCTION__ + "(): Error: method = " + method + ", ticket = #" + If(existing, OrderTicket(), 0) + ": Invalid Trailing Value: ", new_value, ", previous: ", previous, "; ", GetOrderTextDetails(), ", delta: ", DoubleToStr(delta, PipDigits));
     // If value is invalid, fallback to the previous one.
     return previous;
   }

   if (TrailingStopOneWay && loss_or_profit < 0 && method > 0) { // If TRUE, move trailing stop only one direction.
     if (previous == 0 && method > 0) previous = default_trail;
     if (OpTypeValue(cmd) == loss_or_profit) new_value = If(new_value < previous || previous == 0, new_value, previous);
     else new_value = If(new_value > previous || previous == 0, new_value, previous);
   }
   if (TrailingProfitOneWay && loss_or_profit > 0 && method > 0) { // If TRUE, move profit take only one direction.
     if (OpTypeValue(cmd) == loss_or_profit) new_value = If(new_value > previous || previous == 0, new_value, previous);
     else new_value = If(new_value < previous || previous == 0, new_value, previous);
   }

   // if (VerboseDebug && IsVisualMode()) ShowLine("trail_stop_" + OrderTicket(), new_value, GetOrderColor());
   return NormalizeDouble(new_value, Digits);
}

// Get trailing method based on the strategy type.
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
      if (VerboseTrace) Print(__FUNCTION__ + "(): Unknown order type: " + order_type);
  }
  return If(stop_or_profit > 0, profit_method, stop_method);
}

void ShowLine(string oname, double price, int colour = Yellow) {
    ObjectCreate(ChartID(), oname, OBJ_HLINE, 0, Time[0], price, 0, 0);
    ObjectSet(oname, OBJPROP_COLOR, colour);
    ObjectMove(oname, 0, Time[0], price);
}

/*
 * Get current open price depending on the operation type.
 * @param:
 *   op_type (int)
 */
double GetOpenPrice(int op_type = EMPTY_VALUE) {
   if (op_type == EMPTY_VALUE) op_type = OrderType();
   return If(op_type == OP_BUY, Ask, Bid);
}

/*
 * Get current close price depending on the operation type.
 * @param:
 *   op_type (int)
 */
double GetClosePrice(int op_type = EMPTY_VALUE) {
   if (op_type == EMPTY_VALUE) op_type = OrderType();
   return If(op_type == OP_BUY, Bid, Ask);
}

/*
 * Get peak price at given number of bars.
 */
double GetPeakPrice(int timeframe, int mode, int bars, int index = CURR) {
  int ibar = -1;
  double peak_price = Open[0];
  if (mode == MODE_HIGH) ibar = iHighest(_Symbol, timeframe, MODE_HIGH, bars, index);
  if (mode == MODE_LOW)  ibar =  iLowest(_Symbol, timeframe, MODE_LOW,  bars, index);
  if (ibar == -1 && VerboseTrace) { err_code = GetLastError(); Print(__FUNCTION__ + "(): " + ErrorDescription(err_code)); return FALSE; }
  if (mode == MODE_HIGH) {
    return iHigh(_Symbol, timeframe, ibar);
  } else if (mode == MODE_LOW) {
    return iLow(_Symbol, timeframe, ibar);
  } else {
    return FALSE;
  }
}

int OpTypeValue(int op_type) {
   switch (op_type) {
      case OP_SELL:
      case OP_SELLLIMIT:
      case OP_SELLSTOP:
        return -1;
        break;
      case OP_BUY:
      case OP_BUYLIMIT:
      case OP_BUYSTOP:
        return 1;
        break;
      default:
        return FALSE;
   }
}

// Return double depending on the condition.
double If(bool condition, double on_true, double on_false) {
   // if condition is TRUE, return on_true, otherwise on_false
   if (condition) return (on_true);
   else return (on_false);
}

// Return string depending on the condition.
string IfTxt(bool condition, string on_true, string on_false) {
   // if condition is TRUE, return on_true, otherwise on_false
   if (condition) return (on_true);
   else return (on_false);
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

/*
 * Get total profit of opened orders by type.
 */
double GetTotalProfitByType(int cmd = NULL, int order_type = NULL) {
  double total = 0;
  for (int i = 0; i < OrdersTotal(); i++) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
    if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if (OrderType() == cmd) total += GetOrderProfit();
       else if (OrderMagicNumber() == MagicNumber + order_type) total += GetOrderProfit();
     }
  }
  return total;
}

/*
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

/*
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
    if (VerboseTrace && err != last_err) Print(__FUNCTION__ + "(): " + err);
    last_err = err;
    return (FALSE);
  }*/
  if (Bars < 100) {
    err = "Bars less than 100, not trading...";
    if (VerboseTrace && err != last_err) Print(__FUNCTION__ + "(): " + err);
    //if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "(): " + err);
    last_err = err;
    return (FALSE);
  }
  if (!IsTesting() && Volume[0] < MinVolumeToTrade) {
    err = "Volume too low to trade.";
    if (VerboseTrace && err != last_err) Print(__FUNCTION__ + "(): " + err);
    //if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "(): " + err);
    last_err = err;
    return (FALSE);
  }
  if (IsTradeContextBusy()) {
    err = "Error: Trade context is temporary busy.";
    if (VerboseErrors && err != last_err) Print(__FUNCTION__ + "(): " + err);
    //if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "(): " + err);
    last_err = err;
    return (FALSE);
  }
  // Check if the EA is allowed to trade and trading context is not busy, otherwise returns false.
  // OrderSend(), OrderClose(), OrderCloseBy(), OrderModify(), OrderDelete() trading functions
  //   changing the state of a trading account can be called only if trading by Expert Advisors
  //   is allowed (the "Allow live trading" checkbox is enabled in the Expert Advisor or script properties).
  if (!IsTradeAllowed()) {
    err = "Trade is not allowed at the moment, check the settings!";
    if (VerboseErrors && err != last_err) Print(__FUNCTION__ + "(): " + err);
    //if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "(): " + err);
    last_err = err;
    ea_active = FALSE;
    return (FALSE);
  }
  if (!IsConnected()) {
    err = "Error: Terminal is not connected!";
    if (VerboseErrors && err != last_err) Print(__FUNCTION__ + "(): " + err);
    if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "(): " + err);
    last_err = err;
    if (PrintLogOnChart) DisplayInfoOnChart();
    Sleep(10000);
    return (FALSE);
  }
  if (IsStopped()) {
    err = "Error: Terminal is stopping!";
    if (VerboseErrors && err != last_err) Print(__FUNCTION__ + "(): " + err);
    //if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "():" + err);
    last_err = err;
    ea_active = FALSE;
    return (FALSE);
  }
  if (!IsTesting() && !MarketInfo(Symbol(), MODE_TRADEALLOWED)) {
    err = "Trade is not allowed. Market is closed.";
    if (VerboseInfo && err != last_err) Print(__FUNCTION__ + "(): " + err);
    //if (PrintLogOnChart && err != last_err) Comment(__FUNCTION__ + "():" + err);
    last_err = err;
    ea_active = FALSE;
    return (FALSE);
  }
  if (!IsTesting() && !IsExpertEnabled()) {
    err = "Error: You need to enable: 'Enable Expert Advisor'/'AutoTrading'.";
    if (VerboseErrors && err != last_err) Print(__FUNCTION__ + "(): " + err);
    last_err = err;
    ea_active = FALSE;
    return (FALSE);
  }
  if (!session_active) {
    err = "Error: Session is not active!";
    if (VerboseErrors && err != last_err) Print(__FUNCTION__ + "(): " + err);
    last_err = err;
    ea_active = FALSE;
    return (FALSE);
  }

  ea_active = TRUE;
  return (TRUE);
}

// Check if EA parameters are valid.
bool ValidSettings() {
  string err;
   // TODO: IsDllsAllowed(), IsLibrariesAllowed()
  if (LotSize < 0.0) {
    err = "Error: LotSize is less than 0.";
    if (VerboseErrors) Print(__FUNCTION__ + "(): " + err);
    if (PrintLogOnChart) Comment(err);
    return (FALSE);
  }
  #ifdef __backtest__
    if (!IsTesting()) {
       err = "Error: This version is compiled for backtest mode only.";
       if (VerboseErrors) Print(__FUNCTION__ + "(): " + err);
       if (PrintLogOnChart) Comment(err);
       return (FALSE);
    }
  #endif
  E_Mail = StringTrimLeft(StringTrimRight(E_Mail));
  License = StringTrimLeft(StringTrimRight(License));
  return !StringCompare(ValidEmail(E_Mail), License);
}

/*
 * Check account free margin.
 */
bool CheckFreeMargin(int op_type, double size_of_lot) {
   bool margin_ok = TRUE;
   double margin = AccountFreeMarginCheck(Symbol(), op_type, size_of_lot);
   if (GetLastError() == 134 /* NOT_ENOUGH_MONEY */) margin_ok = FALSE;
   return (margin_ok);
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

/*
 * Get order profit.
 */
double GetOrderProfit() {
  return OrderProfit() - OrderCommission() - OrderSwap();
}

/*
 * Get color of the order.
 */
double GetOrderColor(int cmd = -1) {
  if (cmd == -1) cmd = OrderType();
  return If(OpTypeValue(cmd) > 0, ColorBuy, ColorSell);
}

/*
 * This function returns the minimal permissible distance value in points for StopLoss/TakeProfit.
 *
 * This is due that at placing of a pending order, the open price cannot be too close to the market.
 * The minimal distance of the pending price from the current market one in points can be obtained
 * using the MarketInfo() function with the MODE_STOPLEVEL parameter. In case of false open price of a pending order,
 * the error 130 (ERR_INVALID_STOPS) will be generated.
 *
 */
double GetMinStopLevel() {
  return market_stoplevel * Point;
}

/*
 * Calculate pip size.
 */
double GetPipSize() {
  if (Digits < 4) {
    return 0.01;
  } else {
    return 0.0001;
  }
}

/*
 * Calculate pip precision.
 */
double GetPipPrecision() {
  if (Digits < 4) {
    return 2;
  } else {
    return 4;
  }
}

/*
 * Calculate volume precision.
 */
double GetVolumePrecision() {
  if (TradeMicroLots) return 2;
  else return 1;
}

// Calculate number of points per pip.
// To be used to replace Point for trade parameters calculations.
// See: http://forum.mql4.com/30672
double GetPointsPerPip() {
  return MathPow(10, Digits - PipDigits);
}

/*
 * Convert value into pips.
 */
double ValueToPips(double value) {
  return value * MathPow(10, PipDigits);
}

/*
 * Convert pips into points.
 */
double PipsToPoints(double pips) {
  return pips * pts_per_pip;
}

/*
 * Convert points into pips.
 */
double PointsToPips(int points) {
  return points / pts_per_pip;
}

/*
 * Get the difference between two price values (in pips).
 */
double GetPipDiff(double price1, double price2, bool abs = false) {
  double diff = If(abs, MathAbs(price1 - price2), price1 - price2);
  return ValueToPips(diff);
}

/*
 * Add currency sign to the plain value.
 */
string ValueToCurrency(double value, int digits = 2) {
  ushort sign; bool prefix = TRUE;
  if (AccCurrency == "USD") sign = '$';
  else if (AccCurrency == "GBP") sign = '£';
  else if (AccCurrency == "EUR") sign = '€';
  else { sign = AccCurrency; prefix = FALSE; }
  return IfTxt(prefix, CharToString(sign) + DoubleToStr(value, digits), DoubleToStr(value, digits) + CharToString(sign));
}

/*
 * Current market spread value in pips.
 *
 * Note: Using Mode_SPREAD can return 20 on EURUSD (IBFX), but zero on some other pairs, so using Ask - Bid instead.
 * See: http://forum.mql4.com/42285
 */
double GetMarketSpread(bool in_points = false) {
  // return MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - PipDigits);
  double spread = If(in_points, SymbolInfoInteger(Symbol(), SYMBOL_SPREAD), Ask - Bid);
  if (in_points) CheckStats(spread, MAX_SPREAD);
  // if (VerboseTrace) PrintFormat("%s(): Spread: %f (%s)", __FUNCTION__, spread, IfTxt(in_points, "points", "pips"));
  return spread;
}

// Get current minimum marker gap (in points).
double GetMarketGap(bool in_points = false) {
  return If(in_points, market_stoplevel + GetMarketSpread(TRUE), (market_stoplevel + GetMarketSpread(TRUE)) * Point);
}

/*
 * Check if we're in market peak hours.
 */
bool MarketPeakHours() {
  return hour_of_day >= 8 && hour_of_day <= 16;
}

/*
 * Normalize lot size.
 */
double NormalizeLots(double lots, bool ceiling = false, string pair = "") {
  // See: http://forum.mql4.com/47988
  double lotsize;
  double precision;
  if (market_lotstep > 0.0) precision = 1 / market_lotstep;
  else precision = 1 / market_minlot;

  if (ceiling) lotsize = MathCeil(lots * precision) / precision;
  else lotsize = MathFloor(lots * precision) / precision;

  if (lotsize < market_minlot) lotsize = market_minlot;
  if (lotsize > market_maxlot) lotsize = market_maxlot;
  return (lotsize);
}

/*
 * Normalize price value.
 */
double NormalizePrice(double p, string pair=""){
   // See: http://forum.mql4.com/47988
   // http://forum.mql4.com/43064#515262 zzuegg reports for non-currency DE30:
   // MarketInfo(chart.symbol,MODE_TICKSIZE) returns 0.5
   // MarketInfo(chart.symbol,MODE_DIGITS) return 1
   // Point = 0.1
   // Prices to open must be a multiple of ticksize
   if (pair == "") pair = Symbol();
   double ts = MarketInfo(pair, MODE_TICKSIZE);
   return( MathRound(p/ts) * ts );
}

/*
 * Return opposite trade command operation.
 *
 * @param
 *   cmd (int) - trade command operation
 */
int CmdOpp(int cmd) {
  if (cmd == OP_BUY) return OP_SELL;
  if (cmd == OP_SELL) return OP_BUY;
  return EMPTY;
}

/*
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

/*
 * Calculate number of order allowed given risk ratio.
 */
int GetMaxOrdersAuto(bool smooth = true) {
  double avail_margin = MathMin(AccountFreeMargin(), AccountBalance());
  double leverage     = MathMax(AccountLeverage(), 100);
  int balance_limit   = MathMax(MathMin(AccountBalance(), AccountEquity()) / 2, 0); // At least 1 order per 2 currency value. This also prevents trading with negative balance.
  double stopout_level = GetAccountStopoutLevel();
  double avail_orders = avail_margin / market_marginrequired / MathMax(lot_size, market_lotstep) * (100 / leverage);
  int new_max_orders = avail_orders * stopout_level * risk_ratio;
  #ifdef __advanced__
  if (MaxOrdersPerDay > 0) new_max_orders = MathMin(GetMaxOrdersPerDay(), new_max_orders);
  #endif
  if (VerboseTrace) PrintFormat("%s(): %f / %f / %f * (100/%d)", __FUNCTION__, avail_margin, market_marginrequired, MathMax(lot_size, market_lotstep), leverage);
  if (smooth && new_max_orders > max_orders) {
    max_orders = (max_orders + new_max_orders) / 2; // Increase the limit smoothly.
  } else {
    max_orders = new_max_orders;
  }
  return max_orders;
}

/*
 * Get daily total available orders. It can dynamically change during the day.
 */
#ifdef __advanced__
int GetMaxOrdersPerDay() {
  if (MaxOrdersPerDay <= 0) return TRUE;
  int hours_left = (24 - hour_of_day);
  int curr_allowed_limit = floor((MaxOrdersPerDay - daily_orders) / hours_left);
  // Message(StringFormat("Hours left: (%d - %d) / %d= %d", MaxOrdersPerDay, daily_orders, hours_left, curr_allowed_limit));
  return MathMin(MathMax((total_orders - daily_orders), 1) + curr_allowed_limit, MaxOrdersPerDay);
}
#endif

/*
 * Calculate number of maximum of orders allowed to open.
 */
int GetMaxOrders() {
  #ifdef __advanced__
    return If(MaxOrders > 0, If(MaxOrdersPerDay > 0, MathMin(MaxOrders, GetMaxOrdersPerDay()), MaxOrders), GetMaxOrdersAuto());
  #else
    return If(MaxOrders > 0, MaxOrders, GetMaxOrdersAuto());
  #endif
}

/*
 * Calculate number of maximum of orders allowed to open per type.
 */
int GetMaxOrdersPerType() {
  return If(MaxOrdersPerType > 0, MaxOrdersPerType, MathMax(MathFloor(max_orders / MathMax(GetNoOfStrategies(), 1) ), 1) * 2);
}

/*
 * Get number of active strategies.
 */
int GetNoOfStrategies() {
  int result = 0;
  for (int i = 0; i < FINAL_STRATEGY_TYPE_ENTRY; i++)
    result += info[i][ACTIVE];
  return result;
}

/*
 * Calculate size of the lot based on the free margin and account leverage automatically.
 */
double GetAutoLotSize(bool smooth = true) {
  double avail_margin = MathMin(AccountFreeMargin(), AccountBalance());
  double leverage     = MathMax(AccountLeverage(), 100);
  #ifdef __advanced__ double margin_risk = 0.02; #else double margin_risk = 0.01; #endif // Risk only 1%/2% (0.01/0.02) per order of total available margin.
  // double margin_risk = 0.01; // Risk only 1% of total available margin per order.
  double new_lot_size = avail_margin / market_marginrequired * margin_risk * risk_ratio;

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
    return (lot_size + new_lot_size) / 2; // Increase only by average of the previous and new (which should prevent sudden increases).
  } else {
    return new_lot_size;
  }
}

/*
 * Return current lot size to trade.
 */
double GetLotSize() {
  return NormalizeLots(If(LotSize == 0, GetAutoLotSize(), LotSize));
}

/*
 * Calculate auto risk ratio value.
 */
double GetAutoRiskRatio() {
  double equity  = AccountEquity();
  double balance = AccountBalance();
  double free    = AccountFreeMargin(); // Used when you open/close new positions. It can increase decrease during the price movement in favor and vice versa.
  double margin  = AccountMargin(); // Taken from your depo as a guarantee to maintain your current positions opened. It stays the same untill you open or close positions.
  double new_risk_ratio = 1 / MathMin(equity, balance) * MathMin(MathMin(free, balance), equity);

  #ifdef __advanced__
    int margin_pc = 100 / equity * margin;
    rr_text = IfTxt(new_risk_ratio < 1.0, StringFormat("-MarginUsed=%d%%|", margin_pc), ""); string s = "|";
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

/*
 * Return risk ratio value.
 */
double GetRiskRatio() {
  return If(RiskRatio == 0, GetAutoRiskRatio(), RiskRatio);
}

/*
 * Validate the e-mail.
 */
string ValidEmail(string text) {
  string output = StringLen(text);
  if (text == "") {
    last_err = "Error: E-mail is empty, please validate the settings.";
    Comment(last_err);
    Print(last_err);
    ea_active = FALSE;
    return FALSE;
  }
  if (StringFind(text, "@") == EMPTY || StringFind(text, ".") == EMPTY) {
    last_err = "Error: E-mail is not in valid format.";
    Comment(last_err);
    Print(last_err);
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

/*
 * Executed for every hour.
 */
void StartNewHour() {
  CheckHistory(); // Process closed orders for previous hour.

  hour_of_day = Hour(); // Start the new hour.
  if (VerboseDebug) PrintFormat("== New hour: %d", hour_of_day);

  // Update variables.
  risk_ratio = GetRiskRatio();
  max_orders = GetMaxOrders();

  if (day_of_week != DayOfWeek()) { // Check if new day has been started.
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

/*
 * Queue the message for display.
 */
void Message(string msg = NULL) {
  if (msg == NULL) { last_msg = ""; last_err = ""; }
  else last_msg = msg;
}

/*
 * Get last available message.
 */
string GetLastMessage() {
  return last_msg;
}

/*
 * Get last available error.
 */
string GetLastErrMsg() {
  return last_err;
}

/*
 * Executed for every new day.
 */
void StartNewDay() {
  if (VerboseInfo) PrintFormat("== New day (day of month: %d; day of year: %d ==",  Day(), DayOfYear());

  // Print daily report at end of each day.
  if (VerboseInfo) Print(GetDailyReport());

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

/*
 * Executed for every new week.
 */
void StartNewWeek() {
  if (VerboseInfo) Print("== New week ==");
  if (VerboseInfo) Print(GetWeeklyReport()); // Print weekly report at end of each week.

  // Calculate lot size, orders and risk.
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

/*
 * Executed for every new month.
 */
void StartNewMonth() {
  if (VerboseInfo) Print("== New month ==");
  if (VerboseInfo) Print(GetMonthlyReport()); // Print monthly report at end of each month.

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
    stats[j][MONTHLY_PROFIT] = MathMin(0, stats[j][MONTHLY_PROFIT]);
  }
  if (VerboseInfo) Print(strategy_stats);
}

/*
 * Executed for every new year.
 */
void StartNewYear() {
  if (VerboseInfo) Print("== New year ==");
  // if (VerboseInfo) Print(GetYearlyReport()); // Print monthly report at end of each year.

  // Reset variables.
  for (int i = 0; i < FINAL_PERIOD_TYPE_ENTRY; i++) {
    signals[YEARLY][SAR1][i][OP_BUY] = 0;
    signals[YEARLY][SAR1][i][OP_SELL] = 0;
  }
}

/* END: PERIODIC FUNCTIONS */

/* BEGIN: VARIABLE FUNCTIONS */

/*
 * Initialize startup variables.
 */
bool InitializeVariables() {

  bool init = TRUE;

  // Get type of account.
  if (IsDemo()) account_type = "Demo"; else account_type = "Live";
  if (IsTesting()) account_type = "Backtest on " + account_type;
  #ifdef __backtest__ init &= IsTesting(); #endif

  // Check time of the week, month and year based on the trading bars.
  time_current = TimeCurrent();
  bar_time = iTime(NULL, PERIOD_M1, 0);
  hour_of_day = Hour(); // The hour (0,1,2,..23) of the last known server time by the moment of the program start.
  day_of_week = DayOfWeek(); // The zero-based day of week (0 means Sunday,1,2,3,4,5,6) of the specified date. At the testing, the last known server time is modelled.
  day_of_month = Day(); // The day of month (1 - 31) of the specified date. At the testing, the last known server time is modelled.
  day_of_year = DayOfYear(); // Day (1 means 1 January,..,365(6) does 31 December) of year. At the testing, the last known server time is modelled.

  market_minlot = MarketInfo(_Symbol, MODE_MINLOT); // Minimum permitted amount of a lot
  if (market_minlot == 0.0) market_minlot = 0.1;
  market_maxlot = MarketInfo(_Symbol, MODE_MAXLOT); // Maximum permitted amount of a lot
  if (market_maxlot == 0.0) market_maxlot = 100;
  market_lotstep = MarketInfo(_Symbol, MODE_LOTSTEP); // Step for changing lots.
  market_lotsize = MarketInfo(_Symbol, MODE_LOTSIZE); // Lot size in the base currency.
  market_marginrequired = MarketInfo(_Symbol, MODE_MARGINREQUIRED); // Free margin required to open 1 lot for buying.
  if (market_marginrequired == 0) market_marginrequired = 10; // Fix for 'zero divide' bug when MODE_MARGINREQUIRED is zero.
  market_margininit = MarketInfo(_Symbol, MODE_MARGININIT); // Initial margin requirements for 1 lot
  market_stoplevel = MarketInfo(_Symbol, MODE_STOPLEVEL); // Market stop level in points.
  // market_stoplevel=(int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
  curr_spread = ValueToPips(GetMarketSpread());
  LastAsk = Ask; LastBid = Bid;
  init_balance = AccountBalance();
  init_spread = GetMarketSpread(TRUE);
  AccCurrency = AccountCurrency();

  // Calculate pip/volume/slippage size and precision.
  pip_size = GetPipSize();
  PipDigits = GetPipPrecision();
  pts_per_pip = GetPointsPerPip();
  VolumeDigits = GetVolumePrecision();
  max_order_slippage = PipsToPoints(MaxOrderPriceSlippage); // Maximum price slippage for buy or sell orders (converted into points).

  // Calculate lot size, orders and risk.
  lot_size = GetLotSize();
  risk_ratio = GetRiskRatio();
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
  return (init);
}

#ifdef __advanced__

/*
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
      QueueOrdersAIActive = !QueueOrdersAIActive;
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
      if (MinimumIntervalSec > 0) MinimumIntervalSec = 0;
      else MinimumIntervalSec = 240;
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
      ArrSetValueI(info, OPEN_CONDITION1,  0);
      break;
    case 38:
      ArrSetValueI(info, OPEN_CONDITION2,  0);
      break;
    case 39:
      ArrSetValueI(info, CLOSE_CONDITION, C_MACD_BUY_SELL);
      break;
    case 40:
      ArrSetValueD(conf, OPEN_LEVEL, 0.0);
      break;
    case 41:
      ArrSetValueD(conf, SPREAD_LIMIT,  100.0);
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

/*
 * Initialize strategies.
 */
bool InitializeStrategies() {

  // Initialize/reset strategy arrays.
  ArrayInitialize(info, 0);  // Reset strategy info.
  ArrayInitialize(conf, 0);  // Reset strategy configuration.
  ArrayInitialize(stats, 0); // Reset strategy statistics.

  // Initialize strategy array variables.
  #ifdef __advanced__
  InitStrategy(AC1,  "AC M1",  AC1_Active,  AC, PERIOD_M1,  AC1_OpenMethod,  AC_OpenLevel, AC1_OpenCondition1,  AC1_OpenCondition2,  AC1_CloseCondition,  AC1_MaxSpread);
  InitStrategy(AC5,  "AC M5",  AC5_Active,  AC, PERIOD_M5,  AC5_OpenMethod,  AC_OpenLevel, AC5_OpenCondition1,  AC5_OpenCondition2,  AC5_CloseCondition,  AC5_MaxSpread);
  InitStrategy(AC15, "AC M15", AC15_Active, AC, PERIOD_M15, AC15_OpenMethod, AC_OpenLevel, AC15_OpenCondition1, AC15_OpenCondition2, AC15_CloseCondition, AC15_MaxSpread);
  InitStrategy(AC30, "AC M30", AC30_Active, AC, PERIOD_M30, AC30_OpenMethod, AC_OpenLevel, AC30_OpenCondition1, AC30_OpenCondition2, AC30_CloseCondition, AC30_MaxSpread);
  #else
  InitStrategy(AC1,  "AC M1",  AC1_Active,  AC, PERIOD_M1,  AC1_OpenMethod,  AC_OpenLevel);
  InitStrategy(AC5,  "AC M5",  AC5_Active,  AC, PERIOD_M5,  AC5_OpenMethod,  AC_OpenLevel);
  InitStrategy(AC15, "AC M15", AC15_Active, AC, PERIOD_M15, AC15_OpenMethod, AC_OpenLevel);
  InitStrategy(AC30, "AC M30", AC30_Active, AC, PERIOD_M30, AC30_OpenMethod, AC_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(AD1,  "AD M1",  AD1_Active,  AD, PERIOD_M1,  AD1_OpenMethod,  AD_OpenLevel, AD1_OpenCondition1,  AD1_OpenCondition2,  AD1_CloseCondition,  AD1_MaxSpread);
  InitStrategy(AD5,  "AD M5",  AD5_Active,  AD, PERIOD_M5,  AD5_OpenMethod,  AD_OpenLevel, AD5_OpenCondition1,  AD5_OpenCondition2,  AD5_CloseCondition,  AD5_MaxSpread);
  InitStrategy(AD15, "AD M15", AD15_Active, AD, PERIOD_M15, AD15_OpenMethod, AD_OpenLevel, AD15_OpenCondition1, AD15_OpenCondition2, AD15_CloseCondition, AD15_MaxSpread);
  InitStrategy(AD30, "AD M30", AD30_Active, AD, PERIOD_M30, AD30_OpenMethod, AD_OpenLevel, AD30_OpenCondition1, AD30_OpenCondition2, AD30_CloseCondition, AD30_MaxSpread);
  #else
  InitStrategy(AD1,  "AD M1",  AD1_Active,  AD, PERIOD_M1,  AD1_OpenMethod,  AD_OpenLevel);
  InitStrategy(AD5,  "AD M5",  AD5_Active,  AD, PERIOD_M5,  AD5_OpenMethod,  AD_OpenLevel);
  InitStrategy(AD15, "AD M15", AD15_Active, AD, PERIOD_M15, AD15_OpenMethod, AD_OpenLevel);
  InitStrategy(AD30, "AD M30", AD30_Active, AD, PERIOD_M30, AD30_OpenMethod, AD_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(ADX1,  "ADX M1",  ADX1_Active,  ADX, PERIOD_M1,  ADX1_OpenMethod,  ADX_OpenLevel, ADX1_OpenCondition1,  ADX1_OpenCondition2,  ADX1_CloseCondition,  ADX1_MaxSpread);
  InitStrategy(ADX5,  "ADX M5",  ADX5_Active,  ADX, PERIOD_M5,  ADX5_OpenMethod,  ADX_OpenLevel, ADX5_OpenCondition1,  ADX5_OpenCondition2,  ADX5_CloseCondition,  ADX5_MaxSpread);
  InitStrategy(ADX15, "ADX M15", ADX15_Active, ADX, PERIOD_M15, ADX15_OpenMethod, ADX_OpenLevel, ADX15_OpenCondition1, ADX15_OpenCondition2, ADX15_CloseCondition, ADX15_MaxSpread);
  InitStrategy(ADX30, "ADX M30", ADX30_Active, ADX, PERIOD_M30, ADX30_OpenMethod, ADX_OpenLevel, ADX30_OpenCondition1, ADX30_OpenCondition2, ADX30_CloseCondition, ADX30_MaxSpread);
  #else
  InitStrategy(ADX1,  "ADX M1",  ADX1_Active,  ADX, PERIOD_M1,  ADX1_OpenMethod,  ADX_OpenLevel);
  InitStrategy(ADX5,  "ADX M5",  ADX5_Active,  ADX, PERIOD_M5,  ADX5_OpenMethod,  ADX_OpenLevel);
  InitStrategy(ADX15, "ADX M15", ADX15_Active, ADX, PERIOD_M15, ADX15_OpenMethod, ADX_OpenLevel);
  InitStrategy(ADX30, "ADX M30", ADX30_Active, ADX, PERIOD_M30, ADX30_OpenMethod, ADX_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(ALLIGATOR1,  "Alligator M1",  Alligator1_Active,  ALLIGATOR, PERIOD_M1,  Alligator1_OpenMethod,  Alligator_OpenLevel, Alligator1_OpenCondition1,  Alligator1_OpenCondition2,  Alligator1_CloseCondition,  Alligator1_MaxSpread);
  InitStrategy(ALLIGATOR5,  "Alligator M5",  Alligator5_Active,  ALLIGATOR, PERIOD_M5,  Alligator5_OpenMethod,  Alligator_OpenLevel, Alligator5_OpenCondition1,  Alligator5_OpenCondition2,  Alligator5_CloseCondition,  Alligator5_MaxSpread);
  InitStrategy(ALLIGATOR15, "Alligator M15", Alligator15_Active, ALLIGATOR, PERIOD_M15, Alligator15_OpenMethod, Alligator_OpenLevel, Alligator15_OpenCondition1, Alligator15_OpenCondition2, Alligator15_CloseCondition, Alligator15_MaxSpread);
  InitStrategy(ALLIGATOR30, "Alligator M30", Alligator30_Active, ALLIGATOR, PERIOD_M30, Alligator30_OpenMethod, Alligator_OpenLevel, Alligator30_OpenCondition1, Alligator30_OpenCondition2, Alligator30_CloseCondition, Alligator30_MaxSpread);
  #else
  InitStrategy(ALLIGATOR1,  "Alligator M1",  Alligator1_Active,  ALLIGATOR, PERIOD_M1,  Alligator1_OpenMethod,  Alligator_OpenLevel);
  InitStrategy(ALLIGATOR5,  "Alligator M5",  Alligator5_Active,  ALLIGATOR, PERIOD_M5,  Alligator5_OpenMethod,  Alligator_OpenLevel);
  InitStrategy(ALLIGATOR15, "Alligator M15", Alligator15_Active, ALLIGATOR, PERIOD_M15, Alligator15_OpenMethod, Alligator_OpenLevel);
  InitStrategy(ALLIGATOR30, "Alligator M30", Alligator30_Active, ALLIGATOR, PERIOD_M30, Alligator30_OpenMethod, Alligator_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(ATR1,  "ATR M1",  ATR1_Active,  ATR, PERIOD_M1,  ATR1_OpenMethod,  ATR_OpenLevel, ATR1_OpenCondition1,  ATR1_OpenCondition2,  ATR1_CloseCondition,  ATR1_MaxSpread);
  InitStrategy(ATR5,  "ATR M5",  ATR5_Active,  ATR, PERIOD_M5,  ATR5_OpenMethod,  ATR_OpenLevel, ATR5_OpenCondition1,  ATR5_OpenCondition2,  ATR5_CloseCondition,  ATR5_MaxSpread);
  InitStrategy(ATR15, "ATR M15", ATR15_Active, ATR, PERIOD_M15, ATR15_OpenMethod, ATR_OpenLevel, ATR15_OpenCondition1, ATR15_OpenCondition2, ATR15_CloseCondition, ATR15_MaxSpread);
  InitStrategy(ATR30, "ATR M30", ATR30_Active, ATR, PERIOD_M30, ATR30_OpenMethod, ATR_OpenLevel, ATR30_OpenCondition1, ATR30_OpenCondition2, ATR30_CloseCondition, ATR30_MaxSpread);
  #else
  InitStrategy(ATR1,  "ATR M1",  ATR1_Active,  ATR, PERIOD_M1,  ATR1_OpenMethod,  ATR_OpenLevel);
  InitStrategy(ATR5,  "ATR M5",  ATR5_Active,  ATR, PERIOD_M5,  ATR5_OpenMethod,  ATR_OpenLevel);
  InitStrategy(ATR15, "ATR M15", ATR15_Active, ATR, PERIOD_M15, ATR15_OpenMethod, ATR_OpenLevel);
  InitStrategy(ATR30, "ATR M30", ATR30_Active, ATR, PERIOD_M30, ATR30_OpenMethod, ATR_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(AWESOME1,  "Awesome M1",  Awesome1_Active,  AWESOME, PERIOD_M1,  Awesome1_OpenMethod,  Awesome_OpenLevel, Awesome1_OpenCondition1,  Awesome1_OpenCondition2,  Awesome1_CloseCondition,  Awesome1_MaxSpread);
  InitStrategy(AWESOME5,  "Awesome M5",  Awesome5_Active,  AWESOME, PERIOD_M5,  Awesome5_OpenMethod,  Awesome_OpenLevel, Awesome5_OpenCondition1,  Awesome5_OpenCondition2,  Awesome5_CloseCondition,  Awesome5_MaxSpread);
  InitStrategy(AWESOME15, "Awesome M15", Awesome15_Active, AWESOME, PERIOD_M15, Awesome15_OpenMethod, Awesome_OpenLevel, Awesome15_OpenCondition1, Awesome15_OpenCondition2, Awesome15_CloseCondition, Awesome15_MaxSpread);
  InitStrategy(AWESOME30, "Awesome M30", Awesome30_Active, AWESOME, PERIOD_M30, Awesome30_OpenMethod, Awesome_OpenLevel, Awesome30_OpenCondition1, Awesome30_OpenCondition2, Awesome30_CloseCondition, Awesome30_MaxSpread);
  #else
  InitStrategy(AWESOME1,  "Awesome M1",  Awesome1_Active,  AWESOME, PERIOD_M1,  Awesome1_OpenMethod,  Awesome_OpenLevel);
  InitStrategy(AWESOME5,  "Awesome M5",  Awesome5_Active,  AWESOME, PERIOD_M5,  Awesome5_OpenMethod,  Awesome_OpenLevel);
  InitStrategy(AWESOME15, "Awesome M15", Awesome15_Active, AWESOME, PERIOD_M15, Awesome15_OpenMethod, Awesome_OpenLevel);
  InitStrategy(AWESOME30, "Awesome M30", Awesome30_Active, AWESOME, PERIOD_M30, Awesome30_OpenMethod, Awesome_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(BANDS1,  "Bands M1",  Bands1_Active,  BANDS, PERIOD_M1,  Bands1_OpenMethod,  Bands_OpenLevel, Bands1_OpenCondition1,  Bands1_OpenCondition2,  Bands1_CloseCondition,  Bands1_MaxSpread);
  InitStrategy(BANDS5,  "Bands M5",  Bands5_Active,  BANDS, PERIOD_M5,  Bands5_OpenMethod,  Bands_OpenLevel, Bands5_OpenCondition1,  Bands5_OpenCondition2,  Bands5_CloseCondition,  Bands5_MaxSpread);
  InitStrategy(BANDS15, "Bands M15", Bands15_Active, BANDS, PERIOD_M15, Bands15_OpenMethod, Bands_OpenLevel, Bands15_OpenCondition1, Bands15_OpenCondition2, Bands15_CloseCondition, Bands15_MaxSpread);
  InitStrategy(BANDS30, "Bands M30", Bands30_Active, BANDS, PERIOD_M30, Bands30_OpenMethod, Bands_OpenLevel, Bands30_OpenCondition1, Bands30_OpenCondition2, Bands30_CloseCondition, Bands30_MaxSpread);
  #else
  InitStrategy(BANDS1,  "Bands M1",  Bands1_Active,  BANDS, PERIOD_M1,  Bands1_OpenMethod,  Bands_OpenLevel);
  InitStrategy(BANDS5,  "Bands M5",  Bands5_Active,  BANDS, PERIOD_M5,  Bands5_OpenMethod,  Bands_OpenLevel);
  InitStrategy(BANDS15, "Bands M15", Bands15_Active, BANDS, PERIOD_M15, Bands15_OpenMethod, Bands_OpenLevel);
  InitStrategy(BANDS30, "Bands M30", Bands30_Active, BANDS, PERIOD_M30, Bands30_OpenMethod, Bands_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(BPOWER1,  "BPower M1",  BPower1_Active,  BPOWER, PERIOD_M1,  BPower1_OpenMethod,  BPower_OpenLevel, BPower1_OpenCondition1,  BPower1_OpenCondition2,  BPower1_CloseCondition,  BPower1_MaxSpread);
  InitStrategy(BPOWER5,  "BPower M5",  BPower5_Active,  BPOWER, PERIOD_M5,  BPower5_OpenMethod,  BPower_OpenLevel, BPower5_OpenCondition1,  BPower5_OpenCondition2,  BPower5_CloseCondition,  BPower5_MaxSpread);
  InitStrategy(BPOWER15, "BPower M15", BPower15_Active, BPOWER, PERIOD_M15, BPower15_OpenMethod, BPower_OpenLevel, BPower15_OpenCondition1, BPower15_OpenCondition2, BPower15_CloseCondition, BPower15_MaxSpread);
  InitStrategy(BPOWER30, "BPower M30", BPower30_Active, BPOWER, PERIOD_M30, BPower30_OpenMethod, BPower_OpenLevel, BPower30_OpenCondition1, BPower30_OpenCondition2, BPower30_CloseCondition, BPower30_MaxSpread);
  #else
  InitStrategy(BPOWER1,  "BPower M1",  BPower1_Active,  BPOWER, PERIOD_M1,  BPower1_OpenMethod,  BPower_OpenLevel);
  InitStrategy(BPOWER5,  "BPower M5",  BPower5_Active,  BPOWER, PERIOD_M5,  BPower5_OpenMethod,  BPower_OpenLevel);
  InitStrategy(BPOWER15, "BPower M15", BPower15_Active, BPOWER, PERIOD_M15, BPower15_OpenMethod, BPower_OpenLevel);
  InitStrategy(BPOWER30, "BPower M30", BPower30_Active, BPOWER, PERIOD_M30, BPower30_OpenMethod, BPower_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(BREAKAGE1,  "Breakage M1",  Breakage1_Active,  EMPTY, PERIOD_M1,  Breakage1_OpenMethod,  Breakage_OpenLevel, Breakage1_OpenCondition1,  Breakage1_OpenCondition2,  Breakage1_CloseCondition,  Breakage1_MaxSpread);
  InitStrategy(BREAKAGE5,  "Breakage M5",  Breakage5_Active,  EMPTY, PERIOD_M5,  Breakage5_OpenMethod,  Breakage_OpenLevel, Breakage5_OpenCondition1,  Breakage5_OpenCondition2,  Breakage5_CloseCondition,  Breakage5_MaxSpread);
  InitStrategy(BREAKAGE15, "Breakage M15", Breakage15_Active, EMPTY, PERIOD_M15, Breakage15_OpenMethod, Breakage_OpenLevel, Breakage15_OpenCondition1, Breakage15_OpenCondition2, Breakage15_CloseCondition, Breakage15_MaxSpread);
  InitStrategy(BREAKAGE30, "Breakage M30", Breakage30_Active, EMPTY, PERIOD_M30, Breakage30_OpenMethod, Breakage_OpenLevel, Breakage30_OpenCondition1, Breakage30_OpenCondition2, Breakage30_CloseCondition, Breakage30_MaxSpread);
  #else
  InitStrategy(BREAKAGE1,  "Breakage M1",  Breakage1_Active,  EMPTY, PERIOD_M1,  Breakage1_OpenMethod,  Breakage_OpenLevel);
  InitStrategy(BREAKAGE5,  "Breakage M5",  Breakage5_Active,  EMPTY, PERIOD_M5,  Breakage5_OpenMethod,  Breakage_OpenLevel);
  InitStrategy(BREAKAGE15, "Breakage M15", Breakage15_Active, EMPTY, PERIOD_M15, Breakage15_OpenMethod, Breakage_OpenLevel);
  InitStrategy(BREAKAGE30, "Breakage M30", Breakage30_Active, EMPTY, PERIOD_M30, Breakage30_OpenMethod, Breakage_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(BWMFI1,  "BWMFI M1",  BWMFI1_Active,  EMPTY, PERIOD_M1,  BWMFI1_OpenMethod,  BWMFI_OpenLevel, BWMFI1_OpenCondition1,  BWMFI1_OpenCondition2,  BWMFI1_CloseCondition,  BWMFI1_MaxSpread);
  InitStrategy(BWMFI5,  "BWMFI M5",  BWMFI5_Active,  EMPTY, PERIOD_M5,  BWMFI5_OpenMethod,  BWMFI_OpenLevel, BWMFI5_OpenCondition1,  BWMFI5_OpenCondition2,  BWMFI5_CloseCondition,  BWMFI5_MaxSpread);
  InitStrategy(BWMFI15, "BWMFI M15", BWMFI15_Active, EMPTY, PERIOD_M15, BWMFI15_OpenMethod, BWMFI_OpenLevel, BWMFI15_OpenCondition1, BWMFI15_OpenCondition2, BWMFI15_CloseCondition, BWMFI15_MaxSpread);
  InitStrategy(BWMFI30, "BWMFI M30", BWMFI30_Active, EMPTY, PERIOD_M30, BWMFI30_OpenMethod, BWMFI_OpenLevel, BWMFI30_OpenCondition1, BWMFI30_OpenCondition2, BWMFI30_CloseCondition, BWMFI30_MaxSpread);
  #else
  InitStrategy(BWMFI1,  "BWMFI M1",  BWMFI1_Active,  EMPTY, PERIOD_M1,  BWMFI1_OpenMethod,  BWMFI_OpenLevel);
  InitStrategy(BWMFI5,  "BWMFI M5",  BWMFI5_Active,  EMPTY, PERIOD_M5,  BWMFI5_OpenMethod,  BWMFI_OpenLevel);
  InitStrategy(BWMFI15, "BWMFI M15", BWMFI15_Active, EMPTY, PERIOD_M15, BWMFI15_OpenMethod, BWMFI_OpenLevel);
  InitStrategy(BWMFI30, "BWMFI M30", BWMFI30_Active, EMPTY, PERIOD_M30, BWMFI30_OpenMethod, BWMFI_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(CCI1,  "CCI M1",  CCI1_Active,  CCI, PERIOD_M1,  CCI1_OpenMethod,  CCI_OpenLevel, CCI1_OpenCondition1,  CCI1_OpenCondition2,  CCI1_CloseCondition,  CCI1_MaxSpread);
  InitStrategy(CCI5,  "CCI M5",  CCI5_Active,  CCI, PERIOD_M5,  CCI5_OpenMethod,  CCI_OpenLevel, CCI5_OpenCondition1,  CCI5_OpenCondition2,  CCI5_CloseCondition,  CCI5_MaxSpread);
  InitStrategy(CCI15, "CCI M15", CCI15_Active, CCI, PERIOD_M15, CCI15_OpenMethod, CCI_OpenLevel, CCI15_OpenCondition1, CCI15_OpenCondition2, CCI15_CloseCondition, CCI15_MaxSpread);
  InitStrategy(CCI30, "CCI M30", CCI30_Active, CCI, PERIOD_M30, CCI30_OpenMethod, CCI_OpenLevel, CCI30_OpenCondition1, CCI30_OpenCondition2, CCI30_CloseCondition, CCI30_MaxSpread);
  #else
  InitStrategy(CCI1,  "CCI M1",  CCI1_Active,  CCI, PERIOD_M1,  CCI1_OpenMethod,  CCI_OpenLevel);
  InitStrategy(CCI5,  "CCI M5",  CCI5_Active,  CCI, PERIOD_M5,  CCI5_OpenMethod,  CCI_OpenLevel);
  InitStrategy(CCI15, "CCI M15", CCI15_Active, CCI, PERIOD_M15, CCI15_OpenMethod, CCI_OpenLevel);
  InitStrategy(CCI30, "CCI M30", CCI30_Active, CCI, PERIOD_M30, CCI30_OpenMethod, CCI_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(DEMARKER1,  "DeMarker M1",  DeMarker1_Active,  DEMARKER, PERIOD_M1,  DeMarker1_OpenMethod,  DeMarker_OpenLevel, DeMarker1_OpenCondition1,  DeMarker1_OpenCondition2,  DeMarker1_CloseCondition,  DeMarker1_MaxSpread);
  InitStrategy(DEMARKER5,  "DeMarker M5",  DeMarker5_Active,  DEMARKER, PERIOD_M5,  DeMarker5_OpenMethod,  DeMarker_OpenLevel, DeMarker5_OpenCondition1,  DeMarker5_OpenCondition2,  DeMarker5_CloseCondition,  DeMarker5_MaxSpread);
  InitStrategy(DEMARKER15, "DeMarker M15", DeMarker15_Active, DEMARKER, PERIOD_M15, DeMarker15_OpenMethod, DeMarker_OpenLevel, DeMarker15_OpenCondition1, DeMarker15_OpenCondition2, DeMarker15_CloseCondition, DeMarker15_MaxSpread);
  InitStrategy(DEMARKER30, "DeMarker M30", DeMarker30_Active, DEMARKER, PERIOD_M30, DeMarker30_OpenMethod, DeMarker_OpenLevel, DeMarker30_OpenCondition1, DeMarker30_OpenCondition2, DeMarker30_CloseCondition, DeMarker30_MaxSpread);
  #else
  InitStrategy(DEMARKER1,  "DeMarker M1",  DeMarker1_Active,  DEMARKER, PERIOD_M1,  DeMarker1_OpenMethod,  DeMarker_OpenLevel);
  InitStrategy(DEMARKER5,  "DeMarker M5",  DeMarker5_Active,  DEMARKER, PERIOD_M5,  DeMarker5_OpenMethod,  DeMarker_OpenLevel);
  InitStrategy(DEMARKER15, "DeMarker M15", DeMarker15_Active, DEMARKER, PERIOD_M15, DeMarker15_OpenMethod, DeMarker_OpenLevel);
  InitStrategy(DEMARKER30, "DeMarker M30", DeMarker30_Active, DEMARKER, PERIOD_M30, DeMarker30_OpenMethod, DeMarker_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(ENVELOPES1,  "Envelopes M1",  Envelopes1_Active,  ENVELOPES, PERIOD_M1,  Envelopes1_OpenMethod,  Envelopes_OpenLevel, Envelopes1_OpenCondition1,  Envelopes1_OpenCondition2,  Envelopes1_CloseCondition,  Envelopes1_MaxSpread);
  InitStrategy(ENVELOPES5,  "Envelopes M5",  Envelopes5_Active,  ENVELOPES, PERIOD_M5,  Envelopes5_OpenMethod,  Envelopes_OpenLevel, Envelopes5_OpenCondition1,  Envelopes5_OpenCondition2,  Envelopes5_CloseCondition,  Envelopes5_MaxSpread);
  InitStrategy(ENVELOPES15, "Envelopes M15", Envelopes15_Active, ENVELOPES, PERIOD_M15, Envelopes15_OpenMethod, Envelopes_OpenLevel, Envelopes15_OpenCondition1, Envelopes15_OpenCondition2, Envelopes15_CloseCondition, Envelopes15_MaxSpread);
  InitStrategy(ENVELOPES30, "Envelopes M30", Envelopes30_Active, ENVELOPES, PERIOD_M30, Envelopes30_OpenMethod, Envelopes_OpenLevel, Envelopes30_OpenCondition1, Envelopes30_OpenCondition2, Envelopes30_CloseCondition, Envelopes30_MaxSpread);
  #else
  InitStrategy(ENVELOPES1,  "Envelopes M1",  Envelopes1_Active,  ENVELOPES, PERIOD_M1,  Envelopes1_OpenMethod,  Envelopes_OpenLevel);
  InitStrategy(ENVELOPES5,  "Envelopes M5",  Envelopes5_Active,  ENVELOPES, PERIOD_M5,  Envelopes5_OpenMethod,  Envelopes_OpenLevel);
  InitStrategy(ENVELOPES15, "Envelopes M15", Envelopes15_Active, ENVELOPES, PERIOD_M15, Envelopes15_OpenMethod, Envelopes_OpenLevel);
  InitStrategy(ENVELOPES30, "Envelopes M30", Envelopes30_Active, ENVELOPES, PERIOD_M30, Envelopes30_OpenMethod, Envelopes_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(FORCE1,  "Force M1",  Force1_Active,  FORCE, PERIOD_M1,  Force1_OpenMethod,  Force_OpenLevel, Force1_OpenCondition1,  Force1_OpenCondition2,  Force1_CloseCondition,  Force1_MaxSpread);
  InitStrategy(FORCE5,  "Force M5",  Force5_Active,  FORCE, PERIOD_M5,  Force5_OpenMethod,  Force_OpenLevel, Force5_OpenCondition1,  Force5_OpenCondition2,  Force5_CloseCondition,  Force5_MaxSpread);
  InitStrategy(FORCE15, "Force M15", Force15_Active, FORCE, PERIOD_M15, Force15_OpenMethod, Force_OpenLevel, Force15_OpenCondition1, Force15_OpenCondition2, Force15_CloseCondition, Force15_MaxSpread);
  InitStrategy(FORCE30, "Force M30", Force30_Active, FORCE, PERIOD_M30, Force30_OpenMethod, Force_OpenLevel, Force30_OpenCondition1, Force30_OpenCondition2, Force30_CloseCondition, Force30_MaxSpread);
  #else
  InitStrategy(FORCE1,  "Force M1",  Force1_Active,  FORCE, PERIOD_M1,  Force1_OpenMethod,  Force_OpenLevel);
  InitStrategy(FORCE5,  "Force M5",  Force5_Active,  FORCE, PERIOD_M5,  Force5_OpenMethod,  Force_OpenLevel);
  InitStrategy(FORCE15, "Force M15", Force15_Active, FORCE, PERIOD_M15, Force15_OpenMethod, Force_OpenLevel);
  InitStrategy(FORCE30, "Force M30", Force30_Active, FORCE, PERIOD_M30, Force30_OpenMethod, Force_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(FRACTALS1,  "Fractals M1",  Fractals1_Active,  FRACTALS, PERIOD_M1,  Fractals1_OpenMethod,  Fractals_OpenLevel, Fractals1_OpenCondition1,  Fractals1_OpenCondition2,  Fractals1_CloseCondition,  Fractals1_MaxSpread);
  InitStrategy(FRACTALS5,  "Fractals M5",  Fractals5_Active,  FRACTALS, PERIOD_M5,  Fractals5_OpenMethod,  Fractals_OpenLevel, Fractals5_OpenCondition1,  Fractals5_OpenCondition2,  Fractals5_CloseCondition,  Fractals5_MaxSpread);
  InitStrategy(FRACTALS15, "Fractals M15", Fractals15_Active, FRACTALS, PERIOD_M15, Fractals15_OpenMethod, Fractals_OpenLevel, Fractals15_OpenCondition1, Fractals15_OpenCondition2, Fractals15_CloseCondition, Fractals15_MaxSpread);
  InitStrategy(FRACTALS30, "Fractals M30", Fractals30_Active, FRACTALS, PERIOD_M30, Fractals30_OpenMethod, Fractals_OpenLevel, Fractals30_OpenCondition1, Fractals30_OpenCondition2, Fractals30_CloseCondition, Fractals30_MaxSpread);
  #else
  InitStrategy(FRACTALS1,  "Fractals M1",  Fractals1_Active,  FRACTALS, PERIOD_M1,  Fractals1_OpenMethod,  Fractals_OpenLevel);
  InitStrategy(FRACTALS5,  "Fractals M5",  Fractals5_Active,  FRACTALS, PERIOD_M5,  Fractals5_OpenMethod,  Fractals_OpenLevel);
  InitStrategy(FRACTALS15, "Fractals M15", Fractals15_Active, FRACTALS, PERIOD_M15, Fractals15_OpenMethod, Fractals_OpenLevel);
  InitStrategy(FRACTALS30, "Fractals M30", Fractals30_Active, FRACTALS, PERIOD_M30, Fractals30_OpenMethod, Fractals_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(GATOR1,  "Gator M1",  Gator1_Active,  GATOR, PERIOD_M1,  Gator1_OpenMethod,  Gator_OpenLevel, Gator1_OpenCondition1,  Gator1_OpenCondition2,  Gator1_CloseCondition,  Gator1_MaxSpread);
  InitStrategy(GATOR5,  "Gator M5",  Gator5_Active,  GATOR, PERIOD_M5,  Gator5_OpenMethod,  Gator_OpenLevel, Gator5_OpenCondition1,  Gator5_OpenCondition2,  Gator5_CloseCondition,  Gator5_MaxSpread);
  InitStrategy(GATOR15, "Gator M15", Gator15_Active, GATOR, PERIOD_M15, Gator15_OpenMethod, Gator_OpenLevel, Gator15_OpenCondition1, Gator15_OpenCondition2, Gator15_CloseCondition, Gator15_MaxSpread);
  InitStrategy(GATOR30, "Gator M30", Gator30_Active, GATOR, PERIOD_M30, Gator30_OpenMethod, Gator_OpenLevel, Gator30_OpenCondition1, Gator30_OpenCondition2, Gator30_CloseCondition, Gator30_MaxSpread);
  #else
  InitStrategy(GATOR1,  "Gator M1",  Gator1_Active,  GATOR, PERIOD_M1,  Gator1_OpenMethod,  Gator_OpenLevel);
  InitStrategy(GATOR5,  "Gator M5",  Gator5_Active,  GATOR, PERIOD_M5,  Gator5_OpenMethod,  Gator_OpenLevel);
  InitStrategy(GATOR15, "Gator M15", Gator15_Active, GATOR, PERIOD_M15, Gator15_OpenMethod, Gator_OpenLevel);
  InitStrategy(GATOR30, "Gator M30", Gator30_Active, GATOR, PERIOD_M30, Gator30_OpenMethod, Gator_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(ICHIMOKU1,  "Ichimoku M1",  Ichimoku1_Active,  ICHIMOKU, PERIOD_M1,  Ichimoku1_OpenMethod,  Ichimoku_OpenLevel, Ichimoku1_OpenCondition1,  Ichimoku1_OpenCondition2,  Ichimoku1_CloseCondition,  Ichimoku1_MaxSpread);
  InitStrategy(ICHIMOKU5,  "Ichimoku M5",  Ichimoku5_Active,  ICHIMOKU, PERIOD_M5,  Ichimoku5_OpenMethod,  Ichimoku_OpenLevel, Ichimoku5_OpenCondition1,  Ichimoku5_OpenCondition2,  Ichimoku5_CloseCondition,  Ichimoku5_MaxSpread);
  InitStrategy(ICHIMOKU15, "Ichimoku M15", Ichimoku15_Active, ICHIMOKU, PERIOD_M15, Ichimoku15_OpenMethod, Ichimoku_OpenLevel, Ichimoku15_OpenCondition1, Ichimoku15_OpenCondition2, Ichimoku15_CloseCondition, Ichimoku15_MaxSpread);
  InitStrategy(ICHIMOKU30, "Ichimoku M30", Ichimoku30_Active, ICHIMOKU, PERIOD_M30, Ichimoku30_OpenMethod, Ichimoku_OpenLevel, Ichimoku30_OpenCondition1, Ichimoku30_OpenCondition2, Ichimoku30_CloseCondition, Ichimoku30_MaxSpread);
  #else
  InitStrategy(ICHIMOKU1,  "Ichimoku M1",  Ichimoku1_Active,  ICHIMOKU, PERIOD_M1,  Ichimoku1_OpenMethod,  Ichimoku_OpenLevel);
  InitStrategy(ICHIMOKU5,  "Ichimoku M5",  Ichimoku5_Active,  ICHIMOKU, PERIOD_M5,  Ichimoku5_OpenMethod,  Ichimoku_OpenLevel);
  InitStrategy(ICHIMOKU15, "Ichimoku M15", Ichimoku15_Active, ICHIMOKU, PERIOD_M15, Ichimoku15_OpenMethod, Ichimoku_OpenLevel);
  InitStrategy(ICHIMOKU30, "Ichimoku M30", Ichimoku30_Active, ICHIMOKU, PERIOD_M30, Ichimoku30_OpenMethod, Ichimoku_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(MA1,  "MA M1",  MA1_Active,  MA, PERIOD_M1,  MA1_OpenMethod,  MA_OpenLevel,  MA1_OpenCondition1, MA1_OpenCondition2,  MA1_CloseCondition,  MA1_MaxSpread);
  InitStrategy(MA5,  "MA M5",  MA5_Active,  MA, PERIOD_M5,  MA5_OpenMethod,  MA_OpenLevel,  MA5_OpenCondition1, MA5_OpenCondition2,  MA5_CloseCondition,  MA5_MaxSpread);
  InitStrategy(MA15, "MA M15", MA15_Active, MA, PERIOD_M15, MA15_OpenMethod, MA_OpenLevel, MA15_OpenCondition1, MA15_OpenCondition2, MA15_CloseCondition, MA15_MaxSpread);
  InitStrategy(MA30, "MA M30", MA30_Active, MA, PERIOD_M30, MA30_OpenMethod, MA_OpenLevel, MA30_OpenCondition1, MA30_OpenCondition2, MA30_CloseCondition, MA30_MaxSpread);
  #else
  InitStrategy(MA1,  "MA M1",  MA1_Active,  MA, PERIOD_M1,  MA1_OpenMethod,  MA_OpenLevel);
  InitStrategy(MA5,  "MA M5",  MA5_Active,  MA, PERIOD_M5,  MA5_OpenMethod,  MA_OpenLevel);
  InitStrategy(MA15, "MA M15", MA15_Active, MA, PERIOD_M15, MA15_OpenMethod, MA_OpenLevel);
  InitStrategy(MA30, "MA M30", MA30_Active, MA, PERIOD_M30, MA30_OpenMethod, MA_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(MACD1,  "MACD M1",  MACD1_Active,  MACD, PERIOD_M1,  MACD1_OpenMethod,  MACD_OpenLevel, MACD1_OpenCondition1,  MACD1_OpenCondition2,  MACD1_CloseCondition,  MACD1_MaxSpread);
  InitStrategy(MACD5,  "MACD M5",  MACD5_Active,  MACD, PERIOD_M5,  MACD5_OpenMethod,  MACD_OpenLevel, MACD5_OpenCondition1,  MACD5_OpenCondition2,  MACD5_CloseCondition,  MACD5_MaxSpread);
  InitStrategy(MACD15, "MACD M15", MACD15_Active, MACD, PERIOD_M15, MACD15_OpenMethod, MACD_OpenLevel, MACD15_OpenCondition1, MACD15_OpenCondition2, MACD15_CloseCondition, MACD15_MaxSpread);
  InitStrategy(MACD30, "MACD M30", MACD30_Active, MACD, PERIOD_M30, MACD30_OpenMethod, MACD_OpenLevel, MACD30_OpenCondition1, MACD30_OpenCondition2, MACD30_CloseCondition, MACD30_MaxSpread);
  #else
  InitStrategy(MACD1,  "MACD M1",  MACD1_Active,  MACD, PERIOD_M1,  MACD1_OpenMethod,  MACD_OpenLevel);
  InitStrategy(MACD5,  "MACD M5",  MACD5_Active,  MACD, PERIOD_M5,  MACD5_OpenMethod,  MACD_OpenLevel);
  InitStrategy(MACD15, "MACD M15", MACD15_Active, MACD, PERIOD_M15, MACD15_OpenMethod, MACD_OpenLevel);
  InitStrategy(MACD30, "MACD M30", MACD30_Active, MACD, PERIOD_M30, MACD30_OpenMethod, MACD_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(MFI1,  "MFI M1",  MFI1_Active,  MFI, PERIOD_M1,  MFI1_OpenMethod,  MFI_OpenLevel, MFI1_OpenCondition1,  MFI1_OpenCondition2,  MFI1_CloseCondition,  MFI1_MaxSpread);
  InitStrategy(MFI5,  "MFI M5",  MFI5_Active,  MFI, PERIOD_M5,  MFI5_OpenMethod,  MFI_OpenLevel, MFI5_OpenCondition1,  MFI5_OpenCondition2,  MFI5_CloseCondition,  MFI5_MaxSpread);
  InitStrategy(MFI15, "MFI M15", MFI15_Active, MFI, PERIOD_M15, MFI15_OpenMethod, MFI_OpenLevel, MFI15_OpenCondition1, MFI15_OpenCondition2, MFI15_CloseCondition, MFI15_MaxSpread);
  InitStrategy(MFI30, "MFI M30", MFI30_Active, MFI, PERIOD_M30, MFI30_OpenMethod, MFI_OpenLevel, MFI30_OpenCondition1, MFI30_OpenCondition2, MFI30_CloseCondition, MFI30_MaxSpread);
  #else
  InitStrategy(MFI1,  "MFI M1",  MFI1_Active,  MFI, PERIOD_M1,  MFI1_OpenMethod,  MFI_OpenLevel);
  InitStrategy(MFI5,  "MFI M5",  MFI5_Active,  MFI, PERIOD_M5,  MFI5_OpenMethod,  MFI_OpenLevel);
  InitStrategy(MFI15, "MFI M15", MFI15_Active, MFI, PERIOD_M15, MFI15_OpenMethod, MFI_OpenLevel);
  InitStrategy(MFI30, "MFI M30", MFI30_Active, MFI, PERIOD_M30, MFI30_OpenMethod, MFI_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(MOMENTUM1,  "Momentum M1",  Momentum1_Active,  MOMENTUM, PERIOD_M1,  Momentum1_OpenMethod,  Momentum_OpenLevel, Momentum1_OpenCondition1,  Momentum1_OpenCondition2,  Momentum1_CloseCondition,  Momentum1_MaxSpread);
  InitStrategy(MOMENTUM5,  "Momentum M5",  Momentum5_Active,  MOMENTUM, PERIOD_M5,  Momentum5_OpenMethod,  Momentum_OpenLevel, Momentum5_OpenCondition1,  Momentum5_OpenCondition2,  Momentum5_CloseCondition,  Momentum5_MaxSpread);
  InitStrategy(MOMENTUM15, "Momentum M15", Momentum15_Active, MOMENTUM, PERIOD_M15, Momentum15_OpenMethod, Momentum_OpenLevel, Momentum15_OpenCondition1, Momentum15_OpenCondition2, Momentum15_CloseCondition, Momentum15_MaxSpread);
  InitStrategy(MOMENTUM30, "Momentum M30", Momentum30_Active, MOMENTUM, PERIOD_M30, Momentum30_OpenMethod, Momentum_OpenLevel, Momentum30_OpenCondition1, Momentum30_OpenCondition2, Momentum30_CloseCondition, Momentum30_MaxSpread);
  #else
  InitStrategy(MOMENTUM1,  "Momentum M1",  Momentum1_Active,  MOMENTUM, PERIOD_M1,  Momentum1_OpenMethod,  Momentum_OpenLevel);
  InitStrategy(MOMENTUM5,  "Momentum M5",  Momentum5_Active,  MOMENTUM, PERIOD_M5,  Momentum5_OpenMethod,  Momentum_OpenLevel);
  InitStrategy(MOMENTUM15, "Momentum M15", Momentum15_Active, MOMENTUM, PERIOD_M15, Momentum15_OpenMethod, Momentum_OpenLevel);
  InitStrategy(MOMENTUM30, "Momentum M30", Momentum30_Active, MOMENTUM, PERIOD_M30, Momentum30_OpenMethod, Momentum_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(OBV1,  "OBV M1",  OBV1_Active,  OBV, PERIOD_M1,  OBV1_OpenMethod,  OBV_OpenLevel,  OBV1_OpenCondition1, OBV1_OpenCondition2,  OBV1_CloseCondition,  OBV1_MaxSpread);
  InitStrategy(OBV5,  "OBV M5",  OBV5_Active,  OBV, PERIOD_M5,  OBV5_OpenMethod,  OBV_OpenLevel,  OBV5_OpenCondition1, OBV5_OpenCondition2,  OBV5_CloseCondition,  OBV5_MaxSpread);
  InitStrategy(OBV15, "OBV M15", OBV15_Active, OBV, PERIOD_M15, OBV15_OpenMethod, OBV_OpenLevel, OBV15_OpenCondition1, OBV15_OpenCondition2, OBV15_CloseCondition, OBV15_MaxSpread);
  InitStrategy(OBV30, "OBV M30", OBV30_Active, OBV, PERIOD_M30, OBV30_OpenMethod, OBV_OpenLevel, OBV30_OpenCondition1, OBV30_OpenCondition2, OBV30_CloseCondition, OBV30_MaxSpread);
  #else
  InitStrategy(OBV1,  "OBV M1",  OBV1_Active,  OBV, PERIOD_M1,  OBV1_OpenMethod,  OBV_OpenLevel);
  InitStrategy(OBV5,  "OBV M5",  OBV5_Active,  OBV, PERIOD_M5,  OBV5_OpenMethod,  OBV_OpenLevel);
  InitStrategy(OBV15, "OBV M15", OBV15_Active, OBV, PERIOD_M15, OBV15_OpenMethod, OBV_OpenLevel);
  InitStrategy(OBV30, "OBV M30", OBV30_Active, OBV, PERIOD_M30, OBV30_OpenMethod, OBV_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(OSMA1,  "OSMA M1",  OSMA1_Active,  OSMA, PERIOD_M1,  OSMA1_OpenMethod,  OSMA_OpenLevel, OSMA1_OpenCondition1,  OSMA1_OpenCondition2,  OSMA1_CloseCondition,  OSMA1_MaxSpread);
  InitStrategy(OSMA5,  "OSMA M5",  OSMA5_Active,  OSMA, PERIOD_M5,  OSMA5_OpenMethod,  OSMA_OpenLevel, OSMA5_OpenCondition1,  OSMA5_OpenCondition2,  OSMA5_CloseCondition,  OSMA5_MaxSpread);
  InitStrategy(OSMA15, "OSMA M15", OSMA15_Active, OSMA, PERIOD_M15, OSMA15_OpenMethod, OSMA_OpenLevel, OSMA15_OpenCondition1, OSMA15_OpenCondition2, OSMA15_CloseCondition, OSMA15_MaxSpread);
  InitStrategy(OSMA30, "OSMA M30", OSMA30_Active, OSMA, PERIOD_M30, OSMA30_OpenMethod, OSMA_OpenLevel, OSMA30_OpenCondition1, OSMA30_OpenCondition2, OSMA30_CloseCondition, OSMA30_MaxSpread);
  #else
  InitStrategy(OSMA1,  "OSMA M1",  OSMA1_Active,  OSMA, PERIOD_M1,  OSMA1_OpenMethod,  OSMA_OpenLevel);
  InitStrategy(OSMA5,  "OSMA M5",  OSMA5_Active,  OSMA, PERIOD_M5,  OSMA5_OpenMethod,  OSMA_OpenLevel);
  InitStrategy(OSMA15, "OSMA M15", OSMA15_Active, OSMA, PERIOD_M15, OSMA15_OpenMethod, OSMA_OpenLevel);
  InitStrategy(OSMA30, "OSMA M30", OSMA30_Active, OSMA, PERIOD_M30, OSMA30_OpenMethod, OSMA_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(RSI1,  "RSI M1",  RSI1_Active,  RSI, PERIOD_M1,  RSI1_OpenMethod,  RSI_OpenLevel, RSI1_OpenCondition1,  RSI1_OpenCondition2,  RSI1_CloseCondition,  RSI1_MaxSpread);
  InitStrategy(RSI5,  "RSI M5",  RSI5_Active,  RSI, PERIOD_M5,  RSI5_OpenMethod,  RSI_OpenLevel, RSI5_OpenCondition1,  RSI5_OpenCondition2,  RSI5_CloseCondition,  RSI5_MaxSpread);
  InitStrategy(RSI15, "RSI M15", RSI15_Active, RSI, PERIOD_M15, RSI15_OpenMethod, RSI_OpenLevel, RSI15_OpenCondition1, RSI15_OpenCondition2, RSI15_CloseCondition, RSI15_MaxSpread);
  InitStrategy(RSI30, "RSI M30", RSI30_Active, RSI, PERIOD_M30, RSI30_OpenMethod, RSI_OpenLevel, RSI30_OpenCondition1, RSI30_OpenCondition2, RSI30_CloseCondition, RSI30_MaxSpread);
  #else
  InitStrategy(RSI1,  "RSI M1",  RSI1_Active,  RSI, PERIOD_M1,  RSI1_OpenMethod,  RSI_OpenLevel);
  InitStrategy(RSI5,  "RSI M5",  RSI5_Active,  RSI, PERIOD_M5,  RSI5_OpenMethod,  RSI_OpenLevel);
  InitStrategy(RSI15, "RSI M15", RSI15_Active, RSI, PERIOD_M15, RSI15_OpenMethod, RSI_OpenLevel);
  InitStrategy(RSI30, "RSI M30", RSI30_Active, RSI, PERIOD_M30, RSI30_OpenMethod, RSI_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(RVI1,  "RVI M1",  RVI1_Active,  RVI, PERIOD_M1,  RVI1_OpenMethod,  RVI_OpenLevel, RVI1_OpenCondition1,  RVI1_OpenCondition2,  RVI1_CloseCondition,  RVI1_MaxSpread);
  InitStrategy(RVI5,  "RVI M5",  RVI5_Active,  RVI, PERIOD_M5,  RVI5_OpenMethod,  RVI_OpenLevel, RVI5_OpenCondition1,  RVI5_OpenCondition2,  RVI5_CloseCondition,  RVI5_MaxSpread);
  InitStrategy(RVI15, "RVI M15", RVI15_Active, RVI, PERIOD_M15, RVI15_OpenMethod, RVI_OpenLevel, RVI15_OpenCondition1, RVI15_OpenCondition2, RVI15_CloseCondition, RVI15_MaxSpread);
  InitStrategy(RVI30, "RVI M30", RVI30_Active, RVI, PERIOD_M30, RVI30_OpenMethod, RVI_OpenLevel, RVI30_OpenCondition1, RVI30_OpenCondition2, RVI30_CloseCondition, RVI30_MaxSpread);
  #else
  InitStrategy(RVI1,  "RVI M1",  RVI1_Active,  RVI, PERIOD_M1,  RVI1_OpenMethod,  RVI_OpenLevel);
  InitStrategy(RVI5,  "RVI M5",  RVI5_Active,  RVI, PERIOD_M5,  RVI5_OpenMethod,  RVI_OpenLevel);
  InitStrategy(RVI15, "RVI M15", RVI15_Active, RVI, PERIOD_M15, RVI15_OpenMethod, RVI_OpenLevel);
  InitStrategy(RVI30, "RVI M30", RVI30_Active, RVI, PERIOD_M30, RVI30_OpenMethod, RVI_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(SAR1,  "SAR M1",  SAR1_Active,  SAR, PERIOD_M1,  SAR1_OpenMethod,  SAR_OpenLevel, SAR1_OpenCondition1,  SAR1_OpenCondition2,  SAR1_CloseCondition,  SAR1_MaxSpread);
  InitStrategy(SAR5,  "SAR M5",  SAR5_Active,  SAR, PERIOD_M5,  SAR5_OpenMethod,  SAR_OpenLevel, SAR5_OpenCondition1,  SAR5_OpenCondition2,  SAR5_CloseCondition,  SAR5_MaxSpread);
  InitStrategy(SAR15, "SAR M15", SAR15_Active, SAR, PERIOD_M15, SAR15_OpenMethod, SAR_OpenLevel, SAR15_OpenCondition1, SAR15_OpenCondition2, SAR15_CloseCondition, SAR15_MaxSpread);
  InitStrategy(SAR30, "SAR M30", SAR30_Active, SAR, PERIOD_M30, SAR30_OpenMethod, SAR_OpenLevel, SAR30_OpenCondition1, SAR30_OpenCondition2, SAR30_CloseCondition, SAR30_MaxSpread);
  #else
  InitStrategy(SAR1,  "SAR M1",  SAR1_Active,  SAR, PERIOD_M1,  SAR1_OpenMethod,  SAR_OpenLevel);
  InitStrategy(SAR5,  "SAR M5",  SAR5_Active,  SAR, PERIOD_M5,  SAR5_OpenMethod,  SAR_OpenLevel);
  InitStrategy(SAR15, "SAR M15", SAR15_Active, SAR, PERIOD_M15, SAR15_OpenMethod, SAR_OpenLevel);
  InitStrategy(SAR30, "SAR M30", SAR30_Active, SAR, PERIOD_M30, SAR30_OpenMethod, SAR_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(STDDEV1,  "StdDev M1",  StdDev1_Active,  STDDEV, PERIOD_M1,  StdDev1_OpenMethod,  StdDev_OpenLevel,  StdDev1_OpenCondition1,  StdDev1_OpenCondition2,  StdDev1_CloseCondition,  StdDev1_MaxSpread);
  InitStrategy(STDDEV5,  "StdDev M5",  StdDev5_Active,  STDDEV, PERIOD_M5,  StdDev5_OpenMethod,  StdDev_OpenLevel,  StdDev5_OpenCondition1,  StdDev5_OpenCondition2,  StdDev5_CloseCondition,  StdDev5_MaxSpread);
  InitStrategy(STDDEV15, "StdDev M15", StdDev15_Active, STDDEV, PERIOD_M15, StdDev15_OpenMethod, StdDev_OpenLevel, StdDev15_OpenCondition1, StdDev15_OpenCondition2, StdDev15_CloseCondition, StdDev15_MaxSpread);
  InitStrategy(STDDEV30, "StdDev M30", StdDev30_Active, STDDEV, PERIOD_M30, StdDev30_OpenMethod, StdDev_OpenLevel, StdDev30_OpenCondition1, StdDev30_OpenCondition2, StdDev30_CloseCondition, StdDev30_MaxSpread);
  #else
  InitStrategy(STDDEV1,  "StdDev M1",  StdDev1_Active,  STDDEV, PERIOD_M1,  StdDev1_OpenMethod,  StdDev_OpenLevel);
  InitStrategy(STDDEV5,  "StdDev M5",  StdDev5_Active,  STDDEV, PERIOD_M5,  StdDev5_OpenMethod,  StdDev_OpenLevel);
  InitStrategy(STDDEV15, "StdDev M15", StdDev15_Active, STDDEV, PERIOD_M15, StdDev15_OpenMethod, StdDev_OpenLevel);
  InitStrategy(STDDEV30, "StdDev M30", StdDev30_Active, STDDEV, PERIOD_M30, StdDev30_OpenMethod, StdDev_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(STOCHASTIC1,  "Stochastic M1",  Stochastic1_Active,  STOCHASTIC, PERIOD_M1,  Stochastic1_OpenMethod,  Stochastic_OpenLevel,  Stochastic1_OpenCondition1,  Stochastic1_OpenCondition2,  Stochastic1_CloseCondition,  Stochastic1_MaxSpread);
  InitStrategy(STOCHASTIC5,  "Stochastic M5",  Stochastic5_Active,  STOCHASTIC, PERIOD_M5,  Stochastic5_OpenMethod,  Stochastic_OpenLevel,  Stochastic5_OpenCondition1,  Stochastic5_OpenCondition2,  Stochastic5_CloseCondition,  Stochastic5_MaxSpread);
  InitStrategy(STOCHASTIC15, "Stochastic M15", Stochastic15_Active, STOCHASTIC, PERIOD_M15, Stochastic15_OpenMethod, Stochastic_OpenLevel, Stochastic15_OpenCondition1, Stochastic15_OpenCondition2, Stochastic15_CloseCondition, Stochastic15_MaxSpread);
  InitStrategy(STOCHASTIC30, "Stochastic M30", Stochastic30_Active, STOCHASTIC, PERIOD_M30, Stochastic30_OpenMethod, Stochastic_OpenLevel, Stochastic30_OpenCondition1, Stochastic30_OpenCondition2, Stochastic30_CloseCondition, Stochastic30_MaxSpread);
  #else
  InitStrategy(STOCHASTIC1,  "Stochastic M1",  Stochastic1_Active,  STOCHASTIC, PERIOD_M1,  Stochastic1_OpenMethod,  Stochastic_OpenLevel);
  InitStrategy(STOCHASTIC5,  "Stochastic M5",  Stochastic5_Active,  STOCHASTIC, PERIOD_M5,  Stochastic5_OpenMethod,  Stochastic_OpenLevel);
  InitStrategy(STOCHASTIC15, "Stochastic M15", Stochastic15_Active, STOCHASTIC, PERIOD_M15, Stochastic15_OpenMethod, Stochastic_OpenLevel);
  InitStrategy(STOCHASTIC30, "Stochastic M30", Stochastic30_Active, STOCHASTIC, PERIOD_M30, Stochastic30_OpenMethod, Stochastic_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(WPR1,  "WPR M1",  WPR1_Active,  WPR, PERIOD_M1,  WPR1_OpenMethod,  WPR_OpenLevel, WPR1_OpenCondition1,  WPR1_OpenCondition2,  WPR1_CloseCondition,  WPR1_MaxSpread);
  InitStrategy(WPR5,  "WPR M5",  WPR5_Active,  WPR, PERIOD_M5,  WPR5_OpenMethod,  WPR_OpenLevel, WPR5_OpenCondition1,  WPR5_OpenCondition2,  WPR5_CloseCondition,  WPR5_MaxSpread);
  InitStrategy(WPR15, "WPR M15", WPR15_Active, WPR, PERIOD_M15, WPR15_OpenMethod, WPR_OpenLevel, WPR15_OpenCondition1, WPR15_OpenCondition2, WPR15_CloseCondition, WPR15_MaxSpread);
  InitStrategy(WPR30, "WPR M30", WPR30_Active, WPR, PERIOD_M30, WPR30_OpenMethod, WPR_OpenLevel, WPR30_OpenCondition1, WPR30_OpenCondition2, WPR30_CloseCondition, WPR30_MaxSpread);
  #else
  InitStrategy(WPR1,  "WPR M1",  WPR1_Active,  WPR, PERIOD_M1,  WPR1_OpenMethod,  WPR_OpenLevel);
  InitStrategy(WPR5,  "WPR M5",  WPR5_Active,  WPR, PERIOD_M5,  WPR5_OpenMethod,  WPR_OpenLevel);
  InitStrategy(WPR15, "WPR M15", WPR15_Active, WPR, PERIOD_M15, WPR15_OpenMethod, WPR_OpenLevel);
  InitStrategy(WPR30, "WPR M30", WPR30_Active, WPR, PERIOD_M30, WPR30_OpenMethod, WPR_OpenLevel);
  #endif

  #ifdef __advanced__
  InitStrategy(ZIGZAG1,  "ZigZag M1",  ZigZag1_Active,  ZIGZAG, PERIOD_M1,  ZigZag1_OpenMethod,  ZigZag_OpenLevel, ZigZag1_OpenCondition1,  ZigZag1_OpenCondition2,  ZigZag1_CloseCondition,  ZigZag1_MaxSpread);
  InitStrategy(ZIGZAG5,  "ZigZag M5",  ZigZag5_Active,  ZIGZAG, PERIOD_M5,  ZigZag5_OpenMethod,  ZigZag_OpenLevel, ZigZag5_OpenCondition1,  ZigZag5_OpenCondition2,  ZigZag5_CloseCondition,  ZigZag5_MaxSpread);
  InitStrategy(ZIGZAG15, "ZigZag M15", ZigZag15_Active, ZIGZAG, PERIOD_M15, ZigZag15_OpenMethod, ZigZag_OpenLevel, ZigZag15_OpenCondition1, ZigZag15_OpenCondition2, ZigZag15_CloseCondition, ZigZag15_MaxSpread);
  InitStrategy(ZIGZAG30, "ZigZag M30", ZigZag30_Active, ZIGZAG, PERIOD_M30, ZigZag30_OpenMethod, ZigZag_OpenLevel, ZigZag30_OpenCondition1, ZigZag30_OpenCondition2, ZigZag30_CloseCondition, ZigZag30_MaxSpread);
  #else
  InitStrategy(ZIGZAG1,  "ZigZag M1",  ZigZag1_Active,  ZIGZAG, PERIOD_M1,  ZigZag1_OpenMethod,  ZigZag_OpenLevel);
  InitStrategy(ZIGZAG5,  "ZigZag M5",  ZigZag5_Active,  ZIGZAG, PERIOD_M5,  ZigZag5_OpenMethod,  ZigZag_OpenLevel);
  InitStrategy(ZIGZAG15, "ZigZag M15", ZigZag15_Active, ZIGZAG, PERIOD_M15, ZigZag15_OpenMethod, ZigZag_OpenLevel);
  InitStrategy(ZIGZAG30, "ZigZag M30", ZigZag30_Active, ZIGZAG, PERIOD_M30, ZigZag30_OpenMethod, ZigZag_OpenLevel);
  #endif

  ArrSetValueD(conf, FACTOR, 1.0);
  ArrSetValueD(conf, LOT_SIZE, lot_size);

  return (TRUE);
}

/*
 * Initialize specific strategy.
 */
bool InitStrategy(int key, string name, bool active, int indicator, int timeframe, int open_method = 0, double open_level = 0.0, int open_cond1 = 0, int open_cond2 = 0, int close_cond = 0, double max_spread = 0.0) {
  sname[key]                 = name;
  info[key][ACTIVE]          = active;
  info[key][TIMEFRAME]       = timeframe;
  info[key][INDICATOR]       = indicator;
  info[key][OPEN_METHOD]     = open_method;
  conf[key][OPEN_LEVEL]      = open_level;
  #ifdef __advanced__
  info[key][OPEN_CONDITION1] = open_cond1;
  info[key][OPEN_CONDITION2] = open_cond2;
  info[key][CLOSE_CONDITION] = close_cond;
  conf[key][SPREAD_LIMIT]    = max_spread;
  #endif
  return (TRUE);
}

/*
 * Update global variables.
 */
void UpdateVariables() {
  time_current = TimeCurrent();
  last_close_profit = EMPTY;
  total_orders = GetTotalOrders();
  curr_spread = ValueToPips(GetMarketSpread());
}

/* END: VARIABLE FUNCTIONS */

/* BEGIN: CONDITION FUNCTIONS */

#ifdef __advanced__
/*
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

  #ifdef __advanced__
  if (Account_Condition_To_Disable > 0 && Account_Condition_To_Disable < ArraySize(acc_conditions)) {
    acc_conditions[Account_Condition_To_Disable - 1][0] = C_ACC_NONE;
    acc_conditions[Account_Condition_To_Disable - 1][1] = C_MARKET_NONE;
    acc_conditions[Account_Condition_To_Disable - 1][2] = A_NONE;
  }
  #endif
  return TRUE;
}

/*
 * Check account condition.
 */
bool AccCondition(int condition = C_ACC_NONE) {
  switch(condition) {
    case C_ACC_TRUE:
      last_cname = "True";
      return TRUE;
    case C_EQUITY_LOWER:
      last_cname = "Equ<Bal";
      return AccountEquity() < AccountBalance();
    case C_EQUITY_HIGHER:
      last_cname = "Equ>Bal";
      return AccountEquity() > AccountBalance();
    case C_EQUITY_50PC_HIGH: // Equity 50% high
      last_cname = "Equ>50%";
      return AccountEquity() > AccountBalance() * 2;
    case C_EQUITY_20PC_HIGH: // Equity 20% high
      last_cname = "Equ>20%";
      return AccountEquity() > AccountBalance()/100 * 120;
    case C_EQUITY_10PC_HIGH: // Equity 10% high
      last_cname = "Equ>10%";
      return AccountEquity() > AccountBalance()/100 * 110;
    case C_EQUITY_10PC_LOW:  // Equity 10% low
      last_cname = "Equ<10%";
      return AccountEquity() < AccountBalance()/100 * 90;
    case C_EQUITY_20PC_LOW:  // Equity 20% low
      last_cname = "Equ<20%";
      return AccountEquity() < AccountBalance()/100 * 80;
    case C_EQUITY_50PC_LOW:  // Equity 50% low
      last_cname = "Equ<50%";
      return AccountEquity() <= AccountBalance() / 2;
    case C_MARGIN_USED_50PC: // 50% Margin Used
      last_cname = "Margin>50%";
      return AccountMargin() >= AccountEquity() /100 * 50;
    case C_MARGIN_USED_70PC: // 70% Margin Used
      // Note that in some accounts, Stop Out will occur in your account when equity reaches 70% of your used margin resulting in immediate closing of all positions.
      last_cname = "Margin>70%";
      return AccountMargin() >= AccountEquity() /100 * 70;
    case C_MARGIN_USED_80PC: // 80% Margin Used
      last_cname = "Margin>80%";
      return AccountMargin() >= AccountEquity() /100 * 80;
    case C_MARGIN_USED_90PC: // 90% Margin Used
      last_cname = "Margin>90%";
      return AccountMargin() >= AccountEquity() /100 * 90;
    case C_NO_FREE_MARGIN:
      last_cname = "NoMargin%";
      return AccountFreeMargin() <= 10;
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
      return GetArrSumKey1(hourly_profit, day_of_year, 10) > 0;
    case C_ACC_CDAY_IN_LOSS: // Check if current day in loss.
      last_cname = "TodayInLoss";
      return GetArrSumKey1(hourly_profit, day_of_year, 10) < 0;
    case C_ACC_PDAY_IN_PROFIT: // Check if previous day in profit.
      last_cname = "YesterdayInProfit";
      int yesterday1 = TimeDayOfYear(time_current - 24*60*60);
      return GetArrSumKey1(hourly_profit, yesterday1) > 0;
    case C_ACC_PDAY_IN_LOSS: // Check if previous day in loss.
      last_cname = "YesterdayInLoss";
      int yesterday2 = TimeDayOfYear(time_current - 24*60*60);
      return GetArrSumKey1(hourly_profit, yesterday2) < 0;
    case C_ACC_MAX_ORDERS:
      return total_orders >= max_orders;
    default:
    case C_ACC_NONE:
      last_cname = "None";
      return FALSE;
  }
  return FALSE;
}

/*
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
    case C_MARKET_NONE:
    default:
      return FALSE;
  }
  return FALSE;
}

// Check our account if certain conditions are met.
void CheckAccConditions() {
  // if (VerboseTrace) Print("Calling " + __FUNCTION__ + "()");
  if (!Account_Conditions_Active) return;
  if (bar_time == last_action_time) return; // If action was already executed in the same bar, do not check again.

  for (int i = 0; i < ArrayRange(acc_conditions, 0); i++) {
    if (AccCondition(acc_conditions[i][0]) && MarketCondition(acc_conditions[i][1]) && acc_conditions[i][2] != A_NONE) {
      ActionExecute(acc_conditions[i][2], i);
    }
  } // end: for
}

#endif

/*
 * Get default multiplier lot factor.
 */
double GetDefaultLotFactor() {
  return 1.0;
}

/* BEGIN: STRATEGY FUNCTIONS */

/*
 * Calculate lot size for specific strategy.
 */
double GetStrategyLotSize(int sid, int cmd) {
  double trade_lot = If(conf[sid][LOT_SIZE], conf[sid][LOT_SIZE], lot_size) * If(conf[sid][FACTOR], conf[sid][FACTOR], 1.0);
  #ifdef __advanced__
  if (Boosting_Enabled) {
    double pf = GetStrategyProfitFactor(sid);
    if (BoostByProfitFactor && pf > 1.0) trade_lot *= MathMax(GetStrategyProfitFactor(sid), 1.0);
    else if (HandicapByProfitFactor && pf < 1.0) trade_lot *= MathMin(GetStrategyProfitFactor(sid), 1.0);
  }
  #endif
  if (Boosting_Enabled && CheckTrend() == cmd && BoostTrendFactor != 1.0) {
    trade_lot *= BoostTrendFactor;
  }
  return NormalizeLots(trade_lot);
}

/*
 * Get strategy comment for opened order.
 */
string GetStrategyComment(int sid, string sep = "|") {
  string comment = sname[sid];
  comment =+ StringFormat("%s spread: %.1f", sep, curr_spread);
  return comment;
}

/*
 * Get strategy report based on the total orders.
 */
string GetStrategyReport(string sep = "\n") {
  string output = "Strategy stats: " + sep;
  double pc_loss = 0, pc_won = 0;
  for (int id = 0; id < FINAL_STRATEGY_TYPE_ENTRY; id++) {
    if (info[id][TOTAL_ORDERS] > 0) {
      output += StringFormat("Profit factor: %.2f, ",
                GetStrategyProfitFactor(id));
      output += StringFormat("Total net profit: %.2fpips (%+.2f/%-.2f), ",
        stats[id][TOTAL_NET_PROFIT], stats[id][TOTAL_GROSS_PROFIT], stats[id][TOTAL_GROSS_LOSS]);
      pc_loss = (100 / NormalizeDouble(info[id][TOTAL_ORDERS], 2)) * info[id][TOTAL_ORDERS_LOSS];
      pc_won  = (100 / NormalizeDouble(info[id][TOTAL_ORDERS], 2)) * info[id][TOTAL_ORDERS_WON];
      output += StringFormat("Total orders: %d (Won: %.1f%% [%d] / Loss: %.1f%% [%d])",
                info[id][TOTAL_ORDERS], pc_won, info[id][TOTAL_ORDERS_WON], pc_loss, info[id][TOTAL_ORDERS_LOSS]);
      if (info[id][TOTAL_ERRORS] > 0) output += StringFormat(", Errors: %d", info[id][TOTAL_ERRORS]);
      output += StringFormat(" - %s", sname[id]);
      // output += "Total orders: " + info[id][TOTAL_ORDERS] + " (Won: " + DoubleToStr(pc_won, 1) + "% [" + info[id][TOTAL_ORDERS_WON] + "] | Loss: " + DoubleToStr(pc_loss, 1) + "% [" + info[id][TOTAL_ORDERS_LOSS] + "]); ";
      output += sep;
    }
  }
  return output;
}

/*
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

/*
 * Update strategy lot size.
 */
void UpdateStrategyLotSize() {
  for (int i; i < ArrayRange(conf, 0); i++) {
    conf[i][LOT_SIZE] = lot_size * conf[i][FACTOR];
  }
}

/*
 * Calculate strategy profit factor.
 */
double GetStrategyProfitFactor(int id) {
  if (info[id][TOTAL_ORDERS] > 10 && stats[id][TOTAL_GROSS_LOSS] < 0) {
    return (double)(stats[id][TOTAL_GROSS_PROFIT] / -stats[id][TOTAL_GROSS_LOSS]);
  } else {
    return 1.0;
  }
}

/*
 * Fetch strategy open level based on the indicator and timeframe.
 */
double GetStrategyOpenLevel(int indicator, int timeframe = PERIOD_M30, double default_value = 0.0) {
  int sid = GetStrategyViaIndicator(indicator, timeframe);
  // Message(StringFormat("%s(): indi = %d, timeframe = %d, sid = %d, open_level = %f", __FUNCTION__, indicator, timeframe, sid, conf[sid][OPEN_LEVEL]));
  return If(sid != EMPTY, conf[sid][OPEN_LEVEL], default_value);
}

/*
 * Fetch strategy open level based on the indicator and timeframe.
 */
int GetStrategyOpenMethod(int indicator, int timeframe = PERIOD_M30, int default_value = 0) {
  int sid = GetStrategyViaIndicator(indicator, timeframe);
  return If(sid != EMPTY, info[sid][OPEN_METHOD], default_value);
}

/*
 * Fetch strategy timeframe based on the strategy type.
 */
int GetStrategyTimeframe(int sid, int default_value = PERIOD_M1) {
  return If(sid >= 0, info[sid][TIMEFRAME], default_value);
}

/*
 * Get strategy id based on the indicator and timeframe.
 */
int GetStrategyViaIndicator(int indicator, int timeframe) {
  for (int sid = 0; sid < ArrayRange(info, 0); sid++) {
    if (info[sid][INDICATOR] == indicator && info[sid][TIMEFRAME] == timeframe) {
      return sid;
    }
  }
  return EMPTY;
}

/*
 * Convert period to proper chart timeframe value.
 */
int PeriodToTf(int period) {
  int tf = PERIOD_M30;
  switch (period) {
    case M1: // 1 minute
      tf = PERIOD_M1;
      break;
    case M5: // 5 minutes
      tf = PERIOD_M5;
      break;
    case M15: // 15 minutes
      tf = PERIOD_M15;
      break;
    case M30: // 30 minutes
      tf = PERIOD_M30;
      break;
    case H1: // 1 hour
      tf = PERIOD_H1;
      break;
    case H4: // 4 hours
      tf = PERIOD_H4;
      break;
    case D1: // daily
      tf = PERIOD_D1;
      break;
    case W1: // weekly
      tf = PERIOD_W1;
      break;
    case MN1: // monthly
      tf = PERIOD_MN1;
      break;
  }
  return tf;
}

/*
 * Convert timeframe constant to period value.
 */
int TfToPeriod(int tf) {
  int period = M30;
  switch (tf) {
    case PERIOD_M1: // 1 minute
      period = M1;
      break;
    case PERIOD_M5: // 5 minutes
      period = M5;
      break;
    case PERIOD_M15: // 15 minutes
      period = M15;
      break;
    case PERIOD_M30: // 30 minutes
      period = M30;
      break;
    case PERIOD_H1: // 1 hour
      period = H1;
      break;
    case PERIOD_H4: // 4 hours
      period = H4;
      break;
    case PERIOD_D1: // daily
      period = D1;
      break;
    case PERIOD_W1: // weekly
      period = W1;
      break;
    case PERIOD_MN1: // monthly
      period = MN1;
      break;
  }
  return period;
}

/*
 * Calculate total strategy profit.
 */
double GetTotalProfit() {
  double total_profit = 0;
  for (int id; id < ArrayRange(stats, 0); id++) {
    total_profit += stats[id][TOTAL_NET_PROFIT];
  }
  return total_profit;
}

/*
 * Apply strategy multiplier factor based on the strategy profit or loss.
 */
void ApplyStrategyMultiplierFactor(int period = DAILY, int loss_or_profit = 0, double factor = 1.0) {
  if (GetNoOfStrategies() <= 1 || factor == 1.0) return;
  int key = If(period == MONTHLY, MONTHLY_PROFIT, If(period == WEEKLY, WEEKLY_PROFIT, DAILY_PROFIT));
  string period_name = IfTxt(period == MONTHLY, "montly", IfTxt(period == WEEKLY, "weekly", "daily"));
  int new_strategy = If(loss_or_profit > 0, GetArrKey1ByHighestKey2ValueD(stats, key), GetArrKey1ByLowestKey2ValueD(stats, key));
  if (new_strategy == EMPTY) return;
  int previous = If(loss_or_profit > 0, best_strategy[period], worse_strategy[period]);
  double new_factor = 1.0;
  if (loss_or_profit > 0) { // Best strategy.
    if (info[new_strategy][ACTIVE] && stats[new_strategy][key] > 10 && new_strategy != previous) { // Check if it's different than the previous one.
      if (previous != EMPTY) {
        if (!info[previous][ACTIVE]) info[previous][ACTIVE] = TRUE;
        conf[previous][FACTOR] = GetDefaultLotFactor(); // Set previous strategy multiplier factor to default.
        if (VerboseDebug) Print(__FUNCTION__ + "(): Setting multiplier factor to default for strategy: " + previous);
      }
      best_strategy[period] = new_strategy; // Assign the new worse strategy.
      info[new_strategy][ACTIVE] = TRUE;
      new_factor = GetDefaultLotFactor() * factor;
      conf[new_strategy][FACTOR] = new_factor; // Apply multiplier factor for the new strategy.
      if (VerboseDebug) Print(__FUNCTION__ + "(): Setting multiplier factor to " + new_factor + " for strategy: " + new_strategy + " (period: " + period_name + ")");
    }
  } else { // Worse strategy.
    if (info[new_strategy][ACTIVE] && stats[new_strategy][key] < 10 && new_strategy != previous) { // Check if it's different than the previous one.
      if (previous != EMPTY) {
        if (!info[previous][ACTIVE]) info[previous][ACTIVE] = TRUE;
        conf[previous][FACTOR] = GetDefaultLotFactor(); // Set previous strategy multiplier factor to default.
        if (VerboseDebug) Print(__FUNCTION__ + "(): Setting multiplier factor to default for strategy: " + previous + " to default.");
      }
      worse_strategy[period] = new_strategy; // Assign the new worse strategy.
      if (factor > 0) {
        new_factor = NormalizeDouble(GetDefaultLotFactor() / factor, Digits);
        info[new_strategy][ACTIVE] = TRUE;
        conf[new_strategy][FACTOR] = new_factor; // Apply multiplier factor for the new strategy.
        if (VerboseDebug) Print(__FUNCTION__ + "(): Setting multiplier factor to " + new_factor + " for strategy: " + new_strategy + " (period: " + period_name + ")");
      } else {
        info[new_strategy][ACTIVE] = FALSE;
        //conf[new_strategy][FACTOR] = GetDefaultLotFactor();
        if (VerboseDebug) Print(__FUNCTION__ + "(): Disabling strategy: " + new_strategy);
      }
    }
  }
}

#ifdef __advanced__
/*
 * Check if RSI period needs any change.
 *
 * FIXME: Doesn't improve much.
 */
void RSI_CheckPeriod() {

  int period;
  // 1 minute period.
  period = M1;
  if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < RSI1_IncreasePeriod_MinDiff) {
    info[RSI1][CUSTOM_PERIOD] = MathMin(info[RSI1][CUSTOM_PERIOD] + 1, RSI_Period * 2);
    if (VerboseDebug) PrintFormat("Increased " + sname[RSI1] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  } else if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] > RSI1_DecreasePeriod_MaxDiff) {
    info[RSI1][CUSTOM_PERIOD] = MathMax(info[RSI1][CUSTOM_PERIOD] - 1, RSI_Period / 2);
    if (VerboseDebug) PrintFormat("Decreased " + sname[RSI1] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  }
  // 5 minute period.
  period = M5;
  if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < RSI5_IncreasePeriod_MinDiff) {
    info[RSI5][CUSTOM_PERIOD] = MathMin(info[RSI5][CUSTOM_PERIOD] + 1, RSI_Period * 2);
    if (VerboseDebug) PrintFormat("Increased " + sname[RSI5] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  } else if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] > RSI5_DecreasePeriod_MaxDiff) {
    info[RSI5][CUSTOM_PERIOD] = MathMax(info[RSI5][CUSTOM_PERIOD] - 1, RSI_Period / 2);
    if (VerboseDebug) PrintFormat("Decreased " + sname[RSI5] + " period to %d", info[RSI1][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  }
  // 15 minute period.

  period = M15;
  if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < RSI15_IncreasePeriod_MinDiff) {
    info[RSI15][CUSTOM_PERIOD] = MathMin(info[RSI15][CUSTOM_PERIOD] + 1, RSI_Period * 2);
    if (VerboseDebug) PrintFormat("Increased " + sname[RSI15] + " period to %d", info[RSI15][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  } else if (rsi_stats[period][UPPER] - rsi_stats[period][LOWER] > RSI15_DecreasePeriod_MaxDiff) {
    info[RSI15][CUSTOM_PERIOD] = MathMax(info[RSI15][CUSTOM_PERIOD] - 1, RSI_Period / 2);
    if (VerboseDebug) PrintFormat("Decreased " + sname[RSI15] + " period to %d", info[RSI15][CUSTOM_PERIOD]);
    // Reset stats.
    rsi_stats[period][UPPER] = 0;
    rsi_stats[period][LOWER] = 0;
  }
  /*
  Print(__FUNCTION__ + "(): M1: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  period = M5;
  Print(__FUNCTION__ + "(): M5: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  period = M15;
  Print(__FUNCTION__ + "(): M15: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  period = M30;
  Print(__FUNCTION__ + "(): M30: Avg: " + rsi_stats[period][0] + ", Min: " + rsi_stats[period][LOWER] + ", Max: " + rsi_stats[period][UPPER] + ", Diff: " + ( rsi_stats[period][UPPER] - rsi_stats[period][LOWER] ));
  */
}

// FIXME: Doesn't improve anything.
bool RSI_IncreasePeriod(int tf = PERIOD_M1, int condition = 0) {
  bool result = condition > 0;
  UpdateIndicator(RSI, tf);
  int period = TfToPeriod(tf);
  if ((condition &   1) != 0) result = result && (rsi_stats[period][UPPER] > 50 + RSI_OpenLevel + RSI_OpenLevel / 2 && rsi_stats[period][LOWER] < 50 - RSI_OpenLevel - RSI_OpenLevel / 2);
  if ((condition &   2) != 0) result = result && (rsi_stats[period][UPPER] > 50 + RSI_OpenLevel + RSI_OpenLevel / 2 || rsi_stats[period][LOWER] < 50 - RSI_OpenLevel - RSI_OpenLevel / 2);
  if ((condition &   4) != 0) result = result && (rsi_stats[period][0] < 50 + RSI_OpenLevel + RSI_OpenLevel / 3 && rsi_stats[period][0] > 50 - RSI_OpenLevel - RSI_OpenLevel / 3);
  // if ((condition &   4) != 0) result = result || rsi_stats[period][0] < 50 + RSI_OpenLevel;
  if ((condition &   8) != 0) result = result && rsi_stats[period][UPPER] - rsi_stats[period][LOWER] < 50;
  // if ((condition &  16) != 0) result = result && rsi[period][CURR] - rsi[period][PREV] > rsi[period][PREV] - rsi[period][FAR];
  // if ((condition &  32) != 0) result = result && Open[CURR] > Close[PREV];
  return result;
}

// FIXME: Doesn't improve anything.
bool RSI_DecreasePeriod(int tf = PERIOD_M1, int condition = 0) {
  bool result = condition > 0;
  UpdateIndicator(RSI, tf);
  int period = TfToPeriod(tf);
  if ((condition &   1) != 0) result = result && (rsi_stats[period][UPPER] <= 50 + RSI_OpenLevel && rsi_stats[period][LOWER] >= 50 - RSI_OpenLevel);
  if ((condition &   2) != 0) result = result && (rsi_stats[period][UPPER] <= 50 + RSI_OpenLevel || rsi_stats[period][LOWER] >= 50 - RSI_OpenLevel);
  // if ((condition &   4) != 0) result = result && (rsi_stats[period][0] > 50 + RSI_OpenLevel / 3 || rsi_stats[period][0] < 50 - RSI_OpenLevel / 3);
  // if ((condition &   4) != 0) result = result && rsi_stats[period][UPPER] > 50 + (RSI_OpenLevel / 3);
  // if ((condition &   8) != 0) result = result && && rsi_stats[period][UPPER] < 50 - (RSI_OpenLevel / 3);
  // if ((condition &  16) != 0) result = result && rsi[period][CURR] - rsi[period][PREV] > rsi[period][PREV] - rsi[period][FAR];
  // if ((condition &  32) != 0) result = result && Open[CURR] > Close[PREV];
  return result;
}
#endif

/*
 * Return strategy id by order magic number.
 */
int GetIdByMagic(int magic = EMPTY) {
  if (magic == EMPTY) magic = OrderMagicNumber();
  int id = magic - MagicNumber;
  return If(CheckOurMagicNumber(magic), id, EMPTY);
}

/* END: STRATEGY FUNCTIONS */

/* BEGIN: SUPPORT/RESISTANCE CALCULATION */

/*
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

/*
 * Get text output of hourly profit report.
 */
string GetHourlyReport(string sep = ", ") {
  string output = StringFormat("Hourly profit (total: %.1fp): ", GetArrSumKey1(hourly_profit, day_of_year));
  for (int h = 0; h < hour_of_day; h++) {
    output += StringFormat("%d: %.1fp%s", h, hourly_profit[day_of_year][h], IfTxt(h < hour_of_day, sep, ""));
  }
  return output;
}

/*
 * Get text output of daily report.
 */
string GetDailyReport() {
  string output = "Daily max: ";
  int key;
  // output += "Low: "     + daily[MAX_LOW] + "; ";
  // output += "High: "    + daily[MAX_HIGH] + "; ";
  output += StringFormat("Tick: %.0f; ", daily[MAX_TICK]);
  // output += "Drop: "    + daily[MAX_DROP] + "; ";
  output += StringFormat("Spread: %.1f; ", daily[MAX_SPREAD]);
  output += StringFormat("Max orders: %.0f; ", daily[MAX_ORDERS]);
  output += StringFormat("Loss: %.2f; ", daily[MAX_LOSS]);
  output += StringFormat("Profit: %.2f; ", daily[MAX_PROFIT]);
  output += StringFormat("Equity: %.2f; ", daily[MAX_EQUITY]);
  output += StringFormat("Balance: %.2f; ", daily[MAX_BALANCE]);

  //output += GetAccountTextDetails() + "; " + GetOrdersStats();

  key = GetArrKey1ByHighestKey2ValueD(stats, DAILY_PROFIT);
  if (key >= 0) output += "Best: " + sname[key] + " (" + stats[key][DAILY_PROFIT] + "p); ";
  key = GetArrKey1ByLowestKey2ValueD(stats, DAILY_PROFIT);
  if (key >= 0) output += "Worse: " + sname[key] + " (" + stats[key][DAILY_PROFIT] + "p); ";

  return output;
}

/*
 * Get text output of weekly report.
 */
string GetWeeklyReport() {
  string output = "Weekly max: ";
  int key;
  // output =+ GetAccountTextDetails() + "; " + GetOrdersStats();
  // output += "Low: "     + weekly[MAX_LOW] + "; ";
  // output += "High: "    + weekly[MAX_HIGH] + "; ";
  output += "Tick: "       + weekly[MAX_TICK] + "; ";
  // output += "Drop: "    + weekly[MAX_DROP] + "; ";
  output += "Spread: "     + weekly[MAX_SPREAD] + "; ";
  output += "Max orders: " + weekly[MAX_ORDERS] + "; ";
  output += "Loss: "       + weekly[MAX_LOSS] + "; ";
  output += "Profit: "     + weekly[MAX_PROFIT] + "; ";
  output += "Equity: "     + weekly[MAX_EQUITY] + "; ";
  output += "Balance: "    + weekly[MAX_BALANCE] + "; ";

  key = GetArrKey1ByHighestKey2ValueD(stats, WEEKLY_PROFIT);
  if (key >= 0) output += "Best: " + sname[key] + " (" + stats[key][WEEKLY_PROFIT] + "p); ";
  key = GetArrKey1ByLowestKey2ValueD(stats, WEEKLY_PROFIT);
  if (key >= 0) output += "Worse: " + sname[key] + " (" + stats[key][WEEKLY_PROFIT] + "p); ";

  return output;
}

/*
 * Get text output of monthly report.
 */
string GetMonthlyReport() {
  string output = "Monthly max: ";
  int key;
  // output =+ GetAccountTextDetails() + "; " + GetOrdersStats();
  // output += "Low: "     + monthly[MAX_LOW] + "; ";
  // output += "High: "    + monthly[MAX_HIGH] + "; ";
  output += "Tick: "       + monthly[MAX_TICK] + "; ";
  // output += "Drop: "    + monthly[MAX_DROP] + "; ";
  output += "Spread: "     + monthly[MAX_SPREAD] + "; ";
  output += "Max orders: " + monthly[MAX_ORDERS] + "; ";
  output += "Loss: "       + monthly[MAX_LOSS] + "; ";
  output += "Profit: "     + monthly[MAX_PROFIT] + "; ";
  output += "Equity: "     + monthly[MAX_EQUITY] + "; ";
  output += "Balance: "    + monthly[MAX_BALANCE] + "; ";

  key = GetArrKey1ByHighestKey2ValueD(stats, MONTHLY_PROFIT);
  if (key >= 0) output += "Best: " + sname[key] + " (" + stats[key][MONTHLY_PROFIT] + "p); ";
  key = GetArrKey1ByLowestKey2ValueD(stats, MONTHLY_PROFIT);
  if (key >= 0) output += "Worse: " + sname[key] + " (" + stats[key][MONTHLY_PROFIT] + "p); ";

  return output;
}

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
  string text_spread = StringFormat("Spread: %.1f pips", ValueToPips(GetMarketSpread()));
  // string text_spread = "Spread (pips): " + DoubleToStr(GetMarketSpread(TRUE) / pts_per_pip, Digits - PipDigits) + " / Stop level (pips): " + DoubleToStr(market_stoplevel / pts_per_pip, Digits - PipDigits);
  // Check trend.
  string trend = "Neutral.";
  if (CheckTrend() == OP_BUY) trend = "Bullish";
  if (CheckTrend() == OP_SELL) trend = "Bearish";
  // Print actual info.
  string indent = "";
  indent = "                      "; // if (total_orders > 5)?
  output = indent + "------------------------------------------------" + sep
                  + indent + StringFormat("| %s v%s (Status: %s)%s", ea_name, ea_version, IfTxt(ea_active, "ACTIVE", "NOT ACTIVE"), sep)
                  + indent + StringFormat("| ACCOUNT INFORMATION:%s", sep)
                  + indent + StringFormat("| Server Name: %s, Time: %s%s", AccountInfoString(ACCOUNT_SERVER), TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS), sep)
                  + indent + "| Acc Number: " + IntegerToString(AccountNumber()) + "; Acc Name: " + AccountName() + "; Broker: " + AccountCompany() + " (Type: " + account_type + ")" + sep
                  + indent + StringFormat("| Stop Out Level: %s, Leverage: 1:%d %s", stop_out_level, AccountLeverage(), sep)
                  + indent + "| Used Margin: " + ValueToCurrency(AccountMargin()) + "; Free: " + ValueToCurrency(AccountFreeMargin()) + sep
                  + indent + "| Equity: " + ValueToCurrency(AccountEquity()) + "; Balance: " + ValueToCurrency(AccountBalance()) + sep
                  + indent + "| Lot size: " + DoubleToStr(lot_size, VolumeDigits) + "; " + text_max_orders + sep
                  + indent + "| Risk ratio: " + DoubleToStr(risk_ratio, 1) + " (" + GetRiskRatioText() + ")" + sep
                  + indent + "| " + GetOrdersStats("" + sep + indent + "| ") + "" + sep
                  + indent + "| Last error: " + last_err + "" + sep
                  + indent + "| Last message: " + GetLastMessage() + "" + sep
                  + indent + "| ------------------------------------------------" + sep
                  + indent + "| MARKET INFORMATION:" + sep
                  + indent + "| " + text_spread + "" + sep
                  + indent + "| Trend: " + trend + "" + sep
                  // + indent // + "Mini lot: " + MarketInfo(Symbol(), MODE_MINLOT) + "" + sep
                  + indent + "| ------------------------------------------------" + sep
                  + indent + "| STATISTICS:" + sep
                  + indent + "| " + GetHourlyReport() + "" + sep
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

void SendEmailExecuteOrder(string sep = "<br>\n") {
  string mail_title = "Trading Info - " + ea_name;
  string body = "Trade Information" + sep;
  body += sep + StringFormat("Event: %s", "Trade Opened");
  body += sep + StringFormat("Currency Pair: %s", _Symbol);
  body += sep + StringFormat("Time: %s", TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS));
  body += sep + StringFormat("Order Type: %s", _OrderType_str(OrderType()));
  body += sep + StringFormat("Price: %s", DoubleToStr(OrderOpenPrice(), Digits));
  body += sep + StringFormat("Lot size: %s", DoubleToStr(OrderLots(), VolumeDigits));
  body += sep + StringFormat("Current Balance: %s", ValueToCurrency(AccountBalance()));
  body += sep + StringFormat("Current Equity: %s", ValueToCurrency(AccountEquity()));
  SendMail(mail_title, body);
}

string GetOrderTextDetails() {
   return StringConcatenate("Order Details: ",
      "Ticket: ", OrderTicket(), "; ",
      "Time: ", TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS), "; ",
      "Comment: ", OrderComment(), "; ",
      "Commision: ", OrderCommission(), "; ",
      "Symbol: ", StringSubstr(Symbol(), 0, 6), "; ",
      "Type: ", _OrderType_str(OrderType()), "; ",
      "Expiration: ", OrderExpiration(), "; ",
      "Open Price: ", DoubleToStr(OrderOpenPrice(), Digits), "; ",
      "Close Price: ", DoubleToStr(OrderClosePrice(), Digits), "; ",
      "Take Profit: ", OrderProfit(), "; ",
      "Stop Loss: ", OrderStopLoss(), "; ",
      "Swap: ", OrderSwap(), "; ",
      "Lot size: ", OrderLots(), "; "
   );
}

/*
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
        orders_per_type += StringFormat("%s: %.1f%%", sname[i], MathFloor(100 / total_orders * open_orders[i]));
      }
    }
  } else {
    orders_per_type += "No orders open yet.";
  }
  return orders_per_type + sep + total_orders_text;
}

/*
 * Get information about account conditions in text format.
 */
string GetAccountTextDetails(string sep = "; ") {
   return StringConcatenate("Account Details: ",
      "Time: ", TimeToStr(time_current, TIME_DATE|TIME_MINUTES|TIME_SECONDS), sep,
      "Account Balance: ", ValueToCurrency(AccountBalance()), sep,
      "Account Equity: ", ValueToCurrency(AccountEquity()), sep,
      "Used Margin: ", ValueToCurrency(AccountMargin()), sep,
      "Free Margin: ", ValueToCurrency(AccountFreeMargin()), sep,
      "No of Orders: ", total_orders, " (BUY/SELL: ", CalculateOrdersByCmd(OP_BUY), "/", CalculateOrdersByCmd(OP_SELL), ")", sep,
      "Risk Ratio: ", DoubleToStr(risk_ratio, 1)
   );
}

/*
 * Get information about market conditions in text format.
 */
string GetMarketTextDetails() {
   return StringConcatenate("MarketInfo: ",
     "Symbol: ", Symbol(), "; ",
     "Ask: ", DoubleToStr(Ask, Digits), "; ",
     "Bid: ", DoubleToStr(Bid, Digits), "; ",
     "Spread: ", GetMarketSpread(TRUE), " points = ", ValueToPips(GetMarketSpread()), " pips; "
   );
}

/*
 * Get account summary text.
 */
string GetSummaryText() {
  return GetAccountTextDetails();
}

/*
 * Get risk ratio text based on the value.
 */
string GetRiskRatioText() {
  string text = "Normal";
  if (risk_ratio < 0.2) text = "Extremely risky!";
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

/*
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

/* BEGIN: CONVERTING FUNCTIONS */

/*
 * Returns OrderType as a text.
 */
string _OrderType_str(int _OrderType) {
  switch ( _OrderType ) {
    case OP_BUY:          return("Buy");
    case OP_SELL:         return("Sell");
    case OP_BUYLIMIT:     return("BuyLimit");
    case OP_BUYSTOP:      return("BuyStop");
    case OP_SELLLIMIT:    return("SellLimit");
    case OP_SELLSTOP:     return("SellStop");
    default:              return("UnknownOrderType");
  }
}

/* END: CONVERTING FUNCTIONS */

/* BEGIN: STRING FUNCTIONS */

/*
 * Remove separator character from the end of the string.
 */
void TxtRemoveSepChar(string& text, string sep) {
  if (StringSubstr(text, StringLen(text)-1) == sep) text = StringSubstr(text, 0, StringLen(text)-1);
}

/* END: STRING FUNCTIONS */

/* BEGIN: ARRAY FUNCTIONS */

/*
 * Find lower value within the 1-dim array of floats.
 */
double LowestArrValue(double& arr[]) {
  return (arr[ArrayMinimum(arr)]);
}

/*
 * Find higher value within the 1-dim array of floats.
 */
double HighestArrValue(double& arr[]) {
   return (arr[ArrayMaximum(arr)]);
}

/*
 * Find lower value within the 2-dim array of floats by the key.
 */
double LowestArrValue2(double& arr[][], int key1) {
  double lowest = 0;
  for (int i = 0; i < ArrayRange(arr, 1); i++) {
    if (arr[key1][i] < lowest) {
      lowest = arr[key1][i];
    }
  }
  return lowest;
}

/*
 * Find higher value within the 2-dim array of floats by the key.
 */
double HighestArrValue2(double& arr[][], int key1) {
  double highest = 0;
  for (int i = 0; i < ArrayRange(arr, 1); i++) {
    if (arr[key1][i] > highest) {
      highest = arr[key1][i];
    }
  }
  return highest;
}

/*
 * Find highest value in 2-dim array of integers by the key.
 */
int HighestValueByKey(int& arr[][], int key) {
  double highest = 0;
  for (int i = 0; i < ArrayRange(arr, 1); i++) {
    if (arr[key][i] > highest) {
      highest = arr[key][i];
    }
  }
  return highest;
}

/*
 * Find lowest value in 2-dim array of integers by the key.
 */
int LowestValueByKey(int& arr[][], int key) {
  double lowest = 0;
  for (int i = 0; i < ArrayRange(arr, 1); i++) {
    if (arr[key][i] < lowest) {
      lowest = arr[key][i];
    }
  }
  return lowest;
}

/*
int GetLowestArrDoubleValue(double& arr[][], int key) {
  double lowest = -1;
  for (int i = 0; i < ArrayRange(arr, 0); i++) {
    for (int j = 0; j < ArrayRange(arr, 1); j++) {
      if (arr[i][j] < lowest) {
        lowest = arr[i][j];
      }
    }
  }
  return lowest;
}*/

/*
 * Find key in array of integers with highest value.
 */
int GetArrKey1ByHighestKey2Value(int& arr[][], int key2) {
  int key1 = EMPTY;
  int highest = 0;
  for (int i = 0; i < ArrayRange(arr, 0); i++) {
      if (arr[i][key2] > highest) {
        highest = arr[i][key2];
        key1 = i;
      }
  }
  return key1;
}

/*
 * Find key in array of integers with lowest value.
 */
int GetArrKey1ByLowestKey2Value(int& arr[][], int key2) {
  int key1 = EMPTY;
  int lowest = 0;
  for (int i = 0; i < ArrayRange(arr, 0); i++) {
      if (arr[i][key2] < lowest) {
        lowest = arr[i][key2];
        key1 = i;
      }
  }
  return key1;
}

/*
 * Find key in array of doubles with highest value.
 */
int GetArrKey1ByHighestKey2ValueD(double& arr[][], int key2) {
  int key1 = EMPTY;
  int highest = 0;
  for (int i = 0; i < ArrayRange(arr, 0); i++) {
      if (arr[i][key2] > highest) {
        highest = arr[i][key2];
        key1 = i;
      }
  }
  return key1;
}

/*
 * Find key in array of doubles with lowest value.
 */
int GetArrKey1ByLowestKey2ValueD(double& arr[][], int key2) {
  int key1 = EMPTY;
  int lowest = 0;
  for (int i = 0; i < ArrayRange(arr, 0); i++) {
      if (arr[i][key2] < lowest) {
        lowest = arr[i][key2];
        key1 = i;
      }
  }
  return key1;
}

/*
 * Set array value for double items with specific keys.
 */
void ArrSetValueD(double& arr[][], int key, double value) {
  for (int i = 0; i < ArrayRange(info, 0); i++) {
    arr[i][key] = value;
  }
}

/*
 * Set array value for integer items with specific keys.
 */
void ArrSetValueI(int& arr[][], int key, int value) {
  for (int i = 0; i < ArrayRange(info, 0); i++) {
    arr[i][key] = value;
  }
}

/*
 * Calculate sum of 2 dimentional array based on given key.
 */
double GetArrSumKey1(double& arr[][], int key1, int offset = 0) {
  double sum = 0;
  offset = MathMin(offset, ArrayRange(arr, 1) - 1);
  for (int i = offset; i < ArrayRange(arr, 1); i++) {
    sum += arr[key1][i];
  }
  return sum;
}

/* END: ARRAY FUNCTIONS */

/* BEGIN: ACTION FUNCTIONS */

#ifdef __advanced__

/*
 * Execute action to close most profitable order.
 */
bool ActionCloseMostProfitableOrder(int reason_id = EMPTY, int min_profit = EMPTY){
  bool result = FALSE;
  int selected_ticket = 0;
  double max_ticket_profit = 0, curr_ticket_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES))
     if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
      curr_ticket_profit = GetOrderProfit();
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
    Print(__FUNCTION__ + "(): Can't find any profitable order.");
  }
  return (FALSE);
}

/*
 * Execute action to close most unprofitable order.
 */
bool ActionCloseMostUnprofitableOrder(int reason_id = EMPTY){
  int selected_ticket = 0;
  double ticket_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES))
     if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if (GetOrderProfit() < ticket_profit) {
         selected_ticket = OrderTicket();
         ticket_profit = GetOrderProfit();
       }
     }
  }

  if (selected_ticket > 0) {
    last_close_profit = ticket_profit;
    return TaskAddCloseOrder(selected_ticket, reason_id);
  } else if (VerboseDebug) {
    Print(__FUNCTION__ + "(): Can't find any unprofitable order as requested.");
  }
  return (FALSE);
}

/*
 * Execute action to close all profitable orders.
 */
bool ActionCloseAllProfitableOrders(int reason_id = EMPTY){
  bool result = FALSE;
  int selected_orders;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = GetOrderProfit();
       if (ticket_profit > 0) {
         result = TaskAddCloseOrder(OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    if (VerboseInfo) Print(__FUNCTION__ + "(): Queued " + selected_orders + " orders to close with expected profit of " + total_profit + " pips.");
  }
  return (result);
}

/*
 * Execute action to close all unprofitable orders.
 */
bool ActionCloseAllUnprofitableOrders(int reason_id = EMPTY){
  bool result = FALSE;
  int selected_orders;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = GetOrderProfit();
       if (ticket_profit < 0) {
         result = TaskAddCloseOrder(OrderTicket(), reason_id);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0) {
    last_close_profit = total_profit;
    if (VerboseInfo) Print(__FUNCTION__ + "(): Queued " + selected_orders + " orders to close with expected loss of " + total_profit + " pips.");
  }
  return (result);
}

/*
 * Execute action to close all orders by specified type.
 */
bool ActionCloseAllOrdersByType(int cmd = EMPTY, int reason_id = EMPTY){
  int selected_orders;
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
    if (VerboseInfo) Print(__FUNCTION__ + "(" + _OrderType_str(cmd) + "): Queued " + selected_orders + " orders to close with expected profit of " + total_profit + " pips.");
  }
  return (FALSE);
}

/*
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
         total_profit += GetOrderProfit();
         TaskAddCloseOrder(OrderTicket(), reason_id); // Add task to re-try.
         processed++;
      } else {
        if (VerboseDebug)
         Print(__FUNCTION__ + "(): Error: Order Pos: " + order + "; Message: ", GetErrorText(GetLastError()));
      }
   }

   if (processed > 0) {
    last_close_profit = total_profit;
     if (VerboseInfo) Print(__FUNCTION__ + "(): Queued " + processed + " orders out of " + total + " for closure.");
   }
   return (processed > 0);
}

/*
 * Execute action by its id. See: EA_Conditions parameters.
 *
 * Note: Executing random actions can be potentially dangerous for the account if not used wisely.
 */
bool ActionExecute(int aid, int id = EMPTY) {
  bool result = FALSE;
  int reason_id = If(id != EMPTY, acc_conditions[id][0], EMPTY); // Account id condition.
  int mid = If(id != EMPTY, acc_conditions[id][1], EMPTY); // Market id condition.
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
        result = ActionCloseAllOrdersByType(CmdOpp(cmd), reason_id);
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
        result = ActionCloseAllOrdersByType(CmdOpp(cmd), reason_id);
      }
      break;
    case A_CLOSE_ALL_ORDERS: /* 10 */
      result = ActionCloseAllOrders(reason_id);
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
      if (VerboseDebug) Print(__FUNCTION__ + "(): Unknown action id: ", aid);
  }
  // reason = "Account condition: " + acc_conditions[i][0] + ", Market condition: " + acc_conditions[i][1] + ", Action: " + acc_conditions[i][2] + " [E: " + ValueToCurrency(AccountEquity()) + "/B: " + ValueToCurrency(AccountBalance()) + "]";

  TaskProcessList(TRUE); // Process task list immediately after action has been taken.
  if (VerboseInfo) PrintFormat("%s(): %s; %s", __FUNCTION__, GetAccountTextDetails(), GetOrdersStats());
  if (result) {
    Message(StringFormat("%s(): Executed action: %s (id: %d), because of market condition: %s (id: %d) and account condition: %s (id: %d) [E:%s/B:%s/P:%sp].",
      __FUNCTION__, ActionIdToText(aid), aid, MarketIdToText(mid), mid, ReasonIdToText(reason_id), reason_id, ValueToCurrency(AccountEquity()), ValueToCurrency(AccountBalance()), DoubleToStr(last_close_profit, 1)));
    if (VerboseDebug && aid != A_NONE) Print(GetLastMessage());
    if (WriteReport && VerboseDebug) ReportAdd(GetLastMessage());
    last_action_time = last_bar_time; // Set last execution bar time.
  } else {
    if (VerboseDebug) Message(StringFormat("%s(): Failed to execute action: %s (id: %d), condition: %s (id: %d).", __FUNCTION__, ActionIdToText(aid), aid, ReasonIdToText(reason_id), reason_id));
  }
  return result;
}

/*
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

/*
 * Convert reason id into text representation.
 */
string ReasonIdToText(int rid) {
  string output = "Unknown";
  switch (rid) {
    case EMPTY: output = "Empty"; break;
    case C_ACC_NONE: output = "None (inactive)"; break;
    case C_ACC_TRUE: output = "Always true"; break;
    case C_EQUITY_LOWER: output = "Equity lower than balance"; break;
    case C_EQUITY_HIGHER: output = "Equity higher than balance"; break;
    case C_EQUITY_50PC_HIGH: output = "Equity 50% high"; break;
    case C_EQUITY_20PC_HIGH: output = "Equity 20% high"; break;
    case C_EQUITY_10PC_HIGH: output = "Equity 10% high"; break;
    case C_EQUITY_10PC_LOW: output = "Equity 10% low"; break;
    case C_EQUITY_20PC_LOW: output = "Equity 20% low"; break;
    case C_EQUITY_50PC_LOW: output = "Equity 50% low"; break;
    case C_MARGIN_USED_50PC: output = "50% Margin Used"; break;
    case C_MARGIN_USED_70PC: output = "70% Margin Used"; break;
    case C_MARGIN_USED_80PC: output = "80% Margin Used"; break;
    case C_MARGIN_USED_90PC: output = "90% Margin Used"; break;
    case C_NO_FREE_MARGIN: output = "No free margin."; break;
    case C_ACC_IN_LOSS: output = "Account in loss"; break;
    case C_ACC_IN_PROFIT: output = "Account in profit"; break;
    case C_DBAL_LT_WEEKLY: output = "Max. daily balance < max. weekly"; break;
    case C_DBAL_GT_WEEKLY: output = "Max. daily balance > max. weekly"; break;
    case C_WBAL_LT_MONTHLY: output = "Max. weekly balance < max. monthly"; break;
    case C_WBAL_GT_MONTHLY: output = "Max. weekly balance > max. monthly"; break;
    case C_ACC_IN_TREND: output = "Account in trend"; break;
    case C_ACC_IN_NON_TREND: output = "Account is against trend"; break;
    case C_ACC_CDAY_IN_PROFIT: output = "Current day in profit"; break;
    case C_ACC_CDAY_IN_LOSS: output = "Current day in loss"; break;
    case C_ACC_PDAY_IN_PROFIT: output = "Previous day in profit"; break;
    case C_ACC_PDAY_IN_LOSS: output = "Previous day in loss"; break;
    case C_ACC_MAX_ORDERS: output = "Maximum orders opened"; break;
  }
  return output;
}

/*
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
  }
  return output;
}

#endif

/* END: ACTION FUNCTIONS */

/* BEGIN: TICKET LIST/HISTORY CHECK FUNCTIONS */

/*
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
      if (VerboseDebug) Print(__FUNCTION__ + "(): Couldn't allocate Ticket slot, re-sizing the array. New size: ",  (size + 1), ", Old size: ", size);
      slot = size;
    }
    return (FALSE); // Array exceeded hard limit, probably because of some memory leak.
  }

  tickets[slot] = ticket_no;
  return (TRUE);
}

/*
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

/*
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
/*
 * Process AI queue of orders to see if we can open any trades.
 */
bool OrderQueueProcess(int method = EMPTY, int filter = EMPTY) {
  bool result = FALSE;
  int queue_size = OrderQueueCount();
  int sorted_queue[][2];
  int cmd, sid, time; double volume;
  if (method == EMPTY) method = QueueOrdersAIMethod;
  if (filter == EMPTY) filter = QueueOrdersAIFilter;
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
    for (i = 0; i < queue_size; i++) {
      selected_qid = sorted_queue[i][1];
      cmd = order_queue[selected_qid][Q_CMD];
      sid = order_queue[selected_qid][Q_SID];
      time = order_queue[selected_qid][Q_TIME];
      volume = GetStrategyLotSize(sid, cmd);
      if (!OrderOrderCondition(cmd, sid, time, filter)) continue;
      if (OpenOrderIsAllowed(cmd, sid, volume)) {
        string comment = GetStrategyComment(sid) + " [AIQueued]";
        result = ExecuteOrder(cmd, sid, volume);
        break;
      }
    }
  }
  return result;
}

/*
 * Check for the market condition to filter out the order queue.
 */
bool OrderOrderCondition(int cmd, int sid, int time, int method) {
  bool result = TRUE;
  int timeframe = GetStrategyTimeframe(sid);
  int period = TfToPeriod(timeframe);
  int qshift = iBarShift(_Symbol, timeframe, time, FALSE); // Get the number of bars for the timeframe since queued.
  double qopen = iOpen(_Symbol, timeframe, qshift);
  double qclose = iClose(_Symbol, timeframe, qshift);
  double qhighest = GetPeakPrice(timeframe, MODE_HIGH, qshift); // Get the high price since queued.
  double qlowest = GetPeakPrice(timeframe, MODE_LOW, qshift); // Get the lowest price since queued.
  double diff = MathMax(qhighest - Open[CURR], Open[CURR] - qlowest);
  if ((method &   1) != 0) result &= (cmd == OP_BUY && qopen < Open[CURR]) || (cmd == OP_SELL && qopen > Open[CURR]);
  if ((method &   2) != 0) result &= (cmd == OP_BUY && qclose < Close[CURR]) || (cmd == OP_SELL && qclose > Close[CURR]);
  if ((method &   4) != 0) result &= (cmd == OP_BUY && qlowest < Low[CURR]) || (cmd == OP_SELL && qlowest > Low[CURR]);
  if ((method &   8) != 0) result &= (cmd == OP_BUY && qhighest > High[CURR]) || (cmd == OP_SELL && qhighest < High[CURR]);
  if ((method &  16) != 0) result &= UpdateIndicator(SAR, timeframe) && Trade_SAR(cmd, timeframe, 0, 0);
  if ((method &  32) != 0) result &= UpdateIndicator(DEMARKER, timeframe) && Trade_DeMarker(cmd, timeframe, 0, 0);
  if ((method &  64) != 0) result &= UpdateIndicator(RSI, timeframe) && Trade_RSI(cmd, timeframe, 0, 0);
  if ((method & 128) != 0) result &= UpdateIndicator(MA, timeframe) && Trade_MA(cmd, timeframe, 0, 0);
  return (result);
}

/*
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

/*
 * Get the next non-empty item from the queue.
 */
int OrderQueueNext(int index = EMPTY) {
  if (index == EMPTY) index = 0;
  for (int qid = index; qid < ArrayRange(order_queue, 0); qid++)
    if (order_queue[qid][Q_SID] != EMPTY) { return qid; }
  return (EMPTY);
}

/*
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

/*
 * Clear queue from the orders.
 */
void OrderQueueClear() {
  if (VerboseTrace) Print("Calling " + __FUNCTION__ + "().");
  ArrayFill(order_queue, 0, ArraySize(order_queue), EMPTY);
}

/*
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

/*
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
    // Print(__FUNCTION__ + "(): Added task (", job_id, ") for ticket: ", todo_queue[job_id][0], ", type: ", todo_queue[job_id][1], " (", todo_queue[job_id][3], ").");
    return TRUE;
  } else {
    return FALSE; // Job not allocated.
  }
}

/*
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
    if (VerboseTrace) Print(__FUNCTION__ + "(): Failed to allocate close task for ticket: " + ticket_no);
    return FALSE; // Job is not allocated.
  }
}

/*
 * Add new task to recalculate loss/profit.
 */
bool TaskAddCalcStats(int ticket_no, int order_type = EMPTY) {
  int job_id = TaskFindEmptySlot(ticket_no);
  if (job_id >= 0) {
    todo_queue[job_id][0] = ticket_no;
    todo_queue[job_id][1] = TASK_CALC_STATS;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = order_type;
    // if (VerboseTrace) Print(__FUNCTION__ + "(): Allocated task (id: ", job_id, ") for ticket: ", todo_queue[job_id][0], ".");
    return TRUE;
  } else {
    if (VerboseTrace) Print(__FUNCTION__ + "(): Failed to allocate task for ticket: " + ticket_no);
    return FALSE; // Job is not allocated.
  }
}

// Remove specific task.
bool TaskRemove(int job_id) {
  todo_queue[job_id][0] = 0;
  todo_queue[job_id][2] = 0;
  // if (VerboseTrace) Print(__FUNCTION__ + "(): Task removed for id: " + job_id);
  return TRUE;
}

// Check if task for specific ticket already exists.
bool TaskExistByKey(int key) {
  for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
    if (todo_queue[job_id][0] == key) {
      // if (VerboseTrace) Print(__FUNCTION__ + "(): Task already allocated for key: " + key);
      return (TRUE);
      break;
    }
  }
  return (FALSE);
}

/*
 * Find available slot id.
 */
int TaskFindEmptySlot(int key) {
  int taken = 0;
  if (!TaskExistByKey(key)) {
    for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
      if (VerboseTrace) Print(__FUNCTION__ + "(): job_id = " + job_id + "; key: " + todo_queue[job_id][0]);
      if (todo_queue[job_id][0] <= 0) { // Find empty slot.
        // if (VerboseTrace) Print(__FUNCTION__ + "(): Found empty slot at: " + job_id);
        return job_id;
      } else taken++;
    }
    // If no empty slots, Otherwise increase size of array.
    int size = ArrayRange(todo_queue, 0);
    if (size < 1000) { // Set array hard limit.
      ArrayResize(todo_queue, size + 10);
      if (VerboseDebug) Print(__FUNCTION__ + "(): Couldn't allocate Task slot, re-sizing array. New size: ",  (size + 1), ", Old size: ", size);
      return size;
    } else {
      // Array exceeded hard limit, probably because of some memory leak.
      if (VerboseDebug) Print(__FUNCTION__ + "(): Couldn't allocate task slot, all are taken (" + taken + "). Size: " + size);
    }
  }
  return EMPTY;
}

/*
 * Run specific task.
 */
bool TaskRun(int job_id) {
  bool result = FALSE;
  int key = todo_queue[job_id][0];
  int task_type = todo_queue[job_id][1];
  int retries = todo_queue[job_id][2];
  int cmd, sid, reason_id;
  // if (VerboseTrace) Print(__FUNCTION__ + "(): Job id: " + job_id + "; Task type: " + task_type);

  switch (task_type) {
    case TASK_ORDER_OPEN:
       cmd = todo_queue[job_id][3];
       // double volume = todo_queue[job_id][4]; // FIXME: Not used as we can't use double to integer array.
       sid = todo_queue[job_id][5];
       // string order_comment = todo_queue[job_id][6]; // FIXME: Not used as we can't use double to integer array.
       result = ExecuteOrder(cmd, sid, EMPTY, EMPTY, FALSE);
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
          if (VerboseDebug) Print(__FUNCTION__ + "(): Access to history failed with error: (" + GetLastError() + ").");
        }
      break;
    default:
      if (VerboseDebug) Print(__FUNCTION__ + "(): Unknown task: ", task_type);
  };
  return result;
}

/*
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

   RefreshRates();
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
     Print(__FUNCTION__, "(): Processed ", total_run+total_failed, " jobs (", total_run, " run, ", total_failed, " failed (", total_removed, " removed)).");
  return TRUE;
}

/* END: TASK FUNCTIONS */

/* BEGIN: CHART FUNCTIONS */

void DrawMA(int timeframe) {
   int Counter = 1;
   int shift=iBarShift(Symbol(), timeframe, time_current);
   while(Counter < Bars) {
      string itime = iTime(NULL, timeframe, Counter);

      // FIXME: The shift parameter (Counter, Counter-1) doesn't use the real values of MA_Fast, MA_Medium and MA_Slow including MA_Shift_Fast, etc.
      double MA_Fast_Curr = iMA(NULL, timeframe, MA_Period_Fast, 0, MA_Method, MA_Applied_Price, Counter); // Current Bar.
      double MA_Fast_Prev = iMA(NULL, timeframe, MA_Period_Fast, 0, MA_Method, MA_Applied_Price, Counter-1); // Previous Bar.
      ObjectCreate("MA_Fast" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Fast_Curr, iTime(NULL,0,Counter-1), MA_Fast_Prev);
      ObjectSet("MA_Fast" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Fast" + itime, OBJPROP_COLOR, Yellow);

      double MA_Medium_Curr = iMA(NULL, timeframe, MA_Period_Medium, 0, MA_Method, MA_Applied_Price, Counter); // Current Bar.
      double MA_Medium_Prev = iMA(NULL, timeframe, MA_Period_Medium, 0, MA_Method, MA_Applied_Price, Counter-1); // Previous Bar.
      ObjectCreate("MA_Medium" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Medium_Curr, iTime(NULL,0,Counter-1), MA_Medium_Prev);
      ObjectSet("MA_Medium" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Medium" + itime, OBJPROP_COLOR, Gold);

      double MA_Slow_Curr = iMA(NULL, timeframe, MA_Period_Slow, 0, MA_Method, MA_Applied_Price, Counter); // Current Bar.
      double MA_Slow_Prev = iMA(NULL, timeframe, MA_Period_Slow, 0, MA_Method, MA_Applied_Price, Counter-1); // Previous Bar.
      ObjectCreate("MA_Slow" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Slow_Curr, iTime(NULL,0,Counter-1), MA_Slow_Prev);
      ObjectSet("MA_Slow" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Slow" + itime, OBJPROP_COLOR, Orange);
      Counter++;
   }
}

/*
 * Draw a vertical line.
 */
bool DrawVLine(string oname, datetime tm) {
  bool result = ObjectCreate(NULL, oname, OBJ_VLINE, 0, tm, 0);
  if (!result) PrintFormat("%(): Can't create vertical line! code #", __FUNCTION__, GetLastError());
  return (result);
}

/*
 * Draw a horizontal line.
 */
bool DrawHLine(string oname, double value) {
  bool result = ObjectCreate(NULL, oname, OBJ_HLINE, 0, 0, value);
  if (!result) PrintFormat("%(): Can't create horizontal line! code #", __FUNCTION__, GetLastError());
  return (result);
}

/*
 * Delete a vertical line.
 */
bool DeleteVertLine(string oname) {
  bool result = ObjectDelete(NULL, oname);
  if (!result) PrintFormat("%(): Can't delete vertical line! code #", __FUNCTION__, GetLastError());
   return (result);
}

/* END: CHART FUNCTIONS */

/* BEGIN: ERROR HANDLING FUNCTIONS */

/*
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

/*
 * Get text description based on the uninitialization reason code.
 */
string getUninitReasonText(int reasonCode) {
   string text = "";
   switch(reasonCode) {
     case REASON_PROGRAM: // 0
       text = "EA terminated its operation."; // By calling the ExpertRemove() function?!
       break;
     case REASON_REMOVE: // 1 (implemented for the indicators only)
       text = "Program " + __FILE__ + " has been deleted from the chart.";
       break;
      case REASON_RECOMPILE: // 2 (implemented for the indicators only)
        text = "Program " + __FILE__ + " has been recompiled.";
        break;
      case REASON_CHARTCHANGE: // 3
        text = "Symbol or chart period has been changed.";
        break;
      case REASON_CHARTCLOSE: // 4
        text = "Chart has been closed.";
        break;
      case REASON_PARAMETERS: // 5
        text = "Input parameters have been changed by a user.";
        break;
      case REASON_ACCOUNT: // 6
        text = "Another account has been activated or reconnection to the trade server has occurred due to changes in the account settings.";
        break;
      case REASON_TEMPLATE: // 7
        text = "	A new template has been applied to chart.";
        break;
      case REASON_INITFAILED: // 8
        text = "Configuration issue. OnInit() handler has returned a nonzero value.";
        break;
      case REASON_CLOSE: // 9
        text = "Terminal has been closed.";
        break;
      default:
        text = "Unknown reason.";
        break;
     }
   return text;
}

/* END: ERROR HANDLING FUNCTIONS */

/* BEGIN: SUMMARY REPORT */

#define OP_BALANCE 6
#define OP_CREDIT  7

double InitialDeposit;
double SummaryProfit;
double GrossProfit;
double GrossLoss;
double MaxProfit;
double MinProfit;
double ConProfit1;
double ConProfit2;
double ConLoss1;
double ConLoss2;
double MaxLoss;
double MaxDrawdown;
double MaxDrawdownPercent;
double RelDrawdownPercent;
double RelDrawdown;
double ExpectedPayoff;
double ProfitFactor;
double AbsoluteDrawdown;
int    SummaryTrades;
int    ProfitTrades;
int    LossTrades;
int    ShortTrades;
int    LongTrades;
int    WinShortTrades;
int    WinLongTrades;
int    ConProfitTrades1;
int    ConProfitTrades2;
int    ConLossTrades1;
int    ConLossTrades2;
int    AvgConWinners;
int    AvgConLosers;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateSummary(double initial_deposit)
  {
   int    sequence=0, profitseqs=0, lossseqs=0;
   double sequential=0.0, prevprofit=EMPTY_VALUE, drawdownpercent, drawdown;
   double maxpeak=initial_deposit, minpeak=initial_deposit, balance=initial_deposit;
   int    trades_total = HistoryTotal();
   double profit;
//---- initialize summaries
   InitializeSummaries(initial_deposit);
//----
   for (int i = 0; i < trades_total; i++) {
      if (!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) continue;
      int type=OrderType();
      //---- initial balance not considered
      if (i == 0 && type == OP_BALANCE) continue;
      //---- calculate profit
      profit = OrderProfit() + OrderCommission() + OrderSwap();
      balance += profit;
      //---- drawdown check
      if(maxpeak<balance) {
         drawdown=maxpeak-minpeak;
         if(maxpeak!=0.0) {
            drawdownpercent=drawdown/maxpeak*100.0;
            if(RelDrawdownPercent<drawdownpercent) {
               RelDrawdownPercent=drawdownpercent;
               RelDrawdown=drawdown;
              }
           }
         if(MaxDrawdown < drawdown) {
            MaxDrawdown = drawdown;
            if (maxpeak != 0.0) MaxDrawdownPercent = MaxDrawdown / maxpeak * 100.0;
            else MaxDrawdownPercent=100.0;
         }
         maxpeak = balance;
         minpeak = balance;
      }
      if (minpeak > balance) minpeak = balance;
      if (MaxLoss > balance) MaxLoss = balance;
      //---- market orders only
      if (type != OP_BUY && type != OP_SELL) continue;
      //---- calculate profit in points
      // profit=(OrderClosePrice()-OrderOpenPrice())/MarketInfo(OrderSymbol(),MODE_POINT);
      SummaryProfit += profit;
      SummaryTrades++;
      if (type == OP_BUY) LongTrades++;
      else             ShortTrades++;
      if(profit<0) { //---- loss trades
         LossTrades++;
         GrossLoss+=profit;
         if(MinProfit>profit) MinProfit=profit;
         //---- fortune changed
         if(prevprofit!=EMPTY_VALUE && prevprofit>=0)
           {
            if(ConProfitTrades1<sequence ||
               (ConProfitTrades1==sequence && ConProfit2<sequential))
              {
               ConProfitTrades1=sequence;
               ConProfit1=sequential;
              }
            if(ConProfit2<sequential ||
               (ConProfit2==sequential && ConProfitTrades1<sequence))
              {
               ConProfit2=sequential;
               ConProfitTrades2=sequence;
              }
            profitseqs++;
            AvgConWinners+=sequence;
            sequence=0;
            sequential=0.0;
           }
        } else { //---- profit trades (profit>=0)
         ProfitTrades++;
         if(type==OP_BUY)  WinLongTrades++;
         if(type==OP_SELL) WinShortTrades++;
         GrossProfit+=profit;
         if(MaxProfit<profit) MaxProfit=profit;
         //---- fortune changed
         if(prevprofit!=EMPTY_VALUE && prevprofit<0)
           {
            if(ConLossTrades1<sequence ||
               (ConLossTrades1==sequence && ConLoss2>sequential))
              {
               ConLossTrades1=sequence;
               ConLoss1=sequential;
              }
            if(ConLoss2>sequential ||
               (ConLoss2==sequential && ConLossTrades1<sequence))
              {
               ConLoss2=sequential;
               ConLossTrades2=sequence;
              }
            lossseqs++;
            AvgConLosers+=sequence;
            sequence=0;
            sequential=0.0;
           }
        }
      sequence++;
      sequential+=profit;
      prevprofit=profit;
     }
//---- final drawdown check
   drawdown = maxpeak - minpeak;
   if (maxpeak != 0.0) {
      drawdownpercent = drawdown / maxpeak * 100.0;
      if (RelDrawdownPercent < drawdownpercent) {
         RelDrawdownPercent = drawdownpercent;
         RelDrawdown = drawdown;
      }
   }
   if (MaxDrawdown < drawdown) {
    MaxDrawdown = drawdown;
    if (maxpeak != 0) MaxDrawdownPercent = MaxDrawdown / maxpeak * 100.0;
    else MaxDrawdownPercent = 100.0;
   }
//---- consider last trade
   if(prevprofit!=EMPTY_VALUE)
     {
      profit=prevprofit;
      if(profit<0)
        {
         if(ConLossTrades1<sequence ||
            (ConLossTrades1==sequence && ConLoss2>sequential))
           {
            ConLossTrades1=sequence;
            ConLoss1=sequential;
           }
         if(ConLoss2>sequential ||
            (ConLoss2==sequential && ConLossTrades1<sequence))
           {
            ConLoss2=sequential;
            ConLossTrades2=sequence;
           }
         lossseqs++;
         AvgConLosers+=sequence;
        }
      else
        {
         if(ConProfitTrades1<sequence ||
            (ConProfitTrades1==sequence && ConProfit2<sequential))
           {
            ConProfitTrades1=sequence;
            ConProfit1=sequential;
           }
         if(ConProfit2<sequential ||
            (ConProfit2==sequential && ConProfitTrades1<sequence))
           {
            ConProfit2=sequential;
            ConProfitTrades2=sequence;
           }
         profitseqs++;
         AvgConWinners+=sequence;
        }
     }
//---- collecting done
   double dnum, profitkoef=0.0, losskoef=0.0, avgprofit=0.0, avgloss=0.0;
//---- average consecutive wins and losses
   dnum=AvgConWinners;
   if(profitseqs>0) AvgConWinners=dnum/profitseqs+0.5;
   dnum=AvgConLosers;
   if(lossseqs>0)   AvgConLosers=dnum/lossseqs+0.5;
//---- absolute values
   if(GrossLoss<0.0) GrossLoss*=-1.0;
   if(MinProfit<0.0) MinProfit*=-1.0;
   if(ConLoss1<0.0)  ConLoss1*=-1.0;
   if(ConLoss2<0.0)  ConLoss2*=-1.0;
//---- profit factor
   if (GrossLoss > 0.0) ProfitFactor = GrossProfit / GrossLoss;
//---- expected payoff
   if (ProfitTrades > 0) avgprofit = GrossProfit / ProfitTrades;
   if (LossTrades > 0)   avgloss   = GrossLoss   / LossTrades;
   if (SummaryTrades > 0) {
    profitkoef = 1.0 * ProfitTrades / SummaryTrades;
    losskoef = 1.0 * LossTrades / SummaryTrades;
    ExpectedPayoff = profitkoef * avgprofit - losskoef * avgloss;
   }
//---- absolute drawdown
   AbsoluteDrawdown = initial_deposit - MaxLoss;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void InitializeSummaries(double initial_deposit)
  {
   InitialDeposit=initial_deposit;
   MaxLoss=initial_deposit;
   SummaryProfit=0.0;
   GrossProfit=0.0;
   GrossLoss=0.0;
   MaxProfit=0.0;
   MinProfit=0.0;
   ConProfit1=0.0;
   ConProfit2=0.0;
   ConLoss1=0.0;
   ConLoss2=0.0;
   MaxDrawdown=0.0;
   MaxDrawdownPercent=0.0;
   RelDrawdownPercent=0.0;
   RelDrawdown=0.0;
   ExpectedPayoff=0.0;
   ProfitFactor=0.0;
   AbsoluteDrawdown=0.0;
   SummaryTrades=0;
   ProfitTrades=0;
   LossTrades=0;
   ShortTrades=0;
   LongTrades=0;
   WinShortTrades=0;
   WinLongTrades=0;
   ConProfitTrades1=0;
   ConProfitTrades2=0;
   ConLossTrades1=0;
   ConLossTrades2=0;
   AvgConWinners=0;
   AvgConLosers=0;
  }

/*
 * Calculates initial deposit based on the current balance and previous orders.
 */
double CalculateInitialDeposit() {
  static double initial_deposit = 0;
  if (initial_deposit > 0) {
    return initial_deposit;
  }
  else if (IsTesting()) {  // FIXME: MQL5: IsTesting()
    initial_deposit = init_balance;
  } else {
    initial_deposit = AccountBalance();
    for (int i = HistoryTotal()-1; i>=0; i--) {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
      int type = OrderType();
      //---- initial balance not considered
      if (i == 0 && type == OP_BALANCE) break;
      if (type == OP_BUY || type == OP_SELL) {
        //---- calculate profit
        double profit=OrderProfit() + OrderCommission() + OrderSwap();
        //---- and decrease balance
        initial_deposit -= profit;
      }
      if (type==OP_BALANCE || type==OP_CREDIT) {
        initial_deposit -= OrderProfit();
      }
    }
  }
  return (initial_deposit);
}

/*
 * Add message into the report file.
 */
void ReportAdd(string msg) {
  int last = ArraySize(log);
  ArrayResize(log, last + 1);
  log[last] = TimeToStr(time_current,TIME_DATE|TIME_SECONDS) + ": " + msg;
}

/*
 * Write report into file.
 */
string GenerateReport(string sep = "\n") {
  string output = "";
  int i;
  output += StringFormat("Initial deposit:                            %.2f", ValueToCurrency(CalculateInitialDeposit())) + sep;
  output += StringFormat("Total net profit:                           %.2f", ValueToCurrency(SummaryProfit)) + sep;
  output += StringFormat("Gross profit:                               %.2f", ValueToCurrency(GrossProfit)) + sep;
  output += StringFormat("Gross loss:                                 %.2f", ValueToCurrency(GrossLoss))  + sep;
  output += StringFormat("Profit factor:                              %.2f", ProfitFactor) + sep;
  output += StringFormat("Expected payoff:                            %.2f", ExpectedPayoff) + sep;
  output += StringFormat("Absolute drawdown:                          %.2f", AbsoluteDrawdown) + sep;
  output += StringFormat("Maximal drawdown:                           %.1f (%.1f%%)", ValueToCurrency(MaxDrawdown), MaxDrawdownPercent) + sep;
  output += StringFormat("Relative drawdown:                          (%.1f%%) %.1f", RelDrawdownPercent, ValueToCurrency(RelDrawdown)) + sep;
  output += StringFormat("Trades total                                %d", SummaryTrades) + sep;
  if (ShortTrades > 0) {
  output += StringFormat("Short positions (won %%):                    %d (%.1f%%)", ShortTrades, 100.0*WinShortTrades/ShortTrades) + sep;
  }
  if (LongTrades > 0) {
  output += StringFormat("Long positions (won %%):                     %d (%.1f%%)", LongTrades, 100.0*WinLongTrades/LongTrades) + sep;
  }
  if (ProfitTrades > 0)
  output += StringFormat("Profit trades (%% of total):                 %d (%.1f%%)", ProfitTrades, 100.0*ProfitTrades/SummaryTrades) + sep;
  if (LossTrades>0)
  output += StringFormat("Loss trades (%% of total):                   %d (%.1f%%)", LossTrades, 100.0*LossTrades/SummaryTrades) + sep;
  output += StringFormat("Largest profit trade:                       %.2f", MaxProfit) + sep;
  output += StringFormat("Largest loss trade:                         %.2f", -MinProfit) + sep;
  if (ProfitTrades > 0)
  output += StringFormat("Average profit trade:                       %.2f", GrossProfit/ProfitTrades) + sep;
  if (LossTrades > 0)
  output += StringFormat("Average loss trade:                         %.2f", -GrossLoss/LossTrades) + sep;
  output += StringFormat("Average consecutive wins:                   %.2f", AvgConWinners) + sep;
  output += StringFormat("Average consecutive losses:                 %.2f", AvgConLosers) + sep;
  output += StringFormat("Maximum consecutive wins (profit in money): %d %.2f", ConProfitTrades1, ConProfit1, ")") + sep;
  output += StringFormat("Maximum consecutive losses (loss in money): %d %.2f", ConLossTrades1, -ConLoss1) + sep;
  output += StringFormat("Maximal consecutive profit (count of wins): %.2f %d", ConProfit2, ConProfitTrades2) + sep;
  output += StringFormat("Maximal consecutive loss (count of losses): %.2f %d", ConLoss2, ConLossTrades2) + sep;
  output += GetStrategyReport();

  // Write report log.
  if (ArraySize(log) > 0) output += "Report log:\n";
  for (i = 0; i < ArraySize(log); i++)
   output += log[i] + sep;

  return output;
}

/*
 * Write report into file.
 */
void WriteReport(string report_name) {
  int handle = FileOpen(report_name, FILE_CSV|FILE_WRITE, '\t');
  if (handle < 1) return;

  string report = GenerateReport();
  FileWrite(handle, report);
  FileClose(handle);

  if (VerboseDebug) {
    PrintText(report);
  }
}

/* END: SUMMARY REPORT */

//+------------------------------------------------------------------+
