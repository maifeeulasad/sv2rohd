#!/usr/bin/env bash
# Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
#
# Vendors Icarus Verilog into .dart_tool/iverilog without root, by downloading
# the .deb and extracting it. Used by the SV<->ROHD equivalence tests
# (test/equivalence_test.dart) to simulate SystemVerilog.
#
# After running, the equivalence tests find iverilog automatically. You can
# also point them at any existing install with the IVERILOG_ROOT env var
# (a prefix containing usr/bin/iverilog).
set -euo pipefail

DEST="$(cd "$(dirname "$0")/.." && pwd)/.dart_tool/iverilog"

if [ -x "$DEST/usr/bin/iverilog" ]; then
  echo "iverilog already vendored at $DEST"
  exit 0
fi

if command -v iverilog >/dev/null 2>&1; then
  echo "iverilog already on PATH: $(command -v iverilog)"
  echo "(the equivalence tests will use it directly)"
  exit 0
fi

echo "Vendoring Icarus Verilog into $DEST ..."
mkdir -p "$DEST"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cd "$tmp"
if command -v apt-get >/dev/null 2>&1; then
  apt-get download iverilog
else
  echo "error: apt-get not available; install iverilog manually and set IVERILOG_ROOT" >&2
  exit 1
fi

deb="$(ls iverilog_*.deb | head -1)"
dpkg -x "$deb" "$DEST"

# The relocated binary can't auto-find its backend; callers must pass
# -B/-M pointing at the ivl directory (the equivalence harness does this).
backend="$(find "$DEST" -type d -name ivl | head -1 || true)"
echo "✓ iverilog vendored at $DEST"
echo "  backend (pass to -B / -M): $backend"
"$DEST/usr/bin/iverilog" -B "$backend" -V 2>/dev/null | head -1 || true
