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
extern int      MaxOrdersPerType = 15; // Max orders per type (0 = auto)
extern double   LotSize = 0.00000000; // Lot size (0 = auto)
extern bool     TradeMicroLots = 1; // Trade micro lots?
extern int TrendMethod = 135; // Main trend method (0-255)
extern int MinVolumeToTrade = 2; // Min volume to trade
extern int MaxOrderPriceSlippage = 5; // Max price slippage (in pips)
extern int MaxTries = 5; // Max retries for opening orders
extern double MinPipChangeToTrade = 0.70000000; // Min pip change to trade (0 = every tick)
extern int MinPipGap = 80; // Min gap between trades per type (in pips)

//+------------------------------------------------------------------+
extern string   __EA_Order_Parameters__ = "-- Profit and loss parameters --"; // >>> PROFIT/LOSS <<<
extern double   TakeProfit = 140; // Take profit in pips (0 = none)
extern double   StopLoss = 160; // Stop loss in pips (0 = none)

//+------------------------------------------------------------------+
extern string __EA_Trailing_Parameters__ = "-- Profit and loss trailing parameters --"; // >>> TRAILINGS <<<
extern int TrailingStop = 40; // Trailing stop in pips
extern ENUM_TRAIL_TYPE DefaultTrailingStopMethod = 7; // Default trail stop method (0 = none)
extern bool TrailingStopOneWay = 0; // Trailing stop one way?
extern int TrailingProfit = 20; // Trailing profit in pips
extern ENUM_TRAIL_TYPE DefaultTrailingProfitMethod = 17; // Default trail profit method
extern bool TrailingProfitOneWay = 0; // Trailing profit one way?
extern double TrailingStopAddPerMinute = 0; // Decrease trail stop per minute (pip/min)

//+------------------------------------------------------------------+
extern string __EA_Risk_Parameters__ = "-- Risk management parameters --"; // >>> RISK <<
extern double RiskRatio = 0.00000000; // Risk ratio (0 = auto, 1.0 = normal)
extern bool TradeWithTrend = 0; // Trade with trend

//+------------------------------------------------------------------+
extern string __Strategy_Boosting_Parameters__ = "-- Strategy boosting parameters (set 1.0 for default) --"; // >>> BOOSTING <<<
extern bool Boosting_Enabled = 1; // Enable boosting
extern double BestDailyStrategyMultiplierFactor = 1.5; // Multiplier for the best daily strategy
extern double BestWeeklyStrategyMultiplierFactor = 1.00000000; // Multiplier for the best weekly strategy
extern double BestMonthlyStrategyMultiplierFactor = 1.00000000; // Multiplier for the best monthly strategy
extern double WorseDailyStrategyDividerFactor = 1.00000000; // Divider for the worse daily strategy
extern double WorseWeeklyStrategyDividerFactor = 1; // Divider for the worse weekly strategy
extern double WorseMonthlyStrategyDividerFactor = 1.00000000; // Divider for the worse monthly strategy
extern double BoostTrendFactor = 1.3; // Boost trend factor

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions__ = "-- Account conditions --"; // >>> CONDITIONS & ACTIONS <<<
// Note: It's not advice to use on accounts where multi bots are trading.
extern bool Account_Conditions_Active = TRUE; // Enable account conditions
extern ENUM_ACC_CONDITION Account_Condition_1      = 5; // 1. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_1    = 9; // 1. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_1      = 8; // 1. Action to take

extern ENUM_ACC_CONDITION Account_Condition_2      = 8; // 2. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_2    = 14; // 2. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_2      = 10; // 2. Action to take

extern ENUM_ACC_CONDITION Account_Condition_3      = 13; // 3. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_3    = 9; // 3. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_3      = 5; // 3. Action to take

extern ENUM_ACC_CONDITION Account_Condition_4      = 2; // 4. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_4    = 13; // 4. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_4      = 8; // 4. Action to take

extern ENUM_ACC_CONDITION Account_Condition_5      = 18; // 5. Account condition
extern ENUM_MARKET_CONDITION Market_Condition_5    = 7; // 5. Market condition
extern ENUM_ACTION_TYPE Action_On_Condition_5      = 10; // 5. Action to take

extern int Account_Condition_MinProfitCloseOrder = 20; // Min pip profit on action to close (and)

//+------------------------------------------------------------------+
extern string __EA_Account_Conditions_Params__ = "-- Account conditions parameters --"; // >>> CONDITIONS & ACTIONS PARAMS <<<
extern int MarketSuddenDropSize = 10; // Drop in pips to react
extern int MarketBigDropSize = 50; // Big drop in pips to react
extern int TrendMethodAction = 238; // Trend method for actions (0-255)
extern int MarketSpecificHour = 0; // Specific hour used for conditions (0-23)

//+------------------------------------------------------------------+
string __AC_Parameters__ = "-- Settings for the Bill Williams' Accelerator/Decelerator oscillator --"; // >>> AC (NOT IMPLEMENTED YET) <<<
bool AC1_Active = 0; // Enable for M1
bool AC5_Active = 0; // Enable on M5
bool AC15_Active = 0; // Enable on M15
bool AC30_Active = 0; // Enable on M30
ENUM_TRAIL_TYPE AC_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE AC_TrailingProfitMethod = 1; // Trail profit method
double AC_OpenLevel = 0.00000000; // Open level
int AC1_OpenMethod = 15; // Open method for M1 (0-?)
int AC5_OpenMethod = 15; // Open method for M5 (0-?)
int AC15_OpenMethod = 15; // Open method for M15 (0-?)
int AC30_OpenMethod = 15; // Open method for M30 (0-?)

//+------------------------------------------------------------------+
string __AD_Parameters__ = "-- Settings for the Accumulation/Distribution indicator --"; // >>> AD (NOT IMPLEMENTED YET) <<<
bool AD1_Active = 0; // Enable for M1
bool AD5_Active = 0; // Enable for M5
bool AD15_Active = 0; // Enable for M15
bool AD30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE AD_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE AD_TrailingProfitMethod = 1; // Trail profit method
double AD_OpenLevel = 0.00000000; // Open level
int AD1_OpenMethod = 15; // Open method for M1 (0-?)
int AD5_OpenMethod = 15; // Open method for M5 (0-?)
int AD15_OpenMethod = 15; // Open method for M15 (0-?)
int AD30_OpenMethod = 15; // Open method for M30 (0-?)

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
double ADX_OpenLevel = 0.00000000; // Open level
int ADX1_OpenMethod = 15; // Open method for M1 (0-?)
int ADX5_OpenMethod = 15; // Open method for M5 (0-?)
int ADX15_OpenMethod = 15; // Open method for M15 (0-?)
int ADX30_OpenMethod = 15; // Open method for M30 (0-?)

//+------------------------------------------------------------------+
extern string __Alligator_Parameters__ = "-- Settings for the Alligator indicator --"; // >>> ALLIGATOR <<<
extern bool Alligator1_Active = 1; // Enable for M1
extern bool Alligator5_Active = 1; // Enable for M5
extern bool Alligator15_Active = 1; // Enable for M15
extern bool Alligator30_Active = 1; // Enable for M30
extern int Alligator_Period_Jaw = 19; // Jaw Period
extern int Alligator_Jaw_Shift = 1; // Jaw Shift
extern int Alligator_Period_Teeth = 7; // Teeth Period
extern int Alligator_Teeth_Shift = 4; // Teeth Shift
extern int Alligator_Period_Lips = 7; // Lips Period
extern int Alligator_Lips_Shift = 1; // Lips Shift
extern ENUM_MA_METHOD Alligator_MA_Method = 3; // MA Method
extern ENUM_APPLIED_PRICE Alligator_Applied_Price = 4; // Applied Price
extern int Alligator_Shift = 1; // Shift
extern int Alligator_Shift_Far = 2; // Shift Far
extern ENUM_TRAIL_TYPE Alligator_TrailingStopMethod = 22; // Trail stop method
extern ENUM_TRAIL_TYPE Alligator_TrailingProfitMethod = 24; // Trail profit method
extern double Alligator_OpenLevel = 0.02; // Open level
extern int Alligator1_OpenMethod = 41; // Open method for M1 (0-63)
extern int Alligator5_OpenMethod = 2; // Open method for M5 (0-63)
extern int Alligator15_OpenMethod = 63; // Open method for M15 (0-63)
extern int Alligator30_OpenMethod = 1; // Open method for M30 (0-63)

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
double ATR_OpenLevel = 0.00000000; // Open level
int ATR1_OpenMethod = 31; // Open method for M1 (0-31)
int ATR5_OpenMethod = 31; // Open method for M5 (0-31)
int ATR15_OpenMethod = 31; // Open method for M15 (0-31)
int ATR30_OpenMethod = 31; // Open method for M30 (0-31)

//+------------------------------------------------------------------+
string __Awesome_Parameters__ = "-- Settings for the Awesome oscillator --"; // >>> AWESOME <<<
bool Awesome1_Active = 0; // Enable for M1
bool Awesome5_Active = 0; // Enable for M5
bool Awesome15_Active = 0; // Enable for M15
bool Awesome30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Awesome_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Awesome_TrailingProfitMethod = 1; // Trail profit method
double Awesome_OpenLevel = 0.00000000; // Open level
int Awesome1_OpenMethod = 31; // Open method for M1 (0-31)
int Awesome5_OpenMethod = 0; // Open method for M5 (0-31)
int Awesome15_OpenMethod = 31; // Open method for M15 (0-31)
int Awesome30_OpenMethod = 31; // Open method for M30 (0-31)

//+------------------------------------------------------------------+
extern string __Bands_Parameters__ = "-- Settings for the Bollinger Bands indicator --"; // >>> BANDS <<<
extern bool Bands1_Active = 0; // Enable for M1
extern bool Bands5_Active = 0; // Enable for M5
extern bool Bands15_Active = 0; // Enable for M15
extern bool Bands30_Active = 0; // Enable for M30
extern int Bands_Period = 26; // Period
extern ENUM_APPLIED_PRICE Bands_Applied_Price = 2; // Applied Price
extern double Bands_Deviation = 2.3; // Deviation
extern int Bands_Shift = 1; // Shift
/* @todo extern */ int Bands_Shift_Far = 4; // Shift Far
extern ENUM_TRAIL_TYPE Bands_TrailingStopMethod = 12; // Trail stop method
extern ENUM_TRAIL_TYPE Bands_TrailingProfitMethod = 22; // Trail profit method
/* @todo extern */ int Bands_OpenLevel = 0; // Open level
extern int Bands1_OpenMethod = 18; // Open method for M1 (0-255)
extern int Bands5_OpenMethod = 124; // Open method for M5 (0-255)
extern int Bands15_OpenMethod = 0; // Open method for M15 (0-255)
extern int Bands30_OpenMethod = 225; // Open method for M30 (0-255)

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
double BPower_OpenLevel = 0.00000000; // Open level
int BPower1_OpenMethod = 15; // Open method for M1 (0-
int BPower5_OpenMethod = 15; // Open method for M5 (0-
int BPower15_OpenMethod = 15; // Open method for M15 (0-
int BPower30_OpenMethod = 15; // Open method for M30 (0-

//+------------------------------------------------------------------+
string __Breakage_Parameters__ = "-- Settings for the custom Breakage strategy --"; // >>> BREAKAGE <<<
bool Breakage1_Active = 0; // Enable for M1
bool Breakage5_Active = 0; // Enable for M5
bool Breakage15_Active = 0; // Enable for M15
bool Breakage30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Breakage_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Breakage_TrailingProfitMethod = 1; // Trail profit method
double Breakage_OpenLevel = 0.00000000; // Open level
int Breakage1_OpenMethod = 0; // Open method for M1 (0-31)
int Breakage5_OpenMethod = 0; // Open method for M5 (0-31)
int Breakage15_OpenMethod = 0; // Open method for M15 (0-31)
int Breakage30_OpenMethod = 0; // Open method for M30 (0-31)

//+------------------------------------------------------------------+
string __BWMFI_Parameters__ = "-- Settings for the Market Facilitation Index indicator --"; // >>> BWMFI <<<
bool BWMFI1_Active = 0; // Enable for M1
bool BWMFI5_Active = 0; // Enable for M5
bool BWMFI15_Active = 0; // Enable for M15
bool BWMFI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE BWMFI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE BWMFI_TrailingProfitMethod = 1; // Trail profit method
double BWMFI_OpenLevel = 0.00000000; // Open level
int BWMFI1_OpenMethod = 0; // Open method for M1 (0-
int BWMFI5_OpenMethod = 0; // Open method for M5 (0-
int BWMFI15_OpenMethod = 0; // Open method for M15 (0-
int BWMFI30_OpenMethod = 0; // Open method for M30 (0-

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
double CCI_OpenLevel = 0.00000000; // Open level
int CCI1_OpenMethod = 0; // Open method for M1 (0-
int CCI5_OpenMethod = 0; // Open method for M5 (0-
int CCI15_OpenMethod = 0; // Open method for M15 (0-
int CCI30_OpenMethod = 0; // Open method for M30 (0-

//+------------------------------------------------------------------+
extern string __DeMarker_Parameters__ = "-- Settings for the DeMarker indicator --"; // >>> DEMARKER <<<
extern bool DeMarker1_Active = 1; // Enable for M1
extern bool DeMarker5_Active = 1; // Enable for M5
extern bool DeMarker15_Active = 1; // Enable for M15
extern bool DeMarker30_Active = 1; // Enable for M30
extern int DeMarker_Period = 24; // Period
extern int DeMarker_Shift = 0; // Shift
extern double DeMarker_OpenLevel = 0.2; // Open level (0.0-0.4)
extern ENUM_TRAIL_TYPE DeMarker_TrailingStopMethod = 1; // Trail stop method
extern ENUM_TRAIL_TYPE DeMarker_TrailingProfitMethod = 9; // Trail profit method
extern int DeMarker1_OpenMethod = 3; // Open method for M1 (0-
extern int DeMarker5_OpenMethod = 31; // Open method for M5 (0-
extern int DeMarker15_OpenMethod = 31; // Open method for M15 (0-
extern int DeMarker30_OpenMethod = 25; // Open method for M30 (0-

//+------------------------------------------------------------------+
extern string __Envelopes_Parameters__ = "-- Settings for the Envelopes indicator --"; // >>> ENVELOPES <<<
extern bool Envelopes1_Active = 1; // Enable for M1
extern bool Envelopes5_Active = 1; // Enable for M5
extern bool Envelopes15_Active = 1; // Enable for M15
extern bool Envelopes30_Active = 1; // Enable for M30
extern int Envelopes_MA_Period = 28; // Period
extern ENUM_MA_METHOD Envelopes_MA_Method = 3; // MA Method
extern int Envelopes_MA_Shift = 0; // MA Shift
extern ENUM_APPLIED_PRICE Envelopes_Applied_Price = 5; // Applied Price
extern double Envelopes1_Deviation = 0.20; // Deviation for M1
extern double Envelopes5_Deviation = 0.15; // Deviation for M5
extern double Envelopes15_Deviation = 0.15; // Deviation for M15
extern double Envelopes30_Deviation = 0.40000000; // Deviation for M30
extern int Envelopes_Shift = 2; // Shift
int Envelopes_Shift_Far = 0; // Shift Far
extern ENUM_TRAIL_TYPE Envelopes_TrailingStopMethod = 1; // Trail stop method
extern ENUM_TRAIL_TYPE Envelopes_TrailingProfitMethod = 14; // Trail profit method
/* @todo extern */ int Envelopes_OpenLevel = 0; // Open level
extern int Envelopes1_OpenMethod = 80; // Open method for M1 (0-127)
extern int Envelopes5_OpenMethod = 62; // Open method for M5 (0-127)
extern int Envelopes15_OpenMethod = 126; // Open method for M15 (0-127)
extern int Envelopes30_OpenMethod = 48; // Open method for M30 (0-127)

//+------------------------------------------------------------------+
string __Force_Parameters__ = "-- Settings for the Force Index indicator --"; // >>> FORCE <<<
bool Force1_Active = 0; // Enable for M1
bool Force5_Active = 0; // Enable for M5
bool Force15_Active = 0; // Enable for M15
bool Force30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Force_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Force_TrailingProfitMethod = 1; // Trail profit method
int Force_Period = 13; // Period
ENUM_MA_METHOD Force_MA_Method = 3; // MA Method
ENUM_APPLIED_PRICE Force_Applied_price = 0; // Applied Price
double Force_OpenLevel = 0.00000000; // Open level
int Force1_OpenMethod = 31; // Open method for M1 (0-
int Force5_OpenMethod = 31; // Open method for M5 (0-
int Force15_OpenMethod = 31; // Open method for M15 (0-
int Force30_OpenMethod = 31; // Open method for M30 (0-

//+------------------------------------------------------------------+
extern string __Fractals_Parameters__ = "-- Settings for the Fractals indicator --"; // >>> FRACTALS <<<
extern bool Fractals1_Active = 1; // Enable for M1
extern bool Fractals5_Active = 1; // Enable for M5
extern bool Fractals15_Active = 1; // Enable for M15
extern bool Fractals30_Active = 1; // Enable for M30
extern ENUM_TRAIL_TYPE Fractals_TrailingStopMethod = 1; // Trail stop method
extern ENUM_TRAIL_TYPE Fractals_TrailingProfitMethod = 1; // Trail profit method
/* @todo extern */ int Fractals_OpenLevel = 0; // Open level
extern int Fractals1_OpenMethod = 1; // Open method for M1 (0-1)
extern int Fractals5_OpenMethod = 1; // Open method for M5 (0-1)
extern int Fractals15_OpenMethod = 0; // Open method for M15 (0-1)
extern int Fractals30_OpenMethod = 1; // Open method for M30 (0-1)

//+------------------------------------------------------------------+
string __Gator_Parameters__ = "-- Settings for the Gator oscillator --"; // >>> GATOR <<<
bool Gator1_Active = 0; // Enable for M1
bool Gator5_Active = 0; // Enable for M5
bool Gator15_Active = 0; // Enable for M15
bool Gator30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Gator_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Gator_TrailingProfitMethod = 1; // Trail profit method
double Gator_OpenLevel = 0.00000000; // Open level
int Gator1_OpenMethod = 0; // Open method for M1 (0-
int Gator5_OpenMethod = 0; // Open method for M5 (0-
int Gator15_OpenMethod = 0; // Open method for M15 (0-
int Gator30_OpenMethod = 0; // Open method for M30 (0-

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
double Ichimoku_OpenLevel = 0.00000000; // Open level
int Ichimoku1_OpenMethod = 0; // Open method for M1 (0-
int Ichimoku5_OpenMethod = 0; // Open method for M5 (0-
int Ichimoku15_OpenMethod = 0; // Open method for M15 (0-
int Ichimoku30_OpenMethod = 0; // Open method for M30 (0-

//+------------------------------------------------------------------+
extern string __MA_Parameters__ = "-- Settings for the Moving Average indicator --"; // >>> MA <<<
extern bool MA1_Active = 1; // Enable for M1
extern bool MA5_Active = 1; // Enable for M5
extern bool MA15_Active = 1; // Enable for M15
extern bool MA30_Active = 1; // Enable for M30
extern int MA_Period_Fast = 10; // Period Fast
extern int MA_Period_Medium = 18; // Period Medium
extern int MA_Period_Slow = 42; // Period Slow
extern int MA_Shift = 0; // Shift
extern int MA_Shift_Fast = 0; // Shift Fast (+1)
extern int MA_Shift_Medium = 2; // Shift Medium (+1)
extern int MA_Shift_Slow = 5; // Shift Slow (+1)
extern int MA_Shift_Far = 1; // Shift Far (+2)
extern ENUM_MA_METHOD MA_Method = 3; // MA Method
extern ENUM_APPLIED_PRICE MA_Applied_Price = 0; // Applied Price
extern ENUM_TRAIL_TYPE MA_TrailingStopMethod = 13; // Trail stop method
extern ENUM_TRAIL_TYPE MA_TrailingProfitMethod = 1; // Trail profit method
extern double MA_OpenLevel = 1.2; // Open level
extern int MA1_OpenMethod = 40; // Open method for M1 (0-127)
extern int MA5_OpenMethod = 97; // Open method for M5 (0-127)
extern int MA15_OpenMethod = 7; // Open method for M15 (0-127)
extern int MA30_OpenMethod = 48; // Open method for M30 (0-127)

//+------------------------------------------------------------------+
extern string __MACD_Parameters__ = "-- Settings for the Moving Averages Convergence/Divergence indicator --"; // >>> MACD <<<
extern bool MACD1_Active = 1; // Enable for M1
extern bool MACD5_Active = 1; // Enable for M5
extern bool MACD15_Active = 1; // Enable for M15
extern bool MACD30_Active = 0; // Enable for M30
extern int MACD_Period_Fast = 14; // Period Fast
extern int MACD_Period_Slow = 35; // Period Slow
extern int MACD_Period_Signal = 10; // Period for signal
extern ENUM_APPLIED_PRICE MACD_Applied_Price = 6; // Applied Price
extern int MACD_Shift = 2; // Shift
extern int MACD_Shift_Far = 0; // Shift Far
extern ENUM_TRAIL_TYPE MACD_TrailingStopMethod = 21; // Trail stop method
extern ENUM_TRAIL_TYPE MACD_TrailingProfitMethod = 27; // Trail profit method
extern double MACD_OpenLevel = 0.3; // Open level
extern int MACD1_OpenMethod = 0; // Open method for M1 (0-31)
extern int MACD5_OpenMethod = 28; // Open method for M5 (0-31)
extern int MACD15_OpenMethod = 18; // Open method for M15 (0-31)
extern int MACD30_OpenMethod = 4; // Open method for M30 (0-31)

//+------------------------------------------------------------------+
string __MFI_Parameters__ = "-- Settings for the Money Flow Index indicator --"; // >>> MFI <<<
bool MFI1_Active = 0; // Enable for M1
bool MFI5_Active = 0; // Enable for M5
bool MFI15_Active = 0; // Enable for M15
bool MFI30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE MFI_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE MFI_TrailingProfitMethod = 1; // Trail profit method
int MFI_Period = 14; // Period
double MFI_OpenLevel = 0.00000000; // Open level
int MFI1_OpenMethod = 0; // Open method for M1 (0-
int MFI5_OpenMethod = 0; // Open method for M5 (0-
int MFI15_OpenMethod = 0; // Open method for M15 (0-
int MFI30_OpenMethod = 0; // Open method for M30 (0-

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
double Momentum_OpenLevel = 0.00000000; // Open level
int Momentum1_OpenMethod = 15; // Open method for M1 (0-
int Momentum5_OpenMethod = 15; // Open method for M5 (0-
int Momentum15_OpenMethod = 15; // Open method for M15 (0-
int Momentum30_OpenMethod = 15; // Open method for M30 (0-

//+------------------------------------------------------------------+
string __OBV_Parameters__ = "-- Settings for the On Balance Volume indicator --"; // >>> OBV <<<
bool OBV1_Active = 0; // Enable for M1
bool OBV5_Active = 0; // Enable for M5
bool OBV15_Active = 0; // Enable for M15
bool OBV30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE OBV_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE OBV_TrailingProfitMethod = 1; // Trail profit method
ENUM_APPLIED_PRICE OBV_Applied_Price = 0; // Applied Price
double OBV_OpenLevel = 0.00000000; // Open level
int OBV1_OpenMethod = 0; // Open method for M1 (0-
int OBV5_OpenMethod = 0; // Open method for M5 (0-
int OBV15_OpenMethod = 0; // Open method for M15 (0-
int OBV30_OpenMethod = 0; // Open method for M30 (0-

//+------------------------------------------------------------------+
string __OSMA_Parameters__ = "-- Settings for the Moving Average of Oscillator indicator --"; // >>> OSMA <<<
bool OSMA1_Active = 0; // Enable for M1
bool OSMA5_Active = 0; // Enable for M5
bool OSMA15_Active = 0; // Enable for M15
bool OSMA30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE OSMA_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE OSMA_TrailingProfitMethod = 1; // Trail profit method
int OSMA_Period_Fast = 12; // Period Fast
int OSMA_Period_Slow = 26; // Period Slow
int OSMA_Period_Signal = 9; // Period for signal
ENUM_APPLIED_PRICE OSMA_Applied_Price = 1; // Applied Price
double OSMA_OpenLevel = 0.00000000; // Open level
int OSMA1_OpenMethod = 0; // Open method for M1 (0-
int OSMA5_OpenMethod = 0; // Open method for M5 (0-
int OSMA15_OpenMethod = 0; // Open method for M15 (0-
int OSMA30_OpenMethod = 0; // Open method for M30 (0-

//+------------------------------------------------------------------+
extern string __RSI_Parameters__ = "-- Settings for the Relative Strength Index indicator --"; // >>> RSI <<<
extern bool RSI1_Active = 1; // Enable for M1
extern bool RSI5_Active = 1; // Enable for M5
extern bool RSI15_Active = 1; // Enable for M15
extern bool RSI30_Active = 0; // Enable for M30
extern int RSI_Period = 19; // Period
extern ENUM_APPLIED_PRICE RSI_Applied_Price = 2; // Applied Price
extern int RSI_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE RSI_TrailingStopMethod = 17; // Trail stop method
extern ENUM_TRAIL_TYPE RSI_TrailingProfitMethod = 20; // Trail profit method
extern int RSI_OpenLevel = 20; // Open level
extern int RSI1_OpenMethod = 50; // Open method for M1 (0-63)
extern int RSI5_OpenMethod = 33; // Open method for M5 (0-63)
extern int RSI15_OpenMethod = 6; // Open method for M15 (0-63)
extern int RSI30_OpenMethod = 2; // Open method for M30 (0-63)

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
double RVI_OpenLevel = 0.00000000; // Open level
int RVI1_OpenMethod = 0; // Open method for M1 (0-
int RVI5_OpenMethod = 0; // Open method for M5 (0-
int RVI15_OpenMethod = 0; // Open method for M15 (0-
int RVI30_OpenMethod = 0; // Open method for M30 (0-

//+------------------------------------------------------------------+
extern string __SAR_Parameters__ = "-- Settings for the the Parabolic Stop and Reverse system indicator --"; // >>> SAR <<<
extern bool SAR1_Active = 1; // Enable for M1
extern bool SAR5_Active = 1; // Enable for M5
extern bool SAR15_Active = 1; // Enable for M15
extern bool SAR30_Active = 1; // Enable for M30
extern double SAR_Step = 0.01; // Step
extern double SAR_Maximum_Stop = 0.30000000; // Maximum stop
extern int SAR_Shift = 0; // Shift
extern ENUM_TRAIL_TYPE SAR_TrailingStopMethod = 12; // Trail stop method
extern ENUM_TRAIL_TYPE SAR_TrailingProfitMethod = 18; // Trail profit method
extern double SAR_OpenLevel = 0.2; // Open level
extern int SAR1_OpenMethod = 127; // Open method for M1 (0-127)
extern int SAR5_OpenMethod = 86; // Open method for M5 (0-127)
extern int SAR15_OpenMethod = 16; // Open method for M15 (0-127)
extern int SAR30_OpenMethod = 20; // Open method for M30 (0-127)

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
ENUM_MA_METHOD StdDev_MA_Method = 1; // MA Method
int StdDev_MA_Shift = 0; // Shift
double StdDev_OpenLevel = 0.00000000; // Open level
int StdDev1_OpenMethod = 31; // Open method for M1 (0-
int StdDev5_OpenMethod = 31; // Open method for M5 (0-
int StdDev15_OpenMethod = 31; // Open method for M15 (0-
int StdDev30_OpenMethod = 31; // Open method for M30 (0-

//+------------------------------------------------------------------+
string __Stochastic_Parameters__ = "-- Settings for the the Stochastic Oscillator --"; // >>> STOCHASTIC <<<
bool Stochastic1_Active = 0; // Enable for M1
bool Stochastic5_Active = 0; // Enable for M5
bool Stochastic15_Active = 0; // Enable for M15
bool Stochastic30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE Stochastic_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE Stochastic_TrailingProfitMethod = 1; // Trail profit method
double Stochastic_OpenLevel = 0.00000000; // Open level
int Stochastic1_OpenMethod = 0; // Open method for M1 (0-
int Stochastic5_OpenMethod = 0; // Open method for M5 (0-
int Stochastic15_OpenMethod = 0; // Open method for M15 (0-
int Stochastic30_OpenMethod = 0; // Open method for M30 (0-

//+------------------------------------------------------------------+
extern string __WPR_Parameters__ = "-- Settings for the Larry Williams' Percent Range indicator --"; // >>> WPR <<<
extern bool WPR1_Active = 0; // Enable for M1
extern bool WPR5_Active = 1; // Enable for M5
extern bool WPR15_Active = 1; // Enable for M15
extern bool WPR30_Active = 1; // Enable for M30
extern int WPR_Period = 14; // Period
extern int WPR_Shift = 0; // Shift
extern int WPR_OpenLevel = 20; // Open level
extern ENUM_TRAIL_TYPE WPR_TrailingStopMethod = 7; // Trail stop method
extern ENUM_TRAIL_TYPE WPR_TrailingProfitMethod = 10; // Trail profit method
extern int WPR1_OpenMethod = 0; // Open method for M1 (0-63)
extern int WPR5_OpenMethod = 0; // Open method for M5 (0-63)
extern int WPR15_OpenMethod = 0; // Open method for M15 (0-63)
extern int WPR30_OpenMethod = 0; // Open method for M30 (0-63)

//+------------------------------------------------------------------+
string __ZigZag_Parameters__ = "-- Settings for the ZigZag indicator --"; // >>> ZIGZAG <<<
bool ZigZag1_Active = 0; // Enable for M1
bool ZigZag5_Active = 0; // Enable for M5
bool ZigZag15_Active = 0; // Enable for M15
bool ZigZag30_Active = 0; // Enable for M30
ENUM_TRAIL_TYPE ZigZag_TrailingStopMethod = 22; // Trail stop method
ENUM_TRAIL_TYPE ZigZag_TrailingProfitMethod = 1; // Trail profit method
double ZigZag_OpenLevel = 0.00000000; // Open level
int ZigZag1_OpenMethod = 0; // Open method for M1 (0-31)
int ZigZag5_OpenMethod = 0; // Open method for M5 (0-31)
int ZigZag15_OpenMethod = 0; // Open method for M15 (0-31)
int ZigZag30_OpenMethod = 0; // Open method for M30 (0-31)

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
extern bool WriteReport = 1; // Write file report on exit.
extern bool PrintLogOnChart = 1; // Display info on chart
extern bool VerboseErrors = 1; // Display errors.
extern bool VerboseInfo = 1; // Display info messages.
bool VerboseDebug = 1; // Display debug messages.
bool VerboseTrace = 0; // Display trace messages

//+------------------------------------------------------------------+
extern string __UI_UX_Parameters__ = "-- Settings for User Interface & Experience --"; // >>> UI & UX <<<
extern bool SendEmailEachOrder = 0; // Send e-mail per each order
extern color ColorBuy = 16711680; // Color: Buy
extern color ColorSell = 255; // Color: Sell
extern bool SoundAlert = 0; // Enable sound alerts
extern string SoundFileAtOpen = "alert.wav"; // Sound: on order open
extern string SoundFileAtClose = "alert.wav"; // Sound: on order close
// extern bool SendLogs = FALSE; // Send logs to remote host for diagnostic purposes.

//+------------------------------------------------------------------+
extern string __Backtest_Parameters__ = "-- Backtest parameters --"; // >>> BACKTESTING <<<
extern bool ValidateSettings = TRUE; // Validate startup settings
extern int DemoMarketStopLevel = 10; // Demo market stop level

//+------------------------------------------------------------------+
extern string __Constants__ = "-- Constants --"; // >>> CONSTANTS <<<
extern int MagicNumber = 31337; // Unique magic number (+40)

//+------------------------------------------------------------------+
extern string __Other_Parameters__ = "-- Other parameters --"; // >>> OTHER <<<
