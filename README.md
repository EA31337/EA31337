# EA31337

[![Release][github-release-image]][github-release-link]
[![Channel][tg-channel-image]][tg-channel-link]
[![Status][gha-image-check-master]][gha-link-check-master]
[![Status][gha-image-test-master]][gha-link-test-master]
[![Status][gha-image-backtest-master]][gha-link-backtest-master]
[![Edit][gitpod-image]][gitpod-link]
[![License][license-image]][license-link]

## Introduction

EA31337 is an advanced trading robot for Forex markets written in MQL.

## About the project

The project aims to deliver fully working EA at the professional level
with code compability for MQL4 and MQL5 at the same time.

It implements algorithms for managing multiple strategies on different timeframes at once.

Please follow [Wiki Home page](https://github.com/EA31337/EA31337/wiki) for the available documentation pages.

This project utilizes the following sub-projects:

- [EA31337 framework][gh-repo-classes]
- [EA31337 strategies][gh-repo-strats]

### Disclamer

The project has been published for free (check [License](#LICENSE)) after _MQL5 Ltd_ decided to remove this EA
from their [marketplace](https://www.mql5.com/en/market) with all associated seller accounts for no apparent reason,
a day after network of [scam brokers][scam-broker-se-link] has been reported at their _Service Desk_.
These scam brokers still appearing on their live MT4 app, about which they really don't care much
(as long as the scammers pay them for the licence), so please be careful.
For that reason, I've stopped using MetaTrader platform for my daily trading,
apart of the time when maintaining this project.
For more details, please read the following [FPA court submission][scam-broker-fpa-link] (guilty case).

### Usage

You can freely use this project for education or research purposes.
If you're planning to use it for trading, please take care, as neither it is the holy grail or making money machine.
So if you're looking to double your investment in a short period with few clicks, this is not what you're looking for,
and most likely you won't find holy grail anywhere else.

To use this project most efficiently, you'll have to invest some time to understand how it works and how you can use it.

To learn more about the usage, please check our [Wiki pages](https://github.com/EA31337/EA31337/wiki).

### Features

The EA provides the following out-of-box features:

- Over 35 optimised strategies on four different timeframes analysing the market in real-time.

### Strategies

The robot comes with over 35 strategies coordinated and controlled by the central algorithm.
Each strategy analyses market on multiple timeframes at the same time.
The market analysis is based on over 30 major technical indicators in real-time.

### Profit/Stop Trailing system

This unique profit-stop trailing system auto-controls when to take profit
or when to close the order by specific market conditions based on the technical indicator analysis.

### Open Method System

The unique conditional system manages trades per given strategy and state of its technical indicators.
In other words, each strategy uses unique configuration of technical indicators and conditions to buy and sell signals.

### Using & Testing

Please be strongly aware that combination of symbol pair, broker, their market gaps and market spreads
can give completely results when trading variety of robots.
The EA tries its best to detect the perfect conditions for its trading, however you need to backtest the robot first
(or test it on demo account), before going into deep waters.
We keep testing, optimizing and improving our bot, but it takes months and years to achieve the perfect shape.

### Important tips

When using this EA for the trading purposes, please read the following tips:

- Take your time to get familiar with the project and how it works.
- Make sure you have tested EA on the demo account first (at least for few weeks).
- It is advised to backtest your configuration before running on live account (see [Testing](#TESTING) section).
- Choose your broker wisely to make sure EA will work as expected. For example:
  - Be aware of your broker spreads and commissions, otherwise high spreads can easily kill your account,
    no matter how good EA is.
  - Start with with the smaller deposit first (use account supporting micro lots, otherwise change your broker)
    to test the broker, market and EA configuration as the whole.
  - Do not use EA in accounts with spreads above 20 points (2 pips) without proper backtesting
    or good results in the demo account, unless risking affordable minimum (micro lots).
  - Be aware that some brokers dynamically sets very high spreads (over 100) when the market is volatile,
    so best opportunity for EA could turn into the worse. In this case, you should blame broker, not EA.
  - Do not use brokers which doesn't allow hedging positions. The EA has not been tested for it.
  - Watch out for brokers who steal pips by closing orders at a price which is less favourable to you by 1-2 pips
    which can reduce the profits made by EA.
- It's recommended to use VPS in order to run EA reliabily (24/7) as often restarts of EA
  or a trading terminal while trades are opened can drastically affect the expected results.
- Ensure to provide a stable internet connection to achieve reliable operation of EA as slow network
  or short disruptions may significantly impact the performance.
- While running on live, keep monitoring your account (e.g. for any warnings/errors in the logs).
- Do not increase any lot size or risk criteria if your tradings are going well.
  The EA will automatically adjust it when needed based on your available balance.
- Be aware that potential profits can be matter of weeks, not days, so please be patient.
  The configuration could be right, but it's about finding a good opportunity.
- Use major symbol pairs (such as EURUSD, GBPUSD, etc), the one which has been tested.

For more important tips, refer to [Before you start][gh-wiki-start] wiki page.

## Installation

For installation steps, refer to [Installation][gh-wiki-installation] wiki page.

### Compilation

For compilation steps, refer to [Compilation](https://github.com/EA31337/EA31337/wiki/Compilation) wiki page.

## Configuration

The default settings has been optimized for EURUSD symbol pair.

There are many of adjustable inputs that you can set. These are documented in a separate provided file.

If you planning to run EA on variety of symbol pairs,
it is strongly advised that you should test it on the demo first,
alternatively backtest and optimize the settings first.
Only run EA on live at your own risk, when you're happy with the backtest or results on the demo account.

### Timeframe

For the trading purposes, any timeframe can be used since EA reads data from multiple timeframes
independently from the current chart.

### Input parameters

Input parameters has been documented at the following pages:

- [Input parameters](https://github.com/mycognitive/ea31337/wiki/Input-parameters)
- [Open methods](https://github.com/mycognitive/ea31337/wiki/Open-methods)

## Testing

### Backtesting

Please be aware that backtesting is a very complex process and due to several MetaTrader 4 platform limitations,
it cannot reliabily simulate the outcome.

The backtesting has been documented at [Backtesting using MT4][gh-wiki-backtest] wiki page.

Few notes to be aware when backtesting:

- Please use M30 or M15 timeframe to have access to multiple timeframes at the same time,
  as sometimes not all strategies would be activated (check the logs for details).
  This is due to platform limitations/bugs.
- Be aware that using [Birt's CSV2FXT.mq4](https://github.com/EA31337/Birt-CSV2FXT) script
  to generate FXT files is [outdated](https://eareview.net/tick-data/faq-troubleshooting) method
  and [buggy](https://github.com/EA31337/Birt-CSV2FXT/issues/3).
- There is no such thing as 99% modelling quality.
  It's a fake [hardcoded number](https://github.com/EA31337/MT-Formats/blob/master/fxt-405-refined.mqh#L53)
  when your FXT files are read-only and it's often used by scammers as a selling point.
- It's better to not set FXT/HST files as read-only, otherwise platform has no ability to validate
  and correct the data. When you force platform to use corrupted data, you get non-reliable results.
- When using generated FXT/HST files, run tests in off-line mode in order to not overlap your broker data
  onto your existing data, otherwise you get data errors, then you'd need to start from scratch.

### SET Files

By default, EA provides the best optimized settings for EURUSD symbol pair
based on the performed optimization tests.

## Documentation

Documentation can be found at the [wiki page][gh-wiki].
If you believe some information is outdated, you can propose new changes.

## Support

- For help, open a [new discussion][gh-discuss] to ask questions.
- For bugs/features, raise a [new issue at GitHub][gh-issues].
- Join our [Telegram channel][tg-channel-link] for news and discussion group for help.

## Legal

### License

The project is released under [GNU GPLv3 licence](https://www.gnu.org/licenses/quick-guide-gplv3.html),
so that means the software is copyrighted, however you have the freedom to use, change or share the software
for any purpose as long as the modified version stays free. See: [GNU FAQ](https://www.gnu.org/licenses/gpl-faq.html).

You should have received a copy of the GNU General Public License along with this program
(check the [LICENSE](https://github.com/EA31337/EA31337/blob/master/LICENSE) file).
If not, please read <http://www.gnu.org/licenses/>.
For simplified version, please read <https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)>.

## Terms of Use

By using EA31337, you understand and agree that we (company and author)
are not be liable or responsible for any loss or damage due to any reason.
Although every attempt has been made to assure accuracy,
we do not give any express or implied warranty as to its accuracy.
We do not accept any liability for error or omission.

You acknowledge that you are familiar with these risks
and that you are solely responsible for the outcomes of your decisions.
We accept no liability whatsoever for any direct or consequential loss arising from the use of this product.
You understand and agree that past results are not necessarily indicative of future performance.

Use of EA31337 trading robot serves as your acknowledgement and representation that you have read and understand
these TERMS OF USE and that you agree to be bound by such Terms of Use ("License Agreement").

### Copyright information

Copyright © 2016-2021 - EA31337 Ltd - All Rights Reserved

Author & Publisher: kenorb at EA31337 Ltd.

### Disclaimer and Risk Warnings

Trading any financial market involves risk.
All forms of trading carry a high level of risk so you should only speculate with money you can afford to lose.
You can lose more than your initial deposit and stake.
Please ensure your chosen method matches your investment objectives,
familiarize yourself with the risks involved and if necessary seek independent advice.

NFA and CTFC Required Disclaimers:
Trading in the Foreign Exchange market as well as in Futures Market and Options or in the Stock Market
is a challenging opportunity where above average returns are available for educated and experienced investors
who are willing to take above average risk.
However, before deciding to participate in Foreign Exchange (FX) trading or in Trading Futures, Options or stocks,
you should carefully consider your investment objectives, level of experience and risk appetite.
**Do not invest money you cannot afford to lose**.

CFTC RULE 4.41 - HYPOTHETICAL OR SIMULATED PERFORMANCE RESULTS HAVE CERTAIN LIMITATIONS.
UNLIKE AN ACTUAL PERFORMANCE RECORD, SIMULATED RESULTS DO NOT REPRESENT ACTUAL TRADING.
ALSO, SINCE THE TRADES HAVE NOT BEEN EXECUTED, THE RESULTS MAY HAVE UNDER-OR-OVER COMPENSATED FOR THE IMPACT,
IF ANY, OF CERTAIN MARKET FACTORS, SUCH AS LACK OF LIQUIDITY. SIMULATED TRADING PROGRAMS IN GENERAL
ARE ALSO SUBJECT TO THE FACT THAT THEY ARE DESIGNED WITH THE BENEFIT OF HINDSIGHT.
NO REPRESENTATION IS BEING MADE THAN ANY ACCOUNT WILL OR IS LIKELY TO ACHIEVE PROFIT OR LOSSES SIMILAR TO THOSE SHOWN.

<!-- Named links -->

[gh-wiki]: https://github.com/EA31337/EA31337/wiki
[gh-wiki-start]: https://github.com/EA31337/EA31337/wiki/Before-you-start
[gh-wiki-installation]: https://github.com/EA31337/EA31337/wiki/Installation
[gh-wiki-backtest]: https://github.com/EA31337/EA3133-Support/wiki/Backtesting-using-MT4

[github-release-image]: https://img.shields.io/github/release/EA31337/EA31337.svg?logo=github
[github-release-link]: https://github.com/EA31337/EA31337/releases

[tg-channel-image]: https://img.shields.io/badge/Telegram-join-0088CC.svg?logo=telegram
[tg-channel-link]: https://t.me/EA31337

[gha-link-check-master]: https://github.com/EA31337/EA31337/actions?query=workflow%3ACheck+branch%3Amaster
[gha-image-check-master]: https://github.com/EA31337/EA31337/workflows/Check/badge.svg?branch=master
[gha-link-test-master]: https://github.com/EA31337/EA31337/actions?query=workflow%3ATest+branch%3Amaster
[gha-image-test-master]: https://github.com/EA31337/EA31337/workflows/Test/badge.svg?branch=master
[gha-link-backtest-master]: https://github.com/EA31337/EA31337/actions?query=workflow%3ABacktest+branch%3Amaster
[gha-image-backtest-master]: https://github.com/EA31337/EA31337/workflows/Backtest/badge.svg?branch=master

[gitpod-image]: https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod
[gitpod-link]: https://gitpod.io/#https://github.com/EA31337/EA31337

[gh-repo-classes]: https://github.com/EA31337/EA31337-classes
[gh-repo-strats]: https://github.com/EA31337/EA31337-strategies

[gh-discuss]: https://github.com/EA31337/EA31337/discussions
[gh-issues]: https://github.com/EA31337/EA31337/issues

[license-image]: https://img.shields.io/github/license/EA31337/EA31337.svg
[license-link]: https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)

[scam-broker-se-link]: https://money.stackexchange.com/q/91732/6888
[scam-broker-fpa-link]: https://www.forexpeacearmy.com/community/threads/guilty-case-2018-060-kenorb-vs-tradeu2-com.54563/#post-312721
