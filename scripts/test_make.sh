#!/usr/bin/env bash
set -e
CWD=$(git rev-parse --show-toplevel 2> /dev/null || (cd -P -- "$(dirname -- "$0")/.." && pwd -P))
make lite
make advanced
make rider
make clean
