#!/usr/bin/env bash
# Script to update parameters from set into mqh files.
ROOT="$(git rev-parse --show-toplevel)"
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

# Lite
cp -v "$ROOT"/src/include/EA/ea-enums.mqh "$ROOT"/releases/Lite/includes/
cp -v "$ROOT"/src/include/EA/ea-input-lite.mqh "$ROOT"/releases/Lite/includes/
