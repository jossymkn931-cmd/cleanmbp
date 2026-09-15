from __future__ import annotations

import shutil
import sys
from pathlib import Path

try:
    import tomllib  # Python 3.11+
except ModuleNotFoundError:  # pragma: no cover
    print("This script requires Python 3.11+ (tomllib not available).", file=sys.stderr)
    raise SystemExit(1)


HELP_TEXT = """
clean_results.py

What it does
------------
Scans for robot.toml files under the given root directory, reads every configured
'output-dir', and deletes those directories relative to the folder containing
each robot.toml file.

Safety rules
------------
- Only deletes directories that are under the same project folder as the robot.toml
- Skips unsafe paths like '.', './', and '/'
- Skips paths that do not exist
- Avoids deleting the same target twice

Usage
-----
uv run python clean_results.py [ROOT_PATH]
uv run python clean_results.py -h
uv run python clean_results.py --help

Arguments
---------
ROOT_PATH
    Optional root directory to scan.
    If omitted, the current working directory is used.

Command template
----------------
uv run python clean_results.py [optional-root-path]

Examples
--------
1. Scan from the monorepo root:
   uv run python python_utils/clean_results.py

2. Scan only one project subtree:
   uv run python python_utils/clean_results.py projects/ibank/api

3. Show this help:
   uv run python python_utils/clean_results.py --help
""".strip()


def print_help() -> None:
    print(HELP_TEXT)


def extract_output_dirs(data: object) -> set[str]:
    """
    Recursively collect every 'output-dir' string from a parsed TOML structure.
    This covers:
      - top-level output-dir
      - profile-specific output-dir
      - nested tables that may also define output-dir
    """
    found: set[str] = set()

    def walk(node: object) -> None:
        if isinstance(node, dict):
            for key, value in node.items():
                if key == "output-dir" and isinstance(value, str) and value.strip():
                    found.add(value.strip())
                else:
                    walk(value)
        elif isinstance(node, list):
            for item in node:
                walk(item)

    walk(data)
    return found


def should_skip(path_str: str) -> bool:
    """
    Skip obviously unsafe targets.
    """
    normalized = path_str.strip().replace("\\", "/")
    if not normalized:
        return True
    if normalized in {".", "./", "/"}:
        return True
    return False


def remove_dir(path: Path) -> bool:
    if path.exists() and path.is_dir():
        print(f"Removing {path}")
        shutil.rmtree(path, ignore_errors=False)
        return True

    print(f"Skipping {path} (not found)")
    return False


def parse_root_arg(argv: list[str]) -> Path:
    if len(argv) > 2:
        print("Too many arguments.\n", file=sys.stderr)
        print_help()
        raise SystemExit(2)

    if len(argv) == 2:
        arg = argv[1].strip()
        if arg in {"-h", "--help"}:
            print_help()
            raise SystemExit(0)
        return Path(arg).resolve()

    return Path.cwd()


def main() -> int:
    root = parse_root_arg(sys.argv)

    robot_tomls = list(root.rglob("robot.toml"))
    if not robot_tomls:
        print(f"No robot.toml files found under {root}")
        return 0

    removed_any = False
    seen_targets: set[Path] = set()

    for robot_toml in robot_tomls:
        try:
            with robot_toml.open("rb") as f:
                data = tomllib.load(f)
        except Exception as exc:
            print(f"Failed to parse {robot_toml}: {exc}", file=sys.stderr)
            continue

        output_dirs = extract_output_dirs(data)
        if not output_dirs:
            print(f"No output-dir found in {robot_toml}")
            continue

        project_dir = robot_toml.parent
        project_dir_resolved = project_dir.resolve()

        for output_dir in sorted(output_dirs):
            if should_skip(output_dir):
                print(f"Skipping unsafe output-dir '{output_dir}' in {robot_toml}", file=sys.stderr)
                continue

            target = (project_dir / output_dir).resolve()

            # Extra safety: only delete paths under the project directory
            try:
                target.relative_to(project_dir_resolved)
            except ValueError:
                print(
                    f"Skipping output-dir outside project root: '{output_dir}' in {robot_toml}",
                    file=sys.stderr,
                )
                continue

            if target in seen_targets:
                continue
            seen_targets.add(target)

            if remove_dir(target):
                removed_any = True

    if not removed_any:
        print("No configured output directories were removed.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())