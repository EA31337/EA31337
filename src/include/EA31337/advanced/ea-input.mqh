//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                       Copyright 2016-2020, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//|                                                     ea-input.mqh |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, kenorb"
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| Includes.
//+------------------------------------------------------------------+
#include "..\ea-enums.mqh"
#include "..\..\EA31337-classes\Condition.mqh"

//+------------------------------------------------------------------+
//| User input variables.
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
extern string __Trade_Parameters__ = "-- Trade parameters --"; // >>> TRADE <<<
extern uint   MaxOrders = 0; // Max orders (0 = auto)
extern uint   MaxOrdersPerType = 6; // Max orders per type (0 = auto)
extern uint   MaxOrdersPerDay = 0; // Max orders per day (0 = unlimited)
extern double LotSize = 0.01; // Lot size (0 = auto)
extern int    LotSizeIncreaseMethod = 202; // Lot size increase method (0-255)
extern int    LotSizeDecreaseMethod = 167; // Lot size decrease method (0-255)
extern bool   TradeMicroLots = 1; // Trade micro lots?
int           TrendMethod = 0; // Main trend method (0-255)
extern int    MinVolumeToTrade = 0; // Min volume to trade
extern int    MaxOrderPriceSlippage = 50; // Max price slippage (in pts)
extern int    MaxTries = 5; // Max retries for opening orders
double MinPipChangeToTrade = 0.0; // Min pip change to trade
extern int    MinPipGap = 10; // Min gap between trades per type (in pips)
extern int    MinIntervalSec = 0; // Min interval between subsequent trade signals (in sec)
//extern uint   TickProcessMethod = 0; // Tick process method (0-8, 0 - all)

//+------------------------------------------------------------------+
extern string   __EA_Order_Parameters__ = "-- Profit and loss parameters --"; // >>> PROFIT/LOSS <<<
extern uint     TakeProfitMax = 0; // Max Take profit (in pips, 0 = auto)
extern uint     StopLossMax = 0; // Max Stop loss (in pips, 0 = auto)

//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Profit and loss trailing parameters --"; // >>> TRAILINGS <<<
ENUM_TRAIL_TYPE DefaultTrailingStopMethod = 0; // Default trail stop method (0 = none)
ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = 0; // Default trail profit method
extern int TrailingStop = 40; // Extra trailing stop (in pips)
extern int TrailingProfit = 0; // Extra trailing profit (in pips)
double TrailingStopAddPerMinute = 0.3; // Decrease trail stop per minute (pip/min)

//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management parameters --"; // >>> RISK <<
extern double RiskMarginPerOrder = 1; // Risk margin per order (in %, 0-100, 0 - auto, -1 - off)
extern double RiskMarginTotal = 5; // Risk margin in total (in %, 0-100, 0 - auto, -1 - off)
extern double RiskRatio = 0; // Risk ratio (0 = auto, 1.0 = normal)
extern int RiskRatioIncreaseMethod = 0; // Risk ratio increase method (0-255)
extern int RiskRatioDecreaseMethod = 0; // Risk ratio decrease method (0-255)
extern int InitNoOfDaysToWarmUp = 21; // Initial warm-up period (in days)
extern double CloseOrderAfterXHours = 0; // Close order after X hours (>0 - all, <0 - only profitable 0 - off)

extern bool ApplySpreadLimits = 1; // Apply strategy spread limits
extern double MaxSpreadToTrade = 10.0; // Max spread to trade (in pips), 0 - disable limit

//+------------------------------------------------------------------+
extern string __Strategy_Profit__ = "-- Per strategy parameters (0 to disable) --"; // >>> STRATEGY PARAMS <<<
extern double ProfitFactorMinToTrade = 0.6; // Min. profit factor per strategy to trade
extern double ProfitFactorMaxToTrade = 0.0; // Max. profit factor per strategy to trade
extern int InitNoOfOrdersToCalcPF = 10; // Initial number of orders to calculate profit factor

//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting parameters (set 1.0 for default) --"; // >>> BOOSTING <<<
extern bool Boosting_Enabled = 1; // Enable boosting
extern double BoostTrendFactor = 0.5; // Boost by trend factor
extern bool StrategyBoostByPF = 1.1; // Boost strategy by its profit factor
extern bool StrategyHandicapByPF = 0; // Handicap by its low profit factor
extern double BestDailyStrategyMultiplierFactor = 0.1; // Multiplier for the best daily strategy
extern double BestWeeklyStrategyMultiplierFactor = 0.1; // Multiplier for the best weekly strategy
extern double BestMonthlyStrategyMultiplierFactor = 1.4; // Multiplier for the best monthly strategy
extern double WorseDailyStrategyMultiplierFactor = 1; // Multiplier for the worse daily strategy
extern double WorseWeeklyStrategyMultiplierFactor = 1; // Multiplier for the worse weekly strategy
extern double WorseMonthlyStrategyMultiplierFactor = 1.4; // Multiplier for the worse monthly strategy
extern double ConWinsIncreaseFactor = -1.5; // Increase lot factor on consequent wins (in %, 0 - off)
extern double ConLossesIncreaseFactor = -1.2; // Increase lot factor on consequent loses (in %, 0 - off)
extern uint ConFactorOrdersLimit = 0; // No of orders to check on consequent wins/loses

//+------------------------------------------------------------------+
input static string __Strategy_Timeframes__ = "-- Strategy's timeframes --"; // >>> STRATEGY'S TIMEFRAMES (1-255: M1=1,M5=2,M15=4,M30=8,H1=16,H2=32,H4=64...) <<<
extern unsigned int AC_Active_Tf = 0; // AC: Activate timeframes
extern unsigned int AD_Active_Tf = 1; // AD: Activate timeframes
extern unsigned int ADX_Active_Tf = 1; // ADX: Activate timeframes
extern unsigned int Alligator_Active_Tf = 10; // Alligator: Activate timeframes
extern unsigned int Bands_Active_Tf = 5; // Bands: Activate timeframes
extern unsigned int CCI_Active_Tf = 1; // CCI: Activate timeframes
extern unsigned int DeMarker_Active_Tf = 2; // DeMarker: Activate timeframes
extern unsigned int Envelopes_Active_Tf = 1; // Envelopes: Activate timeframes
extern unsigned int Force_Active_Tf = 0; // Force: Activate timeframes
extern unsigned int Fractals_Active_Tf = 1; // Fractals: Activate timeframes
extern unsigned int MACD_Active_Tf = 9; // MACD: Activate timeframes
extern unsigned int MA_Active_Tf = 0; // MA: Activate timeframes
extern unsigned int MFI_Active_Tf = 9; // MFI: Activate timeframes
extern unsigned int RSI_Active_Tf = 0; // RSI: Activate timeframes
extern unsigned int SAR_Active_Tf = 10; // SAR: Activate timeframes
extern unsigned int WPR_Active_Tf = 0; // WPR: Activate timeframes
unsigned int ATR_Active_Tf = 0; // ATR: Activate timeframes
unsigned int Awesome_Active_Tf = 0; // Awesome: Activate timeframes
unsigned int BWMFI_Active_Tf = 0; // BWMFI: Activate timeframes
unsigned int BearsPower_Active_Tf = 0; // BearsPower: Activate timeframes
unsigned int BullsPower_Active_Tf = 0; // BullsPower: Activate timeframes
unsigned int Gator_Active_Tf = 0; // Gator: Activate timeframes
unsigned int Ichimoku_Active_Tf = 0; // Ichimoku: Activate timeframes
unsigned int Momentum_Active_Tf = 0; // Momentum: Activate timeframes
unsigned int OBV_Active_Tf = 0; // OBV: Activate timeframes
unsigned int OSMA_Active_Tf = 0; // OSMA: Activate timeframes
unsigned int RVI_Active_Tf = 0; // RVI: Activate timeframes
unsigned int StdDev_Active_Tf = 0; // StdDev: Activate timeframes
unsigned int Stochastic_Active_Tf = 0; // Stochastic: Activate timeframes
unsigned int ZigZag_Active_Tf = 0; // ZigZag: Activate timeframes

//+------------------------------------------------------------------+
extern string __SmartQueue_Parameters__ = "-- Smart queue parameters --"; // >>> SMART QUEUE <<<
extern bool SmartQueueActive = 0; // Activate QueueAI
extern int SmartQueueMethod = 5; // QueueAI: Method for selecting the best order (0-15)
extern int SmartQueueFilter = 30; // QueueAI: Method for filtering the orders (0-255)

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions__ = "-- Account conditions --"; // >>> CONDITIONS & ACTIONS <<<
extern bool Account_Conditions_Active = 0; // Enable account conditions (don't enable for multibot trading)
// Condition 5 - Equity 1% high
extern ENUM_ACC_CONDITION Account_Condition_1 = 2; // 1. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_1 = 14; // 1. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_1 = 1; // 1. Action to take
// Condition 6 - Equity 10% high
extern ENUM_ACC_CONDITION Account_Condition_2 = 0; // 2. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_2 = 8; // 2. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_2 = 7; // 2. Action to take
// Condition 10 - 50% Margin Used
extern ENUM_ACC_CONDITION Account_Condition_3 = 0; // 3. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_3 = 1; // 3. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_3 = 0; // 3. Action to take
// Condition 17 - Max. daily balance < max. weekly
extern ENUM_ACC_CONDITION Account_Condition_4 = 17; // 4. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_4 = 16; // 4. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_4 = 7; // 4. Action to take
//
extern ENUM_ACC_CONDITION Account_Condition_5 = 0; // 5. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_5 = 0; // 5. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_5 = 0; // 5. Action to take

extern ENUM_ACC_CONDITION Account_Condition_6      = 6; // 6. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_6    = 0; // 6. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_6      = 0; // 6. Action to take

extern ENUM_ACC_CONDITION Account_Condition_7      = 7; // 7. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_7    = 0; // 7. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_7      = 0; // 7. Action to take

extern ENUM_ACC_CONDITION Account_Condition_8      = 8; // 8. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_8    = 0; // 8. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_8      = 0; // 8. Action to take

extern ENUM_ACC_CONDITION Account_Condition_9      = 9; // 9. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_9    = 0; // 9. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_9      = 0; // 9. Action to take

extern ENUM_ACC_CONDITION Account_Condition_10      = 10; // 10. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_10    = 0; // 10. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_10      = 0; // 10. Action to take

extern ENUM_ACC_CONDITION Account_Condition_11      = 11; // 11. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_11    = 0; // 11. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_11      = 0; // 11. Action to take

extern ENUM_ACC_CONDITION Account_Condition_12      = 12; // 12. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_12    = 0; // 12. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_12      = 0; // 12. Action to take

extern ENUM_ACC_CONDITION Account_Condition_13      = 13; // 13. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_13    = 0; // 13. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_13      = 0; // 13. Action to take

extern ENUM_ACC_CONDITION Account_Condition_14      = 14; // 14. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_14    = 0; // 14. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_14      = 0; // 14. Action to take

extern ENUM_ACC_CONDITION Account_Condition_15      = 15; // 15. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_15    = 0; // 15. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_15      = 0; // 15. Action to take

extern ENUM_ACC_CONDITION Account_Condition_16      = 16; // 16. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_16    = 0; // 16. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_16      = 0; // 16. Action to take

extern ENUM_ACC_CONDITION Account_Condition_17      = 17; // 17. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_17    = 0; // 17. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_17      = 0; // 17. Action to take

extern ENUM_ACC_CONDITION Account_Condition_18      = 18; // 18. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_18    = 0; // 18. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_18      = 0; // 18. Action to take

extern ENUM_ACC_CONDITION Account_Condition_19      = 19; // 19. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_19    = 0; // 19. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_19      = 0; // 19. Action to take

extern ENUM_ACC_CONDITION Account_Condition_20      = 20; // 20. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_20    = 0; // 20. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_20      = 0; // 20. Action to take

extern ENUM_ACC_CONDITION Account_Condition_21      = 21; // 21. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_21    = 0; // 21. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_21      = 0; // 21. Action to take

extern ENUM_ACC_CONDITION Account_Condition_22      = 22; // 22. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_22    = 0; // 22. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_22      = 0; // 22. Action to take

extern ENUM_ACC_CONDITION Account_Condition_23      = 23; // 23. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_23    = 0; // 23. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_23      = 0; // 23. Action to take

extern ENUM_ACC_CONDITION Account_Condition_24      = 24; // 24. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_24    = 0; // 24. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_24      = 0; // 24. Action to take

extern ENUM_ACC_CONDITION Account_Condition_25      = 25; // 25. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_25    = 0; // 25. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_25      = 0; // 25. Action to take

extern ENUM_ACC_CONDITION Account_Condition_26      = 26; // 26. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_26    = 0; // 26. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_26      = 0; // 26. Action to take

extern ENUM_ACC_CONDITION Account_Condition_27      = 27; // 27. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_27    = 0; // 27. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_27      = 0; // 27. Action to take

extern ENUM_ACC_CONDITION Account_Condition_28      = 0; // 28. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_28    = 0; // 28. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_28      = 0; // 28. Action to take

extern ENUM_ACC_CONDITION Account_Condition_29      = 0; // 29. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_29    = 0; // 29. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_29      = 0; // 29. Action to take

extern ENUM_ACC_CONDITION Account_Condition_30      = 0; // 30. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_30    = 0; // 30. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_30      = 0; // 30. Action to take

extern int Account_Condition_MinProfitCloseOrder = 20; // Min pip profit on action to close (and)

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions_Params__ = "-- Account conditions parameters --"; // >>> CONDITIONS & ACTIONS PARAMS <<<
extern int MarketSpecificHour = 3; // Specific hour used for conditions (0-23)
extern bool CloseConditionOnlyProfitable = 0; // Apply close condition only for profitable orders
extern int CloseConditionCustom1Method = 0; // Custom 1 indicator-based close condition (0-1023)
extern int CloseConditionCustom2Method = 0; // Custom 2 indicator-based close condition (0-1023)
extern int CloseConditionCustom3Method = 0; // Custom 3 indicator-based close condition (0-1023)
extern int CloseConditionCustom4Method = 0; // Custom 4 market-based close condition (0-1023)
extern int CloseConditionCustom5Method = 0; // Custom 5 market-based close condition (0-1023)
extern int CloseConditionCustom6Method = 0; // Custom 6 market-based close condition (0-1023)

//+------------------------------------------------------------------+
extern string __Experimental_Parameters__ = "-- Experimental parameters (not safe) --"; // >>> EXPERIMENTAL <<<
// Set stop loss to zero, once the order is profitable.
extern bool MinimalizeLosses = 0; // Minimalize losses?
int HourAfterPeak = 18; // Hour after peak
int ManualGMToffset = 0; // Manual GMT Offset
// How often trailing stop should be updated (in seconds). FIXME: Fix relative delay in backtesting.
int TrailingStopDelay = 0; // Trail stop delay (in secs)
// How often job list should be processed (in seconds).
int JobProcessDelay = 1; // Job process delay (in secs)
bool DynamicSpreadConf = false; // Dynamically calculate most optimal settings based on the current spread (MinPipChangeToTrade/MinPipGap).
int SpreadRatio = 1.0;

// Cache some calculated variables for better performance. FIXME: Needs some work.
#ifdef __experimental__
  extern bool Cache = false; // Cache
#else
  const bool Cache = false; // Cache
#endif

//+------------------------------------------------------------------+
extern string __Logging_Parameters__ = "-- Settings for logging & messages --"; // >>> LOGS & MESSAGES <<<
extern bool WriteReport = 1; // Write summary report on finish
extern bool PrintLogOnChart = 1; // Display info on chart
extern bool VerboseErrors = 1; // Display errors
extern bool VerboseInfo = 1; // Display info messages
#ifdef __debug__
  extern bool VerboseDebug = 0; // Display debug messages
  extern bool VerboseTrace = 0; // Display trace messages
#else
  bool VerboseDebug = 0;
  bool VerboseTrace = 0;
#endif

//+------------------------------------------------------------------+
extern string __UI_UX_Parameters__ = "-- Settings for User Interface & Experience --"; // >>> UI & UX <<<
extern bool SendEmailEachOrder = 0; // Send e-mail per each order
extern color ColorBuy = 16711680; // Color: Buy
extern color ColorSell = 255; // Color: Sell
extern bool SoundAlert = 0; // Enable sound alerts
extern string SoundFileAtOpen = "alert.wav"; // Sound: on order open
extern string SoundFileAtClose = "alert.wav"; // Sound: on order close
// extern bool SendLogs = false; // Send logs to remote host for diagnostic purposes
//+------------------------------------------------------------------+

extern string __Optimization_Parameters__ = "-- Optimization parameters --"; // >>> OPTIMIZATION <<<
extern ENUM_TIMEFRAMES TrendPeriod = PERIOD_H4; // Period for trend calculation

extern string __Backtest_Parameters__ = "-- Testing & troubleshooting parameters --"; // >>> TESTING <<<
#ifndef __backtest__
  extern bool ValidateSettings = 0; // Validate startup settings
#else
  extern bool ValidateSettings = 1; // Validate startup settings
#endif
extern bool RecordTicksToCSV = 0; // Record ticks into CSV files
extern int AccountConditionToDisable = 0; // Override: Disable specific n action
extern bool DisableCloseConditions = 0; // Override: Disable all close conditions
// extern int DemoMarketStopLevel = 10; // Demo market stop level

//+------------------------------------------------------------------+
extern string __EA_Constants__ = "-- Constants --"; // >>> CONSTANTS <<<
extern int MagicNumber = 31337; // Unique EA magic number (+40)

//+------------------------------------------------------------------+
extern string __Other_Parameters__ = "-- Other parameters --"; // >>> OTHER <<<
