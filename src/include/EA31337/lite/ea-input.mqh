//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                       Copyright 2016-2018, 31337 Investments Ltd |
//|                                       https://github.com/EA31337 |
//|                                                     ea-input.mqh |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, kenorb" // ©
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
extern double LotSize = 0.00000000; // Lot size (0 = auto)
extern bool   TradeMicroLots = 1; // Trade micro lots?
ENUM_TIMEFRAMES TrendPeriod = PERIOD_H1; // Period for trend calculation
int    TrendMethod = 192; // Main trend method (0-255)
extern int    MinVolumeToTrade = 2; // Min volume to trade
extern int    MaxOrderPriceSlippage = 10; // Max price slippage (in pts)
extern int    MaxTries = 5; // Max retries for opening orders
extern double MinPipChangeToTrade = 0.6; // Min pip change to trade (0 = every tick)
extern int    MinPipGap = 90; // Min gap between trades per type (in pips)
extern uint   TickProcessMethod = 4; // Tick process method (0-8, 0 - all)

//+------------------------------------------------------------------+
extern string   __EA_Order_Parameters__ = "-- Profit and loss parameters --"; // >>> PROFIT/LOSS <<<
extern uint     TakeProfitMax = 200; // Max Take profit (in pips, 0 = auto)
extern uint     StopLossMax = 60; // Max Stop loss (in pips, 0 = auto)

//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Profit and loss trailing parameters --"; // >>> TRAILINGS <<<
extern ENUM_TRAIL_TYPE DefaultTrailingStopMethod = -27; // Default trail stop method (0 = none)
extern int TrailingStop = 80; // Extra trailing stop (in pips)
extern ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = -27; // Default trail profit method
extern int TrailingProfit = 50; // Extra trailing profit (in pips)
extern double TrailingStopAddPerMinute = 0.1; // Decrease trail stop per minute (pip/min)

//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management parameters --"; // >>> RISK <<
extern double RiskMarginPerOrder = 0.6; // Risk margin per order (in %, 0-100, 0 - auto, -1 - off)
extern double RiskMarginTotal = 8; // Risk margin in total (in %, 0-100, 0 - auto, -1 - off)
extern double RiskRatio = 0.00000000; // Risk ratio (0 = auto, 1.0 = normal)
extern int RiskRatioIncreaseMethod = 0; // Risk ratio increase method (0-255)
extern int RiskRatioDecreaseMethod = 0; // Risk ratio decrease method (0-255)
extern int InitNoOfDaysToWarmUp = 21; // Initial warm-up period (in days)
extern int CloseOrderAfterXHours = 24; // Close order after X hours (>0 - only profitable, <0 - all, 0 - off)

//+------------------------------------------------------------------+
extern string __Strategy_Parameters__ = "-- Per strategy parameters (0 to disable) --"; // >>> STRATEGIES <<<
extern double ProfitFactorMinToTrade = 0.5; // Min. profit factor per strategy to trade
extern double ProfitFactorMaxToTrade = 0; // Max. profit factor per strategy to trade
extern int InitNoOfOrdersToCalcPF = 10; // Initial number of orders to calculate profit factor

//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting parameters (set 1.0 for default) --"; // >>> BOOSTING <<<
extern bool Boosting_Enabled = 0; // Enable boosting
extern double BoostTrendFactor = 1.5; // Boost by trend factor
extern bool StrategyBoostByPF = 0; // Boost strategy by its profit factor
extern bool StrategyHandicapByPF = 1; // Handicap by its low profit factor
extern double BestDailyStrategyMultiplierFactor = 1.2; // Multiplier for the best daily strategy
extern double BestWeeklyStrategyMultiplierFactor = 1.5; // Multiplier for the best weekly strategy
extern double BestMonthlyStrategyMultiplierFactor = 1.5; // Multiplier for the best monthly strategy
extern double WorseDailyStrategyMultiplierFactor = 0.9; // Multiplier for the worse daily strategy
extern double WorseWeeklyStrategyMultiplierFactor = 0.8; // Multiplier for the worse weekly strategy
extern double WorseMonthlyStrategyMultiplierFactor = 0.7; // Multiplier for the worse monthly strategy
extern double ConWinsIncreaseFactor = -1.2; // Increase lot factor on consequent wins (in %, 0 - off)
extern double ConLossesIncreaseFactor = 1.3; // Increase lot factor on consequent loses (in %, 0 - off)
extern uint ConFactorOrdersLimit = 200; // No of orders to check on consequent wins/loses

//+------------------------------------------------------------------+
string __SmartQueue_Parameters__ = "-- Smart queue parameters --"; // >>> SMART QUEUE <<<
bool SmartQueueActive = false; // Activate QueueAI
int SmartQueueMethod = 3; // QueueAI: Method for selecting the best order (0-15)
int SmartQueueFilter = 27; // QueueAI: Method for filtering the orders (0-255)

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions__ = "-- Account conditions --"; // >>> CONDITIONS & ACTIONS <<<
// Note: It's not advice to use on accounts where multi bots are trading.
extern bool Account_Conditions_Active = 1; // Enable account conditions
// 5 - Equity 20% high
extern ENUM_ACC_CONDITION Account_Condition_1 = 5; // 1. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_1 = 9; // 1. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_1 = 4; // 1. Action to take
// 8 - Equity 20% low
extern ENUM_ACC_CONDITION Account_Condition_2 = 7; // 2. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_2 = 13; // 2. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_2 = 7; // 2. Action to take
// 12 - 80% Margin Used
extern ENUM_ACC_CONDITION Account_Condition_3 = 10; // 3. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_3 = 8; // 3. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_3 = 0; // 3. Action to take
// 2 - Equity lower than balance
extern ENUM_ACC_CONDITION Account_Condition_4 = 19; // 4. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_4 = 19; // 4. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_4 = 1; // 4. Action to take
// 18 - Max. daily balance > max. weekly
extern ENUM_ACC_CONDITION Account_Condition_5 = 23; // 5. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_5 = 18; // 5. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_5 = 3; // 5. Action to take

extern int Account_Condition_MinProfitCloseOrder = 20; // Min pip profit on action to close

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions_Params__ = "-- Account conditions parameters --"; // >>> CONDITIONS & ACTIONS PARAMS <<<
extern int MarketSuddenDropSize = 20; // Drop in pips to react
extern int MarketBigDropSize = 40; // Big drop in pips to react
extern int MarketSpecificHour = 10; // Specific hour used for conditions (0-23)
extern bool CloseConditionOnlyProfitable = 1; // Apply close condition only for profitable orders

//+------------------------------------------------------------------+
string __AC_Parameters__ = "-- Settings for the Bill Williams' Accelerator/Decelerator oscillator --"; // >>> AC (NOT IMPLEMENTED YET) <<<
bool AC1_Active = 0; // Enable for M1
bool AC5_Active = 0; // Enable on M5
bool AC15_Active = 0; // Enable on M15
bool AC30_Active = 0; // Enable on M30
ENUM_TRAIL_TYPE AC_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE AC_TrailingProfitMethod = 1; // Trail profit method
double AC_SignalLevel = 0.00000000; // Signal level
int AC1_SignalMethod = 15; // Signal method for M1 (0-?)
int AC5_SignalMethod = 15; // Signal method for M5 (0-?)
int AC15_SignalMethod = 15; // Signal method for M15 (0-?)
int AC30_SignalMethod = 15; // Signal method for M30 (0-?)
int AC1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int AC1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT AC1_CloseCondition = C_AC_BUY_SELL; // Close condition for M1
int AC5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int AC5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT AC5_CloseCondition = C_AC_BUY_SELL; // Close condition for M5
int AC15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int AC15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT AC15_CloseCondition = C_AC_BUY_SELL; // Close condition for M15
int AC30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int AC30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT AC30_CloseCondition = C_AC_BUY_SELL; // Close condition for M30
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
ENUM_TRAIL_TYPE AD_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE AD_TrailingProfitMethod = 1; // Trail profit method
double AD_SignalLevel = 0.00000000; // Signal level
int AD1_SignalMethod = 15; // Signal method for M1 (0-?)
int AD5_SignalMethod = 15; // Signal method for M5 (0-?)
int AD15_SignalMethod = 15; // Signal method for M15 (0-?)
int AD30_SignalMethod = 15; // Signal method for M30 (0-?)
int AD1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int AD1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT AD1_CloseCondition = C_AD_BUY_SELL; // Close condition for M1
int AD5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int AD5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT AD5_CloseCondition = C_AD_BUY_SELL; // Close condition for M5
int AD15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int AD15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT AD15_CloseCondition = C_AD_BUY_SELL; // Close condition for M15
int AD30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int AD30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT AD30_CloseCondition = C_AD_BUY_SELL; // Close condition for M30
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
ENUM_TRAIL_TYPE ADX_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE ADX_TrailingProfitMethod = 1; // Trail profit method
int ADX_Period = 14; // Period
ENUM_APPLIED_PRICE ADX_Applied_Price = 2; // Applied Price
double ADX_SignalLevel = 0.00000000; // Signal level
int ADX1_SignalMethod = 15; // Signal method for M1 (0-?)
int ADX5_SignalMethod = 15; // Signal method for M5 (0-?)
int ADX15_SignalMethod = 15; // Signal method for M15 (0-?)
int ADX30_SignalMethod = 15; // Signal method for M30 (0-?)
int ADX1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int ADX1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ADX1_CloseCondition = C_ADX_BUY_SELL; // Close condition for M1
int ADX5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int ADX5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ADX5_CloseCondition = C_ADX_BUY_SELL; // Close condition for M5
int ADX15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int ADX15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ADX15_CloseCondition = C_ADX_BUY_SELL; // Close condition for M15
int ADX30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int ADX30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ADX30_CloseCondition = C_ADX_BUY_SELL; // Close condition for M30
double ADX1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double ADX5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double ADX15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double ADX30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --"; // >>> ALLIGATOR <<<
extern bool Alligator1_Active = 0; // Enable for M1
extern bool Alligator5_Active = 0; // Enable for M5
extern bool Alligator15_Active = 0; // Enable for M15
extern bool Alligator30_Active = 0; // Enable for M30
extern int Alligator_Period_Jaw = 10; // Jaw Period
extern int Alligator_Period_Teeth = 2; // Teeth Period
extern int Alligator_Period_Lips = 4; // Lips Period
extern double Alligator_Period_Ratio = 1.5; // Period ratio between timeframes (0.5-1.5)
extern int Alligator_Shift_Jaw = 0; // Jaw Shift
extern int Alligator_Shift_Teeth = 2; // Teeth Shift
extern int Alligator_Shift_Lips = 4; // Lips Shift
extern ENUM_MA_METHOD Alligator_MA_Method = 2; // MA Method
extern ENUM_APPLIED_PRICE Alligator_Applied_Price = 2; // Applied Price
extern int Alligator_Shift = -2; // Shift
extern int Alligator_Shift_Far = 10; // Shift Far
extern ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = 9; // Trail stop method
extern ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = 23; // Trail profit method
extern double Alligator_SignalLevel = -0.11; // Signal level
extern int Alligator1_SignalMethod = 24; // Signal method for M1 (-63-63)
extern int Alligator5_SignalMethod = 0; // Signal method for M5 (-63-63)
extern int Alligator15_SignalMethod = 36; // Signal method for M15 (-63-63)
extern int Alligator30_SignalMethod = -62; // Signal method for M30 (-63-63)
int Alligator1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Alligator1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT Alligator1_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M1
int Alligator5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Alligator5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT Alligator5_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M5
int Alligator15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int Alligator15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT Alligator15_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M15
int Alligator30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int Alligator30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT Alligator30_CloseCondition = C_ALLIGATOR_BUY_SELL; // Close condition for M30
double Alligator1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Alligator5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Alligator15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Alligator30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __ATR_Parameters__ = "-- Settings for the Average True Range indicator --"; // >>> ATR <<<
bool ATR1_Active = 0; // Enable for M1
bool ATR5_Active = 0; // Enable for M5
bool ATR15_Active = 0; // Enable for M15
bool ATR30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE ATR_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE ATR_TrailingProfitMethod = 1; // Trail profit method
int ATR_Period_Fast = 14; // Period Fast
int ATR_Period_Slow = 20; // Period Slow
double ATR_Period_Ratio = 1.0; // Period ratio between timeframes (0.5-1.5)
double ATR_SignalLevel = 0.00000000; // Signal level
int ATR1_SignalMethod = 31; // Signal method for M1 (0-31)
int ATR5_SignalMethod = 31; // Signal method for M5 (0-31)
int ATR15_SignalMethod = 31; // Signal method for M15 (0-31)
int ATR30_SignalMethod = 31; // Signal method for M30 (0-31)
int ATR1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int ATR1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ATR1_CloseCondition = C_ATR_BUY_SELL; // Close condition for M1
int ATR5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int ATR5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ATR5_CloseCondition = C_ATR_BUY_SELL; // Close condition for M5
int ATR15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int ATR15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ATR15_CloseCondition = C_ATR_BUY_SELL; // Close condition for M15
int ATR30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int ATR30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ATR30_CloseCondition = C_ATR_BUY_SELL; // Close condition for M30
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
ENUM_TRAIL_TYPE Awesome_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Awesome_TrailingProfitMethod = 1; // Trail profit method
double Awesome_SignalLevel = 0.00000000; // Signal level
int Awesome1_SignalMethod = 31; // Signal method for M1 (0-31)
int Awesome5_SignalMethod = 0; // Signal method for M5 (0-31)
int Awesome15_SignalMethod = 31; // Signal method for M15 (0-31)
int Awesome30_SignalMethod = 31; // Signal method for M30 (0-31)
int Awesome1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Awesome1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Awesome1_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M1
int Awesome5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Awesome5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Awesome5_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M5
int Awesome15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Awesome15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Awesome15_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M15
int Awesome30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Awesome30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Awesome30_CloseCondition = C_AWESOME_BUY_SELL; // Close condition for M30
double Awesome1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Awesome5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Awesome15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Awesome30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --"; // >>> BANDS <<<
extern bool Bands1_Active = 0; // Enable for M1
extern bool Bands5_Active = 0; // Enable for M5
extern bool Bands15_Active = 0; // Enable for M15
extern bool Bands30_Active = 0; // Enable for M30
extern int Bands_Period = 16; // Period
extern double Bands_Period_Ratio = 1.0; // Period ratio between timeframes (0.5-1.5)
extern ENUM_APPLIED_PRICE Bands_Applied_Price = 4; // Applied Price
extern double Bands_Deviation = 4.10000000; // Deviation
extern double Bands_Deviation_Ratio = 1.0; // Deviation ratio between timeframes (0.5-1.5)
extern int Bands_Shift = 0; // Shift
extern int Bands_Shift_Far = 0; // Shift Far
extern ENUM_TRAIL_TYPE Bands_TrailingStopMethod = 26; // Trail stop method
extern ENUM_TRAIL_TYPE Bands_TrailingProfitMethod = 6; // Trail profit method
/* @todo extern */ int Bands_SignalLevel = 0; // Signal level
extern int Bands1_SignalMethod = 0; // Signal method for M1 (-127-127)
extern int Bands5_SignalMethod = 152; // Signal method for M5 (-127-127)
extern int Bands15_SignalMethod = 230; // Signal method for M15 (-127-127)
extern int Bands30_SignalMethod = 32; // Signal method for M30 (-127-127)
int Bands1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Bands1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT Bands1_CloseCondition = C_BANDS_BUY_SELL; // Close condition for M1
int Bands5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Bands5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT Bands5_CloseCondition = C_BANDS_BUY_SELL; // Close condition for M5
int Bands15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int Bands15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT Bands15_CloseCondition = C_BANDS_BUY_SELL; // Close condition for M15
int Bands30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int Bands30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT Bands30_CloseCondition = C_BANDS_BUY_SELL; // Close condition for M30
double Bands1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Bands5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Bands15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Bands30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __BPower_Parameters__ = "-- Settings for the Bulls/Bears Power indicator --"; // >>> BULLS/BEARS POWER <<<
bool BPower1_Active = 0; // Enable for M1
bool BPower5_Active = 0; // Enable for M5
bool BPower15_Active = 0; // Enable for M15
bool BPower30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE BPower_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BPower_TrailingProfitMethod = 1; // Trail profit method
int BPower_Period = 13; // Period
double BPower_Period_Ratio = 1.00000000; // Period ratio between timeframes (0.5-1.5)
ENUM_APPLIED_PRICE BPower_Applied_Price = 0; // Applied Price
double BPower_SignalLevel = 0.00000000; // Signal level
int BPower1_SignalMethod = 15; // Signal method for M1 (0-
int BPower5_SignalMethod = 15; // Signal method for M5 (0-
int BPower15_SignalMethod = 15; // Signal method for M15 (0-
int BPower30_SignalMethod = 15; // Signal method for M30 (0-
int BPower1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int BPower1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BPower1_CloseCondition = C_BPOWER_BUY_SELL; // Close condition for M1
int BPower5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int BPower5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BPower5_CloseCondition = C_BPOWER_BUY_SELL; // Close condition for M5
int BPower15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int BPower15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BPower15_CloseCondition = C_BPOWER_BUY_SELL; // Close condition for M15
int BPower30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int BPower30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BPower30_CloseCondition = C_BPOWER_BUY_SELL; // Close condition for M30
double BPower1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BPower5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BPower15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BPower30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Breakage_Parameters__ = "-- Settings for the custom Breakage strategy --"; // >>> BREAKAGE <<<
bool Breakage1_Active = 0; // Enable for M1
bool Breakage5_Active = 0; // Enable for M5
bool Breakage15_Active = 0; // Enable for M15
bool Breakage30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Breakage_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Breakage_TrailingProfitMethod = 1; // Trail profit method
double Breakage_SignalLevel = 0.00000000; // Signal level
int Breakage1_SignalMethod = 0; // Signal method for M1 (0-31)
int Breakage5_SignalMethod = 0; // Signal method for M5 (0-31)
int Breakage15_SignalMethod = 0; // Signal method for M15 (0-31)
int Breakage30_SignalMethod = 0; // Signal method for M30 (0-31)
int Breakage1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Breakage1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Breakage1_CloseCondition = C_BREAKAGE_BUY_SELL; // Close condition for M1
int Breakage5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Breakage5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Breakage5_CloseCondition = C_BREAKAGE_BUY_SELL; // Close condition for M5
int Breakage15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Breakage15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Breakage15_CloseCondition = C_BREAKAGE_BUY_SELL; // Close condition for M15
int Breakage30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Breakage30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Breakage30_CloseCondition = C_BREAKAGE_BUY_SELL; // Close condition for M30
double Breakage1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Breakage5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Breakage15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Breakage30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __BWMFI_Parameters__ = "-- Settings for the Market Facilitation Index indicator --"; // >>> BWMFI <<<
bool BWMFI1_Active = 0; // Enable for M1
bool BWMFI5_Active = 0; // Enable for M5
bool BWMFI15_Active = 0; // Enable for M15
bool BWMFI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE BWMFI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BWMFI_TrailingProfitMethod = 1; // Trail profit method
double BWMFI_SignalLevel = 0.00000000; // Signal level
int BWMFI1_SignalMethod = 0; // Signal method for M1 (0-
int BWMFI5_SignalMethod = 0; // Signal method for M5 (0-
int BWMFI15_SignalMethod = 0; // Signal method for M15 (0-
int BWMFI30_SignalMethod = 0; // Signal method for M30 (0-
int BWMFI1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int BWMFI1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT BWMFI1_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M1
int BWMFI5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int BWMFI5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT BWMFI5_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M5
int BWMFI15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int BWMFI15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT BWMFI15_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M15
int BWMFI30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int BWMFI30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT BWMFI30_CloseCondition = C_BWMFI_BUY_SELL; // Close condition for M30
double BWMFI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double BWMFI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double BWMFI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double BWMFI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __CCI_Parameters__ = "-- Settings for the Commodity Channel Index indicator --"; // >>> CCI <<<
extern bool CCI1_Active = 0; // Enable for M1
extern bool CCI5_Active = 1; // Enable for M5
extern bool CCI15_Active = 0; // Enable for M15
extern bool CCI30_Active = 1; // Enable for M30
extern double CCI_Period_Ratio = 1; // Period ratio between timeframes (1.0 - default)
extern ENUM_TRAIL_TYPE CCI_TrailingStopMethod = 10; // Trail stop method
extern ENUM_TRAIL_TYPE CCI_TrailingProfitMethod = 8; // Trail profit method
extern int CCI_Period = 14; // Period
extern ENUM_APPLIED_PRICE CCI_Applied_Price = 1; // Applied Price
extern double CCI_SignalLevel = 80; // Signal level (100 by default)
extern int CCI1_SignalMethod = 0; // Signal method for M1 (0-
extern int CCI5_SignalMethod = 0; // Signal method for M5 (0-
extern int CCI15_SignalMethod = 0; // Signal method for M15 (0-
extern int CCI30_SignalMethod = 0; // Signal method for M30 (0-
int CCI1_OpenCondition1 = 4; // Open condition 1 for M1 (0-11)
int CCI1_OpenCondition2 = 7; // Open condition 2 for M1 (0-11)
ENUM_MARKET_EVENT CCI1_CloseCondition = C_CCI_BUY_SELL; // Close condition for M1
int CCI5_OpenCondition1 = 4; // Open condition 1 for M5 (0-11)
int CCI5_OpenCondition2 = 5; // Open condition 2 for M5 (0-11)
ENUM_MARKET_EVENT CCI5_CloseCondition = C_CCI_BUY_SELL; // Close condition for M5
int CCI15_OpenCondition1 = 4; // Open condition 1 for M15 (0-11)
int CCI15_OpenCondition2 = 0; // Open condition 2 for M15 (0-11)
ENUM_MARKET_EVENT CCI15_CloseCondition = C_CCI_BUY_SELL; // Close condition for M15
int CCI30_OpenCondition1 = 7; // Open condition 1 for M30 (0-11)
int CCI30_OpenCondition2 = 5; // Open condition 2 for M30 (0-11)
ENUM_MARKET_EVENT CCI30_CloseCondition = C_CCI_BUY_SELL; // Close condition for M30
double CCI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double CCI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double CCI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double CCI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --"; // >>> DEMARKER <<<
extern bool DeMarker1_Active = 0; // Enable for M1
extern bool DeMarker5_Active = 1; // Enable for M5
extern bool DeMarker15_Active = 0; // Enable for M15
extern bool DeMarker30_Active = 1; // Enable for M30
extern int DeMarker_Period = 17; // Period
extern double DeMarker_Period_Ratio = 0.3; // Period ratio between timeframes (0.5-1.5)
extern int DeMarker_Shift = 0; // Shift
extern double DeMarker_SignalLevel = -0.30000000; // Signal level (0.0-0.4)
extern ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = -20; // Trail stop method
extern ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = 3; // Trail profit method
extern int DeMarker1_SignalMethod = 12; // Signal method for M1 (-31-31)
extern int DeMarker5_SignalMethod = 12; // Signal method for M5 (-31-31)
extern int DeMarker15_SignalMethod = 20; // Signal method for M15 (-31-31)
extern int DeMarker30_SignalMethod = 4; // Signal method for M30 (-31-31)
int DeMarker1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int DeMarker1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT DeMarker1_CloseCondition = C_DEMARKER_BUY_SELL; // Close condition for M1
int DeMarker5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int DeMarker5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT DeMarker5_CloseCondition = C_DEMARKER_BUY_SELL; // Close condition for M5
int DeMarker15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int DeMarker15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT DeMarker15_CloseCondition = C_DEMARKER_BUY_SELL; // Close condition for M15
int DeMarker30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int DeMarker30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT DeMarker30_CloseCondition = C_DEMARKER_BUY_SELL; // Close condition for M30
double DeMarker1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double DeMarker5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double DeMarker15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double DeMarker30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --"; // >>> ENVELOPES <<<
extern bool Envelopes1_Active = 0; // Enable for M1
extern bool Envelopes5_Active = 1; // Enable for M5
extern bool Envelopes15_Active = 0; // Enable for M15
extern bool Envelopes30_Active = 0; // Enable for M30
extern int Envelopes_MA_Period = 32; // Period
extern double Envelopes_MA_Period_Ratio = 1.0; // Period ratio between timeframes (0.5-1.5)
extern ENUM_MA_METHOD Envelopes_MA_Method = 2; // MA Method
extern int Envelopes_MA_Shift = 2; // MA Shift
extern ENUM_APPLIED_PRICE Envelopes_Applied_Price = 1; // Applied Price
extern double Envelopes_Deviation = 0.4; // Deviation for M1
extern double Envelopes_Deviation_Ratio = 0.6; // Deviation ratio between timeframes (0.5-1.5)
extern int Envelopes_Shift = 0; // Shift
int Envelopes_Shift_Far = 0; // Shift Far
extern ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = 27; // Trail stop method
extern ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = 20; // Trail profit method
/* @todo extern */ int Envelopes_SignalLevel = 0; // Signal level
extern int Envelopes1_SignalMethod = 93; // Signal method for M1 (-127-127)
extern int Envelopes5_SignalMethod = 92; // Signal method for M5 (-127-127)
extern int Envelopes15_SignalMethod = 96; // Signal method for M15 (-127-127)
extern int Envelopes30_SignalMethod = -70; // Signal method for M30 (-127-127)
int Envelopes1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Envelopes1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT Envelopes1_CloseCondition = C_ENVELOPES_BUY_SELL; // Close condition for M1
int Envelopes5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Envelopes5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT Envelopes5_CloseCondition = C_ENVELOPES_BUY_SELL; // Close condition for M5
int Envelopes15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int Envelopes15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT Envelopes15_CloseCondition = C_ENVELOPES_BUY_SELL; // Close condition for M15
int Envelopes30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int Envelopes30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT Envelopes30_CloseCondition = C_ENVELOPES_BUY_SELL; // Close condition for M30
double Envelopes1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Envelopes5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Envelopes15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Envelopes30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

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
ENUM_APPLIED_PRICE Force_Applied_price = 0; // Applied Price
double Force_SignalLevel = 0.00000000; // Signal level
int Force1_SignalMethod = 31; // Signal method for M1 (0-
int Force5_SignalMethod = 31; // Signal method for M5 (0-
int Force15_SignalMethod = 31; // Signal method for M15 (0-
int Force30_SignalMethod = 31; // Signal method for M30 (0-
int Force1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Force1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Force1_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M1
int Force5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Force5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Force5_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M5
int Force15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Force15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Force15_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M15
int Force30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Force30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Force30_CloseCondition = C_FORCE_BUY_SELL; // Close condition for M30
double Force1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Force5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Force15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Force30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --"; // >>> FRACTALS <<<
extern bool Fractals1_Active = 0; // Enable for M1
extern bool Fractals5_Active = 0; // Enable for M5
extern bool Fractals15_Active = 0; // Enable for M15
extern bool Fractals30_Active = 1; // Enable for M30
extern ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = 27; // Trail stop method
extern ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = 5; // Trail profit method
/* @todo extern */ int Fractals_SignalLevel = 0; // Signal level
extern int Fractals1_SignalMethod = 3; // Signal method for M1 (-3-3)
extern int Fractals5_SignalMethod = 3; // Signal method for M5 (-3-3)
extern int Fractals15_SignalMethod = 1; // Signal method for M15 (-3-3)
extern int Fractals30_SignalMethod = 1; // Signal method for M30 (-3-3)
int Fractals1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Fractals1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Fractals1_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M1
int Fractals5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Fractals5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Fractals5_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M5
int Fractals15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Fractals15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Fractals15_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M15
int Fractals30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Fractals30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Fractals30_CloseCondition = C_FRACTALS_BUY_SELL; // Close condition for M30
double Fractals1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Fractals5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Fractals15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Fractals30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __Gator_Parameters__ = "-- Settings for the Gator oscillator --"; // >>> GATOR <<<
bool Gator1_Active = 0; // Enable for M1
bool Gator5_Active = 0; // Enable for M5
bool Gator15_Active = 0; // Enable for M15
bool Gator30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Gator_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Gator_TrailingProfitMethod = 1; // Trail profit method
double Gator_SignalLevel = 0.00000000; // Signal level
int Gator1_SignalMethod = 0; // Signal method for M1 (0-
int Gator5_SignalMethod = 0; // Signal method for M5 (0-
int Gator15_SignalMethod = 0; // Signal method for M15 (0-
int Gator30_SignalMethod = 0; // Signal method for M30 (0-
int Gator1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Gator1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Gator1_CloseCondition = C_GATOR_BUY_SELL; // Close condition // Close condition for M1
int Gator5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Gator5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Gator5_CloseCondition = C_GATOR_BUY_SELL; // Close condition for M5
int Gator15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Gator15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Gator15_CloseCondition = C_GATOR_BUY_SELL; // Close condition for M15
int Gator30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Gator30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Gator30_CloseCondition = C_GATOR_BUY_SELL; // Close condition for M30
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
ENUM_TRAIL_TYPE Ichimoku_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Ichimoku_TrailingProfitMethod = 1; // Trail profit method
int Ichimoku_Period_Tenkan_Sen = 9; // Period Tenkan Sen
int Ichimoku_Period_Kijun_Sen = 26; // Period Kijun Sen
int Ichimoku_Period_Senkou_Span_B = 52; // Period Senkou Span B
double Ichimoku_SignalLevel = 0.00000000; // Signal level
int Ichimoku1_SignalMethod = 0; // Signal method for M1 (0-
int Ichimoku5_SignalMethod = 0; // Signal method for M5 (0-
int Ichimoku15_SignalMethod = 0; // Signal method for M15 (0-
int Ichimoku30_SignalMethod = 0; // Signal method for M30 (0-
int Ichimoku1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Ichimoku1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Ichimoku1_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M1
int Ichimoku5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Ichimoku5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Ichimoku5_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M5
int Ichimoku15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Ichimoku15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Ichimoku15_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M15
int Ichimoku30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Ichimoku30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Ichimoku30_CloseCondition = C_ICHIMOKU_BUY_SELL; // Close condition for M30
double Ichimoku1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Ichimoku5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Ichimoku15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Ichimoku30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __MA_Parameters__ = "-- Settings for the Moving Average indicator --"; // >>> MA <<<
extern bool MA1_Active = 0; // Enable for M1
extern bool MA5_Active = 0; // Enable for M5
extern bool MA15_Active = 0; // Enable for M15
extern bool MA30_Active = 0; // Enable for M30
extern int MA_Period_Fast = 17; // Period Fast
extern int MA_Period_Medium = 15; // Period Medium
extern int MA_Period_Slow = 48; // Period Slow
extern double MA_Period_Ratio = 1.0; // Period ratio between timeframes (0.5-1.5)
extern int MA_Shift = 0; // Shift
extern int MA_Shift_Fast = 0; // Shift Fast (+1)
extern int MA_Shift_Medium = 0; // Shift Medium (+1)
extern int MA_Shift_Slow = 1; // Shift Slow (+1)
extern int MA_Shift_Far = 4; // Shift Far (+2)
extern ENUM_MA_METHOD MA_Method = 1; // MA Method
extern ENUM_APPLIED_PRICE MA_Applied_Price = 3; // Applied Price
extern ENUM_TRAIL_TYPE MA_TrailingStopMethod = 27; // Trail stop method
extern ENUM_TRAIL_TYPE MA_TrailingProfitMethod = 26; // Trail profit method
extern double MA_SignalLevel = 1.2; // Signal level
extern int MA1_SignalMethod = -98; // Signal method for M1 (-127-127)
extern int MA5_SignalMethod = 1; // Signal method for M5 (-127-127)
extern int MA15_SignalMethod = -126; // Signal method for M15 (-127-127)
extern int MA30_SignalMethod = -111; // Signal method for M30 (-127-127)
int MA1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int MA1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT MA1_CloseCondition = C_MA_BUY_SELL; // Close condition for M1
int MA5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int MA5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT MA5_CloseCondition = C_MA_BUY_SELL; // Close condition for M5
int MA15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int MA15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT MA15_CloseCondition = C_MA_BUY_SELL; // Close condition for M15
int MA30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int MA30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT MA30_CloseCondition = C_MA_BUY_SELL; // Close condition for M30
double MA1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double MA5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double MA15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double MA30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --"; // >>> MACD <<<
extern bool MACD1_Active = 0; // Enable for M1
extern bool MACD5_Active = 0; // Enable for M5
extern bool MACD15_Active = 0; // Enable for M15
extern bool MACD30_Active = 0; // Enable for M30
extern int MACD_Period_Fast = 19; // Period Fast
extern int MACD_Period_Slow = 29; // Period Slow
extern int MACD_Period_Signal = 12; // Period for signal
extern double MACD_Period_Ratio = 1.0; // Period ratio between timeframes (0.5-1.5)
extern ENUM_APPLIED_PRICE MACD_Applied_Price = 1; // Applied Price
extern int MACD_Shift = 6; // Shift
extern int MACD_Shift_Far = -1; // Shift Far
extern ENUM_TRAIL_TYPE MACD_TrailingStopMethod = 20; // Trail stop method
extern ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = -5; // Trail profit method
extern double MACD_SignalLevel = 0.1; // Signal level
extern int MACD1_SignalMethod = 13; // Signal method for M1 (-31-31)
extern int MACD5_SignalMethod = 5; // Signal method for M5 (-31-31)
extern int MACD15_SignalMethod = 17; // Signal method for M15 (-31-31)
extern int MACD30_SignalMethod = -25; // Signal method for M30 (-31-31)
int MACD1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int MACD1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT MACD1_CloseCondition = C_MACD_BUY_SELL; // Close condition for M1
int MACD5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int MACD5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT MACD5_CloseCondition = C_MACD_BUY_SELL; // Close condition for M5
int MACD15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int MACD15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT MACD15_CloseCondition = C_MACD_BUY_SELL; // Close condition for M15
int MACD30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int MACD30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT MACD30_CloseCondition = C_MACD_BUY_SELL; // Close condition for M30
double MACD1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double MACD5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double MACD15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double MACD30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __MFI_Parameters__ = "-- Settings for the Money Flow Index indicator --"; // >>> MFI <<<
bool MFI1_Active = 0; // Enable for M1
bool MFI5_Active = 0; // Enable for M5
bool MFI15_Active = 0; // Enable for M15
bool MFI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE MFI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE MFI_TrailingProfitMethod = 1; // Trail profit method
int MFI_Period = 14; // Period
double MFI_SignalLevel = 0.00000000; // Signal level
int MFI1_SignalMethod = 0; // Signal method for M1 (0-
int MFI5_SignalMethod = 0; // Signal method for M5 (0-
int MFI15_SignalMethod = 0; // Signal method for M15 (0-
int MFI30_SignalMethod = 0; // Signal method for M30 (0-
int MFI1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int MFI1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT MFI1_CloseCondition = C_MFI_BUY_SELL; // Close condition for M1

int MFI5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int MFI5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT MFI5_CloseCondition = C_MFI_BUY_SELL; // Close condition for M5

int MFI15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int MFI15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT MFI15_CloseCondition = C_MFI_BUY_SELL; // Close condition for M15

int MFI30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int MFI30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT MFI30_CloseCondition = C_MFI_BUY_SELL; // Close condition for M30

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
ENUM_TRAIL_TYPE Momentum_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Momentum_TrailingProfitMethod = 1; // Trail profit method
int Momentum_Period_Fast = 12; // Period Fast
int Momentum_Period_Slow = 20; // Period Slow
ENUM_APPLIED_PRICE Momentum_Applied_Price = 0; // Applied Price
double Momentum_SignalLevel = 0.00000000; // Signal level
int Momentum1_SignalMethod = 15; // Signal method for M1 (0-
int Momentum5_SignalMethod = 15; // Signal method for M5 (0-
int Momentum15_SignalMethod = 15; // Signal method for M15 (0-
int Momentum30_SignalMethod = 15; // Signal method for M30 (0-
int Momentum1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Momentum1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT Momentum1_CloseCondition = C_MOMENTUM_BUY_SELL; // Close condition for M1
int Momentum5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Momentum5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Momentum5_CloseCondition = C_MOMENTUM_BUY_SELL; // Close condition for M5
int Momentum15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Momentum15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Momentum15_CloseCondition = C_MOMENTUM_BUY_SELL; // Close condition for M15
int Momentum30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Momentum30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Momentum30_CloseCondition = C_MOMENTUM_BUY_SELL; // Close condition for M30
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
ENUM_TRAIL_TYPE OBV_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE OBV_TrailingProfitMethod = 1; // Trail profit method
ENUM_APPLIED_PRICE OBV_Applied_Price = 0; // Applied Price
double OBV_SignalLevel = 0.00000000; // Signal level
int OBV1_SignalMethod = 0; // Signal method for M1 (0-
int OBV5_SignalMethod = 0; // Signal method for M5 (0-
int OBV15_SignalMethod = 0; // Signal method for M15 (0-
int OBV30_SignalMethod = 0; // Signal method for M30 (0-
int OBV1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int OBV1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT OBV1_CloseCondition = C_OBV_BUY_SELL; // Close condition for M1
int OBV5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int OBV5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT OBV5_CloseCondition = C_OBV_BUY_SELL; // Close condition for M5
int OBV15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int OBV15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT OBV15_CloseCondition = C_OBV_BUY_SELL; // Close condition for M15
int OBV30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int OBV30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT OBV30_CloseCondition = C_OBV_BUY_SELL; // Close condition for M30
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
ENUM_TRAIL_TYPE OSMA_TrailingStopMethod = 18; // Trail stop method
ENUM_TRAIL_TYPE OSMA_TrailingProfitMethod = 22; // Trail profit method
int OSMA_Period_Fast = 11; // Period Fast
int OSMA_Period_Slow = 42; // Period Slow
int OSMA_Period_Signal = 9; // Period for signal
double OSMA_Period_Ratio = 1.0; // Period ratio between timeframes (0.5-1.5)
ENUM_APPLIED_PRICE OSMA_Applied_Price = 0; // Applied Price
double OSMA_SignalLevel = 1.20000000; // Signal level
int OSMA1_SignalMethod = 15; // Signal method for M1 (0-
int OSMA5_SignalMethod = 9; // Signal method for M5 (0-
int OSMA15_SignalMethod = 24; // Signal method for M15 (0-
int OSMA30_SignalMethod = 14; // Signal method for M30 (0-
int OSMA1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int OSMA1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT OSMA1_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M1
int OSMA5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int OSMA5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT OSMA5_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M5
int OSMA15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int OSMA15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT OSMA15_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M15
int OSMA30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int OSMA30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT OSMA30_CloseCondition = C_OSMA_BUY_SELL; // Close condition for M30
double OSMA1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double OSMA5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double OSMA15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double OSMA30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --"; // >>> RSI <<<
extern bool RSI1_Active = 0; // Enable for M1
extern bool RSI5_Active = 0; // Enable for M5
extern bool RSI15_Active = 0; // Enable for M15
extern bool RSI30_Active = 1; // Enable for M30
extern int RSI_Period = 21; // Period
extern double RSI_Period_Ratio = 1.0; // Period ratio between timeframes (0.5-1.5)
extern ENUM_APPLIED_PRICE RSI_Applied_Price = 4; // Applied Price
extern int RSI_Shift = -2; // Shift
extern ENUM_TRAIL_TYPE RSI_TrailingStopMethod = 3; // Trail stop method
extern ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = 15; // Trail profit method
extern int RSI_SignalLevel = 2; // Signal level
extern int RSI1_SignalMethod = 36; // Signal method for M1 (-63-63)
extern int RSI5_SignalMethod = 36; // Signal method for M5 (-63-63)
extern int RSI15_SignalMethod = 8; // Signal method for M15 (-63-63)
extern int RSI30_SignalMethod = 8; // Signal method for M30 (-63-63)
// bool RSI_DynamicPeriod = False;
int RSI1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int RSI1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT RSI1_CloseCondition = C_RSI_BUY_SELL; // Close condition for M1
int RSI5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int RSI5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT RSI5_CloseCondition = C_RSI_BUY_SELL; // Close condition for M5
int RSI15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int RSI15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT RSI15_CloseCondition = C_RSI_BUY_SELL; // Close condition for M15
int RSI30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int RSI30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT RSI30_CloseCondition = C_RSI_BUY_SELL; // Close condition for M30
double RSI1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double RSI5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double RSI15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double RSI30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __RVI_Parameters__ = "-- Settings for the Relative Vigor Index indicator --"; // >>> RVI <<<
bool RVI1_Active = 0; // Enable for M1
bool RVI5_Active = 0; // Enable for M5
bool RVI15_Active = 0; // Enable for M15
bool RVI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE RVI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE RVI_TrailingProfitMethod = 1; // Trail profit method
int RVI_Shift = 2; // Shift
int RVI_Shift_Far = 0; // Shift Far
double RVI_SignalLevel = 0.00000000; // Signal level
int RVI1_SignalMethod = 0; // Signal method for M1 (0-
int RVI5_SignalMethod = 0; // Signal method for M5 (0-
int RVI15_SignalMethod = 0; // Signal method for M15 (0-
int RVI30_SignalMethod = 0; // Signal method for M30 (0-
int RVI1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int RVI1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT RVI1_CloseCondition = C_RVI_BUY_SELL; // Close condition for M1
int RVI5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int RVI5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT RVI5_CloseCondition = C_RVI_BUY_SELL; // Close condition for M5
int RVI15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int RVI15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT RVI15_CloseCondition = C_RVI_BUY_SELL; // Close condition for M15
int RVI30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int RVI30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT RVI30_CloseCondition = C_RVI_BUY_SELL; // Close condition for M30
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
extern double SAR_Step = 0.15; // Step
extern double SAR_Step_Ratio = 0.3; // Step ratio between timeframes (0.5-1.5)
extern double SAR_Maximum_Stop = 0.40000000; // Maximum stop
extern int SAR_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE SAR_TrailingStopMethod = 2; // Trail stop method
extern ENUM_TRAIL_TYPE SAR_TrailingProfitMethod = 23; // Trail profit method
extern double SAR_SignalLevel = 0.00000000; // Signal level
extern int SAR1_SignalMethod = 0; // Signal method for M1 (-127-127)
extern int SAR5_SignalMethod = 1; // Signal method for M5 (-127-127)
extern int SAR15_SignalMethod = 1; // Signal method for M15 (-127-127)
extern int SAR30_SignalMethod = 5; // Signal method for M30 (-127-127)
int SAR1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int SAR1_OpenCondition2 = 5;   // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT SAR1_CloseCondition = C_SAR_BUY_SELL; // Close condition for M1
int SAR5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int SAR5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT SAR5_CloseCondition = C_SAR_BUY_SELL; // Close condition for M5
int SAR15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int SAR15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT SAR15_CloseCondition = C_SAR_BUY_SELL; // Close condition for M15
int SAR30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int SAR30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT SAR30_CloseCondition = C_SAR_BUY_SELL; // Close condition for M30
double SAR1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double SAR5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double SAR15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double SAR30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __StdDev_Parameters__ = "-- Settings for the Standard Deviation indicator --"; // >>> STDDEV <<<
bool StdDev1_Active = 0; // Enable for M1
bool StdDev5_Active = 0; // Enable for M5
bool StdDev15_Active = 0; // Enable for M15
bool StdDev30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE StdDev_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE StdDev_TrailingProfitMethod = 1; // Trail profit method
ENUM_APPLIED_PRICE StdDev_Applied_Price = 0; // Applied Price
int StdDev_MA_Period = 10; // Period
ENUM_MA_METHOD StdDev_MA_Method = 0; // MA Method
int StdDev_MA_Shift = 0; // Shift
double StdDev_SignalLevel = 0.00000000; // Signal level
int StdDev1_SignalMethod = 31; // Signal method for M1 (0-
int StdDev5_SignalMethod = 31; // Signal method for M5 (0-
int StdDev15_SignalMethod = 31; // Signal method for M15 (0-
int StdDev30_SignalMethod = 31; // Signal method for M30 (0-
int StdDev1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int StdDev1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT StdDev1_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M1
int StdDev5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int StdDev5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT StdDev5_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M5
int StdDev15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int StdDev15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT StdDev15_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M15
int StdDev30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int StdDev30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT StdDev30_CloseCondition = C_STDDEV_BUY_SELL; // Close condition for M30
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
ENUM_TRAIL_TYPE Stochastic_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Stochastic_TrailingProfitMethod = 1; // Trail profit method
double Stochastic_SignalLevel = 0.00000000; // Signal level
int Stochastic1_SignalMethod = 0; // Signal method for M1 (0-
int Stochastic5_SignalMethod = 0; // Signal method for M5 (0-
int Stochastic15_SignalMethod = 0; // Signal method for M15 (0-
int Stochastic30_SignalMethod = 0; // Signal method for M30 (0-
int Stochastic1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int Stochastic1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT Stochastic1_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M1
int Stochastic5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int Stochastic5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT Stochastic5_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M5
int Stochastic15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int Stochastic15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT Stochastic15_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M15
int Stochastic30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int Stochastic30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT Stochastic30_CloseCondition = C_STOCHASTIC_BUY_SELL; // Close condition for M30
double Stochastic1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double Stochastic5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double Stochastic15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double Stochastic30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
extern string __WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --"; // >>> WPR <<<
extern bool WPR1_Active = 0; // Enable for M1
extern bool WPR5_Active = 0; // Enable for M5
extern bool WPR15_Active = 0; // Enable for M15
extern bool WPR30_Active = 0; // Enable for M30
extern int WPR_Period = 9; // Period
extern double WPR_Period_Ratio = 0.2; // Period ratio between timeframes (0.5-1.5)
extern int WPR_Shift = -2; // Shift
extern int WPR_SignalLevel = -7; // Signal level
extern ENUM_TRAIL_TYPE WPR_TrailingStopMethod = -23; // Trail stop method
extern ENUM_TRAIL_TYPE WPR_TrailingProfitMethod = -7; // Trail profit method
extern int WPR1_SignalMethod = 36; // Signal method for M1 (-63-63)
extern int WPR5_SignalMethod = -60; // Signal method for M5 (-63-63)
extern int WPR15_SignalMethod = -60; // Signal method for M15 (-63-63)
extern int WPR30_SignalMethod = -60; // Signal method for M30 (-63-63)
int WPR1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int WPR1_OpenCondition2 = 5; // Open condition 2 for M1 (0-1023)
ENUM_MARKET_EVENT WPR1_CloseCondition = C_WPR_BUY_SELL; // Close condition for M1
int WPR5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int WPR5_OpenCondition2 = 5; // Open condition 2 for M5 (0-1023)
ENUM_MARKET_EVENT WPR5_CloseCondition = C_WPR_BUY_SELL; // Close condition for M5
int WPR15_OpenCondition1 = 7; // Open condition 1 for M15 (0-1023)
int WPR15_OpenCondition2 = 5; // Open condition 2 for M15 (0-1023)
ENUM_MARKET_EVENT WPR15_CloseCondition = C_WPR_BUY_SELL; // Close condition for M15
int WPR30_OpenCondition1 = 7; // Open condition 1 for M30 (0-1023)
int WPR30_OpenCondition2 = 5; // Open condition 2 for M30 (0-1023)
ENUM_MARKET_EVENT WPR30_CloseCondition = C_WPR_BUY_SELL; // Close condition for M30
double WPR1_MaxSpread  =  6.0; // Max spread to trade for M1 (pips)
double WPR5_MaxSpread  =  7.0; // Max spread to trade for M5 (pips)
double WPR15_MaxSpread =  8.0; // Max spread to trade for M15 (pips)
double WPR30_MaxSpread = 10.0; // Max spread to trade for M30 (pips)

//+------------------------------------------------------------------+
string __ZigZag_Parameters__ = "-- Settings for the ZigZag indicator --"; // >>> ZIGZAG <<<
bool ZigZag1_Active = 0; // Enable for M1
bool ZigZag5_Active = 0; // Enable for M5
bool ZigZag15_Active = 0; // Enable for M15
bool ZigZag30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE ZigZag_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE ZigZag_TrailingProfitMethod = 1; // Trail profit method
double ZigZag_SignalLevel = 0.00000000; // Signal level
int ZigZag1_SignalMethod = 0; // Signal method for M1 (0-31)
int ZigZag5_SignalMethod = 0; // Signal method for M5 (0-31)
int ZigZag15_SignalMethod = 0; // Signal method for M15 (0-31)
int ZigZag30_SignalMethod = 0; // Signal method for M30 (0-31)
int ZigZag1_OpenCondition1 = 7; // Open condition 1 for M1 (0-1023)
int ZigZag1_OpenCondition2 = 5; // Open condition 2 for M1 (0-)
ENUM_MARKET_EVENT ZigZag1_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M1
int ZigZag5_OpenCondition1 = 7; // Open condition 1 for M5 (0-1023)
int ZigZag5_OpenCondition2 = 5; // Open condition 2 for M5 (0-)
ENUM_MARKET_EVENT ZigZag5_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M5
int ZigZag15_OpenCondition1 = 7; // Open condition 1 for M15 (0-)
int ZigZag15_OpenCondition2 = 5; // Open condition 2 for M15 (0-)
ENUM_MARKET_EVENT ZigZag15_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M15
int ZigZag30_OpenCondition1 = 7; // Open condition 1 for M30 (0-)
int ZigZag30_OpenCondition2 = 5; // Open condition 2 for M30 (0-)
ENUM_MARKET_EVENT ZigZag30_CloseCondition = C_ZIGZAG_BUY_SELL; // Close condition for M30
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
int TrailingStopDelay = 0; // Trail stop delay
// How often job list should be processed (in seconds).
int JobProcessDelay = 1; // Job process delay

// Cache some calculated variables for better performance. FIXME: Needs some work.
#ifdef __experimental__
  extern bool Cache = FALSE; // Cache
#else
  const bool Cache = FALSE; // Cache
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
// extern bool SendLogs = FALSE; // Send logs to remote host for diagnostic purposes

//+------------------------------------------------------------------+
extern string __Backtest_Parameters__ = "-- Testing & troubleshooting parameters --"; // >>> TESTING <<<
#ifndef __backtest__
  extern bool ValidateSettings = 0; // Validate startup settings
#else
  extern bool ValidateSettings = 1; // Validate startup settings
#endif
extern bool RecordTicksToCSV = 0; // Record ticks into CSV files
#ifdef __profiler__ extern #endif uint ProfilingMinTime = 1; // Displays EA profiling times (0 - off)
extern int AccountConditionToDisable = 0; // Override: Disable specific n action
extern bool DisableCloseConditions = 0; // Override: Disable all close conditions
// extern int DemoMarketStopLevel = 10; // Demo market stop level

//+------------------------------------------------------------------+
extern string __EA_Constants__ = "-- Constants --"; // >>> CONSTANTS <<<
extern int MagicNumber = 31337; // Starting EA magic number (+40)

//+------------------------------------------------------------------+
extern string __Other_Parameters__ = "-- Other parameters --"; // >>> OTHER <<<
