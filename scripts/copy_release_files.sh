#!/usr/bin/env bash
# Script to update parameters from set into mqh files.
ROOT="$(git rev-parse --show-toplevel)"

# Backtest
cp -v "$ROOT"/src/include/EA/ea-enums.mqh "$ROOT"/releases/Backtest/includes/
cp -v "$ROOT"/src/include/EA/lite/ea-input.mqh "$ROOT"/releases/Backtest/includes/

# Lite
cp -v "$ROOT"/src/include/EA/ea-enums.mqh "$ROOT"/releases/Lite/includes/
cp -v "$ROOT"/src/include/EA/lite/ea-input.mqh "$ROOT"/releases/Lite/includes/

# Advanced
cp -v "$ROOT"/src/include/EA/ea-enums.mqh "$ROOT"/releases/Advanced/includes/
cp -v "$ROOT"/src/include/EA/advanced/ea-input.mqh "$ROOT"/releases/Advanced/includes/

