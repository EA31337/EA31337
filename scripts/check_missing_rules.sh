#!/usr/bin/env bash
# Script to convert key-value parameters from set into mqh file.
type ex > /dev/null
#[ $# -lt 2 ] && { echo "Usage: $0 (set-file)"; exit 1; }
ROOT="$(git rev-parse --show-toplevel)"
ignore='(__|Magic*|Validate*|Sound*|Color*|Send*|Verbose*|Print*|Write*|TradeMicroLots|MaxTries|Alligator_Period*|Alligator_Shift*)'

grep ^extern "$ROOT"/src/include/EA/lite/ea-input.mqh | grep -Ev "$ignore" | awk '{print $3}' | while read -r param; do
  # shellcheck disable=SC2154
  # @see: https://github.com/koalaman/shellcheck/issues/1419
  if [ ! "$(find -E "$ROOT"/rules -regex ".*$param.*rule.*")" ]; then
    echo "Rule not found for: $param"
  fi
done
