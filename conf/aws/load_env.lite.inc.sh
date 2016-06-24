#!/bin/sh
export PROVIDER=aws
export KEYPAIR_NAME="EA31337-Tester"
export SUBNET_ID="subnet-2997c75e"
export PRIVATE_KEY="$HOME/Projects/EA31337/EA31337/conf/certs/EA31337-Tester.pem"
export ASSET="EA31337 EA31337-Backtest-Releases v1.068 Lite-Backtest ~/files/EA"
export GITHUB_API_TOKEN=b9c04ee7804b9731d9f64b6826375625760dd960 
export CLONE_REPO="https://9b3e1c0c4314ff16839b4382e13a0367a432de71@github.com/EA31337-Tester/EA31337-Lite-Sets"
export GIT_ARGS='--author="EA31337-Tester <EA31337-Tester@users.noreply.github.com>"'
export POWER_OFF=1
#export RUN_TEST='-t -f */EURUSD/spread-10/digits-5/2014/*.set -e EA31337-Advanced -d 2000 -y 2014 -m 1 -M4.0.0.971 -D5 -i "$(find ~ -name "*SAR-SAR5_Active.rules")"'
#export NO_SETUP=1
#export PUSH_REPO=1
