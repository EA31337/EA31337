## Introduction

Introducing the most advanced EA trading robot on the market.

Please follow [Wiki link](https://github.com/EA31337/EA31337-Wiki/wiki) to start.


## Overview

The **EA31337** trading robot is taking the currency trading on the next level by providing coordinated multi-timeframe complex algorithms and rule system which makes trading 24/7 very simple experience.

## Features

The EA provides the following out-of-box features:

- over 30x4 optimized strategies coordinated and working as one single algorithm,
  - each strategy analyses market on multiple timeframes (M1-M30),
  - over 30 major technical indicators tested and analysed on real-time (every single tick),
  - exceptional number of customizable user parameters (over 300),
  - task scheduler which queues and re-trades the rejected trades due to high volatility or broker requotes,
  - trade prioritiser prioritise trading according to high demand or market limits,
  - trade booster is able to increase lot ratio for successful strategies over current week or month,
  - trade booster can also handicap or disable non-successful strategies for temporary period,
  - Risk Ratio manages automatically your risk for the given equality/balance and the market conditions,
  - lot balancer knows exactly how much to invest (contract size) given your equality/balance ratio,
  - order balancer knows exactly how many trades to open given your balance, opened trades, Stop Out levels and market conditions (Risk Ratio),
  - optional TradeWithTrend parameter minimalize the risk by trading with market trend only,
  - profit/stop trailing system dynamically sets order limits based on the market conditions (learn more below),
  - powerful OpenMethod system enhances technical indicators and trades only on successful market conditions (learn more below),
  - powerful condition-action system gives you the full control what to do on specific market condition (learn more below),

### Profit/Stop Trailing system

  This unique profit-stop trailing system auto-controls when to take profit or when to close the order by specific market conditions based on the technical indicator analysis. Few examples:

  - close trade when price reached higher highs of 50-200 bars,
  - close the order when specific indicator (out of 30) reached its peak,
  - close trade when resistance level is reached,
  - set the order stop loss between low and high of last 200 bars,
  - set the order stop the same as slow moving average plus 20 pips,
  - set profit trailing system when the price reaches SAR reversal points,
  - keep profit/stop trailings always 20 pips outside of upper and lower Bollinger Bands,
  - and many other (over 27 possible trailing configurations).

### Open Method system

  Unique conditional system which decides when to trade based on the given strategy and state of technical indicators. In other words each strategy uses unique configuration of technical indicators and conditions to indicate buy and sell signals. Few examples:

  - lower/higher Bands are reached, but signal could only happen when the price will close outside or inside of bands (128 different combinations of raising signal only for Bands),
  - RSI is reached certain level, but raise the signal only when the 3 last bars are beyond that limit to avoid false signals (along with other 32 possible combinations),
  - raise SAR signal when previous SAR confirmed it (along with other similar 64 combinations),
  - and so on, which gives thousands of possibilities optimized on demand by our cloud system.

### Condition-Action system

  Take the full control of your investments by creating own custom rules, e.g.:

  - react on big market drops in real-time, e.g. by closing all losing trades as soon as possible,
  - if equality is higher than 20% or 50%, close the profitable trade,
  - if equality is lower than 20%, get rid of most risking trades to prevent big drawdown,
  - if market goes opposite, close the most profitable position,
  - relax and invest less after most profitable day of the month,
  - close most profitable trade when your margin is used in 80-90%,
  - when Stop Out level is reached, close the most non-or-profitable position to avoid broker's Margin Call!,
  - when equality is 20% above the balance, close all in profit only when the market goes opposite,
  - when market trend changes, close all non-trend positions,
  - close profitable positions when your account reached max orders,
  - and many more (over 27 account conditions x 14 market conditions x 11 action types).


### Important advise

  Please trade responsively and follow the following rules to avoid any surprices:

  - take some time to get familiar with the product and its settings (it's not just a matter of On-and-forget button),
  - please backtest your robot before using (see Using & Testing section) or try on demo account first,
  - if you're beginner, always trade on micro lots (if broker allows it, otherwise change the broker),
  - do not increase any lots or risk criteria if your tradings are going well (EA will do that automatically when needed),
  - please investigate your broker spreads, commisions and their market gaps before starting, otherwise high spreads can easily kill your account,
  - do not use brokers which doesn't allow hedging positions,
  - do not use EA in accounts with spreads above 20 points, without proper backtesting and proof of concept (we're working on the version which would work better with high spreads),
  - trade in long-term, never short-term, as satisfatory profits can be a matter of weeks or months,
  - please do not blame robot for thievish spreads of your broker which no EA could deal with in long-term (please change your broker if that's the case).

### Using & Testing

  Please be strongly aware that combination of symbol pair, broker, their market gaps and market spreads can give completely results when trading variety of robots. Our robot tries its best to detect the perfect conditions for its trading, however you need to backtest the robot first (or test it on demo account), before going into deep waters. We keep testing, optimizing and improving our bot, but it takes months and years to achieve the perfect shape. Our cloud system constantly improves the settings depending on the new findings, therefore it's strongly advised that you can have a look at our ready-to-use SET files available at https://github.com/EA31337/EA31337-Sets, since default settings of EA could not always work as expected.

### Configuration

  Apart of configuration settings mentioned above, you can find full documentation of all settings at https://github.com/EA31337/EA31337-Wiki/wiki

### Support

  If you need any help, more information, requesting bugs, features or simply give some feedback, please join our chat at gitter or raise a new ticket at https://github.com/EA31337/EA3133-Support, we would love to hear from you about our product and how we can improve it.
