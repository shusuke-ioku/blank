#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$ROOT_DIR/.codex/skills"
DEST_DIR="${CODEX_HOME:-$HOME/.codex}/skills"
FORCE=0

if [[ "${1:-}" == "--force" ]]; then
  FORCE=1
fi

mkdir -p "$DEST_DIR"

for skill in typst-paper-sync-check adversarial-brainstorm-recorder socsci-critical-reader; do
  src="$SRC_DIR/$skill"
  dest="$DEST_DIR/$skill"

  if [[ ! -d "$src" ]]; then
    echo "Skip missing skill dir: $src" >&2
    continue
  fi

  if [[ -e "$dest" ]]; then
    if [[ "$FORCE" -eq 1 ]]; then
      rm -rf "$dest"
    else
      echo "Skip existing: $dest"
      continue
    fi
  fi

  ln -s "$src" "$dest"
  echo "Installed: $skill -> $dest"
done

echo "Restart Codex to pick up new skills."
