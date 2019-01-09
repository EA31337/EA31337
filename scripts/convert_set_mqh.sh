#!/usr/bin/env bash
# Script to convert key-value parameters from set into mqh file.
# E.g.
# ./scripts/convert_set_mqh.sh sets/Lite/EURUSD/default/2000USD/10-spread/5-digits/2014/EA31337-Lite.set src/include/EA31337/lite/ea-input.mqh
type ex > /dev/null
[ $# -lt 2 ] && { echo "Usage: $0 (set-file) (mqh-file)"; exit 1; }
SET=$1
MQH=$2
echo Converting...
# shellcheck disable=SC1117 # @fixme
grep "^[[:alnum:]][0-9A-Za-z_]\+=" "$SET" | while read -r opt; do
  # shellcheck disable=SC2154 # @see: https://github.com/koalaman/shellcheck/issues/1419
  name=${opt%=*}
  eval "$opt"
  value=${!name}
  ! [[ $value == ?(-)+([0-9.]) ]] && value="\"$value\""
  # shellcheck disable=SC1117 # @fixme
  ex "+%s/ $name\s\+=.*;/ $name = $value;/" -scwq "$MQH"
done
echo "$0 done".