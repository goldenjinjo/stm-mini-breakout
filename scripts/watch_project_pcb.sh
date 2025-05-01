#!/usr/bin/env bash
# ─────────────────────────────────────────────
#  watch_project_pcb ─ auto‑export HX‑1 PCB layout
# ─────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_ROOT="$(realpath "$SCRIPT_DIR/..")"

PCB="$REPO_ROOT/HX-1/HX-1.kicad_pcb"
WATCH_DIR="$(dirname "$PCB")"
OUT_DIR="$REPO_ROOT/docs"
PCB_OUT="$OUT_DIR/HX-1-board.svg"

mkdir -p "$OUT_DIR"
echo -e "📡  Watching PCB: $PCB\n🔄  Output → $PCB_OUT\n"

# debounce window (seconds)
DELAY=1
LAST_RUN=0

inotifywait -m -e modify,close_write,moved_to \
            --format '%f' \
            --exclude '(\.tmp$|\.bak$|~$)' \
            "$WATCH_DIR" | while read -r file; do

    [[ "$file" != "HX-1.kicad_pcb" ]] && continue

    now=$(date +%s)
    (( now - LAST_RUN < DELAY )) && continue
    LAST_RUN=$now

    printf '🖉  %(%H:%M:%S)T – exporting PCB layout…\n' "$now"

    if kicad-cli pcb export svg "$PCB" \
        --layers F.Cu,F.SilkS,B.Cu,B.SilkS,F.CrtYd,B.CrtYd,Edge.Cuts \
        --page-size-mode 2 \
        -o "$PCB_OUT" &> /dev/null; then
        echo "✅  PCB layout → $PCB_OUT"
    else
        echo "⚠️   PCB export failed"
    fi
done
