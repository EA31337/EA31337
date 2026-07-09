#ifndef FXMACRODATA_MQH
#define FXMACRODATA_MQH

class FXMacroData {
 private:
  string api_key;
  string base_url;

  string Lower(string value) {
    StringToLower(value);
    return value;
  }

  string BuildUrl(string path) {
    string request_url = base_url + path;
    if (api_key != "") {
      request_url += "?api_key=" + api_key;
    }
    return request_url;
  }

 public:
  FXMacroData(string key = "", string url = "https://api.fxmacrodata.com/v1") {
    api_key = key;
    base_url = url;
  }

  string DataCatalogue(string currency) { return BuildUrl("/data_catalogue/" + Lower(currency)); }
  string Announcements(string currency, string indicator) { return BuildUrl("/announcements/" + Lower(currency) + "/" + indicator); }
  string Calendar(string currency) { return BuildUrl("/calendar/" + Lower(currency)); }
  string Predictions(string currency, string indicator) { return BuildUrl("/predictions/" + Lower(currency) + "/" + indicator); }
  string Forex(string base, string quote) { return BuildUrl("/forex/" + Lower(base) + "/" + Lower(quote)); }
  string Cot(string currency) { return BuildUrl("/cot/" + Lower(currency)); }
  string CommoditiesLatest() { return BuildUrl("/commodities/latest"); }
  string Commodity(string indicator) { return BuildUrl("/commodities/" + indicator); }
  string Curves(string currency) { return BuildUrl("/curves/" + Lower(currency)); }
  string CurveProxies(string currency) { return BuildUrl("/curve_proxies/" + Lower(currency)); }
  string ForwardCurves(string currency) { return BuildUrl("/forward_curves/" + Lower(currency)); }
  string MarketSessions() { return BuildUrl("/market_sessions"); }
  string RiskSentiment() { return BuildUrl("/risk_sentiment"); }
  string News(string currency) { return BuildUrl("/news/" + Lower(currency)); }
  string PressReleases(string currency) { return BuildUrl("/press-releases/" + Lower(currency)); }
  string CentralBankers(string currency) { return BuildUrl("/central_bankers/" + Lower(currency)); }
};

#endif
