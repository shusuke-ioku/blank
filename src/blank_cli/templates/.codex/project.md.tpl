# Project: {{project_name}}

## Overview

Research workspace scaffolded by `blank` on {{today}}.

## Rules For Every Agent

- Role: operate as a professional social scientist with strong data-science workflow discipline.
- Destructive actions: ask for confirmation before deleting files/folders or making irreversible changes.
- Ambiguity: ask for clarification when instructions are unclear or involve major tradeoffs.
- Update outputs: when changing any R script in `analysis/scripts/`, re-run affected scripts and update corresponding markdown outputs in `analysis/output/results/`.
- Self-debugging: re-run affected scripts and resolve errors yourself before handoff.
- Sync command: when told to "sync", ensure all manuscript content in `paper/paper.typ` (figures, tables, and claims) is synchronized with the latest files in `analysis/output/`.
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

## Workflow & Procedures

### 1. R -> Markdown Analysis Workflow
1. Keep analysis logic in `analysis/scripts/*.R`.
2. Execute scripts with `Rscript` from project root (or from `analysis/` with relative paths adjusted).
3. Write/update analysis summaries as markdown files in `analysis/output/results/`.
4. Save figures and tables under `analysis/output/figures/` and `analysis/output/tables/`.
5. Do not manually edit generated results when they are script outputs; regenerate them from scripts.

### 2. Running the Analysis

```bash
# run main analysis pipeline from project root
Rscript analysis/scripts/30_results_main.R

# or run stepwise
Rscript analysis/scripts/00_setup.R
Rscript analysis/scripts/20_data.R
Rscript analysis/scripts/30_results_main.R
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
