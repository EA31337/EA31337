#!/usr/bin/env bash
# Script to copy key-value parameters from SET to MQH file.
# E.g. copy_set_mqh.sh lite
command -v ex > /dev/null
set -e
trap on_error 1 2 3 15 ERR
on_error() { echo "Error!"; while caller $((n++)); do :; done >&2; }
ROOT=$(git rev-parse --show-toplevel 2> /dev/null || (cd -P -- "$(dirname -- "$0")/.." && pwd -P))
[ $# -lt 1 ] && { echo "Usage: $0 (lite/advanced/rider)"; exit 1; }
read -r mode <<<"$@"
[ -d "$ROOT/docker/optimization/$mode" ] || { echo "Invalid mode: $mode!"; exit 1; }
echo "Copying..."
while read -r opt; do
  name=${opt%=*}
  eval "$opt"
  value=${!name}
  dest_file=$(grep -lwr "$name" "$ROOT"/src/include/EA31337/"$mode"/*.mqh "$ROOT"/src/include/EA31337-strategies/*/*.mqh)
  ex "+%s@\\<$name\\s\\?=[^-.0-9]\\+\\zs[-.0-9]\\+\\ze@$value@" -scwq "$dest_file"
done < <(find "$ROOT/docker/optimization/$mode" -name "*.set" -exec grep -hA99 Optimization {} ';' | grep -o "^[A-Z][^=,]\\+=[0-9.]\\+")
echo "done."
