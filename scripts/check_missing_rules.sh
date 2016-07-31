#!/usr/bin/env bash
# Script to convert key-value parameters from set into mqh file.
type ex > /dev/null
#[ $# -lt 2 ] && { echo "Usage: $0 (set-file)"; exit 1; }
ROOT="$(git rev-parse --show-toplevel)"
CWD=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
ignore='(__|Magic*|Validate*|Sound*|Color*|Send*|Verbose*|Print*|Write*)'

grep ^extern "$ROOT"/src/include/EA/lite/ea-input.mqh | grep -Ev "$ignore" | awk '{print $3}' | while read param; do
  if [ ! "$(find -E "$ROOT"/rules -regex ".*$param.*rule.*")" ]; then
    echo "Rule not found for: $param"
  fi
done
