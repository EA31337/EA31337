#!/usr/bin/env bash
# Req. Bash >=4.x.
set -e
CWD=$(git rev-parse --show-toplevel 2> /dev/null || (cd -P -- "$(dirname -- "$0")/.." && pwd -P))
VM_DIR="$CWD/_VM"
EA_DIR="$CWD/src"
REP_DIR="$VM_DIR/files/reports"
OUT="$CWD/_test_results"
VER=${1:-"Lite-Backtest"}

echo "Checking dependencies..."
type vagrant

echo "Compiling..."
[ -n "$VER" ] && make -C "$CWD" "$VER"

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
for year in {2014..2014}; do
  for month in {01..12}; do # Note: Leading zero syntax requires Bash >=4.x.
    for deposit in {2000..2000}; do
      for spread in {10..10}; do
        vagrant ssh -c "/vagrant/scripts/run_backtest.sh -v -t -r EA31337-$VER-EURUSD-DS-${deposit}USD-${spread}spread-$year-$month -e EA31337 -d $deposit -p EURUSD -m $month -y $year -s $spread -b DS -D5 -O /vagrant/files/reports -M4.0.0.1010"
        mkdir -p "$OUT/$VER/$year"
        mv -v "$REP_DIR/*$VER*" "$OUT/$VER/$year"
      done
    done
  done
done
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b N5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b W5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b C5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b Z5 -D /vagrant/files"
#vagrant ssh -c "/vagrant/scripts/run_backtest.sh -c GBP -e EA31337 -d 2000 -p EURUSD -y 2014 -s 10 -b R9 -D /vagrant/files"
