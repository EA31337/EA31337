//+------------------------------------------------------------------+
//|                                                   MQL4Common.mqh |
//| Provides common MQL4 back-compability for MQL5.                  |
//+------------------------------------------------------------------+

#property copyright "kenorb"
#property link      "https://github.com/EA31337"
#property strict
//---

//+------------------------------------------------------------------+
//| Chart Periods
//+------------------------------------------------------------------+

/*
 * Function to convert MQL4 time periods.
 * As in MQL5 chart period constants changed, and some new time periods (M2, M3, M4, M6, M10, M12, H2, H3, H6, H8, H12) were added.
 *
 * It should be noted, that in MQL5 the numerical values of chart timeframe constants (from H1) are not equal to the number of minutes of a bar
 * (for example, in MQL5, the numerical value of constant  PERIOD_H1=16385, but in MQL4 PERIOD_H1=60).
 * You should take it into account when converting to MQL5, if numerical values of MQL4 constants are used in MQL4 programs.
 * To determine the number of minutes of the specified time period of the chart, divide the value, returned by function PeriodSeconds by 60.
 *
 * See: https://www.mql5.com/en/articles/81
 */
ENUM_TIMEFRAMES TFMigrate(int tf) {
  switch(tf) {
    case 0: return(PERIOD_CURRENT);
    case 1: return(PERIOD_M1);
    case 5: return(PERIOD_M5);
    case 15: return(PERIOD_M15);
    case 30: return(PERIOD_M30);
    case 60: return(PERIOD_H1);
    case 240: return(PERIOD_H4);
    case 1440: return(PERIOD_D1);
    case 10080: return(PERIOD_W1);
    case 43200: return(PERIOD_MN1);
    case 2: return(PERIOD_M2);
    case 3: return(PERIOD_M3);
    case 4: return(PERIOD_M4);      
    case 6: return(PERIOD_M6);
    case 10: return(PERIOD_M10);
    case 12: return(PERIOD_M12);
    case 16385: return(PERIOD_H1);
    case 16386: return(PERIOD_H2);
    case 16387: return(PERIOD_H3);
    case 16388: return(PERIOD_H4);
    case 16390: return(PERIOD_H6);
    case 16392: return(PERIOD_H8);
    case 16396: return(PERIOD_H12);
    case 16408: return(PERIOD_D1);
    case 32769: return(PERIOD_W1);
    case 49153: return(PERIOD_MN1);      
    default: return(PERIOD_CURRENT);
  }
}

//+------------------------------------------------------------------+
//| Technical Indicators
//+------------------------------------------------------------------+

double CopyBufferMQL4 (int handle, int index, int shift) {
  double buf[];
  switch (index) {
    case 0: if (CopyBuffer(handle, 0,shift, 1, buf) > 0) return (buf[0]); break;
    case 1: if (CopyBuffer(handle, 1,shift, 1, buf) > 0) return (buf[0]); break;
    case 2: if (CopyBuffer(handle, 2,shift, 1, buf) > 0) return (buf[0]); break;
    case 3: if (CopyBuffer(handle, 3,shift, 1, buf) > 0) return (buf[0]); break;
    case 4: if (CopyBuffer(handle, 4,shift, 1, buf) > 0) return (buf[0]); break;
    default: break;
  }
  return(EMPTY_VALUE);
}

ENUM_MA_METHOD MethodMigrate (int method) {
  switch(method) {
    case 0: return(MODE_SMA);
    case 1: return(MODE_EMA);
    case 2: return(MODE_SMMA);
    case 3: return(MODE_LWMA);
    default: return(MODE_SMA);
  }
}

ENUM_APPLIED_PRICE PriceMigrate (int price) {
  switch (price) {
    case  1: return (PRICE_CLOSE);
    case  2: return (PRICE_OPEN);
    case  3: return (PRICE_HIGH);
    case  4: return (PRICE_LOW);
    case  5: return (PRICE_MEDIAN);
    case  6: return (PRICE_TYPICAL);
    case  7: return (PRICE_WEIGHTED);
    default: return (PRICE_CLOSE);
  }
}

ENUM_STO_PRICE StoFieldMigrate (int field) {
  switch (field) {
    case  0: return (STO_LOWHIGH);
    case  1: return (STO_CLOSECLOSE);
    default: return (STO_LOWHIGH);
  }
}

//+------------------------------------------------------------------+
enum ALLIGATOR_MODE  { MODE_GATORJAW=1,   MODE_GATORTEETH, MODE_GATORLIPS };
//enum ADX_MODE        { MODE_MAIN,         MODE_PLUSDI, MODE_MINUSDI };
enum UP_LOW_MODE     { MODE_BASE,         MODE_UPPER,      MODE_LOWER };
enum ICHIMOKU_MODE   { MODE_TENKANSEN=1,  MODE_KIJUNSEN, MODE_SENKOUSPANA, MODE_SENKOUSPANB, MODE_CHIKOUSPAN };
enum MAIN_SIGNAL_MODE{ MODE_MAIN,         MODE_SIGNAL };

//+------------------------------------------------------------------+
//| MQL4 functions
//+------------------------------------------------------------------+

double MarketInfoMQL4(string symbol,
                      int type) {
  switch(type) {
    case MODE_LOW:
       return(SymbolInfoDouble(symbol,SYMBOL_LASTLOW));
    case MODE_HIGH:
       return(SymbolInfoDouble(symbol,SYMBOL_LASTHIGH));
    case MODE_TIME:
       return double(SymbolInfoInteger(symbol,SYMBOL_TIME));
    case MODE_BID:
       //return(Bid);
    case MODE_ASK:
       //return(Ask);
    case MODE_POINT:
       return(SymbolInfoDouble(symbol,SYMBOL_POINT));
    case MODE_DIGITS:
       return double(SymbolInfoInteger(symbol,SYMBOL_DIGITS));
    case MODE_SPREAD:
       return double(SymbolInfoInteger(symbol,SYMBOL_SPREAD));
    case MODE_STOPLEVEL:
       return double(SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL));
    case MODE_LOTSIZE:
       return(SymbolInfoDouble(symbol,SYMBOL_TRADE_CONTRACT_SIZE));
    case MODE_TICKVALUE:
       return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_VALUE));
    case MODE_TICKSIZE:
       return(SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE));
    case MODE_SWAPLONG:
       return(SymbolInfoDouble(symbol,SYMBOL_SWAP_LONG));
    case MODE_SWAPSHORT:
       return(SymbolInfoDouble(symbol,SYMBOL_SWAP_SHORT));
    case MODE_STARTING:
       return(0);
    case MODE_EXPIRATION:
       return(0);
    case MODE_TRADEALLOWED:
       return(0);
    case MODE_MINLOT:
       return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN));
    case MODE_LOTSTEP:
       return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP));
    case MODE_MAXLOT:
       return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX));
    case MODE_SWAPTYPE:
       return double(SymbolInfoInteger(symbol,SYMBOL_SWAP_MODE));
    case MODE_PROFITCALCMODE:
       return double(SymbolInfoInteger(symbol,SYMBOL_TRADE_CALC_MODE));
    case MODE_MARGINCALCMODE:
       return(0);
    case MODE_MARGININIT:
       return(0);
    case MODE_MARGINMAINTENANCE:
       return(0);
    case MODE_MARGINHEDGED:
       return(0);
    case MODE_MARGINREQUIRED:
       return(0);
    case MODE_FREEZELEVEL:
       return double(SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL));
  
    default: return(0);
   }
  return(0);
}


double AccountBalance() {
  return AccountInfoDouble(ACCOUNT_BALANCE);
}
double AccountCredit() {
  return AccountInfoDouble(ACCOUNT_CREDIT);
}

/*
 * Returns the brokerage company name where the current account was registered.
 */
string GetAccountCompany() {
  return AccountInfoString(ACCOUNT_COMPANY);
}

string AccountCurrency() {
  return AccountInfoString(ACCOUNT_CURRENCY);
}

double AccountEquity() {
  return AccountInfoDouble(ACCOUNT_EQUITY);
}

double AccountFreeMargin() {
  return AccountInfoDouble(ACCOUNT_FREEMARGIN);
}

/*
 * Returns the brokerage company name where the current account was registered.
 */
int AccountLeverage() {
  return (int)AccountInfoInteger(ACCOUNT_LEVERAGE);
}

string AccountCompany() {
  return AccountInfoString(ACCOUNT_COMPANY);
}

double AccountMargin() {
  return AccountInfoDouble(ACCOUNT_MARGIN);
}

string AccountName() {
  return AccountInfoString(ACCOUNT_NAME);
}

int AccountNumber() {
  return (int)AccountInfoInteger(ACCOUNT_LOGIN);
}

double AccountProfit() {
  return AccountInfoDouble(ACCOUNT_PROFIT);
}

string AccountServer() {
  return AccountInfoString(ACCOUNT_SERVER);
}
double AccountStopoutLevel() {
  return AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
}
int AccountStopoutMode() {
  return (int)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
}

bool IsDemo() {
  ENUM_ACCOUNT_TRADE_MODE tradeMode = (ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
  if(tradeMode == ACCOUNT_TRADE_MODE_DEMO) return (true);
  // tradeMode is ACCOUNT_TRADE_MODE_CONTEST or ACCOUNT_TRADE_MODE_REAL
  return(false);
}

bool IsDllsAllowed() {
  return (bool)MQL5InfoInteger(MQL5_DLLS_ALLOWED);
}

bool IsLibrariesAllowed() {
  return (bool)MQL5InfoInteger(MQL5_DLLS_ALLOWED);
}

bool IsOptimization() {
  return (bool)MQL5InfoInteger(MQL5_OPTIMIZATION);
}

bool IsTesting() {
  return (bool)MQL5InfoInteger(MQL5_TESTING);
}

bool IsTradeAllowed() {
  return (bool)MQL5InfoInteger(MQL5_TRADE_ALLOWED) && (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);
}

bool IsExpertEnabled() {
  return(bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
}

bool IsTradeContextBusy() {
  return (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED); // ?
}

bool IsVisualMode() {
  return (bool)MQL5InfoInteger(MQL5_VISUAL_MODE);
}

string TerminalCompany() {
  return TerminalInfoString(TERMINAL_COMPANY);
}

string TerminalName() {
  return TerminalInfoString(TERMINAL_NAME);
}

string TerminalPath() {
  // TerminalInfoString(TERMINAL_DATA_PATH)
  // TerminalInfoString(TERMINAL_COMMONDATA_PATH)
  return TerminalInfoString(TERMINAL_PATH);
}

int Day() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.day;
}

int DayOfWeek() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.day_of_week;
}

int DayOfYear() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.day_of_year;
}

int Month() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.mon;
}

int Year() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.year;
}

int Hour() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.hour;
}

int Minute() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.min;
}

int Seconds() {
  MqlDateTime tm;
  TimeCurrent(tm);
  return tm.sec;
}

datetime TimeDay(datetime date) {
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.day;
}

datetime TimeDayOfWeek(datetime date) {
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.day_of_week;
}

datetime TimeDayOfYear(datetime date) {
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.day_of_year;
}

datetime TimeMonth(datetime date) {
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.mon;
}

datetime TimeYear(datetime date)	{
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.year;
}

datetime TimeHour(datetime date) {
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.hour;
}

datetime TimeMinute(datetime date) {
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.min;
}

datetime TimeSeconds(datetime date) {
  MqlDateTime tm;
  TimeToStruct(date,tm);
  return tm.sec;
}

void WindowRedraw() {
  ChartRedraw();
}

datetime iTime(string symbol,int tf,int index) {
   if(index < 0) return(-1);
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   datetime Arr[];
   if(CopyTime(symbol, timeframe, index, 1, Arr)>0)
        return(Arr[0]);
   else return(-1);
}

string TimeToStr(datetime value, int mode=TIME_DATE|TIME_MINUTES) {
  return TimeToString(value, mode);
}

int BarsMQ5() {
  return Bars(_Symbol,_Period);
  #ifdef __MQL5__
   #define Bars BarsMQ5()
  #endif
}

double iMA(string symbol,
               int tf,
               int period,
               int ma_shift,
               int method,
               int price,
               int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iMA(symbol,timeframe,period,ma_shift,
                  ma_method,applied_price);
   if(handle<0)
     {
      Print("The iMA object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }

  double iBands(string symbol,
                  int tf,
                  int period,
                  double deviation,
                  int bands_shift,
                  int method,
                  int mode,
                  int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   int handle=iBands(symbol,timeframe,period,
                     bands_shift,deviation,ma_method);
   if(handle<0)
     {
      Print("The iBands object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }

  double iDeMarker(string symbol,
                     int tf,
                     int period,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iDeMarker(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iDeMarker object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }

  double iEnvelopes(string symbol,
                     int tf,
                     int ma_period,
                     int method,
                     int ma_shift,
                     int price,
                     double deviation,
                     int mode,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iEnvelopes(symbol,timeframe,
                         ma_period,ma_shift,ma_method,
                         applied_price,deviation);
   if(handle<0)
     {
      Print("The iEnvelopes object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }

  double iFractals(string symbol,
                     int tf,
                     int mode,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iFractals(symbol,timeframe);
   if(handle<0)
     {
      Print("The iFractals object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }

  double iGator(string symbol,
                  int tf,
                  int jaw_period,
                  int jaw_shift,
                  int teeth_period,
                  int teeth_shift,
                  int lips_period,
                  int lips_shift,
                  int method,
                  int price,
                  int mode,
                  int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_MA_METHOD ma_method=MethodMigrate(method);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iGator(symbol,timeframe,jaw_period,jaw_shift,
                     teeth_period,teeth_shift,
                     lips_period,lips_shift,
                     ma_method,applied_price);
   if(handle<0)
     {
      Print("The iGator object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }

  double iIchimoku(string symbol,
                     int tf,
                     int tenkan_sen,
                     int kijun_sen,
                     int senkou_span_b,
                     int mode,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iIchimoku(symbol,timeframe,
                        tenkan_sen,kijun_sen,senkou_span_b);
   if(handle<0)
     {
      Print("The iIchimoku object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode-1,shift));
  }

  double iMACD(string symbol,
                 int tf,
                 int fast_ema_period,
                 int slow_ema_period,
                 int signal_period,
                 int price,
                 int mode,
                 int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iMACD(symbol,timeframe,
                    fast_ema_period,slow_ema_period,
                    signal_period,applied_price);
   if(handle<0)
     {
      Print("The iMACD object is not created: Error ",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }

  double iMomentumMQL4(string symbol,
                     int tf,
                     int period,
                     int price,
                     int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iMomentum(symbol,timeframe,period,applied_price);
   if(handle<0)
     {
      Print("The iMomentum object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }

  #define iMomentum iMomentumMQL4


  double iOBV(string symbol,
                int tf,
                int price,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iOBV(symbol,timeframe,VOLUME_TICK);
   if(handle<0)
     {
      Print("The iOBV object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }

  double iOsMA(string symbol,
                 int tf,
                 int fast_ema_period,
                 int slow_ema_period,
                 int signal_period,
                 int price,
                 int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iOsMA(symbol,timeframe,
                    fast_ema_period,slow_ema_period,
                    signal_period,applied_price);
   if(handle<0)
     {
      Print("The iOsMA object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }


double iRSI(string symbol,
                int tf,
                int period,
                int price,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   ENUM_APPLIED_PRICE applied_price=PriceMigrate(price);
   int handle=iRSI(symbol,timeframe,period,applied_price);
   if(handle<0)
     {
      Print("The iRSI object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }


double iRVI(string symbol,
                int tf,
                int period,
                int mode,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iRVI(symbol,timeframe,period);
   if(handle<0)
     {
      Print("The iRVI object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,mode,shift));
  }

  double iSAR(string symbol,
                int tf,
                double step,
                double maximum,
                int shift)
  {
   ENUM_TIMEFRAMES timeframe=TFMigrate(tf);
   int handle=iSAR(symbol,timeframe,step,maximum);
   if(handle<0)
     {
      Print("The iSAR object is not created: Error",GetLastError());
      return(-1);
     }
   else
      return(CopyBufferMQL4(handle,0,shift));
  }






