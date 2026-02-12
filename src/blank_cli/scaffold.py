from __future__ import annotations

from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import Dict, List


@dataclass(frozen=True)
class ScaffoldAction:
    action: str
    path: Path


class ScaffoldConflictError(RuntimeError):
    pass


DIRECTORIES: List[str] = [
    "analysis/scripts",
    "analysis/data",
    "analysis/output/figures",
    "analysis/output/tables",
    "analysis/output/results",
    "paper",
    "idea",
]

TEMPLATE_FILES: List[str] = [
    "README.md.tpl",
    ".gitignore.tpl",
    ".here.tpl",
    "analysis/scripts/00_setup.R.tpl",
    "analysis/scripts/20_data.R.tpl",
    "analysis/scripts/30_results_main.R.tpl",
    "analysis/data/codebook.md.tpl",
    "paper/ref.bib.tpl",
    "analysis/output/figures/.gitkeep.tpl",
    "analysis/output/tables/.gitkeep.tpl",
    "analysis/output/results/.gitkeep.tpl",
    ".codex/project.md.tpl",
    ".codex/config.toml.tpl",
    ".codex/install_repo_skills.sh.tpl",
    ".codex/install_curated_skills.sh.tpl",
    ".codex/skills/jp-pol-sci-r-pipeline/SKILL.md.tpl",
    ".codex/skills/typst-paper-sync-check/SKILL.md.tpl",
    ".codex/skills/adversarial-brainstorm-recorder/SKILL.md.tpl",
    ".codex/skills/socsci-critical-reader/SKILL.md.tpl",
    ".claude/settings.local.json.tpl",
]

PAPER_TEMPLATE_MAP = {
    "latex": ("paper/paper_latex.typ.tpl", "paper/paper.typ"),
    "blank": ("paper/paper_blank.typ.tpl", "paper/paper.typ"),
}

PAPER_EXTRA_TEMPLATES = {
    "latex": ["paper/aesthetics.typ.tpl"],
    "blank": [],
}


def _render_template(content: str, variables: Dict[str, str]) -> str:
    rendered = content
    for key, value in variables.items():
        rendered = rendered.replace(f"{{{{{key}}}}}", value)
    return rendered


def _is_agent_file(template_path: str) -> bool:
    return template_path.startswith(".codex/") or template_path.startswith(".claude/")


def _output_path_from_template(template_path: str) -> Path:
    if not template_path.endswith(".tpl"):
        raise ValueError(f"Template path must end with .tpl: {template_path}")
    return Path(template_path[:-4])


def _effective_templates(paper_template: str) -> List[str]:
    if paper_template not in PAPER_TEMPLATE_MAP:
        raise ValueError(f"Unsupported paper template: {paper_template}")
    if paper_template not in PAPER_EXTRA_TEMPLATES:
        raise ValueError(f"Unsupported paper template: {paper_template}")
    _paper_src, paper_out = PAPER_TEMPLATE_MAP[paper_template]
    return TEMPLATE_FILES + PAPER_EXTRA_TEMPLATES[paper_template] + [f"{paper_out}.tpl"]


def plan_actions(
    target_dir: Path,
    templates_dir: Path,
    project_name: str,
    include_agents: bool,
    paper_template: str,
    force: bool,
) -> List[ScaffoldAction]:
    variables = {
        "project_name": project_name,
        "today": str(date.today()),
    }
    actions: List[ScaffoldAction] = []

    for rel_dir in DIRECTORIES:
        out_dir = target_dir / rel_dir
        if out_dir.exists():
            actions.append(ScaffoldAction("skip_dir", out_dir))
        else:
            actions.append(ScaffoldAction("create_dir", out_dir))

    effective_templates = _effective_templates(paper_template)
    paper_src, paper_out = PAPER_TEMPLATE_MAP[paper_template]
    virtual_paths = {f"{paper_out}.tpl": paper_src}

    for template_rel in effective_templates:
        source_template_rel = virtual_paths.get(template_rel, template_rel)
        if not include_agents and _is_agent_file(template_rel):
            continue

        template_file = templates_dir / source_template_rel
        if not template_file.exists():
            raise FileNotFoundError(f"Missing template file: {template_file}")

        out_file = target_dir / _output_path_from_template(template_rel)
        rendered_content = _render_template(template_file.read_text(encoding="utf-8"), variables)

        if out_file.exists():
            existing_content = out_file.read_text(encoding="utf-8")
            if existing_content == rendered_content:
                actions.append(ScaffoldAction("skip_file", out_file))
            elif force:
                actions.append(ScaffoldAction("replace_file", out_file))
            else:
                raise ScaffoldConflictError(
                    f"Refusing to overwrite existing file: {out_file}. Use --force to replace scaffold files."
                )
        else:
            actions.append(ScaffoldAction("create_file", out_file))

    return actions


def apply_actions(
    actions: List[ScaffoldAction],
    target_dir: Path,
    templates_dir: Path,
    project_name: str,
    include_agents: bool,
    paper_template: str,
    dry_run: bool,
) -> Dict[str, int]:
    variables = {
        "project_name": project_name,
        "today": str(date.today()),
    }
    counts = {
        "created_dirs": 0,
        "created_files": 0,
        "replaced_files": 0,
        "skipped": 0,
    }

    effective_templates = _effective_templates(paper_template)
    paper_src, paper_out = PAPER_TEMPLATE_MAP[paper_template]
    virtual_paths = {f"{paper_out}.tpl": paper_src}
    template_index = {}
    for template_rel in effective_templates:
        source_template_rel = virtual_paths.get(template_rel, template_rel)
        if include_agents or not _is_agent_file(template_rel):
            template_index[_output_path_from_template(template_rel)] = templates_dir / source_template_rel

    for item in actions:
        if item.action == "create_dir":
            counts["created_dirs"] += 1
            if not dry_run:
                item.path.mkdir(parents=True, exist_ok=True)
            continue

        if item.action == "skip_dir" or item.action == "skip_file":
            counts["skipped"] += 1
            continue

        output_rel = item.path.relative_to(target_dir)
        template_path = template_index.get(output_rel)
        if template_path is None:
            raise RuntimeError(f"No template found for output file {output_rel}")

        content = _render_template(template_path.read_text(encoding="utf-8"), variables)

        if item.action == "create_file":
            counts["created_files"] += 1
        elif item.action == "replace_file":
            counts["replaced_files"] += 1
        else:
            raise RuntimeError(f"Unsupported action: {item.action}")

        if not dry_run:
            item.path.parent.mkdir(parents=True, exist_ok=True)
            item.path.write_text(content, encoding="utf-8")
            if item.path.suffix == ".sh":
                item.path.chmod(0o755)

    return counts
