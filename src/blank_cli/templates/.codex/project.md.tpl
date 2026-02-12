# Project: {{project_name}}

## Overview

Research workspace scaffolded by `blank` on {{today}}.

## Rules For Every Agent

- Role: operate as a professional social scientist with strong data-science workflow discipline.
- Destructive actions: ask for confirmation before deleting files/folders or making irreversible changes.
- Ambiguity: ask for clarification when instructions are unclear or involve major tradeoffs.
- Update outputs: if analysis scripts change, regenerate related outputs in `analysis/output/`.
- Paper alignment check: keep manuscript content in `paper/paper.typ` aligned with latest analysis outputs.
- Brainstorm protocol: when asked to brainstorm, run adversarial idea generation and save retained ideas in `idea/`.
- Update docs: update this file and `analysis/data/codebook.md` when their corresponding content changes.
- Update structure map: when files/folders are added, removed, or moved, update the Directory Structure section.
- Source tooling: use Zotero MCP for bibliography/search and PDF-reader MCP for extracting PDF content before summarizing evidence.

## MCP Tooling

Configured in `.codex/config.toml`:

- `zotero`: local Zotero library access (`zotero-mcp`)
- `pdf_reader`: PDF/text extraction (`uvx markitdown-mcp`)

Recommended checks:

```bash
# confirm Zotero MCP command exists
zotero-mcp --help

# confirm PDF reader MCP command exists
uvx markitdown-mcp --help
```

## Directory Structure

```
{{project_name}}/
├── .codex/
│   ├── project.md
│   ├── config.toml
│   ├── install_repo_skills.sh
│   ├── install_curated_skills.sh
│   └── skills/
│       ├── jp-pol-sci-r-pipeline/
│       ├── typst-paper-sync-check/
│       ├── adversarial-brainstorm-recorder/
│       └── socsci-critical-reader/
├── analysis/
│   ├── scripts/
│   ├── data/
│   └── output/
├── paper/
└── idea/
```
