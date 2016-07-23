//+------------------------------------------------------------------+
//|                                                ea-input-lite.mqh |
//|                                           Copyright 2016, kenorb |
//|                                       https://github.com/EA31337 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, kenorb" // ©
#property link      "https://github.com/EA31337"

//+------------------------------------------------------------------+
//| Includes.
//+------------------------------------------------------------------+
#include <EA\ea-enums.mqh>

//+------------------------------------------------------------------+
//| User input variables.
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
extern string __Trade_Parameters__ = "-- Trade parameters --"; // >>> TRADE <<<
extern int      MaxOrders = 0; // Max orders (0 = auto)
extern int      MaxOrdersPerType = 35; // Max orders per type (0 = auto)
extern double   LotSize = 0.00000000; // Lot size (0 = auto)
extern bool     TradeMicroLots = 1; // Trade micro lots?
extern int TrendMethod = 135; // Main trend method (0-255)
extern int MinVolumeToTrade = 2; // Min volume to trade
extern int MaxOrderPriceSlippage = 5; // Max price slippage (in pips)
extern int MaxTries = 5; // Max retries for opening orders
extern double MinPipChangeToTrade = 0.90000000; // Min pip change to trade (0 = every tick)
extern int MinPipGap = 60; // Min gap between trades per type (in pips)

//+------------------------------------------------------------------+
extern string   __EA_Order_Parameters__ = "-- Profit and loss parameters --"; // >>> PROFIT/LOSS <<<
extern double   TakeProfit = 140.00000000; // Take profit (in pips, 0 = none)
extern double   StopLoss = 140.00000000; // Stop loss (in pips, 0 = none)

//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Profit and loss trailing parameters --"; // >>> TRAILINGS <<<
extern int TrailingStop = 50; // Trailing stop (in pips)
extern ENUM_TRAIL_TYPE DefaultTrailingStopMethod = 7; // Default trail stop method (0 = none)
extern bool TrailingStopOneWay = 0; // Trailing stop one way?
extern int TrailingProfit = 80; // Trailing profit (in pips)
extern ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = 17; // Default trail profit method
extern bool TrailingProfitOneWay = 1; // Trailing profit one way?
extern double TrailingStopAddPerMinute = 0.00000000; // Decrease trail stop per minute (pip/min)

//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management parameters --"; // >>> RISK <<
extern bool TradeWithTrend = 0; // Trade with trend
extern double RiskRatio = 0.00000000; // Risk ratio (0 = auto, 1.0 = normal)
extern int CloseOrderAfterXHours = 0; // Close order after X hours (0 = disabled)

//+------------------------------------------------------------------+
extern string __Strategy_Parameters__ = "-- Per strategy parameters (0 to disable) --"; // >>> STRATEGIES <<<
extern double ProfitFactorMinToTrade = 0.90000000; // Min. profit factor per strategy to trade
extern double ProfitFactorMaxToTrade = 5.00000000; // Max. profit factor per strategy to trade

//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting parameters (set 1.0 for default) --"; // >>> BOOSTING <<<
extern bool Boosting_Enabled = 1; // Enable boosting
extern double BoostTrendFactor = 1.30000000; // Boost by trend factor
extern double BestDailyStrategyMultiplierFactor = 1.50000000; // Multiplier for the best daily strategy
extern double BestWeeklyStrategyMultiplierFactor = 1.00000000; // Multiplier for the best weekly strategy
extern double BestMonthlyStrategyMultiplierFactor = 1.00000000; // Multiplier for the best monthly strategy
extern double WorseDailyStrategyDividerFactor = 1.00000000; // Divider for the worse daily strategy
extern double WorseWeeklyStrategyDividerFactor = 1.00000000; // Divider for the worse weekly strategy
extern double WorseMonthlyStrategyDividerFactor = 1.00000000; // Divider for the worse monthly strategy

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions__ = "-- Account conditions --"; // >>> CONDITIONS & ACTIONS <<<
// Note: It's not advice to use on accounts where multi bots are trading.
extern bool Account_Conditions_Active = 1; // Enable account conditions
extern ENUM_ACC_CONDITION Account_Condition_1 = 5; // 1. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_1 = 13; // 1. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_1 = 3; // 1. Action to take

extern ENUM_ACC_CONDITION Account_Condition_2 = 8; // 2. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_2 = 14; // 2. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_2 = 10; // 2. Action to take

extern ENUM_ACC_CONDITION Account_Condition_3 = 13; // 3. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_3 = 14; // 3. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_3 = 10; // 3. Action to take

extern ENUM_ACC_CONDITION Account_Condition_4 = 2; // 4. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_4 = 13; // 4. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_4 = 10; // 4. Action to take

extern ENUM_ACC_CONDITION Account_Condition_5 = 18; // 5. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_5 = 7; // 5. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_5 = 10; // 5. Action to take

extern int Account_Condition_MinProfitCloseOrder = 20; // Min pip profit on action to close

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions_Params__ = "-- Account conditions parameters --"; // >>> CONDITIONS & ACTIONS PARAMS <<<
extern int MarketSuddenDropSize = 20; // Drop in pips to react
extern int MarketBigDropSize = 50; // Big drop in pips to react
extern int TrendMethodAction = 238; // Trend method for actions (0-255)
extern int MarketSpecificHour = 22; // Specific hour used for conditions (0-23)

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

//+------------------------------------------------------------------+
extern string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --"; // >>> ALLIGATOR <<<
extern bool Alligator1_Active = 1; // Enable for M1
extern bool Alligator5_Active = 1; // Enable for M5
extern bool Alligator15_Active = 1; // Enable for M15
extern bool Alligator30_Active = 1; // Enable for M30
extern int Alligator_Period_Jaw = 19; // Jaw Period
extern int Alligator_Shift_Jaw = 1; // Jaw Shift
extern int Alligator_Period_Teeth = 7; // Teeth Period
extern int Alligator_Shift_Teeth = 3; // Teeth Shift
extern int Alligator_Period_Lips = 7; // Lips Period
extern int Alligator_Shift_Lips = 0; // Lips Shift
extern ENUM_MA_METHOD Alligator_MA_Method = 0; // MA Method
extern ENUM_APPLIED_PRICE Alligator_Applied_Price = 4; // Applied Price
extern int Alligator_Shift = 0; // Shift
extern int Alligator_Shift_Far = 3; // Shift Far
extern ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = 22; // Trail stop method
extern ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = 24; // Trail profit method
extern double Alligator_SignalLevel = 0.02000000; // Signal level
extern int Alligator1_SignalMethod = 21; // Signal method for M1 (0-63)
extern int Alligator5_SignalMethod = 0; // Signal method for M5 (0-63)
extern int Alligator15_SignalMethod = 0; // Signal method for M15 (0-63)
extern int Alligator30_SignalMethod = 33; // Signal method for M30 (0-63)

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
double ATR_SignalLevel = 0.00000000; // Signal level
int ATR1_SignalMethod = 31; // Signal method for M1 (0-31)
int ATR5_SignalMethod = 31; // Signal method for M5 (0-31)
int ATR15_SignalMethod = 31; // Signal method for M15 (0-31)
int ATR30_SignalMethod = 31; // Signal method for M30 (0-31)

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

//+------------------------------------------------------------------+
extern string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --"; // >>> BANDS <<<
extern bool Bands1_Active = 0; // Enable for M1
extern bool Bands5_Active = 0; // Enable for M5
extern bool Bands15_Active = 0; // Enable for M15
extern bool Bands30_Active = 0; // Enable for M30
extern int Bands_Period = 24; // Period
extern ENUM_APPLIED_PRICE Bands_Applied_Price = 2; // Applied Price
extern double Bands_Deviation = 2.60000000; // Deviation
extern int Bands_Shift = 0; // Shift
/* @todo extern */ int Bands_Shift_Far = 0; // Shift Far
extern ENUM_TRAIL_TYPE Bands_TrailingStopMethod = 23; // Trail stop method
extern ENUM_TRAIL_TYPE Bands_TrailingProfitMethod = 27; // Trail profit method
/* @todo extern */ int Bands_SignalLevel = 0; // Signal level
extern int Bands1_SignalMethod = 0; // Signal method for M1 (0-255)
extern int Bands5_SignalMethod = 0; // Signal method for M5 (0-255)
extern int Bands15_SignalMethod = 0; // Signal method for M15 (0-255)
extern int Bands30_SignalMethod = 0; // Signal method for M30 (0-255)

//+------------------------------------------------------------------+
string __BPower_Parameters__ = "-- Settings for the Bulls/Bears Power indicator --"; // >>> BULLS/BEARS POWER <<<
bool BPower1_Active = 0; // Enable for M1
bool BPower5_Active = 0; // Enable for M5
bool BPower15_Active = 0; // Enable for M15
bool BPower30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE BPower_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BPower_TrailingProfitMethod = 1; // Trail profit method
int BPower_Period = 13; // Period
ENUM_APPLIED_PRICE BPower_Applied_Price = 0; // Applied Price
double BPower_SignalLevel = 0.00000000; // Signal level
int BPower1_SignalMethod = 15; // Signal method for M1 (0-
int BPower5_SignalMethod = 15; // Signal method for M5 (0-
int BPower15_SignalMethod = 15; // Signal method for M15 (0-
int BPower30_SignalMethod = 15; // Signal method for M30 (0-

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

//+------------------------------------------------------------------+
string __CCI_Parameters__ = "-- Settings for the Commodity Channel Index indicator --"; // >>> CCI <<<
bool CCI1_Active = 0; // Enable for M1
bool CCI5_Active = 0; // Enable for M5
bool CCI15_Active = 0; // Enable for M15
bool CCI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE CCI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE CCI_TrailingProfitMethod = 1; // Trail profit method
int CCI_Period_Fast = 12; // Period Fast
int CCI_Period_Slow = 20; // Period Slow
ENUM_APPLIED_PRICE CCI_Applied_Price = 0; // Applied Price
double CCI_SignalLevel = 0.00000000; // Signal level
int CCI1_SignalMethod = 0; // Signal method for M1 (0-
int CCI5_SignalMethod = 0; // Signal method for M5 (0-
int CCI15_SignalMethod = 0; // Signal method for M15 (0-
int CCI30_SignalMethod = 0; // Signal method for M30 (0-

//+------------------------------------------------------------------+
extern string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --"; // >>> DEMARKER <<<
extern bool DeMarker1_Active = 1; // Enable for M1
extern bool DeMarker5_Active = 1; // Enable for M5
extern bool DeMarker15_Active = 1; // Enable for M15
extern bool DeMarker30_Active = 1; // Enable for M30
extern int DeMarker_Period = 23; // Period
extern int DeMarker_Shift = 1; // Shift
extern double DeMarker_SignalLevel = 0.40000000; // Signal level (0.0-0.4)
extern ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = 13; // Trail stop method
extern ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = 24; // Trail profit method
extern int DeMarker1_SignalMethod = 15; // Signal method for M1 (0-
extern int DeMarker5_SignalMethod = 15; // Signal method for M5 (0-
extern int DeMarker15_SignalMethod = 15; // Signal method for M15 (0-
extern int DeMarker30_SignalMethod = 12; // Signal method for M30 (0-

//+------------------------------------------------------------------+
extern string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --"; // >>> ENVELOPES <<<
extern bool Envelopes1_Active = 1; // Enable for M1
extern bool Envelopes5_Active = 1; // Enable for M5
extern bool Envelopes15_Active = 1; // Enable for M15
extern bool Envelopes30_Active = 0; // Enable for M30
extern int Envelopes_MA_Period = 28; // Period
extern ENUM_MA_METHOD Envelopes_MA_Method = 0; // MA Method
extern int Envelopes_MA_Shift = 0; // MA Shift
extern ENUM_APPLIED_PRICE Envelopes_Applied_Price = 5; // Applied Price
extern double Envelopes1_Deviation = 0.05000000; // Deviation for M1
extern double Envelopes5_Deviation = 0.15000000; // Deviation for M5
extern double Envelopes15_Deviation = 0.30000000; // Deviation for M15
extern double Envelopes30_Deviation = 0.20000000; // Deviation for M30
extern int Envelopes_Shift = 2; // Shift
int Envelopes_Shift_Far = 0; // Shift Far
extern ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = 6; // Trail stop method
extern ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = 24; // Trail profit method
/* @todo extern */ int Envelopes_SignalLevel = 0; // Signal level
extern int Envelopes1_SignalMethod = 126; // Signal method for M1 (0-127)
extern int Envelopes5_SignalMethod = 48; // Signal method for M5 (0-127)
extern int Envelopes15_SignalMethod = 126; // Signal method for M15 (0-127)
extern int Envelopes30_SignalMethod = 126; // Signal method for M30 (0-127)

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

//+------------------------------------------------------------------+
extern string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --"; // >>> FRACTALS <<<
extern bool Fractals1_Active = 1; // Enable for M1
extern bool Fractals5_Active = 1; // Enable for M5
extern bool Fractals15_Active = 1; // Enable for M15
extern bool Fractals30_Active = 1; // Enable for M30
extern ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = 12; // Trail stop method
extern ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = 24; // Trail profit method
/* @todo extern */ int Fractals_SignalLevel = 0; // Signal level
extern int Fractals1_SignalMethod = 1; // Signal method for M1 (0-7)
extern int Fractals5_SignalMethod = 1; // Signal method for M5 (0-7)
extern int Fractals15_SignalMethod = 1; // Signal method for M15 (0-7)
extern int Fractals30_SignalMethod = 4; // Signal method for M30 (0-7)

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

//+------------------------------------------------------------------+
extern string __MA_Parameters__ = "-- Settings for the Moving Average indicator --"; // >>> MA <<<
extern bool MA1_Active = 1; // Enable for M1
extern bool MA5_Active = 1; // Enable for M5
extern bool MA15_Active = 1; // Enable for M15
extern bool MA30_Active = 1; // Enable for M30
extern int MA_Period_Fast = 11; // Period Fast
extern int MA_Period_Medium = 20; // Period Medium
extern int MA_Period_Slow = 42; // Period Slow
extern int MA_Shift = 0; // Shift
extern int MA_Shift_Fast = 0; // Shift Fast (+1)
extern int MA_Shift_Medium = 1; // Shift Medium (+1)
extern int MA_Shift_Slow = 5; // Shift Slow (+1)
extern int MA_Shift_Far = 1; // Shift Far (+2)
extern ENUM_MA_METHOD MA_Method = 0; // MA Method
extern ENUM_APPLIED_PRICE MA_Applied_Price = 0; // Applied Price
extern ENUM_TRAIL_TYPE MA_TrailingStopMethod = 18; // Trail stop method
extern ENUM_TRAIL_TYPE MA_TrailingProfitMethod = 22; // Trail profit method
extern double MA_SignalLevel = 1.20000000; // Signal level
extern int MA1_SignalMethod = 15; // Signal method for M1 (0-127)
extern int MA5_SignalMethod = 9; // Signal method for M5 (0-127)
extern int MA15_SignalMethod = 24; // Signal method for M15 (0-127)
extern int MA30_SignalMethod = 14; // Signal method for M30 (0-127)

//+------------------------------------------------------------------+
extern string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --"; // >>> MACD <<<
extern bool MACD1_Active = 1; // Enable for M1
extern bool MACD5_Active = 1; // Enable for M5
extern bool MACD15_Active = 1; // Enable for M15
extern bool MACD30_Active = 1; // Enable for M30
extern int MACD_Period_Fast = 12; // Period Fast
extern int MACD_Period_Slow = 34; // Period Slow
extern int MACD_Period_Signal = 10; // Period for signal
extern ENUM_APPLIED_PRICE MACD_Applied_Price = 6; // Applied Price
extern int MACD_Shift = 4; // Shift
extern int MACD_Shift_Far = 0; // Shift Far
extern ENUM_TRAIL_TYPE MACD_TrailingStopMethod = 17; // Trail stop method
extern ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = 24; // Trail profit method
extern double MACD_SignalLevel = 0.30000000; // Signal level
extern int MACD1_SignalMethod = 18; // Signal method for M1 (0-31)
extern int MACD5_SignalMethod = 16; // Signal method for M5 (0-31)
extern int MACD15_SignalMethod = 25; // Signal method for M15 (0-31)
extern int MACD30_SignalMethod = 6; // Signal method for M30 (0-31)

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
ENUM_APPLIED_PRICE OSMA_Applied_Price = 0; // Applied Price
double OSMA_SignalLevel = 1.20000000; // Signal level
int OSMA1_SignalMethod = 15; // Signal method for M1 (0-
int OSMA5_SignalMethod = 9; // Signal method for M5 (0-
int OSMA15_SignalMethod = 24; // Signal method for M15 (0-
int OSMA30_SignalMethod = 14; // Signal method for M30 (0-

//+------------------------------------------------------------------+
extern string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --"; // >>> RSI <<<
extern bool RSI1_Active = 1; // Enable for M1
extern bool RSI5_Active = 1; // Enable for M5
extern bool RSI15_Active = 1; // Enable for M15
extern bool RSI30_Active = 1; // Enable for M30
extern int RSI_Period = 22; // Period
extern ENUM_APPLIED_PRICE RSI_Applied_Price = 2; // Applied Price
extern int RSI_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE RSI_TrailingStopMethod = 9; // Trail stop method
extern ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = 24; // Trail profit method
extern int RSI_SignalLevel = 18; // Signal level
extern int RSI1_SignalMethod = 23; // Signal method for M1 (0-63)
extern int RSI5_SignalMethod = 54; // Signal method for M5 (0-63)
extern int RSI15_SignalMethod = 14; // Signal method for M15 (0-63)
extern int RSI30_SignalMethod = 8; // Signal method for M30 (0-63)

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

//+------------------------------------------------------------------+
extern string __SAR_Parameters__ = "-- Settings for the the Parabolic Stop and Reverse system indicator --"; // >>> SAR <<<
extern bool SAR1_Active = 1; // Enable for M1
extern bool SAR5_Active = 1; // Enable for M5
extern bool SAR15_Active = 1; // Enable for M15
extern bool SAR30_Active = 1; // Enable for M30
extern double SAR_Step = 0.02000000; // Step
extern double SAR_Maximum_Stop = 0.30000000; // Maximum stop
extern int SAR_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE SAR_TrailingStopMethod = 1; // Trail stop method
extern ENUM_TRAIL_TYPE SAR_TrailingProfitMethod = 18; // Trail profit method
extern double SAR_SignalLevel = 0.40000000; // Signal level
extern int SAR1_SignalMethod = 114; // Signal method for M1 (0-127)
extern int SAR5_SignalMethod = 0; // Signal method for M5 (0-127)
extern int SAR15_SignalMethod = 0; // Signal method for M15 (0-127)
extern int SAR30_SignalMethod = 33; // Signal method for M30 (0-127)

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

//+------------------------------------------------------------------+
string __Stochastic_Parameters__ = "-- Settings for the the Stochastic Oscillator --"; // >>> STOCHASTIC <<<
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

//+------------------------------------------------------------------+
extern string __WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --"; // >>> WPR <<<
extern bool WPR1_Active = 1; // Enable for M1
extern bool WPR5_Active = 0; // Enable for M5
extern bool WPR15_Active = 1; // Enable for M15
extern bool WPR30_Active = 1; // Enable for M30
extern int WPR_Period = 21; // Period
extern int WPR_Shift = 0; // Shift
extern int WPR_SignalLevel = 30; // Signal level
extern ENUM_TRAIL_TYPE WPR_TrailingStopMethod = 7; // Trail stop method
extern ENUM_TRAIL_TYPE WPR_TrailingProfitMethod = 24; // Trail profit method
extern int WPR1_SignalMethod = 34; // Signal method for M1 (0-63)
extern int WPR5_SignalMethod = 32; // Signal method for M5 (0-63)
extern int WPR15_SignalMethod = 45; // Signal method for M15 (0-63)
extern int WPR30_SignalMethod = 63; // Signal method for M30 (0-63)

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
extern bool WriteReport = 1; // Write file report on exit
extern bool PrintLogOnChart = 1; // Display info on chart
extern bool VerboseErrors = 1; // Display errors
extern bool VerboseInfo = 1; // Display info messages
bool VerboseDebug = 0; // Display debug messages
bool VerboseTrace = 0; // Display trace messages

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
extern string __Backtest_Parameters__ = "-- Backtest parameters --"; // >>> BACKTESTING <<<
extern bool ValidateSettings = 1; // Validate startup settings
extern int DemoMarketStopLevel = 10; // Demo market stop level

//+------------------------------------------------------------------+
extern string __Constants__ = "-- Constants --"; // >>> CONSTANTS <<<
extern int MagicNumber = 31337; // Unique magic number (+40)

//+------------------------------------------------------------------+
extern string __Other_Parameters__ = "-- Other parameters --"; // >>> OTHER <<<
