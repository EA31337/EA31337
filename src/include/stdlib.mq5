/*
  Definition of constants and functions which exists in MQL4's standard library and are missing in MQL5 (backporting).
*/

#ifdef __MQL5__

// Some of standard MQL4 constants are absent in MQL5, therefore they should be declared as below.
#define OP_BUY 0           // Buy 
#define OP_SELL 1          // Sell 
#define OP_BUYLIMIT 2      // Pending order of BUY LIMIT type 
#define OP_SELLLIMIT 3     // Pending order of SELL LIMIT type 
#define OP_BUYSTOP 4       // Pending order of BUY STOP type 
#define OP_SELLSTOP 5      // Pending order of SELL STOP type 

#define MODE_OPEN 0
#define MODE_CLOSE 3
#define MODE_VOLUME 4 
#define MODE_REAL_VOLUME 5
#define MODE_TRADES 0
#define MODE_HISTORY 1
#define SELECT_BY_POS 0
#define SELECT_BY_TICKET 1

#define DOUBLE_VALUE 0
#define FLOAT_VALUE 1
#define LONG_VALUE INT_VALUE

#define CHART_BAR 0
#define CHART_CANDLE 1

#define MODE_ASCEND 0
#define MODE_DESCEND 1

#define MODE_LOW 1
#define MODE_HIGH 2
#define MODE_TIME 5
#define MODE_BID 9
#define MODE_ASK 10
#define MODE_POINT 11
#define MODE_DIGITS 12
#define MODE_SPREAD 13
#define MODE_STOPLEVEL 14
#define MODE_LOTSIZE 15
#define MODE_TICKVALUE 16
#define MODE_TICKSIZE 17
#define MODE_SWAPLONG 18
#define MODE_SWAPSHORT 19
#define MODE_STARTING 20
#define MODE_EXPIRATION 21
#define MODE_TRADEALLOWED 22
#define MODE_MINLOT 23
#define MODE_LOTSTEP 24
#define MODE_MAXLOT 25
#define MODE_SWAPTYPE 26
#define MODE_PROFITCALCMODE 27
#define MODE_MARGINCALCMODE 28
#define MODE_MARGININIT 29
#define MODE_MARGINMAINTENANCE 30
#define MODE_MARGINHEDGED 31
#define MODE_MARGINREQUIRED 32
#define MODE_FREEZELEVEL 33

/*
  Returns text string with the specified numerical value converted into a specified precision format.

  @see http://docs.mql4.com/convert/doubletostr
*/
string  DoubleToStrMQL4 (
   double  value,     // value
   int     digits     // precision
   )
{
  return DoubleToString (value, digits);

  // Overriding DoubleToStr function.
  #define DoubleToStr DoubleToStrMQL4
}

/*
  The function selects an order for further processing.

  @see http://docs.mql4.com/trading/orderselect
*/
bool  OrderSelectMQL4 (
   int     index,            // index or order ticket
   int     select,           // flag
   int     pool=MODE_TRADES  // mode
   )
{
  return OrderSelect (index);

  // Overriding OrderSelect function.
  #define OrderSelect OrderSelectMQL4
}

/*
  Returns the string copy with changed character in the specified position.

  @see https://www.mql5.com/en/articles/81
*/
string StringSetChar (string text, int pos, int value)
{
  string copy = text;

  StringSetCharacter (copy, pos, (ushort)value);

  return copy;
}

/*
  Prints information about the selected order in the log.

  @see http://docs.mql4.com/trading/orderprint
*/
void OrderPrint ()
{
  // @todo: Create implementation.
}

/*
  Returns open price of the currently selected order.

  @see http://docs.mql4.com/trading/orderopenprice
*/
double OrderOpenPrice ()
{
   return OrderGetDouble (ORDER_PRICE_OPEN);
}

/*
  Returns ticket number of the currently selected order.

  @see https://www.mql5.com/en/docs/trading/ordergetticket
*/
int OrderTicket ()
{
  // @todo: Create implementation.
  return 0;
}

/*
  Returns amount of lots of the selected order.

  @see http://docs.mql4.com/trading/orderlots
*/
double OrderLots ()
{
  // @todo: Check if this is what we want.
  return OrderGetDouble (ORDER_VOLUME_CURRENT); // Order current volume.
}

/*
  Closes opened order.

  @see http://docs.mql4.com/trading/orderclose
*/
bool  OrderClose (
   int        ticket,      // ticket
   double     lots,        // volume
   double     price,       // close price
   int        slippage,    // slippage
   color      arrow_color  // color
   )
{
  // @todo: Create implementation.
  return FALSE;
}

/*
  Returns close time of the currently selected order.

  @see http://docs.mql4.com/trading/orderclosetime
*/
datetime OrderCloseTime ()
{
  // @todo: Create implementation.
  return datetime (0);
}

/*
  The main function used to open market or place a pending order.

  @see http://docs.mql4.com/trading/ordersend
*/
int OrderSend (
   string   symbol,              // symbol
   int      cmd,                 // operation
   double   volume,              // volume
   double   price,               // price
   double   slippage,            // slippage
   double   stoploss,            // stop loss
   double   takeprofit,          // take profit
   string   comment=NULL,        // comment
   int      magic=0,             // magic number
   datetime expiration=0,        // pending order expiration
   color    arrow_color=clrNONE  // color
   )
{
   // Structure: https://www.mql5.com/en/docs/constants/structures/mqltraderequest
   MqlTradeRequest request;
   
   // Structure: https://www.mql5.com/en/docs/constants/structures/mqltraderesult
   MqlTradeResult result;
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = symbol;
   request.volume = volume;
   request.price = price;
   request.sl = stoploss;
   request.tp = takeprofit;
   request.comment = comment;
   request.magic = magic;
   request.expiration = expiration;
   request.type = (ENUM_ORDER_TYPE)cmd; // MQL4 has OP_BUY, OP_SELL. MQL5 has ORDER_TYPE_BUY, ORDER_TYPE_SELL, etc.

   bool status = OrderSend (request, result);

   // @todo: Finish the implementation.
   return 0;
}

/*
  Returns Open price value for the bar of specified symbol with timeframe and shift.

  @see http://docs.mql4.com/series/iopen
*/
double iOpen (
   string           symbol,          // symbol
   int              tf,              // timeframe
   int              index            // shift
   )
{
  if (index < 0)
    return -1;

  double Arr[];

  ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

  if (CopyOpen (symbol, timeframe, index, 1, Arr) > 0) 
    return Arr[0];
  else
    return -1;
}

/*
  Returns Close price value for the bar of specified symbol with timeframe and shift.

  @see http://docs.mql4.com/series/iclose
*/
double iClose (
   string           symbol,          // symbol
   int              tf,              // timeframe
   int              index            // shift
   )
{
  if(index < 0)
    return -1;

  double Arr[];

  ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

  if (CopyClose (symbol, timeframe, index, 1, Arr) > 0)
    return Arr[0];
  else
    return -1;
}

/*
  Refreshing of data in pre-defined variables and series arrays.

  @see http://docs.mql4.com/series/refreshrates
*/
bool RefreshRates ()
{
  return true;
}

/*
  The latest known seller's price (ask price) for the current symbol. The RefreshRates() function must be used to update.

  @see http://docs.mql4.com/predefined/ask
*/
double AskMT4 ()
{
  MqlTick last_tick;

  SymbolInfoTick(_Symbol,last_tick);

  return last_tick.ask;

  // Overriding Ask variable to become a function call.
  #define Ask AskMT4()
}

/*
  The latest known buyer's price (offer price, bid price) of the current symbol. The RefreshRates() function must be used to update.

  @see http://docs.mql4.com/predefined/bid
*/
double BidMT4 ()
{
  MqlTick last_tick;

  SymbolInfoTick(_Symbol,last_tick);

  return last_tick.bid;

  // Overriding Bid variable to become a function call.
  #define Bid BidMT4()

}

/*
  Calculates the Money Flow Index indicator and returns its value.

  @see http://docs.mql4.com/indicators/imfi
*/
double iMFIMQL4 (string symbol,
             int tf,
             int period,
             int shift)
{
  ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

  int handle = (int) iMFI (symbol, timeframe, period, VOLUME_TICK);

  if (handle < 0)
  {
    Print ("The iMFI object is not created: Error", GetLastError ());
    return -1;
  }
  else
    return CopyBufferMQL4 (handle, 0, shift);

  // Overriding iMFI function.
  #define iMFI iMFIMQL4
}

/*
  Calculates the  Larry Williams' Percent Range and returns its value.

  @see http://docs.mql4.com/indicators/iwpr
*/
double iWPRMQL4 (string symbol,
            int tf,
            int period,
            int shift)
{
  ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

  int handle = iWPR (symbol, timeframe, period);

  if (handle < 0)
  {
    Print ("The iWPR object is not created: Error", GetLastError ());
    return -1;
  }
  else
    return CopyBufferMQL4 (handle, 0, shift);

  // Overriding iMPR function.
  #define iWPR iWPRMQL4
}

/*
  Calculates the Stochastic Oscillator and returns its value.

  @see http://docs.mql4.com/indicators/istochastic
*/
double iStochastic(string symbol,
               int tf,
               int Kperiod,
               int Dperiod,
               int slowing,
               int method,
               int field,
               int mode,
               int shift)
{
  ENUM_TIMEFRAMES timeframe   = TFMigrate (tf);
  ENUM_MA_METHOD  ma_method   = MethodMigrate (method);
  ENUM_STO_PRICE  price_field = StoFieldMigrate (field);

  int handle = iStochastic (symbol, timeframe, Kperiod, Dperiod, slowing, ma_method, price_field);

  if (handle < 0)
  {
    Print ("The iStochastic object is not created: Error", GetLastError ());
    return -1;
  }
  else
    return CopyBufferMQL4 (handle, mode, shift);
}


/*
  Calculates the Standard Deviation indicator and returns its value.

  @see http://docs.mql4.com/indicators/istddev
*/
double iStdDev (string symbol,
           int tf,
           int ma_period,
           int ma_shift,
           int method,
           int price,
           int shift)
{
  ENUM_TIMEFRAMES    timeframe     = TFMigrate (tf);
  ENUM_MA_METHOD     ma_method     = MethodMigrate (method);
  ENUM_APPLIED_PRICE applied_price = PriceMigrate (price);

  int handle = iStdDev (symbol, timeframe, ma_period, ma_shift, ma_method, applied_price);

  if (handle < 0)
  {
    Print ("The iStdDev object is not created: Error", GetLastError ());
    return -1;
  }
  else
    return CopyBufferMQL4 (handle, 0, shift);
}

/*
  Returns symbol name of the currently selected order.

  @see http://docs.mql4.com/trading/ordersymbol
*/
string OrderSymbol ()
{
  // @todo: Create implementation.
  return "";
}

/*
  Returns order operation type of the currently selected order.

  @see http://docs.mql4.com/trading/ordertype
*/
int OrderType ()
{
  // @todo: Create implementation.
  return 0;
}

/*
  Returns an identifying (magic) number of the currently selected order.

  @see http://docs.mql4.com/trading/ordermagicnumber
*/
int OrderMagicNumber ()
{
  // @todo: Create implementation.
  return 0;
}

/*
  Returns stop loss value of the currently selected order.

  @see http://docs.mql4.com/trading/orderstoploss
*/
double OrderStopLoss ()
{
  // @todo: Create implementation.
  return 0.0;
}

/*
  Returns calculated commission of the currently selected order.

  @see http://docs.mql4.com/trading/ordercommission
*/
double OrderCommission ()
{
  // @todo: Create implementation.
  return 0.0;
}

/*
  Returns take profit value of the currently selected order.

  @see http://docs.mql4.com/trading/ordertakeprofit
*/
double OrderTakeProfit ()
{
  // @todo: Create implementation.
  return 0.0;
}

/*
  Modification of characteristics of the previously opened or pending orders.

  @see http://docs.mql4.com/trading/ordermodify
*/
bool OrderModify (
   int        ticket,      // ticket
   double     price,       // price
   double     stoploss,    // stop loss
   double     takeprofit,  // take profit
   datetime   expiration,  // expiration
   color      arrow_color  // color
   )
{
  // @todo: Create implementation.
  return false;
}

/*
  Returns open time of the currently selected order.

  @see http://docs.mql4.com/trading/orderopentime
*/
datetime OrderOpenTime ()
{
  // @todo: Create implementation.
  return (datetime)0;
}

/*
  Search for a bar by its time. The function returns the index of the bar which covers the specified time.

  @see http://docs.mql4.com/series/ibarshift
*/
int iBarShift (string symbol,
                  int tf,
             datetime time,
                 bool exact = false)
{
  if (time < 0)
    return -1;

  ENUM_TIMEFRAMES timeframe = TFMigrate (tf);

  datetime Arr[], time1;

  CopyTime (symbol, timeframe, 0, 1, Arr);

  time1 = Arr[0];

  if (CopyTime (symbol, timeframe, time, time1, Arr) > 0)
  {
    if (ArraySize (Arr) > 2)
      return ArraySize (Arr) - 1;

    if (time < time1)
        return 1;
    else
      return 0;
  }
  else
    return -1;
}

#endif