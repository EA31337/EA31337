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
extern bool TradeMicroLots = 1;

//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Settings for trailing stops --";
extern int TrailingStop = 40;

// TrailingStop method. Set 0 to disable. See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE DefaultTrailingStopMethod = 8;

// Change trailing stop towards one direction only.
extern bool TrailingStopOneWay = 0;
extern int TrailingProfit = 20;

// Trailing Profit method. Set 0 to disable. See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = 17;

// Change trailing profit take towards one direction only.
extern bool TrailingProfitOneWay = 1;

// Decrease trailing stop (in pips) per each bar. Set 0 to disable. Suggested value: 0.
extern double TrailingStopAddPerMinute = 0.0;

//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management --";

// Suggested value: 1.0. Do not change unless testing.
extern double RiskRatio = 0;

// Trade with trend (to minimalize the risk).
extern bool TradeWithTrend = 0;
// Set stop loss to zero, once the order is profitable.
extern bool MinimalizeLosses = 0;

//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting (set 1.0 to default) --";
// Default. Enable boosting section.
extern bool Boosting_Enabled                       = TRUE;
// Lot multiplier boosting factor for the most profitable daily strategy.
extern double BestDailyStrategyMultiplierFactor    = 1.5;
// Lot multiplier boosting factor for the most profitable weekly strategy.
extern double BestWeeklyStrategyMultiplierFactor   = 1.0;
// Lot multiplier boosting factor for the most profitable monthly strategy.
extern double BestMonthlyStrategyMultiplierFactor  = 1.0;
// Lot divider factor for the most profitable daily strategy. Useful for low-balance accounts or non-profitable periods.
extern double WorseDailyStrategyDividerFactor      = 1.0;
// Lot divider factor for the most profitable weekly strategy. Useful for low-balance accounts or non-profitable periods.
extern double WorseWeeklyStrategyDividerFactor     = 1.0;
// Lot divider factor for the most profitable monthly strategy. Useful for low-balance accounts or non-profitable periods.
extern double WorseMonthlyStrategyDividerFactor    = 1.0;
// Additional boost when trade is with trend.
extern double BoostTrendFactor                     = 1.3;
//+------------------------------------------------------------------+
extern string __Market_Parameters__ = "-- Market parameters --";
// Method of main trend calculation. Valid range: 0-255. Suggested values: 65!, 71, 81, 83!, 87, 181, etc.
extern int TrendMethod = 135;
// Minimum volume to trade.
extern int MinVolumeToTrade = 2;
// Maximum price slippage for buy or sell orders (in pips).
extern int MaxOrderPriceSlippage = 5;
extern int DemoMarketStopLevel = 10;
// Number of maximum attempts to execute the order.
extern int MaxTries = 5;
// Size of sudden price drop in pips to react when the market drops.
extern int MarketSuddenDropSize = 10;
// Size of big sudden price drop in pips to react when the market drops.
extern int MarketBigDropSize = 50;
// Minimum pip change to trade before the bar change. Set 0 to process every tick. Lower is better for small spreads and other way round.
extern double MinPipChangeToTrade = 0.7;
// Minimum gap in pips between trades of the same strategy.
extern int MinPipGap = 80;
//+------------------------------------------------------------------+
int HourAfterPeak = 18;
//+------------------------------------------------------------------+
extern string __AC_Parameters__ = "-- Settings for the Bill Williams' Accelerator/Decelerator oscillator --";
// Enable AC-based strategy for specific timeframe.
extern bool AC1_Active = 0;
extern bool AC5_Active = 0;
extern bool AC15_Active = 0;
extern bool AC30_Active = 0;
// Trailing Stop method for AC. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE AC_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for AC. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE AC_TrailingProfitMethod = T_FIXED;
// Not used currently.
extern double AC_OpenLevel = 0;
// Valid range: 0-x.
extern int AC1_OpenMethod = 0;
// Valid range: 0-x.
extern int AC5_OpenMethod = 0;
// Valid range: 0-x.
extern int AC15_OpenMethod = 0;
// Valid range: 0-x.
extern int AC30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __AD_Parameters__ = "-- Settings for the Accumulation/Distribution indicator --";
// Enable AD-based strategy for specific timeframe.
extern bool AD1_Active = 0;
extern bool AD5_Active = 0;
extern bool AD15_Active = 0;
extern bool AD30_Active = 0;
// Trailing Stop method for AD. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE AD_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for AD. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE AD_TrailingProfitMethod = T_FIXED;
// Not used currently.
extern double AD_OpenLevel = 0;
// Valid range: 0-x.
extern int AD1_OpenMethod = 0;
// Valid range: 0-x.
extern int AD5_OpenMethod = 0;
// Valid range: 0-x.
extern int AD15_OpenMethod = 0;
// Valid range: 0-x.
extern int AD30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __ADX_Parameters__ = "-- Settings for the Average Directional Movement Index indicator --";
// Enable ADX-based strategy for specific timeframe.
  extern bool ADX1_Active = 0;
  extern bool ADX5_Active = 0;
  extern bool ADX15_Active = 0;
  extern bool ADX30_Active = 0;
// Trailing Stop method for ADX. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ADX_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for ADX. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ADX_TrailingProfitMethod = T_FIXED;
// Averaging period to calculate the main line.
extern int ADX_Period = 14;
// Bands applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE ADX_Applied_Price = PRICE_HIGH;
// Not used currently.
extern double ADX_OpenLevel = 0;
// Valid range: 0-x.
extern int ADX1_OpenMethod = 0;
// Valid range: 0-x.
extern int ADX5_OpenMethod = 0;
// Valid range: 0-x.
extern int ADX15_OpenMethod = 0;
// Valid range: 0-x.
extern int ADX30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --";
// Enable Alligator custom-based strategy for specific timeframe.
extern bool Alligator1_Active = TRUE;
extern bool Alligator5_Active = TRUE;
extern bool Alligator15_Active = TRUE;
extern bool Alligator30_Active = TRUE;
// Timeframe (0 means the current chart).
// Blue line averaging period (Alligator's Jaw).
extern int Alligator_Jaw_Period = 20;
// Blue line shift relative to the chart.
extern int Alligator_Jaw_Shift = 1;
// Red line averaging period (Alligator's Teeth).
extern int Alligator_Teeth_Period = 8;
// Red line shift relative to the chart.
extern int Alligator_Teeth_Shift = 4;
// Green line averaging period (Alligator's Lips).
extern int Alligator_Lips_Period = 9;
// Green line shift relative to the chart.
extern int Alligator_Lips_Shift = 1;
// MA method (See: ENUM_MA_METHOD).
extern ENUM_MA_METHOD Alligator_MA_Method = 2;
// Applied price. It can be any of ENUM_APPLIED_PRICE enumeration values.
extern ENUM_APPLIED_PRICE Alligator_Applied_Price = 1;
// The indicator shift relative to the chart.
extern int Alligator_Shift = 1;
// The indicator shift relative to the chart.
extern int Alligator_Shift_Far = 2;
// Trailing Stop method for Alligator. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = 18;
// Trailing Profit method for Alligator. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = 24;
// Minimum open level between moving averages to raise the trade signal.
extern double Alligator_OpenLevel = 0.01;
// Valid range: 0-63.
extern int Alligator1_OpenMethod  = 47;
// Valid range: 0-63.
extern int Alligator5_OpenMethod  = 2;
// Valid range: 0-63.
extern int Alligator15_OpenMethod  = 3;
// Valid range: 0-63. This value is used for close condition. Used for C_MA_BUY_SELL close condition (6). (2765/1.20)
extern int Alligator30_OpenMethod  = 1;
//+------------------------------------------------------------------+
extern string __ATR_Parameters__ = "-- Settings for the Average True Range indicator --";
// Enable ATR-based strategy for specific timeframe.
extern bool ATR1_Active = 0;
extern bool ATR5_Active = 0;
extern bool ATR15_Active = 0;
extern bool ATR30_Active = 0;
// Trailing Stop method for ATR. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ATR_TrailingStopMethod = 22;
// Trailing Profit method for ATR. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ATR_TrailingProfitMethod = 1;
// Averaging period to calculate the main line.
extern int ATR_Period_Fast = 14;
// Averaging period to calculate the main line.
extern int ATR_Period_Slow = 20;
// Not used currently.
extern double ATR_OpenLevel = 0;
// Valid range: 0-31.
extern int ATR1_OpenMethod = 0;
// Valid range: 0-31.
extern int ATR5_OpenMethod = 0;
// Valid range: 0-31.
extern int ATR15_OpenMethod = 0;
// Valid range: 0-31.
extern int ATR30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __Awesome_Parameters__ = "-- Settings for the Awesome oscillator --";
// Enable Awesome-based strategy for specific timeframe.
extern bool Awesome1_Active = 0;
extern bool Awesome5_Active = 0;
extern bool Awesome15_Active = 0;
extern bool Awesome30_Active = 0;
// Trailing Stop method for Awesome. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Awesome_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for Awesome. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Awesome_TrailingProfitMethod = T_FIXED;
// Not used currently.
extern double Awesome_OpenLevel = 0;
// Valid range: 0-31.
extern int Awesome1_OpenMethod = 0;
// Valid range: 0-31.
extern int Awesome5_OpenMethod = 0;
// Valid range: 0-31.
extern int Awesome15_OpenMethod = 0;
// Valid range: 0-31.
extern int Awesome30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --";
// Enable Bands-based strategy fpr specific timeframe.
extern bool Bands1_Active = TRUE;
extern bool Bands5_Active = FALSE;
extern bool Bands15_Active = FALSE;
extern bool Bands30_Active = FALSE;
// Averaging period to calculate the main line.
extern int Bands_Period = 26;
// Bands applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE Bands_Applied_Price = 4;
// Number of standard deviations from the main line.
extern double Bands_Deviation = 1.7;
// The indicator shift relative to the chart.
extern int Bands_Shift = 1;
// The indicator shift relative to the chart.
extern int Bands_Shift_Far = 4;
// Close opposite orders on market change.
//extern bool Bands_CloseOnChange = FALSE;
// Trailing Stop method for Bands. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Bands_TrailingStopMethod = 9;
// Trailing Profit method for Bands. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Bands_TrailingProfitMethod = 7;
// TODO
/* extern */ int Bands_OpenLevel = 0;
// Valid range: 0-255.
extern int Bands1_OpenMethod = 24;
// Valid range: 0-255.
extern int Bands5_OpenMethod = 124;
// Valid range: 0-255.
extern int Bands15_OpenMethod = 0;
// Valid range: 0-255. Previously: 417. Used for C_BANDS_BUY_SELL close condition.
extern int Bands30_OpenMethod = 225;
//+------------------------------------------------------------------+
extern string __BPower_Parameters__ = "-- Settings for the Bulls/Bears Power indicator --";
// Enable BPower-based strategy for specific timeframe.
extern bool BPower1_Active = 0;
extern bool BPower5_Active = 0;
extern bool BPower15_Active = 0;
extern bool BPower30_Active = 0;
// Trailing Stop method for BPower. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE BPower_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for BPower. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE BPower_TrailingProfitMethod = T_FIXED;
// Averaging period for calculation.
extern int BPower_Period = 13;
// Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE BPower_Applied_Price = PRICE_CLOSE;
// Not used currently.
extern double BPower_OpenLevel = 0;
// Valid range: 0-x.
extern int BPower1_OpenMethod = 0;
// Valid range: 0-x.
extern int BPower5_OpenMethod = 0;
// Valid range: 0-x.
extern int BPower15_OpenMethod = 0;
// Valid range: 0-x.
extern int BPower30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __Breakage_Parameters__ = "-- Settings for the custom Breakage strategy --";
// Enable Breakage-based strategy for specific timeframe.
extern bool Breakage1_Active = 0;
extern bool Breakage5_Active = 0;
extern bool Breakage15_Active = 0;
extern bool Breakage30_Active = 0;
// Trailing Stop method for Breakage. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Breakage_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for Breakage. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Breakage_TrailingProfitMethod = T_FIXED;
// Not used currently.
extern double Breakage_OpenLevel = 0;
// Valid range: 0-31.
extern int Breakage1_OpenMethod = 0;
// Valid range: 0-31.
extern int Breakage5_OpenMethod = 0;
// Valid range: 0-31.
extern int Breakage15_OpenMethod = 0;
// Valid range: 0-31.
extern int Breakage30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __BWMFI_Parameters__ = "-- Settings for the Market Facilitation Index indicator --";
// Enable BWMFI-based strategy for specific timeframe.
extern bool BWMFI1_Active = 0;
extern bool BWMFI5_Active = 0;
extern bool BWMFI15_Active = 0;
extern bool BWMFI30_Active = 0;
// Trailing Stop method for BWMFI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE BWMFI_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for BWMFI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE BWMFI_TrailingProfitMethod = T_FIXED;
// Not used currently.
extern double BWMFI_OpenLevel = 0;
// Valid range: 0-31.
extern int BWMFI1_OpenMethod = 0;
// Valid range: 0-31.
extern int BWMFI5_OpenMethod = 0;
// Valid range: 0-31.
extern int BWMFI15_OpenMethod = 0;
// Valid range: 0-31.
extern int BWMFI30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __CCI_Parameters__ = "-- Settings for the Commodity Channel Index indicator --";
// Enable CCI-based strategy for specific timeframe.
extern bool CCI1_Active = 0;
extern bool CCI5_Active = 0;
extern bool CCI15_Active = 0;
extern bool CCI30_Active = 0;
// Trailing Stop method for CCI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE CCI_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for CCI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE CCI_TrailingProfitMethod = T_FIXED;
// Averaging period to calculate the main line.
extern int CCI_Period_Fast = 12;
// Averaging period to calculate the main line.
extern int CCI_Period_Slow = 20;
// Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE CCI_Applied_Price = PRICE_CLOSE;
// Not used currently.
extern double CCI_OpenLevel = 0;
// Valid range: 0-31.
extern int CCI1_OpenMethod = 0;
// Valid range: 0-31.
extern int CCI5_OpenMethod = 0;
// Valid range: 0-31.
extern int CCI15_OpenMethod = 0;
// Valid range: 0-31.
extern int CCI30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --";
// Enable DeMarker-based strategy for specific timeframe.
extern bool DeMarker1_Active = TRUE;
extern bool DeMarker5_Active = TRUE;
extern bool DeMarker15_Active = TRUE;
extern bool DeMarker30_Active = TRUE;
// DeMarker averaging period for calculation.
extern int DeMarker_Period = 24;
// Shift relative to the current bar the given amount of periods ago. Suggested value: 4.
extern int DeMarker_Shift = 0;
// Valid range: 0.0-0.4. Suggested value: 0.0.
extern double DeMarker_OpenLevel = 0.2;
// Close opposite orders on market change.
// Trailing Stop method for DeMarker. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = 12;
// Trailing Profit method for DeMarker. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = 9;
// Valid range: 0-31.
extern int DeMarker1_OpenMethod = 29;
// Valid range: 0-31.
extern int DeMarker5_OpenMethod = 8;
// Valid range: 0-31.
extern int DeMarker15_OpenMethod = 25;
// Valid range: 0-31. Used for C_DEMARKER_BUY_SELL close condition.
extern int DeMarker30_OpenMethod = 8;
//+------------------------------------------------------------------+
extern string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --";
// Enable Envelopes-based strategy fpr specific timeframe.
extern bool Envelopes1_Active = 1;
extern bool Envelopes5_Active = 1;
extern bool Envelopes15_Active = 1;
extern bool Envelopes30_Active = 1;
// Averaging period to calculate the main line.
extern int Envelopes_MA_Period = 28;
// MA method (See: ENUM_MA_METHOD).
extern ENUM_MA_METHOD Envelopes_MA_Method = 0;
// The indicator shift relative to the chart.
extern int Envelopes_MA_Shift = 0;
// Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE Envelopes_Applied_Price = 5;
// Percent deviation from the main line.
extern double Envelopes1_Deviation = 0.08;
// Percent deviation from the main line.
extern double Envelopes5_Deviation = 0.12;
// Percent deviation from the main line.
extern double Envelopes15_Deviation = 0.15;
// Percent deviation from the main line.
extern double Envelopes30_Deviation = 0.4;
// The indicator shift relative to the chart.
// extern int Envelopes_Shift_Far = 0;
// The indicator shift relative to the chart.
extern int Envelopes_Shift = 2;
// Trailing Stop method for Bands. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = 18;
// Trailing Profit method for Bands. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = 27;
// TODO
/* extern */ int Envelopes_OpenLevel = 0;
// Valid range: 0-127. Set 0 to default.
extern int Envelopes1_OpenMethod = 30;
// Valid range: 0-127. Set 0 to default.
extern int Envelopes5_OpenMethod = 80;
// Valid range: 0-127. Set 0 to default.
extern int Envelopes15_OpenMethod = 62;
// Valid range: 0-127. Set 0 to default. Used for C_ENVELOPES_BUY_SELL close condition.
extern int Envelopes30_OpenMethod = 62;
//+------------------------------------------------------------------+
extern string __Force_Parameters__ = "-- Settings for the Force Index indicator --";
// Enable Force-based strategy for specific timeframe.
extern bool Force1_Active = 0;
extern bool Force5_Active = 0;
extern bool Force15_Active = 0;
extern bool Force30_Active = 0;
// Trailing Stop method for Force. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Force_TrailingStopMethod = 22;
// Trailing Profit method for Force. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Force_TrailingProfitMethod = 1;
// Averaging period for calculation.
extern int Force_Period = 13;
// Moving Average method (See: ENUM_MA_METHOD). Range: 0-3.
extern ENUM_MA_METHOD Force_MA_Method = 0;
// Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE Force_Applied_price = 0;
// Not used currently.
extern double Force_OpenLevel = 0;
// Valid range: 0-31.
extern int Force1_OpenMethod = 31;
// Valid range: 0-31.
extern int Force5_OpenMethod = 31;
// Valid range: 0-31.
extern int Force15_OpenMethod = 31;
// Valid range: 0-31.
extern int Force30_OpenMethod = 31;
//+------------------------------------------------------------------+
extern string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --";
// Enable Fractals-based strategy for specific timeframe.
extern bool Fractals1_Active = 1;
extern bool Fractals5_Active = 1;
extern bool Fractals15_Active = 1;
extern bool Fractals30_Active = 1;
// Close opposite orders on market change.
//extern bool Fractals_CloseOnChange = TRUE;
// Trailing Stop method for Fractals. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = 21;
// Trailing Profit method for Fractals. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = 24;
// TODO
/* extern */ int Fractals_OpenLevel = 0;
// Valid range: 0-1.
extern int Fractals1_OpenMethod = 1;
// Valid range: 0-1.
extern int Fractals5_OpenMethod = 1;
// Valid range: 0-1.
extern int Fractals15_OpenMethod = 1;
// Valid range: 0-1.
extern int Fractals30_OpenMethod = 1;
//+------------------------------------------------------------------+
extern string __Gator_Parameters__ = "-- Settings for the Gator oscillator --";
// Enable Gator-based strategy for specific timeframe.
extern bool Gator1_Active = 0;
extern bool Gator5_Active = 0;
extern bool Gator15_Active = 0;
extern bool Gator30_Active = 0;
// Trailing Stop method for Gator. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Gator_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for Gator. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Gator_TrailingProfitMethod = T_FIXED;
// Not used currently.
extern double Gator_OpenLevel = 0;
// Valid range: 0-31.
extern int Gator1_OpenMethod = 0;
// Valid range: 0-31.
extern int Gator5_OpenMethod = 0;
// Valid range: 0-31.
extern int Gator15_OpenMethod = 0;
// Valid range: 0-31.
extern int Gator30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __Ichimoku_Parameters__ = "-- Settings for the Ichimoku Kinko Hyo indicator --";
// Enable Ichimoku-based strategy for specific timeframe.
extern bool Ichimoku1_Active = 0;
extern bool Ichimoku5_Active = 0;
extern bool Ichimoku15_Active = 0;
extern bool Ichimoku30_Active = 0;
// Trailing Stop method for Ichimoku. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Ichimoku_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for Ichimoku. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Ichimoku_TrailingProfitMethod = T_FIXED;
// Tenkan Sen averaging period.
extern int Ichimoku_Period_Tenkan_Sen = 9;
// Kijun Sen averaging period.
extern int Ichimoku_Period_Kijun_Sen = 26;
// Senkou SpanB averaging period.
extern int Ichimoku_Period_Senkou_Span_B = 52;
// Not used currently.
extern double Ichimoku_OpenLevel = 0;
// Valid range: 0-31.
extern int Ichimoku1_OpenMethod = 0;
// Valid range: 0-31.
extern int Ichimoku5_OpenMethod = 0;
// Valid range: 0-31.
extern int Ichimoku15_OpenMethod = 0;
// Valid range: 0-31.
extern int Ichimoku30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __MA_Parameters__ = "-- Settings for the Moving Average indicator --";
// Enable MA-based strategy for specific timeframe.
extern bool MA1_Active = 1;
extern bool MA5_Active = 1;
extern bool MA15_Active = 1;
extern bool MA30_Active = 1;
// Averaging period for calculation.
extern int MA_Period_Fast = 10;
// Averaging period for calculation.
extern int MA_Period_Medium = 18;
// Averaging period for calculation.
extern int MA_Period_Slow = 42;
// Testing
// extern double MA_Period_Ratio = 2;
extern int MA_Shift = 0;
// Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Fast = 0;
// Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Medium = 2;
// Index of the value taken from the indicator buffer. Shift relative to the previous bar (+1).
extern int MA_Shift_Slow = 5;
// Far shift. Shift relative to the 2 previous bars (+2).
extern int MA_Shift_Far = 1;
// MA method (See: ENUM_MA_METHOD). Range: 0-3. Suggested value: MODE_EMA.
extern ENUM_MA_METHOD MA_Method = 3;
// MA applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE MA_Applied_Price = 0;
// Trailing Stop method for MA. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MA_TrailingStopMethod = 18;
// Trailing Profit method for MA. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MA_TrailingProfitMethod = 1;
// Minimum open level between moving averages to raise the trade signal.
extern double MA_OpenLevel = 1.0;
// Valid range: 0-127.
extern int MA1_OpenMethod = 57;
// Valid range: 0-127.
extern int MA5_OpenMethod = 51;
// Valid range: 0-127.
extern int MA15_OpenMethod = 65;
// Valid range: 0-127. This value is used for close condition.
extern int MA30_OpenMethod = 48;
//+------------------------------------------------------------------+
extern string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --";
// Enable MACD-based strategy for specific timeframe.
extern bool MACD1_Active = 1;
extern bool MACD5_Active = 1;
extern bool MACD15_Active = 1;
extern bool MACD30_Active = 1;
// Fast EMA averaging period.
extern int MACD_Period_Fast = 14;
// Slow EMA averaging period.
extern int MACD_Period_Slow = 35;
// Signal line averaging period.
extern int MACD_Signal_Period = 10;
// MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE MACD_Applied_Price = 6;
// Past MACD value in number of bars. Shift relative to the current bar the given amount of periods ago. Suggested value: 1
extern int MACD_Shift = 2;
// Additional MACD far value in number of bars relatively to MACD_Shift.
extern int MACD_Shift_Far = 0;
// Trailing Stop method for MACD. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MACD_TrailingStopMethod = 5;
// Trailing Profit method for MACD. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = 25;
extern double MACD_OpenLevel  = 0.2;
// Valid range: 0-31.
extern int MACD1_OpenMethod = 4;
// Valid range: 0-31.
extern int MACD5_OpenMethod = 27;
// Valid range: 0-31.
extern int MACD15_OpenMethod = 5;
// Valid range: 0-31. This value is used for close condition.
extern int MACD30_OpenMethod = 4;
//+------------------------------------------------------------------+
extern string __MFI_Parameters__ = "-- Settings for the Money Flow Index indicator --";
// Enable MFI-based strategy for specific timeframe.
extern bool MFI1_Active = TRUE;
extern bool MFI5_Active = TRUE;
extern bool MFI15_Active = TRUE;
extern bool MFI30_Active = TRUE;
// Trailing Stop method for MFI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MFI_TrailingStopMethod = 22;
// Trailing Profit method for MFI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE MFI_TrailingProfitMethod = 1;
// Averaging period for calculation.
extern int MFI_Period = 14;
// Not used currently.
extern double MFI_OpenLevel = 0;
// Valid range: 0-31.
extern int MFI1_OpenMethod = 0;
// Valid range: 0-31.
extern int MFI5_OpenMethod = 0;
// Valid range: 0-31.
extern int MFI15_OpenMethod = 0;
// Valid range: 0-31.
extern int MFI30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __Momentum_Parameters__ = "-- Settings for the Momentum indicator --";
// Enable Momentum-based strategy for specific timeframe.
extern bool Momentum1_Active = 0;
extern bool Momentum5_Active = 0;
extern bool Momentum15_Active = 0;
extern bool Momentum30_Active = 0;
// Trailing Stop method for Momentum. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Momentum_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for Momentum. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Momentum_TrailingProfitMethod = T_FIXED;
// Averaging period for calculation.
extern int Momentum_Period_Fast = 12;
// Averaging period for calculation.
extern int Momentum_Period_Slow = 20;
// Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE Momentum_Applied_Price = PRICE_CLOSE;
// Not used currently.
extern double Momentum_OpenLevel = 0;
// Valid range: 0-x.
extern int Momentum1_OpenMethod = 0;
// Valid range: 0-x.
extern int Momentum5_OpenMethod = 0;
// Valid range: 0-x.
extern int Momentum15_OpenMethod = 0;
// Valid range: 0-x.
extern int Momentum30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __OBV_Parameters__ = "-- Settings for the On Balance Volume indicator --";
// Enable OBV-based strategy for specific timeframe.
extern bool OBV1_Active = 0;
extern bool OBV5_Active = 0;
extern bool OBV15_Active = 0;
extern bool OBV30_Active = 0;
// Trailing Stop method for OBV. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE OBV_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for OBV. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE OBV_TrailingProfitMethod = T_FIXED;
// Applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE OBV_Applied_Price = PRICE_CLOSE;
// Not used currently.
extern double OBV_OpenLevel = 0;
// Valid range: 0-31.
extern int OBV1_OpenMethod = 0;
// Valid range: 0-31.
extern int OBV5_OpenMethod = 0;
// Valid range: 0-31.
extern int OBV15_OpenMethod = 0;
// Valid range: 0-31.
extern int OBV30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __OSMA_Parameters__ = "-- Settings for the Moving Average of Oscillator indicator --";
// Enable OSMA-based strategy for specific timeframe.
extern bool OSMA1_Active = 0;
extern bool OSMA5_Active = 0;
extern bool OSMA15_Active = 0;
extern bool OSMA30_Active = 0;
// Trailing Stop method for OSMA. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE OSMA_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for OSMA. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE OSMA_TrailingProfitMethod = T_FIXED;
// Fast EMA averaging period.
extern int OSMA_Period_Fast = 12;
// Slow EMA averaging period.
extern int OSMA_Period_Slow = 26;
// Signal line averaging period.
extern int OSMA_Period_Signal = 9;
// MACD applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE OSMA_Applied_Price = PRICE_OPEN;
// Not used currently.
extern double OSMA_OpenLevel = 0;
// Valid range: 0-31.
extern int OSMA1_OpenMethod = 0;
// Valid range: 0-31.
extern int OSMA5_OpenMethod = 0;
// Valid range: 0-31.
extern int OSMA15_OpenMethod = 0;
// Valid range: 0-31.
extern int OSMA30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --";
// Enable RSI-based strategy for specific timeframe.
extern bool RSI1_Active = 1;
extern bool RSI5_Active = 1;
extern bool RSI15_Active = 1;
extern bool RSI30_Active = 0;
// Averaging period for calculation.
extern int RSI_Period = 20;
// RSI applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE RSI_Applied_Price = 2;
// Shift relative to the chart.
extern int RSI_Shift = 0;
// Trailing Stop method for RSI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE RSI_TrailingStopMethod = 13;
// Trailing Profit method for RSI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = 20;
extern int RSI_OpenLevel = 20;
// Valid range: 0-63.
extern int RSI1_OpenMethod = 0;
// Valid range: 0-63. Optimized based on genetic algorithm between 2015.01.01-2015.06.30 with spread 20. 2, 5, 306, 374, 388, 642
extern int RSI5_OpenMethod = 33;
// Valid range: 0-63.
extern int RSI15_OpenMethod = 6;
// Valid range: 0-63. Used for C_RSI_BUY_SELL close condition (6).
extern int RSI30_OpenMethod = 2;
//+------------------------------------------------------------------+
extern string __RVI_Parameters__ = "-- Settings for the Relative Vigor Index indicator --";
// Enable RVI-based strategy for specific timeframe.
extern bool RVI1_Active = 0;
extern bool RVI5_Active = 0;
extern bool RVI15_Active = 0;
extern bool RVI30_Active = 0;
// Trailing Stop method for RVI. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE RVI_TrailingStopMethod = T_MA_FMS_PEAK;
// Trailing Profit method for RVI. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE RVI_TrailingProfitMethod = T_FIXED;
// Shift relative to the previous bar the given amount of periods ago.
extern int RVI_Shift = 2;
// Shift relative to the previous bar shift the given amount of periods ago.
extern int RVI_Shift_Far = 0;
// Not used currently.
extern double RVI_OpenLevel = 0;
// Valid range: 0-31.
extern int RVI1_OpenMethod = 0;
// Valid range: 0-31.
extern int RVI5_OpenMethod = 0;
// Valid range: 0-31.
extern int RVI15_OpenMethod = 0;
// Valid range: 0-31.
extern int RVI30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __SAR_Parameters__ = "-- Settings for the the Parabolic Stop and Reverse system indicator --";
// Enable SAR-based strategy for specific timeframe.
extern bool SAR1_Active = 1;
extern bool SAR5_Active = 1;
extern bool SAR15_Active = 1;
extern bool SAR30_Active = 1;
// Stop increment, usually 0.02.
extern double SAR_Step = 0.01;
// Maximum stop value, usually 0.2.
extern double SAR_Maximum_Stop = 0.3;
// Shift relative to the chart.
extern int SAR_Shift = 0;
// Trailing Stop method for SAR. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE SAR_TrailingStopMethod = 13;
// Trailing Profit method for SAR. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE SAR_TrailingProfitMethod = 18;
// Open gap level to raise the trade signal (in pips).
extern double SAR_OpenLevel = 0.2;
// Valid range: 0-127. Optimized.
extern int SAR1_OpenMethod = 0;
// Valid range: 0-127. Optimized.
extern int SAR5_OpenMethod = 86;
// Valid range: 0-127. Optimized.
extern int SAR15_OpenMethod = 16;
// Valid range: 0-127. Used for C_SAR_BUY_SELL close condition.
extern int SAR30_OpenMethod = 20;
//+------------------------------------------------------------------+
extern string __StdDev_Parameters__ = "-- Settings for the Standard Deviation indicator --";
// Enable StdDev-based strategy for specific timeframe.
extern bool StdDev1_Active = 1;
extern bool StdDev5_Active = 1;
extern bool StdDev15_Active = 1;
extern bool StdDev30_Active = 1;
// Trailing Stop method for StdDev. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE StdDev_TrailingStopMethod = 22;
// Trailing Profit method for StdDev. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE StdDev_TrailingProfitMethod = 1;
// MA applied price (See: ENUM_APPLIED_PRICE). Range: 0-6.
extern ENUM_APPLIED_PRICE StdDev_AppliedPrice = PRICE_CLOSE;
// Averaging period to calculate the main line.
extern int StdDev_MA_Period = 10;
// MA method (See: ENUM_MA_METHOD). Range: 0-3. Suggested value: MODE_EMA.
extern ENUM_MA_METHOD StdDev_MA_Method = 1;
// Moving Average shift.
extern int StdDev_MA_Shift = 0;
// Not used currently.
extern double StdDev_OpenLevel = 0.0;
// Valid range: 0-31.
extern int StdDev1_OpenMethod = 31;
// Valid range: 0-31.
extern int StdDev5_OpenMethod = 31;
// Valid range: 0-31.
extern int StdDev15_OpenMethod = 31;
// Valid range: 0-31.
extern int StdDev30_OpenMethod = 31;
//+------------------------------------------------------------------+
extern string __Stochastic_Parameters__ = "-- Settings for the the Stochastic Oscillator --";
// Enable Stochastic-based strategy for specific timeframe.
extern bool Stochastic1_Active = 1;
extern bool Stochastic5_Active = 1;
extern bool Stochastic15_Active = 1;
extern bool Stochastic30_Active = 1;
// Trailing Stop method for Stochastic. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Stochastic_TrailingStopMethod = 22;
// Trailing Profit method for Stochastic. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE Stochastic_TrailingProfitMethod = 1;
// Not used currently.
extern double Stochastic_OpenLevel = 0.0;
// Valid range: 0-31.
extern int Stochastic1_OpenMethod = 0;
// Valid range: 0-31.
extern int Stochastic5_OpenMethod = 0;
// Valid range: 0-31.
extern int Stochastic15_OpenMethod = 0;
// Valid range: 0-31.
extern int Stochastic30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --";
// Enable WPR-based strategy for specific timeframe.
extern bool WPR1_Active = 1;
extern bool WPR5_Active = 1;
extern bool WPR15_Active = 1;
extern bool WPR30_Active = 1;
// Averaging period for calculation. Suggested value: 22.
extern int WPR_Period = 21;
// Shift relative to the current bar the given amount of periods ago. Suggested value: 1.
extern int WPR_Shift = 0;
// Suggested range: 25-35.
extern int WPR_OpenLevel = 30;
// Close opposite orders on market change.
//extern bool WPR_CloseOnChange = TRUE;
// Trailing Stop method for WPR. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE WPR_TrailingStopMethod = 0;
// Trailing Profit method for WPR. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE WPR_TrailingProfitMethod = 10;
// Valid range: 0-63. Optimized.
extern int WPR1_OpenMethod = 14;
// Valid range: 0-63. Optimized.
extern int WPR5_OpenMethod = 10;
// Valid range: 0-63. Optimized.
extern int WPR15_OpenMethod = 14;
// Valid range: 0-63. Optimized with T_MA_M_FAR_TRAIL (8). Used for C_WPR_BUY_SELL close condition (16).
extern int WPR30_OpenMethod = 0;
//+------------------------------------------------------------------+
// Enable ZigZag-based strategy for specific timeframe.
extern bool ZigZag1_Active = 0;
extern bool ZigZag5_Active = 0;
extern bool ZigZag15_Active = 0;
extern bool ZigZag30_Active = 0;
// Trailing Stop method for ZigZag. Set 0 to default (DefaultTrailingStopMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ZigZag_TrailingStopMethod = 22;
// Trailing Profit method for ZigZag. Set 0 to default (DefaultTrailingProfitMethod). See: ENUM_TRAIL_TYPE.
extern ENUM_TRAIL_TYPE ZigZag_TrailingProfitMethod = 1;
// Not used currently.
extern double ZigZag_OpenLevel = 0.0;
// Valid range: 0-31.
extern int ZigZag1_OpenMethod = 0;
// Valid range: 0-31.
extern int ZigZag5_OpenMethod = 0;
// Valid range: 0-31.
extern int ZigZag15_OpenMethod = 0;
// Valid range: 0-31.
extern int ZigZag30_OpenMethod = 0;
//+------------------------------------------------------------------+
extern string __Logging_Parameters__ = "-- Settings for logging & messages --";
extern bool PrintLogOnChart = TRUE;
// Display errors.
extern bool VerboseErrors = TRUE;
// Display info messages.
extern bool VerboseInfo = TRUE;
// Display debug messages.
extern bool VerboseDebug = TRUE;
// Display even more debugging.
bool VerboseTrace = FALSE;
// Write report into the file on exit.
extern bool WriteReport = TRUE;

//+------------------------------------------------------------------+
extern string __UI_UX_Parameters__ = "-- Settings for User Interface & Experience --";
extern bool SendEmailEachOrder = FALSE;
extern bool SoundAlert = FALSE;
// Send logs to remote host for diagnostic purposes.
// extern bool SendLogs = FALSE;
extern string SoundFileAtOpen = "alert.wav";
extern string SoundFileAtClose = "alert.wav";
extern color ColorBuy = Blue;
extern color ColorSell = Red;
//+------------------------------------------------------------------+
extern string __Other_Parameters__ = "-- Other parameters --";

// To help identify its own orders. It can vary in additional range: +20, see: ENUM_ORDER_TYPE.
extern int MagicNumber = 31337;
// Cache some calculated variables for better performance. FIXME: Needs some work.
#ifdef __experimental__
  extern bool Cache = FALSE;
#else
  const bool Cache = FALSE;
#endif
//extern int ManualGMToffset = 0;
// How often trailing stop should be updated (in seconds). FIXME: Fix relative delay in backtesting.
//extern int TrailingStopDelay = 0;
// How often job list should be processed (in seconds).
//extern int JobProcessDelay = 1;
