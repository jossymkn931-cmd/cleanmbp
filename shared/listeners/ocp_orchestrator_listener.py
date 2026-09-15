from __future__ import annotations

import os
import time
from datetime import timedelta
from pathlib import Path
from typing import Any

from listeners.listener_util import generate_pdf_report, update_test_result_counts
from listeners.test_orchestrator_client import send_test_run_completed
from python_utils.monorepo_inventory import MonorepoInventory, register_monorepo_projects_wrapper


def _elapsed_ms(result: Any) -> int | None:
    elapsed_time = getattr(result, "elapsed_time", None)

    if isinstance(elapsed_time, timedelta):
        return int(elapsed_time.total_seconds() * 1000)

    # elapsedtime exists in Robot Framework’s older result model,
    # and it still exists as a deprecated compatibility property in newer versions
    elapsed_time = getattr(result, "elapsedtime", None)

    if isinstance(elapsed_time, int):
        return elapsed_time

    if isinstance(elapsed_time, float):
        return int(elapsed_time)

    if isinstance(elapsed_time, str) and elapsed_time.strip():
        return int(elapsed_time)

    return None



class OcpOrchestratorListener:
    ROBOT_LISTENER_API_VERSION = 3
    monorepo_inventory: MonorepoInventory

    # Called once when the listener class is created, before the execution starts.
    def __init__(self):
        # Register monorepo projects on the test orchestrator
        self.monorepo_inventory = register_monorepo_projects_wrapper()

        self.run_id = os.environ.get("RUN_ID")
        self.project = os.environ.get("PROJECT")
        self.run_command = os.environ.get("RUN_COMMAND")
        self.target_env = os.environ.get("TARGET_ENV")
        self.graphql_url = os.environ.get("TEST_ORCHESTRATOR_GRAPHQL_URL")
        self.callback_token = os.environ.get("TEST_ORCHESTRATOR_CALLBACK_TOKEN")
        self.started_at = time.time()
        self.ocp_job_name = os.environ.get("OCP_JOB_NAME")
        self.tags = os.environ.get("TAGS")
        self.ado_user_story_id = os.environ.get("ADO_USER_STORY_ID")
        self.total_tests = 0
        self.passed_tests = 0
        self.failed_tests = 0
        self.skipped_tests = 0
        self.output_xml_path = None
        self.log_html_path = None
        self.report_html_path = None


    # def start_suite(self, data, result):
    #     send_event({
    #         "eventType": "SUITE_STARTED",
    #         "runId": self.run_id,
    #         "project": self.project,
    #         "targetEnv": self.target_env,
    #         "suiteName": result.name,
    #         "longName": getattr(result, "longname", result.name),
    #     })

    # def end_suite(self, data, result):
    #     send_event({
    #         "eventType": "SUITE_ENDED",
    #         "runId": self.run_id,
    #         "project": self.project,
    #         "targetEnv": self.target_env,
    #         "suiteName": result.name,
    #         "longName": getattr(result, "longname", result.name),
    #         "status": result.status,
    #         "message": result.message,
    #         "elapsedTimeMs": _elapsed_ms(result),
    #     })

    # def start_test(self, data, result):
    #     send_event({
    #         "eventType": "TEST_STARTED",
    #         "runId": self.run_id,
    #         "project": self.project,
    #         "targetEnv": self.target_env,
    #         "testName": result.name,
    #         "longName": getattr(result, "longname", result.name),
    #         "status": "RUNNING",
    #         "tags": list(result.tags),
    #     })
    #
    def end_test(self, data, result):
        del data
        update_test_result_counts(self, result)

        # send_event({
        #     "eventType": "TEST_ENDED",
        #     "runId": self.run_id,
        #     "project": self.project,
        #     "targetEnv": self.target_env,
        #     "testName": result.name,
        #     "longName": getattr(result, "longname", result.name),
        #     "status": result.status,
        #     "message": result.message,
        #     "tags": list(result.tags),
        #     "elapsedTimeMs": _elapsed_ms(result),
        # })

    def output_file(self, path):
        # Robot supplies the actual absolute output path when it is ready.
        self.output_xml_path = Path(path) if path else None

    def log_file(self, path):
        self.log_html_path = str(path) if path else None

    def report_file(self, path):
        self.report_html_path = str(path) if path else None


    def close(self):
        completed_at = time.time()
        total_elapsed_time_ms = int((completed_at - self.started_at) * 1000)

        pdf_report_path = generate_pdf_report(self)

        send_test_run_completed({
            "runId": self.run_id,
            "monorepoName": self.monorepo_inventory.monorepoName,
            "project": self.project,
            "runCommand": self.run_command,
            "targetEnv": self.target_env,
            "message": "Robot Framework execution completed",
            "outputXmlPath": str(self.output_xml_path) if self.output_xml_path is not None else None,
            "logHtmlPath": str(self.log_html_path) if self.log_html_path is not None else None,
            "reportHtmlPath": str(self.report_html_path) if self.report_html_path is not None else None,
            "reportPdfPath": str(pdf_report_path) if pdf_report_path is not None else None,
            "ocpJobName": self.ocp_job_name,
            "totalTests": self.total_tests,
            "passedTests": self.passed_tests,
            "failedTests": self.failed_tests,
            "skippedTests": self.skipped_tests,
            "elapsedTimeMs": total_elapsed_time_ms,
            "adoUserStoryId": self.ado_user_story_id
        })

