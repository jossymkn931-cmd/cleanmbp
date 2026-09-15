from __future__ import annotations

import ssl

from listeners.listener_util import generate_pdf_report, update_test_result_counts
from pyscripts.util.graphql_client import call_graphql
from python_utils.monorepo_inventory import register_monorepo_projects_wrapper

"""Robot Framework listener for test runs started from a developer machine.

The listener receives the project, run command, optional ADO test-plan IDs,
and an optional ADO user-story ID as listener arguments. It generates a sortable 13-character run id, sends the
dedicated GraphQL ``ideRobotRunCompleted`` event, and uploads Robot's result
artifacts only after the mutation confirms that the run was registered.

Expected local command shape::

    uv run python -m pyscripts.runner.run ess api-template-service \
        --listener "listeners.ide_orchestrator_listener.\
IdeOrchestratorGraphQLListener:project=ess:run_command=api-template-service:\
ado_test_plan_ids=123,456:ado_user_story_id=321089" [robot options]

Required environment variables::

    TEST_ORCHESTRATOR_GRAPHQL_URL
    TEST_ORCHESTRATOR_CALLBACK_TOKEN

The artifact upload endpoint defaults to the following URL, derived from the
GraphQL URL::

    POST <orchestrator-base>/reports/upload/{runId}

Set ``TEST_ORCHESTRATOR_ARTIFACT_UPLOAD_URL`` only when the endpoint is routed
elsewhere. Its value may be the ``.../reports/upload`` base URL or contain a
``{run_id}`` placeholder.
"""

import json
import mimetypes
import os
import secrets
import sys
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterable, Mapping, Optional, Sequence
from urllib.error import HTTPError
from urllib.parse import quote, urlsplit, urlunsplit
from urllib.request import Request, urlopen



_CROCKFORD_BASE32 = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"
_CALLBACK_HEADER = "X-Test-Orchestrator-Api-Key"


@dataclass(frozen=True)
class _MultipartPart:
    header: bytes
    path: Path


def _new_tsid_like() -> str:
    """Return a sortable 13-character identifier suitable for a run id.

    The upper bits contain the Unix time in milliseconds and the lower 20 bits
    are random. This is TSID-like rather than a dependency on a TSID package.
    """

    value = (int(time.time() * 1_000) << 20) | secrets.randbits(20)
    characters = ["0"] * 13

    for index in range(12, -1, -1):
        characters[index] = _CROCKFORD_BASE32[value & 31]
        value >>= 5

    return "".join(characters)


def _extract_include_tags(arguments: Sequence[str]) -> list[str]:
    tags: list[str] = []
    index = 0

    while index < len(arguments):
        argument = arguments[index]

        if argument in {"--include", "-i"}:
            if index + 1 < len(arguments):
                tags.append(arguments[index + 1])
                index += 2
                continue
        elif argument.startswith("--include="):
            tags.append(argument.partition("=")[2])
        elif argument.startswith("-i") and len(argument) > 2:
            tags.append(argument[2:])

        index += 1

    return tags


def _parse_ado_test_plan_ids(value: Optional[str]) -> list[str]:
    if not value:
        return []

    return [
        test_plan_id.strip()
        for test_plan_id in value.split(",")
        if test_plan_id.strip()
    ]



def send_ide_test_run_completed(
        input_body: dict[str, Any],
        *,
        graphql_url: str,
        callback_token: str,
) -> None:
    """Create or update a locally executed Robot Framework test run.

    The IDE mutation must not invoke OCP job lookup, pod lookup, or pod file
    copy services. It owns creation of the IDE-triggered ``test_run`` record
    because no record is created before a developer starts a local execution.
    The resolver can still classify the run as ``MANUAL_RUN`` because that
    source also covers manual executions initiated through Postman.
    """

    query = """
        mutation SendIdeRobotRunCompletedEvent(
          $input: IdeRobotRunCompletedEventInput!
        ) {
          sendIdeRobotRunCompletedEvent(input: $input)
        }
    """
    variables = {"input": input_body}
    response = call_graphql(graphql_url, query, variables, callback_token)
    data = response.get("data")

    if not isinstance(data, dict) or data.get("sendIdeRobotRunCompletedEvent") is not True:
        raise RuntimeError("The orchestrator did not confirm that the IDE run was registered.")



def _artifact_upload_url(graphql_url: str, run_id: str) -> str:
    configured_url = os.environ.get("TEST_ORCHESTRATOR_ARTIFACT_UPLOAD_URL")

    if configured_url:
        if "{run_id}" in configured_url:
            return configured_url.format(run_id=quote(run_id, safe=""))
        return f"{configured_url.rstrip('/')}/{quote(run_id, safe='')}"

    parsed = urlsplit(graphql_url)
    base_path = parsed.path.rstrip("/")

    if base_path.endswith("/graphql"):
        base_path = base_path[: -len("/graphql")]

    upload_path = f"{base_path}/reports/upload/{quote(run_id, safe='')}"
    return urlunsplit((parsed.scheme, parsed.netloc, upload_path, "", ""))


def _existing_artifacts(
        artifact_paths: Mapping[str, Optional[Path]],
) -> dict[str, Path]:
    artifacts: dict[str, Path] = {}

    for field_name, path in artifact_paths.items():
        if path is not None and path.is_file():
            artifacts[field_name] = path

    return artifacts


def _safe_filename(path: Path) -> str:
    return path.name.replace('"', "").replace("\r", "").replace("\n", "")


def _multipart_parts(
        boundary: str,
        artifacts: Mapping[str, Path],
) -> list[_MultipartPart]:
    parts: list[_MultipartPart] = []

    for field_name, path in artifacts.items():
        content_type = mimetypes.guess_type(path.name)[0] or "application/octet-stream"
        header = (
            f"--{boundary}\r\n"
            f'Content-Disposition: form-data; name="{field_name}"; '
            f'filename="{_safe_filename(path)}"\r\n'
            f"Content-Type: {content_type}\r\n\r\n"
        ).encode("utf-8")
        parts.append(_MultipartPart(header=header, path=path))

    return parts


def _multipart_length(parts: Sequence[_MultipartPart], closing: bytes) -> int:
    return sum(
        len(part.header) + part.path.stat().st_size + len(b"\r\n")
        for part in parts
    ) + len(closing)


def _multipart_body(
        parts: Sequence[_MultipartPart],
        closing: bytes,
) -> Iterable[bytes]:
    for part in parts:
        yield part.header

        with part.path.open("rb") as file_handle:
            while chunk := file_handle.read(64 * 1024):
                yield chunk

        yield b"\r\n"

    yield closing


def upload_test_run_artifacts(
        *,
        graphql_url: str,
        callback_token: str,
        run_id: str,
        artifact_paths: Mapping[str, Optional[Path]],
) -> dict[str, Any]:
    """Upload reports and attach them to an existing IDE-triggered test run.

    ``ideRobotRunCompleted`` must be called before this function so the
    endpoint can find the ``test_run`` by ``run_id``. The endpoint stores the
    files and updates the run's final report URL columns directly.
    """

    artifacts = _existing_artifacts(artifact_paths)

    if not artifacts:
        return {}

    upload_url = _artifact_upload_url(graphql_url, run_id)
    boundary = f"----robot-run-{secrets.token_hex(16)}"
    parts = _multipart_parts(boundary, artifacts)
    closing = f"--{boundary}--\r\n".encode("ascii")
    headers = {
        _CALLBACK_HEADER: callback_token,
        "Accept": "application/json",
        "Content-Type": f"multipart/form-data; boundary={boundary}",
        "Content-Length": str(_multipart_length(parts, closing)),
    }

    request = Request(
        upload_url,
        data=_multipart_body(parts, closing),
        headers=headers,
        method="POST",
    )

    print(f"\nUPLOADING REPORT FILES:\n")

    # Equivalent to curl -k
    ssl_context = ssl._create_unverified_context()

    try:
        with urlopen(request, context=ssl_context, timeout=120) as response:
            response_body = response.read()
    except HTTPError as error:
        response_body = error.read(2_000).decode("utf-8", errors="replace")
        raise RuntimeError(
            f"Artifact upload returned HTTP {error.code}: {response_body}"
        ) from error

    if not response_body:
        return {}

    body = json.loads(response_body)

    print(f"REPORT UPLOAD RESPONSE:\n{json.dumps(body)}")

    if not isinstance(body, dict):
        raise RuntimeError("Artifact upload endpoint returned invalid JSON.")

    return body


class IdeOrchestratorListener:
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(
            self,
            project: str,
            run_command: str,
            tags: Optional[str] = None,
            ado_test_plan_ids: Optional[str] = None,
            ado_user_story_id: Optional[str] = None,
    ) -> None:
        project = project.strip()
        run_command = run_command.strip()

        if not project or not run_command:
            raise ValueError(
                "project and run_command listener arguments must be provided."
            )

        self.graphql_url = os.environ.get("TEST_ORCHESTRATOR_GRAPHQL_URL")
        self.callback_token = os.environ.get("TEST_ORCHESTRATOR_CALLBACK_TOKEN")

        if not self.graphql_url or not self.callback_token:
            raise ValueError(
                "TEST_ORCHESTRATOR_GRAPHQL_URL and "
                "TEST_ORCHESTRATOR_CALLBACK_TOKEN must be set."
            )

        self.monorepo_inventory = register_monorepo_projects_wrapper()
        self.run_id = _new_tsid_like()
        self.project = project
        self.run_command = run_command
        self.tags = (
            tags.strip()
            if tags is not None
            else ",".join(_extract_include_tags(sys.argv[1:]))
        )
        self.ado_test_plan_ids = _parse_ado_test_plan_ids(ado_test_plan_ids)
        self.ado_user_story_id = (ado_user_story_id or "").strip() or None
        self.started_at = time.time()

        self.total_tests = 0
        self.passed_tests = 0
        self.failed_tests = 0
        self.skipped_tests = 0

        self.output_xml_path: Optional[Path] = None
        self.log_html_path: Optional[Path] = None
        self.report_html_path: Optional[Path] = None

        print(f"IDE test run id: {self.run_id}")

    def end_test(self, data: Any, result: Any) -> None:
        del data

        update_test_result_counts(self, result)


    def output_file(self, path: Optional[str]) -> None:
        self.output_xml_path = Path(path) if path else None

    def log_file(self, path: Optional[str]) -> None:
        self.log_html_path = Path(path) if path else None

    def report_file(self, path: Optional[str]) -> None:
        self.report_html_path = Path(path) if path else None


    def close(self) -> None:
        total_elapsed_time_ms = int((time.time() - self.started_at) * 1_000)
        pdf_report_path = generate_pdf_report(self)

        try:
            send_ide_test_run_completed(
                {
                    "runId": self.run_id,
                    "monorepoName": self.monorepo_inventory.monorepoName,
                    "project": self.project,
                    "runCommand": self.run_command,
                    "targetEnv": None,
                    "tags": self.tags,
                    "adoTestPlanIds": self.ado_test_plan_ids,
                    "adoUserStoryId": self.ado_user_story_id,
                    "message": "Robot Framework IDE execution completed",
                    # These are paths on the developer's machine. The IDE
                    # resolver may retain them as metadata, but must never use
                    # them for an OCP pod copy operation.
                    "outputXmlPath": (
                        str(self.output_xml_path)
                        if self.output_xml_path is not None
                        else None
                    ),
                    "logHtmlPath": (
                        str(self.log_html_path)
                        if self.log_html_path is not None
                        else None
                    ),
                    "reportHtmlPath": (
                        str(self.report_html_path)
                        if self.report_html_path is not None
                        else None
                    ),
                    "reportPdfPath": (
                        str(pdf_report_path) if pdf_report_path is not None else None
                    ),
                    "totalTests": self.total_tests,
                    "passedTests": self.passed_tests,
                    "failedTests": self.failed_tests,
                    "skippedTests": self.skipped_tests,
                    "elapsedTimeMs": total_elapsed_time_ms,
                },
                graphql_url=self.graphql_url,
                callback_token=self.callback_token,
            )
        except Exception as error:
            # Do not upload artifacts when the IDE test_run was not created.
            print(
                f"Could not register completed IDE run {self.run_id} with "
                f"the test orchestrator: {error}",
                file=sys.stderr,
            )
            return

        try:
            upload_test_run_artifacts(
                graphql_url=self.graphql_url,
                callback_token=self.callback_token,
                run_id=self.run_id,
                artifact_paths={
                    "outputXml": self.output_xml_path,
                    "logHtml": self.log_html_path,
                    "reportHtml": self.report_html_path,
                    "reportPdf": pdf_report_path,
                },
            )
        except Exception as error:
            print(
                f"IDE run {self.run_id} was recorded, but its report files "
                f"could not be uploaded: {error}",
                file=sys.stderr,
            )
