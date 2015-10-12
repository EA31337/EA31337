//+------------------------------------------------------------------+
//| Define constants.
//+------------------------------------------------------------------+

#ifdef __MQL5__
  #define EMPTY WRONG_VALUE
  #define EMPTY_STRING ""
  #define FALSE false
  #define TRUE true

  // EMPTY_VALUE in MQL5 is equal to DBL_MAX. Integer types in MQL5 can't hold
  // DBL_MAX so we need to redefine EMPTY_VALUE to become INT_MAX. See
  // https://www.mql5.com/en/docs/constants/namedconstants/otherconstants for
  // reference
  #undef EMPTY_VALUE
  #define EMPTY_VALUE INT_MAX

  #define ARRAY_INDEX_2D []

  #define Volume VolumeMT4()
  #define Digits _Digits
  #define Point _Point
  
#endif
