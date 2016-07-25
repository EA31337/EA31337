#!/usr/bin/env bash
# Script to convert key-value parameters from set into mqh file.
type ex > /dev/null
[ $# -lt 2 ] && { echo "Usage: $0 (set-file) (mqh-file)"; exit 1; }
SET=$1
MQH=$2
ROOT="$(git rev-parse --show-toplevel)"
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
echo Converting...
grep "^[[:alnum:]][0-9A-Za-z_]\+=" "$SET" | while read opt; do
  name=${opt%=*}
  eval $opt
  value=${!name}
  ! [[ $value == ?(-)+([0-9.]) ]] && value="\"$value\""
  ex "+%s/ $name\s\+=.*;/ $name = $value;/" -scwq "$MQH"
done
echo $0 done.
