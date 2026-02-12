# blank

`blank` is a CLI scaffolder for research projects driven by agentic AI workflows.

## Install

Recommended (handles `pipx ensurepath`, install, and verification):

```bash
curl -fsSL https://raw.githubusercontent.com/shusuke-ioku/blank/main/scripts/install_blank.sh | bash
```

From GitHub package source (same installer with package override):

```bash
curl -fsSL https://raw.githubusercontent.com/shusuke-ioku/blank/main/scripts/install_blank.sh | bash -s -- git+https://github.com/shusuke-ioku/blank.git
```

From a local clone:

```bash
bash scripts/install_blank.sh
```

First-time `pipx` setup (one-time per machine):

```bash
pipx ensurepath
exec $SHELL -l
```

From PyPI (after release):

```bash
pipx install blank-agentic-cli
```

From GitHub:

```bash
pipx install git+https://github.com/shusuke-ioku/blank.git
```

## Post-install check

```bash
blank --help
```

If you see `bash: blank: command not found`, `pipx` likely installed correctly but your shell PATH is missing `~/.local/bin`.

Quick fix for current shell:

```bash
export PATH="$HOME/.local/bin:$PATH"
hash -r
blank --help
```

Persist it:

```bash
# zsh (default on modern macOS)
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zprofile

# bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

Optional:

```bash
pipx ensurepath
```

## Usage

```bash
blank init
blank init my-project
blank init my-project --project-name "My Project"
blank init my-project --dry-run
blank init my-project --force
blank init my-project --no-agents
blank init my-project --paper-template latex
blank init my-project --paper-template blank
```

If `--paper-template` is omitted and you run in a terminal, `blank init` asks you to choose:
- `latex`: TeXst-style Typst starter (generates `paper/aesthetics.typ` + `paper/paper.typ`)
- `blank`: minimal empty Typst file

## Generated scaffold

- `analysis/scripts/`
- `analysis/data/`
- `analysis/output/`
- `paper/`
- `idea/`
- `.codex/project.md` with default agent rules
- `.codex/config.toml` with Zotero + PDF-reader MCP server setup
- `.codex/skills/` starter skill set and install scripts
- `.claude/` defaults

## MCP setup (Zotero + PDF reader)

Generated projects include:
- `zotero` MCP server via `zotero-mcp`
- `pdf_reader` MCP server via `uvx markitdown-mcp`

Quick local checks:

```bash
zotero-mcp --help
uvx markitdown-mcp --help
```

## Development

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -e . pytest
pytest
```

## Release (PyPI)

1. Create PyPI project `blank-agentic-cli` and enable Trusted Publishing for this GitHub repo.
2. (Optional) Run GitHub Action `publish` manually with `testpypi` to verify packaging.
3. Tag a release:

```bash
git tag v0.1.0
git push origin v0.1.0
```

4. The `publish` workflow builds and uploads to PyPI.
