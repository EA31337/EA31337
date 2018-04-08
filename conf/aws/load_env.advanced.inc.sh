#!/bin/sh
export PROVIDER=aws
export ASSET="EA31337 EA31337 v1.076 Advanced-Backtest ~/files/EA"
export CLONE_REPO="https://github.com/EA31337-Tester/EA31337-Advanced-Sets"
export GIT_ARGS='--author="EA31337-Tester <EA31337-Tester@users.noreply.github.com>"'
export TERMINATE=1
export POWER_OFF=1
#export RUN_TEST='-t -f */EURUSD/spread-10/digits-5/2014/*.set -e EA31337-Advanced -d 2000 -y 2014 -m 1 -M4.0.0.971 -D5 -i "$(find ~ -name "*SAR-SAR5_Active.rules")"'
#export NO_SETUP=1
#export PUSH_REPO=1
