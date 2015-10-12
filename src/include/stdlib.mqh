//+------------------------------------------------------------------+
//|                                                       stdlib.mqh |
//|                      Copyright © 2004, MetaQuotes Software Corp. |
//|                                       http://www.metaquotes.net/ |
//+------------------------------------------------------------------+

#ifdef __MQL5__
  #include "stdlib.mq4"
#else
  #import "stdlib.ex4"
#endif


string ErrorDescription(int error_code);
int    RGB(int red_value,int green_value,int blue_value);
bool   CompareDoubles(double number1,double number2);
string DoubleToStrMorePrecision(double number,int precision);
string IntegerToHexString(int integer_number);

