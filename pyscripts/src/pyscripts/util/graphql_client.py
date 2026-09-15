import json
import ssl
import urllib
from typing import Dict, Any, Optional
from urllib.request import Request, urlopen

import urllib.error



def call_graphql(
        graphql_url: Optional[str],
        query: str,
        variables: Dict[str, Any],
        api_key: Optional[str],
) -> dict[str, Any]:
    if not graphql_url:
        raise RuntimeError("TEST_ORCHESTRATOR_GRAPHQL_URL is not set. ")

    if not api_key:
        raise RuntimeError("TEST_ORCHESTRATOR_API_KEY is not set. ")

    payload = {
        "query": query,
        "variables": variables,
    }

    body = json.dumps(payload).encode("utf-8")

    request_headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-Test-Orchestrator-Api-Key": api_key
    }

    request = Request(
        graphql_url,
        data=body,
        method="POST",
        headers=request_headers,
    )

    # Equivalent to curl -k
    ssl_context = ssl._create_unverified_context()

    # formatted body for logging only
    print(f"TEST ORCHESTRATOR REQUEST:\n{json.dumps(payload)}")

    try:
        with urlopen(request, context=ssl_context, timeout=15) as response:
            response_body = response.read().decode("utf-8")

    except urllib.error.HTTPError as error:
        error_body = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(
            f"Orchestrator GraphQL endpoint failed with HTTP {error.code}: {error_body}"
        ) from error


    except Exception as exc:
        # Do not fail the Robot run because callback failed
        print(f">> Orchestrator GraphQL callback failed: {exc}")


    try:
        parsed = json.loads(response_body)

        print(f"TEST ORCHESTRATOR RESPONSE:\n{json.dumps(parsed)}")

    except (json.JSONDecodeError, UnicodeDecodeError) as error:
        raise RuntimeError("GraphQL endpoint returned invalid JSON.") from error

    if not isinstance(parsed, dict):
        raise RuntimeError("GraphQL endpoint returned invalid JSON.")

    errors = parsed.get("errors")

    if errors:
        messages = "; ".join(
            str(item.get("message", item)) if isinstance(item, dict) else str(item)
            for item in errors
        )
        raise RuntimeError(f">> Orchestrator GraphQL call returned errors: {messages}")

    return parsed
