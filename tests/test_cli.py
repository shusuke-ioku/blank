from __future__ import annotations

import re
import stat
from pathlib import Path

from blank_cli.cli import main


def test_init_creates_scaffold(tmp_path: Path) -> None:
    target = tmp_path / "demo"

    rc = main(["init", str(target), "--project-name", "Demo Project"])

    assert rc == 0
    assert (target / "analysis/scripts/00_setup.R").exists()
    assert (target / "analysis/data").exists()
    assert not (target / "analysis/data/base").exists()
    assert not (target / "analysis/data/covariates").exists()
    assert not (target / "analysis/data/rworg").exists()
    assert not (target / "analysis/data/ocr_tables").exists()
    assert (target / "paper/paper.typ").exists()
    assert (target / "paper/aesthetics.typ").exists()
    assert (target / ".codex/project.md").exists()
    assert (target / ".codex/install_repo_skills.sh").exists()
    assert (target / ".codex/install_curated_skills.sh").exists()
    assert (target / ".codex/skills/typst-paper-sync-check/SKILL.md").exists()
    assert (target / ".codex/skills/adversarial-brainstorm-recorder/SKILL.md").exists()
    assert (target / ".codex/skills/socsci-critical-reader/SKILL.md").exists()
    assert not (target / ".codex/skills/jp-pol-sci-r-pipeline/SKILL.md").exists()
    assert (target / ".claude/settings.local.json").exists()
    assert "Demo Project" in (target / "README.md").read_text(encoding="utf-8")
    paper = (target / "paper/paper.typ").read_text(encoding="utf-8")
    assert re.search(r'@preview/texst:\d+\.\d+\.\d+', paper)
    assert "Introduction" in paper
    aesthetics = (target / "paper/aesthetics.typ").read_text(encoding="utf-8")
    assert "intentionally blank" in aesthetics
    assert "Rules For Every Agent" in (target / ".codex/project.md").read_text(encoding="utf-8")
    assert "MCP Tooling" in (target / ".codex/project.md").read_text(encoding="utf-8")
    config = (target / ".codex/config.toml").read_text(encoding="utf-8")
    assert "[mcp_servers.zotero]" in config
    assert "[mcp_servers.pdf_reader]" in config
    mode = (target / ".codex/install_repo_skills.sh").stat().st_mode
    assert mode & stat.S_IXUSR


def test_init_no_agents(tmp_path: Path) -> None:
    target = tmp_path / "demo"

    rc = main(["init", str(target), "--no-agents"])

    assert rc == 0
    assert not (target / ".codex").exists()
    assert not (target / ".claude").exists()


def test_conflict_without_force(tmp_path: Path) -> None:
    target = tmp_path / "demo"
    target.mkdir(parents=True)
    readme = target / "README.md"
    readme.write_text("custom", encoding="utf-8")

    rc = main(["init", str(target)])

    assert rc == 3
    assert readme.read_text(encoding="utf-8") == "custom"


def test_force_replaces_conflict(tmp_path: Path) -> None:
    target = tmp_path / "demo"
    target.mkdir(parents=True)
    readme = target / "README.md"
    readme.write_text("custom", encoding="utf-8")

    rc = main(["init", str(target), "--force", "--project-name", "Forced"])

    assert rc == 0
    assert "Forced" in readme.read_text(encoding="utf-8")


def test_dry_run_writes_nothing(tmp_path: Path) -> None:
    target = tmp_path / "demo"

    rc = main(["init", str(target), "--dry-run"])

    assert rc == 0
    assert not (target / "README.md").exists()
