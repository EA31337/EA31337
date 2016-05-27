#!/usr/bin/env bash
# Script to update parameters from set into mqh files.
ROOT="$(git rev-parse --show-toplevel)"
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
$CWD/convert_set_mqh.sh $ROOT/sets/Lite/EURUSD/spread-10/digits-5/2014/EA31337-Lite.set $ROOT/src/include/EA/ea-input-lite.mqh 
