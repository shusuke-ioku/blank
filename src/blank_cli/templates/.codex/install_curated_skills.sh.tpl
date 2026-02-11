#!/usr/bin/env bash
set -euo pipefail

SCRIPT_ROOT="$HOME/.codex/skills/.system/skill-installer/scripts"
LIST_SCRIPT="$SCRIPT_ROOT/list-skills.py"
INSTALL_SCRIPT="$SCRIPT_ROOT/install-skill-from-github.py"

if [[ ! -f "$LIST_SCRIPT" || ! -f "$INSTALL_SCRIPT" ]]; then
  echo "Skill installer scripts not found under ~/.codex/skills/.system/skill-installer/scripts" >&2
  exit 1
fi

echo "Listing curated skills (JSON)."
echo "python3 \"$LIST_SCRIPT\" --format json"
echo
echo "Install an available skill by path, e.g.:"
echo "python3 \"$INSTALL_SCRIPT\" --repo openai/skills --path skills/.curated/<skill-name>"
