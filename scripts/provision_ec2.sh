#!/usr/bin/env bash
set -e
read -r name <<<"$@"
[ $# -eq 0 ] && { echo Usage: "$0 (name)"; exit 1; }
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
ROOT="$(git rev-parse --show-toplevel || echo "$CWD")"
VERSION=${VERSION:-"Lite"}
SYMBOL=${SYMBOL:-"EURUSD"}
YEAR=${YEAR:-"2014"}
DEPOSIT=${DEPOSIT:-"2000"}
CURRENCY=${CURRENCY:-"USD"}
SPREAD=${SPREAD:-"10"}
DIGITS=${DIGITS:-"5"}
BT_SOURCE=${BT_SOURCE:-"DS"}
VM_DIR="_VM"
LOG_DIR="$ROOT/logs"

# VM variables.
export VM_NAME=${name:-test}
export PROVIDER=aws
export INSTANCE_TYPE=t2.small
export KEYPAIR_NAME="EA31337-Tester"
export ASSET="EA31337 EA31337 v1.076 Lite-Backtest ~/files/EA"
export CLONE_REPO="https://github.com/EA31337/EA31337"
export GIT_ARGS='--author="EA31337-Tester <EA31337-Tester@users.noreply.github.com>"'

# EA variables.
export MT4_VER="4.0.0.971"
export OPT_DIR="$SET_DIR/_optimization_results"
export SET_DIR="$SYMBOL/default/$DEPOSIT$CURRENCY/$SPREAD-spread/$DIGITS-digits/$YEAR"
export SET_FILE="$SET_DIR/*.set"

[ ! -d "$LOG_DIR" ] && mkdir -vp "$LOG_DIR"
cd "$ROOT"/"$VM_DIR"

vagrant up --provider=aws --no-provision --destroy-on-error
vagrant provision | tee "${LOG_DIR}/${VM_NAME}.log"
vagrant ssh -c "/vagrant/scripts/eval.sh install_mt 4.0.0.971"
vagrant ssh
# E.g. EA31337-Lite-Sets/_scripts/run_backtests.sh EURUSD\*2014 -S ValidateSettings=0
