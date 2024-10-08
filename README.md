# EA31337

[![Release][github-release-image]][github-release-link]
[![Status][gha-image-check-master]][gha-link-check-master]
[![Status][gha-image-test-master]][gha-link-test-master]
[![Status][gha-image-backtest-master]][gha-link-backtest-master]
[![Discuss][gh-discuss-badge]][gh-discuss-link]
[![Channel][tg-channel-image]][tg-channel-link]
[![X][x-pimage]][x-plink]
[![X][x-cimage]][x-clink]
[![License][license-image]][license-link]
[![Edit][gh-edit-badge]][gh-edit-link]

## Introduction

EA31337 is a free and open-source Forex autonomous trading robot
designed for the MetaTrader 4 and 5 (MT4/MT5) platforms.

## About the project

EA31337 provides a comprehensive framework for traders to develop, test, and automate their trading strategies.

It leverages the capabilities of MetaTrader platforms, including the MQL
programming language, backtesting, optimization, and automation features for
executing trading robots.

The aim of the project is to implement a wide array of technical analysis
strategies and custom indicators, facilitating the development of robust
trading systems.

Read more: [About](https://github.com/EA31337/EA31337/wiki/About).

## Features

See: [Features](https://github.com/EA31337/EA31337/wiki/Features).

## Best practises

See: [Best practices](https://github.com/EA31337/EA31337/wiki/Best-practices).

### Key Best Practices

See: [Best practices](https://github.com/EA31337/EA31337/wiki/Best-practices).

## Important Considerations Before Use

See: [IMPORTANT NOTES](https://github.com/EA31337/EA31337/wiki/IMPORTANT-NOTES).

## Documentation and usage

Documentation can be found at the [wiki page][gh-wiki].

### Customization

The default parameters are optimized for EURUSD symbol pair. However, there are
many adjustable inputs allowing customization across symbols.

These configuration options are documented on [Input parameters wiki
page][gh-wiki-inputs]. Modifications can optimize performance for alternate
currency pairs when rigorously backtested.

We strongly advise thorough demo testing or backtesting before attempting live
trading with new settings. Each symbol and broker combination can behave
differently. Optimize parameter changes carefully based on evidence from
extensive simulations across diverse market conditions.

Live execution should only be considered once the risk-adjusted profile proves
robust during demo trading or backtesting. Please trade live at your own risk,
only with full confidence in the strategy's integrity across settings,
brokers, and pairs based on your own rigorous testing.

### SET files

The SET files represent the best performing input values found during
pre-release optimization testing.

The EA ships already with optimized parameter files tailored specifically for
EURUSD trading. These SET files represent the best performing input values
found during pre-release optimization testing.

Each release could have slightly different parameters, so don't mix old SET
files between different releases.

Please use the SET files included with your downloaded release package rather
than older versions. Optimization is performed before major updates, so
parameters evolve across releases to adapt to changing market dynamics.

## Key Capabilities

This expert advisor provides a wide range of integrated trading functionality:

- Numerous Strategies: Choose from dozens of pre-built algorithmic trading
  strategies across various timeframes and technical indicators.
- Risk Controls: Configure price and trade stop limits along with customizable
  filters for opening or closing trades based on market conditions.
- Tunable Parameters: Fine-tune behaviors by adjusting dozens of input settings
  for elements like risk limits, position sizing, indicators, and more.

### Filtering System

The unique filtering system offers precise control over trade entry and exit
timing. Filters can be configured around account metrics, chart data, market
volatility, active orders, indicators like Moving Averages or RSI, and more.

You are free to customize these filters using Advanced version of EA.

### Risk Management

Intelligent trade management utilizes indicators and rules to determine ideal
times to take profits or close losing positions. The dynamic price stop system
aids risk mitigation in rapidly moving markets.

### Strategies

Each EA's strategy includes self-contained algorithms that analyze the markets
using popular technical indicators across multiple timeframes. Traders can
mix-and-match strategies or code custom logic taking advantage of included
functions and events.

You are free to write your own custom strategies.

### Timeframe

For the trading purposes, any timeframe can be used since EA reads data from
multiple timeframes independently from the current chart.

## Downloads

### Releases

Compiled binaries can be downloaded from [GitHub's Release page][github-release-link].

For installation steps, refer to [Installation][gh-wiki-installation] wiki page.

### Compilation

To download the source code along with all dependencies, use the following Git command:

    git clone --branch master --recursive https://github.com/EA31337/EA31337.git

After cloning, place the EA31337 directory into the `Experts` folder located in
your MetaTrader platform's MQL directory.

For more detailed compilation steps, refer to [Compilation][gh-wiki-compile] wiki page.

## Testing

### Backtesting & optimization

It is recommended to use MetaTrader 5 platform for backtesting and optimization.

Backtesting is the process of evaluating a trading strategy by applying it to
historical market data. It allows traders to simulate how a strategy might have
performed in the past across many market conditions.

Optimization takes this one step further by systematically tweaking a
strategy's parameters to determine which configurations may have produced the
best historical results. The goal is to fine-tune inputs related to elements
like risk, position sizing and strategy params to maximize a given performance
metric.

By combining an automated strategy with backtesting and optimization, traders
can rigorously analyze huge amounts of market data efficiently. This provides
statistical insights to build conviction in the strategy's edge while finding
optimal inputs without putting capital at risk.

Please be aware that backtesting cannot reliabily simulate the future outcome.

The backtesting for MT4
has been documented at [Backtesting using MT4][gh-wiki-backtest] wiki page.

## Related projects

This project utilizes the following sub-projects:

- [EA31337 framework][gh-repo-classes]
- [EA31337 indicators][gh-repo-indis]
- [EA31337 strategies][gh-repo-strats]
- [EA31337 strategies meta][gh-repo-strats-meta]

## Support

- For general help or ideas, open a [new discussion][gh-discuss-link] to ask questions.
- For bugs/features, raise a [new issue at GitHub][gh-issues].

## Social

- Join our [Telegram channel][tg-channel-link] for news and discussion group for help.
- Follow our [page at X][x-plink] or join our [X Community][x-clink].

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

By using EA31337, you understand and agree that we (company and author) are not
be liable or responsible for any loss or damage due to any reason.  Although
every attempt has been made to assure accuracy, we do not give any express or
implied warranty as to its accuracy.  We do not accept any liability for error
or omission.

You acknowledge that you are familiar with these risks and that you are solely
responsible for the outcomes of your decisions.  We accept no liability
whatsoever for any direct or consequential loss arising from the use of this
product.  You understand and agree that past results are not necessarily
indicative of future performance.

Use of EA31337 trading robot serves as your acknowledgement and representation
that you have read and understand these TERMS OF USE and that you agree to be
bound by such Terms of Use ("License Agreement").

### Copyright information

Copyright © 2016-2024 - EA31337 Ltd - All Rights Reserved

Author & Publisher: kenorb at EA31337 Ltd.

### Disclaimer and Risk Warnings

Trading any financial market involves risk.  All forms of trading carry a high
level of risk so you should only speculate with money you can afford to lose.
You can lose more than your initial deposit and stake.  Please ensure your
chosen method matches your investment objectives, familiarize yourself with the
risks involved and if necessary seek independent advice.

NFA and CTFC Required Disclaimers: Trading in the Foreign Exchange market as
well as in Futures Market and Options or in the Stock Market is a challenging
opportunity where above average returns are available for educated and
experienced investors who are willing to take above average risk.  However,
before deciding to participate in Foreign Exchange (FX) trading or in Trading
Futures, Options or stocks, you should carefully consider your investment
objectives, level of experience and risk appetite.

**Do not invest money you cannot afford to lose**.

CFTC RULE 4.41 - HYPOTHETICAL OR SIMULATED PERFORMANCE RESULTS HAVE
CERTAIN LIMITATIONS.  UNLIKE AN ACTUAL PERFORMANCE RECORD,
SIMULATED RESULTS DO NOT REPRESENT ACTUAL TRADING.  ALSO, SINCE THE
TRADES HAVE NOT BEEN EXECUTED, THE RESULTS MAY HAVE UNDER-OR-OVER
COMPENSATED FOR THE IMPACT, IF ANY, OF CERTAIN MARKET FACTORS, SUCH
AS LACK OF LIQUIDITY. SIMULATED TRADING PROGRAMS IN GENERAL ARE
ALSO SUBJECT TO THE FACT THAT THEY ARE DESIGNED WITH THE BENEFIT OF
HINDSIGHT.  NO REPRESENTATION IS BEING MADE THAN ANY ACCOUNT WILL
OR IS LIKELY TO ACHIEVE PROFIT OR LOSSES SIMILAR TO THOSE SHOWN.

<!-- Named links -->

[gh-edit-badge]: https://img.shields.io/badge/GitHub-edit-purple.svg?logo=github
[gh-edit-link]: https://github.dev/EA31337/EA31337
[gh-wiki]: https://github.com/EA31337/EA31337/wiki
[gh-wiki-compile]: https://github.com/EA31337/EA31337/wiki/Compilation
[gh-wiki-start]: https://github.com/EA31337/EA31337/wiki/Before-you-start
[gh-wiki-inputs]: https://github.com/EA31337/EA31337/wiki/Input-parameters
[gh-wiki-installation]: https://github.com/EA31337/EA31337/wiki/Installation
[gh-wiki-backtest]: https://github.com/EA31337/EA3133-Support/wiki/Backtesting-using-MT4

[github-release-image]: https://img.shields.io/github/release/EA31337/EA31337.svg?logo=github
[github-release-link]: https://github.com/EA31337/EA31337/releases

[gha-link-check-master]: https://github.com/EA31337/EA31337/actions?query=workflow%3ACheck+branch%3Amaster
[gha-image-check-master]: https://github.com/EA31337/EA31337/workflows/Check/badge.svg?branch=master
[gha-link-test-master]: https://github.com/EA31337/EA31337/actions?query=workflow%3ATest+branch%3Amaster
[gha-image-test-master]: https://github.com/EA31337/EA31337/workflows/Test/badge.svg?branch=master
[gha-link-backtest-master]: https://github.com/EA31337/EA31337/actions?query=workflow%3ABacktest+branch%3Amaster
[gha-image-backtest-master]: https://github.com/EA31337/EA31337/workflows/Backtest/badge.svg?branch=master

[gh-repo-classes]: https://github.com/EA31337/EA31337-classes
[gh-repo-indis]: https://github.com/EA31337/EA31337-indicators
[gh-repo-strats]: https://github.com/EA31337/EA31337-strategies
[gh-repo-strats-meta]: https://github.com/EA31337/EA31337-strategies-meta

[tg-channel-image]: https://img.shields.io/badge/Telegram-join-0088CC.svg?logo=telegram
[tg-channel-link]: https://t.me/EA31337

[x-cimage]: https://img.shields.io/badge/EA31337-Join-1DA1F2.svg?logo=X
[x-clink]: https://twitter.com/i/communities/1700228512274174098
[x-pimage]: https://img.shields.io/badge/EA31337-Follow-1DA1F2.svg?logo=X
[x-plink]: https://x.com/EA31337

[gh-discuss-badge]: https://img.shields.io/badge/Discussions-Q&A-blue.svg?logo=github
[gh-discuss-link]: https://github.com/EA31337/EA31337/discussions
[gh-issues]: https://github.com/EA31337/EA31337/issues

[license-image]: https://img.shields.io/github/license/EA31337/EA31337.svg
[license-link]: https://tldrlegal.com/license/gnu-general-public-license-v3-(gpl-3)
