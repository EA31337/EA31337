#!/usr/bin/env bash
set -e
[ "$TRACE" ] && set -x
[ ! "$NOFAIL" ] && set -e
CWD=$(git rev-parse --show-toplevel 2> /dev/null || (cd -P -- "$(dirname -- "$0")/.." && pwd -P))
VM_DIR="$CWD/_VM"
EA_DIR="$CWD/src"
VER=${1:-$(echo "Lite-Backtest")}

echo "Compiling..."
[ -n "$VER" ] && make -C "$CWD" $MAKE_ARGS $VER

echo "Copying EAs..."
mkdir -v "$VM_DIR"/files || true
cp -v "$EA_DIR"/*.ex? "$VM_DIR"/files

make -C "$CWD" mt4-install

TRACE=$TRACE $VM_DIR/scripts/run_backtest.sh -v -t -r "EA31337-$VER" -D5 -e EA31337 -d 2000 -m 1 -y 2014 ${@:2}
