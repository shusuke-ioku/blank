# blank

`blank` is a CLI scaffolder for research projects driven by agentic AI workflows.

## Install

From PyPI (after release):

```bash
pipx install blank-agentic-cli
```

From GitHub:

```bash
pipx install git+https://github.com/shusuke-ioku/blank.git
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
- `latex`: LaTeX-like Typst starter
- `blank`: minimal empty Typst file

## Generated scaffold

- `analysis/scripts/`
- `analysis/data/`
- `analysis/output/`
- `paper/`
- `idea/`
- `.codex/project.md` with default agent rules
- `.codex/skills/` starter skill set and install scripts
- `.claude/` defaults

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
