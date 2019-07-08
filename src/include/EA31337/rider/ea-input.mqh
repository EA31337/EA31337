//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                       Copyright 2016-2019, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//|                                                     ea-input.mqh |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, kenorb" // ©
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| Includes.
//+------------------------------------------------------------------+
#include "..\ea-enums.mqh"

//+------------------------------------------------------------------+
//| User input variables.
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
extern string __Trade_Parameters__ = "-- Trade parameters --"; // >>> TRADE <<<
extern uint   MaxOrders = 0; // Max orders (0 = auto)
extern uint   MaxOrdersPerType = 0; // Max orders per type (0 = auto)
extern uint   MaxOrdersPerDay = 0; // Max orders per day (0 = unlimited)
extern double LotSize = 0; // Lot size (0 = auto)
extern int    LotSizeIncreaseMethod = 202; // Lot size increase method (0-255)
extern int    LotSizeDecreaseMethod = 167; // Lot size decrease method (0-255)
extern bool   TradeMicroLots = 1; // Trade micro lots?
extern int    MinVolumeToTrade = 2; // Min volume to trade
extern int    MaxOrderPriceSlippage = 50; // Max price slippage (in pts)
extern int    MaxTries = 5; // Max retries for opening orders
extern double MinPipChangeToTrade = 0.0; // Min pip change to trade
extern int    MinPipGap = 10; // Min gap between trades per type (in pips)
extern int    MinIntervalSec = 0; // Min interval between subsequent trade signals (in sec)
//extern uint   TickProcessMethod = 0; // Tick process method (0-8, 0 - all)

//+------------------------------------------------------------------+
extern string   __EA_Order_Parameters__ = "-- Profit and loss parameters --"; // >>> PROFIT/LOSS <<<
extern uint     TakeProfitMax = 0; // Max Take profit (in pips, 0 = auto)
extern uint     StopLossMax = 40; // Max Stop loss (in pips, 0 = auto)

//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Profit and loss trailing parameters --"; // >>> TRAILINGS <<<
extern ENUM_TRAIL_TYPE DefaultTrailingStopMethod = 0; // Default trail stop method (0 = none)
extern int TrailingStop = 50; // Extra trailing stop (in pips)
extern ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = 0; // Default trail profit method
extern int TrailingProfit = 0; // Extra trailing profit (in pips)
extern double TrailingStopAddPerMinute = 0.1; // Decrease trail stop per minute (pip/min)

//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management parameters --"; // >>> RISK <<
extern double RiskMarginPerOrder = 1; // Risk margin per order (in %, 0-100, 0 - auto, -1 - off)
extern double RiskMarginTotal = 10; // Risk margin in total (in %, 0-100, 0 - auto, -1 - off)
extern double RiskRatio = 0; // Risk ratio (0 = auto, 1.0 = normal)
extern int RiskRatioIncreaseMethod = 0; // Risk ratio increase method (0-255)
extern int RiskRatioDecreaseMethod = 0; // Risk ratio decrease method (0-255)
extern int InitNoOfDaysToWarmUp = 21; // Initial warm-up period (in days)
extern int CloseOrderAfterXHours = 96; // Close order after X hours (>0 - only profitable, <0 - all, 0 - off)

extern bool ApplySpreadLimits = true; // Apply strategy spread limits
extern double MaxSpreadToTrade = 10.0; // Max spread to trade (in pips), 0 - disable limit

//+------------------------------------------------------------------+
extern string __Strategy_Parameters__ = "-- Per strategy parameters (0 to disable) --"; // >>> STRATEGIES <<<
extern double ProfitFactorMinToTrade = 0.9; // Min. profit factor per strategy to trade
extern double ProfitFactorMaxToTrade = 0; // Max. profit factor per strategy to trade
extern int InitNoOfOrdersToCalcPF = 20; // Initial number of orders to calculate profit factor

//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting parameters (set 1.0 for default) --"; // >>> BOOSTING <<<
extern bool Boosting_Enabled = 1; // Enable boosting
extern double BoostTrendFactor = 1.1; // Boost by trend factor
extern bool StrategyBoostByPF = 1.1; // Boost strategy by its profit factor
extern bool StrategyHandicapByPF = true; // Handicap by its low profit factor
extern double BestDailyStrategyMultiplierFactor = 0.8; // Multiplier for the best daily strategy
extern double BestWeeklyStrategyMultiplierFactor = 0.7; // Multiplier for the best weekly strategy
extern double BestMonthlyStrategyMultiplierFactor = 0.6; // Multiplier for the best monthly strategy
extern double WorseDailyStrategyMultiplierFactor = 0.9; // Multiplier for the worse daily strategy
extern double WorseWeeklyStrategyMultiplierFactor = 0.8; // Multiplier for the worse weekly strategy
extern double WorseMonthlyStrategyMultiplierFactor = 0.7; // Multiplier for the worse monthly strategy
extern double ConWinsIncreaseFactor = 0.4; // Increase lot factor on consequent wins (in %, 0 - off)
extern double ConLossesIncreaseFactor = 0.7; // Increase lot factor on consequent loses (in %, 0 - off)
extern uint ConFactorOrdersLimit = 600; // No of orders to check on consequent wins/loses

//+------------------------------------------------------------------+
extern string __SmartQueue_Parameters__ = "-- Smart queue parameters --"; // >>> SMART QUEUE <<<
extern bool SmartQueueActive = 1; // Activate QueueAI
extern int SmartQueueMethod = 14; // QueueAI: Method for selecting the best order (0-15)
extern int SmartQueueFilter = 112; // QueueAI: Method for filtering the orders (0-255)

//+------------------------------------------------------------------+
// extern string __Advanced_Parameters__ = "-- Advanced parameters --"; // >>> ADVANCED <<<

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions__ = "-- Account conditions --"; // >>> CONDITIONS & ACTIONS <<<
// Note: It's not advice to use on accounts where multi bots are trading.
extern bool Account_Conditions_Active = 1; // Enable account conditions
// 5 - Equity 1% high
extern ENUM_ACC_CONDITION Account_Condition_1 = 5; // 1. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_1 = 2; // 1. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_1 = 1; // 1. Action to take
// 6 - Equity 1%
extern ENUM_ACC_CONDITION Account_Condition_2 = 6; // 2. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_2 = 1; // 2. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_2 = 3; // 2. Action to take
// 10 - 20% Margin Used
extern ENUM_ACC_CONDITION Account_Condition_3 = 10; // 3. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_3 = 1; // 3. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_3 = 0; // 3. Action to take
// 17 - Max. daily balance < max. weekly
extern ENUM_ACC_CONDITION Account_Condition_4 = 17; // 4. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_4 = 9; // 4. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_4 = 8; // 4. Action to take
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
extern bool CloseConditionOnlyProfitable = true; // Apply close condition only for profitable orders
extern int CloseConditionCustom1Method = 0; // Custom 1 indicator-based close condition (0-1023)
extern int CloseConditionCustom2Method = 0; // Custom 2 indicator-based close condition (0-1023)
extern int CloseConditionCustom3Method = 0; // Custom 3 indicator-based close condition (0-1023)
extern int CloseConditionCustom4Method = 0; // Custom 4 market-based close condition (0-1023)
extern int CloseConditionCustom5Method = 0; // Custom 5 market-based close condition (0-1023)
extern int CloseConditionCustom6Method = 0; // Custom 6 market-based close condition (0-1023)

//+------------------------------------------------------------------+
string __AC_Parameters__ = "-- Settings for the Bill Williams' Accelerator/Decelerator oscillator --"; // >>> AC (NOT IMPLEMENTED YET) <<<
bool AC1_Active = 0; // Enable for M1
bool AC5_Active = 0; // Enable on M5
bool AC15_Active = 0; // Enable on M15
bool AC30_Active = 0; // Enable on M30
ENUM_TRAIL_TYPE AC_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE AC_TrailingProfitMethod = 1; // Trail profit method
double AC_SignalLevel = 0.00000000; // Signal level
int AC1_SignalMethod = 0; // Signal method for M1 (0-?)
int AC5_SignalMethod = 0; // Signal method for M5 (0-?)
int AC15_SignalMethod = 0; // Signal method for M15 (0-?)
int AC30_SignalMethod = 0; // Signal method for M30 (0-?)
int AC1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int AC1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT AC1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int AC5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int AC5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT AC5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int AC15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int AC15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT AC15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int AC30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int AC30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT AC30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double AC1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double AC5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double AC15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double AC30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __AD_Parameters__ = "-- Settings for the Accumulation/Distribution indicator --"; // >>> AD (NOT IMPLEMENTED YET) <<<
bool AD1_Active = 0; // Enable for M1
bool AD5_Active = 0; // Enable for M5
bool AD15_Active = 0; // Enable for M15
bool AD30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE AD_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE AD_TrailingProfitMethod = T_NONE; // Trail profit method
double AD_SignalLevel = 0.00000000; // Signal level
int AD1_SignalMethod = 0; // Signal method for M1 (0-?)
int AD5_SignalMethod = 0; // Signal method for M5 (0-?)
int AD15_SignalMethod = 0; // Signal method for M15 (0-?)
int AD30_SignalMethod = 0; // Signal method for M30 (0-?)
int AD1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int AD1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT AD1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int AD5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int AD5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT AD5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int AD15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int AD15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT AD15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int AD30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int AD30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT AD30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double AD1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double AD5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double AD15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double AD30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __ADX_Parameters__ = "-- Settings for the Average Directional Movement Index indicator --"; // >>> ADX (NOT IMPLEMENTED YET) <<<
bool ADX1_Active = 0; // Enable for M1
bool ADX5_Active = 0; // Enable for M5
bool ADX15_Active = 0; // Enable for M15
bool ADX30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE ADX_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE ADX_TrailingProfitMethod = T_NONE; // Trail profit method
int ADX_Period = 14; // Period
ENUM_APPLIED_PRICE ADX_Applied_Price = 2; // Applied Price
double ADX_SignalLevel = 0.00000000; // Signal level
int ADX1_SignalMethod = 0; // Signal method for M1 (0-?)
int ADX5_SignalMethod = 0; // Signal method for M5 (0-?)
int ADX15_SignalMethod = 0; // Signal method for M15 (0-?)
int ADX30_SignalMethod = 0; // Signal method for M30 (0-?)
int ADX1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int ADX1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ADX1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int ADX5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int ADX5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ADX5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int ADX15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int ADX15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ADX15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int ADX30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int ADX30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ADX30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double ADX1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double ADX5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double ADX15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double ADX30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --"; // >>> ALLIGATOR <<<
extern bool Alligator1_Active = 0; // Enable for M1
extern bool Alligator5_Active = 1; // Enable for M5
extern bool Alligator15_Active = 0; // Enable for M15
extern bool Alligator30_Active = 1; // Enable for M30
extern int Alligator_Period_Jaw = 6; // Jaw Period
extern int Alligator_Period_Teeth = 10; // Teeth Period
extern int Alligator_Period_Lips = 8; // Lips Period
extern int Alligator_Shift_Jaw = 5; // Jaw Shift
extern int Alligator_Shift_Teeth = 7; // Teeth Shift
extern int Alligator_Shift_Lips = 5; // Lips Shift
extern ENUM_MA_METHOD Alligator_MA_Method = 2; // MA Method
extern ENUM_APPLIED_PRICE Alligator_Applied_Price = 3; // Applied Price
extern int Alligator_Shift = 2; // Shift
extern ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = -8; // Trail stop method
extern ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = -24; // Trail profit method
extern double Alligator_SignalLevel = 0; // Signal level
extern int Alligator1_SignalMethod = 19; // Signal method for M1 (-63-63)
extern int Alligator5_SignalMethod = 27; // Signal method for M5 (-63-63)
extern int Alligator15_SignalMethod = 20; // Signal method for M15 (-63-63)
extern int Alligator30_SignalMethod = 16; // Signal method for M30 (-63-63)
extern int Alligator1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
extern int Alligator1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT Alligator1_CloseCondition = C_MA_BUY_SELL; // Close condition for M1
//
extern int Alligator5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
extern int Alligator5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT Alligator5_CloseCondition = C_MA_BUY_SELL; // Close condition for M5
//
extern int Alligator15_OpenCondition1 = 0; // Open condition 1 for M15 (0-1023)
extern int Alligator15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT Alligator15_CloseCondition = C_MA_BUY_SELL; // Close condition for M15
//
extern int Alligator30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
extern int Alligator30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT Alligator30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
//
extern double Alligator1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double Alligator5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double Alligator15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double Alligator30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __ATR_Parameters__ = "-- Settings for the Average True Range indicator --"; // >>> ATR <<<
bool ATR1_Active = 0; // Enable for M1
bool ATR5_Active = 0; // Enable for M5
bool ATR15_Active = 0; // Enable for M15
bool ATR30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE ATR_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE ATR_TrailingProfitMethod = T_NONE; // Trail profit method
int ATR_Period = 14; // Period.
double ATR_SignalLevel = 0.00000000; // Signal level
int ATR1_SignalMethod = 0; // Signal method for M1 (0-31)
int ATR5_SignalMethod = 0; // Signal method for M5 (0-31)
int ATR15_SignalMethod = 0; // Signal method for M15 (0-31)
int ATR30_SignalMethod = 0; // Signal method for M30 (0-31)
int ATR1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int ATR1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ATR1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int ATR5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int ATR5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ATR5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int ATR15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int ATR15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ATR15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int ATR30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int ATR30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ATR30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double ATR1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double ATR5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double ATR15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double ATR30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Awesome_Parameters__ = "-- Settings for the Awesome oscillator --"; // >>> AWESOME <<<
bool Awesome1_Active = 0; // Enable for M1
bool Awesome5_Active = 0; // Enable for M5
bool Awesome15_Active = 0; // Enable for M15
bool Awesome30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Awesome_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE Awesome_TrailingProfitMethod = T_NONE; // Trail profit method
double Awesome_SignalLevel = 0.00000000; // Signal level
int Awesome1_SignalMethod = 0; // Signal method for M1 (0-31)
int Awesome5_SignalMethod = 0; // Signal method for M5 (0-31)
int Awesome15_SignalMethod = 0; // Signal method for M15 (0-31)
int Awesome30_SignalMethod = 0; // Signal method for M30 (0-31)
int Awesome1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Awesome1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Awesome1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int Awesome5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Awesome5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Awesome5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int Awesome15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Awesome15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Awesome15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int Awesome30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Awesome30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Awesome30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double Awesome1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Awesome5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Awesome15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Awesome30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --"; // >>> BANDS <<<
extern bool Bands1_Active = 1; // Enable for M1
extern bool Bands5_Active = 1; // Enable for M5
extern bool Bands15_Active = 1; // Enable for M15
extern bool Bands30_Active = 1; // Enable for M30
extern int Bands_Period = 18; // Period
extern ENUM_APPLIED_PRICE Bands_Applied_Price = 3; // Applied Price
extern double Bands_Deviation = 2.3; // Deviation
extern int Bands_Shift = 3; // Shift
extern ENUM_TRAIL_TYPE Bands_TrailingStopMethod = 7; // Trail stop method
extern ENUM_TRAIL_TYPE Bands_TrailingProfitMethod = 25; // Trail profit method
extern int Bands_SignalLevel = 0; // Signal level
extern int Bands1_SignalMethod = -85; // Signal method for M1 (-127-127)
extern int Bands5_SignalMethod = -74; // Signal method for M5 (-127-127)
extern int Bands15_SignalMethod = -127; // Signal method for M15 (-127-127)
extern int Bands30_SignalMethod = -127; // Signal method for M30 (-127-127)
extern int Bands1_OpenCondition1 = 528; // Open condition 1 for M1 (0-1023)
extern int Bands1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT Bands1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
extern int Bands5_OpenCondition1 = 528; // Open condition 1 for M5 (0-1023)
extern int Bands5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT Bands5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
extern int Bands15_OpenCondition1 = 0; // Open condition 1 for M15 (0-1023)
extern int Bands15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT Bands15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
extern int Bands30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
extern int Bands30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT Bands30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
extern double Bands1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double Bands5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double Bands15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double Bands30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __BearsPower_Parameters__ = "-- Settings for the Bears Power indicator --"; // >>> BULLS/BEARS POWER <<<
bool BearsPower1_Active = 0; // Enable for M1
bool BearsPower5_Active = 0; // Enable for M5
bool BearsPower15_Active = 0; // Enable for M15
bool BearsPower30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE BearsPower_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BearsPower_TrailingProfitMethod = 1; // Trail profit method
int BearsPower_Period = 13; // Period
ENUM_APPLIED_PRICE BearsPower_Applied_Price = PRICE_CLOSE; // Applied Price
double BearsPower_SignalLevel = 0.00000000; // Signal level
int BearsPower1_SignalMethod = 0; // Signal method for M1 (0-
int BearsPower5_SignalMethod = 0; // Signal method for M5 (0-
int BearsPower15_SignalMethod = 0; // Signal method for M15 (0-
int BearsPower30_SignalMethod = 0; // Signal method for M30 (0-
int BearsPower1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int BearsPower1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BearsPower1_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M1
int BearsPower5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int BearsPower5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BearsPower5_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M5
int BearsPower15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int BearsPower15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BearsPower15_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M15
int BearsPower30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int BearsPower30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BearsPower30_CloseCondition = C_BEARSPOWER_BUY_SELL; // Close condition for M30
double BearsPower1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BearsPower5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BearsPower15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BearsPower30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __BullsPower_Parameters__ = "-- Settings for the Bulls Power indicator --"; // >>> BULLS/BEARS POWER <<<
bool BullsPower1_Active = 0; // Enable for M1
bool BullsPower5_Active = 0; // Enable for M5
bool BullsPower15_Active = 0; // Enable for M15
bool BullsPower30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE BullsPower_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BullsPower_TrailingProfitMethod = 1; // Trail profit method
int BullsPower_Period = 13; // Period
ENUM_APPLIED_PRICE BullsPower_Applied_Price = PRICE_CLOSE; // Applied Price
double BullsPower_SignalLevel = 0.00000000; // Signal level
int BullsPower1_SignalMethod = 0; // Signal method for M1 (0-
int BullsPower5_SignalMethod = 0; // Signal method for M5 (0-
int BullsPower15_SignalMethod = 0; // Signal method for M15 (0-
int BullsPower30_SignalMethod = 0; // Signal method for M30 (0-
int BullsPower1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int BullsPower1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BullsPower1_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M1
int BullsPower5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int BullsPower5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BullsPower5_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M5
int BullsPower15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int BullsPower15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BullsPower15_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M15
int BullsPower30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int BullsPower30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BullsPower30_CloseCondition = C_BULLSPOWER_BUY_SELL; // Close condition for M30
double BullsPower1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BullsPower5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BullsPower15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BullsPower30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __BWMFI_Parameters__ = "-- Settings for the Market Facilitation Index indicator --"; // >>> BWMFI <<<
bool BWMFI1_Active = 0; // Enable for M1
bool BWMFI5_Active = 0; // Enable for M5
bool BWMFI15_Active = 0; // Enable for M15
bool BWMFI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE BWMFI_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE BWMFI_TrailingProfitMethod = T_NONE; // Trail profit method
double BWMFI_SignalLevel = 0.00000000; // Signal level
int BWMFI1_SignalMethod = 0; // Signal method for M1 (0-
int BWMFI5_SignalMethod = 0; // Signal method for M5 (0-
int BWMFI15_SignalMethod = 0; // Signal method for M15 (0-
int BWMFI30_SignalMethod = 0; // Signal method for M30 (0-
int BWMFI1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int BWMFI1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BWMFI1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int BWMFI5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int BWMFI5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BWMFI5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int BWMFI15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int BWMFI15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BWMFI15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int BWMFI30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int BWMFI30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BWMFI30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double BWMFI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BWMFI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BWMFI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BWMFI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __CCI_Parameters__ = "-- Settings for the Commodity Channel Index indicator --"; // >>> CCI <<<
extern bool CCI1_Active = 0; // Enable for M1
extern bool CCI5_Active = 0; // Enable for M5
extern bool CCI15_Active = 1; // Enable for M15
extern bool CCI30_Active = 1; // Enable for M30
extern int CCI_Shift = 0; // Shift (0 for default)
extern ENUM_TRAIL_TYPE CCI_TrailingStopMethod = 5; // Trail stop method
extern ENUM_TRAIL_TYPE CCI_TrailingProfitMethod = 12; // Trail profit method
extern int CCI_Period = 28; // Period
extern ENUM_APPLIED_PRICE CCI_Applied_Price = 2; // Applied Price
extern double CCI_SignalLevel = 98; // Signal level (100 by default)
extern int CCI1_SignalMethod = 34; // Signal method for M1 (0-63)
extern int CCI5_SignalMethod = 18; // Signal method for M5 (0-63)
extern int CCI15_SignalMethod = 0; // Signal method for M15 (0-63)
extern int CCI30_SignalMethod = -44; // Signal method for M30 (0-63)
extern int CCI1_OpenCondition1 = 971; // Open condition 1 for M1 (0-1023)
extern int CCI1_OpenCondition2 = 1; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT CCI1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

extern int CCI5_OpenCondition1 = 1; // Open condition 1 for M5 (0-1023)
extern int CCI5_OpenCondition2 = 1; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT CCI5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

extern int CCI15_OpenCondition1 = 1; // Open condition 1 for M15 (0-1023)
extern int CCI15_OpenCondition2 = 1; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT CCI15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

extern int CCI30_OpenCondition1 = 1; // Open condition 1 for M30 (0-1023)
extern int CCI30_OpenCondition2 = 1; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT CCI30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double CCI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double CCI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double CCI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double CCI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --"; // >>> DEMARKER <<<
extern bool DeMarker1_Active = 0; // Enable for M1
extern bool DeMarker5_Active = 0; // Enable for M5
extern bool DeMarker15_Active = 0; // Enable for M15
extern bool DeMarker30_Active = 0; // Enable for M30
extern int DeMarker_Period = 2; // Period
extern int DeMarker_Shift = 5; // Shift
extern double DeMarker_SignalLevel = -0.7; // Signal level (0.0-0.4)
extern ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = 24; // Trail stop method
extern ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = 20; // Trail profit method
extern int DeMarker1_SignalMethod = 12; // Signal method for M1 (-31-31)
extern int DeMarker5_SignalMethod = 12; // Signal method for M5 (-31-31)
extern int DeMarker15_SignalMethod = 4; // Signal method for M15 (-31-31)
extern int DeMarker30_SignalMethod = 12; // Signal method for M30 (-31-31)
extern int DeMarker1_OpenCondition1 = 528; // Open condition 1 for M1 (0-1023)
extern int DeMarker1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT DeMarker1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
//
extern int DeMarker5_OpenCondition1 = 528; // Open condition 1 for M5 (0-1023)
extern int DeMarker5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT DeMarker5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
//
extern int DeMarker15_OpenCondition1 = 528; // Open condition 1 for M15 (0-1023)
extern int DeMarker15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT DeMarker15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
//
extern int DeMarker30_OpenCondition1 = 528; // Open condition 1 for M30 (0-1023)
extern int DeMarker30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT DeMarker30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
//
extern double DeMarker1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double DeMarker5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double DeMarker15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double DeMarker30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --"; // >>> ENVELOPES <<<
extern bool Envelopes1_Active = 0; // Enable for M1
extern bool Envelopes5_Active = 0; // Enable for M5
extern bool Envelopes15_Active = 0; // Enable for M15
extern bool Envelopes30_Active = 1; // Enable for M30
extern int Envelopes_MA_Period = 30; // Period
extern ENUM_MA_METHOD Envelopes_MA_Method = 0; // MA Method
extern int Envelopes_MA_Shift = 2; // MA Shift
extern ENUM_APPLIED_PRICE Envelopes_Applied_Price = 2; // Applied Price
extern double Envelopes_Deviation = 0.5; // Deviation for M1
extern int Envelopes_Shift = 2; // Shift
extern ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = 19; // Trail stop method
extern ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = -2; // Trail profit method
/* @todo extern */ int Envelopes_SignalLevel = 0; // Signal level
extern int Envelopes1_SignalMethod = -88; // Signal method for M1 (-127-127)
extern int Envelopes5_SignalMethod = -88; // Signal method for M5 (-127-127)
extern int Envelopes15_SignalMethod = -12; // Signal method for M15 (-127-127)
extern int Envelopes30_SignalMethod = -76; // Signal method for M30 (-127-127)
extern int Envelopes1_OpenCondition1 = 528; // Open condition 1 for M1 (0-1023)
extern int Envelopes1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT Envelopes1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
//
extern int Envelopes5_OpenCondition1 = 528; // Open condition 1 for M5 (0-1023)
extern int Envelopes5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT Envelopes5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
//
extern int Envelopes15_OpenCondition1 = 528; // Open condition 1 for M15 (0-1023)
extern int Envelopes15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT Envelopes15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
//
extern int Envelopes30_OpenCondition1 = 528; // Open condition 1 for M30 (0-1023)
extern int Envelopes30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT Envelopes30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
//
extern double Envelopes1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double Envelopes5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double Envelopes15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double Envelopes30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Force_Parameters__ = "-- Settings for the Force Index indicator --"; // >>> FORCE <<<
bool Force1_Active = 0; // Enable for M1
bool Force5_Active = 0; // Enable for M5
bool Force15_Active = 0; // Enable for M15
bool Force30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Force_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Force_TrailingProfitMethod = 1; // Trail profit method
int Force_Period = 13; // Period
ENUM_MA_METHOD Force_MA_Method = 0; // MA Method
ENUM_APPLIED_PRICE Force_Applied_price = PRICE_CLOSE; // Applied Price
double Force_SignalLevel = 0.00000000; // Signal level
int Force1_SignalMethod = 0; // Signal method for M1 (0-
int Force5_SignalMethod = 0; // Signal method for M5 (0-
int Force15_SignalMethod = 0; // Signal method for M15 (0-
int Force30_SignalMethod = 0; // Signal method for M30 (0-
int Force1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Force1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Force1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int Force5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Force5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Force5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int Force15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Force15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Force15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int Force30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Force30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Force30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double Force1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Force5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Force15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Force30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --"; // >>> FRACTALS <<<
extern bool Fractals1_Active = 0; // Enable for M1
extern bool Fractals5_Active = 0; // Enable for M5
extern bool Fractals15_Active = 0; // Enable for M15
extern bool Fractals30_Active = 0; // Enable for M30
extern int Fractals_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = 1; // Trail stop method
extern ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = -3; // Trail profit method
/* @todo extern */ int Fractals_SignalLevel = 0; // Signal level
extern int Fractals1_SignalMethod = 3; // Signal method for M1 (-3-3)
extern int Fractals5_SignalMethod = 3; // Signal method for M5 (-3-3)
extern int Fractals15_SignalMethod = 1; // Signal method for M15 (-3-3)
extern int Fractals30_SignalMethod = -2; // Signal method for M30 (-3-3)
extern int Fractals1_OpenCondition1 = 528; // Open condition 1 for M1 (0-1023)
extern int Fractals1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
extern ENUM_MARKET_EVENT Fractals1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
//
extern int Fractals5_OpenCondition1 = 528; // Open condition 1 for M5 (0-1023)
extern int Fractals5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
extern ENUM_MARKET_EVENT Fractals5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
//
extern int Fractals15_OpenCondition1 = 528; // Open condition 1 for M15 (0-)
extern int Fractals15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
extern ENUM_MARKET_EVENT Fractals15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
//
extern int Fractals30_OpenCondition1 = 528; // Open condition 1 for M30 (0-)
extern int Fractals30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
extern ENUM_MARKET_EVENT Fractals30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
//
extern double Fractals1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double Fractals5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double Fractals15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double Fractals30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Gator_Parameters__ = "-- Settings for the Gator oscillator --"; // >>> GATOR <<<
bool Gator1_Active = 0; // Enable for M1
bool Gator5_Active = 0; // Enable for M5
bool Gator15_Active = 0; // Enable for M15
bool Gator30_Active = 0; // Enable for M30
int Gator_Period_Jaw = 6; // Jaw Period
int Gator_Period_Teeth = 10; // Teeth Period
int Gator_Period_Lips = 8; // Lips Period
int Gator_Shift_Jaw = 5; // Jaw Shift
int Gator_Shift_Teeth = 7; // Teeth Shift
int Gator_Shift_Lips = 5; // Lips Shift
ENUM_MA_METHOD Gator_MA_Method = 2; // MA Method
ENUM_APPLIED_PRICE Gator_Applied_Price = 3; // Applied Price
int Gator_Shift = 2; // Shift
ENUM_TRAIL_TYPE Gator_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE Gator_TrailingProfitMethod = T_NONE; // Trail profit method
double Gator_SignalLevel = 0.00000000; // Signal level
int Gator1_SignalMethod = 0; // Signal method for M1 (0-
int Gator5_SignalMethod = 0; // Signal method for M5 (0-
int Gator15_SignalMethod = 0; // Signal method for M15 (0-
int Gator30_SignalMethod = 0; // Signal method for M30 (0-
int Gator1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Gator1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Gator1_CloseCondition = C_MACD_BUY_SELL; // Close condition // Close condition for M1

int Gator5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Gator5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Gator5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int Gator15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Gator15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Gator15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int Gator30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Gator30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Gator30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double Gator1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Gator5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Gator15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Gator30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Ichimoku_Parameters__ = "-- Settings for the Ichimoku Kinko Hyo indicator --"; // >>> ICHIMOKU <<<
bool Ichimoku1_Active = 0; // Enable for M1
bool Ichimoku5_Active = 0; // Enable for M5
bool Ichimoku15_Active = 0; // Enable for M15
bool Ichimoku30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Ichimoku_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE Ichimoku_TrailingProfitMethod = T_NONE; // Trail profit method
int Ichimoku_Period_Tenkan_Sen = 9; // Period Tenkan Sen
int Ichimoku_Period_Kijun_Sen = 26; // Period Kijun Sen
int Ichimoku_Period_Senkou_Span_B = 52; // Period Senkou Span B
double Ichimoku_SignalLevel = 0.00000000; // Signal level
int Ichimoku1_SignalMethod = 0; // Signal method for M1 (0-
int Ichimoku5_SignalMethod = 0; // Signal method for M5 (0-
int Ichimoku15_SignalMethod = 0; // Signal method for M15 (0-
int Ichimoku30_SignalMethod = 0; // Signal method for M30 (0-
int Ichimoku1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Ichimoku1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Ichimoku1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int Ichimoku5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Ichimoku5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Ichimoku5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int Ichimoku15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Ichimoku15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Ichimoku15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int Ichimoku30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Ichimoku30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Ichimoku30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double Ichimoku1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Ichimoku5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Ichimoku15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Ichimoku30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __MA_Parameters__ = "-- Settings for the Moving Average indicator --"; // >>> MA <<<
extern bool MA1_Active = 1; // Enable for M1
extern bool MA5_Active = 0; // Enable for M5
extern bool MA15_Active = 0; // Enable for M15
extern bool MA30_Active = 0; // Enable for M30
extern int MA_Period_Fast = 12; // Period Fast
extern int MA_Period_Medium = 12; // Period Medium
extern int MA_Period_Slow = 4; // Period Slow
extern int MA_Shift = 8; // Shift
extern int MA_Shift_Fast = 10; // Shift Fast (+1)
extern int MA_Shift_Medium = 10; // Shift Medium (+1)
extern int MA_Shift_Slow = 5; // Shift Slow (+1)
extern ENUM_MA_METHOD MA_Method = 1; // MA Method
extern ENUM_APPLIED_PRICE MA_Applied_Price = 6; // Applied Price
extern ENUM_TRAIL_TYPE MA_TrailingStopMethod = 25; // Trail stop method
extern ENUM_TRAIL_TYPE MA_TrailingProfitMethod = 13; // Trail profit method
extern double MA_SignalLevel = -0.6; // Signal level
extern int MA1_SignalMethod = -118; // Signal method for M1 (-127-127)
extern int MA5_SignalMethod = 32; // Signal method for M5 (-127-127)
extern int MA15_SignalMethod = -127; // Signal method for M15 (-127-127)
extern int MA30_SignalMethod = -127; // Signal method for M30 (-127-127)
extern int MA1_OpenCondition1 = 512; // Open condition 1 for M1 (0-1023)
extern int MA1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT MA1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
//
extern int MA5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
extern int MA5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT MA5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
//
extern int MA15_OpenCondition1 = 0; // Open condition 1 for M15 (0-1023)
extern int MA15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT MA15_CloseCondition = C_MA_BUY_SELL; // Close condition for M15
//
extern int MA30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
extern int MA30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT MA30_CloseCondition = C_MA_BUY_SELL; // Close condition for M30
//
extern double MA1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double MA5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double MA15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double MA30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --"; // >>> MACD <<<
extern bool MACD1_Active = 1; // Enable for M1
extern bool MACD5_Active = 0; // Enable for M5
extern bool MACD15_Active = 1; // Enable for M15
extern bool MACD30_Active = 0; // Enable for M30
extern int MACD_Period_Fast = 15; // Period Fast
extern int MACD_Period_Slow = 29; // Period Slow
extern int MACD_Period_Signal = 10; // Period for signal
extern ENUM_APPLIED_PRICE MACD_Applied_Price = 2; // Applied Price
extern int MACD_Shift = 3; // Shift
extern ENUM_TRAIL_TYPE MACD_TrailingStopMethod = -1; // Trail stop method
extern ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = -19; // Trail profit method
extern double MACD_SignalLevel = -0.3; // Signal level
extern int MACD1_SignalMethod = -26; // Signal method for M1 (-31-31)
extern int MACD5_SignalMethod = -31; // Signal method for M5 (-31-31)
extern int MACD15_SignalMethod = -25; // Signal method for M15 (-31-31)
extern int MACD30_SignalMethod = 4; // Signal method for M30 (-31-31)
extern int MACD1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
extern int MACD1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT MACD1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
//
extern int MACD5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
extern int MACD5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT MACD5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
//
extern int MACD15_OpenCondition1 = 0; // Open condition 1 for M15 (0-1023)
extern int MACD15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT MACD15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
//
extern int MACD30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
extern int MACD30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT MACD30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
//
extern double MACD1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double MACD5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double MACD15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double MACD30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __MFI_Parameters__ = "-- Settings for the Money Flow Index indicator --"; // >>> MFI <<<
bool MFI1_Active = 0; // Enable for M1
bool MFI5_Active = 0; // Enable for M5
bool MFI15_Active = 0; // Enable for M15
bool MFI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE MFI_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE MFI_TrailingProfitMethod = T_NONE; // Trail profit method
int MFI_Period = 14; // Period
double MFI_SignalLevel = 0.00000000; // Signal level
int MFI1_SignalMethod = 0; // Signal method for M1 (0-
int MFI5_SignalMethod = 0; // Signal method for M5 (0-
int MFI15_SignalMethod = 0; // Signal method for M15 (0-
int MFI30_SignalMethod = 0; // Signal method for M30 (0-
int MFI1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int MFI1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT MFI1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int MFI5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int MFI5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT MFI5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int MFI15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int MFI15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT MFI15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int MFI30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int MFI30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT MFI30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double MFI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double MFI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double MFI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double MFI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Momentum_Parameters__ = "-- Settings for the Momentum indicator --"; // >>> MOMENTUM <<<
bool Momentum1_Active = 0; // Enable for M1
bool Momentum5_Active = 0; // Enable for M5
bool Momentum15_Active = 0; // Enable for M15
bool Momentum30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Momentum_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE Momentum_TrailingProfitMethod = T_NONE; // Trail profit method
int Momentum_Period = 12; // Period Fast
ENUM_APPLIED_PRICE Momentum_Applied_Price = 0; // Applied Price
double Momentum_SignalLevel = 0.00000000; // Signal level
int Momentum1_SignalMethod = 0; // Signal method for M1 (0-
int Momentum5_SignalMethod = 0; // Signal method for M5 (0-
int Momentum15_SignalMethod = 0; // Signal method for M15 (0-
int Momentum30_SignalMethod = 0; // Signal method for M30 (0-
int Momentum1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Momentum1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT Momentum1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
int Momentum5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Momentum5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Momentum5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int Momentum15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Momentum15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Momentum15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int Momentum30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Momentum30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Momentum30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double Momentum1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Momentum5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Momentum15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Momentum30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __OBV_Parameters__ = "-- Settings for the On Balance Volume indicator --"; // >>> OBV <<<
bool OBV1_Active = 0; // Enable for M1
bool OBV5_Active = 0; // Enable for M5
bool OBV15_Active = 0; // Enable for M15
bool OBV30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE OBV_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE OBV_TrailingProfitMethod = T_NONE; // Trail profit method
ENUM_APPLIED_PRICE OBV_Applied_Price = 0; // Applied Price
double OBV_SignalLevel = 0.00000000; // Signal level
int OBV1_SignalMethod = 0; // Signal method for M1 (0-
int OBV5_SignalMethod = 0; // Signal method for M5 (0-
int OBV15_SignalMethod = 0; // Signal method for M15 (0-
int OBV30_SignalMethod = 0; // Signal method for M30 (0-
int OBV1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int OBV1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT OBV1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int OBV5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int OBV5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT OBV5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int OBV15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int OBV15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT OBV15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int OBV30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int OBV30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT OBV30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double OBV1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double OBV5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double OBV15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double OBV30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __OSMA_Parameters__ = "-- Settings for the Moving Average of Oscillator indicator --"; // >>> OSMA <<<
bool OSMA1_Active = 0; // Enable for M1
bool OSMA5_Active = 0; // Enable for M5
bool OSMA15_Active = 0; // Enable for M15
bool OSMA30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE OSMA_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE OSMA_TrailingProfitMethod = T_NONE; // Trail profit method
int OSMA_Period_Fast = 12; // Period Fast
int OSMA_Period_Slow = 26; // Period Slow
int OSMA_Period_Signal = 9; // Period for signal
ENUM_APPLIED_PRICE OSMA_Applied_Price = 1; // Applied Price
double OSMA_SignalLevel = 0.00000000; // Signal level
int OSMA1_SignalMethod = 0; // Signal method for M1 (0-
int OSMA5_SignalMethod = 0; // Signal method for M5 (0-
int OSMA15_SignalMethod = 0; // Signal method for M15 (0-
int OSMA30_SignalMethod = 0; // Signal method for M30 (0-
int OSMA1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int OSMA1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT OSMA1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int OSMA5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int OSMA5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT OSMA5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int OSMA15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int OSMA15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT OSMA15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int OSMA30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int OSMA30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT OSMA30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double OSMA1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double OSMA5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double OSMA15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double OSMA30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --"; // >>> RSI <<<
extern bool RSI1_Active = 0; // Enable for M1
extern bool RSI5_Active = 1; // Enable for M5
extern bool RSI15_Active = 1; // Enable for M15
extern bool RSI30_Active = 1; // Enable for M30
extern int RSI_Period = 16; // Period
extern ENUM_APPLIED_PRICE RSI_Applied_Price = 3; // Applied Price
extern uint RSI_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE RSI_TrailingStopMethod = 24; // Trail stop method
extern ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = 4; // Trail profit method
extern int RSI_SignalLevel = 26; // Signal level (-49-49)
extern int RSI1_SignalMethod = -63; // Signal method for M1 (-63-63)
extern int RSI5_SignalMethod = -61; // Signal method for M5 (-63-63)
extern int RSI15_SignalMethod = -63; // Signal method for M15 (-63-63)
extern int RSI30_SignalMethod = 0; // Signal method for M30 (-63-63)

extern int RSI1_OpenCondition1 = 971; // Open condition 1 for M1 (0-1023)
extern int RSI1_OpenCondition2 = 1; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT RSI1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

extern int RSI5_OpenCondition1 = 1; // Open condition 1 for M5 (0-1023)
extern int RSI5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT RSI5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

extern int RSI15_OpenCondition1 = 1; // Open condition 1 for M15 (0-1023)
extern int RSI15_OpenCondition2 = 1; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT RSI15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

extern int RSI30_OpenCondition1 = 1; // Open condition 1 for M30 (0-1023)
extern int RSI30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT RSI30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

extern double RSI1_MaxSpread =   6.0; // Max spread to trade for M1 (pips)
extern double RSI5_MaxSpread =   7.0; // Max spread to trade for M5 (pips)
extern double RSI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double RSI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)
extern bool RSI_DynamicPeriod = false;
int RSI1_IncreasePeriod_MinDiff = 27, RSI1_DecreasePeriod_MaxDiff = 61;
int RSI5_IncreasePeriod_MinDiff = 20, RSI5_DecreasePeriod_MaxDiff = 68;
int RSI15_IncreasePeriod_MinDiff = 18, RSI15_DecreasePeriod_MaxDiff = 58;
int RSI30_IncreasePeriod_MinDiff = 26, RSI30_DecreasePeriod_MaxDiff = 60;

//+------------------------------------------------------------------+
string __RVI_Parameters__ = "-- Settings for the Relative Vigor Index indicator --"; // >>> RVI <<<
bool RVI1_Active = 0; // Enable for M1
bool RVI5_Active = 0; // Enable for M5
bool RVI15_Active = 0; // Enable for M15
bool RVI30_Active = 0; // Enable for M30
uint RVI_Period = 10; // Period
ENUM_TRAIL_TYPE RVI_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE RVI_TrailingProfitMethod = T_NONE; // Trail profit method
int RVI_Shift = 2; // Shift
double RVI_SignalLevel = 0.00000000; // Signal level
int RVI1_SignalMethod = 0; // Signal method for M1 (0-
int RVI5_SignalMethod = 0; // Signal method for M5 (0-
int RVI15_SignalMethod = 0; // Signal method for M15 (0-
int RVI30_SignalMethod = 0; // Signal method for M30 (0-
int RVI1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int RVI1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT RVI1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int RVI5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int RVI5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT RVI5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int RVI15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int RVI15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT RVI15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int RVI30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int RVI30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT RVI30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double RVI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double RVI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double RVI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double RVI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __SAR_Parameters__ = "-- Settings for the Parabolic Stop and Reverse system indicator --"; // >>> SAR <<<
extern bool SAR1_Active = 0; // Enable for M1
extern bool SAR5_Active = 0; // Enable for M5
extern bool SAR15_Active = 0; // Enable for M15
extern bool SAR30_Active = 1; // Enable for M30
extern double SAR_Step = 0.2; // Step
extern double SAR_Maximum_Stop = 0.4; // Maximum stop
extern int SAR_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE SAR_TrailingStopMethod = 8; // Trail stop method
extern ENUM_TRAIL_TYPE SAR_TrailingProfitMethod = 25; // Trail profit method
extern double SAR_SignalLevel = 0.00000000; // Signal level
extern int SAR1_SignalMethod = 127; // Signal method for M1 (-127-127)
extern int SAR5_SignalMethod = -101; // Signal method for M5 (-127-127)
extern int SAR15_SignalMethod = -112; // Signal method for M15 (-127-127)
extern int SAR30_SignalMethod = -104; // Signal method for M30 (-127-127)
extern int SAR1_OpenCondition1 = 512;
extern int SAR1_OpenCondition2 = 0;
extern ENUM_MARKET_EVENT SAR1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
extern int SAR5_OpenCondition1 = 514; // Open condition 1 for M1 (0-1023)
extern int SAR5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT SAR5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
extern int SAR15_OpenCondition1 = 0; // Open condition 1 for M15 (0-1023)
extern int SAR15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT SAR15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
extern int SAR30_OpenCondition1 = 0; // Open condition 1 for M30 (0-1023)
extern int SAR30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT SAR30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
extern double SAR1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double SAR5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double SAR15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double SAR30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __StdDev_Parameters__ = "-- Settings for the Standard Deviation indicator --"; // >>> STDDEV <<<
bool StdDev1_Active = 0; // Enable for M1
bool StdDev5_Active = 0; // Enable for M5
bool StdDev15_Active = 0; // Enable for M15
bool StdDev30_Active = 0; // Enable for M30
int StdDev_MA_Period = 10; // Period
int StdDev_MA_Shift = 0; // Shift
ENUM_MA_METHOD StdDev_MA_Method = 1; // MA Method
ENUM_APPLIED_PRICE StdDev_Applied_Price = PRICE_CLOSE; // Applied Price
int StdDev_Shift = 0; // Shift
ENUM_TRAIL_TYPE StdDev_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE StdDev_TrailingProfitMethod = T_NONE; // Trail profit method
double StdDev_SignalLevel = 0.00000000; // Signal level
int StdDev1_SignalMethod = 0; // Signal method for M1 (0-
int StdDev5_SignalMethod = 0; // Signal method for M5 (0-
int StdDev15_SignalMethod = 0; // Signal method for M15 (0-
int StdDev30_SignalMethod = 0; // Signal method for M30 (0-
int StdDev1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int StdDev1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT StdDev1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int StdDev5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int StdDev5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT StdDev5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int StdDev15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int StdDev15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT StdDev15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int StdDev30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int StdDev30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT StdDev30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double StdDev1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double StdDev5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double StdDev15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double StdDev30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Stochastic_Parameters__ = "-- Settings for the Stochastic Oscillator --"; // >>> STOCHASTIC <<<
bool Stochastic1_Active = 0; // Enable for M1
bool Stochastic5_Active = 0; // Enable for M5
bool Stochastic15_Active = 0; // Enable for M15
bool Stochastic30_Active = 0; // Enable for M30
uint Stochastic_KPeriod = 5; // K line period
uint Stochastic_DPeriod = 5; // D line period
uint Stochastic_Slowing = 5; // Slowing
ENUM_MA_METHOD Stochastic_MA_Method = MODE_SMA; // Moving Average method
ENUM_STO_PRICE Stochastic_Price_Field = 0; // Price (0 - Low/High or 1 - Close/Close)
uint Stochastic_Shift = 0; // Shift (relative to the current bar)
ENUM_TRAIL_TYPE Stochastic_TrailingStopMethod = T_NONE; // Trail stop method
ENUM_TRAIL_TYPE Stochastic_TrailingProfitMethod = T_NONE; // Trail profit method
double Stochastic_SignalLevel = 0.00000000; // Signal level
int Stochastic1_SignalMethod = 0; // Signal method for M1 (0-
int Stochastic5_SignalMethod = 0; // Signal method for M5 (0-
int Stochastic15_SignalMethod = 0; // Signal method for M15 (0-
int Stochastic30_SignalMethod = 0; // Signal method for M30 (0-
int Stochastic1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int Stochastic1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Stochastic1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int Stochastic5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int Stochastic5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Stochastic5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int Stochastic15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int Stochastic15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Stochastic15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int Stochastic30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int Stochastic30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Stochastic30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double Stochastic1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Stochastic5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Stochastic15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Stochastic30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --"; // >>> WPR <<<
extern bool WPR1_Active = 1; // Enable for M1
extern bool WPR5_Active = 1; // Enable for M5
extern bool WPR15_Active = 1; // Enable for M15
extern bool WPR30_Active = 0; // Enable for M30
extern int WPR_Period = 6; // Period
extern int WPR_Shift = 0; // Shift
extern int WPR_SignalLevel = 20; // Signal level
extern ENUM_TRAIL_TYPE WPR_TrailingStopMethod = 25; // Trail stop method
extern ENUM_TRAIL_TYPE WPR_TrailingProfitMethod = 25; // Trail profit method
extern int WPR1_SignalMethod = -46; // Signal method for M1 (-63-63)
extern int WPR5_SignalMethod = -40; // Signal method for M5 (-63-63)
extern int WPR15_SignalMethod = -60; // Signal method for M15 (-63-63)
extern int WPR30_SignalMethod = 0; // Signal method for M30 (-63-63)
extern int WPR1_OpenCondition1 = 528; // Open condition 1 for M1 (0-1023)
extern int WPR1_OpenCondition2 = 0; // Open condition 2 for M1 (0-1023)
extern ENUM_MARKET_EVENT WPR1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
//
extern int WPR5_OpenCondition1 = 528; // Open condition 1 for M5 (0-1023)
extern int WPR5_OpenCondition2 = 0; // Open condition 2 for M5 (0-1023)
extern ENUM_MARKET_EVENT WPR5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
//
extern int WPR15_OpenCondition1 = 528; // Open condition 1 for M15 (0-1023)
extern int WPR15_OpenCondition2 = 0; // Open condition 2 for M15 (0-1023)
extern ENUM_MARKET_EVENT WPR15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
//
extern int WPR30_OpenCondition1 = 528; // Open condition 1 for M30 (0-1023)
extern int WPR30_OpenCondition2 = 0; // Open condition 2 for M30 (0-1023)
extern ENUM_MARKET_EVENT WPR30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
//
extern double WPR1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
extern double WPR5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
extern double WPR15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
extern double WPR30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __ZigZag_Parameters__ = "-- Settings for the ZigZag indicator --"; // >>> ZIGZAG <<<
bool ZigZag1_Active = 0; // Enable for M1
bool ZigZag5_Active = 0; // Enable for M5
bool ZigZag15_Active = 0; // Enable for M15
bool ZigZag30_Active = 0; // Enable for M30
uint ZigZag_Depth = 0; // Depth
uint ZigZag_Deviation = 0; // Deviation
uint ZigZag_Backstep = 0; // Deviation
uint ZigZag_Shift = 0; // Shift (relative to the current bar)
ENUM_TRAIL_TYPE ZigZag_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE ZigZag_TrailingProfitMethod = 1; // Trail profit method
double ZigZag_SignalLevel = 0.00000000; // Signal level
int ZigZag1_SignalMethod = 0; // Signal method for M1 (0-31)
int ZigZag5_SignalMethod = 0; // Signal method for M5 (0-31)
int ZigZag15_SignalMethod = 0; // Signal method for M15 (0-31)
int ZigZag30_SignalMethod = 0; // Signal method for M30 (0-31)
int ZigZag1_OpenCondition1 = 0; // Open condition 1 for M1 (0-1023)
int ZigZag1_OpenCondition2 = 0; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ZigZag1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1

int ZigZag5_OpenCondition1 = 0; // Open condition 1 for M5 (0-1023)
int ZigZag5_OpenCondition2 = 0; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ZigZag5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5

int ZigZag15_OpenCondition1 = 0; // Open condition 1 for M15 (0-)
int ZigZag15_OpenCondition2 = 0; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ZigZag15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15

int ZigZag30_OpenCondition1 = 0; // Open condition 1 for M30 (0-)
int ZigZag30_OpenCondition2 = 0; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ZigZag30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30

double ZigZag1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double ZigZag5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double ZigZag15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double ZigZag30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

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
bool DynamicSpreadConf = false; // Dynamically calculate most optimal settings based on the current spread (MinPipChangeToTrade/MinPipGap)
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
#ifdef __optimize__ extern #endif ENUM_TIMEFRAMES TrendPeriod = 30; // Period for trend calculation

extern string __Backtest_Parameters__ = "-- Testing & troubleshooting parameters --"; // >>> TESTING <<<
#ifndef __backtest__
  extern bool ValidateSettings = 0; // Validate startup settings
#else
  extern bool ValidateSettings = 1; // Validate startup settings
#endif
extern bool RecordTicksToCSV = 0; // Record ticks into CSV files
// extern int DemoMarketStopLevel = 10; // Demo market stop level
extern int AccountConditionToDisable = 0; // Override: Disable specific n action
extern int Account_Condition_To_Disable = 0; // Override: Disable specific n action
extern bool DisableCloseConditions = false; // Override: Disable all close conditions

//+------------------------------------------------------------------+
extern string __EA_Constants__ = "-- Constants --"; // >>> CONSTANTS <<<
extern int MagicNumber = 31337; // Unique EA magic number (+40)

//+------------------------------------------------------------------+
extern string __Other_Parameters__ = "-- Other parameters --"; // >>> OTHER <<<
