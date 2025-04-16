#!/usr/bin/env bash
# ─────────────────────────────────────────────
#  watch_project ─ auto‑export HX‑1 schematic
# ─────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_ROOT="$(realpath "$SCRIPT_DIR/..")"

SCHEM="$REPO_ROOT/HX-1/HX-1.kicad_sch"
WATCH_DIR="$REPO_ROOT/HX-1"
OUT_DIR="$REPO_ROOT/docs"
OUT_IMG="$OUT_DIR/HX-1.svg"

mkdir -p "$OUT_DIR"
echo -e "📡  Watching: $SCHEM\n🔄  Output →  $OUT_IMG\n"

# debounce window (seconds)
DELAY=1
LAST_RUN=0

inotifywait  -m  -e modify,close_write,moved_to  \
             --format '%f'                       \
             --exclude '(\.tmp$|\.bak$|~$)'      \
             "$WATCH_DIR" | while read -r file; do

    [[ "$file" != "HX-1.kicad_sch" ]] && continue

    now=$(date +%s)
    (( now - LAST_RUN < DELAY )) && continue   # skip duplicate
    LAST_RUN=$now

    printf '🖉  %(%H:%M:%S)T – exporting…\n' "$now"

    if kicad-cli sch export svg "$SCHEM" -o "$OUT_IMG" &> /dev/null ; then
        echo "✅  Exported → $OUT_IMG"
    else
        echo "⚠️   Export failed"
    fi
done
