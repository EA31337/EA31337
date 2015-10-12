#!/bin/sh
[ -n "$1" ]   || { echo "Usage: $0 (file)"; exit 1; }
FILE="$1"
dos2unix "$FILE"
ex +'%s/\s\+$//e' -cwq "$FILE"
