#!/bin/bash -e
#set -e
CWD=$(git rev-parse --show-toplevel 2> /dev/null || (cd -P -- "$(dirname -- "$0")/.." && pwd -P))
VM_DIR="$CWD/_VM"
EA_DIR="$CWD/src"
REP_DIR="$VM_DIR/files/reports"
OUT="$CWD/_test_results"
VER=${1:-$(echo "Lite-Backtest")}

echo "Checking dependencies..."
type vagrant

echo "Compiling..."
[ -n "$1" ] && make -C "$CWD" $1

echo "Initializing VM..."
cd "$VM_DIR"
vagrant up

echo "Copying EAs..."
mkdir -v "$VM_DIR"/files || true
cp -v "$EA_DIR"/*.ex? "$VM_DIR"/files

echo "Cleaning previous reports..."
[ ! -d "$REP_DIR" ] && mkdir -vp "$REP_DIR"
find "$REP_DIR" -type f -print -delete

echo "Running tests..."
for month in {01..12}; do
  vagrant ssh -c "/vagrant/scripts/run_backtest.sh -t -r "EA31337-$VER-EURUSD-DS-s10-2014-$month" -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -m $month -s 10 -b DS -D /vagrant/files/reports"
done
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b N5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b W5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b C5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b Z5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b R9 -D /vagrant/files"
mv -v "$REP_DIR"/*$VER* "$OUT"/$VER
