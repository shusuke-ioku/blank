from __future__ import annotations

import argparse
import sys
from importlib import resources
from pathlib import Path

from .scaffold import ScaffoldConflictError, apply_actions, plan_actions


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(prog="blank", description="Scaffold research projects")
    subparsers = parser.add_subparsers(dest="command", required=True)

    init_parser = subparsers.add_parser("init", help="Initialize a research project scaffold")
    init_parser.add_argument("target_dir", nargs="?", default=".", help="Target directory (default: current directory)")
    init_parser.add_argument(
        "--project-name",
        help="Project name used in generated template files (default: target directory name)",
    )
    init_parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite scaffold files when they already exist and differ",
    )
    init_parser.add_argument("--dry-run", action="store_true", help="Show planned actions without writing files")
    init_parser.add_argument(
        "--no-agents",
        action="store_true",
        help="Skip generating .codex/ and .claude/ files",
    )
    init_parser.add_argument(
        "--paper-template",
        choices=["latex", "blank"],
        help="Paper template style for paper/paper.typ (latex generates TeXst-style files)",
    )

    return parser


def _prompt_paper_template() -> str:
    print("Choose paper template for paper/paper.typ:")
    print("1) latex (TeXst-style layout + aesthetics.typ) [recommended]")
    print("2) blank (empty starter file)")
    while True:
        choice = input("Enter 1 or 2 [1]: ").strip()
        if choice in ("", "1"):
            return "latex"
        if choice == "2":
            return "blank"
        print("Invalid choice. Please enter 1 or 2.")


def _command_init(args: argparse.Namespace) -> int:
    target_dir = Path(args.target_dir).expanduser().resolve()
    project_name = args.project_name or target_dir.name
    include_agents = not args.no_agents
    paper_template = args.paper_template
    if paper_template is None:
        if sys.stdin.isatty():
            paper_template = _prompt_paper_template()
        else:
            paper_template = "latex"

    templates_dir = resources.files("blank_cli") / "templates"
    templates_path = Path(str(templates_dir))

    target_dir.mkdir(parents=True, exist_ok=True)

    try:
        actions = plan_actions(
            target_dir=target_dir,
            templates_dir=templates_path,
            project_name=project_name,
            include_agents=include_agents,
            paper_template=paper_template,
            force=args.force,
        )
    except ScaffoldConflictError as exc:
        print(str(exc), file=sys.stderr)
        return 3

    counts = apply_actions(
        actions=actions,
        target_dir=target_dir,
        templates_dir=templates_path,
        project_name=project_name,
        include_agents=include_agents,
        paper_template=paper_template,
        dry_run=args.dry_run,
    )

    mode = "DRY RUN" if args.dry_run else "DONE"
    print(f"[{mode}] blank init -> {target_dir}")
    print(f"paper_template={paper_template}")
    print(
        f"created_dirs={counts['created_dirs']} created_files={counts['created_files']} "
        f"replaced_files={counts['replaced_files']} skipped={counts['skipped']}"
    )

    return 0


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)

    if args.command == "init":
        return _command_init(args)

    parser.print_usage()
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
