# EA31337 trading robot

## About the project

EA31337 is an advanced trading robot for Forex markets written in MQL.

The project aims to deliver fully working Expert Advisor (EA) for free.

It implements algorithm for managing multiple strategies
on different timeframes at once.

The code is split into 3 modes: Lite, Advanced and Rider,
each providing slightly different trading logic,
while sharing the same codebase and strategies.

## Features

### Lite

Lite version aims at simpler implementation of EA.

Features include:

- Simple input interface ideal for beginners.
- Comes with 30+ built-in strategies ready to use.
- Strategies can trade at different timeframes at the same time.
- Auto calculation of trade's lot size
  based on the available account's margin to minimalize risk.
- Risk management to prevent sudden losses.

### Advanced

Advanced version aims at more advanced implementation of EA.

It comes with all same features plus the following:

- Advanced input interface for more customization.
- Allows overriding strategy's trailing stop methods.
- Allows to specify a closing time for active orders.

### Rider

Rider version aims at "riding" the market's trends.

In simple words, the trades are opened by lower timeframe strategies,
and closed by the higher timeframe strategies.

In comparison with other modes,
it tries to keep the orders for longer period of time.

## Input parameters

To read more about the EA's parameters,
check the following [wiki page about Input parameters][wiki-inputs].

## Dependencies

The project is using the following projects:

- [EA31337 Framework][ghp-ea-framework]
- [EA31337 Strategies][ghp-ea-strats]

## Further readings

For more information, check the following resources:

- [README][repo-readme]
- [Wiki pages][repo-wiki]

## Downloads

To download the project's files,
go to [Releases page][repo-releases].

You can also download the files from the [Marketplace][ea-marketplace].

## Other projects

To read about other projects, go to [ea31337.github.io][lnk-gh-io].

<!-- Named links -->

[ea-marketplace]: https://marketplace.ea31337.com/

[ghp-ea-framework]: https://ea31337.github.io/EA31337-classes
[ghp-ea-strats]: https://ea31337.github.io/EA31337-strategies

[lnk-gh-io]: https://ea31337.github.io

[repo-readme]: https://github.com/EA31337/EA31337#readme
[repo-releases]: https://github.com/EA31337/EA31337/releases
[repo-wiki]: https://github.com/EA31337/EA31337/wiki

[wiki-inputs]: https://github.com/EA31337/EA31337/wiki/Input-parameters
