from __future__ import annotations

import os
from typing import Any

from pyscripts.util.graphql_client import call_graphql

orchestrator_url = os.getenv("TEST_ORCHESTRATOR_GRAPHQL_URL")
api_key = os.getenv("TEST_ORCHESTRATOR_API_KEY")

def register_monorepo_projects(inventory: dict) -> None:

    query = """
            mutation RegisterRobotFrameworkMonorepoProjects($input: RfMonorepoGqlInput!) {
              registerRfMonorepoProjects(input: $input) {
                monorepoName
                registeredProjectCount
                registeredSuiteCount
              }
            }
    """
    variables = {"input": inventory}

    call_graphql(orchestrator_url, query, variables, api_key)

def send_test_run_completed(input_body: dict[str, Any]) -> None:
    query = """
        mutation OcpRobotRunCompletedEvent($input: OcpRobotRunCompletedEventInput!) {
          sendOcpRobotRunCompletedEvent(input: $input)
        }
    """
    variables = {"input": input_body}

    call_graphql(orchestrator_url, query, variables, api_key)


def send_event(input_body: dict[str, Any]) -> None:
    query = """
        mutation RobotRunEvent($input: RobotRunEventInput!) {
          robotRunEvent(input: $input)
        }
    """
    variables = {"input": input_body}

    call_graphql(orchestrator_url, query, variables, api_key)
