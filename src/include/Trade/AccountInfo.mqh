//+------------------------------------------------------------------+
//|                                                  AccountInfo.mqh |
//|                   Copyright 2009-2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <Object.mqh>
//+------------------------------------------------------------------+
//| Class CAccountInfo.                                              |
//| Appointment: Class for access to account info.                   |
//|              Derives from class CObject.                         |
//+------------------------------------------------------------------+
class CAccountInfo : public CObject
  {
public:
                     CAccountInfo(void);
                    ~CAccountInfo(void);
   //--- fast access methods to the integer account propertyes
   long              Login(void) const;
   ENUM_ACCOUNT_TRADE_MODE TradeMode(void) const;
   string            TradeModeDescription(void) const;
   long              Leverage(void) const;
   ENUM_ACCOUNT_STOPOUT_MODE MarginMode(void) const;
   string            MarginModeDescription(void) const;
   bool              TradeAllowed(void) const;
   bool              TradeExpert(void) const;
   int               LimitOrders(void) const;
   //--- fast access methods to the double account propertyes
   double            Balance(void) const;
   double            Credit(void) const;
   double            Profit(void) const;
   double            Equity(void) const;
   double            Margin(void) const;
   double            FreeMargin(void) const;
   double            MarginLevel(void) const;
   double            MarginCall(void) const;
   double            MarginStopOut(void) const;
   //--- fast access methods to the string account propertyes
   string            Name(void) const;
   string            Server(void) const;
   string            Currency(void) const;
   string            Company(void) const;
   //--- access methods to the API MQL5 functions
   long              InfoInteger(const ENUM_ACCOUNT_INFO_INTEGER prop_id) const;
   double            InfoDouble(const ENUM_ACCOUNT_INFO_DOUBLE prop_id) const;
   string            InfoString(const ENUM_ACCOUNT_INFO_STRING prop_id) const;
   //--- checks
   double            OrderProfitCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                      const double volume,const double price_open,const double price_close) const;
   double            MarginCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                 const double volume,const double price) const;
   double            FreeMarginCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                     const double volume,const double price) const;
   double            MaxLotCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                 const double price,const double percent=100) const;
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CAccountInfo::CAccountInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CAccountInfo::~CAccountInfo(void)
  {
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_LOGIN"                           |
//+------------------------------------------------------------------+
long CAccountInfo::Login(void) const
  {
   return(AccountInfoInteger(ACCOUNT_LOGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_MODE"                      |
//+------------------------------------------------------------------+
ENUM_ACCOUNT_TRADE_MODE CAccountInfo::TradeMode(void) const
  {
   return((ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_MODE" as string            |
//+------------------------------------------------------------------+
string CAccountInfo::TradeModeDescription(void) const
  {
   string str;
//---
   switch(TradeMode())
     {
      case ACCOUNT_TRADE_MODE_DEMO   : str="Demo trading account";    break;
      case ACCOUNT_TRADE_MODE_CONTEST: str="Contest trading account"; break;
      case ACCOUNT_TRADE_MODE_REAL   : str="Real trading account";    break;
      default                        : str="Unknown trade account";
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_LEVERAGE"                        |
//+------------------------------------------------------------------+
long CAccountInfo::Leverage(void) const
  {
   return(AccountInfoInteger(ACCOUNT_LEVERAGE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_MODE"                  |
//+------------------------------------------------------------------+
ENUM_ACCOUNT_STOPOUT_MODE CAccountInfo::MarginMode(void) const
  {
   return((ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_MODE" as string        |
//+------------------------------------------------------------------+
string CAccountInfo::MarginModeDescription(void) const
  {
   string str;
//---
   switch(MarginMode())
     {
      case ACCOUNT_STOPOUT_MODE_PERCENT: str="Level is specified in percentage"; break;
      case ACCOUNT_STOPOUT_MODE_MONEY  : str="Level is specified in money";      break;
      default                          : str="Unknown margin mode";
     }
//---
   return(str);
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_ALLOWED"                   |
//+------------------------------------------------------------------+
bool CAccountInfo::TradeAllowed(void) const
  {
   return((bool)AccountInfoInteger(ACCOUNT_TRADE_ALLOWED));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_TRADE_EXPERT"                    |
//+------------------------------------------------------------------+
bool CAccountInfo::TradeExpert(void) const
  {
   return((bool)AccountInfoInteger(ACCOUNT_TRADE_EXPERT));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_LIMIT_ORDERS"                    |
//+------------------------------------------------------------------+
int CAccountInfo::LimitOrders(void) const
  {
   return((int)AccountInfoInteger(ACCOUNT_LIMIT_ORDERS));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_BALANCE"                         |
//+------------------------------------------------------------------+
double CAccountInfo::Balance(void) const
  {
   return(AccountInfoDouble(ACCOUNT_BALANCE));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_CREDIT"                          |
//+------------------------------------------------------------------+
double CAccountInfo::Credit(void) const
  {
   return(AccountInfoDouble(ACCOUNT_CREDIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_PROFIT"                          |
//+------------------------------------------------------------------+
double CAccountInfo::Profit(void) const
  {
   return(AccountInfoDouble(ACCOUNT_PROFIT));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_EQUITY"                          |
//+------------------------------------------------------------------+
double CAccountInfo::Equity(void) const
  {
   return(AccountInfoDouble(ACCOUNT_EQUITY));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN"                          |
//+------------------------------------------------------------------+
double CAccountInfo::Margin(void) const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_FREEMARGIN"                      |
//+------------------------------------------------------------------+
double CAccountInfo::FreeMargin(void) const
  {
   return(AccountInfoDouble(ACCOUNT_FREEMARGIN));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_LEVEL"                    |
//+------------------------------------------------------------------+
double CAccountInfo::MarginLevel(void) const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN_LEVEL));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_CALL"                  |
//+------------------------------------------------------------------+
double CAccountInfo::MarginCall(void) const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_MARGIN_SO_SO"                    |
//+------------------------------------------------------------------+
double CAccountInfo::MarginStopOut(void) const
  {
   return(AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_NAME"                            |
//+------------------------------------------------------------------+
string CAccountInfo::Name(void) const
  {
   return(AccountInfoString(ACCOUNT_NAME));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_SERVER"                          |
//+------------------------------------------------------------------+
string CAccountInfo::Server(void) const
  {
   return(AccountInfoString(ACCOUNT_SERVER));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_CURRENCY"                        |
//+------------------------------------------------------------------+
string CAccountInfo::Currency(void) const
  {
   return(AccountInfoString(ACCOUNT_CURRENCY));
  }
//+------------------------------------------------------------------+
//| Get the property value "ACCOUNT_COMPANY"                         |
//+------------------------------------------------------------------+
string CAccountInfo::Company(void) const
  {
   return(AccountInfoString(ACCOUNT_COMPANY));
  }
//+------------------------------------------------------------------+
//| Access functions AccountInfoInteger(...)                         |
//+------------------------------------------------------------------+
long CAccountInfo::InfoInteger(const ENUM_ACCOUNT_INFO_INTEGER prop_id) const
  {
   return(AccountInfoInteger(prop_id));
  }
//+------------------------------------------------------------------+
//| Access functions AccountInfoDouble(...)                          |
//+------------------------------------------------------------------+
double CAccountInfo::InfoDouble(const ENUM_ACCOUNT_INFO_DOUBLE prop_id) const
  {
   return(AccountInfoDouble(prop_id));
  }
//+------------------------------------------------------------------+
//| Access functions AccountInfoString(...)                          |
//+------------------------------------------------------------------+
string CAccountInfo::InfoString(const ENUM_ACCOUNT_INFO_STRING prop_id) const
  {
   return(AccountInfoString(prop_id));
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcProfit(...).                            |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         volume          - volume of the opening position,        |
//|         price_open      - price of the opening position,         |
//|         price_close     - price of the closing position.         |
//+------------------------------------------------------------------+
double CAccountInfo::OrderProfitCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                      const double volume,const double price_open,const double price_close) const
  {
   double profit=EMPTY_VALUE;
//---
   if(!OrderCalcProfit(trade_operation,symbol,volume,price_open,price_close,profit))
      return(EMPTY_VALUE);
//---
   return(profit);
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcMargin(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         volume          - volume of the opening position,        |
//|         price           - price of the opening position.         |
//+------------------------------------------------------------------+
double CAccountInfo::MarginCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                 const double volume,const double price) const
  {
   double margin=EMPTY_VALUE;
//---
   if(!OrderCalcMargin(trade_operation,symbol,volume,price,margin))
      return(EMPTY_VALUE);
//---
   return(margin);
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcMargin(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         volume          - volume of the opening position,        |
//|         price           - price of the opening position.         |
//+------------------------------------------------------------------+
double CAccountInfo::FreeMarginCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                     const double volume,const double price) const
  {
   return(FreeMargin()-MarginCheck(symbol,trade_operation,volume,price));
  }
//+------------------------------------------------------------------+
//| Access functions OrderCalcMargin(...).                           |
//| INPUT:  name            - symbol name,                           |
//|         trade_operation - trade operation,                       |
//|         price           - price of the opening position,         |
//|         percent         - percent of available margin [1-100%].   |
//+------------------------------------------------------------------+
double CAccountInfo::MaxLotCheck(const string symbol,const ENUM_ORDER_TYPE trade_operation,
                                 const double price,const double percent) const
  {
   double margin=0.0;
//--- checks
   if(symbol=="" || price<=0.0 || percent<1 || percent>100)
     {
      Print("CAccountInfo::MaxLotCheck invalid parameters");
      return(0.0);
     }
//--- calculate margin requirements for 1 lot
   if(!OrderCalcMargin(trade_operation,symbol,1.0,price,margin) || margin<0.0)
     {
      Print("CAccountInfo::MaxLotCheck margin calculation failed");
      return(0.0);
     }
//---
   if(margin==0.0) // for pending orders
      return(SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX));
//--- calculate maximum volume
   double volume=NormalizeDouble(FreeMargin()*percent/100.0/margin,2);
//--- normalize and check limits
   double stepvol=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   if(stepvol>0.0)
      volume=stepvol*MathFloor(volume/stepvol);
//---
   double minvol=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   if(volume<minvol)
      volume=0.0;
//---
   double maxvol=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   if(volume>maxvol)
      volume=maxvol;
//--- return volume
   return(volume);
  }
//+------------------------------------------------------------------+
