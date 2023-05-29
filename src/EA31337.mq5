//+------------------------------------------------------------------+
//|                 EA31337 - multi-strategy advanced trading robot. |
//|                                 Copyright 2016-2023, EA31337 Ltd |
//|                                       https://ea31337.github.io/ |
//+------------------------------------------------------------------+

/*
 *  This file is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

// Includes.
#include "include/ea.h"
#include "include/includes.h"

// EA properties.
#ifdef __property__
#property copyright ea_copy
#property description ea_name
#property description ea_desc
#property icon "resources/favicon.ico"
#property link ea_link
#property version ea_version
#endif

// EA indicator resources.
#ifdef __resource__
#ifdef __MQL5__
// Tester properties.
#property tester_indicator "::" + INDI_EWO_OSC_PATH + "\\Elliott_Wave_Oscillator2" + MQL_EXT
#property tester_indicator "::" + INDI_SVEBB_PATH + "\\SVE_Bollinger_Bands" + MQL_EXT
#property tester_indicator "::" + INDI_TMA_CG_PATH + "\\TMA+CG_mladen_NRP" + MQL_EXT
#property tester_indicator "::" + INDI_ATR_MA_TREND_PATH + "\\ATR_MA_Trend" + MQL_EXT
#property tester_indicator "::" + INDI_TMA_TRUE_PATH + "\\TMA_True" + MQL_EXT
#property tester_indicator "::" + INDI_SAWA_PATH + "\\SAWA" + MQL_EXT
#property tester_indicator "::" + INDI_SUPERTREND_PATH + "\\SuperTrend" + MQL_EXT
// Indicator resources.
#resource INDI_EWO_OSC_PATH + "\\Elliott_Wave_Oscillator2" + MQL_EXT
#resource INDI_SVEBB_PATH + "\\SVE_Bollinger_Bands" + MQL_EXT
#resource INDI_TMA_CG_PATH + "\\TMA+CG_mladen_NRP" + MQL_EXT
#resource INDI_ATR_MA_TREND_PATH + "\\ATR_MA_Trend" + MQL_EXT
#resource INDI_TMA_TRUE_PATH + "\\TMA_True" + MQL_EXT
#resource INDI_SAWA_PATH + "\\SAWA" + MQL_EXT
#resource INDI_SUPERTREND_PATH + "\\SuperTrend" + MQL_EXT
#endif
#endif

// Global variables.
EA31337 *ea;

/* EA event handler functions */

/**
 * Initialization function of the expert.
 */
int OnInit() {
  bool _initiated = true;
  EAParams _ea_params(__FILE__, VerboseLevel);
  // EA params.
  _ea_params.SetDetails(ea_name, ea_desc, ea_version, StringFormat("%s (%s)", ea_author, ea_link));
  // Risk params.
  _ea_params.Set(STRUCT_ENUM(EAParams, EA_PARAM_PROP_RISK_MARGIN_MAX), EA_Risk_MarginMax);
  _ea_params.SetFlag(EA_PARAM_FLAG_LOTSIZE_AUTO, EA_LotSize <= 0);
  ea = new EA31337(_ea_params);
  ea.Set(TRADE_PARAM_RISK_MARGIN, EA_Risk_MarginMax);
  if (ea.Get(STRUCT_ENUM(EAState, EA_STATE_FLAG_TRADE_ALLOWED))) {
    _initiated &= InitStrategies();
#ifdef __advanced__
    if (_initiated) {
      _initiated &= ea.TaskAdd(ea.GetTaskEntry(EA_Task1_If, EA_Task1_Then));
      _initiated &= ea.TaskAdd(ea.GetTaskEntry(EA_Task2_If, EA_Task2_Then));
      _initiated &= ea.TaskAdd(ea.GetTaskEntry(EA_Task3_If, EA_Task3_Then));
    }
#endif
  } else {
    ea.GetLogger().Error(
        "Trading is not allowed for this symbol, please enable automated trading or check the settings!",
        __FUNCTION_LINE__);
    _initiated = false;
  }
  if (!_initiated || GetLastError() > 0) {
    ea.GetLogger().Error("Error during initializing!", __FUNCTION_LINE__, Terminal::GetLastErrorText());
  }
  if (EA_DisplayDetailsOnChart) {
    ea.PrintStartupInfo(true);
  }
  ea.GetLogger().Flush();
  Chart::WindowRedraw();
  if (!_initiated) {
    ea.Set(STRUCT_ENUM(EAState, EA_STATE_FLAG_ENABLED), false);
  }
  return (_initiated ? INIT_SUCCEEDED : INIT_FAILED);
}

/**
 * Deinitialization function of the expert.
 */
void OnDeinit(const int reason) { DeinitVars(); }

/**
 * "Tick" event handler function (EA only).
 *
 * Invoked when a new tick for a symbol is received, to the chart of which the Expert Advisor is attached.
 */
void OnTick() { ea.OnTick(SymbolInfoStatic::GetTick(_Symbol)); }

#ifdef __MQL5__
/**
 * "Trade" event handler function (MQL5 only).
 *
 * Invoked when a trade operation is completed on a trade server.
 */
void OnTrade() {}

/**
 * "OnTradeTransaction" event handler function (MQL5 only).
 *
 * Invoked when performing some definite actions on a trade account, its state changes.
 */
void OnTradeTransaction(const MqlTradeTransaction &trans,  // Trade transaction structure.
                        const MqlTradeRequest &request,    // Request structure.
                        const MqlTradeResult &result       // Result structure.
) {}

/**
 * "Timer" event handler function (MQL5 only).
 *
 * Invoked periodically generated by the EA that has activated the timer by the EventSetTimer function.
 * Usually, this function is called by OnInit.
 */
void OnTimer() {}

/**
 * "TesterInit" event handler function (MQL5 only).
 *
 * The start of optimization in the strategy tester before the first optimization pass.
 *
 * Invoked with the start of optimization in the strategy tester.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
void TesterInit() {}

/**
 * "OnTester" event handler function.
 *
 * Invoked after a history testing of an Expert Advisor on the chosen interval is over.
 * It is called right before the call of OnDeinit().
 *
 * Returns calculated value that is used as the Custom max criterion
 * in the genetic optimization of input parameters.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
// double OnTester() { return 1.0; }

/**
 * "OnTesterPass" event handler function (MQL5 only).
 *
 * Invoked when a frame is received during Expert Advisor optimization in the strategy tester.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
void OnTesterPass() {}

/**
 * "OnTesterDeinit" event handler function (MQL5 only).
 *
 * Invoked after the end of Expert Advisor optimization in the strategy tester.
 *
 * @see: https://www.mql5.com/en/docs/basis/function/events
 */
void OnTesterDeinit() {}

/**
 * "OnBookEvent" event handler function (MQL5 only).
 *
 * Invoked on Depth of Market changes.
 * To pre-subscribe use the MarketBookAdd() function.
 * In order to unsubscribe for a particular symbol, call MarketBookRelease().
 */
void OnBookEvent(const string &symbol) {}

/**
 * "OnBookEvent" event handler function (MQL5 only).
 *
 * Invoked by the client terminal when a user is working with a chart.
 */
void OnChartEvent(const int id,          // Event ID.
                  const long &lparam,    // Parameter of type long event.
                  const double &dparam,  // Parameter of type double event.
                  const string &sparam   // Parameter of type string events.
) {}

// @todo: OnTradeTransaction (https://www.mql5.com/en/docs/basis/function/events).
#endif  // end: __MQL5__

/* Custom EA functions */

/**
 * Init strategies.
 */
bool InitStrategies() {
  bool _res = ea_exists;
  int _magic_step = FINAL_ENUM_TIMEFRAMES_INDEX;
  long _magic_no = EA_MagicNumber;
  ResetLastError();
  // Initialize strategies per timeframe.
  ea.StrategyAddToTfs(Strategy_M1, 1 << M1);
  ea.StrategyAddToTfs(Strategy_M5, 1 << M5);
  ea.StrategyAddToTfs(Strategy_M15, 1 << M15);
  ea.StrategyAddToTfs(Strategy_M30, 1 << M30);
  ea.StrategyAddToTfs(Strategy_H1, 1 << H1);
  ea.StrategyAddToTfs(Strategy_H2, 1 << H2);
  ea.StrategyAddToTfs(Strategy_H3, 1 << H3);
  ea.StrategyAddToTfs(Strategy_H4, 1 << H4);
  ea.StrategyAddToTfs(Strategy_H6, 1 << H6);
  ea.StrategyAddToTfs(Strategy_H8, 1 << H8);
  ea.StrategyAddToTfs(Strategy_H12, 1 << H12);
  // Update lot size.
  ea.Set(STRAT_PARAM_LS, EA_LotSize);
#ifdef __advanced__
  ea.Set(STRAT_PARAM_SOFM, EA_SignalOpenFilterMethod);
  ea.Set(STRAT_PARAM_SCFM, EA_SignalCloseFilterMethod);
  ea.Set(STRAT_PARAM_SOFT, EA_SignalOpenFilterTime);
  ea.Set(STRAT_PARAM_TFM, EA_TickFilterMethod);
  ea.Set(STRUCT_ENUM(EAParams, EA_PARAM_PROP_SIGNAL_FILTER), EA_SignalOpenStrategyFilter);
#ifdef __rider__
  // Disables strategy defined order closures for Rider.
  ea.Set(STRAT_PARAM_OCL, 0);
  ea.Set(STRAT_PARAM_OCP, 0);
  ea.Set(STRAT_PARAM_OCT, 0);
  // Init price stop methods for all timeframes.
  ea.StrategyAddStops(NULL, EA_Stops_Strat, EA_Stops_Tf);
#else
  ea.Set(STRAT_PARAM_OCL, EA_OrderCloseLoss);
  ea.Set(STRAT_PARAM_OCP, EA_OrderCloseProfit);
  ea.Set(STRAT_PARAM_OCT, EA_OrderCloseTime);
  // Init price stop methods for each timeframe.
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_M1), EA_Stops_M1, PERIOD_M1);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_M5), EA_Stops_M5, PERIOD_M5);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_M15), EA_Stops_M15, PERIOD_M15);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_M30), EA_Stops_M30, PERIOD_M30);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_H1), EA_Stops_H1, PERIOD_H1);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_H2), EA_Stops_H2, PERIOD_H2);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_H3), EA_Stops_H3, PERIOD_H3);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_H4), EA_Stops_H4, PERIOD_H4);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_H6), EA_Stops_H6, PERIOD_H6);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_H8), EA_Stops_H8, PERIOD_H8);
  _res &= ea.StrategyAddStops(ea.GetStrategyViaProp<int>(STRAT_PARAM_TF, PERIOD_H12), EA_Stops_H12, PERIOD_H12);
#endif                                                    // __rider__
#endif                                                    // __advanced__
  _res &= GetLastError() == 0 || GetLastError() == 5053;  // @fixme: error 5053?
  ResetLastError();
  return _res && ea_configured;
}

/**
 * Deinitialize global class variables.
 */
void DeinitVars() { Object::Delete(ea); }
