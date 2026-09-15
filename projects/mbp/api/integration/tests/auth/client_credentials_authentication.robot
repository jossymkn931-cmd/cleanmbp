*** Settings ***
Documentation    MBP OAuth2 client credentials authentication tests.

Resource         ../../resources/keywords/authentication_keywords.resource

Test Tags        api    integration    authentication

Suite Teardown   Clear MBP Access Token


*** Test Cases ***

Valid Client Credentials Return An Access Token
    [Documentation]    Verify valid client credentials produce an MBP access token.
    [Tags]    smoke    positive    regression
    Should Not Be Empty    ${TOKEN_URL}
    Should Be Equal        ${TOKEN_SCOPE}    auto
    ${result}=    Obtain A Valid MBP Access Token
    Verify Authentication Response Time    ${result}


Invalid Client Credentials Are Rejected
    [Documentation]    Verify invalid Basic Authorization credentials are rejected.
    [Tags]    negative    security    regression
    Should Not Be Empty    ${TOKEN_URL}
    ${result}=    Request MBP Access Token With Invalid Credentials
    ...    ${TOKEN_URL}
    ...    ${TOKEN_SCOPE}
    ...    ${REQUEST_TIMEOUT_SECONDS}
    ...    ${VERIFY_TLS}
    Verify Authentication Request Was Rejected    ${result}


Missing Authorization Is Rejected
    [Documentation]    Verify a token request without Authorization is rejected.
    [Tags]    negative    security    regression
    Should Not Be Empty    ${TOKEN_URL}
    ${result}=    Request MBP Access Token Without Authorization
    ...    ${TOKEN_URL}
    ...    ${TOKEN_SCOPE}
    ...    ${REQUEST_TIMEOUT_SECONDS}
    ...    ${VERIFY_TLS}
    Verify Authentication Request Was Rejected    ${result}


Unsupported Grant Type Is Rejected
    [Documentation]    Verify WSO2 rejects an unsupported OAuth grant type.
    [Tags]    negative    security    regression
    ${unsupported_grant_type}=    Set Variable    unsupported_grant
    ${result}=    Request Token Using Grant Type
    ...    ${TOKEN_URL}
    ...    ${unsupported_grant_type}
    ...    ${TOKEN_SCOPE}
    ...    ${REQUEST_TIMEOUT_SECONDS}
    ...    ${VERIFY_TLS}
    Verify Authentication Request Was Rejected    ${result}
