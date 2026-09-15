import os
import uuid
from typing import Any
import truststore
truststore.inject_into_ssl()
import requests
from robot.api.deco import keyword


_access_token: str | None = None
_token_type: str | None = None
_expires_in: int | None = None


@keyword("Request MBP Access Token")
def request_mbp_access_token(
    token_url: str,
    scope: str = "auto",
    timeout: int = 30,
    verify_tls: bool = True,
) -> dict[str, Any]:
    """Request and securely retain an MBP access token."""

    authorization = _read_basic_authorization()
    resolved_scope = _resolve_scope(scope)

    result, response_body = _send_token_request(
        token_url=token_url,
        authorization=authorization,
        grant_type="client_credentials",
        scope=resolved_scope,
        timeout=timeout,
        verify_tls=verify_tls,
    )

    if 200 <= result["status_code"] < 300:
        access_token = response_body.get("access_token")

        if not access_token:
            raise AssertionError(
                "Authentication succeeded but access_token was not returned."
            )

        _store_token_response(response_body)

    return result


@keyword("Request MBP Access Token With Invalid Credentials")
def request_mbp_access_token_with_invalid_credentials(
    token_url: str,
    scope: str = "auto",
    timeout: int = 30,
    verify_tls: bool = True,
) -> dict[str, Any]:
    """Request a token using deliberately invalid Basic credentials."""

    return _send_token_request(
        token_url=token_url,
        authorization="Basic aW52YWxpZDppbnZhbGlk",
        grant_type="client_credentials",
        scope=_resolve_scope(scope),
        timeout=timeout,
        verify_tls=verify_tls,
    )[0]


@keyword("Request MBP Access Token Without Authorization")
def request_mbp_access_token_without_authorization(
    token_url: str,
    scope: str = "auto",
    timeout: int = 30,
    verify_tls: bool = True,
) -> dict[str, Any]:
    """Request a token without an Authorization header."""

    return _send_token_request(
        token_url=token_url,
        authorization=None,
        grant_type="client_credentials",
        scope=_resolve_scope(scope),
        timeout=timeout,
        verify_tls=verify_tls,
    )[0]


@keyword("Request Token Using Grant Type")
def request_token_using_grant_type(
    token_url: str,
    grant_type: str,
    scope: str = "auto",
    timeout: int = 30,
    verify_tls: bool = True,
) -> dict[str, Any]:
    """Request a token using the supplied OAuth grant type."""

    authorization = _read_basic_authorization()

    return _send_token_request(
        token_url=token_url,
        authorization=authorization,
        grant_type=grant_type,
        scope=_resolve_scope(scope),
        timeout=timeout,
        verify_tls=verify_tls,
    )[0]


@keyword("MBP Access Token Should Be Available")
def mbp_access_token_should_be_available() -> None:
    """Verify that an access token has been obtained."""

    if not _access_token:
        raise AssertionError(
            "An MBP access token has not been obtained."
        )


@keyword("Create MBP Authorized Headers")
def create_mbp_authorized_headers() -> dict[str, str]:
    """Create headers for authenticated MBP API requests."""

    if not _access_token:
        raise AssertionError(
            "Obtain an MBP access token before creating authorized headers."
        )

    resolved_token_type = _token_type or "Bearer"

    return {
        "Authorization": f"{resolved_token_type} {_access_token}",
        "Accept": "application/json",
        "Content-Type": "application/json",
    }


@keyword("Clear MBP Access Token")
def clear_mbp_access_token() -> None:
    """Remove the access token retained in memory."""

    global _access_token
    global _token_type
    global _expires_in

    _access_token = None
    _token_type = None
    _expires_in = None


def _send_token_request(
    token_url: str,
    authorization: str | None,
    grant_type: str,
    scope: str,
    timeout: int,
    verify_tls: bool,
) -> tuple[dict[str, Any], dict[str, Any]]:
    """Send the token request and return a sanitized result."""

    headers = {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
    }

    if authorization:
        headers["Authorization"] = authorization

    form_data = {
        "grant_type": grant_type,
        "scope": scope,
    }

    response = requests.post(
        url=token_url,
        headers=headers,
        data=form_data,
        timeout=int(timeout),
        verify=_to_boolean(verify_tls),
    )

    response_body = _safe_json(response)
    sanitized_response = _sanitize_response(
        response=response,
        response_body=response_body,
    )

    return sanitized_response, response_body


def _read_basic_authorization() -> str:
    """Read the complete Basic Authorization value from the environment."""

    authorization = os.getenv("MBP_API_BASIC_AUTH", "").strip()

    if not authorization:
        raise ValueError(
            "MBP_API_BASIC_AUTH must be configured in the root .env file."
        )

    if not authorization.lower().startswith("basic "):
        raise ValueError(
            "MBP_API_BASIC_AUTH must begin with 'Basic '."
        )

    return authorization


def _resolve_scope(scope: str | None) -> str:
    """Generate a UUID when the configured scope is auto or empty."""

    if scope is None:
        return str(uuid.uuid4())

    normalized_scope = str(scope).strip()

    if not normalized_scope or normalized_scope.lower() == "auto":
        return str(uuid.uuid4())

    return normalized_scope


def _store_token_response(response_body: dict[str, Any]) -> None:
    """Store token details without returning the credential to Robot."""

    global _access_token
    global _token_type
    global _expires_in

    _access_token = str(response_body["access_token"])

    returned_token_type = response_body.get("token_type")
    _token_type = (
        str(returned_token_type)
        if returned_token_type is not None
        else "Bearer"
    )

    returned_expiry = response_body.get("expires_in")
    _expires_in = (
        int(returned_expiry)
        if returned_expiry is not None
        else None
    )


def _safe_json(response: requests.Response) -> dict[str, Any]:
    """Return a dictionary for both JSON and non-JSON responses."""

    try:
        response_body = response.json()
    except ValueError:
        return {
            "message": response.text[:500] if response.text else "",
        }

    if isinstance(response_body, dict):
        return response_body

    return {
        "data": response_body,
    }


def _sanitize_response(
    response: requests.Response,
    response_body: dict[str, Any],
) -> dict[str, Any]:
    """Remove tokens and credentials before returning data to Robot."""

    sensitive_fields = {
        "access_token",
        "refresh_token",
        "id_token",
        "client_secret",
        "authorization",
    }

    sanitized_body = {
        key: value
        for key, value in response_body.items()
        if key.lower() not in sensitive_fields
    }

    return {
        "status_code": response.status_code,
        "reason": response.reason,
        "elapsed_ms": round(
            response.elapsed.total_seconds() * 1000
        ),
        "content_type": response.headers.get(
            "Content-Type",
            "",
        ),
        "has_access_token": bool(
            response_body.get("access_token")
        ),
        "token_type": response_body.get("token_type"),
        "expires_in": response_body.get("expires_in"),
        "body": sanitized_body,
    }


def _to_boolean(value: Any) -> bool:
    """Convert Robot Framework values into Python booleans."""

    if isinstance(value, bool):
        return value

    return str(value).strip().lower() in {
        "true",
        "yes",
        "1",
        "on",
    }