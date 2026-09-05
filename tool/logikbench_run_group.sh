#!/usr/bin/env bash
# Memory-safe LogikBench bidirectional driver.
# Each circuit runs as its own top-level `dart run` so the whole process tree
# (incl. Dart dev/DDS helpers) is reaped after every circuit -> flat memory.
# Aborts if available memory drops below a floor.
#
# Usage: run_group.sh <group-dir> <result-log>
set -u
GROUP_DIR="$1"
LOG="$2"
FLOOR_MB=600
cd /home/maifee/projects-rohd/sv2rohd || exit 2
: > "$LOG"

for d in "$GROUP_DIR"/*/; do
  name=$(basename "$d")
  rtl="$d/rtl/$name.v"
  [ -f "$rtl" ] || rtl=$(ls "$d"/rtl/*.v "$d"/rtl/*.sv 2>/dev/null | head -1)
  [ -f "$rtl" ] || continue

  avail=$(free -m | awk '/^Mem:/{print $7}')
  if [ "$avail" -lt "$FLOOR_MB" ]; then
    echo "ABORT: low memory (${avail}MB) before $name" | tee -a "$LOG"
    exit 3
  fi

  line=$(timeout 120 dart run tool/logikbench_bidir.dart "$rtl" 2>/dev/null | head -1)
  [ -z "$line" ] && line="TIMEOUT/ERR  $name"
  echo "$line" | tee -a "$LOG"
done

echo "=== done: $(basename "$GROUP_DIR") ===" | tee -a "$LOG"
