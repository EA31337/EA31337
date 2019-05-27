# Introduction

[![](https://img.shields.io/github/release/EA31337/EA31337.svg?logo=github)](https://github.com/EA31337/EA31337/releases)
[![](https://img.shields.io/badge/news-Telegram-0088CC.svg?logo=telegram)](https://t.me/EA31337_News)
[![](https://img.shields.io/badge/chat-Telegram-0088CC.svg?logo=telegram)](https://t.me/EA31337)
[![](https://img.shields.io/github/license/EA31337/EA31337.svg)](https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3))

Introducing EA31337, an advanced trading robot on the market written in MQL.

It takes the currency trading on the next level by implementing the coordinated algorithm which prioritising and managing multi-timeframe strategies. With fully user customizable parameters, it makes real-time trading a hassle-free experience.

Please follow [Wiki Home page](https://github.com/EA31337/EA31337/wiki) for the available documentation pages.

## Build status

| Type            | Status      |
| --------------: |:-----------:|
| Travis CI build | [![Build Status](https://api.travis-ci.org/EA31337/EA31337.svg?branch=master)](https://travis-ci.org/EA31337/EA31337) |
| AppVeyor build  | [![Build status](https://ci.appveyor.com/api/projects/status/63qnd959vxl44102?svg=true)](https://ci.appveyor.com/project/kenorb/ea31337/branch/master) |

## About the project

The project aims to deliver fully working EA at the professional level to be compatible with both MQL4 and MQL5 at the same time.

Ideally, you should use this project for education or research purposes. However, if you're still planning to use it for trading, please take care, as neither it is the holy grail or making money machine. So if you're looking to double your investment in a short period with few clicks, this is not what you're looking for, and most likely you won't find it anywhere else. Therefore, to use this project most efficiently, you'll have to invest some time to understand how it works and how you can use it.

The project has been published for free (see [License](#LICENSE)) after _MQL5 Ltd_ decided to remove this EA from their [marketplace](https://www.mql5.com/en/market) with all associated seller accounts for no apparent reason, a day after network of [scam brokers](https://money.stackexchange.com/q/91732/6888) has been reported at their _Service Desk_. These scam brokers still appearing on the MT4 app, so please be careful.

# Features

The EA provides the following out-of-box features:

- Over 30 optimised strategies on four different timeframes analysing the market in real-time.
- An exceptional number of customizable user parameters (over 300).
- Task scheduler which queues and re-trades the rejected trades due to high volatility or broker requotes.
- Trade tasker prioritises trading according to high demand or market limits.
- Trade booster can increase lot ratio for successful strategies over current week or month.
- Trade booster can also handicap or disable non-successful strategy for a temporary period.
- Risk Ratio manages your risk automatically for the given equality/balance and the market conditions.
- Lot balancer computes precisely how much to invest (contract size) given your equality/balance ratio.
- Order balancer knows exactly how many trades to open given your balance, opened trades, Stop Out levels and market conditions (Risk Ratio).
- Optional _TradeWithTrend_ parameter minimalizes the risk by trading with market trend only.
- Profit/stop trailing system dynamically sets order limits based on the market conditions (learn more below).
- The powerful OpenMethod system enhances technical indicators and trades only on prosperous market conditions (learn more below).
- The powerful condition-action system gives you the full control what to do on specific market condition (learn more below).

## Strategies

The robot comes with over 30 optimised strategies coordinated and controlled by the central algorithm (engine). Each strategy analyses market on multiple timeframes (M1-M30) at the same time. The business analysis is based on over 30 major technical indicators on real-time (on the tick level).

## Profit/Stop Trailing system

This unique profit-stop trailing system auto-controls when to take profit or when to close the order by specific market conditions based on the technical indicator analysis.

Few examples of the conditionally controlled trailing system:

- It can close the trade when the price reached higher highs of 50-200 bars.
- It can close the order when specific indicator (out of 30) reached its peak.
- It can close the trade when resistance level is reached.
- It can set the order stop loss between low and high of last 200 bars.
- It can set the order stop the same as slow moving average plus 20 pips.
- It can take the profit when the price reaches SAR reversal points.
- It can keep profit/stop trailings always 20 pips outside of upper and lower Bollinger Bands.

There are over 27 possible trailing configurations.

## Open Method System

The unique conditional system which decides when to trade based on the given strategy and state of technical indicators. In other words, each strategy uses unique configuration of technical indicators and conditions to buy and sell signals. Few examples:

  - lower/higher Bands are reached, but signal could only happen when the price will close outside or inside of bands (128 different combinations of raising signal only for Bands),
  - RSI is reached certain level, but raise the signal only when the 3 last bars are beyond that limit to avoid false signals (along with other 32 possible combinations),
  - raise SAR signal when previous SAR confirmed it (along with other similar 64 combinations),
  - and so on, which gives thousands of possibilities optimized on demand by our cloud system.

## Condition-Action system

Take the full control of your investments by creating own custom rules.

Few examples of such rules:

- React on big market drops in real-time, e.g. by closing all losing trades as soon as possible.
- If equality is higher than 20% or 50%, close the profitable trade.
- If equality is lower than 20%, get rid of most risking trades to prevent big drawdown.
- If market goes opposite, close the most profitable position.
- Relax and invest less after most profitable day of the month.
- Close most profitable trade when your margin is used in 80-90%.
- When Stop Out level is reached, close the most non-or-profitable position to avoid broker's Margin Call!
- When equality is 20% above the balance, close all in profit only when the market goes opposite.
- When market trend changes, close all non-trend positions,
- Close profitable positions when your account reached max orders.

There are over 27 account conditions, 14 market conditions and 11 actions to perform, which makes over 4000 condition-action possibilities.

## Using & Testing

Please be strongly aware that combination of symbol pair, broker, their market gaps and market spreads can give completely results when trading variety of robots. Our robot tries its best to detect the perfect conditions for its trading, however you need to backtest the robot first (or test it on demo account), before going into deep waters. We keep testing, optimizing and improving our bot, but it takes months and years to achieve the perfect shape. Our cloud system constantly improves the settings depending on the new findings, therefore it's strongly advised that you can have a look at our ready-to-use SET files available at https://github.com/EA31337/EA31337-Sets, since default settings of EA could not always work as expected.

## Important advice

If you decide to use this EA for the trading purposes, please use it responsively by following below advises to avoid any surprices.

* Take your time to get familiar with the product and its settings as it's not one of these turn-on-and-forget projects.
* Please backtest your configuration before running on live (see [Testing](#TESTING) section), otherwise try on the demo account first.
* Choose your broker wisely to make sure EA will work as expected. For example:
  - Be aware of your broker spreads and commissions, otherwise high spreads can easily kill your account, no matter how good EA is.
  - For the first weeks, trade with smallest deposit as possible (e.g. trade on micro lots if broker allows it, otherwise use a different one) just to test the broker, market and EA configuration as a whole.
  - Do not use EA in accounts with spreads above 20 points without proper backtesting or good results in the demo account, unless risking affordable minimum (micro lots).
  - Be aware that some brokers dynamically sets very high spreads (over 100) when the market is volatile, so best opportunity for EA could turn into the worse. In this case, you should blame broker, not EA.
  - Do not use brokers which doesn't allow hedging positions. The EA has not been tested for it.
  - Watch out for brokers who steal pips by closing orders at a price which is less favourable to you by 1-2 pips which can reduce the profits made by EA.
* It's recommended to use VPS in order to run EA reliabily (24/7) as often restarts of EA or a trading terminal while trades are opened can drastically affect the expected results.
* Ensure to provide a stable internet connection to achieve reliable operation of EA as slow network or short disruptions may significantly impact the performance.
* While running on live, keep monitoring your account (e.g. for any warnings/errors in the logs).
* Do not increase any lots or risk criteria if your tradings are going well as EA will automatically adjust it when needed based on your available balance.
* Be aware that potential profits can be matter of weeks, not days, so please be patient. The configuration could be right, but it's about finding a good opportunity.
* Use major symbol pairs (such as EURUSD, GBPUSD, etc), the one which has been tested.

# Installation

## MetaTrader 4 platform

1. Download MetaTrader platform from your broker's site, alternatively from www.metaquotes.net.

   a. Once on the site, click on MetaTrader 4, then on Trading Terminal.
   a. At the bottom, click on Download MetaTrader 4 Terminal button.

   Alternatively click this [direct link](https://download.mql5.com/cdn/web/metaquotes.software.corp/mt4/mt4setup.exe) to start download.

1. Install platform by running its executable file and follow the steps of the installation wizzard.

1. After completing installation, the Terminal window should be shown and you will be asked to create a demo account. So you may fill in the details and select the deposit amount of your account, otherwise please log-in to your existing account.

## Installation of EA

1. Run MetaTrader 4 Trading Terminal.
1. Click *File, Open Data Folder* in a top menu bar.
1. Copy provided *EX4* or *EX5* file into that opened folder (MQL4/Experts).
<sup>Note: Check [_Releases_](https://github.com/EA31337/EA31337/releases) tab for compiled EX4 files.</sup>
1. Click *Tools*, *Options*, and in *Expert Advisors* tab please enable *Allow automated trading* and *Allow DLL imports* to activate automated trading on your account, then click *OK*.
1. Click *File, New Chart* and *EURUSD* (recommended). You may switch any timeframe (e.g. M1).
1. Now in *Navigator* window attach *EA31337* to a chart either from contextual menu, or alternatively simply drag EA onto the chart (if you don't see EA yet, *Refresh* or restart your terminal).
1. *Expert* pop-up should appear, so the following options are mandatory to set-up:

    a. in *Common* tab: *Allow live trading* & *Allow DLL imports*
    b. in *Inputs* tab, please enter your *E-Mail* and *License* by clicking on *Value* column and confirming by *Tab* or *Enter*
1. Now you should have smiley face in the upper right hand corner of your chart which means your EA is up and running, otherwise if your EA is reporting invalid parameters, please repeat steps 5-6.
1. You can enable or disable EA at any time by clicking AutoTrading button in upper bar.

## Compilation

For compilation steps, refer to [Compilation](https://github.com/EA31337/EA31337/wiki/Compilation) wiki page.

# Configuration

The default settings has been optimized for EURUSD symbol pair.

There are many of adjustable inputs that you can set. These are documented in a separate provided file.

If you planning to run EA on variety of symbol pairs, it is strongly advised that you should test it on the demo first, alternatively backtest and optimize the settings first. Only run EA on live at your own risk, when you're happy with the backtest or results on the demo account.

## Timeframe

For the trading purposes, any timeframe can be used since EA reads data from multiple timeframes independently from the current chart. However, due to platform limitations, the M30 should be used when backtesting or optimizing.

## Input parameters

Input parameters has been documented at the following pages:

- [Input parameters](https://github.com/mycognitive/ea31337/wiki/Input-parameters)
- [Open methods](https://github.com/mycognitive/ea31337/wiki/Open-methods)

# Testing

## Backtesting

Please be aware that backtesting is a very complex process and due to several MetaTrader 4 platform limitations, it cannot reliabily simulate the outcome.

The backtesting has been documented at [Backtesting using MT4](https://github.com/EA31337/EA3133-Support/wiki/Backtesting-using-MT4) wiki page.

Few notes to be aware when backtesting:

- Please use M30 or M15 timeframe to have access to multiple timeframes at the same time, as sometimes not all strategies would be activated (check the logs for details). This is due to platform limitations/bugs.
- Be aware that using [Birt's CSV2FXT.mq4](https://github.com/EA31337/Birt-CSV2FXT) script to generate FXT files is [outdated](https://eareview.net/tick-data/faq-troubleshooting) method and [buggy](https://github.com/EA31337/Birt-CSV2FXT/issues/3).
- There is no such thing as 99% modelling quality. It's a fake [hardcoded number](https://github.com/EA31337/MT-Formats/blob/master/fxt-405-refined.mqh#L53) when your FXT files are read-only and it's often used by scammers as a selling point.
- It's better to not set FXT/HST files as read-only, otherwise platform has no ability to validate and correct the data. When you force platform to use corrupted data, you get non-reliable results.
- When using generated FXT/HST files, run tests in off-line mode in order to not overlap your broker data onto your existing data, otherwise you get data errors, then you'd need to start from scratch.

## SET Files

By default, EA provides the best optimized settings for EURUSD symbol pair based on the performed optimization tests. If you'd like to experiment more, some optimization SET files can be found at [EA31337-Lite-Sets](https://github.com/EA31337/EA31337-Lite-Sets) repository.

# Documentation

Documentation can be found at the [wiki page](https://github.com/EA31337/EA31337/wiki). If you believe some information is outdated, you can propose new changes.

# Support

If you having any problems or questions, please [raise a support ticket](https://github.com/EA31337/EA3133-Support/issues/new) or join our [Telegram](https://t.me/EA31337) group.

# Terms of Use

By using EA31337, you understand and agree that we (company and author) are not be liable or responsible for any loss or damage due to any reason. Although every attempt has been made to assure accuracy, we do not give any express or implied warranty as to its accuracy. We do not accept any liability for error or omission.

You acknowledge that you are familiar with these risks and that you are solely responsible for the outcomes of your decisions. We accept no liability whatsoever for any direct or consequential loss arising from the use of this product. You understand and agree that past results are not necessarily indicative of future performance.

Use of EA31337 trading robot serves as your acknowledgement and representation that you have read and understand these TERMS OF USE and that you agree to be bound by such Terms of Use ("License Agreement").

## License

The project is released under [GNU GPLv3 licence](https://www.gnu.org/licenses/quick-guide-gplv3.html), so that means the software is copyrighted, however you have the freedom to use, change or share the software for any purpose as long as the modified version stays free. See: [GNU FAQ](https://www.gnu.org/licenses/gpl-faq.html).

You should have received a copy of the GNU General Public License along with this program (check the [LICENSE](https://github.com/EA31337/EA31337/blob/master/LICENSE) file).  If not, see <http://www.gnu.org/licenses/>.

### Copyright information

Copyright © 2016 – 31337 Investments Ltd. - All Rights Reserved

Author & Publisher: kenorb at 31337 Investments Ltd.

## Disclaimer and Risk Warnings

Trading any financial market involves risk. All forms of trading carry a high level of risk so you should only speculate with money you can afford to lose. You can lose more than your initial deposit and stake. Please ensure your chosen method matches your investment objectives, familiarize yourself with the risks involved and if necessary seek independent advice.

NFA and CTFC Required Disclaimers: Trading in the Foreign Exchange market as well as in Futures Market and Options or in the Stock Market is a challenging opportunity where above average returns are available for educated and experienced investors who are willing to take above average risk. However, before deciding to participate in Foreign Exchange (FX) trading or in Trading Futures, Options or stocks, you should carefully consider your investment objectives, level of experience and risk appetite. Do not invest money you cannot afford to lose.

CFTC RULE 4.41 - HYPOTHETICAL OR SIMULATED PERFORMANCE RESULTS HAVE CERTAIN LIMITATIONS. UNLIKE AN ACTUAL PERFORMANCE RECORD, SIMULATED RESULTS DO NOT REPRESENT ACTUAL TRADING. ALSO, SINCE THE TRADES HAVE NOT BEEN EXECUTED, THE RESULTS MAY HAVE UNDER-OR-OVER COMPENSATED FOR THE IMPACT, IF ANY, OF CERTAIN MARKET FACTORS, SUCH AS LACK OF LIQUIDITY. SIMULATED TRADING PROGRAMS IN GENERAL ARE ALSO SUBJECT TO THE FACT THAT THEY ARE DESIGNED WITH THE BENEFIT OF HINDSIGHT. NO REPRESENTATION IS BEING MADE THAN ANY ACCOUNT WILL OR IS LIKELY TO ACHIEVE PROFIT OR LOSSES SIMILAR TO THOSE SHOWN.
