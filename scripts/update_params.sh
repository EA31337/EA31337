#!/usr/bin/env bash
# Script to update parameters from set into mqh files.
ROOT="$(git rev-parse --show-toplevel)"
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
$CWD/convert_set_mqh.sh $ROOT/sets/Lite/EURUSD/default/2000USD/10-spread/5-digits/2014-2015/EA31337-Lite.set $ROOT/src/include/EA/lite/ea-input.mqh
