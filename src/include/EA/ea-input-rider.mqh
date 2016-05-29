//+------------------------------------------------------------------+
//|                                               ea-input-rider.mqh |
//|                                           Copyright 2016, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, kenorb"
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| Includes.
//+------------------------------------------------------------------+
#include <EA\ea-enums.mqh>

//+------------------------------------------------------------------+
//| User input variables.
//+------------------------------------------------------------------+
extern string __EA_Order_Parameters__ = "-- Profit/Loss settings (set 0 for auto) --";
#ifndef __limited__
  extern double LotSize = 0; // Default lot size. Set 0 for auto.
#else // Limit to micro lot.
  extern double LotSize = 0.01;
#endif
extern double TakeProfit = 0.0; // Take profit value in pips. [start=0,step=10,stop=80]
extern double StopLoss = 0.0; // Stop loss value in pips. [start=0,step=10,stop=80]
#ifndef __limited__
  extern int MaxOrders = 0; // Maximum orders. Set 0 for auto.
#else
  extern int MaxOrders = 30;
#endif
extern int MaxOrdersPerType = 0; // Maximum orders per strategy type. Set 0 for auto.
#ifndef __limited__
  extern int MinimumIntervalSec = 0; // Minimum interval between subsequent trade signals. Suggested value: 0 or 60.
  extern int MaxOrdersPerDay = 0; // Minimum number of orders to open per day.
#else // Limited.
  extern int MaxOrdersPerDay = 30;
  extern int MinimumIntervalSec = 240;
#endif
extern bool TradeMicroLots = TRUE;
//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Settings for trailing stops --";
extern int TrailingStop = 40;
extern ENUM_TRAIL_TYPE DefaultTrailingStopMethod = T_FIXED; // TrailingStop method. Set 0 to disable. See: ENUM_TRAIL_TYPE.
extern bool TrailingStopOneWay = TRUE; // Change trailing stop towards one direction only. Suggested value: TRUE
extern int TrailingProfit = 30;
extern ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = T_NONE; // Trailing Profit method. Set 0 to disable. See: ENUM_TRAIL_TYPE.
extern bool TrailingProfitOneWay = TRUE; // Change trailing profit take towards one direction only.
extern double TrailingStopAddPerMinute = 0.0; // Decrease trailing stop (in pips) per each bar. Set 0 to disable. Suggested value: 0.
//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management --";
extern double RiskRatio = 0; // Suggested value: 1.0. Do not change unless testing.
#ifndef __trend__
  extern bool TradeWithTrend = FALSE; // Default. Trade with trend only to minimalize the risk.
#else
  extern bool TradeWithTrend = TRUE; // Trade with trend.
#endif
extern bool MinimalizeLosses = FALSE; // Set stop loss to zero, once the order is profitable.
extern int RiskRatioIncreaseMethod = 112; // Risk ratio calculation method when RiskRatio is set to 0. Valid range: 0-255.
extern int RiskRatioDecreaseMethod = 216; // Risk ratio calculation method when RiskRatio is set to 0. Valid range: 0-255.
// Prev: £13130.03	32536	1.13	0.40	7241.88	57.42%	0.00000000	RiskRatioIncreaseMethod=34	RiskRatioDecreaseMethod=58 (dep: £10k, spread: 20, 01-06.2015)
/* Backtest log (ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, spread 20, quality 25%]:
  9006.16	17263	1.09	0.52	4625.19	63.17%	0.00000000	RiskRatioIncreaseMethod=112 	RiskRatioDecreaseMethod=216 	LotSizeIncreaseMethod=202 	LotSizeDecreaseMethod=167
  7367.18	18891	1.08	0.39	5095.59	61.06%	0.00000000	RiskRatioIncreaseMethod=214 	RiskRatioDecreaseMethod=200 	LotSizeIncreaseMethod=222 	LotSizeDecreaseMethod=142
  6978.63	19650	1.07	0.36	5832.82	62.51%	0.00000000	RiskRatioIncreaseMethod=0 	RiskRatioDecreaseMethod=0 	LotSizeIncreaseMethod=14 	LotSizeDecreaseMethod=81
  6918.15	18846	1.07	0.37	6453.92	64.88%	0.00000000	RiskRatioIncreaseMethod=0 	RiskRatioDecreaseMethod=0 	LotSizeIncreaseMethod=1 	LotSizeDecreaseMethod=1
  6746.91	18926	1.06	0.36	5941.86	65.12%	0.00000000	RiskRatioIncreaseMethod=197 	RiskRatioDecreaseMethod=132 	LotSizeIncreaseMethod=9 	LotSizeDecreaseMethod=96
*/
#ifndef __nospreads__
  extern bool ApplySpreadLimits = TRUE; // Apply strategy spread limits.
#else
  extern bool ApplySpreadLimits = FALSE;
#endif
extern double MaxSpreadToTrade = 10.0; // Maximum spread to trade (in pips). Only applied if ApplySpreadLimits is TRUE.
//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting (set 1.0 to default) --";
#ifndef __noboost__
  extern bool Boosting_Enabled                       = TRUE; // Default. Enable boosting section.
#else
  extern bool Boosting_Enabled                       = FALSE;
#endif
#ifndef __nofactor__
  extern double BestDailyStrategyMultiplierFactor    = 1.1; // Lot multiplier boosting factor for the most profitable daily strategy.
  extern double BestWeeklyStrategyMultiplierFactor   = 1.2; // Lot multiplier boosting factor for the most profitable weekly strategy.
  extern double BestMonthlyStrategyMultiplierFactor  = 1.5; // Lot multiplier boosting factor for the most profitable monthly strategy.
  extern double WorseDailyStrategyDividerFactor      = 1.2; // Lot divider factor for the most profitable daily strategy. Useful for low-balance accounts or non-profitable periods.
  extern double WorseWeeklyStrategyDividerFactor     = 1.2; // Lot divider factor for the most profitable weekly strategy. Useful for low-balance accounts or non-profitable periods.
  extern double WorseMonthlyStrategyDividerFactor    = 1.2; // Lot divider factor for the most profitable monthly strategy. Useful for low-balance accounts or non-profitable periods.
#else
  extern double BestDailyStrategyMultiplierFactor    = 1.0; // Lot multiplier boosting factor for the most profitable daily strategy.
  extern double BestWeeklyStrategyMultiplierFactor   = 1.0; // Lot multiplier boosting factor for the most profitable weekly strategy.
  extern double BestMonthlyStrategyMultiplierFactor  = 1.0; // Lot multiplier boosting factor for the most profitable monthly strategy.
  extern double WorseDailyStrategyDividerFactor      = 1.0;
  extern double WorseWeeklyStrategyDividerFactor     = 1.0;
  extern double WorseMonthlyStrategyDividerFactor    = 1.0;
#endif
extern double BoostTrendFactor                     = 1.0; // Disable boost trend for rider mode.
extern int LotSizeIncreaseMethod = 202; // Lot size calculation method when LotSize is set to 0. Valid range: 0-255.
extern int LotSizeDecreaseMethod = 167; // Lot size calculation method when LotSize is set to 0. Valid range: 0-255.
extern bool BoostByProfitFactor                  = FALSE; // Disable boost by pf for rider strategy.
extern bool HandicapByProfitFactor               = FALSE; // Handicap by low profit factor.
//+------------------------------------------------------------------+
extern string __Market_Parameters__ = "-- Market parameters --";
extern int TrendMethod = 181; // Method of main trend calculation. Valid range: 0-255. Suggested values: 65!, 71, 81, 83!, 87, 181, etc.
/* Backtest log (ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
  £11347.25	20908	1.03	0.54	17245.91	58.84%	TrendMethod=181 (d: £10k, spread 24)
  £11383.51	20278	1.04	0.56	22825.00	67.72%	TrendMethod=81 (d: £10k, spread 24)
  £3146.85	20099	1.01	0.16	25575.87	77.54%	TrendMethod=81 (d: £10k, spread 28)
  £1668.90	20747	1.01	0.08	17142.41	71.64%	TrendMethod=181 (d: £10k, spread 28)
*/
  extern int TrendMethodAction = 17;
/* Backtest log (ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
     £129847.70	5406	1.25	24.02	83328.01	72.67%	TrendMethodAction=17 (d: £2k, spread 20, __rider__, auto)
     £84538.74	5282	1.21	16.01	64259.13	72.67%	TrendMethodAction=16 (d: £2k, spread 20, __rider__, auto)
     £71144.36	5323	1.29	13.37	34450.52	70.68%	TrendMethodAction=25 (d: £2k, spread 20, __rider__, auto)
*/
extern int MinVolumeToTrade = 2; // Minimum volume to trade.
extern int MaxOrderPriceSlippage = 5; // Maximum price slippage for buy or sell orders (in pips).
extern int DemoMarketStopLevel = 10;
extern int MaxTries = 5; // Number of maximum attempts to execute the order.
extern int MarketSuddenDropSize = 10; // Size of sudden price drop in pips to react when the market drops.
extern int MarketBigDropSize = 50; // Size of big sudden price drop in pips to react when the market drops.
extern double MinPipChangeToTrade = 0.7; // Minimum pip change to trade before the bar change. Set 0 to process every tick. Lower is better for small spreads and other way round.
extern int MinPipGap = 10; // Minimum gap in pips between trades of the same strategy.
//+------------------------------------------------------------------+
extern string __Advanced_Parameters__ = "-- Advanced parameters --";
extern bool QueueOrdersAIActive = TRUE; // Activate AI queue orders for selecting the best strategy to open. At least 2 orders needs to be queued in order to be processed.
extern int QueueOrdersAIMethod = 3; // Method for selecting best order to open from the orders queue. Valid range: 0-15.
extern int QueueOrdersAIFilter = 27; // Method for filtering the orders from the queue. Valid range: 0-255.
extern bool CloseConditionOnlyProfitable = TRUE; // Close conditions applies only for profitable orders.
extern bool DisableCloseConditions = FALSE; // Set TRUE to disable all close conditions for strategies. Not useful apart of testing.
extern int HourAfterPeak = 18; // Minimum hour to check for peak prices, used by C_DAILY_PEAK, etc.
extern int CloseConditionCustom1Method = 0; // Custom 1 indicator-based close condition. Valid range: 0-1023.
extern int CloseConditionCustom2Method = 0; // Custom 2 indicator-based close condition. Valid range: 0-1023.
extern int CloseConditionCustom3Method = 0; // Custom 3 indicator-based close condition. Valid range: 0-1023.
extern int CloseConditionCustom4Method = 0; // Custom 4 market-based close condition. Valid range: 0-1023.
extern int CloseConditionCustom5Method = 0; // Custom 5 market-based close condition. Valid range: 0-1023.
extern int CloseConditionCustom6Method = 0; // Custom 6 market-based close condition. Valid range: 0-1023.
extern bool DynamicSpreadConf = FALSE; // Dynamically calculate most optimal settings based on the current spread (MinPipChangeToTrade/MinPipGap).
extern int SmartToggleComponent = 0; // Dynamically toggle different components. Use only to troubleshoot the overall performance during the optimization. Valid range: 0-43.
int SpreadRatio = 1.0;
//+------------------------------------------------------------------+
extern string __EA_Conditions__ = "-- Account conditions --"; // See: ENUM_ACTION_TYPE
#ifndef __noactions__
  extern bool Account_Conditions_Active = TRUE; // Enable account conditions. It's not advice on accounts where multi bots are trading.
#else
  extern bool Account_Conditions_Active = FALSE;
#endif

#ifndef __limited__

extern ENUM_ACC_CONDITION Account_Condition_1      = C_ACC_NONE;
extern ENUM_MARKET_CONDITION Market_Condition_1    = C_MARKET_NONE;
extern ENUM_ACTION_TYPE Action_On_Condition_1      = A_NONE;

extern ENUM_ACC_CONDITION Account_Condition_2      = C_ACC_NONE;
extern ENUM_MARKET_CONDITION Market_Condition_2    = C_MARKET_NONE;
extern ENUM_ACTION_TYPE Action_On_Condition_2      = A_NONE;

extern ENUM_ACC_CONDITION Account_Condition_3      = C_EQUITY_20PC_LOW;
extern ENUM_MARKET_CONDITION Market_Condition_3    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_3      = A_CLOSE_ALL_IN_PROFIT;

extern ENUM_ACC_CONDITION Account_Condition_4      = C_EQUITY_50PC_LOW;
extern ENUM_MARKET_CONDITION Market_Condition_4    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_4      = A_CLOSE_ALL_LOSS_SIDE;

extern ENUM_ACC_CONDITION Account_Condition_5      = C_ACC_NONE;
extern ENUM_MARKET_CONDITION Market_Condition_5    = C_MARKET_NONE;
extern ENUM_ACTION_TYPE Action_On_Condition_5      = A_NONE;

extern ENUM_ACC_CONDITION Account_Condition_6      = C_ACC_NONE;
extern ENUM_MARKET_CONDITION Market_Condition_6    = C_MARKET_NONE;
extern ENUM_ACTION_TYPE Action_On_Condition_6      = A_NONE;

extern ENUM_ACC_CONDITION Account_Condition_7      = C_EQUITY_50PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_7    = C_MA1_FS_TREND_OPP;
extern ENUM_ACTION_TYPE Action_On_Condition_7      = A_CLOSE_ORDER_PROFIT_MIN;

extern ENUM_ACC_CONDITION Account_Condition_8      = C_MARGIN_USED_80PC;
extern ENUM_MARKET_CONDITION Market_Condition_8    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_8      = A_CLOSE_ALL_NON_TREND;

extern ENUM_ACC_CONDITION Account_Condition_9      = C_MARGIN_USED_90PC;
extern ENUM_MARKET_CONDITION Market_Condition_9    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_9      = A_CLOSE_ORDER_LOSS;

extern ENUM_ACC_CONDITION Account_Condition_10     = C_EQUITY_HIGHER;
extern ENUM_MARKET_CONDITION Market_Condition_10   = C_MARKET_BIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_10     = A_CLOSE_ORDER_PROFIT_MIN;

extern ENUM_ACC_CONDITION Account_Condition_11     = C_ACC_TRUE;
extern ENUM_MARKET_CONDITION Market_Condition_11   = C_MARKET_VBIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_11     = A_CLOSE_ALL_NON_TREND;

extern ENUM_ACC_CONDITION Account_Condition_12     = C_EQUITY_50PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_12   = C_MA30_FS_TREND_OPP;
extern ENUM_ACTION_TYPE Action_On_Condition_12     = A_CLOSE_ALL_LOSS_SIDE;
  /*
    77576.22	5258	1.44	14.75	24957.91	77.13%	Market_Condition_12=9 	Action_On_Condition_12=6 (d: £2k, spread: 20, 2015.01.01-06.30)
    50903.83	5452	1.29	9.34	21735.21	66.82%	Market_Condition_12=9 	Action_On_Condition_12=4 (d: £2k, spread: 20, 2015.01.01-06.30)
    44363.39	5433	1.30	8.17	22401.58	68.00%	Market_Condition_12=8 	Action_On_Condition_12=1 (d: £2k, spread: 20, 2015.01.01-06.30)
  */

#else // Actions for rider and limited mode.

extern ENUM_ACC_CONDITION Account_Condition_1      = C_ACC_MAX_ORDERS;
extern ENUM_MARKET_CONDITION Market_Condition_1    = C_DAILY_PEAK;
extern ENUM_ACTION_TYPE Action_On_Condition_1      = A_CLOSE_ORDER_PROFIT_MIN;

extern ENUM_ACC_CONDITION Account_Condition_2      = C_ACC_MAX_ORDERS;
extern ENUM_MARKET_CONDITION Market_Condition_2    = C_WEEKLY_PEAK;
extern ENUM_ACTION_TYPE Action_On_Condition_2      = A_CLOSE_ORDER_PROFIT_MIN;

extern ENUM_ACC_CONDITION Account_Condition_3      = C_EQUITY_20PC_LOW;
extern ENUM_MARKET_CONDITION Market_Condition_3    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_3      = A_CLOSE_ALL_IN_PROFIT;

extern ENUM_ACC_CONDITION Account_Condition_4      = C_EQUITY_50PC_LOW;
extern ENUM_MARKET_CONDITION Market_Condition_4    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_4      = A_CLOSE_ALL_LOSS_SIDE;

extern ENUM_ACC_CONDITION Account_Condition_5      = C_EQUITY_10PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_5    = C_MARKET_BIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_5      = A_CLOSE_ORDER_PROFIT_MIN;

extern ENUM_ACC_CONDITION Account_Condition_6      = C_EQUITY_20PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_6    = C_MARKET_VBIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_6      = A_CLOSE_ORDER_PROFIT_MIN;

extern ENUM_ACC_CONDITION Account_Condition_7      = C_EQUITY_50PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_7    = C_MA1_FS_TREND_OPP;
extern ENUM_ACTION_TYPE Action_On_Condition_7      = A_CLOSE_ORDER_PROFIT_MIN;

extern ENUM_ACC_CONDITION Account_Condition_8      = C_MARGIN_USED_80PC;
extern ENUM_MARKET_CONDITION Market_Condition_8    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_8      = A_CLOSE_ALL_NON_TREND;

extern ENUM_ACC_CONDITION Account_Condition_9      = C_MARGIN_USED_90PC;
extern ENUM_MARKET_CONDITION Market_Condition_9    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_9      = A_CLOSE_ORDER_LOSS;

extern ENUM_ACC_CONDITION Account_Condition_10     = C_ACC_NONE;
extern ENUM_MARKET_CONDITION Market_Condition_10   = C_MARKET_NONE;
extern ENUM_ACTION_TYPE Action_On_Condition_10     = A_NONE;

extern ENUM_ACC_CONDITION Account_Condition_11     = C_ACC_TRUE;
extern ENUM_MARKET_CONDITION Market_Condition_11   = C_MARKET_VBIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_11     = A_CLOSE_ALL_NON_TREND;

extern ENUM_ACC_CONDITION Account_Condition_12     = C_EQUITY_50PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_12   = C_MA30_FS_TREND_OPP;
extern ENUM_ACTION_TYPE Action_On_Condition_12     = A_CLOSE_ALL_LOSS_SIDE;

#endif
extern int Account_Condition_MinProfitCloseOrder = 20; // Minimum order profit in pips to close the order on condition met.

extern int Account_Condition_To_Disable = 0; // Specify which actions should be temporary disabled. It's useful for troubleshooting the worse condition by using the optimization.

//+------------------------------------------------------------------+
extern string __AC_Parameters__ = "-- Settings for the Bill Williams' Accelerator/Decelerator oscillator --";
#ifndef __disabled__
  extern bool AC1_Active = TRUE;
  extern bool AC5_Active = TRUE;
  extern bool AC15_Active = TRUE;
  extern bool AC30_Active = TRUE; // Enable AC-based strategy for specific timeframe.
#else
  extern bool AC1_Active = FALSE;
  extern bool AC5_Active = FALSE;
  extern bool AC15_Active = FALSE;
  extern bool AC30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE AC_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE AC_TrailingProfitMethod = T_FIXED;
extern double AC_OpenLevel = 0; // Not used currently.
extern int AC1_OpenMethod = 0; // Valid range: 0-x.
extern int AC5_OpenMethod = 0; // Valid range: 0-x.
extern int AC15_OpenMethod = 0; // Valid range: 0-x.
extern int AC30_OpenMethod = 0; // Valid range: 0-x.
extern int AC1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int AC1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT AC1_CloseCondition = C_MACD_BUY_SELL;
//
extern int AC5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int AC5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT AC5_CloseCondition = C_MACD_BUY_SELL;
//
extern int AC15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int AC15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT AC15_CloseCondition = C_MACD_BUY_SELL;
//
extern int AC30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int AC30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT AC30_CloseCondition = C_MACD_BUY_SELL;
//
extern double AC1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double AC5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double AC15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double AC30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __AD_Parameters__ = "-- Settings for the Accumulation/Distribution indicator --";
#ifndef __disabled__
  extern bool AD1_Active = TRUE;
  extern bool AD5_Active = TRUE;
  extern bool AD15_Active = TRUE;
  extern bool AD30_Active = TRUE; // Enable AD-based strategy for specific timeframe.
#else
  extern bool AD1_Active = FALSE;
  extern bool AD5_Active = FALSE;
  extern bool AD15_Active = FALSE;
  extern bool AD30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE AD_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE AD_TrailingProfitMethod = T_FIXED;
extern double AD_OpenLevel = 0; // Not used currently.
extern int AD1_OpenMethod = 0; // Valid range: 0-x.
extern int AD5_OpenMethod = 0; // Valid range: 0-x.
extern int AD15_OpenMethod = 0; // Valid range: 0-x.
extern int AD30_OpenMethod = 0; // Valid range: 0-x.
extern int AD1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int AD1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT AD1_CloseCondition = C_MACD_BUY_SELL;
//
extern int AD5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int AD5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT AD5_CloseCondition = C_MACD_BUY_SELL;
//
extern int AD15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int AD15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT AD15_CloseCondition = C_MACD_BUY_SELL;
//
extern int AD30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int AD30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT AD30_CloseCondition = C_MACD_BUY_SELL;
//
extern double AD1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double AD5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double AD15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double AD30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __ADX_Parameters__ = "-- Settings for the Average Directional Movement Index indicator --";
#ifndef __disabled__
  extern bool ADX1_Active = TRUE;
  extern bool ADX5_Active = TRUE;
  extern bool ADX15_Active = TRUE;
  extern bool ADX30_Active = TRUE; // Enable ADX-based strategy for specific timeframe.
#else
  extern bool ADX1_Active = FALSE;
  extern bool ADX5_Active = FALSE;
  extern bool ADX15_Active = FALSE;
  extern bool ADX30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE ADX_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE ADX_TrailingProfitMethod = T_FIXED;
extern int ADX_Period = 14; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE ADX_Applied_Price = PRICE_HIGH; // Bands applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double ADX_OpenLevel = 0; // Not used currently.
extern int ADX1_OpenMethod = 0; // Valid range: 0-x.
extern int ADX5_OpenMethod = 0; // Valid range: 0-x.
extern int ADX15_OpenMethod = 0; // Valid range: 0-x.
extern int ADX30_OpenMethod = 0; // Valid range: 0-x.
extern int ADX1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int ADX1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT ADX1_CloseCondition = C_MACD_BUY_SELL;
//
extern int ADX5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int ADX5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ADX5_CloseCondition = C_MACD_BUY_SELL;
//
extern int ADX15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int ADX15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ADX15_CloseCondition = C_MACD_BUY_SELL;
//
extern int ADX30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int ADX30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ADX30_CloseCondition = C_MACD_BUY_SELL;
//
extern double ADX1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double ADX5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double ADX15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double ADX30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --";
#ifndef __disabled__
  extern bool Alligator1_Active = TRUE;
  extern bool Alligator5_Active = TRUE;
  extern bool Alligator15_Active = TRUE;
  extern bool Alligator30_Active = TRUE; // Enable Alligator custom-based strategy for specific timeframe.
#else
  extern bool Alligator1_Active = FALSE;
  extern bool Alligator5_Active = FALSE;
  extern bool Alligator15_Active = FALSE;
  extern bool Alligator30_Active = FALSE;
#endif
// extern ENUM_TIMEFRAMES Alligator_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int Alligator_Jaw_Period = 22; // Blue line averaging period (Alligator's Jaw).
extern int Alligator_Jaw_Shift = 0; // Blue line shift relative to the chart.
extern int Alligator_Teeth_Period = 10; // Red line averaging period (Alligator's Teeth).
extern int Alligator_Teeth_Shift = 4; // Red line shift relative to the chart.
extern int Alligator_Lips_Period = 9; // Green line averaging period (Alligator's Lips).
extern int Alligator_Lips_Shift = 2; // Green line shift relative to the chart.
extern ENUM_MA_METHOD Alligator_MA_Method = MODE_EMA; // MA method (See: ENUM_MA_METHOD).
extern ENUM_APPLIED_PRICE Alligator_Applied_Price = PRICE_HIGH; // Applied price. It can be any of ENUM_APPLIED_PRICE enumeration values.
extern int Alligator_Shift = 0; // The indicator shift relative to the chart.
extern int Alligator_Shift_Far = 1; // The indicator shift relative to the chart.
extern ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = T_BANDS_PEAK;
extern double Alligator_OpenLevel = 0.01; // Minimum open level between moving averages to raise the trade signal.
extern int Alligator1_OpenMethod  = 6; // Valid range: 0-63.
extern int Alligator5_OpenMethod  = 6; // Valid range: 0-63.
extern int Alligator15_OpenMethod  = 9; // Valid range: 0-63.
extern int Alligator30_OpenMethod  = 13; // Valid range: 0-63. This value is used for close condition. Used for C_MA_BUY_SELL close condition (6). (2765/1.20)
extern int Alligator1_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Alligator1_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT Alligator1_CloseCondition = C_MA_BUY_SELL;
//
extern int Alligator5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Alligator5_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT Alligator5_CloseCondition = C_MA_BUY_SELL;
//
extern int Alligator15_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Alligator15_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT Alligator15_CloseCondition = C_MA_BUY_SELL;
//
extern int Alligator30_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Alligator30_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT Alligator30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Alligator1_MaxSpread  =  6.0;  // Maximum spread to trade (in pips).
extern double Alligator5_MaxSpread  =  7.0;  // Maximum spread to trade (in pips).
extern double Alligator15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Alligator30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * Alligator backtest log (ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
 *   £18429.60	4363	1.32	4.22	14102.48	63.82% (d: £10k, spread 25, lot size: 0.1, no boosts/actions)
 *   £21362.41	2753	1.48	7.76	5174.72	36.07%	0.00000000	Alligator_TrailingStopMethod=22 (rider: d: £10k, spread 20, lot size: 0.1, no boosts, with actions)
 *   £22299.85	2753	1.51	8.10	5106.04	35.06%	0.00000000	Alligator_Jaw_Period=22 	Alligator_Teeth_Period=10 	Alligator_Lips_Period=9 (rider: d: £10k, spread 20, lot size: 0.1, no boosts, with actions)
 */
//+------------------------------------------------------------------+
extern string __ATR_Parameters__ = "-- Settings for the Average True Range indicator --";
#ifndef __disabled__
  extern bool ATR1_Active = TRUE;
  extern bool ATR5_Active = TRUE;
  extern bool ATR15_Active = TRUE;
  extern bool ATR30_Active = TRUE; // Enable ATR-based strategy for specific timeframe.
#else
  extern bool ATR1_Active = FALSE;
  extern bool ATR5_Active = FALSE;
  extern bool ATR15_Active = FALSE;
  extern bool ATR30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE ATR_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for ATR. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ATR_TrailingProfitMethod = T_FIXED; // Trailing Profit method for ATR. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int ATR_Period_Fast = 14; // Averaging period to calculate the main line.
extern int ATR_Period_Slow = 20; // Averaging period to calculate the main line.
extern double ATR_OpenLevel = 0; // Not used currently.
extern int ATR1_OpenMethod = 0; // Valid range: 0-31.
extern int ATR5_OpenMethod = 0; // Valid range: 0-31.
extern int ATR15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int ATR30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int ATR1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int ATR1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT ATR1_CloseCondition = C_MACD_BUY_SELL;
//
extern int ATR5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int ATR5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ATR5_CloseCondition = C_MACD_BUY_SELL;
//
extern int ATR15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int ATR15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ATR15_CloseCondition = C_MACD_BUY_SELL;
//
extern int ATR30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int ATR30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ATR30_CloseCondition = C_MACD_BUY_SELL;
//
extern double ATR1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double ATR5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double ATR15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double ATR30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Awesome_Parameters__ = "-- Settings for the Awesome oscillator --";
#ifndef __disabled__
  extern bool Awesome1_Active = TRUE;
  extern bool Awesome5_Active = TRUE;
  extern bool Awesome15_Active = TRUE;
  extern bool Awesome30_Active = TRUE; // Enable Awesome-based strategy for specific timeframe.
#else
  extern bool Awesome1_Active = FALSE;
  extern bool Awesome5_Active = FALSE;
  extern bool Awesome15_Active = FALSE;
  extern bool Awesome30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE Awesome_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Awesome. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Awesome_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Awesome. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double Awesome_OpenLevel = 0; // Not used currently.
extern int Awesome1_OpenMethod = 0; // Valid range: 0-31.
extern int Awesome5_OpenMethod = 0; // Valid range: 0-31.
extern int Awesome15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Awesome30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int Awesome1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int Awesome1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Awesome1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Awesome5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Awesome5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Awesome5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Awesome15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Awesome15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Awesome15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Awesome30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Awesome30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Awesome30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Awesome1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Awesome5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Awesome15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Awesome30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --";
#ifndef __disabled__
  extern bool Bands1_Active = TRUE;
  extern bool Bands5_Active = TRUE;
  extern bool Bands15_Active = TRUE;
  extern bool Bands30_Active = TRUE; // Enable Bands-based strategy fpr specific timeframe.
#else
  extern bool Bands1_Active = FALSE;
  extern bool Bands5_Active = FALSE;
  extern bool Bands15_Active = FALSE;
  extern bool Bands30_Active = FALSE;
#endif
extern int Bands_Period = 26; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE Bands_Applied_Price = PRICE_MEDIAN; // Bands applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double Bands_Deviation = 2.1; // Number of standard deviations from the main line.
extern int Bands_Shift = 0; // The indicator shift relative to the chart.
extern int Bands_Shift_Far = 0; // The indicator shift relative to the chart.
//extern bool Bands_CloseOnChange = FALSE; // Close opposite orders on market change.
extern ENUM_TRAIL_TYPE Bands_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Bands. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Bands_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Bands. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
/* extern */ int Bands_OpenLevel = 0; // TODO
extern int Bands1_OpenMethod = 0; // Valid range: 0-255.
extern int Bands5_OpenMethod = 0; // Valid range: 0-255.
extern int Bands15_OpenMethod = 16; // Valid range: 0-255.
extern int Bands30_OpenMethod = 0; // Valid range: 0-255. Previously: 417. Used for C_BANDS_BUY_SELL close condition.
extern int Bands1_OpenCondition1 = 528; // Valid range: 0-1023. // TODO
extern int Bands1_OpenCondition2 = 0; // Valid range: 0-1023. // TODO
extern ENUM_MARKET_EVENT Bands1_CloseCondition = C_MACD_BUY_SELL;
// £11618.71	741	1.81	15.68	5546.73	21.70%	0.00000000	Bands1_OpenCondition1=528	TrailingStop=40 (d: £10k, sp: 20, ls:0.1, __testing__)
// £11236.18	926	1.62	12.13	4957.40	25.95%	0.00000000	Bands1_OpenMethod=16 	Bands1_OpenCondition1=16 (d: £10k, sp: 20, ls:0.1, __testing__)
// £10762.86	937	1.58	11.49	4835.66	26.13%	0.00000000	Bands1_OpenMethod=0 	Bands1_OpenCondition1=16 (d: £10k, sp: 20, ls:0.1, __testing__)
extern int Bands5_OpenCondition1 = 528; // Valid range: 0-1023. // TODO
extern int Bands5_OpenCondition2 = 0; // Valid range: 0-1023. // TODO
extern ENUM_MARKET_EVENT Bands5_CloseCondition = C_MACD_BUY_SELL;
// £8599.17	644	1.69	13.35	4715.84	20.73%	0.00000000	Bands5_OpenCondition1=528 (d: £10k, sp: 20, ls:0.1, __testing__)
// £7379.55	1119	1.33	6.59	6926.42	29.15%	0.00000000	Bands5_OpenMethod=0 	Bands5_OpenCondition2=0 (d: £10k, sp: 20, ls:0.1, __testing__)
extern int Bands15_OpenCondition1 = 0; // Valid range: 0-1023. // TODO
extern int Bands15_OpenCondition2 = 0; // Valid range: 0-1023. // TODO
extern ENUM_MARKET_EVENT Bands15_CloseCondition = C_MACD_BUY_SELL;
// £6475.19	1020	1.32	6.35	7177.96	31.84%	0.00000000	Bands15_OpenMethod=16 	Bands15_OpenCondition2=0 	Bands15_CloseCondition=2 (d: £10k, sp: 20, ls:0.1, __testing__)
extern int Bands30_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Bands30_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT Bands30_CloseCondition = C_MACD_BUY_SELL;
// £6710.23	935	1.37	7.18	5805.15	28.88%	0.00000000	Bands30_OpenMethod=0 	Bands30_CloseCondition=2 (d: £10k, sp: 20, ls:0.1, __testing__)
extern double Bands1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Bands5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Bands15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Bands30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * Bands backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
 *   £30087.06	3123	1.49	9.63	21508.48	59.74% Bands_TrailingProfitMethod=7 (d: £10k, sp: 20, ls:0.1, __testing__)
 *   £28420.72	3126	1.47	9.09	20860.99	65.05% Bands_TrailingProfitMethod=1 (d: £10k, sp: 20, ls:0.1, __testing__)
 *
 *   Strategy stats (deposit: £10000, spread 20, ls:auto, __testing__):
 */
//+------------------------------------------------------------------+
extern string __BPower_Parameters__ = "-- Settings for the Bulls/Bears Power indicator --";
#ifndef __disabled__
  extern bool BPower1_Active = TRUE;
  extern bool BPower5_Active = TRUE;
  extern bool BPower15_Active = TRUE;
  extern bool BPower30_Active = TRUE; // Enable BPower-based strategy for specific timeframe.
#else
  extern bool BPower1_Active = FALSE;
  extern bool BPower5_Active = FALSE;
  extern bool BPower15_Active = FALSE;
  extern bool BPower30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE BPower_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE BPower_TrailingProfitMethod = T_FIXED;
extern int BPower_Period = 13; // Averaging period for calculation.
extern ENUM_APPLIED_PRICE BPower_Applied_Price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double BPower_OpenLevel = 0; // Not used currently.
extern int BPower1_OpenMethod = 0; // Valid range: 0-x.
extern int BPower5_OpenMethod = 0; // Valid range: 0-x.
extern int BPower15_OpenMethod = 0; // Valid range: 0-x. // Optimized.
extern int BPower30_OpenMethod = 0; // Valid range: 0-x. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int BPower1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int BPower1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT BPower1_CloseCondition = C_MACD_BUY_SELL;
//
extern int BPower5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int BPower5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT BPower5_CloseCondition = C_MACD_BUY_SELL;
//
extern int BPower15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int BPower15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT BPower15_CloseCondition = C_MACD_BUY_SELL;
//
extern int BPower30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int BPower30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT BPower30_CloseCondition = C_MACD_BUY_SELL;
//
extern double BPower1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double BPower5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double BPower15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double BPower30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Breakage_Parameters__ = "-- Settings for the custom Breakage strategy --";
#ifndef __disabled__
  extern bool Breakage1_Active = TRUE;
  extern bool Breakage5_Active = TRUE;
  extern bool Breakage15_Active = TRUE;
  extern bool Breakage30_Active = TRUE; // Enable Breakage-based strategy for specific timeframe.
#else
  extern bool Breakage1_Active = FALSE;
  extern bool Breakage5_Active = FALSE;
  extern bool Breakage15_Active = FALSE;
  extern bool Breakage30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE Breakage_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Breakage. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Breakage_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Breakage. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double Breakage_OpenLevel = 0; // Not used currently.
extern int Breakage1_OpenMethod = 0; // Valid range: 0-31.
extern int Breakage5_OpenMethod = 0; // Valid range: 0-31.
extern int Breakage15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Breakage30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int Breakage1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int Breakage1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Breakage1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Breakage5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Breakage5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Breakage5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Breakage15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Breakage15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Breakage15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Breakage30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Breakage30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Breakage30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Breakage1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Breakage5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Breakage15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Breakage30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __BWMFI_Parameters__ = "-- Settings for the Market Facilitation Index indicator --";
#ifndef __disabled__
  extern bool BWMFI1_Active = TRUE;
  extern bool BWMFI5_Active = TRUE;
  extern bool BWMFI15_Active = TRUE;
  extern bool BWMFI30_Active = TRUE; // Enable BWMFI-based strategy for specific timeframe.
#else
  extern bool BWMFI1_Active = FALSE;
  extern bool BWMFI5_Active = FALSE;
  extern bool BWMFI15_Active = FALSE;
  extern bool BWMFI30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE BWMFI_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for BWMFI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE BWMFI_TrailingProfitMethod = T_FIXED; // Trailing Profit method for BWMFI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double BWMFI_OpenLevel = 0; // Not used currently.
extern int BWMFI1_OpenMethod = 0; // Valid range: 0-31.
extern int BWMFI5_OpenMethod = 0; // Valid range: 0-31.
extern int BWMFI15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int BWMFI30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int BWMFI1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int BWMFI1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT BWMFI1_CloseCondition = C_MACD_BUY_SELL;
//
extern int BWMFI5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int BWMFI5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT BWMFI5_CloseCondition = C_MACD_BUY_SELL;
//
extern int BWMFI15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int BWMFI15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT BWMFI15_CloseCondition = C_MACD_BUY_SELL;
//
extern int BWMFI30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int BWMFI30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT BWMFI30_CloseCondition = C_MACD_BUY_SELL;
//
extern double BWMFI1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double BWMFI5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double BWMFI15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double BWMFI30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __CCI_Parameters__ = "-- Settings for the Commodity Channel Index indicator --";
#ifndef __disabled__
  extern bool CCI1_Active = TRUE;
  extern bool CCI5_Active = TRUE;
  extern bool CCI15_Active = TRUE;
  extern bool CCI30_Active = TRUE; // Enable CCI-based strategy for specific timeframe.
#else
  extern bool CCI1_Active = FALSE;
  extern bool CCI5_Active = FALSE;
  extern bool CCI15_Active = FALSE;
  extern bool CCI30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE CCI_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for CCI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE CCI_TrailingProfitMethod = T_FIXED; // Trailing Profit method for CCI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int CCI_Period_Fast = 12; // Averaging period to calculate the main line.
extern int CCI_Period_Slow = 20; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE CCI_Applied_Price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double CCI_OpenLevel = 0; // Not used currently.
extern int CCI1_OpenMethod = 0; // Valid range: 0-31.
extern int CCI5_OpenMethod = 0; // Valid range: 0-31.
extern int CCI15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int CCI30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int CCI1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int CCI1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT CCI1_CloseCondition = C_MACD_BUY_SELL;
//
extern int CCI5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int CCI5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT CCI5_CloseCondition = C_MACD_BUY_SELL;
//
extern int CCI15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int CCI15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT CCI15_CloseCondition = C_MACD_BUY_SELL;
//
extern int CCI30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int CCI30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT CCI30_CloseCondition = C_MACD_BUY_SELL;
//
extern double CCI1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double CCI5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double CCI15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double CCI30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --";
#ifndef __disabled__
  extern bool DeMarker1_Active = TRUE;
  extern bool DeMarker5_Active = TRUE;
  extern bool DeMarker15_Active = TRUE;
  extern bool DeMarker30_Active = TRUE; // Enable DeMarker-based strategy for specific timeframe.
#else
  extern bool DeMarker1_Active = FALSE;
  extern bool DeMarker5_Active = FALSE;
  extern bool DeMarker15_Active = FALSE;
  extern bool DeMarker30_Active = FALSE;
#endif
//extern ENUM_TIMEFRAMES DeMarker_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int DeMarker_Period = 24; // DeMarker averaging period for calculation.
extern int DeMarker_Shift = 0; // Shift relative to the current bar the given amount of periods ago. Suggested value: 4.
extern double DeMarker_OpenLevel = 0.2; // Valid range: 0.0-0.4. Suggested value: 0.0.
//extern bool DeMarker_CloseOnChange = FALSE; // Close opposite orders on market change.
extern ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = T_FIXED;
extern int DeMarker1_OpenMethod = 0; // Valid range: 0-31.
extern int DeMarker5_OpenMethod = 0; // Valid range: 0-31.
extern int DeMarker15_OpenMethod = 0; // Valid range: 0-31.
extern int DeMarker30_OpenMethod = 0; // Valid range: 0-31. Used for C_DEMARKER_BUY_SELL close condition.
extern int DeMarker1_OpenCondition1 = 528; // Valid range: 0-1023.
extern int DeMarker1_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT DeMarker1_CloseCondition = C_MACD_BUY_SELL;
//
extern int DeMarker5_OpenCondition1 = 528; // Valid range: 0-1023.
extern int DeMarker5_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT DeMarker5_CloseCondition = C_MACD_BUY_SELL;
//
extern int DeMarker15_OpenCondition1 = 528; // Valid range: 0-1023.
extern int DeMarker15_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT DeMarker15_CloseCondition = C_MACD_BUY_SELL;
//
extern int DeMarker30_OpenCondition1 = 528; // Valid range: 0-1023.
extern int DeMarker30_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT DeMarker30_CloseCondition = C_MACD_BUY_SELL;
//
extern double DeMarker1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double DeMarker5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double DeMarker15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double DeMarker30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/* DeMarker backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, spread 20, 9,5mln ticks, quality 25%]:
 *   £32058.66	2358	1.68	13.60	13837.63	37.93%

 *   £5968.23 5968  1.17  1.00  1314.82 47.46% (deposit: £1000, no boosting)
 *   £7465.39 5966  1.21  1.25  1306.65 9.32% (deposit: £10000, no boosting)
 *   $11414.20  5966  1.21  1.91  1776.70 12.99% (deposit: $10000, no boosting)
 *   Strategy stats:
 *   DeMarker M1: Total net profit: 930 pips, Total orders: 2145 (Won: 30.7% [659] | Loss: 69.3% [1486]);
 *   DeMarker M5: Total net profit: 1699 pips, Total orders: 1751 (Won: 31.1% [544] | Loss: 68.9% [1207]);
 *   DeMarker M15: Total net profit: 1882 pips, Total orders: 1281 (Won: 37.7% [483] | Loss: 62.3% [798]);
 *   DeMarker M30: Total net profit: 905 pips, Total orders: 789 (Won: 40.7% [321] | Loss: 59.3% [468]);
 *   Prev: £1929.90 2778  1.13  0.69  525.00  21.84% (deposit: £1000, no boosting)
 *   Prev: £3369.57 1694  1.25  1.99  588.65  21.19%  0.00000000  DeMarker_TrailingProfitMethod=19 (deposit: £1000)
 */
//+------------------------------------------------------------------+
extern string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --";
#ifndef __disabled__
  extern bool Envelopes1_Active = TRUE;
  extern bool Envelopes5_Active = TRUE;
  extern bool Envelopes15_Active = TRUE;
  extern bool Envelopes30_Active = TRUE; // Enable Envelopes-based strategy fpr specific timeframe.
#else
  extern bool Envelopes1_Active = FALSE;
  extern bool Envelopes5_Active = FALSE;
  extern bool Envelopes15_Active = FALSE;
  extern bool Envelopes30_Active = FALSE;
#endif
extern int Envelopes_MA_Period = 28; // Averaging period to calculate the main line.
extern ENUM_MA_METHOD Envelopes_MA_Method = MODE_SMA; // MA method (See: ENUM_MA_METHOD).
extern int Envelopes_MA_Shift = 0; // The indicator shift relative to the chart.
extern ENUM_APPLIED_PRICE Envelopes_Applied_Price = PRICE_TYPICAL; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double Envelopes1_Deviation = 0.08; // Percent deviation from the main line.
// £1804.07	1620	1.12	1.11	1396.96	11.31%	0.00000000	Envelopes1_Deviation=0.07 (d:£10k)
// £1800.30	1549	1.13	1.16	1352.76	11.01%	0.00000000	Envelopes1_Deviation=0.08 (d:£10k)
extern double Envelopes5_Deviation = 0.12; // Percent deviation from the main line.
extern double Envelopes15_Deviation = 0.15; // Percent deviation from the main line.
extern double Envelopes30_Deviation = 0.4; // Percent deviation from the main line.
// extern int Envelopes_Shift_Far = 0; // The indicator shift relative to the chart.
extern int Envelopes_Shift = 2; // The indicator shift relative to the chart.
extern ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = T_FIXED;
/* extern */ int Envelopes_OpenLevel = 0; // TODO
extern int Envelopes1_OpenMethod = 0; // Valid range: 0-127. Set 0 to default.
extern int Envelopes5_OpenMethod = 0; // Valid range: 0-127. Set 0 to default.
extern int Envelopes15_OpenMethod = 0; // Valid range: 0-127. Set 0 to default.
extern int Envelopes30_OpenMethod = 4; // Valid range: 0-127. Set 0 to default. Used for C_ENVELOPES_BUY_SELL close condition.
extern int Envelopes1_OpenCondition1 = 528; // Valid range: 0-1023. Optimized based on genetic algorithm between 2015.01.01-2015.06.30 with spread 20. 768-880
extern int Envelopes1_OpenCondition2 = 0; // Valid range: 0-1023. Optimized based on genetic algorithm between 2015.01.01-2015.06.30 with spread 20. 8/24
extern ENUM_MARKET_EVENT Envelopes1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Envelopes5_OpenCondition1 = 528; // Valid range: 0-1023.
extern int Envelopes5_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT Envelopes5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Envelopes15_OpenCondition1 = 528; // Valid range: 0-1023. // TODO
extern int Envelopes15_OpenCondition2 = 0; // Valid range: 0-1023. // TODO
extern ENUM_MARKET_EVENT Envelopes15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Envelopes30_OpenCondition1 = 528; // Valid range: 0-1023. Try: 512, 528
extern int Envelopes30_OpenCondition2 = 0; // Valid range: 0-1023. Try: 0, 8, 16, 24
extern ENUM_MARKET_EVENT Envelopes30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Envelopes1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Envelopes5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Envelopes15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Envelopes30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * Envelopes backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
 *  £33014.05	2758	1.61	11.97	18039.17	44.56%	Envelopes_MA_Period=26 (d: £10k, sp: 20, ls:0.1, __testing__)
 *  £34606.84	2745	1.64	12.61	17735.31	43.79%	Envelopes_MA_Period=28 (d: £10k, sp: 20, ls:0.1, __testing__)
 */

//+------------------------------------------------------------------+
extern string __Force_Parameters__ = "-- Settings for the Force Index indicator --";
#ifndef __disabled__
  extern bool Force1_Active = TRUE;
  extern bool Force5_Active = TRUE;
  extern bool Force15_Active = TRUE;
  extern bool Force30_Active = TRUE; // Enable Force-based strategy for specific timeframe.
#else
  extern bool Force1_Active = FALSE;
  extern bool Force5_Active = FALSE;
  extern bool Force15_Active = FALSE;
  extern bool Force30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE Force_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Force_TrailingProfitMethod = T_FIXED;
extern int Force_Period = 13; // Averaging period for calculation.
extern ENUM_MA_METHOD Force_MA_Method = MODE_SMA; // Moving Average method (See: ENUM_MA_METHOD). Range: 0-3.
extern ENUM_APPLIED_PRICE Force_Applied_price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double Force_OpenLevel = 0; // Not used currently.
extern int Force1_OpenMethod = 0; // Valid range: 0-31.
extern int Force5_OpenMethod = 0; // Valid range: 0-31.
extern int Force15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Force30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int Force1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int Force1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Force1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Force5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Force5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Force5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Force15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Force15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Force15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Force30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Force30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Force30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Force1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Force5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Force15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Force30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --";
#ifndef __disabled__
  extern bool Fractals1_Active = TRUE;
  extern bool Fractals5_Active = TRUE;
  extern bool Fractals15_Active = TRUE;
  extern bool Fractals30_Active = TRUE; // Enable Fractals-based strategy for specific timeframe.
#else
  extern bool Fractals1_Active = FALSE;
  extern bool Fractals5_Active = FALSE;
  extern bool Fractals15_Active = FALSE;
  extern bool Fractals30_Active = FALSE;
#endif
//extern bool Fractals_CloseOnChange = TRUE; // Close opposite orders on market change.
extern ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = T_FIXED;
/* extern */ int Fractals_OpenLevel = 0; // TODO
extern int Fractals1_OpenMethod = 0; // Valid range: 0-1.
extern int Fractals5_OpenMethod = 0; // Valid range: 0-1.
extern int Fractals15_OpenMethod = 0; // Valid range: 0-1. // Optimized.
extern int Fractals30_OpenMethod = 0; // Valid range: 0-1. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int Fractals1_OpenCondition1 = 528; // Valid range: 0-1023. 512, 800 ,832
extern int Fractals1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Fractals1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Fractals5_OpenCondition1 = 528; // Valid range: 0-1023.
extern int Fractals5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Fractals5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Fractals15_OpenCondition1 = 528; // Valid range: 0-1023. // Optimized.
extern int Fractals15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Fractals15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Fractals30_OpenCondition1 = 528; // Valid range: 0-1023. // Optimized.
extern int Fractals30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Fractals30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Fractals1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Fractals5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Fractals15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Fractals30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * Fractals backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, spread 20, 9,5mln ticks, quality 25%]:
 *   £40321.54	2672	1.77	15.09	25486.83	54.12%	0.00000000	Account_Conditions_Active=0 (d: £10k, sp: 20, ls:0.1, __testing__)
 *   £21560.33	3143	1.45	6.86	4752.95	26.95%	0.00000000	Account_Conditions_Active=1 (d: £10k, sp: 20, ls:0.1, __testing__)
 */
//+------------------------------------------------------------------+
extern string __Gator_Parameters__ = "-- Settings for the Gator oscillator --";
#ifndef __disabled__
  extern bool Gator1_Active = TRUE;
  extern bool Gator5_Active = TRUE;
  extern bool Gator15_Active = TRUE;
  extern bool Gator30_Active = TRUE; // Enable Gator-based strategy for specific timeframe.
#else
  extern bool Gator1_Active = FALSE;
  extern bool Gator5_Active = FALSE;
  extern bool Gator15_Active = FALSE;
  extern bool Gator30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE Gator_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Gator_TrailingProfitMethod = T_FIXED;
extern double Gator_OpenLevel = 0; // Not used currently.
extern int Gator1_OpenMethod = 0; // Valid range: 0-31.
extern int Gator5_OpenMethod = 0; // Valid range: 0-31.
extern int Gator15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Gator30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int Gator1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int Gator1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Gator1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Gator5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Gator5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Gator5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Gator15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Gator15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Gator15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Gator30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Gator30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Gator30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Gator1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Gator5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Gator15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Gator30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Ichimoku_Parameters__ = "-- Settings for the Ichimoku Kinko Hyo indicator --";
#ifndef __disabled__
  extern bool Ichimoku1_Active = TRUE;
  extern bool Ichimoku5_Active = TRUE;
  extern bool Ichimoku15_Active = TRUE;
  extern bool Ichimoku30_Active = TRUE; // Enable Ichimoku-based strategy for specific timeframe.
#else
  extern bool Ichimoku1_Active = FALSE;
  extern bool Ichimoku5_Active = FALSE;
  extern bool Ichimoku15_Active = FALSE;
  extern bool Ichimoku30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE Ichimoku_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Ichimoku_TrailingProfitMethod = T_FIXED;
extern int Ichimoku_Period_Tenkan_Sen = 9; // Tenkan Sen averaging period.
extern int Ichimoku_Period_Kijun_Sen = 26; // Kijun Sen averaging period.
extern int Ichimoku_Period_Senkou_Span_B = 52; // Senkou SpanB averaging period.
extern double Ichimoku_OpenLevel = 0; // Not used currently.
extern int Ichimoku1_OpenMethod = 0; // Valid range: 0-31.
extern int Ichimoku5_OpenMethod = 0; // Valid range: 0-31.
extern int Ichimoku15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Ichimoku30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int Ichimoku1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int Ichimoku1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Ichimoku1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Ichimoku5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Ichimoku5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Ichimoku5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Ichimoku15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Ichimoku15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Ichimoku15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Ichimoku30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Ichimoku30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Ichimoku30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Ichimoku1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Ichimoku5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Ichimoku15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Ichimoku30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __MA_Parameters__ = "-- Settings for the Moving Average indicator --";
#ifndef __disabled__
  extern bool MA1_Active = TRUE;
  extern bool MA5_Active = TRUE;
  extern bool MA15_Active = TRUE;
  extern bool MA30_Active = TRUE; // Enable MA-based strategy for specific timeframe.
#else
  extern bool MA1_Active = FALSE;
  extern bool MA5_Active = FALSE;
  extern bool MA15_Active = FALSE;
  extern bool MA30_Active = FALSE;
#endif
extern int MA_Period_Fast = 8; // Averaging period for calculation.
extern int MA_Period_Medium = 20; // Averaging period for calculation.
extern int MA_Period_Slow = 40; // Averaging period for calculation.
// extern double MA_Period_Ratio = 2; // Testing
extern int MA_Shift = 0;
extern int MA_Shift_Fast = 0; // Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Medium = 2; // Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Slow = 4; // Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Far = 1; // Far shift. Shift relative to the 2 previous bars (+2).
extern ENUM_MA_METHOD MA_Method = MODE_LWMA; // MA method (See: ENUM_MA_METHOD). Range: 0-3. Suggested value: MODE_EMA.
extern ENUM_APPLIED_PRICE MA_Applied_Price = PRICE_CLOSE; // MA applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_TRAIL_TYPE MA_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE MA_TrailingProfitMethod = T_50_BARS_PEAK;
extern double MA_OpenLevel  = 1.0; // Minimum open level between moving averages to raise the trade signal.
extern int MA1_OpenMethod = 57; // Valid range: 0-127.
extern int MA5_OpenMethod = 51; // Valid range: 0-127.
extern int MA15_OpenMethod = 65; // Valid range: 0-127.
extern int MA30_OpenMethod = 71; // Valid range: 0-127. This value is used for close condition.
extern int MA1_OpenCondition1 = 512; // Valid range: 0-1023.
extern int MA1_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MA1_CloseCondition = C_MACD_BUY_SELL;
//
extern int MA5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MA5_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MA5_CloseCondition = C_MACD_BUY_SELL;
//
extern int MA15_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MA15_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MA15_CloseCondition = C_MA_BUY_SELL;
//
extern int MA30_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MA30_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MA30_CloseCondition = C_MA_BUY_SELL;
//
extern double MA1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double MA5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double MA15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double MA30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * MA backtest log [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
 *   £49952.57	2906	1.29	17.19	17750.78	29.01%	TradeWithTrend=0 (d: £10k, spread: 25, no boosting, no actions, lot size: auto, with C_EVENT_NONE)
 *   £34911.40	2422	1.30	14.41	11890.54	26.95%	TradeWithTrend=1 (d: £10k, spread: 25, no boosting, no actions, lot size: auto, with C_EVENT_NONE)
 *   £27566.63	3177	1.23	8.68	13847.12	33.39%	TradeWithTrend=0 (d: £10k, spread: 25, no boosting, no actions, lot size: auto, with C_MA_BUY_SELL)
 *   £24780.05	2920	1.27	8.49	10192.43	32.01%	TradeWithTrend=0 (d: £10k, spread: 20, no boosting, no actions, lot size: auto, with C_MA_BUY_SELL)
 *   £22280.33	2413	1.31	9.23	6611.29	28.83%	TradeWithTrend=1 (d: £10k, spread: 20, no boosting, no actions, lot size: auto, with C_MA_BUY_SELL)
 */
//+------------------------------------------------------------------+
extern string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --";
#ifndef __disabled__
  extern bool MACD1_Active = TRUE;
  extern bool MACD5_Active = TRUE;
  extern bool MACD15_Active = TRUE;
  extern bool MACD30_Active = TRUE; // Enable MACD-based strategy for specific timeframe.
#else
  extern bool MACD1_Active = FALSE;
  extern bool MACD5_Active = FALSE;
  extern bool MACD15_Active = FALSE;
  extern bool MACD30_Active = FALSE;
#endif
extern int MACD_Period_Fast = 14; // Fast EMA averaging period.
extern int MACD_Period_Slow = 35; // Slow EMA averaging period.
extern int MACD_Signal_Period = 9; // Signal line averaging period.
extern ENUM_APPLIED_PRICE MACD_Applied_Price = PRICE_WEIGHTED; // MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int MACD_Shift = 2; // Past MACD value in number of bars. Shift relative to the current bar the given amount of periods ago. Suggested value: 1
extern int MACD_Shift_Far = 0; // Additional MACD far value in number of bars relatively to MACD_Shift.
extern ENUM_TRAIL_TYPE MACD_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = T_FIXED;
extern double MACD_OpenLevel  = 0.2;
extern int MACD1_OpenMethod = 0; // Valid range: 0-31.
extern int MACD5_OpenMethod = 0; // Valid range: 0-31.
extern int MACD15_OpenMethod = 0; // Valid range: 0-31.
extern int MACD30_OpenMethod = 15; // Valid range: 0-31. This value is used for close condition.
extern int MACD1_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MACD1_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MACD1_CloseCondition = C_MACD_BUY_SELL;
//
extern int MACD5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MACD5_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MACD5_CloseCondition = C_MACD_BUY_SELL;
//
extern int MACD15_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MACD15_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MACD15_CloseCondition = C_MACD_BUY_SELL;
//
extern int MACD30_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MACD30_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT MACD30_CloseCondition = C_MACD_BUY_SELL;
//
extern double MACD1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double MACD5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double MACD15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double MACD30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * MACD backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
 *   £33714.17	5911	1.37	5.70	8643.29	53.15%	0.00000000	MACD_Period_Fast=12 	MACD_Period_Slow=30 	MACD_Signal_Period=9 (deposit £10000, spread 25, no boosting, no actions)
 *
 */
//+------------------------------------------------------------------+
extern string __MFI_Parameters__ = "-- Settings for the Money Flow Index indicator --";
#ifndef __disabled__
  extern bool MFI1_Active = TRUE;
  extern bool MFI5_Active = TRUE;
  extern bool MFI15_Active = TRUE;
  extern bool MFI30_Active = TRUE; // Enable MFI-based strategy for specific timeframe.
#else
  extern bool MFI1_Active = FALSE;
  extern bool MFI5_Active = FALSE;
  extern bool MFI15_Active = FALSE;
  extern bool MFI30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE MFI_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE MFI_TrailingProfitMethod = T_FIXED;
extern int MFI_Period = 14; // Averaging period for calculation.
extern double MFI_OpenLevel = 0; // Not used currently.
extern int MFI1_OpenMethod = 0; // Valid range: 0-31.
extern int MFI5_OpenMethod = 0; // Valid range: 0-31.
extern int MFI15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int MFI30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int MFI1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int MFI1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT MFI1_CloseCondition = C_MACD_BUY_SELL;
//
extern int MFI5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int MFI5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT MFI5_CloseCondition = C_MACD_BUY_SELL;
//
extern int MFI15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int MFI15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT MFI15_CloseCondition = C_MACD_BUY_SELL;
//
extern int MFI30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int MFI30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT MFI30_CloseCondition = C_MACD_BUY_SELL;
//
extern double MFI1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double MFI5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double MFI15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double MFI30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Momentum_Parameters__ = "-- Settings for the Momentum indicator --";
#ifndef __disabled__
  extern bool Momentum1_Active = TRUE;
  extern bool Momentum5_Active = TRUE;
  extern bool Momentum15_Active = TRUE;
  extern bool Momentum30_Active = TRUE; // Enable Momentum-based strategy for specific timeframe.
#else
  extern bool Momentum1_Active = FALSE;
  extern bool Momentum5_Active = FALSE;
  extern bool Momentum15_Active = FALSE;
  extern bool Momentum30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE Momentum_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Momentum_TrailingProfitMethod = T_FIXED;
extern int Momentum_Period_Fast = 12; // Averaging period for calculation.
extern int Momentum_Period_Slow = 20; // Averaging period for calculation.
extern ENUM_APPLIED_PRICE Momentum_Applied_Price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double Momentum_OpenLevel = 0; // Not used currently.
extern int Momentum1_OpenMethod = 0; // Valid range: 0-x.
extern int Momentum5_OpenMethod = 0; // Valid range: 0-x.
extern int Momentum15_OpenMethod = 0; // Valid range: 0-x.
extern int Momentum30_OpenMethod = 0; // Valid range: 0-x.
extern int Momentum1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int Momentum1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Momentum1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Momentum5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Momentum5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Momentum5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Momentum15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Momentum15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Momentum15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Momentum30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Momentum30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Momentum30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Momentum1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Momentum5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Momentum15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Momentum30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __OBV_Parameters__ = "-- Settings for the On Balance Volume indicator --";
#ifndef __disabled__
  extern bool OBV1_Active = TRUE;
  extern bool OBV5_Active = TRUE;
  extern bool OBV15_Active = TRUE;
  extern bool OBV30_Active = TRUE; // Enable OBV-based strategy for specific timeframe.
#else
  extern bool OBV1_Active = FALSE;
  extern bool OBV5_Active = FALSE;
  extern bool OBV15_Active = FALSE;
  extern bool OBV30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE OBV_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE OBV_TrailingProfitMethod = T_FIXED;
extern ENUM_APPLIED_PRICE OBV_Applied_Price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double OBV_OpenLevel = 0; // Not used currently.
extern int OBV1_OpenMethod = 0; // Valid range: 0-31.
extern int OBV5_OpenMethod = 0; // Valid range: 0-31.
extern int OBV15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int OBV30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int OBV1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int OBV1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT OBV1_CloseCondition = C_MACD_BUY_SELL;
//
extern int OBV5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int OBV5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT OBV5_CloseCondition = C_MACD_BUY_SELL;
//
extern int OBV15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int OBV15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT OBV15_CloseCondition = C_MACD_BUY_SELL;
//
extern int OBV30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int OBV30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT OBV30_CloseCondition = C_MACD_BUY_SELL;
//
extern double OBV1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double OBV5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double OBV15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double OBV30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __OSMA_Parameters__ = "-- Settings for the Moving Average of Oscillator indicator --";
#ifndef __disabled__
  extern bool OSMA1_Active = TRUE;
  extern bool OSMA5_Active = TRUE;
  extern bool OSMA15_Active = TRUE;
  extern bool OSMA30_Active = TRUE; // Enable OSMA-based strategy for specific timeframe.
#else
  extern bool OSMA1_Active = FALSE;
  extern bool OSMA5_Active = FALSE;
  extern bool OSMA15_Active = FALSE;
  extern bool OSMA30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE OSMA_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE OSMA_TrailingProfitMethod = T_FIXED;
extern int OSMA_Period_Fast = 12; // Fast EMA averaging period.
extern int OSMA_Period_Slow = 26; // Slow EMA averaging period.
extern int OSMA_Period_Signal = 9; // Signal line averaging period.
extern ENUM_APPLIED_PRICE OSMA_Applied_Price = PRICE_OPEN; // MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double OSMA_OpenLevel = 0; // Not used currently.
extern int OSMA1_OpenMethod = 0; // Valid range: 0-31.
extern int OSMA5_OpenMethod = 0; // Valid range: 0-31.
extern int OSMA15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int OSMA30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
extern int OSMA1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int OSMA1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT OSMA1_CloseCondition = C_MACD_BUY_SELL;
//
extern int OSMA5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int OSMA5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT OSMA5_CloseCondition = C_MACD_BUY_SELL;
//
extern int OSMA15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int OSMA15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT OSMA15_CloseCondition = C_MACD_BUY_SELL;
//
extern int OSMA30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int OSMA30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT OSMA30_CloseCondition = C_MACD_BUY_SELL;
//
extern double OSMA1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double OSMA5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double OSMA15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double OSMA30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --";
#ifndef __disabled__
  extern bool RSI1_Active = TRUE;
  extern bool RSI5_Active = TRUE;
  extern bool RSI15_Active = TRUE;
  extern bool RSI30_Active = TRUE; // Enable RSI-based strategy for specific timeframe.
#else
  extern bool RSI1_Active = FALSE;
  extern bool RSI5_Active = FALSE;
  extern bool RSI15_Active = FALSE;
  extern bool RSI30_Active = FALSE;
#endif
extern int RSI_Period = 20; // Averaging period for calculation.
extern ENUM_APPLIED_PRICE RSI_Applied_Price = PRICE_MEDIAN; // RSI applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int RSI_Shift = 0; // Shift relative to the chart.
extern ENUM_TRAIL_TYPE RSI_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = T_FIXED;
extern int RSI_OpenLevel = 20;
extern int RSI1_OpenMethod  = 0; // Valid range: 0-63.
extern int RSI5_OpenMethod  = 0; // Valid range: 0-63. Optimized based on genetic algorithm between 2015.01.01-2015.06.30 with spread 20. 2, 5, 306, 374, 388, 642
extern int RSI15_OpenMethod = 0; // Valid range: 0-63.
extern int RSI30_OpenMethod = 2; // Valid range: 0-63. Used for C_RSI_BUY_SELL close condition (6).
extern int RSI1_OpenCondition1 = 0; // Valid range: 0-1023. Optimized based on genetic algorithm between 2015.01.01-2015.06.30 with spread 20.
extern int RSI1_OpenCondition2 = 0; // Valid range: 0-1023. Optimized based on genetic algorithm between 2015.01.01-2015.06.30 with spread 20.
extern ENUM_MARKET_EVENT RSI1_CloseCondition = C_MACD_BUY_SELL;
// £6077.73	982	1.31	6.19	6150.06	19.66%	RSI1_CloseCondition=2 (deposit: £10000, spread 20, __testing__)
extern int RSI5_OpenCondition1 = 0; // Valid range: 0-1023. TODO: To optimize. 36/64
extern int RSI5_OpenCondition2 = 0; // Valid range: 0-1023. TODO: To optimize. 1/16/76/196/529
extern ENUM_MARKET_EVENT RSI5_CloseCondition = C_MACD_BUY_SELL;
// £7051.01	809	1.43	8.72	4789.69	22.92% (deposit: £10000, spread 20, __testing__)
extern int RSI15_OpenCondition1 = 116; // Valid range: 0-1023. TODO
extern int RSI15_OpenCondition2 = 1; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT RSI15_CloseCondition = C_MACD_BUY_SELL;
// £5321.65	613	1.42	8.68	3408.52	12.33%	RSI15_CloseCondition=2 (deposit: £10000, spread 20, __testing__)
extern int RSI30_OpenCondition1 = 0; // Valid range: 0-1023.
extern int RSI30_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT RSI30_CloseCondition = C_MACD_BUY_SELL;
// £4019.61	456	1.41	8.81	1737.77	15.71%	RSI30_OpenMethod=2 (deposit: £10000, spread 20, __testing__)
// £2927.64	381	1.35	7.68	1737.20	13.53%	RSI30_CloseCondition=2, RSI30_OpenMethod=6 (deposit: £10000, spread 20, __testing__)
extern double RSI1_MaxSpread =   6.0;  // Maximum spread to trade (in pips).
extern double RSI5_MaxSpread =   7.0;  // Maximum spread to trade (in pips).
extern double RSI15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double RSI30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
extern bool RSI_DynamicPeriod = FALSE;
int RSI1_IncreasePeriod_MinDiff = 27, RSI1_DecreasePeriod_MaxDiff = 61;
int RSI5_IncreasePeriod_MinDiff = 20, RSI5_DecreasePeriod_MaxDiff = 68;
int RSI15_IncreasePeriod_MinDiff = 18, RSI15_DecreasePeriod_MaxDiff = 58;
int RSI30_IncreasePeriod_MinDiff = 26, RSI30_DecreasePeriod_MaxDiff = 60;
/*
 * RSI backtest log (ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
 *
 * RSI backtest log (auto,ts:25,tp:25,gap:10) [2015.01.05-2015.06.20 based on MT4 FXCM backtest data, spread 2, 7,6mln ticks, quality 25%]:
 *   £3367.78 2298  1.24  1.47  1032.39 42.64%  0.00000000  RSI_CloseOnChange=0 (deposit: £1000, boosting factor 1.0)
 *   £3249.67 2338  1.24  1.39  1025.47 44.49%  0.00000000  RSI_CloseOnChange=1 (deposit: £1000, boosting factor 1.0)
 *   £4551.26 2331  1.34  1.95  1030.22 9.06% RSI_TrailingProfitMethod=1 (deposit: £10000, boosting factor 1.0)
 *   Strategy stats:
 *    RSI M1: Total net profit: 23205 pips, Total orders: 2726 (Won: 68.6% [1871] | Loss: 31.4% [855]);
 *    RSI M5: Total net profit: 2257 pips, Total orders: 391 (Won: 48.1% [188] | Loss: 51.9% [203]);
 *    RSI M15: Total net profit: 4970 pips, Total orders: 496 (Won: 52.2% [259] | Loss: 47.8% [237]);
 *    RSI M30: Total net profit: 2533 pips, Total orders: 272 (Won: 48.5% [132] | Loss: 51.5% [140]);
 * Deposit: £10000 (factor = 1.0) && RSI_DynamicPeriod
 *  £3380.43  2142  1.31  1.58  541.01  5.12% 0.00000000  RSI_DynamicPeriod=1
 *  £3060.19  1307  1.44  2.34  549.59  4.66% 0.00000000  RSI_DynamicPeriod=0
 *
 * RSI backtest log (ts:40,tp:20,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, spread 25, 9,5mln ticks, quality 25%]:
 *   TODO
 */
//+------------------------------------------------------------------+
extern string __RVI_Parameters__ = "-- Settings for the Relative Vigor Index indicator --";
#ifndef __disabled__
  extern bool RVI1_Active = TRUE;
  extern bool RVI5_Active = TRUE;
  extern bool RVI15_Active = TRUE;
  extern bool RVI30_Active = TRUE; // Enable RVI-based strategy for specific timeframe.
#else
  extern bool RVI1_Active = FALSE;
  extern bool RVI5_Active = FALSE;
  extern bool RVI15_Active = FALSE;
  extern bool RVI30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE RVI_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE RVI_TrailingProfitMethod = T_FIXED;
extern int RVI_Shift = 2; // Shift relative to the previous bar the given amount of periods ago.
extern int RVI_Shift_Far = 0; // Shift relative to the previous bar shift the given amount of periods ago.
extern double RVI_OpenLevel = 0; // Not used currently.
extern int RVI1_OpenMethod = 0; // Valid range: 0-31.
extern int RVI5_OpenMethod = 0; // Valid range: 0-31.
extern int RVI15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int RVI30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.

extern int RVI1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int RVI1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT RVI1_CloseCondition = C_MACD_BUY_SELL;
//
extern int RVI5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int RVI5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT RVI5_CloseCondition = C_MACD_BUY_SELL;
//
extern int RVI15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int RVI15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT RVI15_CloseCondition = C_MACD_BUY_SELL;
//
extern int RVI30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int RVI30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT RVI30_CloseCondition = C_MACD_BUY_SELL;
//
extern double RVI1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double RVI5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double RVI15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double RVI30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __SAR_Parameters__ = "-- Settings for the the Parabolic Stop and Reverse system indicator --";
#ifndef __disabled__
  extern bool SAR1_Active = TRUE;
  extern bool SAR5_Active = TRUE;
  extern bool SAR15_Active = TRUE;
  extern bool SAR30_Active = TRUE; // Enable SAR-based strategy for specific timeframe.
#else
  extern bool SAR1_Active = FALSE;
  extern bool SAR5_Active = FALSE;
  extern bool SAR15_Active = FALSE;
  extern bool SAR30_Active = FALSE;
#endif
extern double SAR_Step = 0.02; // Stop increment, usually 0.02.
extern double SAR_Maximum_Stop = 0.3; // Maximum stop value, usually 0.2.
extern int SAR_Shift = 0; // Shift relative to the chart.
extern ENUM_TRAIL_TYPE SAR_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE SAR_TrailingProfitMethod = T_FIXED;
extern double SAR_OpenLevel = 0.0; // Open gap level to raise the trade signal (in pips).
extern int SAR1_OpenMethod  = 0; // Valid range: 0-127. Optimized.
extern int SAR5_OpenMethod  = 4; // Valid range: 0-127. Optimized.
extern int SAR15_OpenMethod = 0; // Valid range: 0-127. Optimized.
extern int SAR30_OpenMethod = 0; // Valid range: 0-127. Used for C_SAR_BUY_SELL close condition.

extern int SAR1_OpenCondition1 = 512;
extern int SAR1_OpenCondition2 = 0;
extern ENUM_MARKET_EVENT SAR1_CloseCondition = C_MACD_BUY_SELL;
// £8129.37	1079	1.38	7.53	10255.51	27.67% (d: £20k, sp: 20, ls:0.1, __testing__)
extern int SAR5_OpenCondition1 = 514; // Valid range: 0-1023.
extern int SAR5_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT SAR5_CloseCondition = C_MACD_BUY_SELL;
// £9968.31	905	1.57	11.01	9781.86	25.59% (d: £20k, sp: 20, ls:0.1, __testing__)
extern int SAR15_OpenCondition1 = 0; // Valid range: 0-1023.
extern int SAR15_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT SAR15_CloseCondition = C_MACD_BUY_SELL;
// £11957.61	1150	1.52	10.40	9154.70	24.23% (d: £20k, sp: 20, ls:0.1, __testing__)
extern int SAR30_OpenCondition1 = 0; // Valid range: 0-1023.
extern int SAR30_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT SAR30_CloseCondition = C_MACD_BUY_SELL;
// £13420.26	1141	1.60	11.76	10032.18	24.52% (d: £20k, sp: 20, ls:0.1, __testing__)
extern double SAR1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double SAR5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double SAR15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double SAR30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * SAR backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, 9,5mln ticks, quality 25%]:
 *   £37878.53	4274	1.21	8.86	69890.74	76.77%	TradeWithTrend=0 (d: £20k, sp: 20, ls:auto, __testing__)
 *   £25549.59	4007	1.18	6.38	60049.74	76.82%	TradeWithTrend=1 (d: £20k, sp: 20, ls:auto, __testing__)
 *   £45203.65	5586	1.18	8.09	27420.74	48.15%	Account_Conditions_Active=1 (d: £20k, sp: 20, ls:auto, with actions, no boosting)
 *
 *   Strategy stats (deposit: £10000, spread 20, ls:auto, __testing__):
      Profit factor: 1.14, Total net profit: 6131.69pips (+51196.06/-45064.37), Total orders: 1083 (Won: 27.9% [302] / Loss: 72.1% [781]) - SAR M1
      Profit factor: 1.30, Total net profit: 11347.41pips (+48828.04/-37480.63), Total orders: 901 (Won: 28.5% [257] / Loss: 71.5% [644]) - SAR M5
      Profit factor: 1.17, Total net profit: 8120.80pips (+57220.29/-49099.49), Total orders: 1145 (Won: 26.2% [300] / Loss: 73.8% [845]) - SAR M15
      Profit factor: 1.27, Total net profit: 12706.46pips (+59705.56/-46999.10), Total orders: 1131 (Won: 27.9% [315] / Loss: 72.1% [816]) - SAR M30
 *
 */
//+------------------------------------------------------------------+
extern string __StdDev_Parameters__ = "-- Settings for the Standard Deviation indicator --";
#ifndef __disabled__
  extern bool StdDev1_Active = TRUE;
  extern bool StdDev5_Active = TRUE;
  extern bool StdDev15_Active = TRUE;
  extern bool StdDev30_Active = TRUE; // Enable StdDev-based strategy for specific timeframe.
#else
  extern bool StdDev1_Active = FALSE;
  extern bool StdDev5_Active = FALSE;
  extern bool StdDev15_Active = FALSE;
  extern bool StdDev30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE StdDev_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE StdDev_TrailingProfitMethod = T_FIXED;
extern ENUM_APPLIED_PRICE StdDev_Applied_Price = PRICE_CLOSE; // MA applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int StdDev_MA_Period = 10; // Averaging period to calculate the main line.
extern ENUM_MA_METHOD StdDev_MA_Method = MODE_EMA; // MA method (See: ENUM_MA_METHOD). Range: 0-3. Suggested value: MODE_EMA.
extern int StdDev_MA_Shift = 0; // Moving Average shift.
extern double StdDev_OpenLevel = 0.0; // Not used currently.
extern int StdDev1_OpenMethod = 0; // Valid range: 0-31.
extern int StdDev5_OpenMethod = 0; // Valid range: 0-31.
extern int StdDev15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int StdDev30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.

extern int StdDev1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int StdDev1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT StdDev1_CloseCondition = C_MACD_BUY_SELL;
//
extern int StdDev5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int StdDev5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT StdDev5_CloseCondition = C_MACD_BUY_SELL;
//
extern int StdDev15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int StdDev15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT StdDev15_CloseCondition = C_MACD_BUY_SELL;
//
extern int StdDev30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int StdDev30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT StdDev30_CloseCondition = C_MACD_BUY_SELL;
//
extern double StdDev1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double StdDev5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double StdDev15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double StdDev30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __Stochastic_Parameters__ = "-- Settings for the the Stochastic Oscillator --";
#ifndef __disabled__
  extern bool Stochastic1_Active = TRUE;
  extern bool Stochastic5_Active = TRUE;
  extern bool Stochastic15_Active = TRUE;
  extern bool Stochastic30_Active = TRUE; // Enable Stochastic-based strategy for specific timeframe.
#else
  extern bool Stochastic1_Active = FALSE;
  extern bool Stochastic5_Active = FALSE;
  extern bool Stochastic15_Active = FALSE;
  extern bool Stochastic30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE Stochastic_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE Stochastic_TrailingProfitMethod = T_FIXED;
extern double Stochastic_OpenLevel = 0.0; // Not used currently.
extern int Stochastic1_OpenMethod = 0; // Valid range: 0-31.
extern int Stochastic5_OpenMethod = 0; // Valid range: 0-31.
extern int Stochastic15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Stochastic30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.

extern int Stochastic1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int Stochastic1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT Stochastic1_CloseCondition = C_MACD_BUY_SELL;
//
extern int Stochastic5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int Stochastic5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Stochastic5_CloseCondition = C_MACD_BUY_SELL;
//
extern int Stochastic15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Stochastic15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Stochastic15_CloseCondition = C_MACD_BUY_SELL;
//
extern int Stochastic30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int Stochastic30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT Stochastic30_CloseCondition = C_MACD_BUY_SELL;
//
extern double Stochastic1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double Stochastic5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double Stochastic15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double Stochastic30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
//+------------------------------------------------------------------+
extern string __WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --";
#ifndef __disabled__
  extern bool WPR1_Active = TRUE;
  extern bool WPR5_Active = TRUE;
  extern bool WPR15_Active = TRUE;
  extern bool WPR30_Active = TRUE; // Enable WPR-based strategy for specific timeframe.
#else
  extern bool WPR1_Active = FALSE;
  extern bool WPR5_Active = FALSE;
  extern bool WPR15_Active = FALSE;
  extern bool WPR30_Active = FALSE;
#endif
extern int WPR_Period = 21; // Averaging period for calculation. Suggested value: 22.
extern int WPR_Shift = 0; // Shift relative to the current bar the given amount of periods ago. Suggested value: 1.
extern int WPR_OpenLevel = 30; // Suggested range: 25-35.
//extern bool WPR_CloseOnChange = TRUE; // Close opposite orders on market change.
extern ENUM_TRAIL_TYPE WPR_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE WPR_TrailingProfitMethod = T_FIXED;
extern int WPR1_OpenMethod = 0; // Valid range: 0-63. Optimized.
extern int WPR5_OpenMethod = 0; // Valid range: 0-63. Optimized.
extern int WPR15_OpenMethod = 0; // Valid range: 0-63. Optimized.
extern int WPR30_OpenMethod = 0; // Valid range: 0-63. Optimized with T_MA_M_FAR_TRAIL (8). Used for C_WPR_BUY_SELL close condition (16).

extern int WPR1_OpenCondition1 = 528; // Valid range: 0-1023. 512 (4) 516
extern int WPR1_OpenCondition2 = 0; // Valid range: 0-1023. 0 (32) 96
extern ENUM_MARKET_EVENT WPR1_CloseCondition = C_MACD_BUY_SELL;
//
extern int WPR5_OpenCondition1 = 528; // Valid range: 0-1023. >512
extern int WPR5_OpenCondition2 = 0; // Valid range: 0-1023. 0/16
extern ENUM_MARKET_EVENT WPR5_CloseCondition = C_MACD_BUY_SELL;
//
extern int WPR15_OpenCondition1 = 528; // Valid range: 0-1023. // TODO: Further backtesting required.
extern int WPR15_OpenCondition2 = 0; // Valid range: 0-1023.
extern ENUM_MARKET_EVENT WPR15_CloseCondition = C_MACD_BUY_SELL;
//
extern int WPR30_OpenCondition1 = 528; // Valid range: 0-1023. // TODO: Further backtesting required.
extern int WPR30_OpenCondition2 = 0; // Valid range: 0-1023. // TODO: Further backtesting required.
extern ENUM_MARKET_EVENT WPR30_CloseCondition = C_MACD_BUY_SELL;
//
extern double WPR1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double WPR5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double WPR15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double WPR30_MaxSpread = 10.0; // Maximum spread to trade (in pips).
/*
 * WPR backtest log (auto,ts:40,tp:30,gap:10) [2015.01.01-2015.06.30 based on MT4 FXCM backtest data, spread 20, 9,5mln ticks, quality 25%]:
 *   £34417.03	2394	1.74	14.38	16126.15	44.53% (d: £10k, sp: 20, ls:0.1, __testing__)
 */
//+------------------------------------------------------------------+
#ifndef __disabled__
  extern bool ZigZag1_Active = TRUE;
  extern bool ZigZag5_Active = TRUE;
  extern bool ZigZag15_Active = TRUE;
  extern bool ZigZag30_Active = TRUE; // Enable ZigZag-based strategy for specific timeframe.
#else
  extern bool ZigZag1_Active = FALSE;
  extern bool ZigZag5_Active = FALSE;
  extern bool ZigZag15_Active = FALSE;
  extern bool ZigZag30_Active = FALSE;
#endif
extern ENUM_TRAIL_TYPE ZigZag_TrailingStopMethod = T_MA_FMS_PEAK;
extern ENUM_TRAIL_TYPE ZigZag_TrailingProfitMethod = T_FIXED;
extern double ZigZag_OpenLevel = 0.0; // Not used currently.
extern int ZigZag1_OpenMethod = 0; // Valid range: 0-31.
extern int ZigZag5_OpenMethod = 0; // Valid range: 0-31.
extern int ZigZag15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int ZigZag30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.

extern int ZigZag1_OpenCondition1 = 0; // Valid range: 0-1023. 512, 800 ,832
extern int ZigZag1_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized. // 0, 16
extern ENUM_MARKET_EVENT ZigZag1_CloseCondition = C_MACD_BUY_SELL;
//
extern int ZigZag5_OpenCondition1 = 0; // Valid range: 0-1023.
extern int ZigZag5_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ZigZag5_CloseCondition = C_MACD_BUY_SELL;
//
extern int ZigZag15_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int ZigZag15_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ZigZag15_CloseCondition = C_MACD_BUY_SELL;
//
extern int ZigZag30_OpenCondition1 = 0; // Valid range: 0-1023. // Optimized.
extern int ZigZag30_OpenCondition2 = 0; // Valid range: 0-1023. // Optimized.
extern ENUM_MARKET_EVENT ZigZag30_CloseCondition = C_MACD_BUY_SELL;
//
extern double ZigZag1_MaxSpread  =  6.0; // Maximum spread to trade (in pips).
extern double ZigZag5_MaxSpread  =  7.0; // Maximum spread to trade (in pips).
extern double ZigZag15_MaxSpread =  8.0; // Maximum spread to trade (in pips).
extern double ZigZag30_MaxSpread = 10.0; // Maximum spread to trade (in pips).

//+------------------------------------------------------------------+
extern string __Logging_Parameters__ = "-- Settings for logging & messages --";
extern bool PrintLogOnChart = TRUE;
extern bool VerboseErrors = TRUE; // Show errors.
extern bool VerboseInfo = TRUE;   // Show info messages.
#ifdef __release__
  extern bool VerboseDebug = FALSE; // Disable messages on release.
#else
  extern bool VerboseDebug = TRUE;  // Show debug messages.
#endif
extern bool WriteReport = TRUE;  // Write report into the file on exit.
extern bool VerboseTrace = FALSE;  // Even more debugging.
//+------------------------------------------------------------------+
extern string __UI_UX_Parameters__ = "-- Settings for User Interface & Experience --";
extern bool SendEmailEachOrder = FALSE;
extern bool SoundAlert = FALSE;
// extern bool SendLogs = FALSE; // Send logs to remote host for diagnostic purposes.
extern string SoundFileAtOpen = "alert.wav";
extern string SoundFileAtClose = "alert.wav";
extern color ColorBuy = Blue;
extern color ColorSell = Red;
//+------------------------------------------------------------------+
extern string __Other_Parameters__ = "-- Other parameters --";

extern int MagicNumber = 31337; // To help identify its own orders. It can vary in additional range: +20, see: ENUM_ORDER_TYPE.
#ifdef __experimental__
  extern bool Cache = FALSE; // Cache some calculated variables for better performance. FIXME: Needs some work.
#else
  const bool Cache = FALSE;
#endif

//extern int ManualGMToffset = 0;
//extern int TrailingStopDelay = 0; // How often trailing stop should be updated (in seconds). FIXME: Fix relative delay in backtesting.
//extern int JobProcessDelay = 1; // How often job list should be processed (in seconds).
