#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME="blank-agentic-cli"
PACKAGE_SPEC="${1:-$PACKAGE_NAME}"
BIN_DIR="${HOME}/.local/bin"
TEXST_RELEASES_URL="https://api.github.com/repos/shusuke-ioku/texst/releases/latest"

resolve_latest_texst_version() {
  if ! command -v curl >/dev/null 2>&1; then
    return 1
  fi

  local payload
  if ! payload="$(curl -fsSL \
    -H "Accept: application/vnd.github+json" \
    -H "User-Agent: blank-agentic-cli" \
    "${TEXST_RELEASES_URL}" 2>/dev/null)"; then
    return 1
  fi

  local version
  version="$(printf '%s' "${payload}" \
    | sed -nE 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v?([0-9]+\.[0-9]+\.[0-9]+)".*/\1/p' \
    | head -n 1)"

  if [[ -z "${version}" ]]; then
    return 1
  fi

  printf '%s' "${version}"
}

sync_paper_texst_import() {
  local paper_file="$1"

  if [[ ! -f "${paper_file}" ]]; then
    return 0
  fi

  if ! grep -Eq '@preview/texst:[0-9]+\.[0-9]+\.[0-9]+' "${paper_file}"; then
    echo "No TeXst import found in ${paper_file}; skipping update."
    return 0
  fi

  local texst_version
  if ! texst_version="$(resolve_latest_texst_version)"; then
    echo "Warning: could not resolve latest TeXst version; skipping ${paper_file} update."
    return 0
  fi

  local temp_file
  temp_file="$(mktemp)"

  if ! sed -E "s/@preview\\/texst:[0-9]+\\.[0-9]+\\.[0-9]+/@preview\\/texst:${texst_version}/g" "${paper_file}" > "${temp_file}"; then
    rm -f "${temp_file}"
    echo "Warning: failed to process ${paper_file}; skipping update."
    return 0
  fi

  if cmp -s "${paper_file}" "${temp_file}"; then
    rm -f "${temp_file}"
    echo "TeXst import already current in ${paper_file} (@preview/texst:${texst_version})."
    return 0
  fi

  mv "${temp_file}" "${paper_file}"
  echo "Updated ${paper_file} to @preview/texst:${texst_version}."
}

# pipx/python can fail with PermissionError if current directory is inaccessible.
if ! pwd >/dev/null 2>&1; then
  echo "Current directory is not accessible. Switching to \$HOME..."
  cd "${HOME}"
fi

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
  sync_paper_texst_import "paper/paper.typ"
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
