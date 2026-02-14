from __future__ import annotations

import argparse
import sys
from importlib import resources
from pathlib import Path

from .scaffold import ScaffoldConflictError, apply_actions, plan_actions
from .texst import resolve_latest_texst_version


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
    return parser


def _command_init(args: argparse.Namespace) -> int:
    target_dir = Path(args.target_dir).expanduser().resolve()
    project_name = args.project_name or target_dir.name
    texst_version = resolve_latest_texst_version()
    include_agents = not args.no_agents

    templates_dir = resources.files("blank_cli") / "templates"
    templates_path = Path(str(templates_dir))

    target_dir.mkdir(parents=True, exist_ok=True)

    try:
        actions = plan_actions(
            target_dir=target_dir,
            templates_dir=templates_path,
            project_name=project_name,
            texst_version=texst_version,
            include_agents=include_agents,
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
        texst_version=texst_version,
        include_agents=include_agents,
        dry_run=args.dry_run,
    )

    mode = "DRY RUN" if args.dry_run else "DONE"
    print(f"[{mode}] blank init -> {target_dir}")
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
