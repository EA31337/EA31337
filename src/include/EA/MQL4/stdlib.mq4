//+------------------------------------------------------------------+
//|                                                       stdlib.mq4 |
//|                   Copyright 2005-2015, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "2005-2015, MetaQuotes Software Corp."
#property link      "http://www.mql4.com"
#property library
//+------------------------------------------------------------------+
//| return error description                                         |
//+------------------------------------------------------------------+
string ErrorDescription(int error_code)
  {
   string error_string;
//---
   switch(error_code)
     {
      //--- codes returned from trade server
      case 0:   error_string="no error";                                                   break;
      case 1:   error_string="no error, trade conditions not changed";                     break;
      case 2:   error_string="common error";                                               break;
      case 3:   error_string="invalid trade parameters";                                   break;
      case 4:   error_string="trade server is busy";                                       break;
      case 5:   error_string="old version of the client terminal";                         break;
      case 6:   error_string="no connection with trade server";                            break;
      case 7:   error_string="not enough rights";                                          break;
      case 8:   error_string="too frequent requests";                                      break;
      case 9:   error_string="malfunctional trade operation (never returned error)";       break;
      case 64:  error_string="account disabled";                                           break;
      case 65:  error_string="invalid account";                                            break;
      case 128: error_string="trade timeout";                                              break;
      case 129: error_string="invalid price";                                              break;
      case 130: error_string="invalid stops";                                              break;
      case 131: error_string="invalid trade volume";                                       break;
      case 132: error_string="market is closed";                                           break;
      case 133: error_string="trade is disabled";                                          break;
      case 134: error_string="not enough money";                                           break;
      case 135: error_string="price changed";                                              break;
      case 136: error_string="off quotes";                                                 break;
      case 137: error_string="broker is busy (never returned error)";                      break;
      case 138: error_string="requote";                                                    break;
      case 139: error_string="order is locked";                                            break;
      case 140: error_string="long positions only allowed";                                break;
      case 141: error_string="too many requests";                                          break;
      case 145: error_string="modification denied because order is too close to market";   break;
      case 146: error_string="trade context is busy";                                      break;
      case 147: error_string="expirations are denied by broker";                           break;
      case 148: error_string="amount of open and pending orders has reached the limit";    break;
      case 149: error_string="hedging is prohibited";                                      break;
      case 150: error_string="prohibited by FIFO rules";                                   break;
      //--- mql4 errors
      case 4000: error_string="no error (never generated code)";                           break;
      case 4001: error_string="wrong function pointer";                                    break;
      case 4002: error_string="array index is out of range";                               break;
      case 4003: error_string="no memory for function call stack";                         break;
      case 4004: error_string="recursive stack overflow";                                  break;
      case 4005: error_string="not enough stack for parameter";                            break;
      case 4006: error_string="no memory for parameter string";                            break;
      case 4007: error_string="no memory for temp string";                                 break;
      case 4008: error_string="non-initialized string";                                    break;
      case 4009: error_string="non-initialized string in array";                           break;
      case 4010: error_string="no memory for array\' string";                              break;
      case 4011: error_string="too long string";                                           break;
      case 4012: error_string="remainder from zero divide";                                break;
      case 4013: error_string="zero divide";                                               break;
      case 4014: error_string="unknown command";                                           break;
      case 4015: error_string="wrong jump (never generated error)";                        break;
      case 4016: error_string="non-initialized array";                                     break;
      case 4017: error_string="dll calls are not allowed";                                 break;
      case 4018: error_string="cannot load library";                                       break;
      case 4019: error_string="cannot call function";                                      break;
      case 4020: error_string="expert function calls are not allowed";                     break;
      case 4021: error_string="not enough memory for temp string returned from function";  break;
      case 4022: error_string="system is busy (never generated error)";                    break;
      case 4023: error_string="dll-function call critical error";                          break;
      case 4024: error_string="internal error";                                            break;
      case 4025: error_string="out of memory";                                             break;
      case 4026: error_string="invalid pointer";                                           break;
      case 4027: error_string="too many formatters in the format function";                break;
      case 4028: error_string="parameters count is more than formatters count";            break;
      case 4029: error_string="invalid array";                                             break;
      case 4030: error_string="no reply from chart";                                       break;
      case 4050: error_string="invalid function parameters count";                         break;
      case 4051: error_string="invalid function parameter value";                          break;
      case 4052: error_string="string function internal error";                            break;
      case 4053: error_string="some array error";                                          break;
      case 4054: error_string="incorrect series array usage";                              break;
      case 4055: error_string="custom indicator error";                                    break;
      case 4056: error_string="arrays are incompatible";                                   break;
      case 4057: error_string="global variables processing error";                         break;
      case 4058: error_string="global variable not found";                                 break;
      case 4059: error_string="function is not allowed in testing mode";                   break;
      case 4060: error_string="function is not confirmed";                                 break;
      case 4061: error_string="send mail error";                                           break;
      case 4062: error_string="string parameter expected";                                 break;
      case 4063: error_string="integer parameter expected";                                break;
      case 4064: error_string="double parameter expected";                                 break;
      case 4065: error_string="array as parameter expected";                               break;
      case 4066: error_string="requested history data is in update state";                 break;
      case 4067: error_string="internal trade error";                                      break;
      case 4068: error_string="resource not found";                                        break;
      case 4069: error_string="resource not supported";                                    break;
      case 4070: error_string="duplicate resource";                                        break;
      case 4071: error_string="cannot initialize custom indicator";                        break;
      case 4072: error_string="cannot load custom indicator";                              break;
      case 4073: error_string="no history data";                                           break;
      case 4074: error_string="not enough memory for history data";                        break;
      case 4075: error_string="not enough memory for indicator";                           break;
      case 4099: error_string="end of file";                                               break;
      case 4100: error_string="some file error";                                           break;
      case 4101: error_string="wrong file name";                                           break;
      case 4102: error_string="too many opened files";                                     break;
      case 4103: error_string="cannot open file";                                          break;
      case 4104: error_string="incompatible access to a file";                             break;
      case 4105: error_string="no order selected";                                         break;
      case 4106: error_string="unknown symbol";                                            break;
      case 4107: error_string="invalid price parameter for trade function";                break;
      case 4108: error_string="invalid ticket";                                            break;
      case 4109: error_string="trade is not allowed in the expert properties";             break;
      case 4110: error_string="longs are not allowed in the expert properties";            break;
      case 4111: error_string="shorts are not allowed in the expert properties";           break;
      case 4200: error_string="object already exists";                                     break;
      case 4201: error_string="unknown object property";                                   break;
      case 4202: error_string="object does not exist";                                     break;
      case 4203: error_string="unknown object type";                                       break;
      case 4204: error_string="no object name";                                            break;
      case 4205: error_string="object coordinates error";                                  break;
      case 4206: error_string="no specified subwindow";                                    break;
      case 4207: error_string="graphical object error";                                    break;
      case 4210: error_string="unknown chart property";                                    break;
      case 4211: error_string="chart not found";                                           break;
      case 4212: error_string="chart subwindow not found";                                 break;
      case 4213: error_string="chart indicator not found";                                 break;
      case 4220: error_string="symbol select error";                                       break;
      case 4250: error_string="notification error";                                        break;
      case 4251: error_string="notification parameter error";                              break;
      case 4252: error_string="notifications disabled";                                    break;
      case 4253: error_string="notification send too frequent";                            break;
      case 4260: error_string="ftp server is not specified";                               break;
      case 4261: error_string="ftp login is not specified";                                break;
      case 4262: error_string="ftp connect failed";                                        break;
      case 4263: error_string="ftp connect closed";                                        break;
      case 4264: error_string="ftp change path error";                                     break;
      case 4265: error_string="ftp file error";                                            break;
      case 4266: error_string="ftp error";                                                 break;
      case 5001: error_string="too many opened files";                                     break;
      case 5002: error_string="wrong file name";                                           break;
      case 5003: error_string="too long file name";                                        break;
      case 5004: error_string="cannot open file";                                          break;
      case 5005: error_string="text file buffer allocation error";                         break;
      case 5006: error_string="cannot delete file";                                        break;
      case 5007: error_string="invalid file handle (file closed or was not opened)";       break;
      case 5008: error_string="wrong file handle (handle index is out of handle table)";   break;
      case 5009: error_string="file must be opened with FILE_WRITE flag";                  break;
      case 5010: error_string="file must be opened with FILE_READ flag";                   break;
      case 5011: error_string="file must be opened with FILE_BIN flag";                    break;
      case 5012: error_string="file must be opened with FILE_TXT flag";                    break;
      case 5013: error_string="file must be opened with FILE_TXT or FILE_CSV flag";        break;
      case 5014: error_string="file must be opened with FILE_CSV flag";                    break;
      case 5015: error_string="file read error";                                           break;
      case 5016: error_string="file write error";                                          break;
      case 5017: error_string="string size must be specified for binary file";             break;
      case 5018: error_string="incompatible file (for string arrays-TXT, for others-BIN)"; break;
      case 5019: error_string="file is directory, not file";                               break;
      case 5020: error_string="file does not exist";                                       break;
      case 5021: error_string="file cannot be rewritten";                                  break;
      case 5022: error_string="wrong directory name";                                      break;
      case 5023: error_string="directory does not exist";                                  break;
      case 5024: error_string="specified file is not directory";                           break;
      case 5025: error_string="cannot delete directory";                                   break;
      case 5026: error_string="cannot clean directory";                                    break;
      case 5027: error_string="array resize error";                                        break;
      case 5028: error_string="string resize error";                                       break;
      case 5029: error_string="structure contains strings or dynamic arrays";              break;
      default:   error_string="unknown error";
     }
//---
   return(error_string);
  }
//+------------------------------------------------------------------+
//| convert red, green and blue values to color                      |
//+------------------------------------------------------------------+
int RGB(int red_value,int green_value,int blue_value)
  {
//--- check parameters
   if(red_value<0)     red_value=0;
   if(red_value>255)   red_value=255;
   if(green_value<0)   green_value=0;
   if(green_value>255) green_value=255;
   if(blue_value<0)    blue_value=0;
   if(blue_value>255)  blue_value=255;
//---
   green_value<<=8;
   blue_value<<=16;
   return(red_value+green_value+blue_value);
  }
//+------------------------------------------------------------------+
//| right comparison of 2 doubles                                    |
//+------------------------------------------------------------------+
bool CompareDoubles(double number1,double number2)
  {
   if(NormalizeDouble(number1-number2,8)==0) return(true);
   else return(false);
  }
//+------------------------------------------------------------------+
//| up to 16 digits after decimal point                              |
//+------------------------------------------------------------------+
string DoubleToStrMorePrecision(double number,int precision)
  {
   static double DecimalArray[17]=
     {
      1.0,
      10.0,
      100.0,
      1000.0,
      10000.0,
      100000.0,
      1000000.0,
      10000000.0,
      100000000.0,
      1000000000.0,
      10000000000.0,
      100000000000.0,
      1000000000000.0,
      10000000000000.0,
      100000000000000.0,
      1000000000000000.0,
      10000000000000000.0
     };

   double rem,integer,integer2;
   string intstring,remstring,retstring;
   bool   isnegative=false;
   int    rem2;
//---
   if(precision<0)  precision=0;
   if(precision>16) precision=16;
//---
   double p=DecimalArray[precision];
   if(number<0.0)
     {
      isnegative=true;
      number=-number;
     }
   integer=MathFloor(number);
   rem=MathRound((number-integer)*p);
   remstring="";
   for(int i=0; i<precision; i++)
     {
      integer2=MathFloor(rem/10);
      rem2=(int)NormalizeDouble(rem-integer2*10,0);
      remstring=IntegerToString(rem2)+remstring;
      rem=integer2;
     }
//---
   intstring=DoubleToStr(integer,0);
   if(isnegative)
      retstring="-"+intstring;
   else
      retstring=intstring;

   if(precision>0)
      retstring=retstring+"."+remstring;
//---
   return(retstring);
  }
//+------------------------------------------------------------------+
//| convert integer to string contained input's hexadecimal notation |
//+------------------------------------------------------------------+
string IntegerToHexString(int integer_number)
  {
   string hex_string="00000000";
   int    value,shift=28;
//---
   for(int i=0; i<8; i++)
     {
      value=(integer_number>>shift)&0x0F;
      if(value<10)
         hex_string=StringSetChar(hex_string,i,ushort(value+'0'));
      else
         hex_string=StringSetChar(hex_string,i,ushort((value-10)+'A'));
      shift-=4;
     }
//---
   return(hex_string);
  }
//+------------------------------------------------------------------+
