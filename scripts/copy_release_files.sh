#!/usr/bin/env bash
# Script to update parameters from set into mqh files.
ROOT="$(git rev-parse --show-toplevel)"
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# Backtest
cp -v "$ROOT"/src/include/EA/ea-enums.mqh "$ROOT"/releases/Backtest/includes/
cp -v "$ROOT"/src/include/EA/ea-input-lite.mqh "$ROOT"/releases/Backtest/includes/

# Lite
cp -v "$ROOT"/src/include/EA/ea-enums.mqh "$ROOT"/releases/Lite/includes/
cp -v "$ROOT"/src/include/EA/ea-input-lite.mqh "$ROOT"/releases/Lite/includes/

# Advanced
cp -v "$ROOT"/src/include/EA/ea-enums.mqh "$ROOT"/releases/Advanced/includes/
cp -v "$ROOT"/src/include/EA/ea-input-advanced.mqh "$ROOT"/releases/Advanced/includes/

