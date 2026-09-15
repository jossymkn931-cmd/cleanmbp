*** Settings ***
Documentation    Business keywords for MBP API authentication.

Library          Collections
Library          ../src/authentication_client.py


*** Keywords ***

Obtain A Valid MBP Access Token
    [Documentation]    Obtain and retain a valid MBP bearer access token.

    ${result}=    Request MBP Access Token
    ...    ${TOKEN_URL}
    ...    ${TOKEN_SCOPE}
    ...    ${REQUEST_TIMEOUT_SECONDS}
    ...    ${VERIFY_TLS}

    Verify Successful Token Response    ${result}
    MBP Access Token Should Be Available

    RETURN    ${result}


Verify Successful Token Response
    [Documentation]    Validate the sanitized successful authentication response.
    [Arguments]    ${result}

    Should Be Equal As Integers
    ...    ${result}[status_code]
    ...    200
    ...    Expected authentication status 200 but received ${result}[status_code].

    Should Be True
    ...    ${result}[has_access_token]
    ...    Authentication response did not contain an access token.

    Should Contain
    ...    ${result}[content_type]
    ...    application/json
    ...    Expected JSON content type but received ${result}[content_type].

    Should Be Equal As Strings
    ...    ${result}[token_type]
    ...    Bearer
    ...    Expected token type Bearer but received ${result}[token_type].

    Should Be True
    ...    ${result}[expires_in] > 0
    ...    Token expiry must be greater than zero.


Verify Authentication Response Time
    [Documentation]    Verify authentication completed within the configured limit.
    [Arguments]    ${result}

    Should Be True
    ...    ${result}[elapsed_ms] <= ${AUTH_RESPONSE_TIME_LIMIT_MS}
    ...    Authentication took ${result}[elapsed_ms] ms; expected no more than ${AUTH_RESPONSE_TIME_LIMIT_MS} ms.


Verify Authentication Request Was Rejected
    [Documentation]    Verify an invalid authentication request was rejected.
    [Arguments]    ${result}

    Should Be True
    ...    ${result}[status_code] in [400, 401, 403]
    ...    Expected authentication rejection but received ${result}[status_code].

    Should Not Be True
...    ${result}[has_access_token]
...    Rejected authentication must not return an access token.


Verify Authentication Error Response
    [Documentation]    Verify that a rejected authentication request returns an error response.
    [Arguments]    ${result}

    Verify Authentication Request Was Rejected    ${result}

    Should Not Be Empty
    ...    ${result}[content_type]
    ...    Authentication error response did not contain a content type.