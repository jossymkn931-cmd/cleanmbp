import subprocess
import sys
from pathlib import Path


mbp_root = Path(__file__).resolve().parent
web_root = mbp_root / "web"

environment = sys.argv[1]
robot_arguments = sys.argv[2:]

variable_file = web_root / "resources" / "variables" / f"{environment}.py"
tests_directory = web_root / "tests"

if not variable_file.is_file():
    raise FileNotFoundError(
        f"Web variable file does not exist: {variable_file}"
    )

if not tests_directory.is_dir():
    raise FileNotFoundError(
        f"Web tests directory does not exist: {tests_directory}"
    )

command = [
    "robotcode",
    "run",
    *robot_arguments,
    "--variablefile",
    str(variable_file),
    str(tests_directory),
]

print(f">> Web working directory: {web_root}")
print(f">> Variable file: {variable_file}")
print(f">> Tests directory: {tests_directory}")

result = subprocess.run(
    command,
    cwd=web_root,
    check=False,
)

raise SystemExit(result.returncode)