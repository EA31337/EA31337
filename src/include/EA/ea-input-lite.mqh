//+------------------------------------------------------------------+
//|                                                ea-input-lite.mqh |
//|                                           Copyright 2015, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, kenorb"
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| Includes.
//+------------------------------------------------------------------+
#include <EA\ea-enums.mqh>

//+------------------------------------------------------------------+
//| User input variables.
//+------------------------------------------------------------------+
extern string __EA_Order_Parameters__ = "-- Profit/Loss settings (set 0 for auto) --";

// Default lot size. Set 0 for auto.
extern double LotSize = 0;

// Take profit value in pips.
extern double TakeProfit = 160;

// Stop loss value in pips.
extern double StopLoss = 120;

// Maximum orders. Set 0 for auto.
extern int MaxOrders = 0;

// Maximum orders per strategy type. Set 0 for auto.
extern int MaxOrdersPerType = 15;
extern bool TradeMicroLots = TRUE;

//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Settings for trailing stops --";
extern int TrailingStop = 40;

// TrailingStop method. Set 0 to disable. See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE DefaultTrailingStopMethod = 8;

// Change trailing stop towards one direction only.
extern bool TrailingStopOneWay = FALSE;
extern int TrailingProfit = 20;

// Trailing Profit method. Set 0 to disable. See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = 17;

// Change trailing profit take towards one direction only.
extern bool TrailingProfitOneWay = TRUE;

// Decrease trailing stop (in pips) per each bar. Set 0 to disable. Suggested value: 0.
extern double TrailingStopAddPerMinute = 0.0;

//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management --";

// Suggested value: 1.0. Do not change unless testing.
extern double RiskRatio = 0;

// Trade with trend (to minimalize the risk).
extern bool TradeWithTrend = FALSE;
extern bool MinimalizeLosses = FALSE; // Set stop loss to zero, once the order is profitable.

//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting (set 1.0 to default) --";
// Default. Enable boosting section.
extern bool Boosting_Enabled                       = TRUE;
extern double BestDailyStrategyMultiplierFactor    = 1.1; // Lot multiplier boosting factor for the most profitable daily strategy.
extern double BestWeeklyStrategyMultiplierFactor   = 1.2; // Lot multiplier boosting factor for the most profitable weekly strategy.
extern double BestMonthlyStrategyMultiplierFactor  = 1.5; // Lot multiplier boosting factor for the most profitable monthly strategy.
extern double WorseDailyStrategyDividerFactor      = 1.2; // Lot divider factor for the most profitable daily strategy. Useful for low-balance accounts or non-profitable periods.
extern double WorseWeeklyStrategyDividerFactor     = 1.2; // Lot divider factor for the most profitable weekly strategy. Useful for low-balance accounts or non-profitable periods.
extern double WorseMonthlyStrategyDividerFactor    = 1.2; // Lot divider factor for the most profitable monthly strategy. Useful for low-balance accounts or non-profitable periods.
extern double BoostTrendFactor                     = 1.2; // Additional boost when trade is with trend.
//+------------------------------------------------------------------+
extern string __Market_Parameters__ = "-- Market parameters --";
extern int TrendMethod = 181; // Method of main trend calculation. Valid range: 0-255. Suggested values: 65!, 71, 81, 83!, 87, 181, etc.
extern int TrendMethodAction = 238; // Method of trend calculation on action execution (See: A_CLOSE_ALL_TREND/A_CLOSE_ALL_NON_TREND). Valid range: 0-255.
extern int MinVolumeToTrade = 2; // Minimum volume to trade.
extern int MaxOrderPriceSlippage = 5; // Maximum price slippage for buy or sell orders (in pips).
extern int DemoMarketStopLevel = 10;
extern int MaxTries = 5; // Number of maximum attempts to execute the order.
extern int MarketSuddenDropSize = 10; // Size of sudden price drop in pips to react when the market drops.
extern int MarketBigDropSize = 50; // Size of big sudden price drop in pips to react when the market drops.
extern double MinPipChangeToTrade = 0.7; // Minimum pip change to trade before the bar change. Set 0 to process every tick. Lower is better for small spreads and other way round.
extern int MinPipGap = 10; // Minimum gap in pips between trades of the same strategy.
//+------------------------------------------------------------------+
int HourAfterPeak = 18;
//+------------------------------------------------------------------+
extern string __EA_Conditions__ = "-- Account conditions --"; // See: ENUM_ACTION_TYPE
  extern bool Account_Conditions_Active = TRUE; // Enable account conditions. It's not advice on accounts where multi bots are trading.
extern ENUM_ACC_CONDITION Account_Condition_1      = C_ACC_TRUE;
extern ENUM_MARKET_CONDITION Market_Condition_1    = C_MARKET_BIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_1      = A_CLOSE_ALL_LOSS_SIDE;

extern ENUM_ACC_CONDITION Account_Condition_2      = C_EQUITY_LOWER;
extern ENUM_MARKET_CONDITION Market_Condition_2    = C_MA1_FS_TREND_OPP;
extern ENUM_ACTION_TYPE Action_On_Condition_2      = A_CLOSE_ORDER_PROFIT;

extern ENUM_ACC_CONDITION Account_Condition_3      = C_EQUITY_HIGHER;
extern ENUM_MARKET_CONDITION Market_Condition_3    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_3      = A_CLOSE_ALL_IN_PROFIT;

extern ENUM_ACC_CONDITION Account_Condition_4      = C_EQUITY_50PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_4    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_4      = A_CLOSE_ALL_LOSS_SIDE;

extern ENUM_ACC_CONDITION Account_Condition_5      = C_EQUITY_20PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_5    = C_MA1_FS_TREND_OPP;
extern ENUM_ACTION_TYPE Action_On_Condition_5      = A_CLOSE_ORDER_PROFIT;

extern ENUM_ACC_CONDITION Account_Condition_6      = C_EQUITY_10PC_HIGH;
extern ENUM_MARKET_CONDITION Market_Condition_6    = C_MA1_FS_TREND_OPP;
extern ENUM_ACTION_TYPE Action_On_Condition_6      = A_CLOSE_ALL_NON_TREND;

extern ENUM_ACC_CONDITION Account_Condition_7      = C_EQUITY_10PC_LOW;
extern ENUM_MARKET_CONDITION Market_Condition_7    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_7      = A_CLOSE_ALL_PROFIT_SIDE;

extern ENUM_ACC_CONDITION Account_Condition_8      = C_EQUITY_20PC_LOW;
extern ENUM_MARKET_CONDITION Market_Condition_8    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_8      = A_CLOSE_ALL_NON_TREND;

extern ENUM_ACC_CONDITION Account_Condition_9      = C_EQUITY_50PC_LOW;
extern ENUM_MARKET_CONDITION Market_Condition_9    = C_MARKET_TRUE;
extern ENUM_ACTION_TYPE Action_On_Condition_9      = A_CLOSE_ORDER_LOSS;

extern ENUM_ACC_CONDITION Account_Condition_10     = C_MARGIN_USED_50PC;
extern ENUM_MARKET_CONDITION Market_Condition_10   = C_MARKET_BIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_10     = A_CLOSE_ALL_TREND;

extern ENUM_ACC_CONDITION Account_Condition_11     = C_MARGIN_USED_70PC;
extern ENUM_MARKET_CONDITION Market_Condition_11   = C_MARKET_VBIG_DROP;
extern ENUM_ACTION_TYPE Action_On_Condition_11     = A_CLOSE_ALL_IN_LOSS;

extern ENUM_ACC_CONDITION Account_Condition_12     = C_MARGIN_USED_80PC;
extern ENUM_MARKET_CONDITION Market_Condition_12   = C_MARKET_NONE;
extern ENUM_ACTION_TYPE Action_On_Condition_12     = A_NONE;
extern int Account_Condition_MinProfitCloseOrder = 20; // Minimum order profit in pips to close the order on condition met.
//+------------------------------------------------------------------+
extern string __AC_Parameters__ = "-- Settings for the Bill Williams' Accelerator/Decelerator oscillator --";
  extern bool AC1_Active = TRUE;
  extern bool AC5_Active = TRUE;
  extern bool AC15_Active = TRUE;
  extern bool AC30_Active = TRUE; // Enable AC-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE AC_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for AC. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE AC_TrailingProfitMethod = T_FIXED; // Trailing Profit method for AC. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double AC_OpenLevel = 0; // Not used currently.
extern int AC1_OpenMethod = 0; // Valid range: 0-x.
extern int AC5_OpenMethod = 0; // Valid range: 0-x.
extern int AC15_OpenMethod = 0; // Valid range: 0-x.
extern int AC30_OpenMethod = 0; // Valid range: 0-x.
//+------------------------------------------------------------------+
extern string __AD_Parameters__ = "-- Settings for the Accumulation/Distribution indicator --";
  extern bool AD1_Active = TRUE;
  extern bool AD5_Active = TRUE;
  extern bool AD15_Active = TRUE;
  extern bool AD30_Active = TRUE; // Enable AD-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE AD_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for AD. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE AD_TrailingProfitMethod = T_FIXED; // Trailing Profit method for AD. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double AD_OpenLevel = 0; // Not used currently.
extern int AD1_OpenMethod = 0; // Valid range: 0-x.
extern int AD5_OpenMethod = 0; // Valid range: 0-x.
extern int AD15_OpenMethod = 0; // Valid range: 0-x.
extern int AD30_OpenMethod = 0; // Valid range: 0-x.
//+------------------------------------------------------------------+
extern string __ADX_Parameters__ = "-- Settings for the Average Directional Movement Index indicator --";
  extern bool ADX1_Active = TRUE;
  extern bool ADX5_Active = TRUE;
  extern bool ADX15_Active = TRUE;
  extern bool ADX30_Active = TRUE; // Enable ADX-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE ADX_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for ADX. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ADX_TrailingProfitMethod = T_FIXED; // Trailing Profit method for ADX. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int ADX_Period = 14; // Averaging period to calculate the main line.
extern ENUM_APPLIED_PRICE ADX_Applied_Price = PRICE_HIGH; // Bands applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double ADX_OpenLevel = 0; // Not used currently.
extern int ADX1_OpenMethod = 0; // Valid range: 0-x.
extern int ADX5_OpenMethod = 0; // Valid range: 0-x.
extern int ADX15_OpenMethod = 0; // Valid range: 0-x.
extern int ADX30_OpenMethod = 0; // Valid range: 0-x.
//+------------------------------------------------------------------+
extern string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --";
  extern bool Alligator1_Active = TRUE;
  extern bool Alligator5_Active = TRUE;
  extern bool Alligator15_Active = TRUE;
  extern bool Alligator30_Active = TRUE; // Enable Alligator custom-based strategy for specific timeframe.
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
extern ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Alligator. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = T_BANDS_PEAK; // Trailing Profit method for Alligator. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double Alligator_OpenLevel = 0.01; // Minimum open level between moving averages to raise the trade signal.
extern int Alligator1_OpenMethod  = 6; // Valid range: 0-63.
extern int Alligator5_OpenMethod  = 6; // Valid range: 0-63.
extern int Alligator15_OpenMethod  = 9; // Valid range: 0-63.
extern int Alligator30_OpenMethod  = 13; // Valid range: 0-63. This value is used for close condition. Used for C_MA_BUY_SELL close condition (6). (2765/1.20)
//+------------------------------------------------------------------+
extern string __ATR_Parameters__ = "-- Settings for the Average True Range indicator --";
extern bool ATR1_Active = TRUE;
extern bool ATR5_Active = TRUE;
extern bool ATR15_Active = TRUE;
extern bool ATR30_Active = TRUE; // Enable ATR-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE ATR_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for ATR. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ATR_TrailingProfitMethod = T_FIXED; // Trailing Profit method for ATR. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int ATR_Period_Fast = 14; // Averaging period to calculate the main line.
extern int ATR_Period_Slow = 20; // Averaging period to calculate the main line.
extern double ATR_OpenLevel = 0; // Not used currently.
extern int ATR1_OpenMethod = 0; // Valid range: 0-31.
extern int ATR5_OpenMethod = 0; // Valid range: 0-31.
extern int ATR15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int ATR30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Awesome_Parameters__ = "-- Settings for the Awesome oscillator --";
extern bool Awesome1_Active = TRUE;
extern bool Awesome5_Active = TRUE;
extern bool Awesome15_Active = TRUE;
extern bool Awesome30_Active = TRUE; // Enable Awesome-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE Awesome_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Awesome. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Awesome_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Awesome. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double Awesome_OpenLevel = 0; // Not used currently.
extern int Awesome1_OpenMethod = 0; // Valid range: 0-31.
extern int Awesome5_OpenMethod = 0; // Valid range: 0-31.
extern int Awesome15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Awesome30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --";
extern bool Bands1_Active = TRUE;
extern bool Bands5_Active = TRUE;
extern bool Bands15_Active = TRUE;
extern bool Bands30_Active = TRUE; // Enable Bands-based strategy fpr specific timeframe.
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
//+------------------------------------------------------------------+
extern string __BPower_Parameters__ = "-- Settings for the Bulls/Bears Power indicator --";
extern bool BPower1_Active = TRUE;
extern bool BPower5_Active = TRUE;
extern bool BPower15_Active = TRUE;
extern bool BPower30_Active = TRUE; // Enable BPower-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE BPower_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for BPower. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE BPower_TrailingProfitMethod = T_FIXED; // Trailing Profit method for BPower. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int BPower_Period = 13; // Averaging period for calculation.
extern ENUM_APPLIED_PRICE BPower_Applied_Price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double BPower_OpenLevel = 0; // Not used currently.
extern int BPower1_OpenMethod = 0; // Valid range: 0-x.
extern int BPower5_OpenMethod = 0; // Valid range: 0-x.
extern int BPower15_OpenMethod = 0; // Valid range: 0-x. // Optimized.
extern int BPower30_OpenMethod = 0; // Valid range: 0-x. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Breakage_Parameters__ = "-- Settings for the custom Breakage strategy --";
extern bool Breakage1_Active = TRUE;
extern bool Breakage5_Active = TRUE;
extern bool Breakage15_Active = TRUE;
extern bool Breakage30_Active = TRUE; // Enable Breakage-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE Breakage_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Breakage. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Breakage_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Breakage. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double Breakage_OpenLevel = 0; // Not used currently.
extern int Breakage1_OpenMethod = 0; // Valid range: 0-31.
extern int Breakage5_OpenMethod = 0; // Valid range: 0-31.
extern int Breakage15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Breakage30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __BWMFI_Parameters__ = "-- Settings for the Market Facilitation Index indicator --";
extern bool BWMFI1_Active = TRUE;
extern bool BWMFI5_Active = TRUE;
extern bool BWMFI15_Active = TRUE;
extern bool BWMFI30_Active = TRUE; // Enable BWMFI-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE BWMFI_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for BWMFI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE BWMFI_TrailingProfitMethod = T_FIXED; // Trailing Profit method for BWMFI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double BWMFI_OpenLevel = 0; // Not used currently.
extern int BWMFI1_OpenMethod = 0; // Valid range: 0-31.
extern int BWMFI5_OpenMethod = 0; // Valid range: 0-31.
extern int BWMFI15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int BWMFI30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __CCI_Parameters__ = "-- Settings for the Commodity Channel Index indicator --";
extern bool CCI1_Active = TRUE;
extern bool CCI5_Active = TRUE;
extern bool CCI15_Active = TRUE;
extern bool CCI30_Active = TRUE; // Enable CCI-based strategy for specific timeframe.
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
//+------------------------------------------------------------------+
extern string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --";
extern bool DeMarker1_Active = TRUE;
extern bool DeMarker5_Active = TRUE;
extern bool DeMarker15_Active = TRUE;
extern bool DeMarker30_Active = TRUE; // Enable DeMarker-based strategy for specific timeframe.
//extern ENUM_TIMEFRAMES DeMarker_Timeframe = PERIOD_M1; // Timeframe (0 means the current chart).
extern int DeMarker_Period = 24; // DeMarker averaging period for calculation.
extern int DeMarker_Shift = 0; // Shift relative to the current bar the given amount of periods ago. Suggested value: 4.
extern double DeMarker_OpenLevel = 0.2; // Valid range: 0.0-0.4. Suggested value: 0.0.
//extern bool DeMarker_CloseOnChange = FALSE; // Close opposite orders on market change.
extern ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for DeMarker. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = T_FIXED; // Trailing Profit method for DeMarker. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int DeMarker1_OpenMethod = 0; // Valid range: 0-31.
extern int DeMarker5_OpenMethod = 0; // Valid range: 0-31.
extern int DeMarker15_OpenMethod = 0; // Valid range: 0-31.
extern int DeMarker30_OpenMethod = 0; // Valid range: 0-31. Used for C_DEMARKER_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --";
extern bool Envelopes1_Active = TRUE;
extern bool Envelopes5_Active = TRUE;
extern bool Envelopes15_Active = TRUE;
extern bool Envelopes30_Active = TRUE; // Enable Envelopes-based strategy fpr specific timeframe.
extern int Envelopes_MA_Period = 28; // Averaging period to calculate the main line.
extern ENUM_MA_METHOD Envelopes_MA_Method = MODE_SMA; // MA method (See: ENUM_MA_METHOD).
extern int Envelopes_MA_Shift = 0; // The indicator shift relative to the chart.
extern ENUM_APPLIED_PRICE Envelopes_Applied_Price = PRICE_TYPICAL; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double Envelopes1_Deviation = 0.08; // Percent deviation from the main line.
extern double Envelopes5_Deviation = 0.12; // Percent deviation from the main line.
extern double Envelopes15_Deviation = 0.15; // Percent deviation from the main line.
extern double Envelopes30_Deviation = 0.4; // Percent deviation from the main line.
// extern int Envelopes_Shift_Far = 0; // The indicator shift relative to the chart.
extern int Envelopes_Shift = 2; // The indicator shift relative to the chart.
extern ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Bands. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Bands. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
/* extern */ int Envelopes_OpenLevel = 0; // TODO
extern int Envelopes1_OpenMethod = 0; // Valid range: 0-127. Set 0 to default.
extern int Envelopes5_OpenMethod = 0; // Valid range: 0-127. Set 0 to default.
extern int Envelopes15_OpenMethod = 0; // Valid range: 0-127. Set 0 to default.
extern int Envelopes30_OpenMethod = 4; // Valid range: 0-127. Set 0 to default. Used for C_ENVELOPES_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Force_Parameters__ = "-- Settings for the Force Index indicator --";
extern bool Force1_Active = TRUE;
extern bool Force5_Active = TRUE;
extern bool Force15_Active = TRUE;
extern bool Force30_Active = TRUE; // Enable Force-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE Force_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Force. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Force_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Force. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int Force_Period = 13; // Averaging period for calculation.
extern ENUM_MA_METHOD Force_MA_Method = MODE_SMA; // Moving Average method (See: ENUM_MA_METHOD). Range: 0-3.
extern ENUM_APPLIED_PRICE Force_Applied_price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double Force_OpenLevel = 0; // Not used currently.
extern int Force1_OpenMethod = 0; // Valid range: 0-31.
extern int Force5_OpenMethod = 0; // Valid range: 0-31.
extern int Force15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Force30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --";
extern bool Fractals1_Active = TRUE;
extern bool Fractals5_Active = TRUE;
extern bool Fractals15_Active = TRUE;
extern bool Fractals30_Active = TRUE; // Enable Fractals-based strategy for specific timeframe.
//extern bool Fractals_CloseOnChange = TRUE; // Close opposite orders on market change.
extern ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Fractals. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Fractals. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
/* extern */ int Fractals_OpenLevel = 0; // TODO
extern int Fractals1_OpenMethod = 0; // Valid range: 0-1.
extern int Fractals5_OpenMethod = 0; // Valid range: 0-1.
extern int Fractals15_OpenMethod = 0; // Valid range: 0-1. // Optimized.
extern int Fractals30_OpenMethod = 0; // Valid range: 0-1. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Gator_Parameters__ = "-- Settings for the Gator oscillator --";
extern bool Gator1_Active = TRUE;
extern bool Gator5_Active = TRUE;
extern bool Gator15_Active = TRUE;
extern bool Gator30_Active = TRUE; // Enable Gator-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE Gator_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Gator. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Gator_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Gator. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double Gator_OpenLevel = 0; // Not used currently.
extern int Gator1_OpenMethod = 0; // Valid range: 0-31.
extern int Gator5_OpenMethod = 0; // Valid range: 0-31.
extern int Gator15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Gator30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Ichimoku_Parameters__ = "-- Settings for the Ichimoku Kinko Hyo indicator --";
extern bool Ichimoku1_Active = TRUE;
extern bool Ichimoku5_Active = TRUE;
extern bool Ichimoku15_Active = TRUE;
extern bool Ichimoku30_Active = TRUE; // Enable Ichimoku-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE Ichimoku_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Ichimoku. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Ichimoku_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Ichimoku. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int Ichimoku_Period_Tenkan_Sen = 9; // Tenkan Sen averaging period.
extern int Ichimoku_Period_Kijun_Sen = 26; // Kijun Sen averaging period.
extern int Ichimoku_Period_Senkou_Span_B = 52; // Senkou SpanB averaging period.
extern double Ichimoku_OpenLevel = 0; // Not used currently.
extern int Ichimoku1_OpenMethod = 0; // Valid range: 0-31.
extern int Ichimoku5_OpenMethod = 0; // Valid range: 0-31.
extern int Ichimoku15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Ichimoku30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __MA_Parameters__ = "-- Settings for the Moving Average indicator --";
extern bool MA1_Active = TRUE;
extern bool MA5_Active = TRUE;
extern bool MA15_Active = TRUE;
extern bool MA30_Active = TRUE; // Enable MA-based strategy for specific timeframe.
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
extern ENUM_TRAIL_TYPE MA_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for MA. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MA_TrailingProfitMethod = T_50_BARS_PEAK; // Trailing Profit method for MA. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double MA_OpenLevel  = 1.0; // Minimum open level between moving averages to raise the trade signal.
extern int MA1_OpenMethod = 57; // Valid range: 0-127.
extern int MA5_OpenMethod = 51; // Valid range: 0-127.
extern int MA15_OpenMethod = 65; // Valid range: 0-127.
extern int MA30_OpenMethod = 71; // Valid range: 0-127. This value is used for close condition.
//+------------------------------------------------------------------+
extern string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --";
extern bool MACD1_Active = TRUE;
extern bool MACD5_Active = TRUE;
extern bool MACD15_Active = TRUE;
extern bool MACD30_Active = TRUE; // Enable MACD-based strategy for specific timeframe.
extern int MACD_Period_Fast = 14; // Fast EMA averaging period.
extern int MACD_Period_Slow = 35; // Slow EMA averaging period.
extern int MACD_Signal_Period = 9; // Signal line averaging period.
extern ENUM_APPLIED_PRICE MACD_Applied_Price = PRICE_WEIGHTED; // MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int MACD_Shift = 2; // Past MACD value in number of bars. Shift relative to the current bar the given amount of periods ago. Suggested value: 1
extern int MACD_Shift_Far = 0; // Additional MACD far value in number of bars relatively to MACD_Shift.
extern ENUM_TRAIL_TYPE MACD_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for MACD. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = T_FIXED; // Trailing Profit method for MACD. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double MACD_OpenLevel  = 0.2;
extern int MACD1_OpenMethod = 0; // Valid range: 0-31.
extern int MACD5_OpenMethod = 0; // Valid range: 0-31.
extern int MACD15_OpenMethod = 0; // Valid range: 0-31.
extern int MACD30_OpenMethod = 15; // Valid range: 0-31. This value is used for close condition.
//+------------------------------------------------------------------+
extern string __MFI_Parameters__ = "-- Settings for the Money Flow Index indicator --";
extern bool MFI1_Active = TRUE;
extern bool MFI5_Active = TRUE;
extern bool MFI15_Active = TRUE;
extern bool MFI30_Active = TRUE; // Enable MFI-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE MFI_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for MFI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MFI_TrailingProfitMethod = T_FIXED; // Trailing Profit method for MFI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int MFI_Period = 14; // Averaging period for calculation.
extern double MFI_OpenLevel = 0; // Not used currently.
extern int MFI1_OpenMethod = 0; // Valid range: 0-31.
extern int MFI5_OpenMethod = 0; // Valid range: 0-31.
extern int MFI15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int MFI30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Momentum_Parameters__ = "-- Settings for the Momentum indicator --";
extern bool Momentum1_Active = TRUE;
extern bool Momentum5_Active = TRUE;
extern bool Momentum15_Active = TRUE;
extern bool Momentum30_Active = TRUE; // Enable Momentum-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE Momentum_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Momentum. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Momentum_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Momentum. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int Momentum_Period_Fast = 12; // Averaging period for calculation.
extern int Momentum_Period_Slow = 20; // Averaging period for calculation.
extern ENUM_APPLIED_PRICE Momentum_Applied_Price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double Momentum_OpenLevel = 0; // Not used currently.
extern int Momentum1_OpenMethod = 0; // Valid range: 0-x.
extern int Momentum5_OpenMethod = 0; // Valid range: 0-x.
extern int Momentum15_OpenMethod = 0; // Valid range: 0-x.
extern int Momentum30_OpenMethod = 0; // Valid range: 0-x.
//+------------------------------------------------------------------+
extern string __OBV_Parameters__ = "-- Settings for the On Balance Volume indicator --";
extern bool OBV1_Active = TRUE;
extern bool OBV5_Active = TRUE;
extern bool OBV15_Active = TRUE;
extern bool OBV30_Active = TRUE; // Enable OBV-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE OBV_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for OBV. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE OBV_TrailingProfitMethod = T_FIXED; // Trailing Profit method for OBV. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_APPLIED_PRICE OBV_Applied_Price = PRICE_CLOSE; // Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double OBV_OpenLevel = 0; // Not used currently.
extern int OBV1_OpenMethod = 0; // Valid range: 0-31.
extern int OBV5_OpenMethod = 0; // Valid range: 0-31.
extern int OBV15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int OBV30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __OSMA_Parameters__ = "-- Settings for the Moving Average of Oscillator indicator --";
extern bool OSMA1_Active = TRUE;
extern bool OSMA5_Active = TRUE;
extern bool OSMA15_Active = TRUE;
extern bool OSMA30_Active = TRUE; // Enable OSMA-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE OSMA_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for OSMA. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE OSMA_TrailingProfitMethod = T_FIXED; // Trailing Profit method for OSMA. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int OSMA_Period_Fast = 12; // Fast EMA averaging period.
extern int OSMA_Period_Slow = 26; // Slow EMA averaging period.
extern int OSMA_Period_Signal = 9; // Signal line averaging period.
extern ENUM_APPLIED_PRICE OSMA_Applied_Price = PRICE_OPEN; // MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern double OSMA_OpenLevel = 0; // Not used currently.
extern int OSMA1_OpenMethod = 0; // Valid range: 0-31.
extern int OSMA5_OpenMethod = 0; // Valid range: 0-31.
extern int OSMA15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int OSMA30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --";
extern bool RSI1_Active = TRUE;
extern bool RSI5_Active = TRUE;
extern bool RSI15_Active = TRUE;
extern bool RSI30_Active = TRUE; // Enable RSI-based strategy for specific timeframe.
extern int RSI_Period = 20; // Averaging period for calculation.
extern ENUM_APPLIED_PRICE RSI_Applied_Price = PRICE_MEDIAN; // RSI applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int RSI_Shift = 0; // Shift relative to the chart.
extern ENUM_TRAIL_TYPE RSI_TrailingStopMethod = T_5_BARS_PEAK; // Trailing Stop method for RSI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = T_5_BARS_PEAK; // Trailing Profit method for RSI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int RSI_OpenLevel = 20;
extern int RSI1_OpenMethod  = 0; // Valid range: 0-63.
extern int RSI5_OpenMethod  = 0; // Valid range: 0-63. Optimized based on genetic algorithm between 2015.01.01-2015.06.30 with spread 20. 2, 5, 306, 374, 388, 642
extern int RSI15_OpenMethod = 0; // Valid range: 0-63.
extern int RSI30_OpenMethod = 2; // Valid range: 0-63. Used for C_RSI_BUY_SELL close condition (6).
//+------------------------------------------------------------------+
extern string __RVI_Parameters__ = "-- Settings for the Relative Vigor Index indicator --";
extern bool RVI1_Active = TRUE;
extern bool RVI5_Active = TRUE;
extern bool RVI15_Active = TRUE;
extern bool RVI30_Active = TRUE; // Enable RVI-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE RVI_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for RVI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE RVI_TrailingProfitMethod = T_FIXED; // Trailing Profit method for RVI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int RVI_Shift = 2; // Shift relative to the previous bar the given amount of periods ago.
extern int RVI_Shift_Far = 0; // Shift relative to the previous bar shift the given amount of periods ago.
extern double RVI_OpenLevel = 0; // Not used currently.
extern int RVI1_OpenMethod = 0; // Valid range: 0-31.
extern int RVI5_OpenMethod = 0; // Valid range: 0-31.
extern int RVI15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int RVI30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __SAR_Parameters__ = "-- Settings for the the Parabolic Stop and Reverse system indicator --";
extern bool SAR1_Active = TRUE;
extern bool SAR5_Active = TRUE;
extern bool SAR15_Active = TRUE;
extern bool SAR30_Active = TRUE; // Enable SAR-based strategy for specific timeframe.
extern double SAR_Step = 0.02; // Stop increment, usually 0.02.
extern double SAR_Maximum_Stop = 0.3; // Maximum stop value, usually 0.2.
extern int SAR_Shift = 0; // Shift relative to the chart.
extern ENUM_TRAIL_TYPE SAR_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for SAR. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE SAR_TrailingProfitMethod = T_FIXED; // Trailing Profit method for SAR. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double SAR_OpenLevel = 0.0; // Open gap level to raise the trade signal (in pips).
extern int SAR1_OpenMethod  = 0; // Valid range: 0-127. Optimized.
extern int SAR5_OpenMethod  = 4; // Valid range: 0-127. Optimized.
extern int SAR15_OpenMethod = 0; // Valid range: 0-127. Optimized.
extern int SAR30_OpenMethod = 0; // Valid range: 0-127. Used for C_SAR_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __StdDev_Parameters__ = "-- Settings for the Standard Deviation indicator --";
extern bool StdDev1_Active = TRUE;
extern bool StdDev5_Active = TRUE;
extern bool StdDev15_Active = TRUE;
extern bool StdDev30_Active = TRUE; // Enable StdDev-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE StdDev_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for StdDev. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE StdDev_TrailingProfitMethod = T_FIXED; // Trailing Profit method for StdDev. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_APPLIED_PRICE StdDev_AppliedPrice = PRICE_CLOSE; // MA applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern int StdDev_MA_Period = 10; // Averaging period to calculate the main line.
extern ENUM_MA_METHOD StdDev_MA_Method = MODE_EMA; // MA method (See: ENUM_MA_METHOD). Range: 0-3. Suggested value: MODE_EMA.
extern int StdDev_MA_Shift = 0; // Moving Average shift.
extern double StdDev_OpenLevel = 0.0; // Not used currently.
extern int StdDev1_OpenMethod = 0; // Valid range: 0-31.
extern int StdDev5_OpenMethod = 0; // Valid range: 0-31.
extern int StdDev15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int StdDev30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Stochastic_Parameters__ = "-- Settings for the the Stochastic Oscillator --";
extern bool Stochastic1_Active = TRUE;
extern bool Stochastic5_Active = TRUE;
extern bool Stochastic15_Active = TRUE;
extern bool Stochastic30_Active = TRUE; // Enable Stochastic-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE Stochastic_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for Stochastic. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Stochastic_TrailingProfitMethod = T_FIXED; // Trailing Profit method for Stochastic. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double Stochastic_OpenLevel = 0.0; // Not used currently.
extern int Stochastic1_OpenMethod = 0; // Valid range: 0-31.
extern int Stochastic5_OpenMethod = 0; // Valid range: 0-31.
extern int Stochastic15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int Stochastic30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --";
extern bool WPR1_Active = TRUE;
extern bool WPR5_Active = TRUE;
extern bool WPR15_Active = TRUE;
extern bool WPR30_Active = TRUE; // Enable WPR-based strategy for specific timeframe.
extern int WPR_Period = 21; // Averaging period for calculation. Suggested value: 22.
extern int WPR_Shift = 0; // Shift relative to the current bar the given amount of periods ago. Suggested value: 1.
extern int WPR_OpenLevel = 30; // Suggested range: 25-35.
//extern bool WPR_CloseOnChange = TRUE; // Close opposite orders on market change.
extern ENUM_TRAIL_TYPE WPR_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for WPR. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE. // Try: T_MA_M_FAR_TRAIL
extern ENUM_TRAIL_TYPE WPR_TrailingProfitMethod = T_FIXED; // Trailing Profit method for WPR. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern int WPR1_OpenMethod = 0; // Valid range: 0-63. Optimized.
extern int WPR5_OpenMethod = 0; // Valid range: 0-63. Optimized.
extern int WPR15_OpenMethod = 0; // Valid range: 0-63. Optimized.
extern int WPR30_OpenMethod = 0; // Valid range: 0-63. Optimized with T_MA_M_FAR_TRAIL (8). Used for C_WPR_BUY_SELL close condition (16).
//+------------------------------------------------------------------+
extern bool ZigZag1_Active = TRUE;
extern bool ZigZag5_Active = TRUE;
extern bool ZigZag15_Active = TRUE;
extern bool ZigZag30_Active = TRUE; // Enable ZigZag-based strategy for specific timeframe.
extern ENUM_TRAIL_TYPE ZigZag_TrailingStopMethod = T_MA_FMS_PEAK; // Trailing Stop method for ZigZag. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ZigZag_TrailingProfitMethod = T_FIXED; // Trailing Profit method for ZigZag. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern double ZigZag_OpenLevel = 0.0; // Not used currently.
extern int ZigZag1_OpenMethod = 0; // Valid range: 0-31.
extern int ZigZag5_OpenMethod = 0; // Valid range: 0-31.
extern int ZigZag15_OpenMethod = 0; // Valid range: 0-31. // Optimized.
extern int ZigZag30_OpenMethod = 0; // Valid range: 0-31. // Optimized for C_FRACTALS_BUY_SELL close condition.
//+------------------------------------------------------------------+
extern string __Logging_Parameters__ = "-- Settings for logging & messages --";
extern bool PrintLogOnChart = TRUE;
// Display errors.
extern bool VerboseErrors = TRUE;
// Display info messages.
extern bool VerboseInfo = TRUE;
// Display debug messages.
extern bool VerboseDebug = FALSE;
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
// Cache some calculated variables for better performance. FIXME: Needs some work.
#ifdef __experimental__
  extern bool Cache = FALSE;
#else
  const bool Cache = FALSE;
#endif
//extern int ManualGMToffset = 0;
//extern int TrailingStopDelay = 0; // How often trailing stop should be updated (in seconds). FIXME: Fix relative delay in backtesting.
//extern int JobProcessDelay = 1; // How often job list should be processed (in seconds).
