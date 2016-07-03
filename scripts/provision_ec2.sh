#!/usr/bin/env bash
set -e
read pattern args <<<$@
[ $# -eq 0 ] && { echo Usage: "$0 (name)"; exit 1; }
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
ROOT="$(git rev-parse --show-toplevel || echo $CWD)"
VERSION=${VERSION:-"Lite"}
SYMBOL=${SYMBOL:-"EURUSD"}
YEAR=${YEAR:-"2014"}
DEPOSIT=${DEPOSIT:-"2000"}
CURRENCY=${CURRENCY:-"USD"}
SPREAD=${SPREAD:-"10"}
DIGITS=${DIGITS:-"5"}
BT_SOURCE=${BT_SOURCE:-"DS"}
MT4_VER="4.0.0.971"
SET_DIR="$SYMBOL/default/$DEPOSIT$CURRENCY/$SPREAD-spread/$DIGITS-digits/$YEAR"
OPT_DIR="$SET_DIR/_optimization_results"
SET_FILE="$SET_DIR/*.set"
VM_DIR="_VM"
LOG_DIR="$ROOT/logs"

# VM variables.
export VM_NAME=${1:-test}
export PROVIDER=aws
export INSTANCE_TYPE=t2.small
export KEYPAIR_NAME="EA31337-Tester"
export SUBNET_ID="subnet-2997c75e"
export PRIVATE_KEY="$HOME/Projects/EA31337/EA31337/conf/certs/EA31337-Tester.pem"
export ASSET="EA31337 EA31337-Backtest-Releases v1.069 Lite-Backtest ~/files/EA"
export GITHUB_API_TOKEN=b9c04ee7804b9731d9f64b6826375625760dd960 
export CLONE_REPO="https://9b3e1c0c4314ff16839b4382e13a0367a432de71@github.com/EA31337-Tester/EA31337-Lite-Sets"
export GIT_ARGS='--author="EA31337-Tester <EA31337-Tester@users.noreply.github.com>"'

[ ! -d "$LOG_DIR" ] && mkdir -vp "$LOG_DIR"
cd "$ROOT"/"$VM_DIR"

vagrant up --provider=aws --no-provision --destroy-on-error
vagrant provision | tee "${LOG_DIR}/${VM_NAME}.log"
vagrant ssh -c "/vagrant/scripts/eval.sh install_mt 4.0.0.971"
vagrant ssh
