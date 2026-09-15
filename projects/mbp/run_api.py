import os
import subprocess
import sys
from pathlib import Path

from dotenv import load_dotenv


mbp_root = Path(__file__).resolve().parent
repository_root = mbp_root.parents[1]
api_root = mbp_root / "api" / "integration"

environment_file = repository_root / ".env"
load_dotenv(environment_file)

if len(sys.argv) < 2:
    raise SystemExit(
        "Usage: python run_api.py <dev|sit|uat> [robot arguments...]"
    )

environment = sys.argv[1].lower()
robot_arguments = sys.argv[2:]

supported_environments = {"dev", "sit", "uat"}

if environment not in supported_environments:
    raise ValueError(
        f"Unsupported API environment '{environment}'. "
        f"Expected one of: {sorted(supported_environments)}"
    )

required_environment_variables = [
    "MBP_API_BASIC_AUTH",
]

missing_environment_variables = [
    variable_name
    for variable_name in required_environment_variables
    if not os.getenv(variable_name)
]

if missing_environment_variables:
    missing_variables = ", ".join(missing_environment_variables)
    raise ValueError(
        f"Missing required environment variables: {missing_variables}. "
        f"Configure them in {environment_file}."
    )

variable_file = (
    api_root
    / "resources"
    / "variables"
    / f"{environment}.py"
)

tests_directory = api_root / "tests"
results_directory = api_root / "results"

if not variable_file.is_file():
    raise FileNotFoundError(
        f"API variable file does not exist: {variable_file}"
    )

if not tests_directory.is_dir():
    raise FileNotFoundError(
        f"API tests directory does not exist: {tests_directory}"
    )

results_directory.mkdir(parents=True, exist_ok=True)

command = [
    "robotcode",
    "run",
    *robot_arguments,
    "--variablefile",
    str(variable_file),
    "--outputdir",
    str(results_directory),
    str(tests_directory),
]

print(f">> API working directory: {api_root}")
print(f">> Environment file loaded: {environment_file}")
print(f">> Variable file: {variable_file}")
print(f">> Tests directory: {tests_directory}")
print(f">> Results directory: {results_directory}")

result = subprocess.run(
    command,
    cwd=api_root,
    env=os.environ.copy(),
    check=False,
)

raise SystemExit(result.returncode)