//+------------------------------------------------------------------+
//|                                                  EA31337 v0.1    |
//+------------------------------------------------------------------+
#property description "EA31337 v0.1"
#property copyright   "kenorb"
//#property link        "http://www.example.com"

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
  ALLIGATOR_ON_BUY,
  ALLIGATOR_ON_SELL,
  BBANDS_ON_BUY,
  BBANDS_ON_SELL,
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
extern double EATrailingStop = 20;
extern int EATrailingStopMethod = 5; // TrailingStop method. Set 0 to disable. Range: 0-7. Suggested value: 1 or 4
extern bool EATrailingStopOneWay = TRUE; // Change trailing stop towards one direction only. Suggested value: TRUE
extern double EATrailingProfit = 20;
extern int EATrailingProfitMethod = 1; // Trailing Profit method. Set 0 to disable. Range: 0-7. Suggested value: 0 or 4.
extern bool EATrailingProfitOneWay = TRUE; // Change trailing profit take towards one direction only. Suggested value: TRUE

// extern double EAMinChangeOrders = 5; // Minimum change in pips between placed orders.
// extern double EADelayBetweenOrders = 0; // Minimum delay in seconds between placed orders. FIXME: Fix relative delay in backtesting.
extern bool EACloseOnMarketChange = FALSE; // Close orders on market change.
extern bool EAMinimalizeLosses = FALSE; // Set stop loss to zero, once the order is profitable.
extern int EAOrderPriceSlippage = 5; // Maximum price slippage for buy or sell orders.
extern int EAManualGMToffset = 0;

extern string __EA_Order_Parameters__ = "-- Profit/Loss settings (set 0 for auto) --";
extern double EALotSize = 0; // Default lot size. Set 0 for auto.
extern int EAMaxOrders = 0; // Maximum orders. Set 0 for auto.
extern int EAMaxOrdersPerType = 2; // Maximum orders per strategy type. Set 0 for unlimited.
extern double EATakeProfit = 0.0;
extern double EAStopLoss = 0.0;
extern double RiskRatio = 0; // Suggested value: 1.0. Do not change unless testing.

extern string ____MA_Parameters__ = "-- Settings for the Moving Average indicator --";
extern bool MA_Enabled = TRUE; // Enable MA-based strategy.
extern ENUM_TIMEFRAMES MA_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int MAAvgPeriodFast = 10; // Suggested value: 5
extern int MAAvgPeriodMedium = 25; // Suggested value: 25
extern int MAAvgPeriodSlow = 60; // Suggested value: 45
extern int MAShift = 1; // MA shift. Indicators line offset relate to the chart by timeframe.
extern int MAShiftFast = 2; // Index of the value taken from the indicator buffer (shift relative to the current bar the given amount of periods ago).
extern int MAShiftMedium = 2; // Index of the value taken from the indicator buffer (shift relative to the current bar the given amount of periods ago).
extern int MAShiftSlow = 2; // Index of the value taken from the indicator buffer (shift relative to the current bar the given amount of periods ago).
extern int MAShiftFar = 6; // Extra shift.
extern ENUM_MA_METHOD MAMethod = MODE_EMA; // MA method (See: ENUM_MA_METHOD). Range: 0-3
extern ENUM_APPLIED_PRICE MAAppliedPrice = PRICE_CLOSE; // MA applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.

extern string ____MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --";
extern bool MACD_Enabled = TRUE; // Enable MACD-based strategy.
extern ENUM_TIMEFRAMES MACD_Timeframe = PERIOD_M5; // Timeframe (0 means the current chart).
extern double MACD_OpenLevel  = 2;
//extern double MACD_CloseLevel = 2; // Set 0 to disable.
extern ENUM_APPLIED_PRICE MACD_Applied_Price = PRICE_HIGH; // MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int MACD_Shift = 1; // Past MACD value in number of bars. Shift relative to the current bar the given amount of periods ago. Suggested value: 1
extern int MACD_ShiftExtra = 2; // Extra MACD past value in number of bars.

extern string ____Fractals_Parameters__ = "-- Settings for the Fractals indicator --";
extern bool Fractals_Enabled = TRUE; // Enable Fractals-based strategy.
extern ENUM_TIMEFRAMES Fractals_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int Fractals_MaxPeriods = 6; // Suggested range: 2-5, Suggested value: 4

extern string ____Alligator_Parameters__ = "-- Settings for the Alligator indicator --";
extern bool Alligator_Enabled = TRUE; // Enable Alligator-based strategy.
extern ENUM_TIMEFRAMES Alligator_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern double Alligator_Ratio = 0.5; // Suggested to not change. Suggested range: 0.0-5.0

extern string ____DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --";
extern bool DeMarker_Enabled = TRUE; // Enable DeMarker-based strategy.
extern ENUM_TIMEFRAMES DeMarker_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int DeMarker_Period = 9; // Suggested range: 6-12. Suggested value: 9
extern int DeMarker_MaxPeriods = 2; // Suggested range: 2-5
extern double DeMarker_Shift = 0.2; // Valid range: 0.0-0.4. Suggested value: 0.2

extern string ____WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --";
extern bool WPR_Enabled = TRUE; // Enable WPR-based strategy.
extern ENUM_TIMEFRAMES WPR_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int WPR_period = 8;
extern int WPR_MaxPeriods = 6; // Suggested range: 2-10. Suggested value: 6
extern int WPR_Shift = 0; // Suggested range: 0.0-0.5. Suggested value: 0.4.

extern string ____RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --";
extern bool RSI_Enabled = FALSE; // Enable RSI-based strategy.
extern ENUM_TIMEFRAMES RSI_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int RSI_Period = 14; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE RSI_Applied_Price = PRICE_HIGH; // RSI applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double RSI_MaxPeriods = 3; // Maximum bar periods to calculate its value.

extern string ____BBands_Parameters__ = "-- Settings for the Bollinger Bands® indicator --";
extern bool BBands_Enabled = FALSE; // Enable BBands-based strategy.
extern ENUM_TIMEFRAMES BBands_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int BBands_Period = 20; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE BBands_Applied_Price = PRICE_HIGH; // Bands applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int BBands_Deviation = 2; // Number of standard deviations from the main line.
extern int BBands_MaxPeriods = 3; // Maximum bar periods to calculate its value.
extern int BBands_Shift = 0; // The indicator shift relative to the chart.

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
extern bool MaxTries = 5; // Number of maximum attempts to execute the order.
//extern int TrailingStopDelay = 0; // How often trailing stop should be updated (in seconds). FIXME: Fix relative delay in backtesting.
// extern int JobProcessDelay = 1; // How often job list should be processed (in seconds).

// ENUM_APPLIED_PRICE values:
//   0: PRICE_CLOSE (Close price)
//   1: PRICE_OPEN (Open price)
//   2: PRICE_HIGH (The maximum price for the period)
//   3: PRICE_LOW (The minimum price for the period)
//   4: PRICE_MEDIAN (Median price, (high + low)/2
//   5: PRICE_TYPICAL (Typical price, (high + low + close)/3
//   6: PRICE_WEIGHTED (Average price, (high + low + close + close)/4

// ENUM_MA_METHOD values:
//   0: MODE_SMA
//   1: MODE_EMA
//   2: MODE_SMMA
//   3: MODE_LWMA

// Market/session variables.
double PipSize;
double market_maxlot;
double market_minlot;
double market_lotstep;
double market_marginrequired;
double market_stoplevel;
int gmt_offset = 0;

// Account variables.
string account_type;
double acc_leverage;
int PipPrecision;
int volume_precision;

// State variables.
bool session_initiated;
bool session_active = FALSE;

// EA variables.
string EA_Name = "31337";
bool ea_active = FALSE;
double risk_ratio;
double order_slippage; // Price slippage.
int err_code; // Error code.
string last_err;
int last_trail_update = 0, last_order_time = 0, last_acc_check = 0;
int day_of_month; // Used to print daily reports.
int GMT_Offset;
int todo_queue[100][8], last_queue_process = 0;
int open_orders[FINAL_STRATEGY_TYPE_ENTRY], closed_orders[FINAL_STRATEGY_TYPE_ENTRY];
int total_orders = 0; // Number of total orders currently open.

// Indicator variables.
double MA_Fast[3], MA_Medium[3], MA_Slow[3];
double MACD[3], MACDSignal[3];
double RSI[];
double BBands_main[], BBands_upper[], BBands_lower[];
double Alligator[3];
double DeMarker[], WPR[];
double Fractals_lower, Fractals_upper;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

// Event Handling Function: Indicator initialization function.
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

   if (Digits < 4) {
      PipSize = 0.01;
      PipPrecision = 2;
   } else {
      PipSize = 0.0001;
      PipPrecision = 4;
   }
   if (PipPrecision == 0 && VerboseErrors) Print("Warning: The pip precision is 0!");
   if (TradeMicroLots) volume_precision = 2; else volume_precision = 1;

   // Initialize startup variables.
   session_initiated = FALSE;

   // market_maxlot = MarketInfo(Symbol(), MODE_MAXLOT);
   // market_minlot = MarketInfo(Symbol(), MODE_MINLOT);
   // market_lotstep = MarketInfo(Symbol(), MODE_LOTSTEP);
   // market_marginrequired = MarketInfo(Symbol(), MODE_MARGINREQUIRED) * market_lotstep;
   // market_stoplevel = MarketInfo(Symbol(), MODE_STOPLEVEL);

   if (market_marginrequired == 0) market_marginrequired = 10; // FIX for 'zero divide' bug when MODE_MARGINREQUIRED is zero
   order_slippage = EAOrderPriceSlippage * MathPow(10, Digits - PipPrecision);
   GMT_Offset = EAManualGMToffset;
   ArrayResize(DeMarker, DeMarker_MaxPeriods + 1);
   ArrayResize(WPR, WPR_MaxPeriods + 1);
   ArrayResize(RSI, RSI_MaxPeriods + 1);
   ArrayResize(BBands_main, BBands_MaxPeriods + 1);
   ArrayResize(BBands_upper, BBands_MaxPeriods + 1);
   ArrayResize(BBands_lower, BBands_MaxPeriods + 1);
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
      Print("MarketInfo: Symbol: ", Symbol(), ", MINLOT=" + market_minlot + "MAXLOT=" + market_maxlot +  ", LOTSTEP=" + market_lotstep, ", MODE_MARGINREQUIRED=" + market_marginrequired, ", MODE_STOPLEVEL", market_stoplevel);
      Print("AccountInfo: AccountLeverage: ", acc_leverage, ", PipSize = ", PipSize);
      Print(GetAccountTextDetails());
      Print("EA limits: Lot size:", GetLotSize(), "; Max orders: ", GetMaxOrders(), "; Max orders per type: ", GetMaxOrdersPerType());
   }

   session_active = TRUE;
   ea_active = TRUE;

   return (INIT_SUCCEEDED);
}

void OnTick() {
  int curr_time = TimeCurrent() - GMT_Offset;
  if (ea_active && TradeAllowed() && Volume[0] > 1) {
    Trade();
    if (PrintLogOnChart) DisplayInfoOnChart();
  } else if (GetTotalOrders() > 0) {
    UpdateIndicators();
    UpdateTrailingStops();
    TaskProcessList();
  }
} // end: OnTick()

// The Deinit event handler.
void OnDeinit(const int reason) {
  ea_active = TRUE;
  if (VerboseInfo) {
    Print("EA deinitializing, exit code: ", reason);
    Print(GetSummaryText());
  }
  // DEBUG("n=" + n + " : " +  DoubleToStrMorePrecision(val,19) );
  // DEBUG("CLOSEDEBUGFILE");
}

// The init event handler for tester.
// FIXME: Doesn't seems to work.
void OnTesterInit() {
  if (VerboseDebug) Print("Calling OnTesterInit().");
}

// The init event handler for tester.
// FIXME: Doesn't seems to work.
void OnTesterDeinit() {
  if (VerboseDebug) Print("Calling OnTesterDeinit().");
}

// The Start event handler, which is automatically generated only for running scripts.
// FIXME: Doesn't seems to be called, however MT4 doesn't want to execute EA without it.
void start() {
  if (VerboseTrace) Print("Calling start().");
   // Print market info.
}

void Trade() {
   bool order_placed;
   // vdigits = MarketInfo(Symbol(), MODE_DIGITS);
   // if (VerboseTrace) Print("Calling: Trade()");
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

   if (Alligator_Enabled) {
      if (AlligatorOnBuy()) {
        if (EACloseOnMarketChange) CloseOrdersByType(ALLIGATOR_ON_SELL);
        order_placed = ExecuteOrder(OP_BUY, GetLotSize(), ALLIGATOR_ON_BUY, "AlligatorOnBuy()");
      } else if (AlligatorOnSell()) {
        if (EACloseOnMarketChange) CloseOrdersByType(ALLIGATOR_ON_BUY);
        order_placed = ExecuteOrder(OP_SELL, GetLotSize(), ALLIGATOR_ON_SELL, "AlligatorOnSell()");
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

   if (WPROnBuy()) {
     if (EACloseOnMarketChange) CloseOrdersByType(WPR_ON_SELL);
     order_placed = ExecuteOrder(OP_BUY, GetLotSize(), WPR_ON_BUY, "WPROnBuy()");
   } else if (WPROnSell()) {
     if (EACloseOnMarketChange) CloseOrdersByType(WPR_ON_BUY);
     order_placed = ExecuteOrder(OP_SELL, GetLotSize(), WPR_ON_SELL, "WPROnSell()");
   }

   if (GetTotalOrders() > 0) {
     CheckAccount();
     UpdateTrailingStops();
     TaskProcessList();
   }

   // Print daily report at end of each day.
   int curr_day = - TimeDay(3600 * GMT_Offset);
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
   if (VerboseTrace) Print("Calling: UpdateIndicators()");

   int i;

   // Update Moving Averages indicator values.
   MA_Fast[0] = iMA(NULL, MA_Timeframe, MAAvgPeriodFast, MAShift, MAMethod, MAAppliedPrice, 0); // Current
   MA_Fast[1] = iMA(NULL, MA_Timeframe, MAAvgPeriodFast, MAShift, MAMethod, MAAppliedPrice, MAShiftFast); // Previous
   MA_Fast[2] = iMA(NULL, MA_Timeframe, MAAvgPeriodFast, MAShift, MAMethod, MAAppliedPrice, MAShiftFast + MAShiftFar);
   if (VerboseTrace) { Print("MA_Fast: ", GetArrayValues(MA_Fast)); }

   MA_Medium[0] = iMA(NULL, MA_Timeframe, MAAvgPeriodMedium, MAShift, MAMethod, MAAppliedPrice, 0); // Current
   MA_Medium[1] = iMA(NULL, MA_Timeframe, MAAvgPeriodMedium, MAShift, MAMethod, MAAppliedPrice, MAShiftMedium); // Previous
   MA_Medium[2] = iMA(NULL, MA_Timeframe, MAAvgPeriodMedium, MAShift, MAMethod, MAAppliedPrice, MAShiftMedium + MAShiftFar);
   if (VerboseTrace) { Print("MA_Medium: ", GetArrayValues(MA_Medium)); }

   MA_Slow[0] = iMA(NULL, MA_Timeframe, MAAvgPeriodSlow, MAShift, MAMethod, MAAppliedPrice, 0); // Current
   MA_Slow[1] = iMA(NULL, MA_Timeframe, MAAvgPeriodSlow, MAShift, MAMethod, MAAppliedPrice, MAShiftSlow); // Previous
   MA_Slow[2] = iMA(NULL, MA_Timeframe, MAAvgPeriodSlow, MAShift, MAMethod, MAAppliedPrice, MAShiftSlow + MAShiftFar);
   if (VerboseTrace) { Print("MA_Slow: ", GetArrayValues(MA_Slow)); }
   if (VerboseDebug && IsVisualMode()) DrawMA();

   // Update MACD indicator values.
   MACD[0] = iMACD(NULL, MACD_Timeframe, 12, 26, 9, MACD_Applied_Price, MODE_MAIN, 0); // Current
   MACD[1] = iMACD(NULL, MACD_Timeframe, 12, 26, 9, MACD_Applied_Price, MODE_MAIN, MACD_Shift); // Previous
   MACD[2] = iMACD(NULL, MACD_Timeframe, 12, 26, 9, MACD_Applied_Price, MODE_MAIN, MACD_Shift + MACD_ShiftExtra);
   MACDSignal[0] = iMACD(NULL, MACD_Timeframe, 12, 26, 9, MACD_Applied_Price, MODE_SIGNAL, 0);
   MACDSignal[1] = iMACD(NULL, MACD_Timeframe, 12, 26, 9, MACD_Applied_Price, MODE_SIGNAL, MACD_Shift);
   MACDSignal[2] = iMACD(NULL, MACD_Timeframe, 12, 26, 9, MACD_Applied_Price, MODE_SIGNAL, MACD_Shift + MACD_ShiftExtra);
   if (VerboseTrace) { Print("MACD: ", GetArrayValues(MACD), "; Signal: ", GetArrayValues(MACDSignal)); }

   // Update RSI indicator values.
   for (i = 0; i <= RSI_MaxPeriods; i++) {
      RSI[i] = iRSI(NULL, RSI_Timeframe, RSI_Period, RSI_Applied_Price, i);
   }
   if (VerboseTrace) { Print("RSI: ", GetArrayValues(RSI)); }

   // Update the Bollinger Bands.
   for (i = 0; i <= BBands_MaxPeriods; i++) {
      BBands_main[i] = iBands(NULL, BBands_Timeframe, BBands_Period, BBands_Deviation, BBands_Shift, BBands_Applied_Price, MODE_MAIN, i);
      BBands_upper[i] = iBands(NULL, BBands_Timeframe, BBands_Period, BBands_Deviation, BBands_Shift, BBands_Applied_Price, MODE_UPPER, i);
      BBands_lower[i] = iBands(NULL, BBands_Timeframe, BBands_Period, BBands_Deviation, BBands_Shift, BBands_Applied_Price, MODE_LOWER, i);
   }
   if (VerboseTrace) { Print("Bands: Main: " + GetArrayValues(BBands_main) + "; Upper: " + GetArrayValues(BBands_upper) + "; Lower: " + GetArrayValues(BBands_lower)); }

   // Update Alligator indicator values.
   Alligator[0] = iCustom(NULL, Alligator_Timeframe, "Alligator", 13, 8, 8, 5, 5, 3, 0, 0);
   Alligator[1] = iCustom(NULL, Alligator_Timeframe, "Alligator", 13, 8, 8, 5, 5, 3, 1, 0);
   Alligator[2] = iCustom(NULL, Alligator_Timeframe, "Alligator", 13, 8, 8, 5, 5, 3, 2, 0);
   if (VerboseTrace) { Print("Alligator: ", GetArrayValues(Alligator)); }

   // Update DeMarker indicator values.
   for (i = 0; i <= DeMarker_MaxPeriods; i++) {
      DeMarker[i] = iDeMarker(NULL, DeMarker_Timeframe, DeMarker_Period, i);
   }
   if (VerboseTrace) { Print("DeMarker: ", GetArrayValues(DeMarker)); }

   // Update the Larry Williams' Percent Range indicator values.
   for (i = 0; i <= WPR_MaxPeriods; i++) {
     WPR[i] = (-iWPR(NULL, WPR_Timeframe, WPR_period, i + 1)) / 100.0;
   }
   if (VerboseTrace) { Print("iWPR: ", GetArrayValues(WPR)); }

   // Update Fractals indicator values.
   double ifractal;
   Fractals_lower = 0;
   Fractals_upper = 0;
   for (i = 0; i <= Fractals_MaxPeriods; i++) {
      ifractal = iFractals(NULL, Fractals_Timeframe, MODE_LOWER, i);
      if (ifractal != 0.0) Fractals_lower = ifractal;
      ifractal = iFractals(NULL, Fractals_Timeframe, MODE_UPPER, i);
      if (ifractal != 0.0) Fractals_upper = ifractal;
   }
   if (VerboseTrace) { Print("Fractals_lower: ", Fractals_lower, ", Fractals_upper:", Fractals_upper); }

   return (TRUE);
}

// Trading Signal: when MA1 is crossing MA2, it triggers a trading signal.
bool MAFastOnBuy() {
  bool state = (MA_Fast[0]>MA_Medium[0] && MA_Fast[1]<MA_Medium[1]);
  if (VerboseTrace) Print("iMAFastOnBuy(): cond:", state, " - ", NormalizeDouble(MA_Fast[0], Digits), " > ", NormalizeDouble(MA_Medium[0], Digits), " && ", NormalizeDouble(MA_Fast[1], Digits), " < ", NormalizeDouble(MA_Medium[1], Digits));
  return (MA_Fast[0]>MA_Medium[0] && MA_Fast[1]<MA_Medium[1] && MA_Fast[2]<MA_Medium[2]);
}

// // Trading Signal: when MA1 is crossing MA2, it triggers a trading signal.
bool MAFastOnSell() {
  bool state = (MA_Fast[0]<MA_Medium[0] && MA_Fast[1]>MA_Medium[1]);
  if (VerboseTrace) Print("iMAFastOnSell(): cond:", state, " - ", NormalizeDouble(MA_Fast[0], Digits), " < ", NormalizeDouble(MA_Medium[0], Digits), " && ", NormalizeDouble(MA_Fast[1], Digits), " > ", NormalizeDouble(MA_Medium[1], Digits));
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

bool AlligatorOnBuy() {
  // if (VerboseTrace) Print("AlligatorOnBuy(): ", NormalizeDouble(Alligator[2] - Alligator[1], PipPrecision), ",", NormalizeDouble(Alligator[1] - Alligator[0], PipPrecision), ",", NormalizeDouble(Alligator[2] - Alligator[0], PipPrecision), " >= ", NormalizeDouble(Alligator_Ratio * PipSize, PipPrecision));
   return (
      Alligator[2] - Alligator[1] >= Alligator_Ratio * PipSize &&
      Alligator[1] - Alligator[0] >= Alligator_Ratio * PipSize &&
      Alligator[2] - Alligator[0] >= Alligator_Ratio * PipSize
   );
}

bool AlligatorOnSell() {
  // if (VerboseTrace) Print("AlligatorOnSell(): ", NormalizeDouble(Alligator[1] - Alligator[2], PipPrecision), ",", NormalizeDouble(Alligator[0] - Alligator[1], PipPrecision), ",", NormalizeDouble(Alligator[0] - Alligator[2], PipPrecision), " >= ", NormalizeDouble(Alligator_Ratio * PipSize, PipPrecision));
   return (
      Alligator[1] - Alligator[2] >= Alligator_Ratio * PipSize &&
      Alligator[0] - Alligator[1] >= Alligator_Ratio * PipSize &&
      Alligator[0] - Alligator[2] >= Alligator_Ratio * PipSize
   );
}

bool FractalsOnBuy() {
  return (Fractals_lower != 0.0);
}

bool FractalsOnSell() {
  return (Fractals_upper != 0.0);
}

bool DeMarkerOnSell() {
  // if (VerboseTrace) { Print("DeMarkerOnSell(): ", LowestValue(DeMarker), " < ", (0.5 - DeMarker_Shift)); }
  return (LowestValue(DeMarker) < (0.5 - DeMarker_Shift));
}

bool DeMarkerOnBuy() {
  // if (VerboseTrace) { Print("DeMarkerOnBuy(): ", LowestValue(DeMarker), " > ", (0.5 + DeMarker_Shift)); }
  return (HighestValue(DeMarker) > (0.5 + DeMarker_Shift));
}

bool WPROnSell() {
  return (LowestValue(WPR) <= (0.5 - WPR_Shift));
}

bool WPROnBuy() {
  return (HighestValue(WPR) >= (0.5 + WPR_Shift));
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
   if (last_order_time == iTime(NULL, PERIOD_M1, 0)) {
     return (FALSE);
   }

   // Print current market information.
   if (VerboseTrace) Print(GetMarketTextDetails());

   // Check the limits.
   if (GetTotalOrders() >= GetMaxOrders()) {
     err = "Error in ExecuteOrder(): Maximum open and pending orders reached the limit (EAMaxOrders).";
     if (VerboseErrors && err != last_err) Print(last_err);
     last_err = err;
     return (FALSE);
   }
   if (GetTotalOrdersByType(order_type) >= GetMaxOrdersPerType()) {
     err = "Error in ExecuteOrder(): Maximum open and pending orders per type reached the limit (EAMaxOrdersPerType).";
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
     last_err = StringConcatenate("No money to open more orders.", GetAccountTextDetails());
     if (PrintLogOnChart) Comment(last_err);
     if (VerboseErrors) Print(last_err);
     return (FALSE);
   }

   // Calculate take profit and stop loss.
   RefreshRates();
   double stoploss = 0, takeprofit = 0;
   if (EAStopLoss > 0.0) stoploss = GetClosePrice(cmd) - (EAStopLoss + EATrailingStop) * PipSize * OpTypeValue(cmd);
   else stoploss = GetTrailingStop(EATrailingStopMethod, cmd, 0);
   if (EATakeProfit > 0.0) takeprofit = order_price + (EATakeProfit + EATrailingProfit) * PipSize * OpTypeValue(cmd);
   else takeprofit = GetTrailingProfit(EATrailingProfitMethod, cmd, 0);

   order_ticket = OrderSend(Symbol(), cmd, volume, order_price, EAOrderPriceSlippage, stoploss, takeprofit, order_comment, MagicNumber + order_type, 0, If(cmd == OP_BUY, ColorBuy, ColorSell));
   if (order_ticket >= 0) {
      if (!OrderSelect(order_ticket, SELECT_BY_TICKET) && VerboseErrors) {
        Print("Error in ExecuteOrder(): OrderSelect() error = ", ErrorDescription(GetLastError()));
        if (retry) TaskAddOrderOpen(cmd, volume, order_type, order_comment); // Will re-try again.
        return (FALSE);
      }

      result = TRUE;
      last_order_time = iTime(NULL, PERIOD_M1, 0); // Set last execution bar time.
      last_trail_update = 0; // Set to 0, so trailing stops can be updated faster.
      order_price = OrderOpenPrice();
      if (VerboseInfo) OrderPrint();
      if (VerboseDebug) { Print(GetOrderTextDetails(), GetAccountTextDetails()); }
      if (SoundAlert) PlaySound(SoundFileAtOpen);
      if (SendEmail) EASendEmail();

      /*
      if ((EATakeProfit * PipSize > GetMinStopLevel() || EATakeProfit == 0.0) &&
         (EAStopLoss * PipSize > GetMinStopLevel() || EAStopLoss == 0.0)) {
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
     if (VerboseErrors) Print("Error in ExecuteOrder(): OrderSend(): error = ", ErrorDescription(err_code));
     if (VerboseDebug) {
       Print("ExecuteOrder(): OrderSend(", Symbol(), ", ",  _OrderType_str(cmd), ", ", volume, ", ", order_price, ", ", EAOrderPriceSlippage, ", ", stoploss, ", ", takeprofit, ", ", order_comment, ", ", MagicNumber + order_type, ", 0, ", If(cmd == OP_BUY, ColorBuy, ColorSell), "); ", GetAccountTextDetails());
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

   if (NormalizeDouble(MathAbs((new_price - order_price) / PipSize), 0) > max_change) {
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


bool EACloseOrder(int ticket_no, string reason, bool retry = TRUE) {
  bool result;
  if (ticket_no > 0) result = OrderSelect(ticket_no, SELECT_BY_TICKET);
  else ticket_no = OrderTicket();
  result = OrderClose(ticket_no, OrderLots(), GetClosePrice(OrderType()), EAOrderPriceSlippage, GetOrderColor());
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
  double delta = GetMarketMinGap() * Point + GetMarketSpread(); // Delta price.
  double price = If(existing, OrderOpenPrice(), If(cmd == OP_BUY, Bid, Ask));
  bool valid = trail_stop == 0 || (cmd == OP_BUY  && price - trail_stop > delta) || (cmd == OP_SELL && trail_stop - price > delta);
  if (!valid && VerboseDebug && cmd == OP_BUY) Print("ValidTrailingStop(OP_BUY): #" + If(existing, OrderTicket(), 0) + ":", price - trail_stop, " > ", DoubleToStr(delta, PipPrecision));
  if (!valid && VerboseDebug && cmd == OP_SELL) Print("ValidTrailingStop(OP_SELL): #" + If(existing, OrderTicket(), 0) + ":", trail_stop - price, " > ", DoubleToStr(delta, PipPrecision));
  return valid;
}

// Validate value for profit take.
bool ValidProfitTake(double profit_take, int cmd, bool existing = FALSE) {
  //if (VerboseTrace && cmd ==  OP_BUY) Print("ValidProfitTake(OP_BUY): ", profit_take - Bid, " > ", NormalizeDouble(GetMinStopLevel(), PipPrecision));
  //if (VerboseTrace && cmd ==  OP_SELL) Print("ValidProfitTake(OP_SELL): ", Ask - profit_take, " > ", NormalizeDouble(GetMinStopLevel(), PipPrecision));
  //if (VerboseTrace) Print("ValidProfitTake(" + cmd + "): Delta: ", DoubleToStr(delta, PipPrecision));
  double delta = GetMarketMinGap() * Point + GetMarketSpread(); // Delta price.
  double price = If(existing, OrderOpenPrice(), If(cmd == OP_BUY, Bid, Ask));
  bool valid = profit_take == 0 || (cmd ==  OP_BUY && profit_take - price > delta) || (cmd == OP_SELL && price - profit_take  > delta);
  if (!valid && VerboseDebug && cmd == OP_BUY) Print("ValidTrailingStop(OP_BUY): #" + If(existing, OrderTicket(), 0) + ":", profit_take - price, " > ", DoubleToStr(delta, PipPrecision));
  if (!valid && VerboseDebug && cmd == OP_SELL) Print("ValidTrailingStop(OP_SELL): #" + If(existing, OrderTicket(), 0) + ":", price - profit_take, " > ", DoubleToStr(delta, PipPrecision));
  return valid;
}

void UpdateTrailingStops() {
   bool result; // Check result of executed orders.
   double new_trailing_stop, new_profit_take;
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
        // order_stop_loss = NormalizeDouble(If(OpTypeValue(OrderType()) > 0 || OrderStopLoss() != 0.0, OrderStopLoss(), 999999), PipPrecision);

        if (EAMinimalizeLosses && GetOrderProfit() > GetMinStopLevel()) {
          if ((OrderType() == OP_BUY && OrderStopLoss() < Bid) ||
             (OrderType() == OP_SELL && OrderStopLoss() > Ask)) {
            result = OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - OrderCommission() * Point, OrderTakeProfit(), 0, GetOrderColor());
            if (!result && err_code > 1) Print("Error in UpdateTrailingStops(): OrderModify(): EAMinimalizeLosses: ", ErrorDescription(err_code));
            if (VerboseTrace) Print("UpdateTrailingStops(): EAMinimalizeLosses: ", GetOrderTextDetails());
          }
        }

        new_trailing_stop = GetTrailingStop(EATrailingStopMethod, OrderType(), OrderStopLoss());
        new_profit_take = GetTrailingProfit(EATrailingProfitMethod, OrderType(), OrderTakeProfit());
        if (new_trailing_stop != OrderStopLoss() || OrderTakeProfit() != new_profit_take) { // Perform update on change only.
           result = OrderModify(OrderTicket(), OrderOpenPrice(), new_trailing_stop, new_profit_take, 0, GetOrderColor());
           if (!result) {
             err_code = GetLastError();
             if (VerboseErrors && err_code > 1) {
               Print("OrderModify: ", ErrorDescription(err_code));
               if (VerboseDebug) Print("Error: UpdateTrailingStops(): OrderModify(", OrderTicket(), ", ", OrderOpenPrice(), ", ", new_trailing_stop, ", ", new_profit_take, ", ", 0, ", ", GetOrderColor(), ")");
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
double GetTrailingStop(int method, int cmd, double previous, bool existing = FALSE) {
   double trail_stop = 0;
   double delta = GetMarketMinGap() * Point + GetMarketSpread(); // Delta price.
   switch (method) {
     case 0: // None
       trail_stop = previous;
       break;
     case 1: // Dynamic fixed.
       if (cmd == OP_BUY) trail_stop = Bid - EATrailingStop * PipSize - delta;
       if (cmd == OP_SELL) trail_stop = Ask + EATrailingStop * PipSize + delta;
       break;
     case 2: // iMA Small (Current) - trailing stop
       trail_stop = MA_Fast[0] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 3: // iMA Small (Previous) - trailing stop
       trail_stop = MA_Fast[1] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 4: // iMA Small (Far) - trailing stop. Optimize together with: MAShiftFar.
       trail_stop = MA_Fast[2] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 5: // iMA Medium (Current) - trailing stop
       trail_stop = MA_Medium[0] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 6: // iMA Medium (Previous) - trailing stop
       trail_stop = MA_Medium[1] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 7: // iMA Medium (Far) - trailing stop. Optimize together with: MAShiftFar.
       trail_stop = MA_Medium[2] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 8: // iMA Slow (Current) - trailing stop
       trail_stop = MA_Slow[0] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 9: // iMA Slow (Previous) - trailing stop
       trail_stop = MA_Slow[1] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     case 10: // iMA Slow (Far) - trailing stop. Optimize together with: MAShiftFar.
       trail_stop = MA_Slow[2] - EATrailingStop * OpTypeValue(cmd) * PipSize - delta;
       break;
     default:
       if (VerboseDebug) Print("Error in GetTrailingStop(): Unknown trailing stop method: ", method);
   }

   if (!ValidTrailingStop(trail_stop, cmd, existing)) {
     if (VerboseTrace)
       Print("Error in GetTrailingStop(", method, "): #" + If(existing, OrderTicket(), 0) + ": Invalid Trailing Stop: ", trail_stop, "; Previous: ", previous, "; ", GetOrderTextDetails());
     // If value is invalid, fallback to standard one.
     trail_stop = If(cmd == OP_BUY, Bid - EATrailingStop * PipSize - delta, Ask + EATrailingStop * PipSize + delta);
   }

   if (EATrailingStopOneWay) { // If TRUE, move trailing stop only one direction.
     if (cmd == OP_SELL)     trail_stop = If(trail_stop < previous, trail_stop, previous);
     else if (cmd == OP_BUY) trail_stop = If(trail_stop > previous, trail_stop, previous);
   }

   // if (VerboseTrace && trail_stop != OrderStopLoss()) Print("GetTrailingStop(", method, "): New Trailing Stop: ", trail_stop, "; Previous: ", previous, "; ", GetOrderTextDetails());
   if (VerboseDebug && IsVisualMode()) ShowLine("trail_stop_" + OrderTicket(), trail_stop, Orange);
   return trail_stop;
}


// Get new trailing profit take.
// Note: Suggested methods: 1 & 4.
// Params:
//   bool existing: TRUE if the calculation is for particular existing order
double GetTrailingProfit(int method, int cmd, double previous, bool existing = FALSE) {
   double profit_take = 0;
   double delta = GetMarketMinGap() * Point + GetMarketSpread(); // Delta price.
   switch (method) {
     case 0: // None
       profit_take = previous;
       break;
     case 1: // Dynamic fixed.
       if (cmd == OP_BUY) profit_take = Bid + EATrailingProfit * PipSize + delta;
       if (cmd == OP_SELL) profit_take = Ask - EATrailingProfit * PipSize - delta;
       break;
     case 2: // iMA Small (Current) + trailing profit
       profit_take = MA_Fast[0] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 3: // iMA Small (Previous) + trailing profit.
       profit_take = MA_Fast[1] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 4: // iMA Small (Far) + trailing profit. Optimize together with: MAShiftFar.
       profit_take = MA_Fast[2] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 5: // iMA Medium (Current) + trailing profit
       profit_take = MA_Medium[0] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 6: // iMA Medium (Previous) + trailing profit
       profit_take = MA_Medium[1] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 7: // iMA Medium (Far) + trailing profit. Optimize together with: MAShiftFar.
       profit_take = MA_Medium[2] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 8: // iMA Slow (Current) + trailing profit
       profit_take = MA_Slow[0] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 9: // iMA Slow (Previous) + trailing profit
       profit_take = MA_Slow[1] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     case 10: // iMA Slow (Far) + trailing profit. Optimize together with: MAShiftFar.
       profit_take = MA_Slow[2] + EATrailingProfit * OpTypeValue(cmd) * PipSize + delta;
       break;
     default:
       if (VerboseDebug) Print("Error in GetTrailingStop(): Unknown trailing stop method: ", method);
   }

   if (!ValidProfitTake(profit_take, cmd)) {
     if (VerboseTrace)
       Print("Error in GetTrailingProfit(", method, "): #" + If(existing, OrderTicket(), 0) + ": Invalid Profit Take: ", profit_take, "; Previous: ", previous, "; ", GetOrderTextDetails());
     // If value is invalid, fallback to standard one.
     profit_take = If(cmd == OP_BUY, Bid + EATrailingStop * PipSize + delta, Ask - EATrailingStop * PipSize - delta);
   }

   if (EATrailingProfitOneWay) { // If TRUE, move profit take only one direction.
     if (cmd == OP_SELL)     profit_take = If(profit_take < previous, profit_take, previous);
     else if (cmd == OP_BUY) profit_take = If(profit_take > previous, profit_take, previous);
   }

   // if (VerboseTrace && profit_take != previous) Print("GetProfitStop(", method, "): New Profit Stop: ", profit_take, "; Old: ", previous, "; ", GetOrderTextDetails());
   if (VerboseDebug && IsVisualMode()) ShowLine("take_profit_" + OrderTicket(), profit_take, Gold);
   return profit_take;
}

void ShowLine(string name, double price, int colour = Yellow) {
    ObjectCreate(ChartID(), name, OBJ_HLINE, 0, Time[0], price, 0, 0);
    ObjectSet(name, OBJPROP_COLOR, colour);
    ObjectMove(name, 0, Time[0], price);
}

// Get current open price depending on the operation type.
double GetOpenPrice(int op_type) {
   // op_type: SELL = -1, BUY = 1
   return (If(OpTypeValue(op_type)> 0, Ask, Bid));
}

// Get current close price depending on the operation type.
double GetClosePrice(int op_type) {
   // op_type: SELL = -1, BUY = 1
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

double If(bool condition, double on_true, double on_false) {
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
  if (last_order_time == iTime(NULL, PERIOD_M1, 0)) {
    err = StringConcatenate("Not trading at the moment, as we already placed order on: ", TimeToStr(last_order_time));
    if (VerboseTrace && err != last_err) Print(err);
    last_err = err;
    return (FALSE);
  }
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
  if (Bars<50) {
    err = "Bars less than 50, not trading...";
    if (VerboseTrace && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }
  if (!IsTradeAllowed()) {
    err = "Trade is not allowed!";
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
  if (IsTradeContextBusy()) {
    err = "Error: Trade context is temporary busy.";
    if (VerboseErrors && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }
  if (IsStopped()) {
    err = "Error: Terminal is stopping!";
    if (VerboseErrors && err != last_err) Print(err);
    if (PrintLogOnChart && err != last_err) Comment(err);
    last_err = err;
    return (FALSE);
  }
  if (!IsTradingDay(TimeCurrent())) {
    err = "Not a trading day.";
    if (VerboseInfo && err != last_err) Print(err);
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

bool IsTradingDay(int time) {
   int day_of_year = TimeDayOfYear(time);
   int day_of_week = TimeDayOfWeek(time);
   // if (VerboseTrace) Print("IsTradingDay(): Day of week: " + day_of_week + "; Day of year: " + day_of_year);
   return (day_of_week > 0 && day_of_week < 6 && day_of_year > 1 && day_of_year < 365);
}

double GetOrderProfit() {
  return OrderProfit() - OrderCommission();
}

double GetOrderColor() {
  return If(OpTypeValue(OrderType()) > 0, ColorBuy, ColorSell);
}

// Get minimal permissible StopLoss/TakeProfit value in points.
double GetMinStopLevel() {
  return MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
}

/*
double GetLotSize() {
   double curr_lot_size;
   if (FapTurbo_Lots > 0.0) curr_lot_size = FapCalculateLots(FapTurbo_Lots, 0, "");
   else {
      curr_lot_size = NormalizeDouble(MathFloor(AccountFreeMargin() * default_fap_lot_size / 100.0 / market_marginrequired) * market_lotstep, volume_precision);
      if (curr_lot_size < market_minlot) curr_lot_size = market_minlot;
      if (curr_lot_size > market_maxlot) curr_lot_size = market_maxlot;
   }
   if (curr_lot_size > FapTurbo_MaxLots) curr_lot_size = FapTurbo_MaxLots;
   return (curr_lot_size);
}
*/

// Current market spread value in pips.
//
// Note: Using Mode_SPREAD can return 20 on EURUSD (IBFX), but zero on some other pairs, so using Ask - Bid instead.
// See: http://forum.mql4.com/42285
double GetMarketSpread() {
  // return MarketInfo(Symbol(), MODE_SPREAD) / MathPow(10, Digits - PipPrecision);
  return Ask - Bid;
}

// Get current market stop level in points.
double GetMarketMinGap() {
  return MarketInfo(Symbol(),MODE_STOPLEVEL);  // Unit is in points.
}

double NormalizeLots(double lots, bool ceiling = FALSE, string pair = "") {
   double lotsize;
   double precision;
   if (pair == "" || pair == "0") pair = Symbol();
   double lotstep = MarketInfo(pair, MODE_LOTSTEP);
   double  minlot = MarketInfo(pair, MODE_MINLOT);
   double  maxlot = MarketInfo(pair, MODE_MAXLOT);
   if (minlot == 0.0) minlot = 0.1;
   if (maxlot == 0.0) maxlot = 100;

   if (lotstep > 0.0) precision = 1 / lotstep;
   else precision = 1 / minlot;

   if (ceiling) lotsize = MathCeil(lots * precision) / precision;
   else lotsize = MathFloor(lots * precision) / precision;

   if (lotsize < minlot) lotsize = minlot;
   if (lotsize > maxlot) lotsize = maxlot;
   return (lotsize);
}

double NormalizeLots2(double lots, string pair=""){
    // See: http://forum.mql4.com/47988
    if (pair == "") pair = Symbol();
    double  lotStep     = MarketInfo(pair, MODE_LOTSTEP),
            minLot      = MarketInfo(pair, MODE_MINLOT);
    lots            = MathRound(lots/lotStep) * lotStep;
    if (lots < minLot) lots = 0;    // or minLot
    return(lots);
}

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

// Calculate number of order allowed given risk ratio.
int GetMaxOrdersAuto() {
  double free     = AccountFreeMargin();
  double leverage = AccountLeverage();
  double one_lot  = MarketInfo(Symbol(), MODE_MARGINREQUIRED);// Price of 1 lot
  double margin_risk = 0.5; // Percent of free margin to use (50%).
  return (free * margin_risk / one_lot * (100 / leverage) / GetLotSize()) * GetRiskRatio();
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
  double min_lot   = MarketInfo(Symbol(), MODE_MINLOT);
  double max_lot   = MarketInfo(Symbol(), MODE_MAXLOT);
  double one_lot   = MarketInfo(Symbol(), MODE_MARGINREQUIRED); // Free margin required to open 1 lot for buying.
  double margin_risk = 0.01; // Percent of free margin to use per order (1%).
  double avail_lots = free / one_lot * (100 / leverage);
  return MathMin(MathMax(avail_lots * min_lot * margin_risk * GetRiskRatio(), min_lot), max_lot);
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
  return MathMin(equity / balance, 2);
}

// Return risk ratio value;
double GetRiskRatio() {
  return If(RiskRatio == 0, GetAutoRiskRatio(), RiskRatio);
}

string GetDailyReport() {
  return GetAccountTextDetails() + "\n" + GetOrdersStats();
}

/* BEGIN: DISPLAYING FUNCTIONS */

void DisplayInfoOnChart() {
  // Prepare text for Stop Out.
  string stop_out_level = "Stop Out: " + AccountStopoutLevel();
  if (AccountStopoutMode() == 0) stop_out_level += "%"; else stop_out_level += AccountCurrency();
  // Prepare text for Total Orders.
  string total_orders_text = "Open Orders: " + total_orders + " [" + DoubleToStr(CalculateOpenLots(), 2) + " lots]";
  total_orders_text += " (other: " + GetTotalOrders(FALSE) + ")";
  total_orders_text += "; ratio: " + CalculateOrderTypeRatio();
  // Print actual info.
  Comment(""
   + "------------------------------------------------\n"
   + "ACCOUNT INFORMATION:\n"
   + "Server Time: " + TimeToStr(TimeCurrent(), TIME_SECONDS) + "\n"
   + "Acc Number: " + AccountNumber(), "Acc Name: " + AccountName() + "; Broker: " + AccountCompany() + "\n"
   + "Equity: " + DoubleToStr(AccountEquity(), 0) + AccountCurrency() + "; Balance: " + DoubleToStr(AccountBalance(), 0) + AccountCurrency() + "; Leverage: 1:" + DoubleToStr(AccountLeverage(), 0)  + "\n"
   + "Used Margin: " + DoubleToStr(AccountMargin(), 0)  + AccountCurrency() + "; Free: " + DoubleToStr(AccountFreeMargin(), 0) + AccountCurrency() + "; " + stop_out_level + "\n"
   + "Lot size: " + DoubleToStr(GetLotSize(), volume_precision) + "; Max orders: " + If(EAMaxOrders == 0, GetMaxOrdersAuto(), EAMaxOrders) + "; Risk ratio: " + DoubleToStr(GetRiskRatio(), 1) + "\n"
   + total_orders_text + "\n"
   + GetOrdersStats() + "\n"
   + "Last error: " + last_err + "\n"
   + "------------------------------------------------\n"
   + "MARKET INFORMATION:\n"
   + "Spread: " + DoubleToStr(GetMarketSpread(), Digits - PipPrecision) + "\n"
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
string GetOrdersStats() {
  // Prepare data about open orders per strategy type.
  string open_orders_per_type = "Orders Per Type: ";
  int ma_orders = open_orders[MA_FAST_ON_BUY] + open_orders[MA_FAST_ON_SELL] + open_orders[MA_MEDIUM_ON_BUY] + open_orders[MA_MEDIUM_ON_SELL] + open_orders[MA_LARGE_ON_BUY] + open_orders[MA_LARGE_ON_SELL];
  int macd_orders = open_orders[MACD_ON_BUY] + open_orders[MACD_ON_SELL];
  int fractals_orders = open_orders[FRACTALS_ON_BUY] + open_orders[FRACTALS_ON_SELL];
  int demarker_orders = open_orders[DEMARKER_ON_BUY] + open_orders[DEMARKER_ON_SELL];
  int iwpr_orders = open_orders[WPR_ON_BUY] + open_orders[WPR_ON_SELL];
  int alligator_orders = open_orders[ALLIGATOR_ON_BUY] + open_orders[ALLIGATOR_ON_SELL];
  int bbands_orders = open_orders[BBANDS_ON_BUY] + open_orders[BBANDS_ON_SELL];
  int rsi_orders = open_orders[RSI_ON_BUY] + open_orders[RSI_ON_SELL];
  string orders_per_type = "Stats: ";
  if (total_orders > 0) {
     if (MA_Enabled && ma_orders > 0) orders_per_type += "MA: " + MathFloor(100 / total_orders * ma_orders) + "%, ";
     if (MACD_Enabled && macd_orders > 0) orders_per_type += "MACD: " + MathFloor(100 / total_orders * macd_orders) + "%, ";
     if (Fractals_Enabled && fractals_orders > 0) orders_per_type += "Fractals: " + MathFloor(100 / total_orders * fractals_orders) + "%, ";
     if (DeMarker_Enabled && demarker_orders > 0) orders_per_type += "DeMarker: " + MathFloor(100 / total_orders * demarker_orders) + "%\n";
     if (WPR_Enabled && iwpr_orders > 0) orders_per_type += "IWPR: " + MathFloor(100 / total_orders * iwpr_orders) + "%, ";
     if (Alligator_Enabled && alligator_orders > 0) orders_per_type += "Alligator: " + MathFloor(100 / total_orders * alligator_orders) + "%, ";
     if (BBands_Enabled && bbands_orders > 0) orders_per_type += "Bands: " + MathFloor(100 / total_orders * bbands_orders) + "%, ";
     if (RSI_Enabled && rsi_orders > 0) orders_per_type += "RSI: " + MathFloor(100 / total_orders * rsi_orders) + "%, ";
  } else {
    orders_per_type += "No orders open yet.";
  }
  return orders_per_type;
}
string GetAccountTextDetails() {
   return StringConcatenate("Account Details: ",
      "Time: ", TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS), "; ",
      "Account Balance: ", DoubleToStr(AccountBalance(), 2), " ", AccountCurrency(), "; ",
      "Account Equity: ", DoubleToStr(AccountEquity(), 2), " ", AccountCurrency(), "; ",
      "Free Margin: ", DoubleToStr(AccountFreeMargin(), 2), " ", AccountCurrency(), "; ",
      "No of Orders: ", GetTotalOrders(), " (BUY/SELL ratio: ", CalculateOrderTypeRatio(), "); "
   );
}

string GetMarketTextDetails() {
   return StringConcatenate("MarketInfo: ",
     "Symbol: ", Symbol(), "; ",
     "Ask: ", Ask, "; ",
     "Bid: ", Bid, "; ",
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
      double MA_Fast_Curr = iMA(NULL, MA_Timeframe, MAAvgPeriodFast, MAShift, MAMethod, MAAppliedPrice, Counter); // Current Bar.
      double MA_Fast_Prev = iMA(NULL, MA_Timeframe, MAAvgPeriodFast, MAShift, MAMethod, MAAppliedPrice, Counter-1); // Previous Bar.
      ObjectCreate("MA_Fast" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Fast_Curr, iTime(NULL,0,Counter-1), MA_Fast_Prev);
      ObjectSet("MA_Fast" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Fast" + itime, OBJPROP_COLOR, Yellow);

      double MA_Medium_Curr = iMA(NULL, MA_Timeframe, MAAvgPeriodMedium, MAShift, MAMethod, MAAppliedPrice, Counter); // Current Bar.
      double MA_Medium_Prev = iMA(NULL, MA_Timeframe, MAAvgPeriodMedium, MAShift, MAMethod, MAAppliedPrice, Counter-1); // Previous Bar.
      ObjectCreate("MA_Medium" + itime, OBJ_TREND, 0, iTime(NULL,0,Counter), MA_Medium_Curr, iTime(NULL,0,Counter-1), MA_Medium_Prev);
      ObjectSet("MA_Medium" + itime, OBJPROP_RAY, False);
      ObjectSet("MA_Medium" + itime, OBJPROP_COLOR, Gold);

      double MA_Slow_Curr = iMA(NULL, MA_Timeframe, MAAvgPeriodSlow, MAShift, MAMethod, MAAppliedPrice, Counter); // Current Bar.
      double MA_Slow_Prev = iMA(NULL, MA_Timeframe, MAAvgPeriodSlow, MAShift, MAMethod, MAAppliedPrice, Counter-1); // Previous Bar.
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
      // ERR_TRADE_TOO_MANY_ORDERS
      // On some trade servers, the total amount of open and pending orders can be limited. If this limit has been exceeded, no new position will be opened
      case  148: text = "Amount of open and pending orders has reached the limit."; break;
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
      case 4107: text = "Invalid price parameter for trade function."; break;
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
