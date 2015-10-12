/*
  Series array that contains the lowest prices of each bar of the current chart.

  @see http://docs.mql4.com/predefined/low
*/
double GetLow (int index)
{
  #ifdef __MQL5__
    static double cache[];
    
    int count = 1;
    ArraySetAsSeries (cache, true);
    CopyLow(_Symbol, _Period, 0, count, cache);
    
    return cache[index];
  #else
    return Low[index];
  #endif
}

/*
  Series array that contains the higest prices of each bar of the current chart.

  @see http://docs.mql4.com/predefined/high
*/
double GetHigh (int index)
{
  #ifdef __MQL5__
    static double cache[];
    
    int count = 1;
    ArraySetAsSeries (cache, true);
    CopyHigh(_Symbol, _Period, 0, count, cache);
    
    return cache[index];
  #else
    return High[index];
  #endif
}

/*
  Series array that contains open prices of each bar of the current chart.

  @see http://docs.mql4.com/predefined/open
*/
double GetOpen (int index)
{
  #ifdef __MQL5__
    static double cache[];
    
    int count = 1;
    ArraySetAsSeries (cache, true);
    CopyOpen(_Symbol, _Period, 0, count, cache);
    
    return cache[index];
  #else
    return Open[index];
  #endif
}

/*
  Series array that contains close prices for each bar of the current chart.

  @see http://docs.mql4.com/predefined/close
*/
double GetClose (int index)
{
  #ifdef __MQL5__
    static double cache[];
    
    int count = 1;
    ArraySetAsSeries (cache, true);
    CopyClose(_Symbol, _Period, 0, count, cache);
    
    return cache[index];
  #else
    return Open[index];
  #endif
}

/*
  Returns tick volumes of the specified chart.

  // @see http://docs.mql4.com/predefined/volume
*/
long GetVolume (int index)
{
  #ifdef __MQL5__
    static long volumeCache[];
    
    int count = 1;
    ArraySetAsSeries(volumeCache,true);
    CopyTickVolume(_Symbol, _Period, 0, count, volumeCache);

    return volumeCache[index];
  #else
    return Volume[index];
  #endif
}
