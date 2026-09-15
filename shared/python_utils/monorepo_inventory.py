from __future__ import annotations

from dataclasses import dataclass, asdict
from pathlib import Path
import os
import json
from datetime import datetime, timezone

from listeners.test_orchestrator_client import register_monorepo_projects

import tomllib

MONOREPO_MANIFEST_FILE_NAME = "monorepo-manifest.json"

IGNORED_DIRS = {
    ".git",
    ".venv",
    "__pycache__",
    "results",
    "node_modules",
}


@dataclass(frozen=True)
class ProjectInventory:
    name: str
    suites: list[str]
    adoTestPlanIds: list[str]


@dataclass(frozen=True)
class MonorepoInventory:
    monorepoSnapshotTime: str
    monorepoName: str
    rootPath: str
    projects: list[ProjectInventory]

    def to_dict(self) -> dict:
        return asdict(self)




def register_monorepo_projects_wrapper() -> MonorepoInventory:
    try:
        inventory = _get_monorepo_inventory()

        register_monorepo_projects(inventory)

        return _from_json_dict(inventory)

    except Exception as error:
        # I would not fail the test run just because registration failed.
        # Treat this as observability/metadata registration.
        print(f"Skipping monorepo registration because discovery/registration failed: {error}")
        return _discover_monorepo_inventory()

def _discover_monorepo_inventory() -> MonorepoInventory:
    root = _discover_monorepo_root()
    projects_dir = root / "projects"

    if not projects_dir.is_dir():
        raise FileNotFoundError(f"projects directory was not found: {projects_dir}")

    projects: list[ProjectInventory] = []

    for project_dir in sorted(projects_dir.iterdir()):
        if not project_dir.is_dir():
            continue

        if project_dir.name.startswith("."):
            continue

        suites = _discover_project_suites(project_dir)
        ado_test_plan_ids = _discover_project_ado_test_plan_ids(project_dir)

        projects.append(
            ProjectInventory(
                name=project_dir.name,
                suites=suites,
                adoTestPlanIds=ado_test_plan_ids,
            )
        )


    snapshot_time = (
        datetime.now(timezone.utc)
        .replace(microsecond=0)
        .isoformat()
        .replace("+00:00", "Z")
    )

    return MonorepoInventory(
        monorepoSnapshotTime=snapshot_time,
        monorepoName=root.name,
        rootPath=str(root),
        projects=projects,
    )

def _discover_monorepo_root(start_path: Path | None = None) -> Path:
    """
    Finds the monorepo root by walking upwards until it finds:
      - pyproject.toml
      - projects/
      - shared/

    In Docker, you can avoid guessing by setting:
      ROBOT_MONOREPO_ROOT=/workspace
    """

    configured_root = os.getenv("ROBOT_MONOREPO_ROOT")
    if configured_root:
        root = Path(configured_root).resolve()
        if not root.exists():
            raise FileNotFoundError(f"ROBOT_MONOREPO_ROOT does not exist: {root}")
        return root

    current = (start_path or Path.cwd()).resolve()

    for candidate in [current, *current.parents]:
        if (
                (candidate / "pyproject.toml").exists()
                and (candidate / "projects").is_dir()
                and (candidate / "shared").is_dir()
        ):
            return candidate

    raise FileNotFoundError(
        f"Could not discover monorepo root from {current}. "
        "Set ROBOT_MONOREPO_ROOT explicitly."
    )

def _discover_project_suites(project_dir: Path) -> list[str]:
    """
    Discovers suites below a project.

    A suite directory is identified by:
      - containing a tests/ directory
      - and containing either robot.toml or pyproject.toml

    This supports nested suite paths like:
      projects/customer-portal/tq/api
    """

    suites: list[str] = []

    for current_dir, dir_names, file_names in os.walk(project_dir):
        dir_names[:] = [
            name for name in dir_names
            if name not in IGNORED_DIRS and not name.startswith(".")
        ]

        current = Path(current_dir)

        has_tests_dir = (current / "tests").is_dir()
        has_suite_config = "robot.toml" in file_names or "pyproject.toml" in file_names

        if has_tests_dir and has_suite_config:
            suite_path = current.relative_to(project_dir).as_posix()
            suites.append(suite_path)

            # Do not scan inside a discovered suite's children unless you intentionally support nested suites
            dir_names[:] = []

    return sorted(suites)

def _discover_project_ado_test_plan_ids(project_dir: Path) -> list[str]:
    """
    Reads project-level Azure DevOps test plan IDs from:

      projects/<project>/pyproject.toml

    Expected TOML:

      [tool.azure-devops]
      test-plan-ids = [12345, 67890]

    The IDs are returned as strings because they are identifiers, not values that need arithmetic
    """

    pyproject_file = project_dir / "pyproject.toml"

    if not pyproject_file.is_file():
        return []

    with pyproject_file.open("rb") as file:
        pyproject = tomllib.load(file)

    raw_test_plan_ids = (
        pyproject
        .get("tool", {})
        .get("azure-devops", {})
        .get("test-plan-ids", [])
    )

    if raw_test_plan_ids is None:
        return []

    if not isinstance(raw_test_plan_ids, list):
        raise ValueError(
            f"Invalid Azure DevOps config in {pyproject_file}. "
            "Expected [tool.azure-devops].test-plan-ids to be a list"
        )

    test_plan_ids: list[str] = []

    for raw_test_plan_id in raw_test_plan_ids:
        test_plan_id = str(raw_test_plan_id).strip()

        if not test_plan_id:
            raise ValueError(
                f"Invalid blank Azure DevOps test plan ID in {pyproject_file}"
            )

        test_plan_ids.append(test_plan_id)

    return test_plan_ids

def _get_default_monorepo_manifest_location() -> Path:
    return Path(_discover_monorepo_root() / MONOREPO_MANIFEST_FILE_NAME)

def _from_json_dict(data: dict) -> MonorepoInventory:
    return MonorepoInventory(
        monorepoSnapshotTime=data["monorepoSnapshotTime"],
        monorepoName=data["monorepoName"],
        rootPath=data["rootPath"],
        projects=[
            ProjectInventory(
                name=project["name"],
                suites=project.get("suites") or [],
                adoTestPlanIds=project.get("adoTestPlanIds") or [],
            )
            for project in data.get("projects") or []
        ],
    )

def _get_monorepo_inventory(input_path: Path | None = None) -> dict:
    json_file_path = input_path or _get_default_monorepo_manifest_location()

    return json.loads(json_file_path.read_text(encoding="utf-8"))