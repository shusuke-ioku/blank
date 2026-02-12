#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="blank-agentic-cli"
PACKAGE_SPEC="${1:-$PACKAGE_NAME}"
BIN_DIR="${HOME}/.local/bin"

if ! command -v pipx >/dev/null 2>&1; then
  echo "Error: pipx is not installed." >&2
  echo "Install pipx first, then re-run this script." >&2
  exit 1
fi

echo "[1/3] Configuring pipx PATH..."
pipx ensurepath >/dev/null

echo "[2/3] Installing ${PACKAGE_SPEC}..."
if pipx list 2>/dev/null | grep -q "package ${PACKAGE_NAME} "; then
  if [[ "${PACKAGE_SPEC}" == "${PACKAGE_NAME}" ]]; then
    pipx upgrade "${PACKAGE_NAME}" >/dev/null
  else
    pipx install "${PACKAGE_SPEC}" --force >/dev/null
  fi
else
  pipx install "${PACKAGE_SPEC}" >/dev/null
fi

echo "[3/3] Verifying 'blank' command..."
if command -v blank >/dev/null 2>&1; then
  echo "Success: $(command -v blank)"
  blank --help >/dev/null
  echo "Run: blank init"
  exit 0
fi

echo
echo "'blank' was installed but is not in this shell PATH yet."
if [[ -x "${BIN_DIR}/blank" ]]; then
  echo "Installed binary: ${BIN_DIR}/blank"
fi

echo "Apply for current shell:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo "  hash -r"
echo "  blank --help"
echo

if [[ "${SHELL:-}" == *"zsh"* ]]; then
  echo "Persist for zsh:"
  echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zprofile"
elif [[ "${SHELL:-}" == *"bash"* ]]; then
  echo "Persist for bash:"
  echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bash_profile"
  echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
else
  echo "Persist for your shell by adding this line to your shell profile:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo "Then restart your shell:"
echo "  exec \$SHELL -l"
