from __future__ import annotations

import glob
import os
import shlex
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path

try:
    import tomllib  # Python 3.11+
except ModuleNotFoundError:  # pragma: no cover
    print(
        "This runner needs Python 3.11+ for tomllib. "
        "If you must use Python 3.10, install 'tomli' and switch the import."
    )
    raise


@dataclass
class ProjectInfo:
    name: str
    root: Path
    commands: dict[str, list[str]]


def load_toml(path: Path) -> dict:
    with path.open("rb") as f:
        return tomllib.load(f)


def normalize_command(value: object) -> list[str]:
    """
    Allow either:
      cmd = ["robot", "tests"]
      cmd = ["robotcode", "run", "-p", "sit"]
    or:
      cmd = "robot tests"
      cmd = "robotcode run -p sit"
    Arrays are preferred because quoting is safer and clearer.
    """
    if isinstance(value, list) and all(isinstance(v, str) for v in value):
        return list(value)

    if isinstance(value, str):
        return shlex.split(value, posix=(os.name != "nt"))

    raise ValueError("Command must be either a list of strings or a string.")


def find_workspace_root(start: Path) -> Path:
    """
    Walk upwards until we find a pyproject.toml with [tool.uv.workspace].
    """
    for candidate in [start, *start.parents]:
        pyproject = candidate / "pyproject.toml"
        if not pyproject.exists():
            continue

        data = load_toml(pyproject)
        if (
            isinstance(data.get("tool"), dict)
            and isinstance(data["tool"].get("uv"), dict)
            and isinstance(data["tool"]["uv"].get("workspace"), dict)
        ):
            return candidate

    raise FileNotFoundError(
        "Could not find a workspace root with [tool.uv.workspace] in pyproject.toml."
    )


def discover_projects(workspace_root: Path) -> dict[str, ProjectInfo]:
    root_pyproject = workspace_root / "pyproject.toml"
    root_data = load_toml(root_pyproject)

    members = (
        root_data.get("tool", {})
        .get("uv", {})
        .get("workspace", {})
        .get("members", [])
    )

    if not isinstance(members, list) or not members:
        raise ValueError(
            "Workspace root pyproject.toml must define [tool.uv.workspace].members."
        )

    projects: dict[str, ProjectInfo] = {}

    for pattern in members:
        if not isinstance(pattern, str):
            continue

        abs_pattern = str(workspace_root / pattern)
        for member_path_str in glob.glob(abs_pattern):
            member_root = Path(member_path_str)
            pyproject = member_root / "pyproject.toml"
            if not pyproject.exists():
                continue

            data = load_toml(pyproject)
            project_name = data.get("project", {}).get("name")
            if not isinstance(project_name, str) or not project_name.strip():
                continue

            raw_commands = (
                data.get("tool", {})
                .get("monorepo", {})
                .get("commands", {})
            )

            commands: dict[str, list[str]] = {}
            if isinstance(raw_commands, dict):
                for key, value in raw_commands.items():
                    if isinstance(key, str):
                        commands[key] = normalize_command(value)

            projects[project_name] = ProjectInfo(
                name=project_name,
                root=member_root,
                commands=commands,
            )

    if not projects:
        raise ValueError("No workspace projects with [project].name were found.")

    return projects


def print_help(projects: dict[str, ProjectInfo]) -> None:
    print("Usage:")
    print("  uv run python scripts/run.py <package> <command> [extra args...]")
    print("  uv run python scripts/run.py <package> -- <raw command...>")
    print()
    print("Examples:")
    # in case the folder is not declared, the folder(s) declared in the command is used
    print("  uv run python scripts/run.py api sit")
    # allows you to specify extra Robot Framework/RobotCode arguments after the command
    print("  uv run python scripts/run.py api sit --include regression --outputdir results")
    print("  uv run python scripts/run.py api -- robot api/internal-portal-service --outputdir results")
    print("  uv run python scripts/run.py api -- robotcode run -p sit tests")
    print()
    print("Available packages and commands:")
    for project_name in sorted(projects):
        print(f"  {project_name}")
        commands = projects[project_name].commands
        if commands:
            for command_name, command in sorted(commands.items()):
                print(f"    - {command_name}: {' '.join(command)}")
        else:
            print("    (no [tool.monorepo.commands] defined)")


def find_executable(name: str) -> str:
    executable = shutil.which(cmd=name)
    if executable:
        return executable

    raise FileNotFoundError(
        f"Could not find '{name}' on PATH. Run this script via 'uv run python scripts/run.py ...' "
        f"or activate the environment that contains {name}."
    )


def build_env(workspace_root: Path) -> dict[str, str]:
    env = os.environ.copy()

    libs_dir = workspace_root / "shared"
    if libs_dir.exists():
        existing = env.get("PYTHONPATH", "")
        env["PYTHONPATH"] = (
            str(libs_dir) if not existing else f"{libs_dir}{os.pathsep}{existing}"
        )

    return env


def run_project_command(
    workspace_root: Path,
    project: ProjectInfo,
    command: list[str],
) -> int:
    env = build_env(workspace_root)

    if not command:
        print("No command to run.")
        return 2

    executable = find_executable(command[0])
    cmd = [executable, *command[1:]]

    print(f">> cwd={project.root}")
    print(">>", " ".join(shlex.quote(part) for part in cmd))

    rc = subprocess.call(cmd, cwd=project.root, env=env)

    # Robot Framework returns the number of tests failed as the return code (up to 249, and 250 for any number > 249)
    # We want it to return a successful result code so that when tests are running on OCP, the pod can handle
    # failed tests as a successful OCP job. Let RF return a non-zero for technical errors only
    # 1-249:Returned number of tests failed.
    # 250:  250 or more failures
    # 251:  Help or version information printed
    # 252:  Invalid data or command line option
    # 253:  Execution stopped by user
    # 255:  Unexpected internal error
    if 1 <= rc <= 250:
        print(
            f">> Robot tests completed with failures. "
            f"Original Robot exit code: {rc}. "
            f"Exiting container with 0 so the Kubernetes Job is treated as successful."
        )
        return 0

    return rc


def merge_command_args(base_command: list[str], extra_args: list[str]) -> list[str]:
    """
    Merge command-line arguments with the command configured in pyproject.toml.

    Robot Framework requires options to appear before the test data paths. For
    example, this is valid:

      robot --outputdir results api/internal-portal-service

    But this is not valid:

      robot api/internal-portal-service --outputdir results

    RobotCode was more forgiving because `robotcode run` could interpret/reorder
    arguments internally. Native `robot` does not do that, so for native Robot
    Framework commands, extra arguments are inserted immediately after `robot`
    and before the command configured in pyproject.toml.

    For non-Robot commands, arguments are appended normally.
    """
    if not extra_args:
        return base_command

    if base_command and base_command[0] == "robot":
        return [base_command[0], *extra_args, *base_command[1:]]

    if len(base_command) >= 2 and base_command[0] == "robotcode" and base_command[1] == "run":
        return [base_command[0], base_command[1], *extra_args, *base_command[2:]]

    return [*base_command, *extra_args]


def main() -> int:
    script_dir = Path(__file__).resolve().parent
    workspace_root = find_workspace_root(script_dir)
    projects = discover_projects(workspace_root)

    if len(sys.argv) < 2 or sys.argv[1] in {"-h", "--help"}:
        print_help(projects)
        return 0

    package = sys.argv[1]
    project = projects.get(package)
    if project is None:
        print(f"Unknown package: {package}")
        print()
        print_help(projects)
        return 2

    if len(sys.argv) < 3:
        print(f"No command specified for package: {package}")
        print()
        print_help(projects)
        return 2

    # Raw passthrough mode:
    # uv run python scripts/run.py api -- robot api/internal-portal-service --outputdir results
    # uv run python scripts/run.py api -- robotcode run -p sit tests
    if sys.argv[2] == "--":
        raw = sys.argv[3:]
        if not raw:
            print("Raw mode requires a command after '--'.")
            return 2
        return run_project_command(workspace_root, project, raw)

    # Named command mode:
    # uv run python scripts/run.py api sit --include smoke --outputdir results
    command_name = sys.argv[2]
    base_command = project.commands.get(command_name)
    if base_command is None:
        print(f"Unknown command '{command_name}' for package '{package}'.")
        available = ", ".join(sorted(project.commands)) or "(none)"
        print(f"Available commands: {available}")
        return 2

    extra_args = sys.argv[3:]

    command = merge_command_args(base_command, extra_args)
    return run_project_command(workspace_root, project, command)


if __name__ == "__main__":
    raise SystemExit(main())
