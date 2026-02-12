# blank

`blank` is a CLI scaffolder for research projects driven by agentic AI workflows.

## Install

**Recommended:**

```bash
curl -fsSL https://raw.githubusercontent.com/shusuke-ioku/blank/main/scripts/install_blank.sh | bash
```

**Alternative:** manually install:

1) Install `pipx` (if missing):

```bash
python3 -m pip install --user pipx
python3 -m pipx ensurepath
```

2) Reload your shell:

```bash
exec $SHELL -l
```

3) Install `blank` from PyPI:

```bash
pipx install blank-agentic-cli
```

**Verify:**

```bash
blank --help
```

## Troubleshooting

If `blank --help` fails with `command not found`, run:

```bash
export PATH="$HOME/.local/bin:$PATH"
hash -r
blank --help
```

Make it persistent:

```bash
# zsh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zprofile

# bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

Debug checks:

```bash
pipx list
echo "$PATH" | tr ':' '\n' | rg "$HOME/.local/bin"
which blank
ls -l "$HOME/.local/bin/blank"
```

## Usage

```bash
blank init
blank init my-project
blank init my-project --project-name "My Project"
blank init my-project --dry-run
blank init my-project --force
blank init my-project --no-agents
```

By default, `paper/paper.typ` imports TeXst:

```typst
#import "@preview/texst:0.1.0": paper, nneq, caption-note, table-note, theorem, proof, prop, lem, rem, ass, cmain, csub, caption-with-note
```

TeXst repository:
- https://github.com/shusuke-ioku/texst

`paper/aesthetics.typ` is generated as a blank file so you can add custom style settings.

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
