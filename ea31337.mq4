//+------------------------------------------------------------------+
//|                                                       EA31337    |
//+------------------------------------------------------------------+
#property description "EA31337"
#property copyright   "kenorb"
#property link        "http://www.mql4.com"
#property version   "100.008"
//#property strict

#include <stderror.mqh>

#include <stdlib.mqh> // Used for: ErrorDescription(), RGB(), CompareDoubles(), DoubleToStrMorePrecision(), IntegerToHexString()
// #include "debug.mqh"

// EA constants.
enum ENUM_STRATEGY_TYPE {
  // Type of strategy being used (used for strategy identification, new strategies append to the end, but in general - do not change!).
  UNKNOWN,
  MA_FAST_ON_BUY,
  MA_FAST_ON_SELL,
  MA_MEDIUM_ON_BUY,
  MA_MEDIUM_ON_SELL,
  MA_LARGE_ON_BUY,
  MA_LARGE_ON_SELL,
  MACD_ON_BUY,
  MACD_ON_SELL,
  FRACTALS_ON_BUY,
  FRACTALS_ON_SELL,
  DEMARKER_ON_BUY,
  DEMARKER_ON_SELL,
  WPR_ON_BUY,
  WPR_ON_SELL,
  ALLIGATOR1_ON_BUY,
  ALLIGATOR1_ON_SELL,
  ALLIGATOR2_ON_BUY,
  ALLIGATOR2_ON_SELL,
  BANDS_ON_BUY,
  BANDS_ON_SELL,
  RSI_ON_BUY,
  RSI_ON_SELL,
  FINAL_STRATEGY_TYPE_ENTRY // Should be the last one. Used to calculate the number of enum items.
};

enum ENUM_TASK_TYPE {
  TASK_ORDER_OPEN,
  TASK_ORDER_CLOSE,
};

enum ENUM_ACTION_TYPE {
  ACTION_NONE,
  ACTION_CLOSE_ORDER_PROFIT,
  ACTION_CLOSE_ORDER_LOSS,
  ACTION_CLOSE_ALL_ORDER_PROFIT,
  ACTION_CLOSE_ALL_ORDER_LOSS,
  ACTION_CLOSE_ALL_ORDER_BUY,
  ACTION_CLOSE_ALL_ORDER_SELL,
  ACTION_CLOSE_ALL_ORDERS,
  // ACTION_RISK_REDUCE,
  // ACTION_RISK_INCREASE,
  ACTION_ORDER_STOPS_DECREASE,
  ACTION_ORDER_PROFIT_DECREASE,
  FINAL_ACTION_TYPE_ENTRY // Should be the last one. Used to calculate number of enum items.
};

// User parameters.
extern string ____EA_Parameters__ = "-----------------------------------------";
//extern int EADelayBetweenTrades = 0; // Delay in bars between the placed orders. Set 0 for no limits.

// extern double EAMinChangeOrders = 5; // Minimum change in pips between placed orders.
// extern double EADelayBetweenOrders = 0; // Minimum delay in seconds between placed orders. FIXME: Fix relative delay in backtesting.
extern bool EACloseOnMarketChange = FALSE; // Close orders on market change.
extern bool EAMinimalizeLosses = FALSE; // Set stop loss to zero, once the order is profitable.
extern int EAMinPipGap = 40; // Minimum gap in pips between trades of the same strategy.
extern int MaxOrderPriceSlippage = 5; // Maximum price slippage for buy or sell orders (in pips).

extern string __EA_Trailing_Parameters__ = "-- Settings for trailing stops --";
extern int TrailingStop = 15;
extern int TrailingStopMethod = 4; // TrailingStop method. Set 0 to disable. Range: 0-10. Suggested value: 1 or 4.
extern bool TrailingStopOneWay = TRUE; // Change trailing stop towards one direction only. Suggested value: TRUE
extern int TrailingProfit = 20;
extern int TrailingProfitMethod = 3; // Trailing Profit method. Set 0 to disable. Range: 0-10. Suggested value: 0, 1, 4 or 10.
extern bool TrailingProfitOneWay = TRUE; // Change trailing profit take towards one direction only.

extern string __EA_Order_Parameters__ = "-- Profit/Loss settings (set 0 for auto) --";
extern double EALotSize = 0; // Default lot size. Set 0 for auto.
extern int EAMaxOrders = 0; // Maximum orders. Set 0 for auto.
extern int EAMaxOrdersPerType = 0; // Maximum orders per strategy type. Set 0 for unlimited.
extern double EATakeProfit = 0.0;
extern double EAStopLoss = 0.0;
extern double RiskRatio = 0; // Suggested value: 1.0. Do not change unless testing.

extern string ____MA_Parameters__ = "-- Settings for the Moving Average indicator --";
extern bool MA_Enabled = TRUE; // Enable MA-based strategy.
extern ENUM_TIMEFRAMES MA_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int MA_Period_Fast = 5; // Suggested value: 5
extern int MA_Period_Medium = 25; // Suggested value: 25
extern int MA_Period_Slow = 60; // Suggested value: 60
extern int MA_Shift_Fast = 0; // Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Medium = 1; // Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Slow = 2; // Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Far = 7; // Far shift. Shift relative to the 2 previous bars (+2).
extern ENUM_MA_METHOD MA_Method = MODE_EMA; // MA method (See: ENUM_MA_METHOD). Range: 0-3. Suggested value: MODE_EMA.
extern ENUM_APPLIED_PRICE MA_Applied_Price = PRICE_WEIGHTED; // MA applied price (See: ENUM_APPLIED_PRICE). Range: 0-6. Suggested values: PRICE_OPEN, PRICE_TYPICAL, PRICE_WEIGHTED.

extern string ____MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --";
extern bool MACD_Enabled = TRUE; // Enable MACD-based strategy.
extern ENUM_TIMEFRAMES MACD_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int MACD_Fast_Period = 5; // Fast EMA averaging period.
extern int MACD_Slow_Period = 50; // Slow EMA averaging period.
extern int MACD_Signal_Period = 11; // Signal line averaging period.
extern double MACD_OpenLevel  = 1.5;
//extern double MACD_CloseLevel = 2; // Set 0 to disable.
extern ENUM_APPLIED_PRICE MACD_Applied_Price = PRICE_CLOSE; // MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int MACD_Shift = 5; // Past MACD value in number of bars. Shift relative to the current bar the given amount of periods ago. Suggested value: 1
extern int MACD_ShiftFar = 2; // Additional MACD far value in number of bars relatively to MACD_Shift.
extern int MACD_TrailingStopMethod = 8; // Trailing Stop method for MACD. Range: 0-10. Set 0 to default.
extern int MACD_TrailingProfitMethod = 3; // Trailing Profit method for MACD. Range: 0-10. Set 0 to default.

extern string ____Fractals_Parameters__ = "-- Settings for the Fractals indicator --";
extern bool Fractals_Enabled = TRUE; // Enable Fractals-based strategy.
extern ENUM_TIMEFRAMES Fractals_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int Fractals_MaxPeriods = 2; // Suggested range: 1-5, Suggested value: 3
extern int Fractals_Shift = 2; // Shift relative to the chart. Suggested value: 0.
extern int Fractals_TrailingStopMethod = 5; // Trailing Stop method for Fractals. Range: 0-10. Set 0 to default.
extern int Fractals_TrailingProfitMethod = 4; // Trailing Profit method for Fractals. Range: 0-10. Set 0 to default.

extern string ____Alligator_1_Parameters__ = "-- Settings for the Alligator 1 indicator --";
extern bool Alligator1_Enabled = TRUE; // Enable Alligator custom-based strategy.
extern ENUM_TIMEFRAMES Alligator1_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int Alligator1_Jaw_Period = 13; // Blue line averaging period (Alligator's Jaw).
extern int Alligator1_Jaw_Shift = 8; // Blue line shift relative to the chart.
extern int Alligator1_Teeth_Period = 8; // Red line averaging period (Alligator's Teeth).
extern int Alligator1_Teeth_Shift = 5; // Red line shift relative to the chart.
extern int Alligator1_Lips_Period = 5; // Green line averaging period (Alligator's Lips).
extern int Alligator1_Lips_Shift = 3; // Green line shift relative to the chart.
extern double Alligator1_OpenLevel = 0.5; // Suggested to not change. Suggested range: 0.0-5.0
extern int Alligator1_Shift = 0;
extern int Alligator1_TrailingStopMethod = 9; // Trailing Stop method for Alligator1. Range: 0-10. Set 0 to default.
extern int Alligator1_TrailingProfitMethod = 1; // Trailing Profit method for Alligator1. Range: 0-10. Set 0 to default.

extern string ____Alligator_2_Parameters__ = "-- Settings for the Alligator 2 indicator --";
extern bool Alligator2_Enabled = FALSE; // Enable Alligator-based strategy.
extern ENUM_TIMEFRAMES Alligator2_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int Alligator2_Jaw_Period = 15; // Blue line averaging period (Alligator's Jaw).
extern int Alligator2_Jaw_Shift = 8; // Blue line shift relative to the chart.
extern int Alligator2_Teeth_Period = 8; // Red line averaging period (Alligator's Teeth).
extern int Alligator2_Teeth_Shift = 5; // Red line shift relative to the chart.
extern int Alligator2_Lips_Period = 5; // Green line averaging period (Alligator's Lips).
extern int Alligator2_Lips_Shift = 3; // Green line shift relative to the chart.
extern ENUM_MA_METHOD Alligator2_MA_Method = MODE_SMMA; // MA method (See: ENUM_MA_METHOD).
extern ENUM_APPLIED_PRICE Alligator2_Applied_Price = PRICE_MEDIAN; // Applied price. It can be any of ENUM_APPLIED_PRICE enumeration values.
extern double Alligator2_OpenLevel = 0.5; // Suggested to not change. Suggested range: 0.0-5.0
extern int Alligator2_Shift = 0;
extern int Alligator2_TrailingStopMethod = 9; // Trailing Stop method for Alligator1. Range: 0-10. Set 0 to default.
extern int Alligator2_TrailingProfitMethod = 1; // Trailing Profit method for Alligator1. Range: 0-10. Set 0 to default.

extern string ____DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --";
extern bool DeMarker_Enabled = TRUE; // Enable DeMarker-based strategy.
extern ENUM_TIMEFRAMES DeMarker_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int DeMarker_Period = 12; // Suggested range: 10-20.
extern int DeMarker_Shift = 0; // Shift relative to the current bar the given amount of periods ago. Suggested value: 0.
extern double DeMarker_Filter = 0.0; // Valid range: 0.0-0.4. Suggested value: 0.0.
extern int DeMarker_TrailingStopMethod = 9; // Trailing Stop method for DeMarker. Range: 0-10. Set 0 to default.
extern int DeMarker_TrailingProfitMethod = 1; // Trailing Profit method for DeMarker. Range: 0-10. Set 0 to default.

extern string ____WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --";
extern bool WPR_Enabled = TRUE; // Enable WPR-based strategy.
extern ENUM_TIMEFRAMES WPR_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int WPR_Period = 14; // Suggested value: 12.
extern int WPR_Shift = 1; // Shift relative to the current bar the given amount of periods ago. Suggested value: 1.
extern int WPR_Filter = 0.0; // Suggested range: 0.0-0.5. Suggested value: 0.0.
extern int WPR_TrailingStopMethod = 6; // Trailing Stop method for WPR. Range: 0-10. Set 0 to default.
extern int WPR_TrailingProfitMethod = 6; // Trailing Profit method for WPR. Range: 0-10. Set 0 to default.

extern string ____RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --";
extern bool RSI_Enabled = FALSE; // Enable RSI-based strategy.
extern ENUM_TIMEFRAMES RSI_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int RSI_Period = 14; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE RSI_Applied_Price = PRICE_HIGH; // RSI applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double RSI_MaxPeriods = 3; // Maximum bar periods to calculate its value.
extern int RSI_TrailingStopMethod = 9; // Trailing Stop method for RSI. Range: 0-10. Set 0 to default.
extern int RSI_TrailingProfitMethod = 1; // Trailing Profit method for RSI. Range: 0-10. Set 0 to default.

extern string ____Bands_Parameters__ = "-- Settings for the Bollinger Bands® indicator --";
extern bool Bands_Enabled = FALSE; // Enable BBands-based strategy.
extern ENUM_TIMEFRAMES Bands_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int Bands_Period = 20; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE Bands_Applied_Price = PRICE_HIGH; // Bands applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int Bands_Deviation = 2; // Number of standard deviations from the main line.
extern int Bands_MaxPeriods = 3; // Maximum bar periods to calculate its value.
extern int Bands_Shift = 0; // The indicator shift relative to the chart.
extern int Bands_TrailingStopMethod = 9; // Trailing Stop method for Bands. Range: 0-10. Set 0 to default.
extern int Bands_TrailingProfitMethod = 1; // Trailing Profit method for Bands. Range: 0-10. Set 0 to default.

extern string ____EA_Conditions__ = "-- Execute actions on certain conditions (set 0 to none) --"; // See: ENUM_ACTION_TYPE
extern int ActionOnDoubledEquity  = ACTION_CLOSE_ORDER_PROFIT; // Execute action when account equity doubled balance.
extern int ActionOnTwoThirdEquity = ACTION_CLOSE_ORDER_LOSS; // Execute action when account has 2/3 of equity.
extern int ActionOnHalfEquity     = ACTION_CLOSE_ALL_ORDER_LOSS; // Execute action when account has half equity.
extern int ActionOnOneThirdEquity = ACTION_CLOSE_ALL_ORDER_LOSS; // Execute action when account has 1/3 of equity.
extern int ActionOnMarginCall     = ACTION_NONE; // Execute action on margin call.
// extern int ActionOnLowBalance     = ACTION_NONE; // Execute action on low balance.

extern string ____Debug_Parameters__ = "-- Settings for log & messages --";
extern bool PrintLogOnChart = TRUE;
extern bool VerboseErrors = TRUE; // Show errors.
extern bool VerboseInfo = TRUE;   // Show info messages.
extern bool VerboseDebug = TRUE;  // Show debug messages.
extern bool VerboseTrace = FALSE;  // Even more debugging.

extern string ____UX_Parameters__ = "-- Settings for User Interface & Experience --";
extern bool SendEmail = FALSE;
extern bool SoundAlert = FALSE;
extern string SoundFileAtOpen = "alert.wav";
extern string SoundFileAtClose = "alert.wav";
extern color ColorBuy = Blue;
extern color ColorSell = Red;

extern string ____Other_Parameters__ = "-----------------------------------------";
extern int MagicNumber = 31337; // To help identify its own orders. It can vary in additional range: +20, see: ENUM_ORDER_TYPE.
extern bool TradeMicroLots = TRUE;
extern int EAManualGMToffset = 0;
extern bool MaxTries = 5; // Number of maximum attempts to execute the order.
//extern int TrailingStopDelay = 0; // How often trailing stop should be updated (in seconds). FIXME: Fix relative delay in backtesting.
// extern int JobProcessDelay = 1; // How often job list should be processed (in seconds).

// ENUM_MA_METHOD values:
//   0: MODE_SMA (Simple averaging)
//   1: MODE_EMA (Exponential averaging)
//   2: MODE_SMMA (Smoothed averaging)
//   3: MODE_LWMA (Linear-weighted averaging)

// ENUM_APPLIED_PRICE values:
//   0: PRICE_CLOSE (Close price)
//   1: PRICE_OPEN (Open price)
//   2: PRICE_HIGH (The maximum price for the period)
//   3: PRICE_LOW (The minimum price for the period)
//   4: PRICE_MEDIAN (Median price, (high + low)/2
//   5: PRICE_TYPICAL (Typical price, (high + low + close)/3
//   6: PRICE_WEIGHTED (Average price, (high + low + close + close)/4

// Market/session variables.
double pip_size;
double market_maxlot;
double market_minlot;
double market_lotstep;
double market_marginrequired;
double market_stoplevel;
int pts_per_pip; // Number points per pip.
int gmt_offset = 0;

// Account variables.
string account_type;
double acc_leverage;
int pip_precision;
int volume_precision;

// State variables.
bool session_initiated;
bool session_active = FALSE;

// EA variables.
string EA_Name = "31337";
bool ea_active = FALSE;
double risk_ratio;
double max_order_slippage; // Maximum price slippage for buy or sell orders (in points)
int err_code; // Error code.
string last_err;
int last_trail_update = 0, last_order_time = 0, last_acc_check = 0, last_indicators_update = 0;
int day_of_month; // Used to print daily reports.
int GMT_Offset;
int todo_queue[100][8], last_queue_process = 0;
int open_orders[FINAL_STRATEGY_TYPE_ENTRY], closed_orders[FINAL_STRATEGY_TYPE_ENTRY];
int total_orders = 0; // Number of total orders currently open.

// Indicator variables.
double MA_Fast[3], MA_Medium[3], MA_Slow[3];
double MACD[3], MACDSignal[3];
double RSI[];
double Bands_main[], Bands_upper[], Bands_lower[];
double Alligator1[3], Alligator2[3];
double DeMarker, WPR;
double Fractals_lower, Fractals_upper;

/* TODO:
 *   - add RSA strategy,
 *   - add RSI strategy,
 *   - add SAR strategy (the Parabolic Stop and Reverse system) (http://docs.mql4.com/indicators/isar),
 *   - add the Average Directional Movement Index indicator (iADX) (http://docs.mql4.com/indicators/iadx),
 *   - add the Stochastic Oscillator (http://docs.mql4.com/indicators/istochastic),
 *   - add the Standard Deviation indicator (iStdDev) (http://docs.mql4.com/indicators/istddev),
 *   - add the Money Flow Index (http://docs.mql4.com/indicators/imfi),
 *   - the Ichimoku Kinko Hyo indicator?
 *   - daily higher highs and lower lows,
 *   - add breakage strategy (Envelopes/Bands?) with Order,
 *   - optimize iAlligator() indicators (http://docs.mql4.com/constants/indicatorconstants/lines).
 *   - check on iGator() indicator.
 *   - add the On Balance Volume indicator (iOBV) (http://docs.mql4.com/indicators/iobv),
 *   - add the Average True Range indicator (iATR) (http://docs.mql4.com/indicators/iatr),
 *   - add the Envelopes indicator,
 *   - add the Force Index indicator (iForce) (http://docs.mql4.com/indicators/iforce),
 *   - add the Moving Average of Oscillator indicator (iOsMA) (http://docs.mql4.com/indicators/iosma),
 *   - BearsPower, BullsPower,
 *   - combined strategies doesn't add up (e.g. 2015.01.10-2015.04.28 test: Fractals+Alligator = 978+1241 != 1909)
 */

/*
 * Predefined constants:
 *   Ask - The latest known seller's price (ask price) of the current symbol.
 *   Bid - The latest known buyer's price (offer price, bid price) of the current symbol.
 *   Point - The current symbol point value in the quote currency.
 *   Digits - Number of digits after decimal point for the current symbol prices.
 *   Bars - Number of bars in the current chart.
 */

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {
  int curr_time = TimeCurrent() - GMT_Offset;
  if (ea_active && TradeAllowed() && Volume[0] > 1) {
    UpdateIndicators();
    Trade();
    if (GetTotalOrders() > 0) {
      UpdateTrailingStops();
      CheckAccount();
      TaskProcessList();
    }
    if (PrintLogOnChart) DisplayInfoOnChart();
  }
} // end: OnTick()

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
   if (VerboseInfo) Print("EA initializing...");
   string err;

   if (!session_initiated) {
      if (!ValidSettings()) {
         err = "Error: EA parameters are not valid, please correct them.";
         Comment(err);
         if (VerboseErrors) Print(err);
         return (INIT_PARAMETERS_INCORRECT); // Incorrect set of input parameters.
      }
      if (!IsTesting() && StringLen(AccountName()) <= 1) {
         err = "Error: EA requires on-line Terminal.";
         Comment(err);
         if (VerboseErrors) Print(err);
         return (INIT_FAILED);
       }
       session_initiated = TRUE;
   }

   // Initial checks.
   if (IsDemo()) account_type = "Demo"; else account_type = "Live";

   // TODO: IsDllsAllowed(), IsLibrariesAllowed()

  // Calculate pip size and precision.
  pts_per_pip = GetPointsPerPip();
  if (Digits < 4) {
    pip_size = 0.01;
    pip_precision = 2;
  } else {
    pip_size = 0.0001;
    pip_precision = 4;
  }
  if (TradeMicroLots) volume_precision = 2; else volume_precision = 1;

   // Initialize startup variables.
   session_initiated = FALSE;

   market_minlot = MarketInfo(Symbol(), MODE_MINLOT);
   if (market_minlot == 0.0) market_minlot = 0.1;
   market_maxlot = MarketInfo(Symbol(), MODE_MAXLOT);
   if (market_maxlot == 0.0) market_maxlot = 100;
   market_lotstep = MarketInfo(Symbol(), MODE_LOTSTEP);
   market_marginrequired = MarketInfo(Symbol(), MODE_MARGINREQUIRED) * market_lotstep;
   if (market_marginrequired == 0) market_marginrequired = 10; // FIX for 'zero divide' bug when MODE_MARGINREQUIRED is zero
   market_stoplevel = MarketInfo(Symbol(), MODE_STOPLEVEL);
   max_order_slippage = MaxOrderPriceSlippage * MathPow(10, Digits - pip_precision); // Maximum price slippage for buy or sell orders (in points).

   GMT_Offset = EAManualGMToffset;
   ArrayResize(RSI, RSI_MaxPeriods + 1);
   ArrayResize(Bands_main, Bands_MaxPeriods + 1);
   ArrayResize(Bands_upper, Bands_MaxPeriods + 1);
   ArrayResize(Bands_lower, Bands_MaxPeriods + 1);
   ArrayFill(todo_queue, 0, ArraySize(todo_queue), 0); // Reset queue list.

   if (IsTesting()) {
     SendEmail = FALSE;
     SoundAlert = FALSE;
     if (!IsVisualMode()) PrintLogOnChart = FALSE;
     if (market_stoplevel == 0) market_stoplevel = 15; // When testing, we need to simulate real MODE_STOPLEVEL = 15 (as it's in real account), in demo it's 0
     if (IsOptimization()) {
       VerboseErrors = FALSE;
       VerboseInfo = FALSE;
       VerboseDebug = FALSE;
       VerboseTrace = FALSE;
    }
   }

   if (VerboseInfo) {
     Print(__FUNCTION__, "(): Predefined variables: Bars = ", Bars, ", Ask = ", Ask, ", Bid = ", Bid, ", Digits = ", Digits, ", Point = ", DoubleToStr(Point, Digits));
     Print(__FUNCTION__, "(): Market info: Symbol: ", Symbol(), ", MINLOT=" + market_minlot + ", MAXLOT=" + market_maxlot +  ", LOTSTEP=" + market_lotstep, ", MODE_MARGINREQUIRED=" + market_marginrequired, ", MODE_STOPLEVEL=", market_stoplevel);
     Print(__FUNCTION__, "(): Account info: AccountLeverage: ", acc_leverage);
     Print(__FUNCTION__, "(): Broker info: ", AccountCompany(), ", pip size = ", pip_size, ", points per pip = ", pts_per_pip, ", pip precision = ", pip_precision, ", volume precision = ", volume_precision);
     Print(__FUNCTION__, "(): EA info: Lot size = ", GetLotSize(), "; Max orders = ", GetMaxOrders(), "; Max orders per type = ", GetMaxOrdersPerType());
     Print(__FUNCTION__, "(): ", GetAccountTextDetails());
   }

   session_active = TRUE;
   ea_active = TRUE;

   return (INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
  ea_active = TRUE;
  if (VerboseDebug) Print("Calling " + __FUNCTION__ + "()");
  if (VerboseInfo) {
    Print("EA deinitializing, reason: " + getUninitReasonText(reason) + " (code: " + reason + ")"); // Also: _UninitReason.
    Print(GetSummaryText());
  }

   if (!IsOptimization()) {
      double ExtInitialDeposit;
      if (!IsTesting()) ExtInitialDeposit = CalculateInitialDeposit();
      CalculateSummary(ExtInitialDeposit);
      string filename = TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES);
      WriteReport(filename + "_31337_Report.txt");
  }
  // DEBUG("n=" + n + " : " +  DoubleToStrMorePrecision(val,19) );
  // DEBUG("CLOSEDEBUGFILE");
}

// The init event handler for tester.
// FIXME: Doesn't seems to work.
void OnTesterInit() {
  if (VerboseDebug) Print("Calling " + __FUNCTION__ + "()");
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
   // Print market info.
}

void Trade() {
  bool order_placed;
  // if (VerboseTrace) Print("Calling " + __FUNCTION__ + "()");
  // vdigits = MarketInfo(Symbol(), MODE_DIGITS);
  UpdateIndicators();

   if (MA_Enabled) {
      if (MAFastOnBuy()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MA_FAST_ON_SELL);
       order_placed = ExecuteOrder(OP_BUY, GetLotSize(), MA_FAST_ON_BUY, "MAFastOnBuy()");
      } else if (MAFastOnSell()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MA_FAST_ON_BUY);
       order_placed = ExecuteOrder(OP_SELL, GetLotSize(), MA_FAST_ON_SELL, "MAFastOnSell()");
      }

      if (MAMediumOnBuy()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MA_MEDIUM_ON_SELL);
       order_placed = ExecuteOrder(OP_BUY, GetLotSize(), MA_MEDIUM_ON_BUY, "MAMediumOnBuy()");
      } else if (MAMediumOnSell()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MA_MEDIUM_ON_BUY);
       order_placed = ExecuteOrder(OP_SELL, GetLotSize(), MA_MEDIUM_ON_SELL, "MAMediumOnSell()");
      }

      if (MASlowOnBuy()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MA_LARGE_ON_SELL);
       order_placed = ExecuteOrder(OP_BUY, GetLotSize(), MA_LARGE_ON_BUY, "MASlowOnBuy()");
      } else if (MASlowOnSell()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MA_LARGE_ON_BUY);
       order_placed = ExecuteOrder(OP_SELL, GetLotSize(), MA_LARGE_ON_SELL, "MASlowOnSell()");
      }
   }

   if (MACD_Enabled) {
      if (MACDOnBuy()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MACD_ON_SELL);
       order_placed = ExecuteOrder(OP_BUY, GetLotSize(), MACD_ON_BUY, "MACDOnBuy()");
      } else if (MACDOnSell()) {
       if (EACloseOnMarketChange) CloseOrdersByType(MACD_ON_BUY);
       order_placed = ExecuteOrder(OP_SELL, GetLotSize(), MACD_ON_SELL, "MACDOnSell()");
      }
   }

   if (Fractals_Enabled) {
      if (FractalsOnBuy()) {
       if (EACloseOnMarketChange) CloseOrdersByType(FRACTALS_ON_SELL);
       order_placed = ExecuteOrder(OP_BUY, GetLotSize(), FRACTALS_ON_BUY, "FractalsOnBuy()");
      } else if (FractalsOnSell()) {
       if (EACloseOnMarketChange) CloseOrdersByType(FRACTALS_ON_BUY);
       order_placed = ExecuteOrder(OP_SELL, GetLotSize(), FRACTALS_ON_SELL, "FractalsOnSell()");
      }
   }

   if (Alligator1_Enabled) {
      if (Alligator1OnBuy()) {
        if (EACloseOnMarketChange) CloseOrdersByType(ALLIGATOR1_ON_SELL);
        order_placed = ExecuteOrder(OP_BUY, GetLotSize(), ALLIGATOR1_ON_BUY, "Alligator1OnBuy()");
      } else if (Alligator1OnSell()) {
        if (EACloseOnMarketChange) CloseOrdersByType(ALLIGATOR1_ON_BUY);
        order_placed = ExecuteOrder(OP_SELL, GetLotSize(), ALLIGATOR1_ON_SELL, "Alligator1OnSell()");
      }
   }

   if (Alligator2_Enabled) {
      if (Alligator2OnBuy()) {
        if (EACloseOnMarketChange) CloseOrdersByType(ALLIGATOR2_ON_SELL);
        order_placed = ExecuteOrder(OP_BUY, GetLotSize(), ALLIGATOR2_ON_BUY, "Alligator2OnBuy()");
      } else if (Alligator2OnSell()) {
        if (EACloseOnMarketChange) CloseOrdersByType(ALLIGATOR2_ON_BUY);
        order_placed = ExecuteOrder(OP_SELL, GetLotSize(), ALLIGATOR2_ON_SELL, "Alligator2OnSell()");
      }
   }

   if (DeMarker_Enabled) {
      if (DeMarkerOnBuy()) {
        if (EACloseOnMarketChange) CloseOrdersByType(DEMARKER_ON_SELL);
        order_placed = ExecuteOrder(OP_BUY, GetLotSize(), DEMARKER_ON_BUY, "DeMarkerOnBuy()");
      } else if (DeMarkerOnSell()) {
        if (EACloseOnMarketChange) CloseOrdersByType(DEMARKER_ON_BUY);
        order_placed = ExecuteOrder(OP_SELL, GetLotSize(), DEMARKER_ON_SELL, "DeMarkerOnSell()");
      }
   }

   if (WPR_Enabled) {
     if (WPROnBuy()) {
       if (EACloseOnMarketChange) CloseOrdersByType(WPR_ON_SELL);
       order_placed = ExecuteOrder(OP_BUY, GetLotSize(), WPR_ON_BUY, "WPROnBuy()");
     } else if (WPROnSell()) {
       if (EACloseOnMarketChange) CloseOrdersByType(WPR_ON_BUY);
       order_placed = ExecuteOrder(OP_SELL, GetLotSize(), WPR_ON_SELL, "WPROnSell()");
     }
   }

   // Print daily report at end of each day.
   int curr_day = - iTime(NULL, PERIOD_D1, 0);
   if (day_of_month != curr_day) {
     if (VerboseInfo) Print(GetDailyReport());
     day_of_month = curr_day;
   }
}

// Check our account if certain conditions are met.
void CheckAccount() {

  // Check timing from last time.
  int bar_time = iTime(NULL, PERIOD_M1, 0);
  if (bar_time == last_acc_check) return; else last_acc_check = bar_time;
  if (VerboseTrace) Print("Calling " + __FUNCTION__ + "()");

  if (AccountEquity() > AccountBalance() * 2) {
    if (VerboseInfo) Print(GetAccountTextDetails());
    ActionExecute(ActionOnDoubledEquity, "account equity doubled");
  }

  if (AccountEquity() < AccountBalance() * 2/3 ) {
    if (VerboseInfo) Print(GetAccountTextDetails());
    ActionExecute(ActionOnTwoThirdEquity, "account equity is two thirds of the balance");
  }

  if (AccountEquity() < AccountBalance() / 2) {
    if (VerboseInfo) Print(GetAccountTextDetails());
    ActionExecute(ActionOnHalfEquity, "account equity is less than half of the balance");
  }

  if (AccountEquity() < AccountBalance() / 3) {
    if (VerboseInfo) Print(GetAccountTextDetails());
    ActionExecute(ActionOnOneThirdEquity, "account equity is less than one third of the balance");
  }
}

bool UpdateIndicators() {
  // Check if bar time has been changed since last check.
  int bar_time = iTime(NULL, PERIOD_M1, 0);
  if ((IsTesting() || IsOptimization()) && bar_time == last_indicators_update) {
    // return (FALSE);
  } else {
    last_indicators_update = bar_time;
  }
  if (VerboseTrace) Print("Calling " + __FUNCTION__  + "()");

  int i;

  // Update Moving Averages indicator values.
  // Note: We don't limit MA calculation with MA_Enabled, because this indicator is used for trailing stop calculation.
  // Calculate MA Fast.
  MA_Fast[0] = iMA(NULL, MA_Timeframe, MA_Period_Fast, 0, MA_Method, MA_Applied_Price, 0); // Current
  MA_Fast[1] = iMA(NULL, MA_Timeframe, MA_Period_Fast, 0, MA_Method, MA_Applied_Price, 1 + MA_Shift_Fast); // Previous
  MA_Fast[2] = iMA(NULL, MA_Timeframe, MA_Period_Fast, 0, MA_Method, MA_Applied_Price, 2 + MA_Shift_Far);
  // Calculate MA Medium.
  MA_Medium[0] = iMA(NULL, MA_Timeframe, MA_Period_Medium, 0, MA_Method, MA_Applied_Price, 0); // Current
  MA_Medium[1] = iMA(NULL, MA_Timeframe, MA_Period_Medium, 0, MA_Method, MA_Applied_Price, 1 + MA_Shift_Medium); // Previous
  MA_Medium[2] = iMA(NULL, MA_Timeframe, MA_Period_Medium, 0, MA_Method, MA_Applied_Price, 2 + MA_Shift_Far);
  // Calculate Ma Slow.
  MA_Slow[0] = iMA(NULL, MA_Timeframe, MA_Period_Slow, 0, MA_Method, MA_Applied_Price, 0); // Current
  MA_Slow[1] = iMA(NULL, MA_Timeframe, MA_Period_Slow, 0, MA_Method, MA_Applied_Price, 1 + MA_Shift_Slow); // Previous
  MA_Slow[2] = iMA(NULL, MA_Timeframe, MA_Period_Slow, 0, MA_Method, MA_Applied_Price, 2 + MA_Shift_Far);
  if (VerboseTrace) { Print("MA_Fast: ", GetArrayValues(MA_Fast), "; MA_Medium: ", GetArrayValues(MA_Medium), "; MA_Slow: ", GetArrayValues(MA_Slow)); }
  if (VerboseDebug && IsVisualMode()) DrawMA();

  if (MACD_Enabled) {
    // Update MACD indicator values.
    MACD[0] = iMACD(NULL, MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_Applied_Price, MODE_MAIN, 0); // Current
    MACD[1] = iMACD(NULL, MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_Applied_Price, MODE_MAIN, 1 + MACD_Shift); // Previous
    MACD[2] = iMACD(NULL, MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_Applied_Price, MODE_MAIN, 2 + MACD_ShiftFar);
    MACDSignal[0] = iMACD(NULL, MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_Applied_Price, MODE_SIGNAL, 0);
    MACDSignal[1] = iMACD(NULL, MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_Applied_Price, MODE_SIGNAL, 1 + MACD_Shift);
    MACDSignal[2] = iMACD(NULL, MACD_Timeframe, MACD_Fast_Period, MACD_Slow_Period, MACD_Signal_Period, MACD_Applied_Price, MODE_SIGNAL, 2 + MACD_ShiftFar);
    if (VerboseTrace) Print("MACD: ", GetArrayValues(MACD), "; Signal: ", GetArrayValues(MACDSignal));
  }

  if (RSI_Enabled) {
    // Update RSI indicator values.
    for (i = 0; i <= RSI_MaxPeriods; i++) {
      RSI[i] = iRSI(NULL, RSI_Timeframe, RSI_Period, RSI_Applied_Price, i);
    }
    if (VerboseTrace) { Print("RSI: ", GetArrayValues(RSI)); }
  }

  if (Bands_Enabled) {
    // Update the Bollinger Bands.
    for (i = 0; i <= Bands_MaxPeriods; i++) {
      Bands_main[i] = iBands(NULL, Bands_Timeframe, Bands_Period, Bands_Deviation, Bands_Shift, Bands_Applied_Price, MODE_MAIN, i);
      Bands_upper[i] = iBands(NULL, Bands_Timeframe, Bands_Period, Bands_Deviation, Bands_Shift, Bands_Applied_Price, MODE_UPPER, i);
      Bands_lower[i] = iBands(NULL, Bands_Timeframe, Bands_Period, Bands_Deviation, Bands_Shift, Bands_Applied_Price, MODE_LOWER, i);
    }
    if (VerboseTrace) Print("Bands: Main: " + GetArrayValues(Bands_main) + "; Upper: " + GetArrayValues(Bands_upper) + "; Lower: " + GetArrayValues(Bands_lower));
  }

  if (Alligator1_Enabled) {
    // Update Alligator indicator values.
    Alligator1[0] = iCustom(NULL, Alligator1_Timeframe, "Alligator", Alligator1_Jaw_Period, Alligator1_Jaw_Shift, Alligator1_Teeth_Period, Alligator1_Teeth_Shift, Alligator1_Lips_Period, Alligator1_Lips_Shift, 0, 0);
    Alligator1[1] = iCustom(NULL, Alligator1_Timeframe, "Alligator", Alligator1_Jaw_Period, Alligator1_Jaw_Shift, Alligator1_Teeth_Period, Alligator1_Teeth_Shift, Alligator1_Lips_Period, Alligator1_Lips_Shift, 1, 0);
    Alligator1[2] = iCustom(NULL, Alligator1_Timeframe, "Alligator", Alligator1_Jaw_Period, Alligator1_Jaw_Shift, Alligator1_Teeth_Period, Alligator1_Teeth_Shift, Alligator1_Lips_Period, Alligator1_Lips_Shift, 2, 0);
    if (VerboseTrace) Print("Alligator1: ", GetArrayValues(Alligator1));
  }

  if (Alligator2_Enabled) {
    // Update Alligator indicator values.
    Alligator2[0] = iAlligator(NULL, Alligator2_Timeframe, Alligator2_Jaw_Period, Alligator2_Jaw_Shift, Alligator2_Teeth_Period, Alligator2_Teeth_Shift, Alligator2_Lips_Period, Alligator2_Lips_Shift, Alligator2_MA_Method, Alligator2_Applied_Price, 0, Alligator2_Shift);
    Alligator2[1] = iAlligator(NULL, Alligator2_Timeframe, Alligator2_Jaw_Period, Alligator2_Jaw_Shift, Alligator2_Teeth_Period, Alligator2_Teeth_Shift, Alligator2_Lips_Period, Alligator2_Lips_Shift, Alligator2_MA_Method, Alligator2_Applied_Price, 1, Alligator2_Shift);
    Alligator2[2] = iAlligator(NULL, Alligator2_Timeframe, Alligator2_Jaw_Period, Alligator2_Jaw_Shift, Alligator2_Teeth_Period, Alligator2_Teeth_Shift, Alligator2_Lips_Period, Alligator2_Lips_Shift, Alligator2_MA_Method, Alligator2_Applied_Price, 2, Alligator2_Shift);
    if (VerboseTrace) Print("Alligator2: ", GetArrayValues(Alligator2));
  }

  if (DeMarker_Enabled) {
    // Update DeMarker indicator values.
    DeMarker = iDeMarker(NULL, DeMarker_Timeframe, DeMarker_Period, DeMarker_Shift);
    if (VerboseTrace) Print("DeMarker: ", DeMarker);
  }

  if (WPR_Enabled) {
    // Update the Larry Williams' Percent Range indicator values.
    WPR = (-iWPR(NULL, WPR_Timeframe, WPR_Period, WPR_Shift)) / 100.0;
    if (VerboseTrace) Print("WPR: ", WPR);
  }

  if (Fractals_Enabled) {
    // Update Fractals indicator values.
    // FIXME: Logic needs to be improved, as we're repeating the same orders for higher MaxPeriod values which results in lower performance.
    double ifractal;
    Fractals_lower = 0;
    Fractals_upper = 0;
    for (i = 0; i <= Fractals_MaxPeriods; i++) {
      ifractal = iFractals(NULL, Fractals_Timeframe, MODE_LOWER, i + Fractals_Shift);
      if (ifractal > 0) Fractals_lower = ifractal;
      ifractal = iFractals(NULL, Fractals_Timeframe, MODE_UPPER, i + Fractals_Shift);
      if (ifractal > 0) Fractals_upper = ifractal;
    }
    if (VerboseTrace && (Fractals_lower != 0.0 || Fractals_upper != 0.0)) Print("Fractals_lower: ", Fractals_lower, ", Fractals_upper:", Fractals_upper);
  }

  return (TRUE);
}

// Trading Signal: when MA1 is crossing MA2, it triggers a trading signal.
bool MAFastOnBuy() {
  bool state = (MA_Fast[0]>MA_Medium[0] && MA_Fast[1]<MA_Medium[1]);
  if (VerboseTrace) Print("MAFastOnBuy(): cond:", state, " - ", NormalizeDouble(MA_Fast[0], Digits), " > ", NormalizeDouble(MA_Medium[0], Digits), " && ", NormalizeDouble(MA_Fast[1], Digits), " < ", NormalizeDouble(MA_Medium[1], Digits));
  return (MA_Fast[0]>MA_Medium[0] && MA_Fast[1]<MA_Medium[1] && MA_Fast[2]<MA_Medium[2]);
}

// // Trading Signal: when MA1 is crossing MA2, it triggers a trading signal.
bool MAFastOnSell() {
  bool state = (MA_Fast[0]<MA_Medium[0] && MA_Fast[1]>MA_Medium[1]);
  if (VerboseTrace) Print("MAFastOnSell(): cond:", state, " - ", NormalizeDouble(MA_Fast[0], Digits), " < ", NormalizeDouble(MA_Medium[0], Digits), " && ", NormalizeDouble(MA_Fast[1], Digits), " > ", NormalizeDouble(MA_Medium[1], Digits));
  return (MA_Fast[0]<MA_Medium[0] && MA_Fast[1]>MA_Medium[1] && MA_Fast[2]>MA_Medium[2]);
}

bool MAMediumOnBuy() {
  return (MA_Fast[0]>MA_Slow[0] && MA_Fast[1]<MA_Slow[1] && MA_Fast[2]<MA_Slow[2]);
}

bool MAMediumOnSell() {
  return (MA_Fast[0]<MA_Slow[0] && MA_Fast[1]>MA_Slow[1] && MA_Fast[2]>MA_Slow[2]);
}

bool MASlowOnBuy() {
  return (MA_Medium[0]>MA_Slow[0] && MA_Medium[1]<MA_Slow[1] && MA_Medium[2]<MA_Slow[2]);
}

bool MASlowOnSell() {
  return (MA_Medium[0]<MA_Slow[0] && MA_Medium[1]>MA_Slow[1] && MA_Medium[2]>MA_Slow[2]);
}

bool MACDOnBuy() {
  // Check for long position (BUY) possibility.
  return (
    MACD[0] < 0 && MACD[0] > MACDSignal[0] && MACD[1] < MACDSignal[1] &&
    MathAbs(MACD[0]) > (MACD_OpenLevel*Point) && MA_Medium[0] > MA_Medium[1]
  );
}

bool MACDOnSell() {
  // Check for short position (SELL) possibility.
  return (
    MACD[0] > 0 && MACD[0] < MACDSignal[0] && MACD[1] > MACDSignal[1] &&
    MACD[0] > (MACD_OpenLevel*Point) && MA_Medium[0] < MA_Medium[1]
  );
}

bool Alligator1OnBuy() {
  // if (VerboseTrace) Print("AlligatorOnBuy(): ", NormalizeDouble(Alligator[2] - Alligator[1], pip_precision), ",", NormalizeDouble(Alligator[1] - Alligator[0], pip_precision), ",", NormalizeDouble(Alligator[2] - Alligator[0], pip_precision), " >= ", NormalizeDouble(Alligator_Ratio * pip_size, pip_precision));
   return (
      Alligator1[2] - Alligator1[1] >= Alligator1_OpenLevel * pip_size &&
      Alligator1[1] - Alligator1[0] >= Alligator1_OpenLevel * pip_size &&
      Alligator1[2] - Alligator1[0] >= Alligator1_OpenLevel * pip_size
   );
}

bool Alligator1OnSell() {
  // if (VerboseTrace) Print("AlligatorOnSell(): ", NormalizeDouble(Alligator[1] - Alligator[2], pip_precision), ",", NormalizeDouble(Alligator[0] - Alligator[1], pip_precision), ",", NormalizeDouble(Alligator[0] - Alligator[2], pip_precision), " >= ", NormalizeDouble(Alligator_Ratio * pip_size, pip_precision));
   return (
      Alligator1[1] - Alligator1[2] >= Alligator1_OpenLevel * pip_size &&
      Alligator1[0] - Alligator1[1] >= Alligator1_OpenLevel * pip_size &&
      Alligator1[0] - Alligator1[2] >= Alligator1_OpenLevel * pip_size
   );
}

bool Alligator2OnBuy() {
  // if (VerboseTrace) Print("AlligatorOnBuy(): ", NormalizeDouble(Alligator[2] - Alligator[1], pip_precision), ",", NormalizeDouble(Alligator[1] - Alligator[0], pip_precision), ",", NormalizeDouble(Alligator[2] - Alligator[0], pip_precision), " >= ", NormalizeDouble(Alligator_Ratio * pip_size, pip_precision));
   return (
      Alligator2[2] - Alligator2[1] >= Alligator2_OpenLevel * pip_size &&
      Alligator2[1] - Alligator2[0] >= Alligator2_OpenLevel * pip_size &&
      Alligator2[2] - Alligator2[0] >= Alligator2_OpenLevel * pip_size
   );
}

bool Alligator2OnSell() {
  // if (VerboseTrace) Print("AlligatorOnSell(): ", NormalizeDouble(Alligator[1] - Alligator[2], pip_precision), ",", NormalizeDouble(Alligator[0] - Alligator[1], pip_precision), ",", NormalizeDouble(Alligator[0] - Alligator[2], pip_precision), " >= ", NormalizeDouble(Alligator_Ratio * pip_size, pip_precision));
   return (
      Alligator2[1] - Alligator2[2] >= Alligator2_OpenLevel * pip_size &&
      Alligator2[0] - Alligator2[1] >= Alligator2_OpenLevel * pip_size &&
      Alligator2[0] - Alligator2[2] >= Alligator2_OpenLevel * pip_size
   );
}

bool FractalsOnBuy() {
  return (Fractals_lower > 0.0);
}

bool FractalsOnSell() {
  return (Fractals_upper > 0.0);
}

bool DeMarkerOnSell() {
  // if (VerboseTrace) { Print("DeMarkerOnSell(): ", LowestValue(DeMarker), " < ", (0.5 - DeMarker_Filter)); }
  return (DeMarker < (0.5 - DeMarker_Filter));
}

bool DeMarkerOnBuy() {
  // if (VerboseTrace) { Print("DeMarkerOnBuy(): ", LowestValue(DeMarker), " > ", (0.5 + DeMarker_Filter)); }
  return (DeMarker > (0.5 + DeMarker_Filter));
}

bool WPROnSell() {
  return (WPR <= (0.5 - WPR_Filter));
}

bool WPROnBuy() {
  return (WPR >= (0.5 + WPR_Filter));
}

double LowestValue(double& arr[]) {
  return (arr[ArrayMinimum(arr)]);
}

double HighestValue(double& arr[]) {
   return (arr[ArrayMaximum(arr)]);
}

string GetArrayValues(double& arr[], string sep = ", ") {
  string result = "";
  for (int i = 0; i < ArraySize(arr); i++) {
    result = result + i + ":" + arr[i] + sep;
  }
  return result;
}

int ExecuteOrder(int cmd, double volume, int order_type, string order_comment = "", bool retry = TRUE) {
   bool result = FALSE;
   string err;
   int order_ticket;
   // int min_stop_level;
   double max_change = 1;
   double order_price = GetOpenPrice(cmd);
   volume = NormalizeLots(volume);

   // Check if bar time has been changed since last time.
   /*
   if (last_order_time == iTime(NULL, PERIOD_M1, 0) && EADelayBetweenTrades > 0) {
     // FIXME
     return (FALSE);
   }*/

   // Check the limits.
   if (GetTotalOrders() >= GetMaxOrders()) {
     err = __FUNCTION__ + "(): Maximum open and pending orders reached the limit (EAMaxOrders).";
     if (VerboseErrors && err != last_err) Print(last_err);
     last_err = err;
     return (FALSE);
   }
   if (GetTotalOrdersByType(order_type) >= GetMaxOrdersPerType()) {
     err = __FUNCTION__ + "(): Maximum open and pending orders per type reached the limit (EAMaxOrdersPerType).";
     if (VerboseErrors && err != last_err) Print(last_err);
     last_err = err;
     return (FALSE);
   }
   /* else if (EAMaxOrders == 0 && GetTotalOrders() >= GetMaxOrdersAuto()) {
     err = "Error in ExecuteOrder(): Maximum open and pending orders reached the auto-limit (EAMaxOrders).";
     if (VerboseErrors && err != last_err) Print(last_err + "Auto-Limit: " + GetMaxOrdersAuto());
     last_err = err;
     return (FALSE);
   }*/
   if (!CheckFreeMargin(cmd, volume)) {
     last_err = __FUNCTION__ + "(): No money to open more orders.";
     if (PrintLogOnChart) Comment(last_err);
     if (VerboseErrors) Print(last_err);
     return (FALSE);
   }
   if (!CheckMinPipGap(order_type)) {
     last_err = __FUNCTION__ + "(): Not executing order, because of the minimum gap.";
     if (VerboseTrace) Print(last_err);
     return (FALSE);
   }

   // Calculate take profit and stop loss.
   RefreshRates();
   if (VerboseDebug) Print(__FUNCTION__ + "(): " + GetMarketTextDetails()); // Print current market information before placing the order.
   double stoploss = 0, takeprofit = 0;
   if (EAStopLoss > 0.0) stoploss = GetClosePrice(cmd) - (EAStopLoss + TrailingStop) * pip_size * OpTypeValue(cmd);
   else stoploss = GetTrailingStop(cmd, 0, order_type);
   if (EATakeProfit > 0.0) takeprofit = order_price + (EATakeProfit + TrailingProfit) * pip_size * OpTypeValue(cmd);
   else takeprofit = GetTrailingProfit(cmd, 0, order_type);

   order_ticket = OrderSend(Symbol(), cmd, volume, order_price, max_order_slippage, stoploss, takeprofit, order_comment, MagicNumber + order_type, 0, If(cmd == OP_BUY, ColorBuy, ColorSell));
   if (order_ticket >= 0) {
      if (!OrderSelect(order_ticket, SELECT_BY_TICKET) && VerboseErrors) {
        Print(__FUNCTION__ + "(): OrderSelect() error = ", ErrorDescription(GetLastError()));
        if (retry) TaskAddOrderOpen(cmd, volume, order_type, order_comment); // Will re-try again.
        return (FALSE);
      }

      result = TRUE;
      last_order_time = iTime(NULL, PERIOD_M1, 0); // Set last execution bar time.
      last_trail_update = 0; // Set to 0, so trailing stops can be updated faster.
      order_price = OrderOpenPrice();
      if (VerboseInfo) OrderPrint();
      if (VerboseDebug) { Print(__FUNCTION__ + "(): " + GetOrderTextDetails() + GetAccountTextDetails()); }
      if (SoundAlert) PlaySound(SoundFileAtOpen);
      if (SendEmail) EASendEmail();

      /*
      if ((EATakeProfit * pip_size > GetMinStopLevel() || EATakeProfit == 0.0) &&
         (EAStopLoss * pip_size > GetMinStopLevel() || EAStopLoss == 0.0)) {
            result = OrderModify(order_ticket, order_price, stoploss, takeprofit, 0, Red);
            if (!result && VerboseErrors) {
              Print("Error in ExecuteOrder(): OrderModify() error = ", ErrorDescription(GetLastError()));
              if (VerboseDebug) Print("ExecuteOrder(): OrderModify(", order_ticket, ", ", order_price, ", ", stoploss, ", ", takeprofit, ", ", 0, ", ", Red, ")");
            }
         }
      */
      // curr_bar_time = iTime(NULL, PERIOD_M1, 0);
   } else {
     result = FALSE;
     err_code = GetLastError();
     if (VerboseErrors) Print(__FUNCTION__, "(): OrderSend(): error = ", ErrorDescription(err_code));
     if (VerboseDebug) {
       Print("ExecuteOrder(): OrderSend(", Symbol(), ", ",  _OrderType_str(cmd), ", ", volume, ", ", order_price, ", ", max_order_slippage, ", ", stoploss, ", ", takeprofit, ", ", order_comment, ", ", MagicNumber + order_type, ", 0, ", If(cmd == OP_BUY, ColorBuy, ColorSell), "); ", GetAccountTextDetails());
     }
     // if (err_code != 136 /* OFF_QUOTES */) break;
     if (retry) TaskAddOrderOpen(cmd, volume, order_type, order_comment); // Will re-try again.
   } // end-if: order_ticket

/*
   TriesLeft--;
   if (TriesLeft > 0 && VerboseDebug) {
     Print("Price off-quote, will re-try to open the order.");
   }

   if (cmd == OP_BUY) new_price = Ask; else new_price = Bid;

   if (NormalizeDouble(MathAbs((new_price - order_price) / pip_size), 0) > max_change) {
     if (VerboseDebug) {
       Print("Price changed, not executing order: ", cmd);
     }
     break;
   }
   order_price = new_price;

   volume = NormalizeDouble(volume / 2.0, volume_precision);
   if (volume < market_minlot) volume = market_minlot;
   */
   return (result);
}

// Close order by type of strategy used. See: ENUM_STRATEGY_TYPE.
int CloseOrdersByType(int order_type) {
   int orders_total, order_failed;
   double profit_total;
   RefreshRates();
   for (int order = 0; order < OrdersTotal(); order++) {
      if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == MagicNumber+order_type && OrderSymbol() == Symbol()) {
           if (EACloseOrder(0, "closing on market change [type=" + order_type + "]")) {
              orders_total++;
              profit_total += GetOrderProfit();
           } else {
             order_failed++;
           }
         }
      } else {
        if (VerboseDebug)
          Print("Error in CloseOrdersByType(" + order_type + "): Order: " + order + "; Message: ", GetErrorText(err_code));
        // TaskAddCloseOrder(OrderTicket(), reason); // Add task to re-try.
      }
   }
   if (orders_total > 0 && VerboseInfo) {
     // FIXME: EnumToString(order_type) doesn't work here.
     Print("Closed ", orders_total, " orders (", order_type, ") on market change with total profit of : ", profit_total, " pips (", order_failed, " failed)");
   }
   return (orders_total);
}

// Check if order match has minimum gap in pips configured by EAMinPipGap parameter.
int CheckMinPipGap(int order_type) {
  int min_gap = TRUE, diff;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES)) {
       if (OrderMagicNumber() == MagicNumber+order_type && OrderSymbol() == Symbol()) {
         diff = MathAbs((OrderOpenPrice() - GetOpenPrice()) / pip_size);
         if (VerboseTrace) Print("Ticket: ", OrderTicket(), ", Order: ", OrderType(), ", Gap: ", diff);
         if (diff < EAMinPipGap) {
           return FALSE;
         }
       }
    } else {
      if (VerboseDebug)
        Print("Error in CheckMinPipGap(" + order_type + "): Order: " + order + "; Message: ", GetErrorText(err_code));
    }
  }
  return min_gap;
}
bool EACloseOrder(int ticket_no, string reason, bool retry = TRUE) {
  bool result;
  if (ticket_no > 0) result = OrderSelect(ticket_no, SELECT_BY_TICKET);
  else ticket_no = OrderTicket();
  result = OrderClose(ticket_no, OrderLots(), GetClosePrice(OrderType()), max_order_slippage, GetOrderColor());
  // if (VerboseTrace) Print("CloseOrder request. Reason: " + reason + "; Result=" + result + " @ " + TimeCurrent() + "(" + TimeToStr(TimeCurrent()) + "), ticket# " + ticket_no);
  if (result) {
    if (VerboseDebug) Print("EACloseOrder(): Closed order " + ticket_no + " with profit " + GetOrderProfit() + ", reason: " + reason + "; " + GetOrderTextDetails());
  } else {
    err_code = GetLastError();
    Print("Error in EACloseOrder(): Ticket: ", ticket_no, "; Error: ", GetErrorText(err_code));
    if (retry) TaskAddCloseOrder(ticket_no); // Add task to re-try.
  } // end-if: !result
  return result;
}

// Validate value for trailing stop.
bool ValidTrailingStop(double trail_stop, int cmd, bool existing = FALSE) {
  // OP_BUY: if(Bid-OrderOpenPrice()>Point*TrailingStop)      | Bid-Point*TrailingStop
  // OP_SELL: if((OrderOpenPrice()-Ask)>(Point*TrailingStop)) | Ask+Point*TrailingStop
  // trail_stop > OrderStopLoss()
  // trail_stop < OrderStopLoss()
  double delta = market_stoplevel * Point + GetMarketSpread(); // Delta price.
  double price = If(existing, OrderOpenPrice(), If(cmd == OP_BUY, Bid, Ask));
  bool valid = trail_stop == 0 || (cmd == OP_BUY  && price - trail_stop > delta) || (cmd == OP_SELL && trail_stop - price > delta);
  if (!valid && VerboseTrace) {
    if (cmd == OP_BUY)
      Print("ValidTrailingStop(OP_BUY): #" + If(existing, OrderTicket(), 0) + ": ", price, " - ", trail_stop, " = ", price - trail_stop, " > ", DoubleToStr(delta, pip_precision));
    if (cmd == OP_SELL)
      Print("ValidTrailingStop(OP_SELL): #" + If(existing, OrderTicket(), 0) + ": ", trail_stop, " - ", price, " = ", trail_stop - price, " > ", DoubleToStr(delta, pip_precision));
  }
  return valid;
}

// Validate value for profit take.
bool ValidProfitTake(double profit_take, int cmd, bool existing = FALSE) {
  //if (VerboseTrace && cmd ==  OP_BUY) Print("ValidProfitTake(OP_BUY): ", profit_take - Bid, " > ", NormalizeDouble(GetMinStopLevel(), pip_precision));
  //if (VerboseTrace && cmd ==  OP_SELL) Print("ValidProfitTake(OP_SELL): ", Ask - profit_take, " > ", NormalizeDouble(GetMinStopLevel(), pip_precision));
  //if (VerboseTrace) Print("ValidProfitTake(" + cmd + "): Delta: ", DoubleToStr(delta, pip_precision));
  double delta = market_stoplevel * Point + GetMarketSpread(); // Delta price.
  double price = If(existing, OrderOpenPrice(), If(cmd == OP_BUY, Bid, Ask));
  bool valid = profit_take == 0 || (cmd ==  OP_BUY && profit_take - price > delta) || (cmd == OP_SELL && price - profit_take  > delta);
  if (!valid && VerboseTrace) {
    if (cmd == OP_BUY)
      Print("ValidProfitTake(OP_BUY): #" + If(existing, OrderTicket(), 0) + ": ", profit_take, " - ", price, " = ", profit_take - price, " > ", DoubleToStr(delta, pip_precision));
    if (cmd == OP_SELL)
      Print("ValidProfitTake(OP_SELL): #" + If(existing, OrderTicket(), 0) + ": ", price, " - ", profit_take, " = ", price - profit_take, " > ", DoubleToStr(delta, pip_precision));
  }
  return valid;
}

void UpdateTrailingStops() {
   bool result; // Check result of executed orders.
   double new_trailing_stop, new_profit_take;
   int order_type;
   // double order_stop_loss;
   // double order_trail_stop_loss;
   // double order_take_profit;
   // double order_curr_profit; // The difference between current market price and our open price (in pips).
   // double stoploss_pips; // How many pips are to stoploss limit (200 s/l = -0.02 pips).
   // double ma_trailing_stop;
   // int curr_trail;
   // double order_curr_profit; // extra variable defined
   // if order selected...
   // ( OrderProfit() - OrderCommission() ) / OrderLots() / MarketInfo( OrderSymbol(), MODE_TICKVALUE ) // In pips.

   // Check if bar time has been changed since last time.
   int bar_time = iTime(NULL, PERIOD_M1, 0);
   if (bar_time == last_trail_update) {
     return;
   } else {
     last_trail_update = bar_time;
   }

   for (int i = 0; i < OrdersTotal(); i++) {
     if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
        order_type = OrderMagicNumber() - MagicNumber;
        // order_stop_loss = NormalizeDouble(If(OpTypeValue(OrderType()) > 0 || OrderStopLoss() != 0.0, OrderStopLoss(), 999999), pip_precision);

        // FIXME
        if (EAMinimalizeLosses && GetOrderProfit() > GetMinStopLevel()) {
          if ((OrderType() == OP_BUY && OrderStopLoss() < Bid) ||
             (OrderType() == OP_SELL && OrderStopLoss() > Ask)) {
            result = OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - OrderCommission() * Point, OrderTakeProfit(), 0, GetOrderColor());
            if (!result && err_code > 1) Print("Error in UpdateTrailingStops(): OrderModify(): EAMinimalizeLosses: ", ErrorDescription(err_code));
            if (VerboseTrace) Print(__FUNCTION__ + "(): EAMinimalizeLosses: ", GetOrderTextDetails());
          }
        }

        new_trailing_stop = GetTrailingStop(OrderType(), OrderStopLoss(), order_type, TRUE);
        new_profit_take = GetTrailingProfit(OrderType(), OrderTakeProfit(), order_type, TRUE);
        if (new_trailing_stop != OrderStopLoss() || new_profit_take != OrderTakeProfit()) { // Perform update on change only.
           result = OrderModify(OrderTicket(), OrderOpenPrice(), new_trailing_stop, new_profit_take, 0, GetOrderColor());
           if (!result) {
             err_code = GetLastError();
             if (VerboseErrors && err_code > 1) {
               Print("OrderModify: ", ErrorDescription(err_code));
               if (VerboseDebug)
                 Print(__FUNCTION__ + "(): Error: OrderModify(", OrderTicket(), ", ", OrderOpenPrice(), ", ", new_trailing_stop, ", ", new_profit_take, ", ", 0, ", ", GetOrderColor(), ")");
             }
           } else {
             // if (VerboseTrace) Print("UpdateTrailingStops(): OrderModify(): ", GetOrderTextDetails());
           }
        }

     }
  }
}

// Get new trailing stop.
// Note: Suggested methods: 1 & 4, 5.
// Params:
//   bool existing: TRUE if the calculation is for particular existing order
double GetTrailingStop(int cmd, double previous, int order_type = -1, bool existing = FALSE) {
   double trail_stop = 0;
   double delta = market_stoplevel * Point + GetMarketSpread(); // Delta price.
   double default_trail = If(cmd == OP_BUY, Bid - TrailingStop * pip_size - delta, Ask + TrailingStop * pip_size + delta);
   int method = GetTrailingMethod(order_type, -1);
   switch (method) {
     case 0: // None
       trail_stop = previous;
       break;
     case 1: // Dynamic fixed.
       trail_stop = default_trail;
       break;
     case 2: // iMA Small (Current) - trailing stop
       trail_stop = MA_Fast[0] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 3: // iMA Small (Previous) - trailing stop
       trail_stop = MA_Fast[1] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 4: // iMA Small (Far) - trailing stop. Optimize together with: MA_Shift_Far.
       trail_stop = MA_Fast[2] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 5: // iMA Medium (Current) - trailing stop
       trail_stop = MA_Medium[0] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 6: // iMA Medium (Previous) - trailing stop
       trail_stop = MA_Medium[1] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 7: // iMA Medium (Far) - trailing stop. Optimize together with: MA_Shift_Far.
       trail_stop = MA_Medium[2] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 8: // iMA Slow (Current) - trailing stop
       trail_stop = MA_Slow[0] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 9: // iMA Slow (Previous) - trailing stop
       trail_stop = MA_Slow[1] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     case 10: // iMA Slow (Far) - trailing stop. Optimize together with: MA_Shift_Far.
       trail_stop = MA_Slow[2] - TrailingStop * OpTypeValue(cmd) * pip_size - delta;
       break;
     default:
       if (VerboseDebug) Print("Error in GetTrailingStop(): Unknown trailing stop method: ", method);
   }

   if (!ValidTrailingStop(trail_stop, cmd, existing)) {
     if (previous == 0) previous = default_trail;
     if (VerboseTrace)
       Print(__FUNCTION__ + "(): Error: method = " + method + ", ticket = #" + If(existing, OrderTicket(), 0) + ": Invalid Trailing Stop: ", trail_stop, "; Previous: ", previous, "; ", GetOrderTextDetails(), "; delta: ", DoubleToStr(delta, pip_precision));
     // If value is invalid, fallback to standard one.
     //trail_stop = default_trail;
   }

   if (TrailingStopOneWay && method > 0) { // If TRUE, move trailing stop only one direction.
     if (previous == 0) previous = default_trail;
     if (cmd == OP_SELL)     trail_stop = If(trail_stop < previous, trail_stop, previous);
     else if (cmd == OP_BUY) trail_stop = If(trail_stop > previous, trail_stop, previous);
   }

   // if (VerboseTrace && trail_stop != OrderStopLoss()) Print("GetTrailingStop(): New Trailing Stop: ", trail_stop, "; Previous: ", previous, "; ", GetOrderTextDetails());
   if (VerboseDebug && IsVisualMode()) ShowLine("trail_stop_" + OrderTicket(), trail_stop, Orange);
   return trail_stop;
}


// Get new trailing profit take.
// Note: Suggested methods: 1 & 4.
// Params:
//   bool existing: TRUE if the calculation is for particular existing order
double GetTrailingProfit(int cmd, double previous, int order_type = -1, bool existing = FALSE) {
   double profit_take = 0;
   double delta = market_stoplevel * Point + GetMarketSpread(); // Delta price.
   double default_trail = If(cmd == OP_BUY, Bid + TrailingProfit * pip_size + delta, Ask - TrailingProfit * pip_size - delta);
   int method = GetTrailingMethod(order_type, 1);
   switch (method) {
     case 0: // None
       profit_take = previous;
       break;
     case 1: // Dynamic fixed.
       profit_take = default_trail;
       break;
     case 2: // iMA Small (Current) + trailing profit
       profit_take = MA_Fast[0] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 3: // iMA Small (Previous) + trailing profit.
       profit_take = MA_Fast[1] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 4: // iMA Small (Far) + trailing profit. Optimize together with: MA_Shift_Far.
       profit_take = MA_Fast[2] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 5: // iMA Medium (Current) + trailing profit
       profit_take = MA_Medium[0] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 6: // iMA Medium (Previous) + trailing profit
       profit_take = MA_Medium[1] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 7: // iMA Medium (Far) + trailing profit. Optimize together with: MA_Shift_Far.
       profit_take = MA_Medium[2] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 8: // iMA Slow (Current) + trailing profit
       profit_take = MA_Slow[0] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 9: // iMA Slow (Previous) + trailing profit
       profit_take = MA_Slow[1] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     case 10: // iMA Slow (Far) + trailing profit. Optimize together with: MA_Shift_Far.
       profit_take = MA_Slow[2] + TrailingProfit * OpTypeValue(cmd) * pip_size + delta;
       break;
     default:
       if (VerboseDebug) Print(__FUNCTION__ + "(): Error: Unknown trailing stop method: ", method);
   }

   if (!ValidProfitTake(profit_take, cmd)) {
     if (previous == 0) previous = default_trail;
     if (VerboseTrace)
       Print(__FUNCTION__ + "(): Error: method = " + method + ", ticket = #" + If(existing, OrderTicket(), 0) + ": Invalid Profit Take: ", profit_take, "; Previous: ", previous, "; ", GetOrderTextDetails(), "; delta: ", DoubleToStr(delta, pip_precision));
     // If value is invalid, fallback to standard one.
     //profit_take = default_trail;
   }

   if (TrailingProfitOneWay && method > 0) { // If TRUE, move profit take only one direction.
     if (previous == 0 && method > 0) previous = default_trail;
     if (cmd == OP_SELL)     profit_take = If(profit_take < previous, profit_take, previous);
     else if (cmd == OP_BUY) profit_take = If(profit_take > previous, profit_take, previous);
   }

   // if (VerboseTrace && profit_take != previous) Print("GetProfitStop(", method, "): New Profit Stop: ", profit_take, "; Old: ", previous, "; ", GetOrderTextDetails());
   if (VerboseDebug && IsVisualMode()) ShowLine("take_profit_" + OrderTicket(), profit_take, Gold);
   return profit_take;
}

// Get trailing method based on the strategy type.
int GetTrailingMethod(int order_type, int stop_or_profit) {
  int stop_method = 0, profit_method = 0;
  switch (order_type) {
    case MA_FAST_ON_BUY:
    case MA_FAST_ON_SELL:
    case MA_MEDIUM_ON_BUY:
    case MA_MEDIUM_ON_SELL:
    case MA_LARGE_ON_BUY:
    case MA_LARGE_ON_SELL:
      break;
    case MACD_ON_BUY:
    case MACD_ON_SELL:
      if (MACD_TrailingStopMethod > 0)   stop_method   = MACD_TrailingStopMethod;
      if (MACD_TrailingProfitMethod > 0) profit_method = MACD_TrailingProfitMethod;
      break;
    case FRACTALS_ON_BUY:
    case FRACTALS_ON_SELL:
      if (Fractals_TrailingStopMethod > 0)   stop_method   = Fractals_TrailingStopMethod;
      if (Fractals_TrailingProfitMethod > 0) profit_method = Fractals_TrailingProfitMethod;
      break;
    case ALLIGATOR1_ON_BUY:
    case ALLIGATOR1_ON_SELL:
      if (Alligator1_TrailingStopMethod > 0)   stop_method   = Alligator1_TrailingStopMethod;
      if (Alligator1_TrailingProfitMethod > 0) profit_method = Alligator1_TrailingProfitMethod;
      break;
    case ALLIGATOR2_ON_BUY:
    case ALLIGATOR2_ON_SELL:
      if (Alligator2_TrailingStopMethod > 0)   stop_method   = Alligator2_TrailingStopMethod;
      if (Alligator2_TrailingProfitMethod > 0) profit_method = Alligator2_TrailingProfitMethod;
      break;
    case DEMARKER_ON_BUY:
    case DEMARKER_ON_SELL:
      if (DeMarker_TrailingStopMethod > 0)   stop_method   = DeMarker_TrailingStopMethod;
      if (DeMarker_TrailingProfitMethod > 0) profit_method = DeMarker_TrailingProfitMethod;
      break;
    case WPR_ON_BUY:
    case WPR_ON_SELL:
      if (WPR_TrailingStopMethod > 0)   stop_method   = WPR_TrailingStopMethod;
      if (WPR_TrailingProfitMethod > 0) profit_method = WPR_TrailingProfitMethod;
      break;
    case BANDS_ON_BUY:
    case BANDS_ON_SELL:
      if (Bands_TrailingStopMethod > 0)   stop_method   = Bands_TrailingStopMethod;
      if (Bands_TrailingProfitMethod > 0) profit_method = Bands_TrailingProfitMethod;
      break;
    case RSI_ON_BUY:
    case RSI_ON_SELL:
      if (RSI_TrailingStopMethod > 0)   stop_method   = RSI_TrailingStopMethod;
      if (RSI_TrailingProfitMethod > 0) profit_method = RSI_TrailingProfitMethod;
      break;
    default:
      if (VerboseTrace) Print(__FUNCTION__ + "(): Unknown order type: " + order_type);
  }
  return If(stop_or_profit > 1, profit_method, stop_method);
}

void ShowLine(string name, double price, int colour = Yellow) {
    ObjectCreate(ChartID(), name, OBJ_HLINE, 0, Time[0], price, 0, 0);
    ObjectSet(name, OBJPROP_COLOR, colour);
    ObjectMove(name, 0, Time[0], price);
}

// Get current open price depending on the operation type.
// op_type: SELL = -1, BUY = 1
double GetOpenPrice(int op_type = 0) {
   if (op_type == 0) op_type = OrderType();
   return (If(OpTypeValue(op_type) > 0, Ask, Bid));
}

// Get current close price depending on the operation type.
// op_type: SELL = -1, BUY = 1
double GetClosePrice(int op_type = 0) {
   if (op_type == 0) op_type = OrderType();
   return (If(OpTypeValue(op_type) > 0, Bid, Ask));
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

// Return total number of orders (based on the EA magic number)
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

// Calculate open positions.
int CalculateOrderTypeRatio () {
   int buys=0, sells=0;
   for (int i=0; i<OrdersTotal(); i++) {
      if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == FALSE) break;
      if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
       }
   }
   if(buys>0) return(buys);
   else       return(-sells);
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
bool CheckOurMagicNumber(int magic_number = 0) {
  if (magic_number == 0) magic_number = OrderMagicNumber();
  return (magic_number >= MagicNumber && magic_number < MagicNumber + FINAL_STRATEGY_TYPE_ENTRY);
}

// Check if it is possible to trade.
bool TradeAllowed() {
  string err;
  // Don't place multiple orders for the same bar.
  /*
  if (last_order_time == iTime(NULL, PERIOD_M1, 0)) {
    err = StringConcatenate("Not trading at the moment, as we already placed order on: ", TimeToStr(last_order_time));
    if (VerboseTrace && err != last_err) Print(err);
    last_err = err;
    return (FALSE);
  }*/
  if (!ea_active) {
    err = "Error: EA is not active!";
    if (VerboseErrors && err != last_err) Print(err);
    last_err = err;
    return (FALSE);
  }
  if (!session_active) {
    err = "Error: Session is not active!";
    if (VerboseErrors && err != last_err) Print(err);
    last_err = err;
    return (FALSE);
  }
  if (Bars < 100) {
    err = "Bars less than 100, not trading...";
    if (VerboseTrace && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }
  if (IsTradeContextBusy()) {
    err = "Error: Trade context is temporary busy.";
    if (VerboseErrors && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }
  // Check if the EA is allowed to trade and trading context is not busy, otherwise returns false.
  // OrderSend(), OrderClose(), OrderCloseBy(), OrderModify(), OrderDelete() trading functions
  //   changing the state of a trading account can be called only if trading by Expert Advisors
  //   is allowed (the "Allow live trading" checkbox is enabled in the Expert Advisor or script properties).
  if (!IsTradeAllowed()) {
    err = "Trade is not allowed at the moment!";
    if (VerboseErrors && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }
  if (!IsConnected()) {
    err = "Error: Terminal is not connected!";
    if (VerboseErrors && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    Sleep(10000);
    return (FALSE);
  }
  if (IsStopped()) {
    err = "Error: Terminal is stopping!";
    if (VerboseErrors && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }
  if (!IsTesting() && !MarketInfo(Symbol(), MODE_TRADEALLOWED)) {
    err = "Trade is not allowed. Market is closed.";
    if (VerboseInfo && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }

  return (TRUE);
}

// Check if EA parameters are valid.
bool ValidSettings() {
  string err;
  if (EALotSize < 0.0) {
    err = "Error: LotSize is less than 0.";
    if (VerboseInfo) Print(err);
    if (PrintLogOnChart) Comment(err);
    return (FALSE);
  }
  return (TRUE);
}

bool CheckFreeMargin(int op_type, double size_of_lot) {
   bool margin_ok = TRUE;
   double margin = AccountFreeMarginCheck(Symbol(), op_type, size_of_lot);
   if (GetLastError() == 134 /* NOT_ENOUGH_MONEY */) margin_ok = FALSE;
   return (margin_ok);
}

double GetOrderProfit() {
  return OrderProfit() - OrderCommission();
}

double GetOrderColor() {
  return If(OpTypeValue(OrderType()) > 0, ColorBuy, ColorSell);
}

// Get minimal permissible StopLoss/TakeProfit value in points.
double GetMinStopLevel() {
  return market_stoplevel * Point;
}

// Current market spread value in pips.
//
// Note: Using Mode_SPREAD can return 20 on EURUSD (IBFX), but zero on some other pairs, so using Ask - Bid instead.
// See: http://forum.mql4.com/42285
double GetMarketSpread(bool in_points = FALSE) {
  // return MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - pip_precision);
  return If(in_points, (Ask - Bid) * MathPow(10, Digits), (Ask - Bid));
}

double NormalizeLots(double lots, bool ceiling = FALSE, string pair = "") {
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
double NormalizeLots2(double lots, string pair=""){
    // See: http://forum.mql4.com/47988
    if (pair == "") pair = Symbol();
    double  lotStep     = MarketInfo(pair, MODE_LOTSTEP),
            minLot      = MarketInfo(pair, MODE_MINLOT);
    lots            = MathRound(lots/lotStep) * lotStep;
    if (lots < minLot) lots = 0;    // or minLot
    return(lots);
}
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

// Calculate number of points per pip.
// To be used to replace Point for trade parameters calculations.
// See: http://forum.mql4.com/30672
// FIXME: Not foolproof, there are Symbols with 1 or 2 (gold) or other numbers of digits.
// FIXME: Probably broken, needs re-write.
double GetPointsPerPip() {
  int d = Digits;
  switch(d) {
    case 2:
    case 4:
      d = Point;
      break;
    case 3:
    case 5:
      if (Point > 0) d = Point*10;
      else d = 10;
      break;
    default: if (VerboseDebug) Print(__FUNCTION__ + "(): Unrecognised number of digits to calculate points per pip: ", d);
  }
  return d;
}

// Calculate number of order allowed given risk ratio.
// Note: Optimal minimum should be 5, otherwise trading with this kind of EA doesn't make any sense.
int GetMaxOrdersAuto() {
  double free     = AccountFreeMargin();
  double leverage = AccountLeverage();
  double one_lot  = MathMin(MarketInfo(Symbol(), MODE_MARGINREQUIRED), 10); // Price of 1 lot (minimum 10, to make sure we won't divide by zero).
  double margin_risk = 0.5; // Percent of free margin to use (50%).
  return MathMax((free * margin_risk / one_lot * (100 / leverage) / GetLotSize()) * GetRiskRatio(), 5);
}

// Calculate number of maximum of orders allowed to open.
int GetMaxOrders() {
  return If(EAMaxOrders > 0, EAMaxOrders, GetMaxOrdersAuto());
}

// Calculate number of maximum of orders allowed to open per type.
int GetMaxOrdersPerType() {
  return If(EAMaxOrdersPerType > 0, EAMaxOrdersPerType, MathMax(MathFloor(GetMaxOrders() / FINAL_STRATEGY_TYPE_ENTRY), 1));
}

// Calculate size of the lot based on the free margin and account leverage automatically.
double GetAutoLotSize() {
  double free      = AccountFreeMargin();
  double leverage  = AccountLeverage();
  double margin_risk = 0.01; // Percent of free margin to use per order (1%).
  double avail_lots = free / market_marginrequired * (100 / leverage);
  return MathMin(MathMax(avail_lots * market_minlot * margin_risk * GetRiskRatio(), market_minlot), market_maxlot);
}

// Return current lot size to trade.
double GetLotSize() {
  double min_lot  = MarketInfo(Symbol(), MODE_MINLOT);
  return If(EALotSize == 0, GetAutoLotSize(), MathMax(EALotSize, min_lot));
}

// Calculate auto risk ratio value;
double GetAutoRiskRatio() {
  double equity = AccountEquity();
  double balance = AccountBalance();
  return MathMin(equity / balance, 1.0);
}

// Return risk ratio value;
double GetRiskRatio() {
  return If(RiskRatio == 0, GetAutoRiskRatio(), RiskRatio);
}

string GetDailyReport() {
  return GetAccountTextDetails() + GetOrdersStats();
}

/* BEGIN: DISPLAYING FUNCTIONS */

void DisplayInfoOnChart() {
  // Prepare text for Stop Out.
  string stop_out_level = "Stop Out: " + AccountStopoutLevel();
  if (AccountStopoutMode() == 0) stop_out_level += "%"; else stop_out_level += AccountCurrency();
  // Prepare text to display max orders.
  string text_max_orders = "Max orders: " + GetMaxOrders() + " (Per type: " + GetMaxOrdersPerType() + ")";
  // Print actual info.
  Comment(""
   + "------------------------------------------------\n"
   + "ACCOUNT INFORMATION:\n"
   + "Server Time: " + TimeToStr(TimeCurrent(), TIME_SECONDS) + "\n"
   + "Acc Number: " + AccountNumber(), "; Acc Name: " + AccountName() + "; Broker: " + AccountCompany() + "\n"
   + "Equity: " + DoubleToStr(AccountEquity(), 0) + AccountCurrency() + "; Balance: " + DoubleToStr(AccountBalance(), 0) + AccountCurrency() + "; Leverage: 1:" + DoubleToStr(AccountLeverage(), 0)  + "\n"
   + "Used Margin: " + DoubleToStr(AccountMargin(), 0)  + AccountCurrency() + "; Free: " + DoubleToStr(AccountFreeMargin(), 0) + AccountCurrency() + "; " + stop_out_level + "\n"
   + "Lot size: " + DoubleToStr(GetLotSize(), volume_precision) + "; " + text_max_orders + "; Risk ratio: " + DoubleToStr(GetRiskRatio(), 1) + "\n"
   + GetOrdersStats(TRUE) + "\n"
   + "Last error: " + last_err + "\n"
   + "------------------------------------------------\n"
   + "MARKET INFORMATION:\n"
   + "Spread: " + GetMarketSpread(TRUE) + "\n"
   // + "Mini lot: " + MarketInfo(Symbol(), MODE_MINLOT) + "\n"
   + "------------------------------------------------\n"
  );
  WindowRedraw(); // Redraws the current chart forcedly.
}

void EASendEmail() {
  string mail_title = "Trading Info (EA 31337)";
  SendMail(mail_title, StringConcatenate("Trade Information\nCurrency Pair: ", StringSubstr(Symbol(), 0, 6),
    "\nTime: ", TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS),
    "\nOrder Type: ", _OrderType_str(OrderType()),
    "\nPrice: ", DoubleToStr(OrderOpenPrice(), Digits),
    "\nLot size: ", DoubleToStr(OrderLots(), volume_precision),
    "\nEvent: Trade Opened",
    "\n\nCurrent Balance: ", DoubleToStr(AccountBalance(), 2), " ", AccountCurrency(),
    "\nCurrent Equity: ", DoubleToStr(AccountEquity(), 2), " ", AccountCurrency()));
}

string GetOrderTextDetails() {
   return StringConcatenate("Order Details: ",
      "Ticket:", OrderTicket(), "; ",
      "Time: ", TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS), "; ",
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

// Get order statistics in percentage for each strategy.
string GetOrdersStats(bool nl = FALSE) {
  // Prepare text for Total Orders.
  string total_orders_text = "Open Orders: " + total_orders + " [" + DoubleToStr(CalculateOpenLots(), 2) + " lots]";
  total_orders_text += " (other: " + GetTotalOrders(FALSE) + ")";
  total_orders_text += "; ratio: " + CalculateOrderTypeRatio();
  // Prepare data about open orders per strategy type.
  string open_orders_per_type = "Orders Per Type: ";
  int ma_orders = open_orders[MA_FAST_ON_BUY] + open_orders[MA_FAST_ON_SELL] + open_orders[MA_MEDIUM_ON_BUY] + open_orders[MA_MEDIUM_ON_SELL] + open_orders[MA_LARGE_ON_BUY] + open_orders[MA_LARGE_ON_SELL];
  int macd_orders = open_orders[MACD_ON_BUY] + open_orders[MACD_ON_SELL];
  int fractals_orders = open_orders[FRACTALS_ON_BUY] + open_orders[FRACTALS_ON_SELL];
  int demarker_orders = open_orders[DEMARKER_ON_BUY] + open_orders[DEMARKER_ON_SELL];
  int iwpr_orders = open_orders[WPR_ON_BUY] + open_orders[WPR_ON_SELL];
  int alligator1_orders = open_orders[ALLIGATOR1_ON_BUY] + open_orders[ALLIGATOR2_ON_SELL];
  int alligator2_orders = open_orders[ALLIGATOR1_ON_BUY] + open_orders[ALLIGATOR2_ON_SELL];
  int bands_orders = open_orders[BANDS_ON_BUY] + open_orders[BANDS_ON_SELL];
  int rsi_orders = open_orders[RSI_ON_BUY] + open_orders[RSI_ON_SELL];
  string orders_per_type = "Stats: ";
  if (total_orders > 0) {
     if (MA_Enabled && ma_orders > 0) orders_per_type += "MA: " + MathFloor(100 / total_orders * ma_orders) + "%, ";
     if (MACD_Enabled && macd_orders > 0) orders_per_type += "MACD: " + MathFloor(100 / total_orders * macd_orders) + "%, ";
     if (Fractals_Enabled && fractals_orders > 0) orders_per_type += "Fractals: " + MathFloor(100 / total_orders * fractals_orders) + "%, ";
     if (DeMarker_Enabled && demarker_orders > 0) orders_per_type += "DeMarker: " + MathFloor(100 / total_orders * demarker_orders) + "%\n";
     if (WPR_Enabled && iwpr_orders > 0) orders_per_type += "WPR: " + MathFloor(100 / total_orders * iwpr_orders) + "%, ";
     if (Alligator1_Enabled && alligator1_orders > 0) orders_per_type += "Alligator1: " + MathFloor(100 / total_orders * alligator1_orders) + "%, ";
     if (Alligator2_Enabled && alligator2_orders > 0) orders_per_type += "Alligator2: " + MathFloor(100 / total_orders * alligator2_orders) + "%, ";
     if (Bands_Enabled && bands_orders > 0) orders_per_type += "Bands: " + MathFloor(100 / total_orders * bands_orders) + "%, ";
     if (RSI_Enabled && rsi_orders > 0) orders_per_type += "RSI: " + MathFloor(100 / total_orders * rsi_orders) + "%, ";
  } else {
    orders_per_type += "No orders open yet.";
  }
  return orders_per_type + IfTxt(nl, "\n", "") + total_orders_text;
}
string GetAccountTextDetails() {
   return StringConcatenate("Account Details: ",
      "Time: ", TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS), "; ",
      "Account Balance: ", DoubleToStr(AccountBalance(), 2), " ", AccountCurrency(), "; ",
      "Account Equity: ", DoubleToStr(AccountEquity(), 2), " ", AccountCurrency(), "; ",
      "Free Margin: ", DoubleToStr(AccountFreeMargin(), 2), " ", AccountCurrency(), "; ",
      "No of Orders: ", GetTotalOrders(), " (BUY/SELL ratio: ", CalculateOrderTypeRatio(), "); ",
      "Risk Ratio: ", DoubleToStr(GetRiskRatio(), 1)
   );
}

string GetMarketTextDetails() {
   return StringConcatenate("MarketInfo: ",
     "Symbol: ", Symbol(), "; ",
     "Ask: ", DoubleToStr(Ask, Digits), "; ",
     "Bid: ", DoubleToStr(Bid, Digits), "; ",
     "Spread: ", MarketInfo(Symbol(), MODE_SPREAD), "; "
   );
}

// Get summary text.
string GetSummaryText() {
  return GetAccountTextDetails();
}

/* END: DISPLAYING FUNCTIONS */

/* BEGIN: CONVERTING FUNCTIONS */

// Returns OrderType as a text.
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

/* BEGIN: ACTION FUNCTIONS */

// Execute action to close most profitable order.
bool ActionCloseMostProfitableOrder(){
  int selected_ticket = 0;
  double ticket_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES))
     if (OrderSymbol() == Symbol() && CheckOurMagicNumber()) {
       if (GetOrderProfit() > ticket_profit) {
         selected_ticket = OrderTicket();
         ticket_profit = GetOrderProfit();
       }
     }
  }

  if (selected_ticket > 0) {
    return TaskAddCloseOrder(selected_ticket, ACTION_CLOSE_ORDER_LOSS);
  } else if (VerboseDebug) {
    Print("ActionCloseMostProfitableOrder(): Can't find any profitable order as requested.");
  }
  return (FALSE);
}

// Execute action to close most unprofitable order.
bool ActionCloseMostUnprofitableOrder(){
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
    return TaskAddCloseOrder(selected_ticket, ACTION_CLOSE_ORDER_PROFIT);
  } else if (VerboseDebug) {
    Print("ActionCloseMostUnprofitableOrder(): Can't find any unprofitable order as requested.");
  }
  return (FALSE);
}

// Execute action to close all profitable orders.
bool ActionCloseAllProfitableOrders(){
  int selected_orders;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = GetOrderProfit();
       if (ticket_profit > 0) {
         TaskAddCloseOrder(OrderTicket(), ACTION_CLOSE_ALL_ORDER_PROFIT);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0 && VerboseInfo) {
    Print("ActionCloseAllProfitableOrders(): Queued " + selected_orders + " orders to close with expected profit of " + total_profit + " pips.");
  }
  return (FALSE);
}

// Execute action to close all unprofitable orders.
bool ActionCloseAllUnprofitableOrders(){
  int selected_orders;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       ticket_profit = GetOrderProfit();
       if (ticket_profit < 0) {
         TaskAddCloseOrder(OrderTicket(), ACTION_CLOSE_ALL_ORDER_LOSS);
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0 && VerboseInfo) {
    Print("ActionCloseAllUnprofitableOrders(): Queued " + selected_orders + " orders to close with expected loss of " + total_profit + " pips.");
  }
  return (FALSE);
}

// Execute action to close all orders by specified type.
bool ActionCloseAllOrdersByType(int cmd){
  int selected_orders;
  double ticket_profit = 0, total_profit = 0;
  for (int order = 0; order < OrdersTotal(); order++) {
    if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && CheckOurMagicNumber())
       if (OrderType() == cmd) {
         TaskAddCloseOrder(OrderTicket(), If(cmd == OP_BUY, ACTION_CLOSE_ALL_ORDER_BUY, ACTION_CLOSE_ALL_ORDER_SELL));
         selected_orders++;
         total_profit += ticket_profit;
     }
  }

  if (selected_orders > 0 && VerboseInfo) {
    Print("ActionCloseAllOrdersByType(" + _OrderType_str(cmd) + "): Queued " + selected_orders + " orders to close with expected profit of " + total_profit + " pips.");
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
int ActionCloseAllOrders(bool only_ours = TRUE) {
   int processed = 0;
   int total = OrdersTotal();
   for (int order = 0; order < total; order++) {
      if (OrderSelect(order, SELECT_BY_POS, MODE_TRADES) && OrderSymbol() == Symbol() && OrderTicket() > 0) {
         if (only_ours && !CheckOurMagicNumber()) continue;
         TaskAddCloseOrder(OrderTicket(), ACTION_CLOSE_ALL_ORDERS); // Add task to re-try.
         processed++;
      } else {
        if (VerboseDebug)
         Print("Error in CloseAllOrders(): Order Pos: " + order + "; Message: ", GetErrorText(GetLastError()));
      }
   }

   if (processed > 0 && VerboseInfo) {
     Print("CloseAllOrders(): Queued " + processed + " orders out of " + total + " for closure.");
   }
   return (processed > 0);
}

// Execute action by id. See: EA_Conditions parameters.
// Note: Executing this can be potentially dangerous for the account if not used wisely.
bool ActionExecute(int action_id, string reason) {
  bool result = FALSE;
  if (VerboseDebug) Print("ExecuteAction(): Action id: " + action_id + "; reason: " + reason);
  switch (action_id) {
    case ACTION_NONE:
      result = TRUE;
      if (VerboseDebug) Print("ExecuteAction(): No action taken. Action call reason: " + reason);
      // Nothing.
      break;
    case ACTION_CLOSE_ORDER_PROFIT:
      result = ActionCloseMostProfitableOrder();
      break;
    case ACTION_CLOSE_ORDER_LOSS:
      result = ActionCloseMostUnprofitableOrder();
      break;
    case ACTION_CLOSE_ALL_ORDER_PROFIT:
      result = ActionCloseAllProfitableOrders();
      break;
    case ACTION_CLOSE_ALL_ORDER_LOSS:
      result = ActionCloseAllUnprofitableOrders();
      break;
    case ACTION_CLOSE_ALL_ORDER_BUY:
      result = ActionCloseAllOrdersByType(OP_BUY);
      break;
    case ACTION_CLOSE_ALL_ORDER_SELL:
      result = ActionCloseAllOrdersByType(OP_SELL);
      break;
    case ACTION_CLOSE_ALL_ORDERS:
      result = ActionCloseAllOrders();
      break;
      /*
    case ACTION_RISK_REDUCE:
      result = ActionRiskReduce();
      break;
    case ACTION_RISK_INCREASE:
      result = ActionRiskIncrease();
      break;
      */
    case ACTION_ORDER_STOPS_DECREASE:
      // result = TightenStops();
      break;
    case ACTION_ORDER_PROFIT_DECREASE:
      // result = TightenProfits();
      break;
    default:
      if (VerboseDebug) Print("Unknown action id: ", action_id);
  }
  TaskProcessList(TRUE); // Process task list immediately after action has been taken.
  if (VerboseInfo) Print(GetAccountTextDetails() + GetOrdersStats());
  return result;
}

/* END: ACTION FUNCTIONS */

/* BEGIN: TASK FUNCTIONS */

// Add new closing order task.
bool TaskAddOrderOpen(int cmd, int volume, int order_type, string order_comment) {
  int key = cmd+volume+order_type;
  int job_id = TaskFindEmptySlot(cmd+volume+order_type);
  if (job_id >= 0) {
    todo_queue[job_id][0] = key;
    todo_queue[job_id][1] = TASK_ORDER_OPEN;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = cmd;
    todo_queue[job_id][4] = volume;
    todo_queue[job_id][5] = order_type;
    todo_queue[job_id][6] = order_comment;
    // Print("TaskAddOrderOpen(): Added task (", job_id, ") for ticket: ", todo_queue[job_id][0], ", type: ", todo_queue[job_id][1], " (", todo_queue[job_id][3], ").");
    return TRUE;
  } else {
    return FALSE; // Job not allocated.
  }
}

// Add new close task by job id.
bool TaskAddCloseOrder(int ticket_no, int reason = 0) {
  int job_id = TaskFindEmptySlot(ticket_no);
  if (job_id >= 0) {
    todo_queue[job_id][0] = ticket_no;
    todo_queue[job_id][1] = TASK_ORDER_CLOSE;
    todo_queue[job_id][2] = MaxTries; // Set number of retries.
    todo_queue[job_id][3] = reason;
    // if (VerboseTrace) Print("TaskAddCloseOrder(): Allocated task (id: ", job_id, ") for ticket: ", todo_queue[job_id][0], ".");
    return TRUE;
  } else {
    if (VerboseTrace) Print("TaskAddCloseOrder(): Failed to allocate close task for ticket: " + ticket_no);
    return FALSE; // Job is not allocated.
  }
}

// Remove specific task.
bool TaskRemove(int job_id) {
  todo_queue[job_id][0] = 0;
  todo_queue[job_id][2] = 0;
  // if (VerboseTrace) Print("TaskRemove(): Task removed for id: " + job_id);
  return TRUE;
}

// Check if task for specific ticket already exists.
bool TaskExistByKey(int key) {
  for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
    if (todo_queue[job_id][0] == key) {
      // if (VerboseTrace) Print("TaskExistByKey(): Task already allocated for key: " + key);
      return (TRUE);
      break;
    }
  }
  return (FALSE);
}

// Find available slot id.
int TaskFindEmptySlot(int key) {
  int taken = 0;
  if (!TaskExistByKey(key)) {
    for (int job_id = 0; job_id < ArrayRange(todo_queue, 0); job_id++) {
      if (VerboseTrace) Print("TaskFindEmptySlot(): job_id = " + job_id + "; key: " + todo_queue[job_id][0]);
      if (todo_queue[job_id][0] <= 0) { // Find empty slot.
        // if (VerboseTrace) Print("TaskFindEmptySlot(): Found empty slot at: " + job_id);
        return job_id;
      } else taken++;
    }
    // If no empty slots, Otherwise increase size of array.
    int size = ArrayRange(todo_queue, 0);
    if (size < 1000) { // Set array hard limit.
      ArrayResize(todo_queue, size + 1);
      if (VerboseDebug) Print("TaskFindEmptySlot(): Couldn't allocate Task slot, re-sizing array. New size: ",  (size + 1), ", Old size: ", size);
      return size;
    }
    if (VerboseDebug) Print("TaskFindEmptySlot(): Couldn't allocate task slot, all are taken (" + taken + "). Size: " + size);
  }
  return -1;
}

// Run specific task.
bool TaskRun(int job_id) {
  bool result = FALSE;
  int key = todo_queue[job_id][0];
  int task_type = todo_queue[job_id][1];
  int retries = todo_queue[job_id][2];
  // if (VerboseTrace) Print("TaskRun(): Job id: " + job_id + "; Task type: " + task_type);

  switch (task_type) {
    case TASK_ORDER_OPEN:
       int cmd = todo_queue[job_id][3];
       double volume = todo_queue[job_id][4];
       int order_type = todo_queue[job_id][5];
       string order_comment = todo_queue[job_id][6];
       ExecuteOrder(cmd, volume, order_type, order_comment = "", FALSE);
      break;
    case TASK_ORDER_CLOSE:
        string reason = todo_queue[job_id][3];
        if (OrderSelect(key, SELECT_BY_TICKET)) {
          if (EACloseOrder(key, "TaskRun(): " + reason, FALSE))
            result = TaskRemove(job_id);
        } else {
          todo_queue[job_id][2]--; // Decrease number of retries by one.
        }

      break;
    default:
      if (VerboseDebug) Print("TaskRun(): Unknown task: ", task_type);
  };
  return result;
}

// Process task list.
bool TaskProcessList(bool force = FALSE) {
   int total_run, total_failed, total_removed = 0;
   int no_elem = 8;

   // Check if bar time has been changed since last time.
   int bar_time = iTime(NULL, PERIOD_M1, 0);
   if (bar_time == last_queue_process && !force) {
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
          if (todo_queue[job_id][2] <= 0) { // Remove task if maximum tries reached.
            if (TaskRemove(job_id)) {
              total_removed++;
            }
          }
        }
      }
   } // end: for
   if (VerboseDebug && total_run+total_failed > 0)
     Print("TaskProcessList(): Processed ", total_run+total_failed, " jobs (", total_run, " run, ", total_failed, " failed (", total_removed, " removed)).");
  return TRUE;
}

/* END: TASK FUNCTIONS */

/* BEGIN: DEBUG FUNCTIONS */

void DrawMA() {
   int Counter = 1;
   int shift=iBarShift(Symbol(), MA_Timeframe, TimeCurrent());
   while(Counter < Bars) {
      string itime = iTime(NULL, MA_Timeframe, Counter);

      // FIXME: The shift parameter (Counter, Counter-1) doesn't use the real values of MA_Fast, MA_Medium and MA_Slow including MA_Shift_Fast, etc.
      double MA_Fast_Curr = iMA(NULL, MA_Timeframe, MA_Period_Fast, 0, MA_Method, MA_Applied_Price, Counter); // Current Bar.
      double MA_Fast_Prev = iMA(NULL, MA_Timeframe, MA_Period_Fast, 0, MA_Method, MA_Applied_Price, Counter-1); // Previous Bar.
      ObjectCreate("MA_Fast" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Fast_Curr, iTime(NULL,0,Counter-1), MA_Fast_Prev);
      ObjectSet("MA_Fast" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Fast" + itime, OBJPROP_COLOR, Yellow);

      double MA_Medium_Curr = iMA(NULL, MA_Timeframe, MA_Period_Medium, 0, MA_Method, MA_Applied_Price, Counter); // Current Bar.
      double MA_Medium_Prev = iMA(NULL, MA_Timeframe, MA_Period_Medium, 0, MA_Method, MA_Applied_Price, Counter-1); // Previous Bar.
      ObjectCreate("MA_Medium" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Medium_Curr, iTime(NULL,0,Counter-1), MA_Medium_Prev);
      ObjectSet("MA_Medium" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Medium" + itime, OBJPROP_COLOR, Gold);

      double MA_Slow_Curr = iMA(NULL, MA_Timeframe, MA_Period_Slow, 0, MA_Method, MA_Applied_Price, Counter); // Current Bar.
      double MA_Slow_Prev = iMA(NULL, MA_Timeframe, MA_Period_Slow, 0, MA_Method, MA_Applied_Price, Counter-1); // Previous Bar.
      ObjectCreate("MA_Slow" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Slow_Curr, iTime(NULL,0,Counter-1), MA_Slow_Prev);
      ObjectSet("MA_Slow" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Slow" + itime, OBJPROP_COLOR, Orange);
      Counter++;
   }
}

/* END: DEBUG FUNCTIONS */

/* BEGIN: ERROR HANDLING FUNCTIONS */

// Error codes  defined in stderror.mqh.
// You can print the error description, you can use the ErrorDescription() function, defined in stdlib.mqh.
// Or use this function instead.
string GetErrorText(int code) {
   string text;

   switch (code) {
      case 0: text = "No error returned."; break;
      case 1: text = "No error returned, but the result is unknown."; break;
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
      case  136: text = "Off quotes."; break;
      case  137: text = "Broker is busy (never returned error)."; break;
      case  138: text = "Requote."; break;
      case  139: text = "Order is locked."; break;
      case  140: text = "Long positions only allowed."; break;
      case  141: text = "Too many requests."; break;
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

// Get text description based on the uninitialization reason code.
string getUninitReasonText(int reasonCode) {
   string text="";
   switch(reasonCode) {
      case REASON_ACCOUNT:
         text="Account was changed."; break;
      case REASON_CHARTCHANGE:
         text="Symbol or timeframe was changed."; break;
      case REASON_CHARTCLOSE:
         text="Chart was closed."; break;
      case REASON_PARAMETERS:
         text="Input-parameter was changed."; break;
      case REASON_RECOMPILE:
         text="Program "+__FILE__+" was recompiled."; break;
      case REASON_REMOVE:
         text="Program "+__FILE__+" was removed from chart."; break;
      case REASON_TEMPLATE:
         text="New template was applied to chart."; break;
      default:text="Unknown reason.";
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
   int    trades_total=HistoryTotal();
//---- initialize summaries
   InitializeSummaries(initial_deposit);
//----
   for(int i=0; i<trades_total; i++) {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) continue;
      int type=OrderType();
      //---- initial balance not considered
      if(i==0 && type==OP_BALANCE) continue;
      //---- calculate profit
      double profit=OrderProfit()+OrderCommission()+OrderSwap();
      balance+=profit;
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
      //---- loss trades
      if(profit<0) {
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
        }
      //---- profit trades (profit>=0)
      else
        {
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
      //----
      prevprofit=profit;
     }
//---- final drawdown check
   drawdown=maxpeak-minpeak;
   if(maxpeak != 0.0) {
      drawdownpercent=drawdown/maxpeak*100.0;
      if(RelDrawdownPercent<drawdownpercent) {
         RelDrawdownPercent=drawdownpercent;
         RelDrawdown=drawdown;
      }
   }
   if(MaxDrawdown<drawdown) {
    MaxDrawdown=drawdown;
    if(maxpeak!=0) MaxDrawdownPercent=MaxDrawdown/maxpeak*100.0;
    else MaxDrawdownPercent=100.0;
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
   if(GrossLoss>0.0) ProfitFactor=GrossProfit/GrossLoss;
//---- expected payoff
   if(ProfitTrades>0) avgprofit=GrossProfit/ProfitTrades;
   if(LossTrades>0)   avgloss  =GrossLoss/LossTrades;
   if(SummaryTrades>0)
     {
      profitkoef=1.0*ProfitTrades/SummaryTrades;
      losskoef=1.0*LossTrades/SummaryTrades;
      ExpectedPayoff=profitkoef*avgprofit-losskoef*avgloss;
     }
//---- absolute drawdown
   AbsoluteDrawdown=initial_deposit-MaxLoss;
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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateInitialDeposit()
  {
   double initial_deposit=AccountBalance();
//----
   for(int i=HistoryTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)) continue;
      int type=OrderType();
      //---- initial balance not considered
      if(i==0 && type==OP_BALANCE) break;
      if(type==OP_BUY || type==OP_SELL)
        {
         //---- calculate profit
         double profit=OrderProfit()+OrderCommission()+OrderSwap();
         //---- and decrease balance
         initial_deposit-=profit;
        }
      if(type==OP_BALANCE || type==OP_CREDIT)
         initial_deposit-=OrderProfit();
     }
//----
   return(initial_deposit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WriteReport(string report_name) {
   int handle = FileOpen(report_name,FILE_CSV|FILE_WRITE,'\t');
   if (handle<1) return;
//----
   FileWrite(handle,"Initial deposit           ",InitialDeposit);
   FileWrite(handle,"Total net profit          ",SummaryProfit);
   FileWrite(handle,"Gross profit              ",GrossProfit);
   FileWrite(handle,"Gross loss                ",GrossLoss);
   if(GrossLoss>0.0)
      FileWrite(handle,"Profit factor             ",ProfitFactor);
   FileWrite(handle,"Expected payoff           ",ExpectedPayoff);
   FileWrite(handle,"Absolute drawdown         ",AbsoluteDrawdown);
   FileWrite(handle,"Maximal drawdown          ",MaxDrawdown,StringConcatenate("(",MaxDrawdownPercent,"%)"));
   FileWrite(handle,"Relative drawdown         ",StringConcatenate(RelDrawdownPercent,"%"),StringConcatenate("(",RelDrawdown,")"));
   FileWrite(handle,"Trades total                 ",SummaryTrades);
   if(ShortTrades>0)
      FileWrite(handle,"Short positions(won %)    ",ShortTrades,StringConcatenate("(",100.0*WinShortTrades/ShortTrades,"%)"));
   if(LongTrades>0)
      FileWrite(handle,"Long positions(won %)     ",LongTrades,StringConcatenate("(",100.0*WinLongTrades/LongTrades,"%)"));
   if(ProfitTrades>0)
      FileWrite(handle,"Profit trades (% of total)",ProfitTrades,StringConcatenate("(",100.0*ProfitTrades/SummaryTrades,"%)"));
   if(LossTrades>0)
      FileWrite(handle,"Loss trades (% of total)  ",LossTrades,StringConcatenate("(",100.0*LossTrades/SummaryTrades,"%)"));
   FileWrite(handle,"Largest profit trade      ",MaxProfit);
   FileWrite(handle,"Largest loss trade        ",-MinProfit);
   if(ProfitTrades>0)
      FileWrite(handle,"Average profit trade      ",GrossProfit/ProfitTrades);
   if(LossTrades>0)
      FileWrite(handle,"Average loss trade        ",-GrossLoss/LossTrades);
   FileWrite(handle,"Average consecutive wins  ",AvgConWinners);
   FileWrite(handle,"Average consecutive losses",AvgConLosers);
   FileWrite(handle,"Maximum consecutive wins (profit in money)",ConProfitTrades1,StringConcatenate("(",ConProfit1,")"));
   FileWrite(handle,"Maximum consecutive losses (loss in money)",ConLossTrades1,StringConcatenate("(",-ConLoss1,")"));
   FileWrite(handle,"Maximal consecutive profit (count of wins)",ConProfit2,StringConcatenate("(",ConProfitTrades2,")"));
   FileWrite(handle,"Maximal consecutive loss (count of losses)",-ConLoss2,StringConcatenate("(",ConLossTrades2,")"));
//----
   FileClose(handle);
  }

/* END: SUMMARY REPORT */

//+------------------------------------------------------------------+
