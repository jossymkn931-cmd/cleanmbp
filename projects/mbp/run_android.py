import os
import subprocess
import sys
from pathlib import Path

from dotenv import load_dotenv


mbp_root = Path(__file__).resolve().parent
repository_root = mbp_root.parents[1]
android_root = mbp_root / "mobile" / "android"

environment_file = repository_root / ".env"
environment_loaded = load_dotenv(environment_file)

if len(sys.argv) < 2:
    raise SystemExit(
        "Usage: python run_android.py <dev|sit|uat> [robot arguments...]"
    )

environment = sys.argv[1].lower()
robot_arguments = sys.argv[2:]

supported_environments = {"dev", "sit", "uat"}

if environment not in supported_environments:
    raise ValueError(
        f"Unsupported Android environment '{environment}'. "
        f"Expected one of: {sorted(supported_environments)}"
    )

variable_file = (
        android_root
        / "resources"
        / "variables"
        / f"{environment}.py"
)

tests_directory = android_root / "tests"

if not environment_file.is_file():
    raise FileNotFoundError(
        f"Root environment file does not exist: {environment_file}"
    )

if not variable_file.is_file():
    raise FileNotFoundError(
        f"Android variable file does not exist: {variable_file}"
    )

if not tests_directory.is_dir():
    raise FileNotFoundError(
        f"Android tests directory does not exist: {tests_directory}"
    )

listener_requested = any(
    argument == "--listener" or argument.startswith("--listener")
    for argument in robot_arguments
)

if listener_requested:
    required_listener_variables = [
        "TEST_ORCHESTRATOR_GRAPHQL_URL",
        "TEST_ORCHESTRATOR_CALLBACK_TOKEN",
    ]

    missing_variables = [
        variable_name
        for variable_name in required_listener_variables
        if not os.getenv(variable_name)
    ]

    if missing_variables:
        raise ValueError(
            "Missing Test Orchestrator environment variables: "
            f"{', '.join(missing_variables)}. "
            f"Configure them in {environment_file}."
        )

command = [
    "robotcode",
    "run",
    *robot_arguments,
    "--variablefile",
    str(variable_file),
    str(tests_directory),
]

print(f">> Android working directory: {android_root}")
print(f">> Environment file: {environment_file}")
print(f">> Environment file loaded: {environment_loaded}")
print(f">> Variable file: {variable_file}")
print(f">> Tests directory: {tests_directory}")

result = subprocess.run(
    command,
    cwd=android_root,
    env=os.environ.copy(),
    check=False,
)

raise SystemExit(result.returncode)